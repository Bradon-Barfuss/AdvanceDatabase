CREATE VIEW [dbo].udv_vendorProductView
AS

SELECT 
v.vendorName AS 'Vendor Name',
p.productName AS 'Product Name',
vp.quantityOnHand AS 'Quantity Available',
COUNT(*) AS 'Total Products Sold',
ISNULL(SUM(oi.quantity), 0) AS 'Total Sales for product',
ISNULL((SELECT SUM(oi2.quantity)
	FROM orderItem oi2
	JOIN vendorProduct vp2 ON oi2.sdvendor_id = vp2.sdVendor_id
	and oi2.sdproduct_id = vp2.sdproduct_id
	where vp2.sdvendor_id = v.sdvendor_id), 0) AS 'Total Sales for Vendor'
	FROM
		Vendor v
		JOIN vendorproduct vp on v.sdvendor_id = vp.sdvendor_id
		join product p on vp.sdproduct_id = p.sdproduct_id
		LEFT join orderItem oi
		ON vp.sdvendor_id = oi.sdvendor_id
		and vp.sdproduct_id = oi.sdproduct_id
	GROUP BY
	v.sdvendor_id, v.vendorname, p.productname, p.sdproduct_id, vp.sdproduct_id, vp.sdvendor_id, vp.quantityonhand

GO

