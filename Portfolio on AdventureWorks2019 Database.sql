--SQL PORTFOLIO

--**ONE**
--To retrieve the total quantity purchased for each product 

SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

SELECT SSOD.ProductID, PP.Name, COUNT(SSOD.ProductID) AS Qty_Purchased
FROM Production.Product AS PP
INNER JOIN Sales.SalesOrderDetail AS SSOD
ON PP.ProductID = SSOD.ProductID
INNER JOIN Sales.SalesOrderHeader AS SSOH
ON SSOD.SalesOrderID = SSOH.SalesOrderID
GROUP BY SSOD.ProductID, PP.Name


--**TWO**
--To retrieve products that have prices higher that the average price

--Inner Query
SELECT AVG(ListPrice) AS Ave_ListPrice
FROM Production.Product;

--Subquery
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > (
SELECT AVG(ListPrice) FROM Production.Product
)
ORDER BY ListPrice DESC;

--**THREE**
--To retrieve employees with their bonus payments and associated department details

SELECT * FROM HumanResources.EmployeePayHistory
SELECT * FROM HumanResources.vEmployeeDepartment

SELECT  HRED.FirstName, HRED.LastName, HRED.Department, HREPH.Rate, HREPH.PayFrequency
FROM HumanResources.EmployeePayHistory AS HREPH
INNER JOIN HumanResources.vEmployeeDepartment AS HRED
ON HREPH.BusinessEntityID = HRED.BusinessEntityID
ORDER BY HREPH.Rate DESC;


--**FOUR**
--To retrieve suppliers whose product standard price is greater than products list price

SELECT * FROM Production.Product
SELECT * FROM Purchasing.ProductVendor
SELECT * FROM Purchasing.vVendorWithAddresses

SELECT PP.ProductID, PPV.StandardPrice, PVWA.Name AS Vendor_Name, PP.ListPrice
FROM Production.Product AS PP
INNER JOIN Purchasing.ProductVendor AS PPV
ON PP.ProductID = PPV.ProductID
INNER JOIN Purchasing.vVendorWithAddresses AS PVWA
ON PPV.BusinessEntityID = PVWA.BusinessEntityID
WHERE PPV.StandardPrice > PP.ListPrice
ORDER BY PP.ListPrice DESC;


--**FIVE**
--To retrieve suppliers whose products list price range is between 10 and 50 

SELECT * FROM Production.Product
SELECT * FROM Purchasing.ProductVendor
SELECT * FROM Purchasing.vVendorWithAddresses

SELECT PP.ProductID, PPV.StandardPrice, PVWA.Name AS Vendor_Name, PP.ListPrice
FROM Production.Product AS PP
INNER JOIN Purchasing.ProductVendor AS PPV
ON PP.ProductID = PPV.ProductID
INNER JOIN Purchasing.vVendorWithAddresses AS PVWA
ON PPV.BusinessEntityID = PVWA.BusinessEntityID
WHERE PP.ListPrice >= 70 AND PP.ListPrice <= 150
ORDER BY PP.ListPrice DESC;

--**SIX**
--To retrieve orders where the actual shipping date is later than the due date

SELECT * FROM Purchasing.PurchaseOrderHeader
SELECT * FROM Sales.SalesOrderHeader

SELECT SOH.CustomerID, POH.OrderDate, POH.ShipDate, SOH.DueDate, DATEDIFF(dd, SOH.DueDate, POH.ShipDate) AS No_of_Late_Days
FROM Purchasing.PurchaseOrderHeader AS POH
INNER JOIN Sales.SalesOrderHeader AS SOH
ON POH.ShipMethodID = SOH.ShipMethodID
WHERE POH.ShipDate > SOH.DueDate
ORDER BY No_of_Late_Days DESC;


--**SEVEN**
--To retrieve vendor names with their corresponding phone number, email addrerss and addresses

SELECT * FROM Purchasing.vVendorWithContacts
SELECT * FROM Purchasing.vVendorWithAddresses

SELECT VWA.Name AS Vendor_Name, CONCAT(VWC.Title, ' ', VWC.FirstName,' ', VWC.LastName) AS Contact_Person_Name,
		VWC.PhoneNumber, VWC.EmailAddress, VWA.AddressLine1, VWA.AddressLine2, VWA.StateProvinceName, VWA.CountryRegionName
FROM Purchasing.vVendorWithContacts AS VWC
INNER JOIN Purchasing.vVendorWithAddresses AS VWA
ON VWC.BusinessEntityID = VWA.BusinessEntityID;


--**EIGHT**
--To retrieve the most recent order date for Sales Order ID

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

SELECT SOD.SalesOrderID, MAX(OrderDate) AS Most_Recent_Order_Date
FROM Sales.SalesOrderDetail AS SOD
JOIN Sales.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE SOH.OrderDate = (
				SELECT MAX(OrderDate)
				FROM Sales.SalesOrderHeader
				WHERE SalesOrderID = SOH.SalesOrderID
				)
GROUP BY SOD.SalesOrderID


--**NINE**
--To retrieve the names of employees with their email address, phone number, and address

SELECT * FROM Person.Address
SELECT * FROM Person.PersonPhone
SELECT * FROM Person.BusinessEntityAddress
SELECT * FROM Person.Person
SELECT * FROM Person.EmailAddress

SELECT CONCAT(PP.FirstName, ' ', PP.LastName) AS Employee_Name, PPP.PhoneNumber,
	PEA.EmailAddress, PA.AddressLine1, PA.AddressLine2, PA.City
FROM Person.Address AS PA
INNER JOIN Person.BusinessEntityAddress AS PBEA
ON PA.AddressID = PBEA.AddressID
INNER JOIN Person.Person AS PP
ON PBEA.BusinessEntityID = PP.BusinessEntityID
INNER JOIN Person.PersonPhone AS PPP
ON PP.BusinessEntityID = PPP.BusinessEntityID
INNER JOIN Person.EmailAddress AS PEA
ON PPP.BusinessEntityID = PEA.BusinessEntityID


--**TEN**
--To retrieve sales orders that contain more than one product
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

--Inner Query
SELECT SalesOrderID
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING COUNT(ProductID) > 1

--Subquery
SELECT SOH.SalesOrderID, SOH.OrderDate, COUNT(sod.ProductID) AS No_of_Products
FROM Sales.SalesOrderHeader AS SOH
JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.SalesOrderID IN (
						SELECT SalesOrderID
						FROM Sales.SalesOrderDetail
						GROUP BY SalesOrderID
						HAVING COUNT(ProductID) > 1
						)
GROUP BY SOH.SalesOrderID, SOH.OrderDate
ORDER BY SOH.OrderDate;

--**ELEVEN**
--To retrieve the products along with their current inventory levels

SELECT * FROM Production.Product
SELECT * FROM Production.ProductInventory

SELECT PP.ProductID, PP.Name AS Product_Name, SUM(PPI.Quantity) AS Inventory_Level
FROM Production.Product AS PP
INNER JOIN Production.ProductInventory AS PPI
ON PP.ProductID = PPI.ProductID
GROUP BY PP.ProductID, PP.Name
ORDER BY PP.ProductID ASC;


--**TWELVE**
--To retrieve products with their product IDs, subcategories and categories

SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory

SELECT PP.ProductID, PP.Name AS Product_Name, PPS.Name AS Product_SubCategory, PPC.Name AS Product_Category
FROM Production.Product AS PP
INNER JOIN Production.ProductSubcategory AS PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS PPC
ON PPS.ProductCategoryID = PPC.ProductCategoryID


--**THIRTEEN**
--To retrieve the names of vendors along with the products they supply

SELECT * FROM Production.Product
SELECT * FROM Purchasing.Vendor
SELECT * FROM Purchasing.ProductVendor

SELECT PV.Name AS Vendor_Name, PP.Name AS Product_Name
FROM Production.Product AS PP
INNER JOIN Purchasing.ProductVendor AS PPV
ON PP.ProductID = PPV.ProductID
INNER JOIN Purchasing.Vendor AS PV
ON PPV.BusinessEntityID = PV.BusinessEntityID


--**FOURTEEN**
--To retrieve sales orders whose total amount is above the average order total. 
Use a subquery to calculate the average from the sales order header.

--Inner Query
SELECT * --AVG(LineTotal) AS Average_Order
FROM Sales.SalesOrderDetail

--SubQuery
SELECT SalesOrderID, LineTotal
FROM Sales.SalesOrderDetail
WHERE LineTotal > (SELECT AVG(LineTotal) AS Average_Order
				FROM Sales.SalesOrderDetail
				)
ORDER BY SalesOrderID DESC;


--**FIFTEEN**
--To retrieve each salesperson along with their salesYTD,
--If sales is equal to or greater than average sales total sales, then comment "good", if not, comment "needs improvement".

SELECT * FROM Sales.SalesPerson
SELECT * FROM HumanResources.Employee
SELECT * FROM Person.Person

SELECT SSP.BusinessEntityID, CONCAT(PP.FirstName, ' ', PP.LastName) AS Sales_Person, 
		HRE.JobTitle, SSP.SalesYTD,
CASE WHEN SSP.SalesYTD >= (
						SELECT AVG(SSP2.SalesYTD)
						FROM Sales.SalesPerson AS SSP2)
					 THEN 'Good' ELSE 'Needs Improvement' END AS Comment
FROM Person.Person AS PP
INNER JOIN HumanResources.Employee AS HRE
ON PP.BusinessEntityID = HRE.BusinessEntityID
INNER JOIN Sales.SalesPerson AS SSP
ON HRE.BusinessEntityID = SSP.BusinessEntityID
ORDER BY SSP.SalesYTD DESC;


--**SIXTEEN**
--To retrieve a list of orders with the number of items in each order 

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

SELECT SOH.SalesOrderID, COUNT(SOD.SalesOrderDetailID) AS No_of_times
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY SOH.SalesOrderID
ORDER BY SOH.SalesOrderID ASC;