
CREATE VIEW [dbo].udv_supplierProductView
AS

	SELECT vendorName, t1.productName AS 'Name Product Sale'
	, t2.totalAmountSaleProduct AS 'Total number of each product sold'
	, t2.totalSaleProduct AS 'Total sales amount of each product sold for customer'
	, t3.totalVendorSale AS 'Total sales a vendor makes'
	FROM Vendor v
	INNER JOIN
		(SELECT productName, vp.sdProduct_id, vp.sdVendor_id
		FROM product p INNER JOIN vendorProduct vp
		ON vp.sdProduct_id = p.sdProduct_id
		) t1
	ON v.sdVendor_id = t1.sdVendor_id
	INNER JOIN(
		SELECT vp.sdVendor_id, vp.sdProduct_id
		, ISNULL(sum(quantity), 0) AS totalAmountSaleProduct, ISNULL(SUM(quantity * vp.vendorProductPrice), 0) AS totalSaleProduct
		FROM orderItem oi RIGHT OUTER JOIN vendorProduct vp
		ON oi.sdVendor_id = vp.sdVendor_id AND oi.sdProduct_id = vp.sdProduct_id
		GROUP BY vp.sdvendor_id, vp.sdProduct_id
		) t2
		ON t1.sdVendor_id = t2.sdVendor_id
		AND t1.sdProduct_id = t2.sdProduct_id
	INNER JOIN(
		SELECT vp.sdVendor_id
		, ISNULL(SUM(quantity * vp.vendorProductPrice), 0) AS totalVendorSale
		FROM vendorProduct vp
		left outer join
		orderItem oi
		ON oi.sdVendor_id = vp.sdVendor_id
		AND oi.sdProduct_id = vp.sdProduct_id
		GROUP BY vp.sdVendor_id
	)  t3
	ON t3.sdvendor_id = v.sdVendor_id

GO

