
CREATE PROCEDURE dbo.usp_AddVendor --- usp: user stored procedure

@vendorEmailAddress NVARCHAR(255)
, @vendorName NVARCHAR(50)
, @vendorStreetAddress NVARCHAR(255)
, @vendorCity NVARCHAR(50)		
, @vendorState NVARCHAR(2)		
, @vendorZip NVARCHAR(9)				
, @vendorPhone NVARCHAR(10)

AS
BEGIN

BEGIN TRY

INSERT INTO Vendor (vendorName, vendorEmailAddress, vendorStreetAddress, vendorCity, vendorState, vendorZip, vendorPhone)
VALUES (
	@vendorName					
	, @vendorEmailAddress
	, @vendorStreetAddress 
	, @vendorCity
	, @vendorState 
	, @vendorZip
	, @vendorPhone
); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO Vendor failed for: 
vendorName: ' + @vendorName
+ ', vendorEmailAddress: ' + @vendorEmailAddress
+ ', vendorStreetAddress: ' + @vendorStreetAddress
+ ', vendorCity: ' + @vendorCity
+ ', vendorState: ' + @vendorState
+ ', vendorZip: ' + @vendorZip
+ ', vendorPhone: ' + @vendorPhone
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

