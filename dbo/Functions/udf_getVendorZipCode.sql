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

