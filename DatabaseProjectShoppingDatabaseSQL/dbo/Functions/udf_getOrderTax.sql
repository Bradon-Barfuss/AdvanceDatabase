CREATE FUNCTION [dbo].udf_getOrderTax (@customerEmailAddress NVARCHAR(255))

RETURNS smallMoney

AS BEGIN 
	DECLARE @orderTax smallmoney;

	SET @orderTax = 
		(SELECT taxrate from StateTax
		where [state] = 
			(select customerState from Customer 
			where customerEmailAddress = @customerEmailAddress))

IF @orderTax IS NULL
SET @orderTax = -1

RETURN @orderTax
END

GO

