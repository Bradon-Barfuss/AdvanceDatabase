
CREATE PROCEDURE usp_calculateTotal
@customerEmailAddress NVARCHAR(255)
, @OrderDateTime NVARCHAR(50)

AS
BEGIN

BEGIN TRY
	UPDATE OrderTable
	SET orderTotal = ROUND((ShippingCost + taxAmount + subTotal), 2) --use previous functions to get these values
	WHERE orderTable.sdOrderTable_id = [dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime)
END TRY

	BEGIN CATCH
		PRINT 'The calculate Total failed for:
				customerEmailAddress: ' + @customerEmailAddress +
				'OrderDateTime: ' + @orderDateTime +
				', Message: ' + ERROR_MESSAGE()

		END CATCH
	END

GO

