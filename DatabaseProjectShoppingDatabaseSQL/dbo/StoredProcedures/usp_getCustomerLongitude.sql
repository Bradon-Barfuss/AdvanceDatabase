
CREATE PROCEDURE [dbo].usp_getCustomerLongitude
@customerEmailAddress NVARCHAR(255)

AS
BEGIN
DECLARE @customerLongitude FLOAT;

BEGIN TRY
	SELECT @customerLongitude = [dbo].udf_getLongitude([dbo].udf_getCustomerZip(@customerEmailAddress))
END TRY

BEGIN CATCH
PRINT 'The Customer Longitude Procedure Failed for: 
CustomerEmailAddress: ' + @customerEmailAddress
+ ' Error Message: ' + ERROR_MESSAGE();

END CATCH
END

GO

