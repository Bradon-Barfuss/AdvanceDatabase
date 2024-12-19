--- Question 1 Part 1
select DayOfMonthHired
, [Document Control], [Engineering]
, [Executive], [Facilities and Maintenance], [Finance]
, [Human Resources], [Information Services]
, [Marketing], [Production]
, [Production Control]
, [Purchasing], [Quality Assurance]
, [Research and Development]
, [Sales], [Shipping and Receiving]
, [Tool Design]
from
(SELECT d.name as "DepartmentName", DATENAME(dd, e.hireDate) as DayOfMonthHired, e.BusinessEntityID
FROM HumanResources.Department d 
inner join HumanResources.EmployeeDepartmentHistory edh
on d.DepartmentID = edh.DepartmentID 
inner join HumanResources.Employee e 
on e.BusinessEntityID = edh.BusinessEntityID ) dataTable
PIVOT
(count(BusinessEntityID)
FOR DepartmentName IN ([Document Control]
, [Engineering], [Executive], [Facilities and Maintenance]
, [Finance], [Human Resources]
, [Information Services], [Marketing], [Production]
, [Production Control], [Purchasing], [Quality Assurance]
, [Research and Development]
, [Sales], [Shipping and Receiving]
, [Tool Design])) AS PivotTable;



--- question 1 part 2
DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX)
SET @columns = N'';
SET @sql = N'';
SELECT @columns += N', ' + QUOTENAME(name)
FROM HumanResources.Department AS t1
SET @columns = STUFF(@columns, 1, 2, '')
print @columns;


SET @sql = N'
select DayOfMonthHired, ' + @columns +
'from
(SELECT d.name as "DepartmentName", DATENAME(dd, e.hireDate) as DayOfMonthHired, e.BusinessEntityID
FROM HumanResources.Department d 
inner join HumanResources.EmployeeDepartmentHistory edh
on d.DepartmentID = edh.DepartmentID 
inner join HumanResources.Employee e 
on e.BusinessEntityID = edh.BusinessEntityID ) dataTable
PIVOT
(count(BusinessEntityID)
FOR DepartmentName IN (' + @columns + ')) AS PivotTable;';
EXECUTE sp_executesql @sql;





-- question 2 part 1
select ScrappedReasonname, 
[Sunday], [Monday], [Tuesday], [Wednesday], [Thursday]
, [Friday], [Saturday]
from
(select sr.Name as 'ScrappedReasonname', datename(weekday, wo.StartDate) as 'startday' , wo.ScrappedQty from
Production.ScrapReason sr
inner join production.WorkOrder wo
on sr.ScrapReasonID = wo.ScrapReasonID) dataTable
PIVOT
(sum(ScrappedQty)
FOR startday IN 
( [Sunday]
, [Monday]
, [Tuesday]
, [Wednesday]
, [Thursday]
, [Friday]
, [Saturday])) AS PivotTable;


-- question 2 part 2

SET @columns = N'';
SET @sql = N'';

SELECT @columns += N', ' + QUOTENAME(dayofweekname) 
from
	(select Distinct dayofweekname, dayofweeknumeric 
	from
		(Select dateName(dw, startDate) as dayofweekname, datepart(dw, startdate) as dayofweeknumeric
		from production.workorder) t1
	) t2 
		order by dayofweeknumeric
	



SET @columns = STUFF(@columns, 1, 2, '')

SET @sql = N'select ScrappedReasonname, ' + @columns + '
from
(select sr.Name as "ScrappedReasonname", datename(weekday, wo.StartDate) as "startday" , wo.ScrappedQty from
Production.ScrapReason sr
inner join production.WorkOrder wo
on sr.ScrapReasonID = wo.ScrapReasonID) dataTable
PIVOT
(sum(ScrappedQty)
FOR startday IN 
( ' + @columns + ')) AS PivotTable;';
EXECUTE sp_executesql @sql;















/*Step one, create the normal table

select ppc.Name as 'CategoryName', sum(ssod.OrderQty) as 'TotalMonthQuantity', DateName(mm, ssoh.OrderDate) as 'OrderMonth'
FROM Production.ProductCategory ppc
inner join production.ProductSubcategory ppsc
on ppc.ProductCategoryID = ppsc.ProductCategoryID
inner join Production.Product pp 
on pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
inner join sales.SpecialOfferProduct ssop
on ssop.ProductID = pp.ProductID
inner join sales.SalesOrderDetail ssod
on ssod.SpecialOfferID = ssop.SpecialOfferID
	AND ssod.ProductID = ssop.ProductID
inner join sales.SalesOrderHeader ssoh
on ssoh.SalesOrderID = ssod.SalesOrderID
group by ppc.name, DateName(mm, ssoh.OrderDate)
*/

/* step 2, make it into a sub table and remove the group by and sum or total stuff
(select ppc.Name as 'CategoryName', ssod.OrderQty as 'TotalMonthQuantity', DateName(mm, ssoh.OrderDate) as 'OrderMonth'
FROM Production.ProductCategory ppc
inner join production.ProductSubcategory ppsc
on ppc.ProductCategoryID = ppsc.ProductCategoryID
inner join Production.Product pp 
on pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
inner join sales.SpecialOfferProduct ssop
on ssop.ProductID = pp.ProductID
inner join sales.SalesOrderDetail ssod
on ssod.SpecialOfferID = ssop.SpecialOfferID
	AND ssod.ProductID = ssop.ProductID
inner join sales.SalesOrderHeader ssoh
on ssoh.SalesOrderID = ssod.SalesOrderID) dataTable
*/

/* step 3: Get the column headers you want
-- select Distinct name from production.ProductCategory use this to get the head names
SELECT OrderMonth
, [Accessories]
, [Bikes]
, [Clothing]
, [Components]
FROM
(select ppc.Name as 'CategoryName', ssod.OrderQty as 'TotalMonthQuantity', DateName(mm, ssoh.OrderDate) as 'OrderMonth'
FROM Production.ProductCategory ppc
inner join production.ProductSubcategory ppsc
on ppc.ProductCategoryID = ppsc.ProductCategoryID
inner join Production.Product pp 
on pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
inner join sales.SpecialOfferProduct ssop
on ssop.ProductID = pp.ProductID
inner join sales.SalesOrderDetail ssod
on ssod.SpecialOfferID = ssop.SpecialOfferID
	AND ssod.ProductID = ssop.ProductID
inner join sales.SalesOrderHeader ssoh
on ssoh.SalesOrderID = ssod.SalesOrderID) dataTable
*/

/* step 4, add the pivot at the bottom replacing the group by where the group by should be. add the sum or total word, and FOR [header column name] IN ([headersvalues1], ...., [headervalues2]);
SELECT OrderMonth
, [Accessories]
, [Bikes]
, [Clothing]
, [Components]
FROM
(select ppc.Name as 'CategoryName', ssod.OrderQty, DateName(mm, ssoh.OrderDate) as 'OrderMonth',  DatePart(mm, ssoh.OrderDate) as 'NumericMonth'
FROM Production.ProductCategory ppc
inner join production.ProductSubcategory ppsc
on ppc.ProductCategoryID = ppsc.ProductCategoryID
inner join Production.Product pp 
on pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
inner join sales.SpecialOfferProduct ssop
on ssop.ProductID = pp.ProductID
inner join sales.SalesOrderDetail ssod
on ssod.SpecialOfferID = ssop.SpecialOfferID
	AND ssod.ProductID = ssop.ProductID
inner join sales.SalesOrderHeader ssoh
on ssoh.SalesOrderID = ssod.SalesOrderID) dataTable
PIVOT
(SUM (orderQTY)
FOR CategoryName IN ([Accessories]
, [Bikes]
, [Clothing]
, [Components])) AS PivotTable
order by NumericMonth;
*/


/* step 5, copy and past this, make it dynamic change the from table to the appropate name
DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX)
SET @columns = N'';
SELECT @columns += N', ' + QUOTENAME(name)
FROM Production.ProductCategory AS t1
SET @columns = STUFF(@columns, 1, 2, '')
-- print @columns;
*/

/*
--Step 6, add the 'SET @sql = , everything we made replacing the columns with @columns
SET @sql = N'
SELECT OrderMonth, ' + @columns + 'FROM
(select ppc.Name as CategoryName, ssod.OrderQty, DateName(mm, ssoh.OrderDate) as OrderMonth,  DatePart(mm, ssoh.OrderDate) as NumericMonth
FROM Production.ProductCategory ppc
inner join production.ProductSubcategory ppsc
on ppc.ProductCategoryID = ppsc.ProductCategoryID
inner join Production.Product pp 
on pp.ProductSubcategoryID = ppsc.ProductSubcategoryID
inner join sales.SpecialOfferProduct ssop
on ssop.ProductID = pp.ProductID
inner join sales.SalesOrderDetail ssod
on ssod.SpecialOfferID = ssop.SpecialOfferID
	AND ssod.ProductID = ssop.ProductID
inner join sales.SalesOrderHeader ssoh
on ssoh.SalesOrderID = ssod.SalesOrderID) dataTable
PIVOT
(SUM (orderQTY)
FOR CategoryName IN (' + @columns + ')) AS PivotTable
order by NumericMonth;';

--print @sql; make sure the code looks good

--step 7, run sql with run procedure function
--EXECUTE sp_executesql @sql

*/


/*
SELECT TerritoryID
, [CARGO TRANSPORT 5]
, [OVERNIGHT J-FAST]
, [OVERSEAS - DELUXE]
, [XRQ - TRUCK GROUND]
, [ZY - EXPRESS]
from 
(SELECT m.Name AS "ShipMethodName", h.TerritoryID, h.TotalDue
FROM Purchasing.ShipMethod m
inner join Sales.SalesOrderHeader h 
on m.ShipMethodID = h.ShipMethodID) dataTable
PIVOT
(avg(totalDue)
FOR dataTable.ShipMethodName IN ([CARGO TRANSPORT 5], [OVERNIGHT J-FAST], [OVERSEAS - DELUXE], [XRQ - TRUCK GROUND], [ZY - EXPRESS]))
as PivotTable
order by TerritoryID;
*/


/* -question #
DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX)
SET @columns = N'';
SELECT @columns += N', ' + QUOTENAME(name)
FROM Purchasing.ShipMethod AS t1
SET @columns = STUFF(@columns, 1, 2, '')
--print @columns;

SET @sql = N'SELECT TerritoryID, ' + @columns + N'
from 
(SELECT m.Name AS "ShipMethodName", h.TerritoryID, h.TotalDue
FROM Purchasing.ShipMethod m
inner join Sales.SalesOrderHeader h 
on m.ShipMethodID = h.ShipMethodID) dataTable
PIVOT
(avg(totalDue)
FOR dataTable.ShipMethodName IN (' + @columns + N'))
as PivotTable
order by TerritoryID;';


--print @sql
EXECUTE sp_executesql @sql
*/