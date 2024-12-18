
CREATE PROCEDURE [dbo].usp_calculateSubtotal 
@customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)

AS BEGIN
BEGIN TRY

UPDATE OrderTable
Set subTotal = orderItem.total
from OrderTable
INNER JOIN
	(
		SELECT sdOrderTable_id, SUM(quantity * VendorProductPrice) AS total
		from orderItem oi
		inner join vendorProduct vp
		on oi.sdvendor_id= vp.sdvendor_id
		and oi.sdproduct_id = vp.sdproduct_id
		WHERE sdOrderTable_id = ([dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime))
		GROUP BY sdOrderTable_id
	) OrderItem
	ON ordertable.sdOrderTable_id = orderItem.sdOrderTable_id
	END TRY

BEGIN CATCH
PRINT 'The Get Order Subtotal Procedure failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

