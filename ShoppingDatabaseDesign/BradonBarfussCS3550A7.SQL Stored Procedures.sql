---- Shopping Database Creation Script
-- CS 3550
--Bradon Barfuss

-------------------------------------------
-- Move to Master Database
-------------------------------------------
USE Master;
GO

-------------------------------------------
-- Drop Database if necessary
-------------------------------------------
IF EXISTS (SELECT * FROM sysdatabases WHERE name = N'ShoppingDatabase')
DROP DATABASE ShoppingDatabase;

go


-------------------------------------------
-- Create Database
-------------------------------------------
CREATE DATABASE [ShoppingDatabase]
ON PRIMARY
(Name = N'ShoppingDatabase',
filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\ShoppingDatabase.mdf',
SIZE = 5MB,
FILEGROWTH = 1MB)
LOG ON
(Name = N'ShoppingDatabase_Log',
filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\ShoppingDatabase_Log.ldf',
SIZE = 2MB,
FILEGROWTH = 1MB)
GO

-------------------------------------------
-- Use The Shopping Database
-------------------------------------------
USE ShoppingDatabase;
GO

-------------------------------------------
-- DROP TABLES
-------------------------------------------
IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'OrderItem')
DROP TABLE OrderItem;

IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'VendorProduct')
DROP TABLE VendorProduct;

IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'OrderTable')
DROP TABLE OrderTable;

IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'Vendor')
DROP TABLE Vendor;

IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'Product')
DROP TABLE Product;

IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'Customer')
DROP TABLE Customer;

IF EXISTS (SELECT * FROM sys.tables WHERE Name = N'Supplier')
DROP TABLE Supplier;

GO


-------------------------------------------
-- CREATE TABLES
-------------------------------------------
-- Create Customer Table
CREATE TABLE Customer ( 
	sdCustomer_id				INT				NOT NULL IDENTITY(1, 1)
	, customerEmailAddress		NVARCHAR(255)	NOT NULL
	, customerFirstName			NVARCHAR(50)	NOT NULL
	, customerLastName			NVARCHAR(50)	NOT NULL
	, customerStreetAddress		NVARCHAR(255)	NOT NULL
	, customerCity				NVARCHAR(50)	NOT NULL
	, customerState				NVARCHAR(2)		NOT NULL
	, customerZip				NVARCHAR(9)		NOT NULL
);

-- Create Vendor Table
CREATE TABLE Vendor (
	sdVendor_id					INT				NOT NULL IDENTITY(1, 1)
	, vendorEmailAddress		NVARCHAR(255)	NOT NULL
	, vendorName				NVARCHAR(50)	NOT NULL
	, vendorStreetAddress		NVARCHAR(255)	NOT NULL
	, vendorCity				NVARCHAR(50)	NOT NULL
	, vendorState				NVARCHAR(2)		NOT NULL
	, vendorZip					NVARCHAR(9)		NOT NULL
	, vendorPhone				NVARCHAR(10)	NOT NULL
);

-- Create Supplier Table
CREATE TABLE Supplier (
	sdSupplier_id				INT				NOT NULL IDENTITY(1, 1)
	, supplierName				NVARCHAR(50)	NOT NULL
	, supplierStreetAddress		NVARCHAR(255)	NOT NULL
	, supplierCity				NVARCHAR(50)	NOT NULL
	, supplierState				NVARCHAR(2)		NOT NULL
	, supplierZip				NVARCHAR(9)		NOT NULL
);

-- Create Product Table
CREATE TABLE Product(
	sdProduct_id			INT				NOT NULL IDENTITY(1, 1)
	, sdSupplier_id			INT				NOT NULL
	, productName			NVARCHAR(255)	NOT NULL
);

-- Create VendorProduct Table
CREATE TABLE VendorProduct (
	sdVendor_id				INT				NOT NULL 
	, sdProduct_id			INT				NOT NULL 
	, quantityOnHand		INT				NOT NULL
	, vendorProductPrice	smallMoney		NOT NULL
);

-- Create Order Table
CREATE TABLE OrderTable (
	sdOrderTable_id		INT			NOT NULL IDENTITY(1,1)
	, sdCustomer_id		INT			NOT NULL 
	, orderDateTime		DateTime	NOT NULL
	, subTotal			smallMoney  NULL
	, taxAmount			smallMoney	NULL
	, shippingCost		smallMoney	NULL
	, orderTotal		smallMoney	NULL
);


-- Create OrderItem Table
CREATE TABLE OrderItem (
	sdOrderTable_id		INT		 NOT NULL 
	, sdProduct_id		INT		 NOT NULL
	, sdVendor_id		INT		 NOT NULL
	, quantity			SmallINT NOT NULL
);

GO


-------------------------------------------
-- CREATE Primary Keys
-------------------------------------------
ALTER TABLE Customer
	ADD CONSTRAINT PK_Customer
	PRIMARY KEY (sdCustomer_id);

ALTER TABLE Vendor
	ADD CONSTRAINT PK_Vendor
	PRIMARY KEY (sdVendor_id);

ALTER TABLE Supplier
	ADD CONSTRAINT PK_Supplier
	PRIMARY KEY (sdSupplier_id);

ALTER TABLE Product
	ADD CONSTRAINT PK_Product
	PRIMARY KEY (sdProduct_id);

ALTER TABLE VendorProduct
	ADD CONSTRAINT PK_VendorProduct
	PRIMARY KEY (sdVendor_id, sdProduct_id);

ALTER TABLE OrderTable
	ADD CONSTRAINT PK_OrderTable
	PRIMARY KEY (sdOrderTable_id);

ALTER TABLE OrderItem
	ADD CONSTRAINT PK_OrderItem
	PRIMARY KEY (sdOrderTable_id, sdProduct_id, sdVendor_id);

GO


-------------------------------------------
-- CREATE Foreign Keys
-------------------------------------------
ALTER TABLE VendorProduct 
	ADD CONSTRAINT FK_VendorProduct_VendorID
	FOREIGN KEY (sdVendor_id) REFERENCES Vendor (sdVendor_id);

ALTER TABLE VendorProduct 
	ADD CONSTRAINT FK_VendorProduct_ProductID
	FOREIGN KEY (sdProduct_id) REFERENCES Product (sdProduct_id);

ALTER TABLE Product 
	ADD CONSTRAINT FK_Product_ProductID
	FOREIGN KEY (sdSupplier_id) REFERENCES Supplier (sdSupplier_id);

ALTER TABLE OrderTable
	ADD CONSTRAINT FK_OrderTable_CustomerID
	FOREIGN KEY (sdCustomer_id) REFERENCES Customer (sdCustomer_id);

ALTER TABLE OrderItem
	ADD CONSTRAINT FK_OrderItem_OrderTableID
	FOREIGN KEY (sdOrderTable_id) REFERENCES OrderTable (sdOrderTable_id);

ALTER TABLE OrderItem
	ADD CONSTRAINT FK_OrderItem_VendorID
	FOREIGN KEY (sdVendor_id) REFERENCES Vendor (sdVendor_id);

ALTER TABLE OrderItem
	ADD CONSTRAINT FK_OrderItem_ProductID
	FOREIGN KEY (sdProduct_id) REFERENCES Product (sdProduct_id);

GO


-------------------------------------------
-- CREATE Alternate Keys
-------------------------------------------
ALTER TABLE Customer
	ADD CONSTRAINT AK_Customer_customerEmailAddress
	UNIQUE (customerEmailAddress);

ALTER TABLE Supplier
	ADD CONSTRAINT AK_Supplier_supplierName
	UNIQUE (supplierName);

ALTER TABLE Vendor
	ADD CONSTRAINT AK_Vendor_VendorName
	UNIQUE (vendorName);

ALTER TABLE Product
	ADD CONSTRAINT AK_Product_ProductName
	UNIQUE (ProductName);

ALTER TABLE OrderTable
	ADD CONSTRAINT AK_OrderTable_OrderDateTime_CustomerID
	UNIQUE (OrderDateTime, sdCustomer_id);

GO

-------------------------------------------
-- CREATE Data Constraints
-------------------------------------------

--- Zip Codes----
ALTER TABLE Customer
	ADD CONSTRAINT CK_Customer_Zip
	CHECK (customerZip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	OR customerZip LIKE '[0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE Vendor
	ADD CONSTRAINT CK_Vendor_Zip
	CHECK (VendorZip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	OR VendorZip LIKE '[0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE Supplier
	ADD CONSTRAINT CK_Supplier_Zip
	CHECK (SupplierZip LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	OR SupplierZip LIKE '[0-9][0-9][0-9][0-9][0-9]');

---- Email Address ----
ALTER TABLE Customer
	ADD CONSTRAINT CK_Customer_emailAddress
	CHECK (customerEmailAddress LIKE '%@%.%');

ALTER TABLE Vendor
	ADD CONSTRAINT CK_Vendor_emailAddress
	CHECK (VendorEmailAddress LIKE '%@%.%');

---- Phones ----
ALTER TABLE Vendor
	ADD CONSTRAINT CK_Vendor_Phone
	CHECK (vendorPhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		OR vendorPhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

---- Uppercase abrivated states ----
alter table Customer
	ADD CONSTRAINT CK_Customer_State
	CHECK (upper(customerState) = customerState collate Latin1_General_BIN2)

alter table Vendor
	ADD CONSTRAINT CK_Vendor_State
	CHECK (upper(vendorState) = vendorState collate Latin1_General_BIN2)

alter table Supplier
	ADD CONSTRAINT CK_Supplier_State
	CHECK (upper(supplierState) = supplierState collate Latin1_General_BIN2)

GO


----------------------------------------------------------
-- CREATE PROCEDURES
----------------------------------------------------------

-----------------------------
--- Add Customer Prcedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddCustomer')
DROP PROCEDURE dbo.usp_AddCustomer;
GO

CREATE PROCEDURE dbo.usp_AddCustomer --- usp: user stored procedure

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


-----------------------------
--- Add Vendor Prcedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddVendor')
DROP PROCEDURE dbo.usp_AddVendor;
GO

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


-----------------------------
--- Add Supplier Prcedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddSupplier')
DROP PROCEDURE dbo.usp_AddSupplier;
GO

CREATE PROCEDURE dbo.usp_AddSupplier --- usp: user stored procedure

@supplierName NVARCHAR(50)
, @supplierStreetAddress NVARCHAR(255)
, @supplierCity NVARCHAR(50)
, @supplierState NVARCHAR(2)
, @supplierZip NVARCHAR(9)

AS
BEGIN

BEGIN TRY

INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip)
VALUES (
@supplierName
, @supplierStreetAddress
, @supplierCity
, @supplierState
, @supplierZip 
); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO Supplier failed for: 
supplierName: ' + @supplierName
+ ', supplierStreetAddress: ' + @supplierStreetAddress
+ ', supplierCity: ' + @supplierCity
+ ', supplierState: ' + @supplierState
+ ', supplierZip: ' + @supplierZip
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END 

GO


-----------------------------
--- Add Product Prcedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddProduct')
DROP PROCEDURE dbo.usp_AddProduct;
GO

CREATE PROCEDURE dbo.usp_AddProduct --- usp: user stored procedure
@productName NVARCHAR(255)
, @supplierName NVARCHAR(255)

AS
BEGIN

BEGIN TRY

INSERT INTO Product (productName, sdSupplier_id) 
VALUES (
	@productName
	,(SELECT sdSupplier_id FROM Supplier WHERE supplierName = @supplierName)
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO Product failed for: 
productName: ' + @productName
+ ', sdSupplier_id: ' + @supplierName
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END 

GO


--------------------------------------
-- Order Table Procedure 
--------------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddOrder')
DROP PROCEDURE dbo.usp_AddOrder;
GO

CREATE PROCEDURE dbo.usp_AddOrder --- usp: user stored procedure

@customerEmailAddress NVARCHAR(255) --the sdCustomerId Alternate key 
, @orderDateTime NVARCHAR(50)
, @subTotal NVARCHAR(10)
, @taxAmount NVARCHAR(10)
, @shippingCost NVARCHAR(10)
, @orderTotal NVARCHAR(10)

AS
BEGIN

BEGIN TRY

INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) 
VALUES (
	(SELECT sdCustomer_id FROM Customer WHERE customerEmailAddress = @customerEmailAddress)
	, (SELECT CONVERT (DATETIME, @orderDateTime)) 
	, (SELECT CONVERT (smallMoney, @subTotal))
	, (SELECT CONVERT (smallMoney, @taxAmount))
	, (SELECT CONVERT (smallMoney, @shippingCost))
	, (SELECT CONVERT (smallMoney, @orderTotal))
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO OrderTable failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', subTotal: ' + @subTotal
+ ', taxAmount: ' + @taxAmount
+ ', shippingCost: ' + @shippingCost
+ ', orderTotal: ' + @orderTotal
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END 

GO

-----------------------------
--- Add VendorProduct Prcedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddVendorProduct')
DROP PROCEDURE dbo.usp_AddVendorProduct;
GO

CREATE PROCEDURE dbo.usp_AddVendorProduct --- usp: user stored procedure

@vendorName NVARCHAR(255)
, @productName NVARCHAR(255)
, @quantityOnHand NVARCHAR(10)
, @vendorProductPrice NVARCHAR(10)

AS
BEGIN

BEGIN TRY

INSERT INTO vendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) 
VALUES (
	(SELECT sdVendor_id FROM vendor WHERE vendorName = @vendorName)
	,(SELECT sdProduct_id FROM product WHERE productName = @productName)
	, (select convert(int, @quantityOnHand))
	, (select convert(smallMoney, @vendorProductPrice))
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO vendorProduct failed for: 
vendorName: ' + @vendorName
+ ', productName: ' + @productName
+ ', quantityOnHand: ' + @quantityOnHand
+ ', vendorProductPrice: ' + @vendorProductPrice
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END 

GO


-----------------------------
--- Add OrderItems Prcedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddOrderItems')
DROP PROCEDURE dbo.usp_AddOrderItems;
GO

CREATE PROCEDURE dbo.usp_AddOrderItems --- usp: user stored procedure

@productName NVARCHAR(50)
, @vendorName NVARCHAR(50)
, @quantity NVARCHAR(255)
, @customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)


AS
BEGIN

BEGIN TRY

INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) 
VALUES (
	(select sdOrderTable_id FROM OrderTable where sdCustomer_id 
	= (Select sdCustomer_id from customer where customerEmailAddress = @customerEmailAddress)
	AND orderDateTime = (Select convert (datetime, @orderDateTime)))
	, (SELECT sdProduct_id FROM product WHERE productName = @productName)
	, (SELECT sdVendor_id FROM vendor WHERE vendorName = @vendorName)
	, (SELECT Convert (int, @quantity))
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO OrderItems failed for: 
productName: ' + @productName
+ ', vendorName: ' + @vendorName
+ ', quantity: ' + @quantity
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END 

GO


----------------------------------
--- EXECUTE Data Entry
----------------------------------
-- Enter Customer Table Data
----------------------------------
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'donette.foller@cox.net', @customerFirstName = 'Donette', @customerLastName = 'Foller', @customerStreetAddress = '34 Center St', @customerCity = 'Hamilton', @customerState = 'OH', @customerZip = '45011';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'mroyster@royster.com', @customerFirstName = 'Maryann', @customerLastName = 'Royster',
@customerStreetAddress = '74 S Westgate St', @customerCity = 'Albany', @customerState = 'NY', @customerZip = '12204';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'ernie_stenseth@aol.com', @customerFirstName = 'Ernie', @customerLastName = 'Stenseth',
@customerStreetAddress = '45 E Liberty St', @customerCity = 'Ridgefield Park', @customerState = 'NJ', @customerZip = '07660';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jina_briddick@briddick.com', @customerFirstName = 'Jina', @customerLastName = 'Briddick',
@customerStreetAddress = '38938 Park Blvd', @customerCity = 'Boston', @customerState = 'MA', @customerZip = '02128';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'sabra@uyetake.org', @customerFirstName = 'Sabra', @customerLastName = 'Uyetake',
@customerStreetAddress = '98839 Hawthorne Blvd #6101', @customerCity = 'Columbia', @customerState = 'SC', @customerZip = '29201';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'brhym@rhym.com', @customerFirstName = 'Bobbye', @customerLastName = 'Rhym',
@customerStreetAddress = '30 W 80th St #1995', @customerCity = 'San Carlos', @customerState = 'CA', @customerZip = '94070';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'viva.toelkes@gmail.com', @customerFirstName = 'Viva', @customerLastName = 'Toelkes',
@customerStreetAddress = '4284 Dorigo Ln', @customerCity = 'Chicago', @customerState = 'IL', @customerZip = '60647';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'dominque.dickerson@dickerson.org', @customerFirstName = 'Dominque', @customerLastName = 'Dickerson',
@customerStreetAddress = '69 Marquette Ave', @customerCity = 'Hayward', @customerState = 'CA', @customerZip = '94545';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'latrice.tolfree@hotmail.com', @customerFirstName = 'Latrice', @customerLastName = 'Tolfree',
@customerStreetAddress = '81 Norris Ave #525', @customerCity = 'Ronkonkoma', @customerState = 'NY', @customerZip = '11779';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'stephaine@cox.net', @customerFirstName = 'Stephaine', @customerLastName = 'Vinning',
@customerStreetAddress = '3717 Hamann Industrial Pky', @customerCity = 'San Francisco', @customerState = 'CA', @customerZip = '94104';
GO

-----------------------------
---- Insert Vendor Table ----
-----------------------------
EXECUTE dbo.usp_AddVendor @vendorName = 'Eagle Software Inc', @vendorstreetaddress = '5384 Southwyck Blvd', @vendorCity = 'Douglasville',
@vendorstate = 'GA', @vendorZip = '30135', @vendoremailaddress = 'info@eaglesoftwareinc.com', @vendorPhone = '7705078791';
EXECUTE dbo.usp_AddVendor @vendorName = 'Art Crafters', @vendorstreetaddress = '703 Beville Rd', @vendorCity = 'Opa Locka',
@vendorstate = 'FL', @vendorZip = '33054', @vendoremailaddress = 'support@artcrafters.com', @vendorPhone = '3056709628';
EXECUTE dbo.usp_AddVendor @vendorName = 'Burton & Davis', @vendorstreetaddress = '70 Mechanic St', @vendorCity = 'Northridge',
@vendorstate = 'CA', @vendorZip = '91325', @vendoremailaddress = 'helpdesk@burtondavis.com', @vendorPhone = '8188644875';
EXECUTE dbo.usp_AddVendor @vendorName = 'Jets Cybernetics', @vendorstreetaddress = '99586 Main St', @vendorCity = 'Dallas',
@vendorstate = 'TX', @vendorZip = '75207', @vendoremailaddress = 'info@jetscybernetics.com', @vendorPhone = '2144282285';
EXECUTE dbo.usp_AddVendor @vendorName = 'Professionals Unlimited', @vendorstreetaddress = '66697 Park Pl #3224', @vendorCity = 'Riverton',
@vendorstate = 'WY', @vendorZip = '82501', @vendoremailaddress = 'inquiry@professionalsunlimited.com', @vendorPhone = '3073427795';
EXECUTE dbo.usp_AddVendor @vendorName = 'Linguistic Systems Inc', @vendorstreetaddress = '506 S Hacienda Dr', @vendorCity = 'Atlantic City',
@vendorstate = 'NJ', @vendorZip = '08401', @vendoremailaddress = 'help@linguisticsystemsinc.com', @vendorPhone = '6092285265';
EXECUTE dbo.usp_AddVendor @vendorName = 'Price Business Services', @vendorstreetaddress = '7 West Ave #1', @vendorCity = 'Palatine',
@vendorstate = 'IL', @vendorZip = '60067', @vendoremailaddress = 'support@pricebusinessservices.com', @vendorPhone = '8472221734';
EXECUTE dbo.usp_AddVendor @vendorName = 'Mitsumi Electronics Corp', @vendorstreetaddress = '9677 Commerce Dr', @vendorCity = 'Richmond',
@vendorstate = 'VA', @vendorZip = '23219', @vendoremailaddress = 'support@mitsumielectronicscorp.com', @vendorPhone = '8045505097';
EXECUTE dbo.usp_AddVendor @vendorName = 'Sidewinder Products Corp', @vendorstreetaddress = '8573 Lincoln Blvd', @vendorCity = 'York',
@vendorstate = 'PA', @vendorZip = '17404', @vendoremailaddress = 'helpdesk@sidewinderproductscorp.com', @vendorPhone = '7178093119';
EXECUTE dbo.usp_AddVendor @vendorName = 'Circuit Solution Inc', @vendorstreetaddress = '39 Moccasin Dr', @vendorCity = 'San Francisco',
@vendorstate = 'CA', @vendorZip = '94104', @vendoremailaddress = 'answers@circuitsolutioninc.com', @vendorPhone = '4154111775';
GO


-----------------------------
--- Insert Supplier Table ---
-----------------------------
EXECUTE dbo.usp_AddSupplier @supplierName = 'Printing Dimensions', @supplierStreetAddress = '34 Center St', @supplierCity = 'Hamilton',
@supplierState = 'OH', @supplierZip = '45011';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Franklin Peters Inc', @supplierStreetAddress = '74 S Westgate St', @supplierCity = 'Albany',
@supplierState = 'NY', @supplierZip = '12204';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Knwz Products', @supplierStreetAddress = '45 E Liberty St', @supplierCity = 'Ridgefield Park',
@supplierState = 'NJ', @supplierZip = '07660';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Grace Pastries Inc', @supplierStreetAddress = '38938 Park Blvd', @supplierCity = 'Boston',
@supplierState = 'MA', @supplierZip = '02128';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Lowy Products and Service', @supplierStreetAddress = '98839 Hawthorne Blvd #6101', @supplierCity = 'Columbia',
@supplierState = 'SC', @supplierZip = '29201';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Smits, Patricia Garity', @supplierStreetAddress = '30 W 80th St #1995', @supplierCity = 'San Carlos',
@supplierState = 'CA', @supplierZip = '94070';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Mark Iv Press', @supplierStreetAddress = '4284 Dorigo Ln', @supplierCity = 'Chicago',
@supplierState = 'IL', @supplierZip = '60647';
EXECUTE dbo.usp_AddSupplier @supplierName = 'E A I Electronic Assocs Inc', @supplierStreetAddress = '69 Marquette Ave', @supplierCity = 'Hayward',
@supplierState = 'CA', @supplierZip = '94545';
EXECUTE dbo.usp_AddSupplier @supplierName = 'United Product Lines', @supplierStreetAddress = '81 Norris Ave #525', @supplierCity = 'Ronkonkoma',
@supplierState = 'NY', @supplierZip = '11779';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Birite Foodservice', @supplierStreetAddress = '3717 Hamann Industrial Pky', @supplierCity = 'San Francisco',
@supplierState = 'CA', @supplierZip = '94104';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Roberts Supply Co Inc', @supplierStreetAddress = '8429 Miller Rd', @supplierCity = 'Pelham',
@supplierState = 'NY', @supplierZip = '10803';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Harris Corporation', @supplierStreetAddress = '4 Iwaena St', @supplierCity = 'Baltimore',
@supplierState = 'MD', @supplierZip = '21202';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Armon Communications', @supplierStreetAddress = '9 State Highway 57 #22', @supplierCity = 'Jersey City',
@supplierState = 'NJ', @supplierZip = '07306';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Tipiak Inc', @supplierStreetAddress = '80312 W 32nd St', @supplierCity = 'Conroe',
@supplierState = 'TX', @supplierZip = '77301';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Sportmaster International', @supplierStreetAddress = '6 Sunrise Ave', @supplierCity = 'Utica',
@supplierState = 'NY', @supplierZip = '13501';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Acme Supply Co', @supplierStreetAddress = '1953 Telegraph Rd', @supplierCity = 'Saint Joseph',
@supplierState = 'MO', @supplierZip = '64504';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Warehouse Office & Paper Prod', @supplierStreetAddress = '61556 W 20th Ave', @supplierCity = 'Seattle',
@supplierState = 'WA', @supplierZip = '98104';
GO

-----------------------------
--- Insert Product Table ---
-----------------------------
EXECUTE dbo.usp_AddProduct @productName = 'White Weber State University Women''s Tank Top', @supplierName = 'Printing Dimensions';
EXECUTE dbo.usp_AddProduct @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @supplierName = 'Franklin Peters Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Steel Grey Weber State University Women''s Cropped Short Sleeve T-Shirt', @supplierName = 'Knwz Products';
EXECUTE dbo.usp_AddProduct @productName = 'Yellow Weber State University 16 oz. Tumbler', @supplierName = 'Lowy Products and Service';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Academic Year Planner', @supplierName = 'Warehouse Office & Paper Prod';
EXECUTE dbo.usp_AddProduct @productName = 'White Weber State University Orbiter Pen', @supplierName = 'Smits, Patricia Garity';
EXECUTE dbo.usp_AddProduct @productName = 'Silver Weber State University Wildcats Keytag', @supplierName = 'Mark Iv Press';
EXECUTE dbo.usp_AddProduct @productName = 'Silver Weber State University Money Clip', @supplierName = 'Acme Supply Co';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Rain Poncho', @supplierName = 'United Product Lines';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Crew Neck Sweatshirt', @supplierName = 'Franklin Peters Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Lip Balm', @supplierName = 'Birite Foodservice';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Alumni T-Shirt', @supplierName = 'Harris Corporation';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Dad Short Sleeve T-Shirt', @supplierName = 'Armon Communications';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @supplierName = 'Tipiak Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Wildcats Rambler 20 oz. Tumbler', @supplierName = 'Sportmaster International';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University OtterBox iPhone 7/8 Symmetry Series Case', @supplierName = 'E A I Electronic Assocs Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Wildcats State Decal', @supplierName = 'Warehouse Office & Paper Prod';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Mom Decal', @supplierName = 'Printing Dimensions';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Wildcats Decal', @supplierName = 'Printing Dimensions';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Putter Cover', @supplierName = 'United Product Lines';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Jersey', @supplierName = 'Franklin Peters Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Crew Socks', @supplierName = 'Smits, Patricia Garity';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Short Sleeve T-Shirt', @supplierName = 'Acme Supply Co';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University .75L Camelbak Bottle', @supplierName = 'Grace Pastries Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @supplierName = 'Knwz Products';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Coaches Hat', @supplierName = 'Roberts Supply Co Inc';
GO


----------------------------------
-- Enter OrderTable Table Data
----------------------------------
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'donette.foller@cox.net', @orderDateTime = '02/14/2023  7:18:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'mroyster@royster.com', @orderDateTime = '02/18/2023  5:54:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ernie_stenseth@aol.com', @orderDateTime = '01/19/2023  10:03:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jina_briddick@briddick.com', @orderDateTime = '01/21/2023  8:26:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'sabra@uyetake.org', @orderDateTime = '01/14/2023  9:16:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'brhym@rhym.com', @orderDateTime = '02/24/2023  8:14:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'viva.toelkes@gmail.com', @orderDateTime = '01/03/2023  8:49:00 PM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'dominque.dickerson@dickerson.org', @orderDateTime = '02/17/2023  10:36:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'latrice.tolfree@hotmail.com', @orderDateTime = '02/16/2023  1:54:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'stephaine@cox.net', @orderDateTime = '01/24/2023  2:50:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ernie_stenseth@aol.com', @orderDateTime = '01/8/2023  10:28:00 PM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'dominque.dickerson@dickerson.org', @orderDateTime = '01/20/2023  4:24:00 AM', @subTotal = NULL, @taxAmount = NULL, @shippingCost = NULL, @orderTotal = NULL;
go


-----------------------------------
--- Insert VendorProducts Table ---
-----------------------------------
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorProductPrice = '48', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'Yellow Weber State University 16 oz. Tumbler', @vendorProductPrice = '42', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'Weber State University Rain Poncho', @vendorProductPrice = '5.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Weber State University Alumni T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'Weber State University Wildcats State Decal', @vendorProductPrice = '6.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'Weber State University Putter Cover', @vendorProductPrice = '25', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Weber State University Crew Socks', @vendorProductPrice = '18', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'Weber State University Short Sleeve T-Shirt', @vendorProductPrice = '30', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @vendorProductPrice = '15.99', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Weber State University Coaches Hat', @vendorProductPrice = '25', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorProductPrice = '48', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'Yellow Weber State University 16 oz. Tumbler', @vendorProductPrice = '42', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Weber State University Rain Poncho', @vendorProductPrice = '5.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Weber State University Alumni T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'Weber State University Wildcats State Decal', @vendorProductPrice = '6.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Weber State University Putter Cover', @vendorProductPrice = '25', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'Weber State University Crew Socks', @vendorProductPrice = '18', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'Weber State University Short Sleeve T-Shirt', @vendorProductPrice = '30', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @vendorProductPrice = '15.99', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'Weber State University Coaches Hat', @vendorProductPrice = '25', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorProductPrice = '48', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Yellow Weber State University 16 oz. Tumbler', @vendorProductPrice = '42', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Weber State University Rain Poncho', @vendorProductPrice = '5.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'Weber State University Alumni T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Weber State University Wildcats State Decal', @vendorProductPrice = '6.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'Weber State University Putter Cover', @vendorProductPrice = '25', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'Weber State University Crew Socks', @vendorProductPrice = '18', @quantityOnHand = '10';
Go


-------------------------------
--- Insert OrderItems Table ---
-------------------------------
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt ', @vendorName = 'Eagle Software Inc ', @quantity = '1', @customerEmailAddress = 'donette.foller@cox.net',@orderDateTime = '02/14/2023  7:18:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Burton & Davis ', @quantity = '2', @customerEmailAddress = 'donette.foller@cox.net',@orderDateTime = '02/14/2023  7:18:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Jets Cybernetics ', @quantity = '4', @customerEmailAddress = 'mroyster@royster.com',@orderDateTime = '02/18/2023  5:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt ', @vendorName = 'Linguistic Systems Inc', @quantity = '2', @customerEmailAddress = 'mroyster@royster.com',@orderDateTime = '02/18/2023  5:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt ', @vendorName = 'Burton & Davis', @quantity = '1', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/19/2023  10:03:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Professionals Unlimited', @quantity = '3', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/19/2023  10:03:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Putter Cover ', @vendorName = 'Sidewinder Products Corp', @quantity = '3', @customerEmailAddress = 'jina_briddick@briddick.com',@orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Crew Socks ', @vendorName = 'Circuit Solution Inc ', @quantity = '2', @customerEmailAddress = 'jina_briddick@briddick.com',@orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Coaches Hat ', @vendorName = 'Eagle Software Inc ', @quantity = '3', @customerEmailAddress = 'jina_briddick@briddick.com',@orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt ', @vendorName = 'Price Business Services', @quantity = '2', @customerEmailAddress = 'sabra@uyetake.org',@orderDateTime = '01/14/2023  9:16:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Wildcats State Decal ', @vendorName = 'Mitsumi Electronics Corp', @quantity = '1', @customerEmailAddress = 'sabra@uyetake.org',@orderDateTime = '01/14/2023  9:16:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Burton & Davis ', @quantity = '4', @customerEmailAddress = 'brhym@rhym.com',@orderDateTime = '02/24/2023  8:14:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Putter Cover ', @vendorName = 'Sidewinder Products Corp', @quantity = '2', @customerEmailAddress = 'brhym@rhym.com',@orderDateTime = '02/24/2023  8:14:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt ', @vendorName = 'Eagle Software Inc ', @quantity = '1', @customerEmailAddress = 'viva.toelkes@gmail.com',@orderDateTime = '01/03/2023  8:49:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt ', @vendorName = 'Art Crafters ', @quantity = '2', @customerEmailAddress = 'viva.toelkes@gmail.com',@orderDateTime = '01/03/2023  8:49:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt ', @vendorName = 'Linguistic Systems Inc', @quantity = '2', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '02/17/2023  10:36:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Crew Socks ', @vendorName = 'Circuit Solution Inc ', @quantity = '1', @customerEmailAddress = 'latrice.tolfree@hotmail.com',@orderDateTime = '02/16/2023  1:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Professionals Unlimited', @quantity = '4', @customerEmailAddress = 'latrice.tolfree@hotmail.com',@orderDateTime = '02/16/2023  1:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt ', @vendorName = 'Eagle Software Inc ', @quantity = '1', @customerEmailAddress = 'stephaine@cox.net',@orderDateTime = '01/24/2023  2:50:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Jets Cybernetics ', @quantity = '2', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/8/2023  10:28:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt ', @vendorName = 'Linguistic Systems Inc', @quantity = '1', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/08/2023  10:28:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho ', @vendorName = 'Burton & Davis ', @quantity = '1', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '01/20/2023  4:24:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Putter Cover ', @vendorName = 'Price Business Services', @quantity = '2', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '01/20/2023  4:24:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Coaches Hat ', @vendorName = 'Eagle Software Inc ', @quantity = '1', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '01/20/2023  4:24:00 AM';
GO



SELECT 'This is table' AS 'Customer';
SELECT * FROM Customer;

SELECT 'This is table' AS 'Vendors';
SELECT * FROM Vendor;

SELECT 'This is table' AS 'Supplier';
SELECT * FROM Supplier;

SELECT 'This is table' AS 'Products';
SELECT * FROM Product;

SELECT 'This is table' AS 'OrderTable';
SELECT * FROM OrderTable;

SELECT 'This is table' AS 'VendorProduct';
SELECT * FROM VendorProduct;

SELECT 'This is table' AS 'OrderItems';
SELECT * FROM OrderItem;