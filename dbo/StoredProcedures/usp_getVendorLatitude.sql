
CREATE PROCEDURE [dbo].usp_getVendorLatitude
@customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)

AS
BEGIN
DECLARE @vendorLatitude FLOAT;

BEGIN TRY
	SELECT @vendorLatitude = [dbo].udf_getLatitude([dbo].udf_getVendorZipCode(@customerEmailAddress, @orderDateTime))
END TRY

BEGIN CATCH
PRINT 'The Vendor Latitude Procedure Failed for: 
CustomerEmailAddress: ' + @customerEmailAddress
+ ' OrderDateTime: ' + @orderDateTime
+ ' Error Message: ' + ERROR_MESSAGE();

END CATCH
END

GO

