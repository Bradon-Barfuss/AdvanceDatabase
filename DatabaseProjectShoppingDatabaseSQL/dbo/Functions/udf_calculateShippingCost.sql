CREATE FUNCTION [dbo].udf_calculateShippingCost (@customerZipcode NVARCHAR(9), @VendorZipcode NVARCHAR(9))
RETURNS smallMoney
AS 
BEGIN
	DECLARE @shippingCost smallMoney

	SET @shippingCost = ROUND(((ACOS(COS(Radians(90-[dbo].udf_getLatitude(@customerZipcode)))
						*Cos(Radians(90-[dbo].udf_getLatitude(@VendorZipcode)))
						+SIN(Radians(90-[dbo].udf_getLatitude(@customerZipcode)))
						*Sin(Radians(90-[dbo].udf_getLatitude(@VendorZipcode)))
						*COS(radians([dbo].udf_getLongitude(@customerZipcode)-[dbo].udf_getLongitude(@vendorZipcode))))
						*3958.8) * 0.01), 2);

	IF @shippingCost IS NULL
	SET @shippingCost = -1;

	RETURN @shippingCost
END

GO

