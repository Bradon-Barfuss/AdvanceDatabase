
CREATE PROCEDURE usp_calculateShippingCost
@customerEmailAddress NVARCHAR(255)
, @OrderDateTime NVARCHAR(50)

AS
BEGIN

BEGIN TRY
	UPDATE OrderTable
	SET shippingcost = [dbo].udf_calculateShippingCost([dbo].udf_getCustomerZip(@customerEmailAddress)
					, [dbo].udf_getVendorZipCode(@customerEmailAddress, @orderDateTime))
	WHERE orderTable.sdOrderTable_id = [dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime)
END TRY

	BEGIN CATCH
		PRINT 'The calshipping calculate Total failed for:
				customerEmailAddress: ' + @customerEmailAddress +
				'OrderDateTime: ' + @orderDateTime +
				', Message: ' + ERROR_MESSAGE()

		END CATCH
	END

GO

