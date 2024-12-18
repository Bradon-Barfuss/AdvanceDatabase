-- Bradon Barfuss

/*1. List the first name, last name, gender, age (in days), and job title of the oldest age (as calculated by number of days) employee. 
Note that you should calculate the age in days.*/

select pp.firstname, pp.lastname, hre.Gender, hre.birthdate, datediff(day, hre.birthdate, getdate()) as ageindays, hre.JobTitle
from person.person pp
inner join HumanResources.Employee hre
on pp.BusinessEntityID = hre.BusinessEntityID
where hre.BirthDate = (select min(birthdate) from HumanResources.Employee);



/*2. Display the employee male to female ratio of employees in Production. DONE
(Note that ratio is male/female). Show the single value up to two digits after the decimal (i.e. 5.43). Use CAST to convert the number 
of each gender to a FLOAT. User ROUND to get the value down to 2 digits after decimal*/ 

SELECT t1.DepartmentName, Round(CAST(NumMaleEmployee AS Float) / cast(NumFemaleEmployee as float), 2) as employeeMaleToFemaleRatio
FROM (SELECT hrd.name AS 'DepartmentName', count(*) as NumFemaleEmployee
FROM HumanResources.Employee hre
INNER JOIN HumanResources.EmployeeDepartmentHistory hredh
on hredh.BusinessEntityId = hre.businessentityID
inner join HumanResources.Department hrd
on hrd.departmentID = hredh.departmentID
WHERE hre.Gender = 'F'
group by hrd.name) t1
INNER JOIN
(SELECT hrd.name AS 'DepartmentName', count(*) as NumMaleEmployee
FROM HumanResources.Employee hre
INNER JOIN HumanResources.EmployeeDepartmentHistory hredh
on hredh.BusinessEntityId = hre.businessentityID
inner join HumanResources.Department hrd
on hrd.departmentID = hredh.departmentID
WHERE hre.Gender = 'M' and hrd.name = 'Production'
group by hrd.name) t2
ON t1.DepartmentName = t2.DepartmentName



/*3. Show the name, quantity and product ID of the highest total quantity ordered item SOLD to customers. 
To clarify, show the highest total order quantity per item. Remember the double join*/

SELECT pp.name as 'ProductName', pp.ProductID, sum(ssod.OrderQty) as 'TotalOrderQuantity'
from sales.SalesOrderDetail ssod
INNER JOIN Sales.SpecialOfferProduct ssop
on ssop.ProductID = ssod.ProductID
AND ssop.SpecialOfferID = ssod.SpecialOfferID
inner join production.product pp
on pp.productID = ssop.ProductID
GROUP BY pp.name, pp.productID
HAVING SUM(ssod.OrderQty) = 
(select MAX(totalOrderQuantity) from 

(SELECT pp.name as 'ProductName', pp.ProductID, sum(ssod.OrderQty) as 'TotalOrderQuantity'
from sales.SalesOrderDetail ssod
INNER JOIN Sales.SpecialOfferProduct ssop
on ssop.ProductID = ssod.ProductID
AND ssop.SpecialOfferID = ssod.SpecialOfferID
inner join production.product pp
on pp.productID = ssop.ProductID
GROUP BY pp.name, pp.productID) t1);





/*4. Show the state/provinces(s) with the most online orders. Show the number of online orders as well (hint: it is over 5000)*/
select t1.StateProvinceID, t1.name, t1.orders 
from (select psp.StateProvinceID, psp.Name, count(*) as 'orders' from person.stateprovince psp 
inner join sales.salesTerritory sst 
on sst.territoryID = psp.territoryID
inner join sales.salesorderheader ssoh 
on ssoh.territoryID = sst.territoryID
group by psp.stateprovinceID, psp.name) t1
where t1.orders = (
select Max(t2.orders) 
from (select psp.StateProvinceID, psp.Name, count(*) as 'orders' from person.stateprovince psp 
inner join sales.salesTerritory sst 
on sst.territoryID = psp.territoryID
inner join sales.salesorderheader ssoh 
on ssoh.territoryID = sst.territoryID
group by psp.stateprovinceID, psp.name) t2);


/*5. Display the vendor name, credit rating and address (street address, city, state) for vendors 
that have a credit rating less than or equal to 2. Sort the list be Vendor Name.*/


select pv.name as 'Vendor Name', pv.creditRating, t2.AddressLine1 as 'Street Address', t2.City, t2.statename as 'State'
from Purchasing.Vendor pv
inner join(
	select pv.BusinessEntityID from purchasing.vendor pv
	where pv.CreditRating <= 2) creditRateTable
	on pv.BusinessEntityID = creditRateTable.BusinessEntityID
inner join( 
	select pbe.BusinessEntityID, pa.addressLine1, pa.city, psp.name as 'statename' from person.address pa
	inner join person.StateProvince psp
	on pa.StateProvinceID = psp.StateProvinceID
	inner join person.BusinessEntityAddress pbea
	on pbea.addressID = pa.AddressID
	inner join person.BusinessEntity pbe
	on pbe.BusinessEntityID = pbea.BusinessEntityID
	inner join purchasing.vendor pv
	on pv.BusinessEntityID = pbe.BusinessEntityID) t2
on t2.businessEntityID = pv.businessEntityID
order by pv.name;



/*6. Display the territory (Territory ID, Name, CountryRegionCode, Group and Number of Customers)  
of the sales territory that has the most customers.*/

select t1.territoryID, t1.name, t1.countryRegioncode, t1.[group], t1.[customers count] from (
select sst.TerritoryID, sst.name, sst.CountryRegionCode, sst.[Group], count(*) as 'customers count' from sales.SalesTerritory sst
inner join sales.Customer sc
on  sst.territoryID = sc.TerritoryID
group by sst.TerritoryID, sst.name, sst.CountryRegionCode, sst.[Group]) t1
where t1.[customers count] = (
select max(t2.[customers count]) from (
select sst.TerritoryID, sst.name, sst.CountryRegionCode, sst.[Group], count(*) as 'customers count' from sales.SalesTerritory sst
inner join sales.Customer sc
on  sst.territoryID = sc.TerritoryID
group by sst.TerritoryID, sst.name, sst.CountryRegionCode, sst.[Group]) t2);


/*7. COME BACK TO THIS ONE List the employee (still with the company) last hired in each department, 
in alphabetical order by department. The employee must still be in the department. (End date is blank*/

select DISTINCT hrd.name as 'department name', hre.hiredate, pp.firstname, pp.lastname from HumanResources.Department hrd
inner join HumanResources.EmployeeDepartmentHistory hredh
on hredh.DepartmentID = hrd.departmentid
inner join HumanResources.Employee hre
on hre.businessentityid = hredh.BusinessEntityID
inner join person.person pp
on pp.BusinessEntityID = hre.BusinessEntityID
inner join (
select hrd.name, max(hre.hiredate) as 'hrdate' from HumanResources.Department hrd
inner join HumanResources.EmployeeDepartmentHistory hredh
on hredh.DepartmentID = hrd.departmentid
inner join HumanResources.Employee hre
on hre.businessentityid = hredh.BusinessEntityID
where hre.CurrentFlag = 1
group by hrd.name
) t1
on t1.hrdate = hre.HireDate and t1.name = hrd.name
order by hrd.name;

/*8. List the first and last name, current pay rate and year to date sales of
sales employees who have above average YTD sales. 
Sort by last name then first name*/

select pp.firstname, pp.lastname, hreph.Rate, ssp.SalesYTD AS 'Year to date Sales' 
from sales.SalesPerson ssp
inner join HumanResources.Employee hre
on ssp.BusinessEntityID = hre.BusinessEntityID
inner join person.Person pp
on hre.BusinessEntityID = pp.BusinessEntityID
inner join HumanResources.EmployeePayHistory hreph
on hreph.BusinessEntityID = hre.BusinessEntityID
WHERE pp.PersonType = 'SP'
AND ssp.SalesYTD > ( 
    select AVG(ssp.salesYTD) AS "AverageSales"
    FROM sales.salesPerson ssp
)
order by pp.lastname, pp.firstname;


/*9. Identify the currency of the foreign country (not the US)
with the highest total number of orders.*/
select sst.name as 'Foreign Country', t2.name as 'Currency name', t2.TotalSales from(
select t1.countryRegionCode, t1.name, t1.currencyCode, sum(t1.sales) as 'TotalSales' from (
select scrc.CountryRegionCode, sc.name, scrc.CurrencyCode, count(*) as 'sales' from sales.Currency sc
inner join sales.CountryRegionCurrency scrc
on scrc.CurrencyCode = sc.CurrencyCode
inner join sales.CurrencyRate scr 
on scr.ToCurrencyCode = sc.CurrencyCode
inner join sales.SalesOrderHeader ssoh
on scr.CurrencyRateID = ssoh.CurrencyRateID
where scrc.CountryRegionCode != 'US'
group by scrc.CountryRegionCode, sc.name, scrc.CurrencyCode, scr.ToCurrencyCode, ssoh.CurrencyRateID
) t1
group by t1.CountryRegionCode, t1.name, t1.CurrencyCode) t2
inner join sales.SalesTerritory sst
on t2.CountryRegionCode = sst.CountryRegionCode
where t2.TotalSales = (select Max(t4.[TotalSales]) from (
select t1.countryRegionCode, t1.currencyCode, sum(t1.sales) as 'TotalSales' from (
select scrc.CountryRegionCode, scrc.CurrencyCode, count(*) as 'sales' from sales.Currency sc
inner join sales.CountryRegionCurrency scrc
on scrc.CurrencyCode = sc.CurrencyCode
inner join sales.CurrencyRate scr 
on scr.ToCurrencyCode = sc.CurrencyCode
inner join sales.SalesOrderHeader ssoh
on scr.CurrencyRateID = ssoh.CurrencyRateID
where scrc.CountryRegionCode != 'US'
group by scrc.CountryRegionCode, scrc.CurrencyCode, scr.ToCurrencyCode, ssoh.CurrencyRateID
) t1
group by t1.CountryRegionCode, t1.CurrencyCode
) t4)




/*10.  Show the unique Sale Reason Name, Sales Unit Price, Product Name, Special Offer Description, Special Offer Discount Percent, and the 
discounted price of the item (unit price minus the discount applied against the unit price) for this items On Promotion where the Special Offer
Description begins with Touring. */

select ssr.name as 'sales reason name', ssod.unitPrice as 'Unit Price', pp.name as 'product name', sso.description as 'special offer description', sso.DiscountPct, (ssod.UnitPrice - (ssod.UnitPrice * sso.DiscountPct)) as 'unit price w/ discount'
from sales.salesreason ssr
inner join sales.SalesOrderHeaderSalesReason ssohsr
on ssohsr.SalesReasonID = ssr.SalesReasonID
inner join sales.SalesOrderHeader ssoh
on ssoh.salesorderID = ssohsr.SalesOrderID
inner join sales.SalesOrderDetail ssod
on ssod.SalesOrderID = ssoh.SalesOrderID
inner join production.Product pp
on pp.productID = ssod.ProductID
inner join sales.SpecialOfferProduct ssop
on ssop.SpecialOfferID = ssod.SpecialOfferID and ssop.ProductID = ssod.ProductID
inner join sales.SpecialOffer sso
on sso.SpecialOfferID = ssop.SpecialOfferID
where ssr.name = 'on promotion' and sso.Description like '%touring%'
order by sso.DiscountPct desc


