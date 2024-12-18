
CREATE PROCEDURE dbo.usp_AddProduct --- usp: user stored procedure
@productName NVARCHAR(255)
, @supplierName NVARCHAR(50)

AS
BEGIN

BEGIN TRY

INSERT INTO Product (productName, sdSupplier_id) 
VALUES (
	@productName
	,[dbo].udf_getSupplierID (@supplierName)
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO Product failed for: 
productName: ' + @productName
+ ', sdSupplier_id: ' + @supplierName
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

