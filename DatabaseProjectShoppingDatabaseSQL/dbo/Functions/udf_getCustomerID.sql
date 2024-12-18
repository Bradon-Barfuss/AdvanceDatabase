CREATE FUNCTION [dbo].udf_getCustomerID (@customerEmailAddress NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdCustomer_id INT; -- internal variable

Select @sdCustomer_id = sdCustomer_id
FROM Customer
WHERE customerEmailAddress = @customerEmailAddress

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdCustomer_id IS NULL
SET @sdCustomer_id = -1

RETURN @sdCustomer_id
END

GO

