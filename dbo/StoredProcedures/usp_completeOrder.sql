CREATE PROCEDURE usp_completeOrder
	@customerEmailAddress NVARCHAR(255)
	, @orderDateTime NVARCHAR(255)

	AS
	BEGIN TRY
	--
	DECLARE @orderTableID INT;
	SET @orderTableID = dbo.udf_getOrderTableID(@customerEmailAddress, @orderDateTime);

	IF (SELECT COUNT(*)
	FROM orderItem
	WHERE sdOrderTable_id = @orderTableID) = 0
		BEGIN
			Print 'The Order is empty and must be deleted for customer: ' + @customerEmailAddress + 'and Order Date Time: ' + @orderDateTime
			DELETE FROM OrderTable
			WHERE sdOrderTable_id = @orderTableID
		END
Else
	BEGIN
		EXECUTE [dbo].usp_calculateSubtotal @customerEmailAddress, @orderDateTime;

		EXECUTE [dbo].usp_calculateTaxAmount @customerEmailAddress, @orderDateTime;

		EXECUTE [dbo].usp_calculateShippingCost @customerEmailAddress, @orderDateTime;

		EXECUTE [dbo].usp_calculateTotal @customerEmailAddress, @orderDateTime;
	END

END TRY
	BEGIN CATCH
		PRINT 'The UPDATE OF THE orderTable failed for: 
		customerEmailAddress: ' + @customerEmailAddress
		+ ', orderDateTime: ' + @orderDateTime
		+ ', message: ' + ERROR_MESSAGE()
	END CATCH

GO

