
CREATE PROCEDURE dbo.usp_AddVendorProduct --- usp: user stored procedure

@vendorName NVARCHAR(255)
, @productName NVARCHAR(255)
, @quantityOnHand NVARCHAR(10)
, @vendorProductPrice NVARCHAR(10)

AS
BEGIN

BEGIN TRY

INSERT INTO vendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) 
VALUES (
	[dbo].udf_getVendorID (@vendorName)
	--(SELECT sdVendor_id FROM vendor WHERE vendorName = @vendorName)
	, [dbo].udf_getProductID (@productName)
	--(SELECT sdProduct_id FROM product WHERE productName = @productName)
	, (select convert(int, @quantityOnHand))
	, (select convert(smallMoney, @vendorProductPrice))
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO vendorProduct failed for: 
vendorName: ' + @vendorName
+ ', productName: ' + @productName
+ ', quantityOnHand: ' + @quantityOnHand
+ ', vendorProductPrice: ' + @vendorProductPrice
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

