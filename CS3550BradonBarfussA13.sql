SELECT 'db.ShoppingDatabase.insertOne( 
{ customerfirstname: "' + c.customerfirstname
+ '", customerlastname: "' + customerlastname
+ '", customerStreetAddress: "' + c.customerStreetAddress
+ '", customerCity: "' + c.customerCity
+ '", customerstate: "' + c.customerstate
+ '", customerzip: "' + c.customerzip
+ '", customeremailaddress: "'		+ c.customeremailaddress
+ '", OrderItems:  [ ] })'
FROM Customer c
where c.customerFirstName = 'Vincenza'
and c.customerLastName = 'Zepp'

select 
'{ prouductName: "' + p.productname
+ '", quantity:"' + CONVERT(NVARCHAR(9), oi.quantity)
+ '", vendorProductPrice:"' + CONVERT(NVARCHAR(9), vp.vendorProductPrice)
+ '", vendorName:"' + v.vendorName
+ '", vendorStreetAddress:"' + v.vendorStreetAddress
+ '", vendorState:"' + v.vendorState
+ '", vendorCity:"' + v.vendorCity
+ '", vendorZip:"' + v.vendorZip
+ '", supplierName:"' + s.supplierName
+ '", supplierStreetAddress:"' + s.supplierStreetAddress
+ '", supplierCity:"' + s.supplierCity
+ '", supplierState:"' + s.supplierState
+ '", supplierZip:"' + s.supplierZip
+ '", orderDateTime: "'				+ CONVERT(NVARCHAR(50), ot.orderDateTime)
+ '", ordertotal: "'				+ CONVERT(NVARCHAR(10), ot.ordertotal)
+ '", subtotal: "'					+ CONVERT(NVARCHAR(10), ot.subtotal)
+ '", shippingcost: "'				+ CONVERT(NVARCHAR(9), ot.shippingcost)
+ '", taxAmount: "'					+ CONVERT(NVARCHAR(10), ot.taxAmount)
+ '"},'
FROM Customer c
INNER JOIN ordertable ot
on ot.sdCustomer_id = c.sdCustomer_id
inner join orderitem oi
on oi.sdOrderTable_id = ot.sdOrderTable_id
inner join vendorproduct vp
on vp.sdProduct_id = oi.sdProduct_id and vp.sdvendor_id = oi.sdvendor_id
inner join vendor v
on v.sdVendor_id = vp.sdVendor_id
inner join product p
on p.sdproduct_id = vp.sdProduct_id
inner join supplier s
on s.sdSupplier_id = p.sdSupplier_id
where c.customerFirstName = 'Vincenza'
and c.customerLastName = 'Zepp'




/*
SELECT 'db.ShoppingDatabase.insertOne( 
{ customerfirstname: "' + c.customerfirstname
+ '", customerlastname: "' + customerlastname
+ '", customerStreetAddress: "' + c.customerStreetAddress
+ '", customerCity: "' + c.customerCity
+ '", customerstate: "' + c.customerstate
+ '", customerzip: "' + c.customerzip
+ '", customeremailaddress: "'		+ c.customeremailaddress
+ '", orderDateTime: "'				+ CONVERT(NVARCHAR(50), ot.orderDateTime)
+ '", ordertotal: "'				+ CONVERT(NVARCHAR(10), ot.ordertotal)
+ '", subtotal: "'					+ CONVERT(NVARCHAR(10), ot.subtotal)
+ '", shippingcost: "'				+ CONVERT(NVARCHAR(9), ot.shippingcost)
+ '", taxAmount: "'					+ CONVERT(NVARCHAR(10), ot.taxAmount)
+ '", OrderItems: "  [ { } ] })'
FROM Customer c
INNER JOIN ordertable ot
on ot.sdCustomer_id = c.sdCustomer_id
inner join orderitem oi
on oi.sdOrderTable_id = ot.sdOrderTable_id
inner join vendorproduct vp
on vp.sdProduct_id = oi.sdProduct_id and vp.sdvendor_id = oi.sdvendor_id
inner join vendor v
on v.sdVendor_id = vp.sdVendor_id
inner join product p
on p.sdproduct_id = vp.sdProduct_id
inner join supplier s
on s.sdSupplier_id = p.sdSupplier_id
where c.customerFirstName = 'Dominque'
and c.customerLastName = 'Dickerson'
*/