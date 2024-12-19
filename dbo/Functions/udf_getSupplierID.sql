CREATE FUNCTION [dbo].udf_getSupplierID (@supplierName NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdSupplier_id INT; -- internal variable

Select @sdSupplier_id = sdSupplier_id
FROM Supplier
WHERE supplierName = @supplierName

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdSupplier_id IS NULL
SET @sdSupplier_id = -1

RETURN @sdSupplier_id
END

GO

