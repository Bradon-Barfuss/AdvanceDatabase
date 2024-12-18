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


-----------------------------
-- Insert data into tables --
-----------------------------

-----------------------------
--- Insert Customer Table ---
-----------------------------
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('donette.foller@cox.net','Donette','Foller','34 Center St','Hamilton', 'OH', '45011');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('mroyster@royster.com','Maryann','Royster','74 S Westgate St','Albany', 'NY', '12204');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('ernie_stenseth@aol.com','Ernie','Stenseth','45 E Liberty St','Ridgefield Park', 'NJ', '07660');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('jina_briddick@briddick.com','Jina','Briddick','38938 Park Blvd','Boston', 'MA', '02128');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('sabra@uyetake.org','Sabra','Uyetake','98839 Hawthorne Blvd #6101','Columbia', 'SC', '29201');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('brhym@rhym.com','Bobbye','Rhym','30 W 80th St #1995','San Carlos', 'CA', '94070');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('viva.toelkes@gmail.com','Viva','Toelkes','4284 Dorigo Ln','Chicago', 'IL', '60647');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('dominque.dickerson@dickerson.org','Dominque','Dickerson','69 Marquette Ave','Hayward', 'CA', '94545');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('latrice.tolfree@hotmail.com','Latrice','Tolfree','81 Norris Ave #525','Ronkonkoma', 'NY', '11779');
INSERT INTO Customer (customerEmailAddress, customerFirstName, customerLastName,customerStreetAddress, customerCity, customerState, customerZip) 
VALUES ('stephaine@cox.net','Stephaine','Vinning','3717 Hamann Industrial Pky','San Francisco', 'CA', '94104');


-----------------------------
---- Insert Vendor Table ----
-----------------------------
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Eagle Software Inc','5384 Southwyck Blvd','Douglasville','GA','30135', 'info@eaglesoftwareinc.com', '7705078791');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Art Crafters','703 Beville Rd','Opa Locka','FL','33054', 'support@artcrafters.com', '3056709628');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Burton & Davis','70 Mechanic St','Northridge','CA','91325', 'helpdesk@burtondavis.com', '8188644875');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Jets Cybernetics','99586 Main St','Dallas','TX','75207', 'info@jetscybernetics.com', '2144282285');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Professionals Unlimited','66697 Park Pl #3224','Riverton','WY','82501', 'inquiry@professionalsunlimited.com', '3073427795');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Linguistic Systems Inc','506 S Hacienda Dr','Atlantic City','NJ','08401', 'help@linguisticsystemsinc.com', '6092285265');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Price Business Services','7 West Ave #1','Palatine','IL','60067', 'support@pricebusinessservices.com', '8472221734');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Mitsumi Electronics Corp','9677 Commerce Dr','Richmond','VA','23219', 'support@mitsumielectronicscorp.com', '8045505097');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Sidewinder Products Corp','8573 Lincoln Blvd','York','PA','17404', 'helpdesk@sidewinderproductscorp.com', '7178093119');
INSERT INTO Vendor (vendorName, vendorstreetaddress, vendorCity, vendorstate, vendorZip, vendoremailaddress, vendorPhone) VALUES ('Circuit Solution Inc','39 Moccasin Dr','San Francisco','CA','94104', 'answers@circuitsolutioninc.com', '4154111775');


-----------------------------
--- Insert Supplier Table ---
-----------------------------
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Printing Dimensions','34 Center St','Hamilton','OH','45011');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Franklin Peters Inc','74 S Westgate St','Albany','NY','12204');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Knwz Products','45 E Liberty St','Ridgefield Park','NJ','07660');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Grace Pastries Inc','38938 Park Blvd','Boston','MA','02128');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Lowy Products and Service','98839 Hawthorne Blvd #6101','Columbia','SC','29201');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Smits, Patricia Garity','30 W 80th St #1995','San Carlos','CA','94070');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Mark Iv Press','4284 Dorigo Ln','Chicago','IL','60647');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('E A I Electronic Assocs Inc','69 Marquette Ave','Hayward','CA','94545');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('United Product Lines','81 Norris Ave #525','Ronkonkoma','NY','11779');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Birite Foodservice','3717 Hamann Industrial Pky','San Francisco','CA','94104');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Roberts Supply Co Inc','8429 Miller Rd','Pelham','NY','10803');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Harris Corporation','4 Iwaena St','Baltimore','MD','21202');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Armon Communications','9 State Highway 57 #22','Jersey City','NJ','07306');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Tipiak Inc','80312 W 32nd St','Conroe','TX','77301');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Sportmaster International','6 Sunrise Ave','Utica','NY','13501');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Acme Supply Co','1953 Telegraph Rd','Saint Joseph','MO','64504');
INSERT INTO Supplier (supplierName, supplierStreetAddress, supplierCity, supplierState, supplierZip) VALUES ('Warehouse Office & Paper Prod','61556 W 20th Ave','Seattle','WA','98104');


-----------------------------
--- Insert Product Table ---
-----------------------------
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('White Weber State University Women''s Tank Top',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Printing Dimensions'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Black Weber State University Women''s Hooded Sweatshirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Franklin Peters Inc'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Steel Grey Weber State University Women''s Cropped Short Sleeve T-Shirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Knwz Products'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Yellow Weber State University 16 oz. Tumbler',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Lowy Products and Service'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Academic Year Planner',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Warehouse Office & Paper Prod'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('White Weber State University Orbiter Pen',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Smits, Patricia Garity'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Silver Weber State University Wildcats Keytag',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Mark Iv Press'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Silver Weber State University Money Clip',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Acme Supply Co'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Rain Poncho',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'United Product Lines'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Crew Neck Sweatshirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Franklin Peters Inc'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Lip Balm',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Birite Foodservice'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Alumni T-Shirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Harris Corporation'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Dad Short Sleeve T-Shirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Armon Communications'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Volleyball Short Sleeve T-Shirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Tipiak Inc'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Wildcats Rambler 20 oz. Tumbler',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Sportmaster International'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University OtterBox iPhone 7/8 Symmetry Series Case',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'E A I Electronic Assocs Inc'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Wildcats State Decal',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Warehouse Office & Paper Prod'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Mom Decal',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Printing Dimensions'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Wildcats Decal',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Printing Dimensions'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Putter Cover',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'United Product Lines'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Jersey',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Franklin Peters Inc'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Crew Socks',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Smits, Patricia Garity'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Short Sleeve T-Shirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Acme Supply Co'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University .75L Camelbak Bottle',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Grace Pastries Inc'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Knwz Products'));
INSERT INTO PRODUCT(productName, sdSupplier_id) VALUES ('Weber State University Coaches Hat',(SELECT sdSupplier_ID FROM Supplier WHERE supplierName = 'Roberts Supply Co Inc'));


--------------------------------
--- Insert OrderTable Table ---
-------------------------------
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES 
( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'donette.foller@cox.net'),
(SELECT convert(datetime,'02/14/2023  7:18:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'mroyster@royster.com'),(SELECT convert(datetime,'02/18/2023  5:54:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'ernie_stenseth@aol.com'),(SELECT convert(datetime,'01/19/2023  10:03:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'jina_briddick@briddick.com'),(SELECT convert(datetime,'01/21/2023  8:26:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'sabra@uyetake.org'),(SELECT convert(datetime,'01/14/2023  9:16:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'brhym@rhym.com'),(SELECT convert(datetime,'02/24/2023  8:14:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'viva.toelkes@gmail.com'),(SELECT convert(datetime,'01/03/2023  8:49:00 PM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'dominque.dickerson@dickerson.org'),(SELECT convert(datetime,'02/17/2023  10:36:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'latrice.tolfree@hotmail.com'),(SELECT convert(datetime,'02/16/2023  1:54:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'stephaine@cox.net'),(SELECT convert(datetime,'01/24/2023  2:50:00 AM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'ernie_stenseth@aol.com'),(SELECT convert(datetime,'01/8/2023  10:28:00 PM')),NULL,NULL,NULL,NULL);
INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount,shippingCost, orderTotal) VALUES ( (SELECT sdCustomer_id FROM customer where customerEmailaddress = 'dominque.dickerson@dickerson.org'),(SELECT convert(datetime,'01/20/2023  4:24:00 AM')),NULL,NULL,NULL,NULL);


-----------------------------------
--- Insert VendorProducts Table ---
-----------------------------------
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Eagle Software Inc'), (SELECT sdProduct_id FROM Product where productName = 'Black Weber State University Women''s Hooded Sweatshirt'), 10, (SELECT CONVERT (smallmoney, '19.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Art Crafters'), (SELECT sdProduct_id FROM Product where productName = 'Yellow Weber State University 16 oz. Tumbler'), 10, (SELECT CONVERT (smallmoney, '6.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Burton & Davis'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Rain Poncho'), 10, (SELECT CONVERT (smallmoney, '25')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Jets Cybernetics'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Alumni T-Shirt'), 10, (SELECT CONVERT (smallmoney, '18')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Professionals Unlimited'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Volleyball Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '30')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Linguistic Systems Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Wildcats State Decal'), 10, (SELECT CONVERT (smallmoney, '15.99')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Price Business Services'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Putter Cover'), 10, (SELECT CONVERT (smallmoney, '25')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Mitsumi Electronics Corp'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Crew Socks'), 10, (SELECT CONVERT (smallmoney, '48')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Sidewinder Products Corp'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '42')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Circuit Solution Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '5.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Eagle Software Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Coaches Hat'), 10, (SELECT CONVERT (smallmoney, '19.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Art Crafters'), (SELECT sdProduct_id FROM Product where productName = 'Black Weber State University Women''s Hooded Sweatshirt'), 10, (SELECT CONVERT (smallmoney, '19.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Burton & Davis'), (SELECT sdProduct_id FROM Product where productName = 'Yellow Weber State University 16 oz. Tumbler'), 10, (SELECT CONVERT (smallmoney, '6.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Jets Cybernetics'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Rain Poncho'), 10, (SELECT CONVERT (smallmoney, '25')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Professionals Unlimited'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Alumni T-Shirt'), 10, (SELECT CONVERT (smallmoney, '18')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Linguistic Systems Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Volleyball Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '30')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Price Business Services'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Wildcats State Decal'), 10, (SELECT CONVERT (smallmoney, '15.99')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Mitsumi Electronics Corp'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Putter Cover'), 10, (SELECT CONVERT (smallmoney, '25')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Sidewinder Products Corp'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Crew Socks'), 10, (SELECT CONVERT (smallmoney, '48')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Circuit Solution Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '42')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Eagle Software Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '5.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Art Crafters'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Coaches Hat'), 10, (SELECT CONVERT (smallmoney, '19.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Burton & Davis'), (SELECT sdProduct_id FROM Product where productName = 'Black Weber State University Women''s Hooded Sweatshirt'), 10, (SELECT CONVERT (smallmoney, '19.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Jets Cybernetics'), (SELECT sdProduct_id FROM Product where productName = 'Yellow Weber State University 16 oz. Tumbler'), 10, (SELECT CONVERT (smallmoney, '6.95')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Professionals Unlimited'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Rain Poncho'), 10, (SELECT CONVERT (smallmoney, '25')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Linguistic Systems Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Alumni T-Shirt'), 10, (SELECT CONVERT (smallmoney, '18')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Price Business Services'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Volleyball Short Sleeve T-Shirt'), 10, (SELECT CONVERT (smallmoney, '')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Mitsumi Electronics Corp'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Wildcats State Decal'), 10, (SELECT CONVERT (smallmoney, '')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Sidewinder Products Corp'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Putter Cover'), 10, (SELECT CONVERT (smallmoney, '')));
INSERT INTO VendorProduct (sdVendor_id, sdProduct_id, quantityOnHand, vendorProductPrice) VALUES ( (SELECT sdVendor_id FROM vendor where vendorName = 'Circuit Solution Inc'), (SELECT sdProduct_id FROM Product where productName = 'Weber State University Crew Socks'), 10, (SELECT CONVERT (smallmoney, '')));

-------------------------------
--- Insert OrderItems Table ---
-------------------------------
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) 
VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'donette.foller@cox.net')
AND orderDateTime = (Select convert (datetime, '02/14/2023  7:18:00 AM')))
, (Select sdProduct_id from product where ProductName = 'Black Weber State University Women''s Hooded Sweatshirt')
, (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Eagle Software Inc'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'donette.foller@cox.net')AND orderDateTime = (Select convert (datetime, '02/14/2023  7:18:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Burton & Davis'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'mroyster@royster.com')AND orderDateTime = (Select convert (datetime, '02/18/2023  5:54:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Jets Cybernetics'), '4');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'mroyster@royster.com')AND orderDateTime = (Select convert (datetime, '02/18/2023  5:54:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Volleyball Short Sleeve T-Shirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Linguistic Systems Inc'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'ernie_stenseth@aol.com')AND orderDateTime = (Select convert (datetime, '01/19/2023  10:03:00 AM'))), (Select sdProduct_id from product where ProductName = 'Black Weber State University Women''s Hooded Sweatshirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Burton & Davis'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'ernie_stenseth@aol.com')AND orderDateTime = (Select convert (datetime, '01/19/2023  10:03:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Professionals Unlimited'), '3');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'jina_briddick@briddick.com')AND orderDateTime = (Select convert (datetime, '01/21/2023  8:26:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Putter Cover'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Sidewinder Products Corp'), '3');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'jina_briddick@briddick.com')AND orderDateTime = (Select convert (datetime, '01/21/2023  8:26:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Crew Socks'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Circuit Solution Inc'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'jina_briddick@briddick.com')AND orderDateTime = (Select convert (datetime, '01/21/2023  8:26:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Coaches Hat'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Eagle Software Inc'), '3');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'sabra@uyetake.org')AND orderDateTime = (Select convert (datetime, '01/14/2023  9:16:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Volleyball Short Sleeve T-Shirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Price Business Services'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'sabra@uyetake.org')AND orderDateTime = (Select convert (datetime, '01/14/2023  9:16:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Wildcats State Decal'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Mitsumi Electronics Corp'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'brhym@rhym.com')AND orderDateTime = (Select convert (datetime, '02/24/2023  8:14:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Burton & Davis'), '4');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'brhym@rhym.com')AND orderDateTime = (Select convert (datetime, '02/24/2023  8:14:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Putter Cover'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Sidewinder Products Corp'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'viva.toelkes@gmail.com')AND orderDateTime = (Select convert (datetime, '01/03/2023  8:49:00 PM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Eagle Software Inc'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'viva.toelkes@gmail.com')AND orderDateTime = (Select convert (datetime, '01/03/2023  8:49:00 PM'))), (Select sdProduct_id from product where ProductName = 'Black Weber State University Women''s Hooded Sweatshirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Art Crafters'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'dominque.dickerson@dickerson.org')AND orderDateTime = (Select convert (datetime, '02/17/2023  10:36:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Volleyball Short Sleeve T-Shirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Linguistic Systems Inc'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'latrice.tolfree@hotmail.com')AND orderDateTime = (Select convert (datetime, '02/16/2023  1:54:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Crew Socks'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Circuit Solution Inc'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'latrice.tolfree@hotmail.com')AND orderDateTime = (Select convert (datetime, '02/16/2023  1:54:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Professionals Unlimited'), '4');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'stephaine@cox.net')AND orderDateTime = (Select convert (datetime, '01/24/2023  2:50:00 AM'))), (Select sdProduct_id from product where ProductName = 'Black Weber State University Women''s Hooded Sweatshirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Eagle Software Inc'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'ernie_stenseth@aol.com')AND orderDateTime = (Select convert (datetime, '01/8/2023  10:28:00 PM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Jets Cybernetics'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'ernie_stenseth@aol.com')AND orderDateTime = (Select convert (datetime, '01/08/2023  10:28:00 PM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Volleyball Short Sleeve T-Shirt'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Linguistic Systems Inc'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'dominque.dickerson@dickerson.org')AND orderDateTime = (Select convert (datetime, '01/20/2023  4:24:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Rain Poncho'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Burton & Davis'), '1');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'dominque.dickerson@dickerson.org')AND orderDateTime = (Select convert (datetime, '01/20/2023  4:24:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Putter Cover'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Price Business Services'), '2');
INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) VALUES ( (select sdOrderTable_id FROM OrderTable where sdCustomer_id =(Select sdCustomer_id from customer where customerEmailAddress = 'dominque.dickerson@dickerson.org')AND orderDateTime = (Select convert (datetime, '01/20/2023  4:24:00 AM'))), (Select sdProduct_id from product where ProductName = 'Weber State University Coaches Hat'), (SELECT sdVendor_id FROM Vendor WHERE vendorName = 'Eagle Software Inc'), '1');

SELECT 'This is table' AS 'Customer';
SELECT * FROM Customer;

SELECT 'This is table' AS 'Vendors';
SELECT * FROM Vendor;

SELECT 'This is table' AS 'Supplier';
SELECT * FROM Supplier;

SELECT 'This is table' AS 'Products';
SELECT * FROM Product;

SELECT 'This is table' AS 'VendorProduct';
SELECT * FROM VendorProduct;

SELECT 'This is table' AS 'OrderItems';
SELECT * FROM OrderItem;