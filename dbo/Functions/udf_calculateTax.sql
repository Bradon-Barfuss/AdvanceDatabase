CREATE FUNCTION [dbo].udf_calculateTax (@customerState NVARCHAR(2), @subtotal SMALLMONEY)
	RETURNS SMALLMONEY
	AS
	BEGIN
		DECLARE
			@taxAmount SMALLMONEY
			, @taxRate decimal(5,4)

		SELECT @taxRate = taxRate
		FROM StateTax st
		INNER JOIN customer C
		ON st.State = c.customerState
		WHERE [state] = @customerState

		SET @taxAmount = @subTotal * @taxRate;

		IF @taxAmount IS NULL
		SET @taxAmount = -1;

		RETURN @taxAmount;
	END

GO

