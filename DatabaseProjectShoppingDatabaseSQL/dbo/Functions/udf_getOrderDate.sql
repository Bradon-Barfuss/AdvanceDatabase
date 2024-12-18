CREATE FUNCTION [dbo].udf_getOrderDate (@orderDateTime NVARCHAR(50))
RETURNS datetime
AS 
BEGIN

DECLARE @orderDateTimeFormatted datetime

SELECT @orderDateTimeFormatted = convert(datetime, @orderDateTime)

IF @orderDateTimeFormatted IS NULL
SET @orderDateTimeFormatted = -1

RETURN @orderDateTimeFormatted
END

GO

