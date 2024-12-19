
CREATE PROCEDURE dbo.usp_AddOrder --- usp: user stored procedure

@customerEmailAddress NVARCHAR(255) --the sdCustomerId Alternate key 
, @orderDateTime NVARCHAR(50)

AS
BEGIN

BEGIN TRY

INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount, shippingCost, orderTotal) 
VALUES (
	[dbo].udf_getCustomerID (@customerEmailAddress)
	, [dbo].udf_getOrderDate (@orderDateTime)
	, NULL
	, NULL
	, NULL
	, NULL
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO OrderTable failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

