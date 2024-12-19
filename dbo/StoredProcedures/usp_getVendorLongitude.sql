
CREATE PROCEDURE [dbo].usp_getVendorLongitude
@customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)

AS
BEGIN
DECLARE @vendorLongitude FLOAT;

BEGIN TRY
	SELECT @vendorLongitude = [dbo].udf_getLongitude([dbo].udf_getVendorZipCode(@customerEmailAddress, @orderDateTime))
END TRY

BEGIN CATCH
PRINT 'The Vendor Longitude Procedure Failed for: 
CustomerEmailAddress: ' + @customerEmailAddress
+ ' OrderDateTime: ' + @orderDateTime
+ ' Error Message: ' + ERROR_MESSAGE();

END CATCH
END

GO

