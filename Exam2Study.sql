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
GO

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

IF EXISTS(SELECT * FROM sys.tables WHERE Name = N'StateTax')
DROP TABLE StateTax;

IF EXISTS(SELECT * FROM sys.tables WHERE Name = N'ZipCodes')
DROP TABLE ZipCodes;

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
	, vendorProductPrice	smallmoney		NOT NULL
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

CREATE TABLE ZIPCODES (
  Zipcode NVARCHAR(5) NOT NULL
, City NVARCHAR(50) NOT NULL
, [State] NVARCHAR(2) NOT NULL
, Latitude float
, Longitude float
);

CREATE TABLE STATETAX (
  [State] NVARCHAR(2) NOT NULL
, TaxRate decimal(5,4) NOT NULL
);

GO


-------------------------------------------
-- CREATE Primary Keys
-------------------------------------------

ALTER TABLE ZIPCODES
	ADD Constraint PK_Zipcode
	PRIMARY KEY (Zipcode);

ALTER TABLE STATETAX 
	ADD CONSTRAINT PK_State
	PRIMARY KEY ([State]);

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
	CHECK (upper(customerState) = customerState collate Latin1_General_BIN2);

alter table Vendor
	ADD CONSTRAINT CK_Vendor_State
	CHECK (upper(vendorState) = vendorState collate Latin1_General_BIN2);

alter table Supplier
	ADD CONSTRAINT CK_Supplier_State
	CHECK (upper(supplierState) = supplierState collate Latin1_General_BIN2);

GO


 



---------------------------------------
------ Create Functions ---------------
---------------------------------------


--------------------------------
--- Create udf_getCustomerID ---
--------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getCustomerID'))
DROP Function [dbo].udf_getCustomerID;
GO

CREATE FUNCTION [dbo].udf_getCustomerID (@customerEmailAddress NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdCustomer_id INT; -- internal variable

Select @sdCustomer_id = sdCustomer_id
FROM Customer
WHERE customerEmailAddress = @customerEmailAddress

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdCustomer_id IS NULL
SET @sdCustomer_id = -1

RETURN @sdCustomer_id
END

GO

-------------------------------
--- Create udf_getOrderDate ---
-------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getOrderDate'))
DROP Function [dbo].udf_getOrderDate;

GO

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


--------------------------------
--- Create udf_getVendorID ---
--------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getVendorID'))
DROP Function [dbo].udf_getVendorID;

GO

CREATE FUNCTION [dbo].udf_getVendorID (@vendorName NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdVendor_id INT; -- internal variable

Select @sdVendor_id = sdVendor_id
FROM Vendor
WHERE vendorName = @vendorName

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdVendor_id IS NULL
SET @sdVendor_id = -1

RETURN @sdVendor_id
END

GO

--------------------------------
--- Create udf_getProductID ---
--------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getProductID'))
DROP Function [dbo].udf_getProductID;

GO

CREATE FUNCTION [dbo].udf_getProductID (@productName NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdProduct_id INT; -- internal variable

Select @sdProduct_id = sdProduct_id
FROM Product
WHERE productName = @productName

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdProduct_id IS NULL
SET @sdProduct_id = -1

RETURN @sdProduct_id
END

GO


--------------------------------
--- Create udf_getSupplierID ---
--------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getSupplierID'))
DROP Function [dbo].udf_getSupplierID;

GO

CREATE FUNCTION [dbo].udf_getSupplierID (@supplierName NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdSupplier_id INT; -- internal variable

Select @sdSupplier_id = sdSupplier_id
FROM Supplier
WHERE supplierName = @supplierName

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdSupplier_id IS NULL
SET @sdSupplier_id = -1

RETURN @sdSupplier_id
END

GO


--------------------------------
--- Create udf_getOrderTableID ---
--------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getOrderTableID'))
DROP Function [dbo].udf_getOrderTableID;

GO

CREATE FUNCTION [dbo].udf_getOrderTableID (@customerEmailAddress NVARCHAR(255), @orderDateTime NVARCHAR(50)) --the parentheses are variable put into the function
RETURNS INT -- return type
AS
BEGIN

DECLARE @sdOrderTable_id INT; -- internal variable

Select @sdOrderTable_id = sdOrderTable_id
FROM OrderTable
WHERE sdCustomer_id = [dbo].udf_getCustomerID (@customerEmailAddress)
AND orderDateTime = [dbo].udf_getOrderDate (@orderDateTime)

-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @sdOrderTable_id IS NULL
SET @sdOrderTable_id = -1

RETURN @sdOrderTable_id
END

GO


----------------------------
--- getLatitude Function ---
----------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_id(N'udf_getLatitude'))
DROP FUNCTION [dbo].udf_getLatitude;
GO

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

---------------------------------
--- udf_getLongitude Function ---
---------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_id(N'udf_getLongitude'))
DROP FUNCTION [dbo].udf_getLongitude
GO

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


--------------------------------
--- getCustomerZip Function ---
--------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getCustomerZip'))
DROP FUNCTION [dbo].udf_getCustomerZip;
GO

CREATE FUNCTION [dbo].udf_getCustomerZip (@customerEmailAddress NVARCHAR(255)) --the parentheses are variable put into the function
RETURNS NVARCHAR(9) -- return type
AS
BEGIN

DECLARE @customerZipcode NVARCHAR(9); -- internal variable

	set @customerZipcode = 
		(select customerZip from customer  --I CHANGED @customerZipcode to customerZipcode, so that may cause a error 3/13!!!!!!!
		where customerEmailAddress = @customerEmailAddress)


-- If we don't get a value (if it is null) change the it to -1, which is a error
IF @customerZipcode IS NULL
SET @customerZipcode = '00000'

RETURN @customerZipcode
END

GO

-----------------------------
--- udf_calculateShippingCost ---
-----------------------------
IF exists (select * from sysobjects where id = OBJECT_ID(N'udf_calculateShippingCost'))
DROP FUNCTION [dbo].udf_calculateShippingCost;
GO

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

-----------------------
--- udf_getOrderTax ---
-----------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getOrderTax'))
DROP FUNCTION [dbo].udf_getOrderTax;
GO

CREATE FUNCTION [dbo].udf_getOrderTax (@customerEmailAddress NVARCHAR(255))

RETURNS smallMoney

AS BEGIN 
	DECLARE @orderTax smallmoney;

	SET @orderTax = 
		(SELECT taxrate from StateTax
		where [state] = 
			(select customerState from Customer 
			where customerEmailAddress = @customerEmailAddress))

IF @orderTax IS NULL
SET @orderTax = -1

RETURN @orderTax
END
GO

-------------------------------------
--- udf_getVendorZipCode function ---
-------------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'udf_getVendorZipCode'))
DROP FUNCTION [dbo].udf_getVendorZipCode;
GO

CREATE FUNCTION [dbo].udf_getVendorZipCode(@customerEmailAddress NVARCHAR(255), @orderDateTime NVARCHAR(50))

RETURNS NVARCHAR(9)

AS BEGIN
	DECLARE @vendorZipcode NVARCHAR(9);

	set @vendorZipcode = 
		(select top 1 vendorZip from vendor V
		inner join vendorproduct vp 
		on v.sdvendor_id = vp.sdvendor_id
		inner join orderitem oi
		on oi.sdProduct_id = vp.sdProduct_id and oi.sdvendor_id = vp.sdvendor_id
		inner join ordertable ot
		on ot.sdordertable_id = oi.sdordertable_id
		where ot.sdcustomer_id =
			(SELECT [dbo].udf_getCustomerID(@customerEmailAddress))
			and ot.orderDateTime = (select [dbo].udf_getOrderDate(@orderDateTime))
		)

	IF @vendorZipcode IS NULL
	set @vendorzipcode = '00000'
	
	return @vendorzipcode
END
GO


------------------------
--- udf_calculateTax ---
------------------------
-- [dbo].udf_calculateTax(@customerState, @subtotal)
IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].udf_calculateTax'))
	DROP FUNCTION [dbo].udf_calculateTax;
GO


CREATE FUNCTION [dbo].udf_calculateTax (@customerState NVARCHAR(2), @subtotal SMALLMONEY)
	RETURNS SMALLMONEY
	AS
	BEGIN
		DECLARE
			@taxAmount SMALLMONEY
			, @taxRate decimal(5,4)

		SELECT @taxRate = taxRate
		FROM StateTax st
		INNER JOIN customer C
		ON st.State = c.customerState
		WHERE [state] = @customerState

		SET @taxAmount = @subTotal * @taxRate;

		IF @taxAmount IS NULL
		SET @taxAmount = -1;

		RETURN @taxAmount;
	END
GO






-----------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------- CREATE PROCEDURES----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------
--- usp_calculateSubtotal ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_calculateSubtotal')
DROP PROCEDURE [dbo].usp_calculateSubtotal;
GO

CREATE PROCEDURE [dbo].usp_calculateSubtotal 
@customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)

AS BEGIN
BEGIN TRY

UPDATE OrderTable
Set subTotal = orderItem.total
from OrderTable
INNER JOIN
	(
		SELECT sdOrderTable_id, SUM(quantity * VendorProductPrice) AS total
		from orderItem oi
		inner join vendorProduct vp
		on oi.sdvendor_id= vp.sdvendor_id
		and oi.sdproduct_id = vp.sdproduct_id
		WHERE sdOrderTable_id = ([dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime))
		GROUP BY sdOrderTable_id
	) OrderItem
	ON ordertable.sdOrderTable_id = orderItem.sdOrderTable_id
	END TRY

BEGIN CATCH
PRINT 'The Get Order Subtotal Procedure failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END
GO

------------------------------
--- usp_calculateTaxAmount ---
------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_calculateTaxAmount')
	DROP PROCEDURE usp_calculateTaxAmount
GO

CREATE PROCEDURE usp_calculateTaxAmount
	@customerEmailAddress NVARCHAR(255)
	, @orderDateTime NVARCHAR(50)


	AS BEGIN
	BEGIN TRY
		UPDATE OrderTable
		SET OrderTable.taxAmount = ROUND(dbo.udf_calculateTax(c.customerState, ot.subTotal),2)
		FROM OrderTable ot
		INNER JOIN Customer c
		on ot.sdCustomer_id = c.sdCustomer_id
		WHERE ot.sdOrderTable_id = [dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime)
	END TRY

BEGIN CATCH 
PRINT 'The Calculate Tax failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END

GO

--------------------------
--- usp_calculateTotal ---
--------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_calculateTotal')
	DROP PROCEDURE usp_calculateTotal;
GO

CREATE PROCEDURE usp_calculateTotal
@customerEmailAddress NVARCHAR(255)
, @OrderDateTime NVARCHAR(50)

AS
BEGIN

BEGIN TRY
	UPDATE OrderTable
	SET orderTotal = ROUND((ShippingCost + taxAmount + subTotal), 2) --use previous functions to get these values
	WHERE orderTable.sdOrderTable_id = [dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime)
END TRY

	BEGIN CATCH
		PRINT 'The calculate Total failed for:
				customerEmailAddress: ' + @customerEmailAddress +
				'OrderDateTime: ' + @orderDateTime +
				', Message: ' + ERROR_MESSAGE()

		END CATCH
	END
GO

--------------------------
--- usp_calculateShippingCost ---
--------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_calculateShippingCost')
	DROP PROCEDURE usp_calculateShippingCost;
GO

CREATE PROCEDURE usp_calculateShippingCost
@customerEmailAddress NVARCHAR(255)
, @OrderDateTime NVARCHAR(50)

AS
BEGIN

BEGIN TRY
	UPDATE OrderTable
	SET shippingcost = [dbo].udf_calculateShippingCost([dbo].udf_getCustomerZip(@customerEmailAddress)
					, [dbo].udf_getVendorZipCode(@customerEmailAddress, @orderDateTime))
	WHERE orderTable.sdOrderTable_id = [dbo].udf_getOrderTableID(@customerEmailAddress, @orderDateTime)
END TRY

	BEGIN CATCH
		PRINT 'The calshipping calculate Total failed for:
				customerEmailAddress: ' + @customerEmailAddress +
				'OrderDateTime: ' + @orderDateTime +
				', Message: ' + ERROR_MESSAGE()

		END CATCH
	END
GO


-----------------------
--- usp_updateOrder ---
-----------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_completeOrder')
	DROP PROCEDURE usp_completeOrder;
GO
CREATE PROCEDURE usp_completeOrder
	@customerEmailAddress NVARCHAR(255)
	, @orderDateTime NVARCHAR(255)

	AS
	BEGIN TRY
	--
	DECLARE @orderTableID INT;
	SET @orderTableID = dbo.udf_getOrderTableID(@customerEmailAddress, @orderDateTime);

	IF (SELECT COUNT(*)
	FROM orderItem
	WHERE sdOrderTable_id = @orderTableID) = 0
		BEGIN
			Print 'The Order is empty and must be deleted for customer: ' + @customerEmailAddress + 'and Order Date Time: ' + @orderDateTime
			DELETE FROM OrderTable
			WHERE sdOrderTable_id = @orderTableID
		END
Else
	BEGIN
		EXECUTE [dbo].usp_calculateSubtotal @customerEmailAddress, @orderDateTime;

		EXECUTE [dbo].usp_calculateTaxAmount @customerEmailAddress, @orderDateTime;

		EXECUTE [dbo].usp_calculateShippingCost @customerEmailAddress, @orderDateTime;

		EXECUTE [dbo].usp_calculateTotal @customerEmailAddress, @orderDateTime;
	END

END TRY
	BEGIN CATCH
		PRINT 'The UPDATE OF THE orderTable failed for: 
		customerEmailAddress: ' + @customerEmailAddress
		+ ', orderDateTime: ' + @orderDateTime
		+ ', message: ' + ERROR_MESSAGE()
	END CATCH
GO








-------------------------------------------------------
--- Create usp_getCustomerLatitude Stored Procedure ---
-------------------------------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_getCustomerLatitude')
DROP PROCEDURE [dbo].usp_getCustomerLatitude;
GO

CREATE PROCEDURE [dbo].usp_getCustomerLatitude
@customerEmailAddress NVARCHAR(255)

AS
BEGIN
DECLARE @customerLatitude FLOAT;

BEGIN TRY
	SELECT @customerLatitude = [dbo].udf_getLatitude([dbo].udf_getCustomerZip(@customerEmailAddress))
END TRY

BEGIN CATCH
PRINT 'The Customer Latitude Procedure Failed for: 
CustomerEmailAddress: ' + @customerEmailAddress
+ ' Error Message: ' + ERROR_MESSAGE();

END CATCH
END

GO

-------------------------------------------------------
--- Create usp_getCustomerLongitude Stored Procedure ---
-------------------------------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_getCustomerLongitude')
DROP PROCEDURE [dbo].usp_getCustomerLongitude;
GO

CREATE PROCEDURE [dbo].usp_getCustomerLongitude
@customerEmailAddress NVARCHAR(255)

AS
BEGIN
DECLARE @customerLongitude FLOAT;

BEGIN TRY
	SELECT @customerLongitude = [dbo].udf_getLongitude([dbo].udf_getCustomerZip(@customerEmailAddress))
END TRY

BEGIN CATCH
PRINT 'The Customer Longitude Procedure Failed for: 
CustomerEmailAddress: ' + @customerEmailAddress
+ ' Error Message: ' + ERROR_MESSAGE();

END CATCH
END

GO

-------------------------------------------------------
--- Create usp_getVendorLatitude Stored Procedure ---
-------------------------------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_getVendorLatitude')
DROP PROCEDURE [dbo].usp_getVendorLatitude;
GO

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

-------------------------------------------------------
--- Create usp_getVendorLongitude Stored Procedure ---
-------------------------------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_getVendorLongitude')
DROP PROCEDURE [dbo].usp_getVendorLongitude;
GO

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

-----------------------------
--- Add Customer Procedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddCustomer')
DROP PROCEDURE [dbo].usp_AddCustomer;
GO

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


-----------------------------
--- Add Vendor Procedure ---
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
--- Add Supplier Procedure ---
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
--- Add Product Procedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddProduct')
DROP PROCEDURE dbo.usp_AddProduct;
GO

CREATE PROCEDURE dbo.usp_AddProduct --- usp: user stored procedure
@productName NVARCHAR(255)
, @supplierName NVARCHAR(50)

AS
BEGIN

BEGIN TRY

INSERT INTO Product (productName, sdSupplier_id) 
VALUES (
	@productName
	,[dbo].udf_getSupplierID (@supplierName)
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


-----------------------------
--- Order Table Procedure ---
-----------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddOrder')
DROP PROCEDURE dbo.usp_AddOrder;
GO

CREATE PROCEDURE dbo.usp_AddOrder --- usp: user stored procedure

@customerEmailAddress NVARCHAR(255) --the sdCustomerId Alternate key 
, @orderDateTime NVARCHAR(50)

AS
BEGIN

BEGIN TRY

INSERT INTO Ordertable (sdCustomer_id, orderDateTime, subTotal, taxAmount, shippingCost, orderTotal) 
VALUES (
	[dbo].udf_getCustomerID (@customerEmailAddress)
	, [dbo].udf_getOrderDate (@orderDateTime)
	, NULL
	, NULL
	, NULL
	, NULL
	); 

END TRY

BEGIN CATCH 
PRINT 'The INSERT INTO OrderTable failed for: 
customerEmailAddress: ' + @customerEmailAddress
+ ', orderDateTime: ' + @orderDateTime
+ ', error message: ' + ERROR_MESSAGE();

END CATCH
END 

GO

-----------------------------------
--- Add VendorProduct Procedure ---
-----------------------------------
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
	[dbo].udf_getVendorID (@vendorName)
	--(SELECT sdVendor_id FROM vendor WHERE vendorName = @vendorName)
	, [dbo].udf_getProductID (@productName)
	--(SELECT sdProduct_id FROM product WHERE productName = @productName)
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


--------------------------------
--- Add OrderItems Procedure ---
--------------------------------
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = N'usp_AddOrderItems')
DROP PROCEDURE dbo.usp_AddOrderItems;
GO

CREATE PROCEDURE dbo.usp_AddOrderItems --- usp: user stored procedure
@productName NVARCHAR(255)
, @vendorName NVARCHAR(50)
, @quantity NVARCHAR(255)
, @customerEmailAddress NVARCHAR(255)
, @orderDateTime NVARCHAR(50)


AS
BEGIN

	DECLARE @availableQuantity INT;
	DECLARE @sdvendor_id INT;
	DECLARE @sdproduct_id INT;

	SET @sdVendor_id = ([dbo].udf_getvendorID (@vendorName));
	SET @sdProduct_id = ([dbo].udf_getProductId (@productname));

	select @availablequantity = quantityonhand
	from vendorproduct
	where sdvendor_id = @sdvendor_id
	and sdproduct_id = @sdproduct_id
BEGIN TRY
if(@availableQuantity - (SELECT CONVERT(INT, @quantity))) < 0
RAISERROR ('The vendor does not have enought of this product in stock to complete this order. ' , 16,1); -- 16 is error message 


INSERT INTO OrderItem (sdOrderTable_id, sdProduct_id, sdVendor_id, quantity) 
VALUES (
	[dbo].udf_getOrderTableID (@customerEmailAddress, @orderDateTime)
	, [dbo].udf_getProductID (@productName)
	, [dbo].udf_getVendorID (@vendorName)
	, (SELECT Convert (int, @quantity))
	); 

	UPDATE VendorProduct
	set quantityOnHand = quantityOnHand - (select convert(int, @quantity))
	where sdvendor_id = @sdvendor_id
	and sdproduct_id = @sdproduct_id

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
INSERT INTO StateTax(State, TaxRate) VALUES ('AL',0.07);
INSERT INTO StateTax(State, TaxRate) VALUES ('AK',0);
INSERT INTO StateTax(State, TaxRate) VALUES ('AZ',0.056);
INSERT INTO StateTax(State, TaxRate) VALUES ('AR',0.065);
INSERT INTO StateTax(State, TaxRate) VALUES ('CA',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('CO',0.029);
INSERT INTO StateTax(State, TaxRate) VALUES ('CT',0.0635);
INSERT INTO StateTax(State, TaxRate) VALUES ('DE',0);
INSERT INTO StateTax(State, TaxRate) VALUES ('FL',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('GA',0.04);
INSERT INTO StateTax(State, TaxRate) VALUES ('HI',0.04);
INSERT INTO StateTax(State, TaxRate) VALUES ('ID',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('IL',0.0625);
INSERT INTO StateTax(State, TaxRate) VALUES ('IN',0.07);
INSERT INTO StateTax(State, TaxRate) VALUES ('IA',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('KS',0.065);
INSERT INTO StateTax(State, TaxRate) VALUES ('KY',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('LA',0.0445);
INSERT INTO StateTax(State, TaxRate) VALUES ('ME',0.055);
INSERT INTO StateTax(State, TaxRate) VALUES ('MD',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('MA',0.056);
INSERT INTO StateTax(State, TaxRate) VALUES ('MI',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('MN',0.0688);
INSERT INTO StateTax(State, TaxRate) VALUES ('MS',0.07);
INSERT INTO StateTax(State, TaxRate) VALUES ('MO',0.0423);
INSERT INTO StateTax(State, TaxRate) VALUES ('MT',0);
INSERT INTO StateTax(State, TaxRate) VALUES ('NE',0.055);
INSERT INTO StateTax(State, TaxRate) VALUES ('NV',0.046);
INSERT INTO StateTax(State, TaxRate) VALUES ('NH',0);
INSERT INTO StateTax(State, TaxRate) VALUES ('NJ',0.0663);
INSERT INTO StateTax(State, TaxRate) VALUES ('NM',0.0513);
INSERT INTO StateTax(State, TaxRate) VALUES ('NY',0.04);
INSERT INTO StateTax(State, TaxRate) VALUES ('NC',0.0475);
INSERT INTO StateTax(State, TaxRate) VALUES ('ND',0.05);
INSERT INTO StateTax(State, TaxRate) VALUES ('OH',0.0575);
INSERT INTO StateTax(State, TaxRate) VALUES ('OK',0.045);
INSERT INTO StateTax(State, TaxRate) VALUES ('OR',0);
INSERT INTO StateTax(State, TaxRate) VALUES ('PA',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('RI',0.07);
INSERT INTO StateTax(State, TaxRate) VALUES ('SC',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('SD',0.045);
INSERT INTO StateTax(State, TaxRate) VALUES ('TN',0.07);
INSERT INTO StateTax(State, TaxRate) VALUES ('TX',0.0625);
INSERT INTO StateTax(State, TaxRate) VALUES ('UT',0.047);
INSERT INTO StateTax(State, TaxRate) VALUES ('VT',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('VA',0.043);
INSERT INTO StateTax(State, TaxRate) VALUES ('WA',0.065);
INSERT INTO StateTax(State, TaxRate) VALUES ('WV',0.06);
INSERT INTO StateTax(State, TaxRate) VALUES ('WI',0.05);
INSERT INTO StateTax(State, TaxRate) VALUES ('WY',0.04);
GO


-- Enter Customer Table Data
----------------------------------
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'noah.kalafatis@aol.com', @customerFirstName = 'Noah', @customerLastName = 'Kalafatis', @customerStreetAddress = '1950 5th Ave', @customerCity = 'Milwaukee', @customerState = 'WI', @customerZip = '53209';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'csweigard@sweigard.com', @customerFirstName = 'Carmen', @customerLastName = 'Sweigard', @customerStreetAddress = '61304 N French Rd', @customerCity = 'Somerset', @customerState = 'NJ', @customerZip = '08873';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lavonda@cox.net', @customerFirstName = 'Lavonda', @customerLastName = 'Hengel', @customerStreetAddress = '87 Imperial Ct #79', @customerCity = 'Fargo', @customerState = 'ND', @customerZip = '58102';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'junita@aol.com', @customerFirstName = 'Junita', @customerLastName = 'Stoltzman', @customerStreetAddress = '94 W Dodge Rd', @customerCity = 'Carson City', @customerState = 'NV', @customerZip = '89701';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'herminia@nicolozakes.org', @customerFirstName = 'Herminia', @customerLastName = 'Nicolozakes', @customerStreetAddress = '4 58th St #3519', @customerCity = 'Scottsdale', @customerState = 'AZ', @customerZip = '85254';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'casie.good@aol.com', @customerFirstName = 'Casie', @customerLastName = 'Good', @customerStreetAddress = '5221 Bear Valley Rd', @customerCity = 'Nashville', @customerState = 'TN', @customerZip = '37211';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'reena@hotmail.com', @customerFirstName = 'Reena', @customerLastName = 'Maisto', @customerStreetAddress = '9648 S Main', @customerCity = 'Salisbury', @customerState = 'MD', @customerZip = '21801';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'mirta_mallett@gmail.com', @customerFirstName = 'Mirta', @customerLastName = 'Mallett', @customerStreetAddress = '7 S San Marcos Rd', @customerCity = 'New York', @customerState = 'NY', @customerZip = '10004';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'cathrine.pontoriero@pontoriero.com', @customerFirstName = 'Cathrine', @customerLastName = 'Pontoriero', @customerStreetAddress = '812 S Haven St', @customerCity = 'Amarillo', @customerState = 'TX', @customerZip = '79109';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'ftawil@hotmail.com', @customerFirstName = 'Filiberto', @customerLastName = 'Tawil', @customerStreetAddress = '3882 W Congress St #799', @customerCity = 'Los Angeles', @customerState = 'CA', @customerZip = '90016';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'rupthegrove@yahoo.com', @customerFirstName = 'Raul', @customerLastName = 'Upthegrove', @customerStreetAddress = '4 E Colonial Dr', @customerCity = 'La Mesa', @customerState = 'CA', @customerZip = '91942';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'sarah.candlish@gmail.com', @customerFirstName = 'Sarah', @customerLastName = 'Candlish', @customerStreetAddress = '45 2nd Ave #9759', @customerCity = 'Atlanta', @customerState = 'GA', @customerZip = '30328';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lucy@cox.net', @customerFirstName = 'Lucy', @customerLastName = 'Treston', @customerStreetAddress = '57254 Brickell Ave #372', @customerCity = 'Worcester', @customerState = 'MA', @customerZip = '01602';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jaquas@aquas.com', @customerFirstName = 'Judy', @customerLastName = 'Aquas', @customerStreetAddress = '8977 Connecticut Ave Nw #3', @customerCity = 'Niles', @customerState = 'MI', @customerZip = '49120';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'yvonne.tjepkema@hotmail.com', @customerFirstName = 'Yvonne', @customerLastName = 'Tjepkema', @customerStreetAddress = '9 Waydell St', @customerCity = 'Fairfield', @customerState = 'NJ', @customerZip = '07004';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kayleigh.lace@yahoo.com', @customerFirstName = 'Kayleigh', @customerLastName = 'Lace', @customerStreetAddress = '43 Huey P Long Ave', @customerCity = 'Lafayette', @customerState = 'LA', @customerZip = '70508';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'felix_hirpara@cox.net', @customerFirstName = 'Felix', @customerLastName = 'Hirpara', @customerStreetAddress = '7563 Cornwall Rd #4462', @customerCity = 'Denver', @customerState = 'PA', @customerZip = '17517';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'tresa_sweely@hotmail.com', @customerFirstName = 'Tresa', @customerLastName = 'Sweely', @customerStreetAddress = '22 Bridle Ln', @customerCity = 'Valley Park', @customerState = 'MO', @customerZip = '63088';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kristeen@gmail.com', @customerFirstName = 'Kristeen', @customerLastName = 'Turinetti', @customerStreetAddress = '70099 E North Ave', @customerCity = 'Arlington', @customerState = 'TX', @customerZip = '76013';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jregusters@regusters.com', @customerFirstName = 'Jenelle', @customerLastName = 'Regusters', @customerStreetAddress = '3211 E Northeast Loop', @customerCity = 'Tampa', @customerState = 'FL', @customerZip = '33619';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'renea@hotmail.com', @customerFirstName = 'Renea', @customerLastName = 'Monterrubio', @customerStreetAddress = '26 Montgomery St', @customerCity = 'Atlanta', @customerState = 'GA', @customerZip = '30328';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'olive@aol.com', @customerFirstName = 'Olive', @customerLastName = 'Matuszak', @customerStreetAddress = '13252 Lighthouse Ave', @customerCity = 'Cathedral City', @customerState = 'CA', @customerZip = '92234';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lreiber@cox.net', @customerFirstName = 'Ligia', @customerLastName = 'Reiber', @customerStreetAddress = '206 Main St #2804', @customerCity = 'Lansing', @customerState = 'MI', @customerZip = '48933';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'christiane.eschberger@yahoo.com', @customerFirstName = 'Christiane', @customerLastName = 'Eschberger', @customerStreetAddress = '96541 W Central Blvd', @customerCity = 'Phoenix', @customerState = 'AZ', @customerZip = '85034';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'goldie.schirpke@yahoo.com', @customerFirstName = 'Goldie', @customerLastName = 'Schirpke', @customerStreetAddress = '34 Saint George Ave #2', @customerCity = 'Bangor', @customerState = 'ME', @customerZip = '04401';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'loreta.timenez@hotmail.com', @customerFirstName = 'Loreta', @customerLastName = 'Timenez', @customerStreetAddress = '47857 Coney Island Ave', @customerCity = 'Clinton', @customerState = 'MD', @customerZip = '20735';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'fabiola.hauenstein@hauenstein.org', @customerFirstName = 'Fabiola', @customerLastName = 'Hauenstein', @customerStreetAddress = '8573 Lincoln Blvd', @customerCity = 'York', @customerState = 'PA', @customerZip = '17404';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'amie.perigo@yahoo.com', @customerFirstName = 'Amie', @customerLastName = 'Perigo', @customerStreetAddress = '596 Santa Maria Ave #7913', @customerCity = 'Mesquite', @customerState = 'TX', @customerZip = '75150';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'raina.brachle@brachle.org', @customerFirstName = 'Raina', @customerLastName = 'Brachle', @customerStreetAddress = '3829 Ventura Blvd', @customerCity = 'Butte', @customerState = 'MT', @customerZip = '59701';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'erinn.canlas@canlas.com', @customerFirstName = 'Erinn', @customerLastName = 'Canlas', @customerStreetAddress = '13 S Hacienda Dr', @customerCity = 'Livingston', @customerState = 'NJ', @customerZip = '07039';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'cherry@lietz.com', @customerFirstName = 'Cherry', @customerLastName = 'Lietz', @customerStreetAddress = '40 9th Ave Sw #91', @customerCity = 'Waterford', @customerState = 'MI', @customerZip = '48329';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kattie@vonasek.org', @customerFirstName = 'Kattie', @customerLastName = 'Vonasek', @customerStreetAddress = '2845 Boulder Crescent St', @customerCity = 'Cleveland', @customerState = 'OH', @customerZip = '44103';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lilli@aol.com', @customerFirstName = 'Lilli', @customerLastName = 'Scriven', @customerStreetAddress = '33 State St', @customerCity = 'Abilene', @customerState = 'TX', @customerZip = '79601';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'whitley.tomasulo@aol.com', @customerFirstName = 'Whitley', @customerLastName = 'Tomasulo', @customerStreetAddress = '2 S 15th St', @customerCity = 'Fort Worth', @customerState = 'TX', @customerZip = '76107';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'badkin@hotmail.com', @customerFirstName = 'Barbra', @customerLastName = 'Adkin', @customerStreetAddress = '4 Kohler Memorial Dr', @customerCity = 'Brooklyn', @customerState = 'NY', @customerZip = '11230';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'hermila_thyberg@hotmail.com', @customerFirstName = 'Hermila', @customerLastName = 'Thyberg', @customerStreetAddress = '1 Rancho Del Mar Shopping C', @customerCity = 'Providence', @customerState = 'RI', @customerZip = '02903';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jesusita.flister@hotmail.com', @customerFirstName = 'Jesusita', @customerLastName = 'Flister', @customerStreetAddress = '3943 N Highland Ave', @customerCity = 'Lancaster', @customerState = 'PA', @customerZip = '17601';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'caitlin.julia@julia.org', @customerFirstName = 'Caitlin', @customerLastName = 'Julia', @customerStreetAddress = '5 Williams St', @customerCity = 'Johnston', @customerState = 'RI', @customerZip = '02919';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'roosevelt.hoffis@aol.com', @customerFirstName = 'Roosevelt', @customerLastName = 'Hoffis', @customerStreetAddress = '60 Old Dover Rd', @customerCity = 'Hialeah', @customerState = 'FL', @customerZip = '33014';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'hhalter@yahoo.com', @customerFirstName = 'Helaine', @customerLastName = 'Halter', @customerStreetAddress = '8 Sheridan Rd', @customerCity = 'Jersey City', @customerState = 'NJ', @customerZip = '07304';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lorean.martabano@hotmail.com', @customerFirstName = 'Lorean', @customerLastName = 'Martabano', @customerStreetAddress = '85092 Southern Blvd', @customerCity = 'San Antonio', @customerState = 'TX', @customerZip = '78204';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'france.buzick@yahoo.com', @customerFirstName = 'France', @customerLastName = 'Buzick', @customerStreetAddress = '64 Newman Springs Rd E', @customerCity = 'Brooklyn', @customerState = 'NY', @customerZip = '11219';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jferrario@hotmail.com', @customerFirstName = 'Justine', @customerLastName = 'Ferrario', @customerStreetAddress = '48 Stratford Ave', @customerCity = 'Pomona', @customerState = 'CA', @customerZip = '91768';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'adelina_nabours@gmail.com', @customerFirstName = 'Adelina', @customerLastName = 'Nabours', @customerStreetAddress = '80 Pittsford Victor Rd #9', @customerCity = 'Cleveland', @customerState = 'OH', @customerZip = '44103';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'ddhamer@cox.net', @customerFirstName = 'Derick', @customerLastName = 'Dhamer', @customerStreetAddress = '87163 N Main Ave', @customerCity = 'New York', @customerState = 'NY', @customerZip = '10013';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jerry.dallen@yahoo.com', @customerFirstName = 'Jerry', @customerLastName = 'Dallen', @customerStreetAddress = '393 Lafayette Ave', @customerCity = 'Richmond', @customerState = 'VA', @customerZip = '23219';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'leota.ragel@gmail.com', @customerFirstName = 'Leota', @customerLastName = 'Ragel', @customerStreetAddress = '99 5th Ave #33', @customerCity = 'Trion', @customerState = 'GA', @customerZip = '30753';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jamyot@hotmail.com', @customerFirstName = 'Jutta', @customerLastName = 'Amyot', @customerStreetAddress = '49 N Mays St', @customerCity = 'Broussard', @customerState = 'LA', @customerZip = '70518';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'aja_gehrett@hotmail.com', @customerFirstName = 'Aja', @customerLastName = 'Gehrett', @customerStreetAddress = '993 Washington Ave', @customerCity = 'Nutley', @customerState = 'NJ', @customerZip = '07110';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kirk.herritt@aol.com', @customerFirstName = 'Kirk', @customerLastName = 'Herritt', @customerStreetAddress = '88 15th Ave Ne', @customerCity = 'Vestal', @customerState = 'NY', @customerZip = '13850';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'leonora@yahoo.com', @customerFirstName = 'Leonora', @customerLastName = 'Mauson', @customerStreetAddress = '3381 E 40th Ave', @customerCity = 'Passaic', @customerState = 'NJ', @customerZip = '07055';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'winfred_brucato@hotmail.com', @customerFirstName = 'Winfred', @customerLastName = 'Brucato', @customerStreetAddress = '201 Ridgewood Rd', @customerCity = 'Moscow', @customerState = 'ID', @customerZip = '83843';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'tarra.nachor@cox.net', @customerFirstName = 'Tarra', @customerLastName = 'Nachor', @customerStreetAddress = '39 Moccasin Dr', @customerCity = 'San Francisco', @customerState = 'CA', @customerZip = '94104';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'corinne@loder.org', @customerFirstName = 'Corinne', @customerLastName = 'Loder', @customerStreetAddress = '4 Carroll St', @customerCity = 'North Attleboro', @customerState = 'MA', @customerZip = '02760';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'dulce_labreche@yahoo.com', @customerFirstName = 'Dulce', @customerLastName = 'Labreche', @customerStreetAddress = '9581 E Arapahoe Rd', @customerCity = 'Rochester', @customerState = 'MI', @customerZip = '48307';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kate_keneipp@yahoo.com', @customerFirstName = 'Kate', @customerLastName = 'Keneipp', @customerStreetAddress = '33 N Michigan Ave', @customerCity = 'Green Bay', @customerState = 'WI', @customerZip = '54301';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kaitlyn.ogg@gmail.com', @customerFirstName = 'Kaitlyn', @customerLastName = 'Ogg', @customerStreetAddress = '2 S Biscayne Blvd', @customerCity = 'Baltimore', @customerState = 'MD', @customerZip = '21230';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'sherita.saras@cox.net', @customerFirstName = 'Sherita', @customerLastName = 'Saras', @customerStreetAddress = '8 Us Highway 22', @customerCity = 'Colorado Springs', @customerState = 'CO', @customerZip = '80937';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lstuer@cox.net', @customerFirstName = 'Lashawnda', @customerLastName = 'Stuer', @customerStreetAddress = '7422 Martin Ave #8', @customerCity = 'Toledo', @customerState = 'OH', @customerZip = '43607';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'ernest@cox.net', @customerFirstName = 'Ernest', @customerLastName = 'Syrop', @customerStreetAddress = '94 Chase Rd', @customerCity = 'Hyattsville', @customerState = 'MD', @customerZip = '20785';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'nobuko.halsey@yahoo.com', @customerFirstName = 'Nobuko', @customerLastName = 'Halsey', @customerStreetAddress = '8139 I Hwy 10 #92', @customerCity = 'New Bedford', @customerState = 'MA', @customerZip = '02745';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'lavonna.wolny@hotmail.com', @customerFirstName = 'Lavonna', @customerLastName = 'Wolny', @customerStreetAddress = '5 Cabot Rd', @customerCity = 'Mc Lean', @customerState = 'VA', @customerZip = '22102';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'llizama@cox.net', @customerFirstName = 'Lashaunda', @customerLastName = 'Lizama', @customerStreetAddress = '3387 Ryan Dr', @customerCity = 'Hanover', @customerState = 'MD', @customerZip = '21076';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'mariann.bilden@aol.com', @customerFirstName = 'Mariann', @customerLastName = 'Bilden', @customerStreetAddress = '3125 Packer Ave #9851', @customerCity = 'Austin', @customerState = 'TX', @customerZip = '78753';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'helene@aol.com', @customerFirstName = 'Helene', @customerLastName = 'Rodenberger', @customerStreetAddress = '347 Chestnut St', @customerCity = 'Peoria', @customerState = 'AZ', @customerZip = '85381';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'roselle.estell@hotmail.com', @customerFirstName = 'Roselle', @customerLastName = 'Estell', @customerStreetAddress = '8116 Mount Vernon Ave', @customerCity = 'Bucyrus', @customerState = 'OH', @customerZip = '44820';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'sheintzman@hotmail.com', @customerFirstName = 'Samira', @customerLastName = 'Heintzman', @customerStreetAddress = '8772 Old County Rd #5410', @customerCity = 'Kent', @customerState = 'WA', @customerZip = '98032';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'margart_meisel@yahoo.com', @customerFirstName = 'Margart', @customerLastName = 'Meisel', @customerStreetAddress = '868 State St #38', @customerCity = 'Cincinnati', @customerState = 'OH', @customerZip = '45251';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kristofer.bennick@yahoo.com', @customerFirstName = 'Kristofer', @customerLastName = 'Bennick', @customerStreetAddress = '772 W River Dr', @customerCity = 'Bloomington', @customerState = 'IN', @customerZip = '47404';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'wacuff@gmail.com', @customerFirstName = 'Weldon', @customerLastName = 'Acuff', @customerStreetAddress = '73 W Barstow Ave', @customerCity = 'Arlington Heights', @customerState = 'IL', @customerZip = '60004';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'shalon@cox.net', @customerFirstName = 'Shalon', @customerLastName = 'Shadrick', @customerStreetAddress = '61047 Mayfield Ave', @customerCity = 'Brooklyn', @customerState = 'NY', @customerZip = '11223';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'denise@patak.org', @customerFirstName = 'Denise', @customerLastName = 'Patak', @customerStreetAddress = '2139 Santa Rosa Ave', @customerCity = 'Orlando', @customerState = 'FL', @customerZip = '32801';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'louvenia.beech@beech.com', @customerFirstName = 'Louvenia', @customerLastName = 'Beech', @customerStreetAddress = '598 43rd St', @customerCity = 'Beverly Hills', @customerState = 'CA', @customerZip = '90210';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'audry.yaw@yaw.org', @customerFirstName = 'Audry', @customerLastName = 'Yaw', @customerStreetAddress = '70295 Pioneer Ct', @customerCity = 'Brandon', @customerState = 'FL', @customerZip = '33511';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kristel.ehmann@aol.com', @customerFirstName = 'Kristel', @customerLastName = 'Ehmann', @customerStreetAddress = '92899 Kalakaua Ave', @customerCity = 'El Paso', @customerState = 'TX', @customerZip = '79925';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'vzepp@gmail.com', @customerFirstName = 'Vincenza', @customerLastName = 'Zepp', @customerStreetAddress = '395 S 6th St #2', @customerCity = 'El Cajon', @customerState = 'CA', @customerZip = '92020';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'egwalthney@yahoo.com', @customerFirstName = 'Elouise', @customerLastName = 'Gwalthney', @customerStreetAddress = '9506 Edgemore Ave', @customerCity = 'Bladensburg', @customerState = 'MD', @customerZip = '20710';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'venita_maillard@gmail.com', @customerFirstName = 'Venita', @customerLastName = 'Maillard', @customerStreetAddress = '72119 S Walker Ave #63', @customerCity = 'Anaheim', @customerState = 'CA', @customerZip = '92801';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'kasandra_semidey@semidey.com', @customerFirstName = 'Kasandra', @customerLastName = 'Semidey', @customerStreetAddress = '369 Latham St #500', @customerCity = 'Saint Louis', @customerState = 'MO', @customerZip = '63102';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'donette.foller@cox.net', @customerFirstName = 'Donette', @customerLastName = 'Foller', @customerStreetAddress = '34 Center St', @customerCity = 'Hamilton', @customerState = 'OH', @customerZip = '45011';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'mroyster@royster.com', @customerFirstName = 'Maryann', @customerLastName = 'Royster', @customerStreetAddress = '74 S Westgate St', @customerCity = 'Albany', @customerState = 'NY', @customerZip = '12204';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'ernie_stenseth@aol.com', @customerFirstName = 'Ernie', @customerLastName = 'Stenseth', @customerStreetAddress = '45 E Liberty St', @customerCity = 'Ridgefield Park', @customerState = 'NJ', @customerZip = '07660';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'jina_briddick@briddick.com', @customerFirstName = 'Jina', @customerLastName = 'Briddick', @customerStreetAddress = '38938 Park Blvd', @customerCity = 'Boston', @customerState = 'MA', @customerZip = '02128';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'sabra@uyetake.org', @customerFirstName = 'Sabra', @customerLastName = 'Uyetake', @customerStreetAddress = '98839 Hawthorne Blvd #6101', @customerCity = 'Columbia', @customerState = 'SC', @customerZip = '29201';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'brhym@rhym.com', @customerFirstName = 'Bobbye', @customerLastName = 'Rhym', @customerStreetAddress = '30 W 80th St #1995', @customerCity = 'San Carlos', @customerState = 'CA', @customerZip = '94070';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'viva.toelkes@gmail.com', @customerFirstName = 'Viva', @customerLastName = 'Toelkes', @customerStreetAddress = '4284 Dorigo Ln', @customerCity = 'Chicago', @customerState = 'IL', @customerZip = '60647';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'dominque.dickerson@dickerson.org', @customerFirstName = 'Dominque', @customerLastName = 'Dickerson', @customerStreetAddress = '69 Marquette Ave', @customerCity = 'Hayward', @customerState = 'CA', @customerZip = '94545';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'latrice.tolfree@hotmail.com', @customerFirstName = 'Latrice', @customerLastName = 'Tolfree', @customerStreetAddress = '81 Norris Ave #525', @customerCity = 'Ronkonkoma', @customerState = 'NY', @customerZip = '11779';
EXECUTE dbo.usp_AddCustomer @customerEmailAddress = 'stephaine@cox.net', @customerFirstName = 'Stephaine', @customerLastName = 'Vinning', @customerStreetAddress = '3717 Hamann Industrial Pky', @customerCity = 'San Francisco', @customerState = 'CA', @customerZip = '94104';
GO


-----------------------------
---- Insert Vendor Table ----
-----------------------------
EXECUTE dbo.usp_AddVendor @vendorName = 'Accurel Systems Intrntl Corp', @vendorstreetaddress = '19 Amboy Ave', @vendorCity = 'Miami', @vendorstate = 'FL', @vendorZip = '33142', @vendoremailaddress = 'support@accurelsystemsintrntlcorp.com', @vendorPhone = '3059884162';
EXECUTE dbo.usp_AddVendor @vendorName = 'Acqua Group', @vendorstreetaddress = '810 N La Brea Ave', @vendorCity = 'King of Prussia', @vendorstate = 'PA', @vendorZip = '19406', @vendoremailaddress = 'support@acquagroup.com', @vendorPhone = '6108091818';
EXECUTE dbo.usp_AddVendor @vendorName = 'Alinabal Inc', @vendorstreetaddress = '72 Mannix Dr', @vendorCity = 'Cincinnati', @vendorstate = 'OH', @vendorZip = '45203', @vendoremailaddress = 'support@alinabalinc.com', @vendorPhone = '5135087371';
EXECUTE dbo.usp_AddVendor @vendorName = 'Alpenlite Inc', @vendorstreetaddress = '201 Hawk Ct', @vendorCity = 'Providence', @vendorstate = 'RI', @vendorZip = '02904', @vendoremailaddress = 'support@alpenliteinc.com', @vendorPhone = '4019608259';
EXECUTE dbo.usp_AddVendor @vendorName = 'Anchor Computer Inc', @vendorstreetaddress = '13 S Hacienda Dr', @vendorCity = 'Livingston', @vendorstate = 'NJ', @vendorZip = '07039', @vendoremailaddress = 'support@anchorcomputerinc.com', @vendorPhone = '9737673008';
EXECUTE dbo.usp_AddVendor @vendorName = 'Art Crafters', @vendorstreetaddress = '703 Beville Rd', @vendorCity = 'Opa Locka', @vendorstate = 'FL', @vendorZip = '33054', @vendoremailaddress = 'support@artcrafters.com', @vendorPhone = '3056709628';
EXECUTE dbo.usp_AddVendor @vendorName = 'Binswanger', @vendorstreetaddress = '4 Kohler Memorial Dr', @vendorCity = 'Brooklyn', @vendorstate = 'NY', @vendorZip = '11230', @vendoremailaddress = 'support@binswanger.com', @vendorPhone = '7182013751';
EXECUTE dbo.usp_AddVendor @vendorName = 'Burton & Davis', @vendorstreetaddress = '70 Mechanic St', @vendorCity = 'Northridge', @vendorstate = 'CA', @vendorZip = '91325', @vendoremailaddress = 'support@burtondavis.com', @vendorPhone = '8188644875';
EXECUTE dbo.usp_AddVendor @vendorName = 'C 4 Network Inc', @vendorstreetaddress = '6 Greenleaf Ave', @vendorCity = 'San Jose', @vendorstate = 'CA', @vendorZip = '95111', @vendoremailaddress = 'support@cnetworkinc.com', @vendorPhone = '4085401785';
EXECUTE dbo.usp_AddVendor @vendorName = 'Calaveras Prospect', @vendorstreetaddress = '6201 S Nevada Ave', @vendorCity = 'Toms River', @vendorstate = 'NJ', @vendorZip = '08755', @vendoremailaddress = 'support@calaverasprospect.com', @vendorPhone = '7326289909';
EXECUTE dbo.usp_AddVendor @vendorName = 'Can Tron', @vendorstreetaddress = '369 Latham St #500', @vendorCity = 'Saint Louis', @vendorstate = 'MO', @vendorZip = '63102', @vendoremailaddress = 'support@cantron.com', @vendorPhone = '3147329131';
EXECUTE dbo.usp_AddVendor @vendorName = 'Casco Services Inc', @vendorstreetaddress = '96541 W Central Blvd', @vendorCity = 'Phoenix', @vendorstate = 'AZ', @vendorZip = '85034', @vendoremailaddress = 'support@cascoservicesinc.com', @vendorPhone = '6023904944';
EXECUTE dbo.usp_AddVendor @vendorName = 'Centro Inc', @vendorstreetaddress = '17 Us Highway 111', @vendorCity = 'Round Rock', @vendorstate = 'TX', @vendorZip = '78664', @vendoremailaddress = 'support@centroinc.com', @vendorPhone = '5125875746';
EXECUTE dbo.usp_AddVendor @vendorName = 'Circuit Solution Inc', @vendorstreetaddress = '39 Moccasin Dr', @vendorCity = 'San Francisco', @vendorstate = 'CA', @vendorZip = '94104', @vendoremailaddress = 'answers@circuitsolutioninc.com', @vendorPhone = '4154111775';
EXECUTE dbo.usp_AddVendor @vendorName = 'Computer Repair Service', @vendorstreetaddress = '70 Euclid Ave #722', @vendorCity = 'Bohemia', @vendorstate = 'NY', @vendorZip = '11716', @vendoremailaddress = 'support@computerrepairservice.com', @vendorPhone = '6317486479';
EXECUTE dbo.usp_AddVendor @vendorName = 'Cowan & Kelly', @vendorstreetaddress = '469 Outwater Ln', @vendorCity = 'San Diego', @vendorstate = 'CA', @vendorZip = '92126', @vendoremailaddress = 'support@cowankelly.com', @vendorPhone = '8586177834';
EXECUTE dbo.usp_AddVendor @vendorName = 'Deltam Systems Inc', @vendorstreetaddress = '3270 Dequindre Rd', @vendorCity = 'Deer Park', @vendorstate = 'NY', @vendorZip = '11729', @vendoremailaddress = 'support@deltamsystemsinc.com', @vendorPhone = '6312586558';
EXECUTE dbo.usp_AddVendor @vendorName = 'E A I Electronic Assocs Inc', @vendorstreetaddress = '69 Marquette Ave', @vendorCity = 'Hayward', @vendorstate = 'CA', @vendorZip = '94545', @vendoremailaddress = 'support@eaielectronicassocsinc.com', @vendorPhone = '5109933758';
EXECUTE dbo.usp_AddVendor @vendorName = 'Eagle Software Inc', @vendorstreetaddress = '5384 Southwyck Blvd', @vendorCity = 'Douglasville', @vendorstate = 'GA', @vendorZip = '30135', @vendoremailaddress = 'info@eaglesoftwareinc.com', @vendorPhone = '7705078791';
EXECUTE dbo.usp_AddVendor @vendorName = 'Feiner Bros', @vendorstreetaddress = '25 E 75th St #69', @vendorCity = 'Los Angeles', @vendorstate = 'CA', @vendorZip = '90034', @vendoremailaddress = 'support@feinerbros.com', @vendorPhone = '3104985651';
EXECUTE dbo.usp_AddVendor @vendorName = 'Franz Inc', @vendorstreetaddress = '57254 Brickell Ave #372', @vendorCity = 'Worcester', @vendorstate = 'MA', @vendorZip = '01602', @vendoremailaddress = 'support@franzinc.com', @vendorPhone = '5087695250';
EXECUTE dbo.usp_AddVendor @vendorName = 'Garrison Ind', @vendorstreetaddress = '31 Douglas Blvd #950', @vendorCity = 'Clovis', @vendorstate = 'NM', @vendorZip = '88101', @vendoremailaddress = 'support@garrisonind.com', @vendorPhone = '5059758559';
EXECUTE dbo.usp_AddVendor @vendorName = 'Geonex Martel Inc', @vendorstreetaddress = '94 W Dodge Rd', @vendorCity = 'Carson City', @vendorstate = 'NV', @vendorZip = '89701', @vendoremailaddress = 'support@geonexmartelinc.com', @vendorPhone = '7756389963';
EXECUTE dbo.usp_AddVendor @vendorName = 'H H H Enterprises Inc', @vendorstreetaddress = '3305 Nabell Ave #679', @vendorCity = 'New York', @vendorstate = 'NY', @vendorZip = '10009', @vendoremailaddress = 'support@hhhenterprisesinc.com', @vendorPhone = '2126749610';
EXECUTE dbo.usp_AddVendor @vendorName = 'Harris Corporation', @vendorstreetaddress = '4 Iwaena St', @vendorCity = 'Baltimore', @vendorstate = 'MD', @vendorZip = '21202', @vendoremailaddress = 'support@harriscorporation.com', @vendorPhone = '4108907866';
EXECUTE dbo.usp_AddVendor @vendorName = 'Hermar Inc', @vendorstreetaddress = '2 Sw Nyberg Rd', @vendorCity = 'Elkhart', @vendorstate = 'IN', @vendorZip = '46514', @vendoremailaddress = 'support@hermarinc.com', @vendorPhone = '5744991454';
EXECUTE dbo.usp_AddVendor @vendorName = 'Jets Cybernetics', @vendorstreetaddress = '99586 Main St', @vendorCity = 'Dallas', @vendorstate = 'TX', @vendorZip = '75207', @vendoremailaddress = 'info@jetscybernetics.com', @vendorPhone = '2144282285';
EXECUTE dbo.usp_AddVendor @vendorName = 'John Wagner Associates', @vendorstreetaddress = '759 Eldora St', @vendorCity = 'New Haven', @vendorstate = 'CT', @vendorZip = '06515', @vendoremailaddress = 'support@johnwagnerassociates.com', @vendorPhone = '2038016193';
EXECUTE dbo.usp_AddVendor @vendorName = 'Killion Industries', @vendorstreetaddress = '7 W 32nd St', @vendorCity = 'Erie', @vendorstate = 'PA', @vendorZip = '16502', @vendoremailaddress = 'support@killionindustries.com', @vendorPhone = '8143935571';
EXECUTE dbo.usp_AddVendor @vendorName = 'Lane Promotions', @vendorstreetaddress = '9648 S Main', @vendorCity = 'Salisbury', @vendorstate = 'MD', @vendorZip = '21801', @vendoremailaddress = 'support@lanepromotions.com', @vendorPhone = '4103511863';
EXECUTE dbo.usp_AddVendor @vendorName = 'Linguistic Systems Inc', @vendorstreetaddress = '506 S Hacienda Dr', @vendorCity = 'Atlantic City', @vendorstate = 'NJ', @vendorZip = '08401', @vendoremailaddress = 'help@linguisticsystemsinc.com', @vendorPhone = '6092285265';
EXECUTE dbo.usp_AddVendor @vendorName = 'Mcauley Mfg Co', @vendorstreetaddress = '2972 Lafayette Ave', @vendorCity = 'Gardena', @vendorstate = 'CA', @vendorZip = '90248', @vendoremailaddress = 'support@mcauleymfgco.com', @vendorPhone = '3108585079';
EXECUTE dbo.usp_AddVendor @vendorName = 'Meca', @vendorstreetaddress = '6 Harry L Dr #6327', @vendorCity = 'Perrysburg', @vendorstate = 'OH', @vendorZip = '43551', @vendoremailaddress = 'support@meca.com', @vendorPhone = '4195444900';
EXECUTE dbo.usp_AddVendor @vendorName = 'Mitsumi Electronics Corp', @vendorstreetaddress = '9677 Commerce Dr', @vendorCity = 'Richmond', @vendorstate = 'VA', @vendorZip = '23219', @vendoremailaddress = 'support@mitsumielectronicscorp.com', @vendorPhone = '8045505097';
EXECUTE dbo.usp_AddVendor @vendorName = 'Morlong Associates', @vendorstreetaddress = '7 Eads St', @vendorCity = 'Chicago', @vendorstate = 'IL', @vendorZip = '60632', @vendoremailaddress = 'support@morlongassociates.com', @vendorPhone = '7735736914';
EXECUTE dbo.usp_AddVendor @vendorName = 'Newtec Inc', @vendorstreetaddress = '1 Huntwood Ave', @vendorCity = 'Phoenix', @vendorstate = 'AZ', @vendorZip = '85017', @vendoremailaddress = 'support@newtecinc.com', @vendorPhone = '6029069419';
EXECUTE dbo.usp_AddVendor @vendorName = 'Panasystems', @vendorstreetaddress = '9 N College Ave #3', @vendorCity = 'Milwaukee', @vendorstate = 'WI', @vendorZip = '53216', @vendoremailaddress = 'support@panasystems.com', @vendorPhone = '4149592540';
EXECUTE dbo.usp_AddVendor @vendorName = 'Polykote Inc', @vendorstreetaddress = '2026 N Plankinton Ave #3', @vendorCity = 'Austin', @vendorstate = 'TX', @vendorZip = '78754', @vendoremailaddress = 'support@polykoteinc.com', @vendorPhone = '5122138574';
EXECUTE dbo.usp_AddVendor @vendorName = 'Price Business Services', @vendorstreetaddress = '7 West Ave #1', @vendorCity = 'Palatine', @vendorstate = 'IL', @vendorZip = '60067', @vendoremailaddress = 'support@pricebusinessservices.com', @vendorPhone = '8472221734';
EXECUTE dbo.usp_AddVendor @vendorName = 'Professionals Unlimited', @vendorstreetaddress = '66697 Park Pl #3224', @vendorCity = 'Riverton', @vendorstate = 'WY', @vendorZip = '82501', @vendoremailaddress = 'support@professionalsunlimited.com', @vendorPhone = '3073427795';
EXECUTE dbo.usp_AddVendor @vendorName = 'Q A Service', @vendorstreetaddress = '6 Kains Ave', @vendorCity = 'Baltimore', @vendorstate = 'MD', @vendorZip = '21215', @vendoremailaddress = 'support@qaservice.com', @vendorPhone = '4105204832';
EXECUTE dbo.usp_AddVendor @vendorName = 'Ravaal Enterprises Inc', @vendorstreetaddress = '3158 Runamuck Pl', @vendorCity = 'Round Rock', @vendorstate = 'TX', @vendorZip = '78664', @vendoremailaddress = 'support@ravaalenterprisesinc.com', @vendorPhone = '5122331831';
EXECUTE dbo.usp_AddVendor @vendorName = 'Reese Plastics', @vendorstreetaddress = '2 W Beverly Blvd', @vendorCity = 'Harrisburg', @vendorstate = 'PA', @vendorZip = '17110', @vendoremailaddress = 'support@www.reeseplastics.com', @vendorPhone = '7175288996';
EXECUTE dbo.usp_AddVendor @vendorName = 'Remaco Inc', @vendorstreetaddress = '73 Southern Blvd', @vendorCity = 'Philadelphia', @vendorstate = 'PA', @vendorZip = '19103', @vendoremailaddress = 'support@www.remacoinc.com', @vendorPhone = '2156057570';
EXECUTE dbo.usp_AddVendor @vendorName = 'Replica I', @vendorstreetaddress = '9 Wales Rd Ne #914', @vendorCity = 'Homosassa', @vendorstate = 'FL', @vendorZip = '34448', @vendoremailaddress = 'support@www.replicai.com', @vendorPhone = '3522422570';
EXECUTE dbo.usp_AddVendor @vendorName = 'Roberts Supply Co Inc', @vendorstreetaddress = '8429 Miller Rd', @vendorCity = 'Pelham', @vendorstate = 'NY', @vendorZip = '10803', @vendoremailaddress = 'support@robertssupplycoinc.com', @vendorPhone = '9148685965';
EXECUTE dbo.usp_AddVendor @vendorName = 'Sampler', @vendorstreetaddress = '555 Main St', @vendorCity = 'Erie', @vendorstate = 'PA', @vendorZip = '16502', @vendoremailaddress = 'support@sampler.com', @vendorPhone = '8144602655';
EXECUTE dbo.usp_AddVendor @vendorName = 'Scat Enterprises', @vendorstreetaddress = '73 Saint Ann St #86', @vendorCity = 'Reno', @vendorstate = 'NV', @vendorZip = '89502', @vendoremailaddress = 'support@scatenterprises.com', @vendorPhone = '7755018109';
EXECUTE dbo.usp_AddVendor @vendorName = 'Sebring & Co', @vendorstreetaddress = '40 9th Ave Sw #91', @vendorCity = 'Waterford', @vendorstate = 'MI', @vendorZip = '48329', @vendoremailaddress = 'support@sebringco.com', @vendorPhone = '2489806904';
EXECUTE dbo.usp_AddVendor @vendorName = 'Sidewinder Products Corp', @vendorstreetaddress = '8573 Lincoln Blvd', @vendorCity = 'York', @vendorstate = 'PA', @vendorZip = '17404', @vendoremailaddress = 'helpdesk@sidewinderproductscorp.com', @vendorPhone = '7178093119';
EXECUTE dbo.usp_AddVendor @vendorName = 'Sigma Corp Of America', @vendorstreetaddress = '38 Pleasant Hill Rd', @vendorCity = 'Hayward', @vendorstate = 'CA', @vendorZip = '94545', @vendoremailaddress = 'support@sigmacorpofamerica.com', @vendorPhone = '5106863407';
EXECUTE dbo.usp_AddVendor @vendorName = 'Silver Bros Inc', @vendorstreetaddress = '8 Industry Ln', @vendorCity = 'New York', @vendorstate = 'NY', @vendorZip = '10002', @vendoremailaddress = 'support@silverbrosinc.com', @vendorPhone = '2123328435';
EXECUTE dbo.usp_AddVendor @vendorName = 'Smc Inc', @vendorstreetaddress = '11279 Loytan St', @vendorCity = 'Jacksonville', @vendorstate = 'FL', @vendorZip = '32254', @vendoremailaddress = 'support@smcinc.com', @vendorPhone = '9047754480';
EXECUTE dbo.usp_AddVendor @vendorName = 'Sport En Art', @vendorstreetaddress = '6 S 33rd St', @vendorCity = 'Aston', @vendorstate = 'PA', @vendorZip = '19014', @vendoremailaddress = 'support@sportenart.com', @vendorPhone = '6105453615';
EXECUTE dbo.usp_AddVendor @vendorName = 'Switchcraft Inc', @vendorstreetaddress = '4 Nw 12th St #3849', @vendorCity = 'Madison', @vendorstate = 'WI', @vendorZip = '53717', @vendoremailaddress = 'support@switchcraftinc.com', @vendorPhone = '6083824541';
EXECUTE dbo.usp_AddVendor @vendorName = 'Tipiak Inc', @vendorstreetaddress = '80312 W 32nd St', @vendorCity = 'Conroe', @vendorstate = 'TX', @vendorZip = '77301', @vendoremailaddress = 'support@tipiakinc.com', @vendorPhone = '9367517961';
EXECUTE dbo.usp_AddVendor @vendorName = 'Valerie & Company', @vendorstreetaddress = '1 S Pine St', @vendorCity = 'Memphis', @vendorstate = 'TN', @vendorZip = '38112', @vendoremailaddress = 'support@valeriecompany.com', @vendorPhone = '9014124381';
EXECUTE dbo.usp_AddVendor @vendorName = 'Wheaton Plastic Products', @vendorstreetaddress = '22 Spruce St #595', @vendorCity = 'Gardena', @vendorstate = 'CA', @vendorZip = '90248', @vendoremailaddress = 'support@wheatonplasticproducts.com', @vendorPhone = '3105109713';
EXECUTE dbo.usp_AddVendor @vendorName = 'Wye Technologies Inc', @vendorstreetaddress = '65895 S 16th St', @vendorCity = 'Providence', @vendorstate = 'RI', @vendorZip = '02909', @vendoremailaddress = 'support@wyetechnologiesinc.com', @vendorPhone = '4014582547';
GO


-----------------------------
--- Insert Supplier Table ---
-----------------------------
EXECUTE dbo.usp_AddSupplier @supplierName = 'Acer', @supplierStreetAddress = '20 Sw Brookman Rd', @supplierCity = 'Chicago', @supplierState = 'IL', @supplierZip = '60618';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Alpine', @supplierStreetAddress = '6 Cavanaugh Rd #3069', @supplierCity = 'Newark', @supplierState = 'OH', @supplierZip = '43055';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Apple', @supplierStreetAddress = '599 Hall Rd', @supplierCity = 'Lansing', @supplierState = 'MI', @supplierZip = '48933';
EXECUTE dbo.usp_AddSupplier @supplierName = 'ASUS', @supplierStreetAddress = '87 20th St E', @supplierCity = 'Brooklyn', @supplierState = 'NY', @supplierZip = '11219';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Bose', @supplierStreetAddress = '97 W Culver St #301', @supplierCity = 'Bucyrus', @supplierState = 'OH', @supplierZip = '44820';
EXECUTE dbo.usp_AddSupplier @supplierName = 'CORSAIR', @supplierStreetAddress = '537 2nd St', @supplierCity = 'Greenville', @supplierState = 'NC', @supplierZip = '27834';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Denon', @supplierStreetAddress = '46055 Metropolitan Sq', @supplierCity = 'Great Neck', @supplierState = 'NY', @supplierZip = '11021';
EXECUTE dbo.usp_AddSupplier @supplierName = 'JBL', @supplierStreetAddress = '63248 Elm St', @supplierCity = 'Modesto', @supplierState = 'CA', @supplierZip = '95354';
EXECUTE dbo.usp_AddSupplier @supplierName = 'LG', @supplierStreetAddress = '2 I 55s S', @supplierCity = 'Salinas', @supplierState = 'CA', @supplierZip = '93912';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Logitech', @supplierStreetAddress = '2 N Midland Blvd #8151', @supplierCity = 'Abilene', @supplierState = 'TX', @supplierZip = '79602';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Onkyo', @supplierStreetAddress = '74 Ridgewood Rd', @supplierCity = 'New York', @supplierState = 'NY', @supplierZip = '10017';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Panamax', @supplierStreetAddress = '7 E Pacific Pl', @supplierCity = 'Irving', @supplierState = 'TX', @supplierZip = '75062';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Pioneer', @supplierStreetAddress = '24270 E 67th St', @supplierCity = 'Annandale', @supplierState = 'VA', @supplierZip = '22003';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Samsung', @supplierStreetAddress = '8537 10th St W', @supplierCity = 'San Anselmo', @supplierState = 'CA', @supplierZip = '94960';
EXECUTE dbo.usp_AddSupplier @supplierName = 'SanDisk', @supplierStreetAddress = '20332 Bernardo Cent #8', @supplierCity = 'New York', @supplierState = 'NY', @supplierZip = '10019';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Sennheiser', @supplierStreetAddress = '41 S Washington Ave', @supplierCity = 'Houston', @supplierState = 'TX', @supplierZip = '77084';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Sony', @supplierStreetAddress = '463 E Jackson St', @supplierCity = 'Van Nuys', @supplierState = 'CA', @supplierZip = '91401';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Printing Dimensions', @supplierStreetAddress = '34 Center St', @supplierCity = 'Hamilton', @supplierState = 'OH', @supplierZip = '45011';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Franklin Peters Inc', @supplierStreetAddress = '74 S Westgate St', @supplierCity = 'Albany', @supplierState = 'NY', @supplierZip = '12204';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Knwz Products', @supplierStreetAddress = '45 E Liberty St', @supplierCity = 'Ridgefield Park', @supplierState = 'NJ', @supplierZip = '07660';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Grace Pastries Inc', @supplierStreetAddress = '38938 Park Blvd', @supplierCity = 'Boston', @supplierState = 'MA', @supplierZip = '02128';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Lowy Products and Service', @supplierStreetAddress = '98839 Hawthorne Blvd #6101', @supplierCity = 'Columbia', @supplierState = 'SC', @supplierZip = '29201';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Smits, Patricia Garity', @supplierStreetAddress = '30 W 80th St #1995', @supplierCity = 'San Carlos', @supplierState = 'CA', @supplierZip = '94070';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Mark Iv Press', @supplierStreetAddress = '4284 Dorigo Ln', @supplierCity = 'Chicago', @supplierState = 'IL', @supplierZip = '60647';
EXECUTE dbo.usp_AddSupplier @supplierName = 'E A I Electronic Assocs Inc', @supplierStreetAddress = '69 Marquette Ave', @supplierCity = 'Hayward', @supplierState = 'CA', @supplierZip = '94545';
EXECUTE dbo.usp_AddSupplier @supplierName = 'United Product Lines', @supplierStreetAddress = '81 Norris Ave #525', @supplierCity = 'Ronkonkoma', @supplierState = 'NY', @supplierZip = '11779';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Birite Foodservice', @supplierStreetAddress = '3717 Hamann Industrial Pky', @supplierCity = 'San Francisco', @supplierState = 'CA', @supplierZip = '94104';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Roberts Supply Co Inc', @supplierStreetAddress = '8429 Miller Rd', @supplierCity = 'Pelham', @supplierState = 'NY', @supplierZip = '10803';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Harris Corporation', @supplierStreetAddress = '4 Iwaena St', @supplierCity = 'Baltimore', @supplierState = 'MD', @supplierZip = '21202';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Armon Communications', @supplierStreetAddress = '9 State Highway 57 #22', @supplierCity = 'Jersey City', @supplierState = 'NJ', @supplierZip = '07306';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Tipiak Inc', @supplierStreetAddress = '80312 W 32nd St', @supplierCity = 'Conroe', @supplierState = 'TX', @supplierZip = '77301';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Sportmaster International', @supplierStreetAddress = '6 Sunrise Ave', @supplierCity = 'Utica', @supplierState = 'NY', @supplierZip = '13501';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Acme Supply Co', @supplierStreetAddress = '1953 Telegraph Rd', @supplierCity = 'Saint Joseph', @supplierState = 'MO', @supplierZip = '64504';
EXECUTE dbo.usp_AddSupplier @supplierName = 'Warehouse Office & Paper Prod', @supplierStreetAddress = '61556 W 20th Ave', @supplierCity = 'Seattle', @supplierState = 'WA', @supplierZip = '98104';
GO

-----------------------------
--- Insert Product Table ---
-----------------------------
EXECUTE dbo.usp_AddProduct @productName = 'Acer 15.6 Chromebook CB5-571-C4G4', @supplierName = 'Acer';
EXECUTE dbo.usp_AddProduct @productName = 'Silver Weber State University Money Clip', @supplierName = 'Acme Supply Co';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Short Sleeve T-Shirt', @supplierName = 'Acme Supply Co';
EXECUTE dbo.usp_AddProduct @productName = 'Alpine - Rear View Camera - Black', @supplierName = 'Alpine';
EXECUTE dbo.usp_AddProduct @productName = 'Alpine PDXM12 1200W Mono RMS Digital Amplifier', @supplierName = 'Alpine';
EXECUTE dbo.usp_AddProduct @productName = '128GB iPod touch (Gold) (6th Generation)', @supplierName = 'Apple';
EXECUTE dbo.usp_AddProduct @productName = 'Apple iPod Touch 128GB Blue', @supplierName = 'Apple';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Dad Short Sleeve T-Shirt', @supplierName = 'Armon Communications';
EXECUTE dbo.usp_AddProduct @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @supplierName = 'ASUS';
EXECUTE dbo.usp_AddProduct @productName = 'VE278Q 27 Widescreen LCD Computer Display', @supplierName = 'ASUS';
EXECUTE dbo.usp_AddProduct @productName = 'VS278Q-P 27 16:9 LCD Monitor', @supplierName = 'ASUS';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Lip Balm', @supplierName = 'Birite Foodservice';
EXECUTE dbo.usp_AddProduct @productName = '251 Outdoor Environmental Speakers (White)', @supplierName = 'Bose';
EXECUTE dbo.usp_AddProduct @productName = 'Bose SoundLink Color Bluetooth Speaker (Black)', @supplierName = 'Bose';
EXECUTE dbo.usp_AddProduct @productName = 'CORSAIR - AX760 760-Watt ATX Power Supply - Black', @supplierName = 'CORSAIR';
EXECUTE dbo.usp_AddProduct @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @supplierName = 'CORSAIR';
EXECUTE dbo.usp_AddProduct @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @supplierName = 'CORSAIR';
EXECUTE dbo.usp_AddProduct @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @supplierName = 'CORSAIR';
EXECUTE dbo.usp_AddProduct @productName = 'CORSAIR - Vengeance LPX 32GB (2PK x 16GB) 2.6 GHz DDR4 DRAM Desktop Memory Kit - Black', @supplierName = 'CORSAIR';
EXECUTE dbo.usp_AddProduct @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @supplierName = 'Denon';
EXECUTE dbo.usp_AddProduct @productName = 'AVR-X1400H 7.2-Channel Network A/V Receiver', @supplierName = 'Denon';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University OtterBox iPhone 7/8 Symmetry Series Case', @supplierName = 'E A I Electronic Assocs Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @supplierName = 'Franklin Peters Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Crew Neck Sweatshirt', @supplierName = 'Franklin Peters Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Jersey', @supplierName = 'Franklin Peters Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University .75L Camelbak Bottle', @supplierName = 'Grace Pastries Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Alumni T-Shirt', @supplierName = 'Harris Corporation';
EXECUTE dbo.usp_AddProduct @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @supplierName = 'JBL';
EXECUTE dbo.usp_AddProduct @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @supplierName = 'JBL';
EXECUTE dbo.usp_AddProduct @productName = 'Steel Grey Weber State University Women''s Cropped Short Sleeve T-Shirt', @supplierName = 'Knwz Products';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @supplierName = 'Knwz Products';
EXECUTE dbo.usp_AddProduct @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @supplierName = 'LG';
EXECUTE dbo.usp_AddProduct @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @supplierName = 'LG';
EXECUTE dbo.usp_AddProduct @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @supplierName = 'LG';
EXECUTE dbo.usp_AddProduct @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @supplierName = 'Logitech';
EXECUTE dbo.usp_AddProduct @productName = 'Logitech - Harmony 950 Universal Remote - Black', @supplierName = 'Logitech';
EXECUTE dbo.usp_AddProduct @productName = 'MX Anywhere 2S Wireless Mouse', @supplierName = 'Logitech';
EXECUTE dbo.usp_AddProduct @productName = 'Yellow Weber State University 16 oz. Tumbler', @supplierName = 'Lowy Products and Service';
EXECUTE dbo.usp_AddProduct @productName = 'Silver Weber State University Wildcats Keytag', @supplierName = 'Mark Iv Press';
EXECUTE dbo.usp_AddProduct @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @supplierName = 'Onkyo';
EXECUTE dbo.usp_AddProduct @productName = 'Onkyo M-5010 2-Channel Amplifier (Black)', @supplierName = 'Onkyo';
EXECUTE dbo.usp_AddProduct @productName = 'Panamax - 11-Outlet Surge Protector - Black', @supplierName = 'Panamax';
EXECUTE dbo.usp_AddProduct @productName = 'Panamax - 2-Outlet Surge Protector - White', @supplierName = 'Panamax';
EXECUTE dbo.usp_AddProduct @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @supplierName = 'Pioneer';
EXECUTE dbo.usp_AddProduct @productName = 'Pioneer - XDP-300R 32GB* Video MP3 Player - Black', @supplierName = 'Pioneer';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Mom Decal', @supplierName = 'Printing Dimensions';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Wildcats Decal', @supplierName = 'Printing Dimensions';
EXECUTE dbo.usp_AddProduct @productName = 'White Weber State University Women''s Tank Top', @supplierName = 'Printing Dimensions';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Coaches Hat', @supplierName = 'Roberts Supply Co Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Gear 360 Spherical VR Camera', @supplierName = 'Samsung';
EXECUTE dbo.usp_AddProduct @productName = 'Samsung - 55 Class - LED - Q8F Series - 2160p - Smart - 4K UHD TV with HDR', @supplierName = 'Samsung';
EXECUTE dbo.usp_AddProduct @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @supplierName = 'Samsung';
EXECUTE dbo.usp_AddProduct @productName = 'Samsung - 850 PRO 1TB Internal SATA III Solid State Drive for Laptops', @supplierName = 'Samsung';
EXECUTE dbo.usp_AddProduct @productName = 'SanDisk - Ultra 500GB Internal SATA Solid State Drive for Laptops', @supplierName = 'SanDisk';
EXECUTE dbo.usp_AddProduct @productName = 'SanDisk - Ultra II 960GB Internal SATA Solid State Drive for Laptops', @supplierName = 'SanDisk';
EXECUTE dbo.usp_AddProduct @productName = 'Sennheiser - Digital Headphone Amplifier - Silver', @supplierName = 'Sennheiser';
EXECUTE dbo.usp_AddProduct @productName = 'Sennheiser - Earbud Headphones - Black', @supplierName = 'Sennheiser';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Crew Socks', @supplierName = 'Smits, Patricia Garity';
EXECUTE dbo.usp_AddProduct @productName = 'White Weber State University Orbiter Pen', @supplierName = 'Smits, Patricia Garity';
EXECUTE dbo.usp_AddProduct @productName = 'GTK-XB90 Bluetooth Speaker', @supplierName = 'Sony';
EXECUTE dbo.usp_AddProduct @productName = 'Sony Ultra-Portable Bluetooth Speaker', @supplierName = 'Sony';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Wildcats Rambler 20 oz. Tumbler', @supplierName = 'Sportmaster International';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @supplierName = 'Tipiak Inc';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Putter Cover', @supplierName = 'United Product Lines';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Rain Poncho', @supplierName = 'United Product Lines';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Academic Year Planner', @supplierName = 'Warehouse Office & Paper Prod';
EXECUTE dbo.usp_AddProduct @productName = 'Weber State University Wildcats State Decal', @supplierName = 'Warehouse Office & Paper Prod';
GO


----------------------------------
-- Enter OrderTable Table Data
----------------------------------
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'noah.kalafatis@aol.com', @orderDateTime = '2023-01-11 05:51 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'csweigard@sweigard.com', @orderDateTime = '2023-02-07 06:41 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lavonda@cox.net', @orderDateTime = '2023-01-13 01:08 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'junita@aol.com', @orderDateTime = '2023-01-12 02:10 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'herminia@nicolozakes.org', @orderDateTime = '2023-01-07 07:37 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'casie.good@aol.com', @orderDateTime = '2023-01-23 05:09 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'reena@hotmail.com', @orderDateTime = '2023-01-25 02:51 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'mirta_mallett@gmail.com', @orderDateTime = '2023-02-11 07:10 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'cathrine.pontoriero@pontoriero.com', @orderDateTime = '2023-02-16 10:36 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ftawil@hotmail.com', @orderDateTime = '2023-02-02 06:50 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'rupthegrove@yahoo.com', @orderDateTime = '2023-02-10 06:16 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'sarah.candlish@gmail.com', @orderDateTime = '2023-02-11 05:03 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lucy@cox.net', @orderDateTime = '2023-01-16 09:18 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jaquas@aquas.com', @orderDateTime = '2023-02-03 07:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'yvonne.tjepkema@hotmail.com', @orderDateTime = '2023-02-12 07:09 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kayleigh.lace@yahoo.com', @orderDateTime = '2023-02-03 11:36 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'felix_hirpara@cox.net', @orderDateTime = '2023-01-18 07:59 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'tresa_sweely@hotmail.com', @orderDateTime = '2023-01-20 04:23 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kristeen@gmail.com', @orderDateTime = '2023-01-04 01:19 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jregusters@regusters.com', @orderDateTime = '2023-02-13 07:51 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'renea@hotmail.com', @orderDateTime = '2023-02-18 03:21 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'olive@aol.com', @orderDateTime = '2023-02-11 01:47 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lreiber@cox.net', @orderDateTime = '2023-01-23 10:15 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'christiane.eschberger@yahoo.com', @orderDateTime = '2023-02-21 01:23 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'goldie.schirpke@yahoo.com', @orderDateTime = '2023-01-09 03:41 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'loreta.timenez@hotmail.com', @orderDateTime = '2023-02-06 10:52 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'fabiola.hauenstein@hauenstein.org', @orderDateTime = '2023-01-13 10:20 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'amie.perigo@yahoo.com', @orderDateTime = '2023-02-16 02:52 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'raina.brachle@brachle.org', @orderDateTime = '2023-02-06 09:42 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'erinn.canlas@canlas.com', @orderDateTime = '2023-01-25 10:26 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'cherry@lietz.com', @orderDateTime = '2023-01-08 12:23 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kattie@vonasek.org', @orderDateTime = '2023-01-07 08:08 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lilli@aol.com', @orderDateTime = '2023-02-21 11:50 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'whitley.tomasulo@aol.com', @orderDateTime = '2023-01-14 12:09 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'badkin@hotmail.com', @orderDateTime = '2023-01-17 09:10 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'hermila_thyberg@hotmail.com', @orderDateTime = '2023-02-20 01:58 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jesusita.flister@hotmail.com', @orderDateTime = '2023-02-09 05:33 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'caitlin.julia@julia.org', @orderDateTime = '2023-01-22 11:13 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'roosevelt.hoffis@aol.com', @orderDateTime = '2023-01-13 12:23 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'hhalter@yahoo.com', @orderDateTime = '2023-01-04 03:01 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lorean.martabano@hotmail.com', @orderDateTime = '2023-02-13 01:28 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'france.buzick@yahoo.com', @orderDateTime = '2023-02-09 12:06 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jferrario@hotmail.com', @orderDateTime = '2023-01-10 01:17 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'adelina_nabours@gmail.com', @orderDateTime = '2023-01-27 07:54 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ddhamer@cox.net', @orderDateTime = '2023-02-09 11:15 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jerry.dallen@yahoo.com', @orderDateTime = '2023-01-29 08:27 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'leota.ragel@gmail.com', @orderDateTime = '2023-01-27 11:04 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jamyot@hotmail.com', @orderDateTime = '2023-01-22 05:57 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'aja_gehrett@hotmail.com', @orderDateTime = '2023-02-13 05:55 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kirk.herritt@aol.com', @orderDateTime = '2023-01-18 05:46 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'leonora@yahoo.com', @orderDateTime = '2023-02-05 09:28 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'winfred_brucato@hotmail.com', @orderDateTime = '2023-02-20 08:26 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'tarra.nachor@cox.net', @orderDateTime = '2023-01-16 12:57 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'corinne@loder.org', @orderDateTime = '2023-01-12 09:01 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'dulce_labreche@yahoo.com', @orderDateTime = '2023-02-10 04:22 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kate_keneipp@yahoo.com', @orderDateTime = '2023-01-15 12:55 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kaitlyn.ogg@gmail.com', @orderDateTime = '2023-02-11 04:07 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'sherita.saras@cox.net', @orderDateTime = '2023-01-17 11:51 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lstuer@cox.net', @orderDateTime = '2023-01-05 03:30 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ernest@cox.net', @orderDateTime = '2023-02-04 12:49 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'nobuko.halsey@yahoo.com', @orderDateTime = '2023-02-09 02:41 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'lavonna.wolny@hotmail.com', @orderDateTime = '2023-02-16 07:50 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'llizama@cox.net', @orderDateTime = '2023-01-21 05:06 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'mariann.bilden@aol.com', @orderDateTime = '2023-02-06 04:16 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'helene@aol.com', @orderDateTime = '2023-02-08 07:21 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'roselle.estell@hotmail.com', @orderDateTime = '2023-02-08 12:45 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'sheintzman@hotmail.com', @orderDateTime = '2023-01-07 02:38 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'margart_meisel@yahoo.com', @orderDateTime = '2023-01-09 07:13 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kristofer.bennick@yahoo.com', @orderDateTime = '2023-02-04 05:49 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'wacuff@gmail.com', @orderDateTime = '2023-01-06 06:38 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'shalon@cox.net', @orderDateTime = '2023-01-22 06:28 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'denise@patak.org', @orderDateTime = '2023-01-16 04:38 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'louvenia.beech@beech.com', @orderDateTime = '2023-02-03 05:08 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'audry.yaw@yaw.org', @orderDateTime = '2023-02-21 01:40 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kristel.ehmann@aol.com', @orderDateTime = '2023-01-21 05:37 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'vzepp@gmail.com', @orderDateTime = '2023-02-08 04:46 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'egwalthney@yahoo.com', @orderDateTime = '2023-02-10 01:43 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'venita_maillard@gmail.com', @orderDateTime = '2023-02-12 04:28 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'kasandra_semidey@semidey.com', @orderDateTime = '2023-02-13 12:17 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'donette.foller@cox.net', @orderDateTime = '02/14/2023  7:18:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'mroyster@royster.com', @orderDateTime = '02/18/2023  5:54:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ernie_stenseth@aol.com', @orderDateTime = '01/19/2023  10:03:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'jina_briddick@briddick.com', @orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'sabra@uyetake.org', @orderDateTime = '01/14/2023  9:16:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'brhym@rhym.com', @orderDateTime = '02/24/2023  8:14:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'viva.toelkes@gmail.com', @orderDateTime = '01/03/2023  8:49:00 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'dominque.dickerson@dickerson.org', @orderDateTime = '02/17/2023  10:36:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'latrice.tolfree@hotmail.com', @orderDateTime = '02/16/2023  1:54:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'stephaine@cox.net', @orderDateTime = '01/24/2023  2:50:00 AM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'ernie_stenseth@aol.com', @orderDateTime = '01/8/2023  10:28:00 PM';
EXECUTE dbo.usp_AddOrder @customerEmailAddress = 'dominque.dickerson@dickerson.org', @orderDateTime = '01/20/2023  4:24:00 AM';
GO

-----------------------------------
--- Insert VendorProducts Table ---
-----------------------------------
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Accurel Systems Intrntl Corp', @productName = 'MX Anywhere 2S Wireless Mouse', @vendorProductPrice = '49', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Acqua Group', @productName = 'MX Anywhere 2S Wireless Mouse', @vendorProductPrice = '49.95', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Alinabal Inc', @productName = 'SanDisk - Ultra 500GB Internal SATA Solid State Drive for Laptops', @vendorProductPrice = '149.95', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Alpenlite Inc', @productName = 'CORSAIR - Vengeance LPX 32GB (2PK x 16GB) 2.6 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '269.65', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Anchor Computer Inc', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '62.95', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorProductPrice = '48', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '147.95', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'Weber State University Coaches Hat', @vendorProductPrice = '25', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Art Crafters', @productName = 'Yellow Weber State University 16 oz. Tumbler', @vendorProductPrice = '42', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Binswanger', @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorProductPrice = '253.99', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorProductPrice = '48', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '194.82', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorProductPrice = '224.99', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorProductPrice = '202.21', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorProductPrice = '159.99', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'Weber State University Rain Poncho', @vendorProductPrice = '5.95', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Burton & Davis', @productName = 'Yellow Weber State University 16 oz. Tumbler', @vendorProductPrice = '42', @quantityOnHand = '21';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'C 4 Network Inc', @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1299', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'C 4 Network Inc', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2999', @quantityOnHand = '21';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'C 4 Network Inc', @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '3193.98', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'C 4 Network Inc', @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorProductPrice = '479', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'C 4 Network Inc', @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorProductPrice = '1177.95', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Calaveras Prospect', @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorProductPrice = '399.99', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Acer 15.6 Chromebook CB5-571-C4G4', @vendorProductPrice = '198.99', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Alpine - Rear View Camera - Black', @vendorProductPrice = '149.95', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Alpine PDXM12 1200W Mono RMS Digital Amplifier', @vendorProductPrice = '849.99', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Apple iPod Touch 128GB Blue', @vendorProductPrice = '279.99', @quantityOnHand = '15';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '279.99', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'AVR-X1400H 7.2-Channel Network A/V Receiver', @vendorProductPrice = '349.98', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Bose SoundLink Color Bluetooth Speaker (Black)', @vendorProductPrice = '116.99', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorProductPrice = '199.99', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'CORSAIR - AX760 760-Watt ATX Power Supply - Black', @vendorProductPrice = '159.99', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorProductPrice = '76.99', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @vendorProductPrice = '34.99', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '219.99', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'CORSAIR - Vengeance LPX 32GB (2PK x 16GB) 2.6 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '262.99', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '279.99', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'GTK-XB90 Bluetooth Speaker', @vendorProductPrice = '349.99', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @vendorProductPrice = '149.99', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorProductPrice = '199.99', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '799.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1299.99', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2499.99', @quantityOnHand = '7';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Logitech - Harmony 950 Universal Remote - Black', @vendorProductPrice = '249.99', @quantityOnHand = '22';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'MX Anywhere 2S Wireless Mouse', @vendorProductPrice = '79.99', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorProductPrice = '399.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Onkyo M-5010 2-Channel Amplifier (Black)', @vendorProductPrice = '249.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorProductPrice = '329.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Panamax - 11-Outlet Surge Protector - Black', @vendorProductPrice = '353.98', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Panamax - 2-Outlet Surge Protector - White', @vendorProductPrice = '149.98', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorProductPrice = '379.99', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Pioneer - XDP-300R 32GB* Video MP3 Player - Black', @vendorProductPrice = '699.98', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Samsung - 55 Class - LED - Q8F Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2199.99', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorProductPrice = '5999.99', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Samsung - 850 PRO 1TB Internal SATA III Solid State Drive for Laptops', @vendorProductPrice = '479.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'SanDisk - Ultra 500GB Internal SATA Solid State Drive for Laptops', @vendorProductPrice = '199.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'SanDisk - Ultra II 960GB Internal SATA Solid State Drive for Laptops', @vendorProductPrice = '399.99', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Sennheiser - Digital Headphone Amplifier - Silver', @vendorProductPrice = '2199.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Sennheiser - Earbud Headphones - Black', @vendorProductPrice = '799.99', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorProductPrice = '69.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorProductPrice = '199.99', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Can Tron', @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorProductPrice = '209.99', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Apple iPod Touch 128GB Blue', @vendorProductPrice = '299', @quantityOnHand = '14';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '279', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'AVR-X1400H 7.2-Channel Network A/V Receiver', @vendorProductPrice = '599', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorProductPrice = '179.99', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorProductPrice = '83.78', @quantityOnHand = '21';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '239', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '439', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'GTK-XB90 Bluetooth Speaker', @vendorProductPrice = '298', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @vendorProductPrice = '129.95', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorProductPrice = '149.95', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1296.99', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1496.99', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2496.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'MX Anywhere 2S Wireless Mouse', @vendorProductPrice = '59.99', @quantityOnHand = '7';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorProductPrice = '399', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Onkyo M-5010 2-Channel Amplifier (Black)', @vendorProductPrice = '314.6', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorProductPrice = '327.72', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorProductPrice = '379', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Pioneer - XDP-300R 32GB* Video MP3 Player - Black', @vendorProductPrice = '699.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Samsung - 55 Class - LED - Q8F Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2197.99', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorProductPrice = '1397.99', @quantityOnHand = '7';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Samsung - 850 PRO 1TB Internal SATA III Solid State Drive for Laptops', @vendorProductPrice = '449', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'SanDisk - Ultra 500GB Internal SATA Solid State Drive for Laptops', @vendorProductPrice = '199.74', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'SanDisk - Ultra II 960GB Internal SATA Solid State Drive for Laptops', @vendorProductPrice = '298.99', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Sennheiser - Digital Headphone Amplifier - Silver', @vendorProductPrice = '2199.95', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Sennheiser - Earbud Headphones - Black', @vendorProductPrice = '799.95', @quantityOnHand = '7';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorProductPrice = '68', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorProductPrice = '189', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Casco Services Inc', @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorProductPrice = '189.99', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Centro Inc', @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorProductPrice = '339.99', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '279', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @vendorProductPrice = '15.99', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'Weber State University Crew Socks', @vendorProductPrice = '18', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Circuit Solution Inc', @productName = 'Weber State University Short Sleeve T-Shirt', @vendorProductPrice = '30', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Computer Repair Service', @productName = 'Bose SoundLink Color Bluetooth Speaker (Black)', @vendorProductPrice = '81', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Cowan & Kelly', @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorProductPrice = '379', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Deltam Systems Inc', @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorProductPrice = '329.47', @quantityOnHand = '22';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'E A I Electronic Assocs Inc', @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorProductPrice = '71.99', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorProductPrice = '48', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Bose SoundLink Color Bluetooth Speaker (Black)', @vendorProductPrice = '89', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @vendorProductPrice = '15.99', @quantityOnHand = '15';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Eagle Software Inc', @productName = 'Weber State University Coaches Hat', @vendorProductPrice = '25', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Feiner Bros', @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorProductPrice = '89.98', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Franz Inc', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '129.94', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Franz Inc', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1595.99', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Garrison Ind', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '94.48', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Geonex Martel Inc', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '176.45', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'H H H Enterprises Inc', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1545', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Harris Corporation', @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorProductPrice = '180', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Hermar Inc', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1510', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorProductPrice = '31.87', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Weber State University Alumni T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Weber State University Rain Poncho', @vendorProductPrice = '5.95', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Jets Cybernetics', @productName = 'Yellow Weber State University 16 oz. Tumbler', @vendorProductPrice = '42', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'John Wagner Associates', @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorProductPrice = '98.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Killion Industries', @productName = 'Apple iPod Touch 128GB Blue', @vendorProductPrice = '399', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Lane Promotions', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1596.99', @quantityOnHand = '15';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'MX Anywhere 2S Wireless Mouse', @vendorProductPrice = '49.93', @quantityOnHand = '21';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'Weber State University Alumni T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Linguistic Systems Inc', @productName = 'Weber State University Wildcats State Decal', @vendorProductPrice = '5.95', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mcauley Mfg Co', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '229', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mcauley Mfg Co', @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @vendorProductPrice = '149.95', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mcauley Mfg Co', @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorProductPrice = '399', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Meca', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '299.99', @quantityOnHand = '14';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Meca', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '54.9', @quantityOnHand = '14';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Meca', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1496.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '69.99', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Weber State University Crew Socks', @vendorProductPrice = '18', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Weber State University Putter Cover', @vendorProductPrice = '25', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Mitsumi Electronics Corp', @productName = 'Weber State University Wildcats State Decal', @vendorProductPrice = '5.95', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Morlong Associates', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '69', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Newtec Inc', @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorProductPrice = '188.95', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Newtec Inc', @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorProductPrice = '96.95', @quantityOnHand = '7';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Panasystems', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1544.95', @quantityOnHand = '14';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Polykote Inc', @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorProductPrice = '19', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '3296.99', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'Weber State University Putter Cover', @vendorProductPrice = '25', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Price Business Services', @productName = 'Weber State University Wildcats State Decal', @vendorProductPrice = '5.95', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Acer 15.6 Chromebook CB5-571-C4G4', @vendorProductPrice = '294.36', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Apple iPod Touch 128GB Blue', @vendorProductPrice = '289.99', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorProductPrice = '85.26', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @vendorProductPrice = '32.1', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '221.04', @quantityOnHand = '10';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1299.99', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '3299', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorProductPrice = '329', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Samsung - 55 Class - LED - Q8F Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2599.99', @quantityOnHand = '14';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorProductPrice = '6999.99', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'SanDisk - Ultra II 960GB Internal SATA Solid State Drive for Laptops', @vendorProductPrice = '292.44', @quantityOnHand = '15';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorProductPrice = '69.99', @quantityOnHand = '11';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorProductPrice = '182.64', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorProductPrice = '199.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Weber State University Alumni T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Weber State University Rain Poncho', @vendorProductPrice = '5.95', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Professionals Unlimited', @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorProductPrice = '19.95', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Q A Service', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1449', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Ravaal Enterprises Inc', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '108', @quantityOnHand = '22';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Reese Plastics', @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @vendorProductPrice = '62', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Reese Plastics', @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorProductPrice = '466', @quantityOnHand = '7';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Remaco Inc', @productName = 'Logitech - Harmony 950 Universal Remote - Black', @vendorProductPrice = '186.99', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Replica I', @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorProductPrice = '329.99', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Roberts Supply Co Inc', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '259.99', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sampler', @productName = 'Onkyo M-5010 2-Channel Amplifier (Black)', @vendorProductPrice = '229.99', @quantityOnHand = '5';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Scat Enterprises', @productName = 'Sennheiser - Earbud Headphones - Black', @vendorProductPrice = '609.98', @quantityOnHand = '14';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sebring & Co', @productName = 'Acer 15.6 Chromebook CB5-571-C4G4', @vendorProductPrice = '259', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sebring & Co', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '64.89', @quantityOnHand = '20';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sebring & Co', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '1497.36', @quantityOnHand = '17';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorProductPrice = '2796.99', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'Weber State University Crew Socks', @vendorProductPrice = '18', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'Weber State University Putter Cover', @vendorProductPrice = '25', @quantityOnHand = '9';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sidewinder Products Corp', @productName = 'Weber State University Short Sleeve T-Shirt', @vendorProductPrice = '30', @quantityOnHand = '24';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sigma Corp Of America', @productName = 'Panamax - 11-Outlet Surge Protector - Black', @vendorProductPrice = '139.99', @quantityOnHand = '13';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Silver Bros Inc', @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorProductPrice = '31.95', @quantityOnHand = '6';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Smc Inc', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '279', @quantityOnHand = '23';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Sport En Art', @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorProductPrice = '185', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Switchcraft Inc', @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorProductPrice = '189.5', @quantityOnHand = '25';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Tipiak Inc', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '131.98', @quantityOnHand = '19';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Valerie & Company', @productName = 'Gear 360 Spherical VR Camera', @vendorProductPrice = '377.71', @quantityOnHand = '18';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Wheaton Plastic Products', @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorProductPrice = '279', @quantityOnHand = '8';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Wheaton Plastic Products', @productName = 'AVR-X1400H 7.2-Channel Network A/V Receiver', @vendorProductPrice = '399', @quantityOnHand = '16';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Wheaton Plastic Products', @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorProductPrice = '379', @quantityOnHand = '12';
EXECUTE dbo.usp_AddVendorProduct @vendorName = 'Wye Technologies Inc', @productName = 'MX Anywhere 2S Wireless Mouse', @vendorProductPrice = '51.99', @quantityOnHand = '8';
GO

-------------------------------
--- Insert OrderItems Table ---
-------------------------------
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorName = 'Wheaton Plastic Products', @quantity = '2', @customerEmailAddress = 'noah.kalafatis@aol.com',@orderDateTime = '2023-01-11 05:51 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'GTK-XB90 Bluetooth Speaker', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'csweigard@sweigard.com',@orderDateTime = '2023-02-07 06:41 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Morlong Associates', @quantity = '2', @customerEmailAddress = 'lavonda@cox.net',@orderDateTime = '2023-01-13 01:08 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'lavonda@cox.net',@orderDateTime = '2023-01-13 01:08 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Franz Inc', @quantity = '1', @customerEmailAddress = 'junita@aol.com',@orderDateTime = '2023-01-12 02:10 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorName = 'Burton & Davis', @quantity = '1', @customerEmailAddress = 'herminia@nicolozakes.org',@orderDateTime = '2023-01-07 07:37 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Professionals Unlimited', @quantity = '1', @customerEmailAddress = 'herminia@nicolozakes.org',@orderDateTime = '2023-01-07 07:37 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Sennheiser - Earbud Headphones - Black', @vendorName = 'Scat Enterprises', @quantity = '2', @customerEmailAddress = 'casie.good@aol.com',@orderDateTime = '2023-01-23 05:09 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Bose SoundLink Color Bluetooth Speaker (Black)', @vendorName = 'Eagle Software Inc', @quantity = '1', @customerEmailAddress = 'reena@hotmail.com',@orderDateTime = '2023-01-25 02:51 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'SanDisk - Ultra II 960GB Internal SATA Solid State Drive for Laptops', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'mirta_mallett@gmail.com',@orderDateTime = '2023-02-11 07:10 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'mirta_mallett@gmail.com',@orderDateTime = '2023-02-11 07:10 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'MX Anywhere 2S Wireless Mouse', @vendorName = 'Linguistic Systems Inc', @quantity = '1', @customerEmailAddress = 'cathrine.pontoriero@pontoriero.com',@orderDateTime = '2023-02-16 10:36 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorName = 'Binswanger', @quantity = '1', @customerEmailAddress = 'ftawil@hotmail.com',@orderDateTime = '2023-02-02 06:50 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Reese Plastics', @quantity = '3', @customerEmailAddress = 'rupthegrove@yahoo.com',@orderDateTime = '2023-02-10 06:16 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'C 4 Network Inc', @quantity = '3', @customerEmailAddress = 'sarah.candlish@gmail.com',@orderDateTime = '2023-02-11 05:03 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Apple iPod Touch 128GB Blue', @vendorName = 'Killion Industries', @quantity = '3', @customerEmailAddress = 'lucy@cox.net',@orderDateTime = '2023-01-16 09:18 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorName = 'Professionals Unlimited', @quantity = '2', @customerEmailAddress = 'jaquas@aquas.com',@orderDateTime = '2023-02-03 07:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Sebring & Co', @quantity = '3', @customerEmailAddress = 'jaquas@aquas.com',@orderDateTime = '2023-02-03 07:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Bose SoundLink Color Bluetooth Speaker (Black)', @vendorName = 'Computer Repair Service', @quantity = '2', @customerEmailAddress = 'yvonne.tjepkema@hotmail.com',@orderDateTime = '2023-02-12 07:09 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Onkyo M-5010 2-Channel Amplifier (Black)', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'kayleigh.lace@yahoo.com',@orderDateTime = '2023-02-03 11:36 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Logitech - Harmony 950 Universal Remote - Black', @vendorName = 'Remaco Inc', @quantity = '1', @customerEmailAddress = 'felix_hirpara@cox.net',@orderDateTime = '2023-01-18 07:59 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorName = 'Burton & Davis', @quantity = '1', @customerEmailAddress = 'tresa_sweely@hotmail.com',@orderDateTime = '2023-01-20 04:23 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorName = 'Switchcraft Inc', @quantity = '3', @customerEmailAddress = 'tresa_sweely@hotmail.com',@orderDateTime = '2023-01-20 04:23 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'MX Anywhere 2S Wireless Mouse', @vendorName = 'Accurel Systems Intrntl Corp', @quantity = '1', @customerEmailAddress = 'kristeen@gmail.com',@orderDateTime = '2023-01-04 01:19 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Geonex Martel Inc', @quantity = '3', @customerEmailAddress = 'jregusters@regusters.com',@orderDateTime = '2023-02-13 07:51 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'renea@hotmail.com',@orderDateTime = '2023-02-18 03:21 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'renea@hotmail.com',@orderDateTime = '2023-02-18 03:21 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorName = 'Smc Inc', @quantity = '1', @customerEmailAddress = 'renea@hotmail.com',@orderDateTime = '2023-02-18 03:21 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Mitsumi Electronics Corp', @quantity = '3', @customerEmailAddress = 'olive@aol.com',@orderDateTime = '2023-02-11 01:47 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'lreiber@cox.net',@orderDateTime = '2023-01-23 10:15 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorName = 'Roberts Supply Co Inc', @quantity = '2', @customerEmailAddress = 'christiane.eschberger@yahoo.com',@orderDateTime = '2023-02-21 01:23 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'C 4 Network Inc', @quantity = '2', @customerEmailAddress = 'goldie.schirpke@yahoo.com',@orderDateTime = '2023-01-09 03:41 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorName = 'Professionals Unlimited', @quantity = '2', @customerEmailAddress = 'loreta.timenez@hotmail.com',@orderDateTime = '2023-02-06 10:52 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorName = 'Feiner Bros', @quantity = '1', @customerEmailAddress = 'loreta.timenez@hotmail.com',@orderDateTime = '2023-02-06 10:52 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorName = 'C 4 Network Inc', @quantity = '2', @customerEmailAddress = 'fabiola.hauenstein@hauenstein.org',@orderDateTime = '2023-01-13 10:20 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Panamax - 2-Outlet Surge Protector - White', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'amie.perigo@yahoo.com',@orderDateTime = '2023-02-16 02:52 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorName = 'Professionals Unlimited', @quantity = '1', @customerEmailAddress = 'amie.perigo@yahoo.com',@orderDateTime = '2023-02-16 02:52 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'raina.brachle@brachle.org',@orderDateTime = '2023-02-06 09:42 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-X1400H 7.2-Channel Network A/V Receiver', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'erinn.canlas@canlas.com',@orderDateTime = '2023-01-25 10:26 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Onkyo M-5010 2-Channel Amplifier (Black)', @vendorName = 'Sampler', @quantity = '1', @customerEmailAddress = 'cherry@lietz.com',@orderDateTime = '2023-01-08 12:23 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Valerie & Company', @quantity = '1', @customerEmailAddress = 'kattie@vonasek.org',@orderDateTime = '2023-01-07 08:08 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Samsung - 850 PRO 1TB Internal SATA III Solid State Drive for Laptops', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'kattie@vonasek.org',@orderDateTime = '2023-01-07 08:08 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorName = 'Mcauley Mfg Co', @quantity = '3', @customerEmailAddress = 'lilli@aol.com',@orderDateTime = '2023-02-21 11:50 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Logitech - Harmony 950 Universal Remote - Black', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'whitley.tomasulo@aol.com',@orderDateTime = '2023-01-14 12:09 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Samsung - 55 Class - LED - Q8F Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Professionals Unlimited', @quantity = '2', @customerEmailAddress = 'badkin@hotmail.com',@orderDateTime = '2023-01-17 09:10 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @vendorName = 'Reese Plastics', @quantity = '3', @customerEmailAddress = 'badkin@hotmail.com',@orderDateTime = '2023-01-17 09:10 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'hermila_thyberg@hotmail.com',@orderDateTime = '2023-02-20 01:58 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'SanDisk - Ultra 500GB Internal SATA Solid State Drive for Laptops', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'hermila_thyberg@hotmail.com',@orderDateTime = '2023-02-20 01:58 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Panamax - 11-Outlet Surge Protector - Black', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'jesusita.flister@hotmail.com',@orderDateTime = '2023-02-09 05:33 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Samsung - 65 Class - LED - MU6290 Series - 2160p - Smart - 4K Ultra HD TV with HDR', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'jesusita.flister@hotmail.com',@orderDateTime = '2023-02-09 05:33 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'caitlin.julia@julia.org',@orderDateTime = '2023-01-22 11:13 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorName = 'Cowan & Kelly', @quantity = '3', @customerEmailAddress = 'caitlin.julia@julia.org',@orderDateTime = '2023-01-22 11:13 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Samsung - 850 PRO 1TB Internal SATA III Solid State Drive for Laptops', @vendorName = 'Casco Services Inc', @quantity = '2', @customerEmailAddress = 'roosevelt.hoffis@aol.com',@orderDateTime = '2023-01-13 12:23 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'MX Anywhere 2S Wireless Mouse', @vendorName = 'Wye Technologies Inc', @quantity = '3', @customerEmailAddress = 'hhalter@yahoo.com',@orderDateTime = '2023-01-04 03:01 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'MX Anywhere 2S Wireless Mouse', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'lorean.martabano@hotmail.com',@orderDateTime = '2023-02-13 01:28 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'lorean.martabano@hotmail.com',@orderDateTime = '2023-02-13 01:28 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VE278Q 27 Widescreen LCD Computer Display', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'france.buzick@yahoo.com',@orderDateTime = '2023-02-09 12:06 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Pioneer - XDP-300R 32GB* Video MP3 Player - Black', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'jferrario@hotmail.com',@orderDateTime = '2023-01-10 01:17 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Franz Inc', @quantity = '3', @customerEmailAddress = 'jferrario@hotmail.com',@orderDateTime = '2023-01-10 01:17 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'adelina_nabours@gmail.com',@orderDateTime = '2023-01-27 07:54 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'ddhamer@cox.net',@orderDateTime = '2023-02-09 11:15 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Alpine PDXM12 1200W Mono RMS Digital Amplifier', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'jerry.dallen@yahoo.com',@orderDateTime = '2023-01-29 08:27 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Professionals Unlimited', @quantity = '3', @customerEmailAddress = 'jerry.dallen@yahoo.com',@orderDateTime = '2023-01-29 08:27 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Sennheiser - Digital Headphone Amplifier - Silver', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'leota.ragel@gmail.com',@orderDateTime = '2023-01-27 11:04 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Sebring & Co', @quantity = '2', @customerEmailAddress = 'jamyot@hotmail.com',@orderDateTime = '2023-01-22 05:57 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @vendorName = 'Casco Services Inc', @quantity = '3', @customerEmailAddress = 'jamyot@hotmail.com',@orderDateTime = '2023-01-22 05:57 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorName = 'Circuit Solution Inc', @quantity = '3', @customerEmailAddress = 'aja_gehrett@hotmail.com',@orderDateTime = '2023-02-13 05:55 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Garrison Ind', @quantity = '3', @customerEmailAddress = 'kirk.herritt@aol.com',@orderDateTime = '2023-01-18 05:46 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'SanDisk - Ultra II 960GB Internal SATA Solid State Drive for Laptops', @vendorName = 'Professionals Unlimited', @quantity = '1', @customerEmailAddress = 'leonora@yahoo.com',@orderDateTime = '2023-02-05 09:28 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Sennheiser - Earbud Headphones - Black', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'winfred_brucato@hotmail.com',@orderDateTime = '2023-02-20 08:26 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Sony Ultra-Portable Bluetooth Speaker', @vendorName = 'Polykote Inc', @quantity = '3', @customerEmailAddress = 'tarra.nachor@cox.net',@orderDateTime = '2023-01-16 12:57 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Acer 15.6 Chromebook CB5-571-C4G4', @vendorName = 'Sebring & Co', @quantity = '3', @customerEmailAddress = 'tarra.nachor@cox.net',@orderDateTime = '2023-01-16 12:57 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 32GB (2PK x 16GB) 2.6 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'corinne@loder.org',@orderDateTime = '2023-01-12 09:01 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorName = 'Casco Services Inc', @quantity = '2', @customerEmailAddress = 'dulce_labreche@yahoo.com',@orderDateTime = '2023-02-10 04:22 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-S530BT 5.2-Channel A/V Receiver', @vendorName = 'Mcauley Mfg Co', @quantity = '1', @customerEmailAddress = 'kate_keneipp@yahoo.com',@orderDateTime = '2023-01-15 12:55 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Meca', @quantity = '1', @customerEmailAddress = 'kaitlyn.ogg@gmail.com',@orderDateTime = '2023-02-11 04:07 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'AVR-X1400H 7.2-Channel Network A/V Receiver', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'sherita.saras@cox.net',@orderDateTime = '2023-01-17 11:51 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 55 Class - LED - UJ7700 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'sherita.saras@cox.net',@orderDateTime = '2023-01-17 11:51 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Gear 360 Spherical VR Camera', @vendorName = 'Tipiak Inc', @quantity = '2', @customerEmailAddress = 'lstuer@cox.net',@orderDateTime = '2023-01-05 03:30 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 32GB (2PK x 16GB) 2.6 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Alpenlite Inc', @quantity = '1', @customerEmailAddress = 'ernest@cox.net',@orderDateTime = '2023-02-04 12:49 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'VS278Q-P 27 16:9 LCD Monitor', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'nobuko.halsey@yahoo.com',@orderDateTime = '2023-02-09 02:41 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Price Business Services', @quantity = '3', @customerEmailAddress = 'lavonna.wolny@hotmail.com',@orderDateTime = '2023-02-16 07:50 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Hermar Inc', @quantity = '2', @customerEmailAddress = 'llizama@cox.net',@orderDateTime = '2023-01-21 05:06 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorName = 'Replica I', @quantity = '2', @customerEmailAddress = 'mariann.bilden@aol.com',@orderDateTime = '2023-02-06 04:16 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorName = 'E A I Electronic Assocs Inc', @quantity = '2', @customerEmailAddress = 'mariann.bilden@aol.com',@orderDateTime = '2023-02-06 04:16 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'helene@aol.com',@orderDateTime = '2023-02-08 07:21 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'roselle.estell@hotmail.com',@orderDateTime = '2023-02-08 12:45 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Alpine - Rear View Camera - Black', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'roselle.estell@hotmail.com',@orderDateTime = '2023-02-08 12:45 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Onkyo - 5.1-Ch. Home Theater System - Black', @vendorName = 'Calaveras Prospect', @quantity = '1', @customerEmailAddress = 'sheintzman@hotmail.com',@orderDateTime = '2023-01-07 02:38 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorName = 'Newtec Inc', @quantity = '1', @customerEmailAddress = 'margart_meisel@yahoo.com',@orderDateTime = '2023-01-09 07:13 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - Vengeance LPX 16GB (2PK x 8GB) 3.2 GHz DDR4 DRAM Desktop Memory Kit - Black', @vendorName = 'Art Crafters', @quantity = '3', @customerEmailAddress = 'kristofer.bennick@yahoo.com',@orderDateTime = '2023-02-04 05:49 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Q A Service', @quantity = '1', @customerEmailAddress = 'wacuff@gmail.com',@orderDateTime = '2023-01-06 06:38 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Pioneer - 5.1-Ch. 4K Ultra HD HDR Compatible A/V Home Theater Receiver - Black', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'wacuff@gmail.com',@orderDateTime = '2023-01-06 06:38 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @vendorName = 'Can Tron', @quantity = '3', @customerEmailAddress = 'shalon@cox.net',@orderDateTime = '2023-01-22 06:28 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Panasystems', @quantity = '3', @customerEmailAddress = 'denise@patak.org',@orderDateTime = '2023-01-16 04:38 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - LED - SJ8500 Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Sidewinder Products Corp', @quantity = '1', @customerEmailAddress = 'louvenia.beech@beech.com',@orderDateTime = '2023-02-03 05:08 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'MX Anywhere 2S Wireless Mouse', @vendorName = 'Acqua Group', @quantity = '2', @customerEmailAddress = 'louvenia.beech@beech.com',@orderDateTime = '2023-02-03 05:08 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'audry.yaw@yaw.org',@orderDateTime = '2023-02-21 01:40 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorName = 'Casco Services Inc', @quantity = '1', @customerEmailAddress = 'kristel.ehmann@aol.com',@orderDateTime = '2023-01-21 05:37 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - HD Series 120mm Case Cooling Fan Kit with RGB lighting', @vendorName = 'Professionals Unlimited', @quantity = '2', @customerEmailAddress = 'kristel.ehmann@aol.com',@orderDateTime = '2023-01-21 05:37 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorName = 'Deltam Systems Inc', @quantity = '1', @customerEmailAddress = 'kristel.ehmann@aol.com',@orderDateTime = '2023-01-21 05:37 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Pioneer - XDP-300R 32GB* Video MP3 Player - Black', @vendorName = 'Can Tron', @quantity = '1', @customerEmailAddress = 'vzepp@gmail.com',@orderDateTime = '2023-02-08 04:46 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'LG - 65 Class - OLED - B7A Series - 2160p - Smart - 4K UHD TV with HDR', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'vzepp@gmail.com',@orderDateTime = '2023-02-08 04:46 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'CORSAIR - ML Series 140mm Case Cooling Fan - White', @vendorName = 'Professionals Unlimited', @quantity = '3', @customerEmailAddress = 'egwalthney@yahoo.com',@orderDateTime = '2023-02-10 01:43 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Circle 2 2MP Wire-Free Network Camera with Night Vision', @vendorName = 'Newtec Inc', @quantity = '3', @customerEmailAddress = 'venita_maillard@gmail.com',@orderDateTime = '2023-02-12 04:28 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Acer 15.6 Chromebook CB5-571-C4G4', @vendorName = 'Can Tron', @quantity = '2', @customerEmailAddress = 'venita_maillard@gmail.com',@orderDateTime = '2023-02-12 04:28 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL - Free True Wireless In-Ear Headphones - Black', @vendorName = 'Mcauley Mfg Co', @quantity = '2', @customerEmailAddress = 'kasandra_semidey@semidey.com',@orderDateTime = '2023-02-13 12:17 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'JBL Under Armour Sport Wireless Heart Rate In-Ear Headphones Black', @vendorName = 'John Wagner Associates', @quantity = '1', @customerEmailAddress = 'kasandra_semidey@semidey.com',@orderDateTime = '2023-02-13 12:17 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'PA248Q 24 LED Backlit IPS Widescreen Monitor', @vendorName = 'Harris Corporation', @quantity = '3', @customerEmailAddress = 'kasandra_semidey@semidey.com',@orderDateTime = '2023-02-13 12:17 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorName = 'Eagle Software Inc ', @quantity = '1', @customerEmailAddress = 'donette.foller@cox.net',@orderDateTime = '02/14/2023  7:18:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Burton & Davis ', @quantity = '2', @customerEmailAddress = 'donette.foller@cox.net',@orderDateTime = '02/14/2023  7:18:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Jets Cybernetics ', @quantity = '4', @customerEmailAddress = 'mroyster@royster.com',@orderDateTime = '02/18/2023  5:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorName = 'Linguistic Systems Inc', @quantity = '2', @customerEmailAddress = 'mroyster@royster.com',@orderDateTime = '02/18/2023  5:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorName = 'Burton & Davis', @quantity = '1', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/19/2023  10:03:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Professionals Unlimited', @quantity = '3', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/19/2023  10:03:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Putter Cover', @vendorName = 'Sidewinder Products Corp', @quantity = '3', @customerEmailAddress = 'jina_briddick@briddick.com',@orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Crew Socks', @vendorName = 'Circuit Solution Inc', @quantity = '2', @customerEmailAddress = 'jina_briddick@briddick.com',@orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Coaches Hat', @vendorName = 'Eagle Software Inc', @quantity = '3', @customerEmailAddress = 'jina_briddick@briddick.com',@orderDateTime = '01/21/2023  8:26:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorName = 'Price Business Services', @quantity = '2', @customerEmailAddress = 'sabra@uyetake.org',@orderDateTime = '01/14/2023  9:16:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Wildcats State Decal', @vendorName = 'Mitsumi Electronics Corp', @quantity = '1', @customerEmailAddress = 'sabra@uyetake.org',@orderDateTime = '01/14/2023  9:16:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Burton & Davis ', @quantity = '4', @customerEmailAddress = 'brhym@rhym.com',@orderDateTime = '02/24/2023  8:14:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Putter Cover', @vendorName = 'Sidewinder Products Corp', @quantity = '2', @customerEmailAddress = 'brhym@rhym.com',@orderDateTime = '02/24/2023  8:14:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Boys'' Tri-Blend Short Sleeve T-Shirt', @vendorName = 'Eagle Software Inc', @quantity = '1', @customerEmailAddress = 'viva.toelkes@gmail.com',@orderDateTime = '01/03/2023  8:49:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorName = 'Art Crafters', @quantity = '2', @customerEmailAddress = 'viva.toelkes@gmail.com',@orderDateTime = '01/03/2023  8:49:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorName = 'Linguistic Systems Inc', @quantity = '2', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '02/17/2023  10:36:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Crew Socks', @vendorName = 'Circuit Solution Inc', @quantity = '1', @customerEmailAddress = 'latrice.tolfree@hotmail.com',@orderDateTime = '02/16/2023  1:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Professionals Unlimited', @quantity = '4', @customerEmailAddress = 'latrice.tolfree@hotmail.com',@orderDateTime = '02/16/2023  1:54:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Black Weber State University Women''s Hooded Sweatshirt', @vendorName = 'Eagle Software Inc ', @quantity = '1', @customerEmailAddress = 'stephaine@cox.net',@orderDateTime = '01/24/2023  2:50:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Jets Cybernetics ', @quantity = '2', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/8/2023  10:28:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Volleyball Short Sleeve T-Shirt', @vendorName = 'Linguistic Systems Inc', @quantity = '1', @customerEmailAddress = 'ernie_stenseth@aol.com',@orderDateTime = '01/08/2023  10:28:00 PM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Rain Poncho', @vendorName = 'Burton & Davis ', @quantity = '1', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '01/20/2023  4:24:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Putter Cover', @vendorName = 'Price Business Services', @quantity = '2', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '01/20/2023  4:24:00 AM';
EXECUTE dbo.usp_AddOrderItems @productName = 'Weber State University Coaches Hat', @vendorName = 'Eagle Software Inc', @quantity = '1', @customerEmailAddress = 'dominque.dickerson@dickerson.org',@orderDateTime = '01/20/2023  4:24:00 AM';
GO