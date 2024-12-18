CREATE FUNCTION [dbo].udf_getVendorID (@vendorName NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdVendor_id INT; -- internal variable

Select @sdVendor_id = sdVendor_id
FROM Vendor
WHERE vendorName = @vendorName

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdVendor_id IS NULL
SET @sdVendor_id = -1

RETURN @sdVendor_id
END

GO

