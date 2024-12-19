CREATE FUNCTION [dbo].udf_getCustomerZip (@customerEmailAddress NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS NVARCHAR(9) -- return type
AS
BEGIN

DECLARE @customerZipcode NVARCHAR(9); -- internal variable

	set @customerZipcode = 
		(select customerZip from customer  --I CHANGED @customerZipcode to customerZipcode, so that may cause a error 3/13!!!!!!!
		where customerEmailAddress = @customerEmailAddress)


-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @customerZipcode IS NULL
SET @customerZipcode = '00000'

RETURN @customerZipcode
END

GO

