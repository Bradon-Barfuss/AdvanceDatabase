
CREATE PROCEDURE dbo.usp_AddSupplier --- usp: user stored procedure

@supplierName NVARCHAR(50)
, @supplierStreetAddress NVARCHAR(255)
, @supplierCity NVARCHAR(50)
, @supplierState NVARCHAR(2)
, @supplierZip NVARCHAR(9)

AS
BEGIN

BEGIN TRY

INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip)
VALUES (
@supplierName
, @supplierStreetAddress
, @supplierCity
, @supplierState
, @supplierZip 
); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO Supplier failed for: 
supplierName: ' + @supplierName
+ ', supplierStreetAddress: ' + @supplierStreetAddress
+ ', supplierCity: ' + @supplierCity
+ ', supplierState: ' + @supplierState
+ ', supplierZip: ' + @supplierZip
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

