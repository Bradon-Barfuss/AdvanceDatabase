CREATE FUNCTION [dbo].udf_getOrderTableID (@customerEmailAddress NVARCHAR(255), @orderDateTime NVARCHAR(50)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdOrderTable_id INT; -- internal variable

Select @sdOrderTable_id = sdOrderTable_id
FROM OrderTable
WHERE sdCustomer_id = [dbo].udf_getCustomerID (@customerEmailAddress)
AND orderDateTime = [dbo].udf_getOrderDate (@orderDateTime)

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdOrderTable_id IS NULL
SET @sdOrderTable_id = -1

RETURN @sdOrderTable_id
END

GO

