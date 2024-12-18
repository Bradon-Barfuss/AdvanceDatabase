CREATE FUNCTION [dbo].udf_getLongitude (@ZipCode NVARCHAR(9))
RETURNS FLOAT
AS
BEGIN
	DECLARE @Longitude FLOAT;

	SELECT @Longitude = Longitude
	FROM Zipcodes
	WHERE zipcode = @ZipCode

	IF @Longitude IS NULL
	SET @Longitude = -1
	
	RETURN @Longitude
END

GO

