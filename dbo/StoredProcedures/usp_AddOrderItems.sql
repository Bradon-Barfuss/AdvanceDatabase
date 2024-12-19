
CREATE PROCEDURE dbo.usp_AddOrderItems --- usp: user stored procedure
@productName NVARCHAR(255)
, @vendorName NVARCHAR(50)
, @quantity NVARCHAR(255)
, @customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)


AS
BEGIN

	DECLARE @availableQuantity INT;
	DECLARE @sdvendor_id INT;
	DECLARE @sdproduct_id INT;

	SET @sdVendor_id = ([dbo].udf_getvendorID (@vendorName));
	SET @sdProduct_id = ([dbo].udf_getProductId (@productname));

	select @availablequantity = quantityonhand
	from vendorproduct
	where sdvendor_id = @sdvendor_id
	and sdproduct_id = @sdproduct_id
BEGIN TRY
if(@availableQuantity - (SELECT CONVERT(INT, @quantity))) < 0
RAISERROR ('The vendor does not have enought of this product in stock to complete this order. ' , 16,1); -- 16 is error message 


INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) 
VALUES (
	[dbo].udf_getOrderTableID (@customerEmailAddress, @orderDateTime)
	, [dbo].udf_getProductID (@productName)
	, [dbo].udf_getVendorID (@vendorName)
	, (SELECT Convert (int, @quantity))
	); 

	UPDATE VendorProduct
	set quantityOnHand = quantityOnHand - (select convert(int, @quantity))
	where sdvendor_id = @sdvendor_id
	and sdproduct_id = @sdproduct_id

	END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO OrderItems failed for: 
productName: ' + @productName
+ ', vendorName: ' + @vendorName
+ ', quantity: ' + @quantity
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

