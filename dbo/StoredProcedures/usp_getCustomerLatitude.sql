
CREATE PROCEDURE [dbo].usp_getCustomerLatitude
@customerEmailAddress NVARCHAR(255)

AS
BEGIN
DECLARE @customerLatitude FLOAT;

BEGIN TRY
	SELECT @customerLatitude = [dbo].udf_getLatitude([dbo].udf_getCustomerZip(@customerEmailAddress))
END TRY

BEGIN CATCH
PRINT 'The Customer Latitude Procedure Failed for: 
CustomerEmailAddress: ' + @customerEmailAddress
+ ' Error Message: ' + ERROR_MESSAGE();

END CATCH
END

GO

