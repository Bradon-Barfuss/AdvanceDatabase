
CREATE PROCEDURE [dbo].usp_AddCustomer --- usp: user stored procedure

@customerEmailAddress NVARCHAR(255)
, @customerFirstName NVARCHAR(50)
, @customerLastName NVARCHAR(50)
, @customerStreetAddress NVARCHAR(255)
, @customerCity NVARCHAR(50)
, @customerState NVARCHAR(2)
, @customerZip NVARCHAR(9)

AS
BEGIN

BEGIN TRY

INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES (
	@customerEmailAddress
	, @customerFirstName 
	, @customerLastName 
	, @customerStreetAddress
	, @customerCity 
	, @customerState
	, @customerZip
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO Customer failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', customerFirstname: ' + @customerFirstName
+ ', customerLastName: ' + @customerLastName
+ ', customerStreetAddress: ' + @customerStreetAddress
+ ', customerCity: ' + @customerCity
+ ', customerState: ' + @customerState
+ ', customerZip: ' + @customerZip
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

