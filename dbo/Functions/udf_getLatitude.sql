CREATE FUNCTION [dbo].udf_getLatitude (@ZipCode NVARCHAR(9))
RETURNS FLOAT
AS
BEGIN
	DECLARE @Latitude FLOAT;

	SELECT @Latitude = Latitude
	FROM Zipcodes
	WHERE zipcode = @ZipCode

	IF @Latitude IS NULL
	SET @Latitude = -1
	
	RETURN @Latitude
END

GO

