
CREATE PROCEDURE usp_calculateTaxAmount
	@customerEmailAddress NVARCHAR(255)
	, @orderDateTime NVARCHAR(50)


	AS BEGIN
	BEGIN TRY
		UPDATE OrderTable
		SET OrderTable.taxAmount = ROUND(dbo.udf_calculateTax(c.customerState, ot.subTotal),2)
		FROM OrderTable ot
		INNER JOIN Customer c
		on ot.sdCustomer_id = c.sdCustomer_id
		WHERE ot.sdOrderTable_id = [dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime)
	END TRY

BEGIN CATCH 
PRINT 'The Calculate Tax failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

