CREATE VIEW [dbo].udv_customerOrderView
AS

SELECT customerFirstName AS "First Name"
, customerLastName AS "Last Name"
, customerStreetAddress AS "Address"
, customerCity AS "City"
, customerState AS "State"
, customerZip AS "Zip"
, orderDateTime AS "Order Date"
, subTotal AS "Sub Total"
, taxAmount AS "Tax"
, shippingCost AS "Shipping"
, orderTotal AS "Total"
, quantity AS "Quantity"
, ProductName AS "Product Name"
FROM OrderTable ot
INNER JOIN customer c
ON c.sdCustomer_id = ot.sdCustomer_id
INNER JOIN orderItem oi
ON oi.sdOrderTable_id = ot.sdOrderTable_id
INNER JOIN vendorProduct vp
ON vp.sdVendor_Id = oi.sdVendor_id AND vp.sdProduct_id = oi.sdProduct_id
INNER JOIN Product P
ON p.sdProduct_id = vp.sdProduct_id

GO

