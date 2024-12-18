CREATE FUNCTION [dbo].udf_getProductID (@productName NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdProduct_id INT; -- internal variable

Select @sdProduct_id = sdProduct_id
FROM Product
WHERE productName = @productName

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdProduct_id IS NULL
SET @sdProduct_id = -1

RETURN @sdProduct_id
END

GO

