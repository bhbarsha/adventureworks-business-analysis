USE AdventureWorks2022;
GO


Select * from Sales.Customer

-- 1. Total customers
SELECT
    COUNT(*) AS TotalCustomers
FROM Sales.Customer;
GO

-- 2. Top 10 customers by total sales
SELECT TOP 10
    c.CustomerID,
    SUM(soh.TotalDue) AS TotalSpent
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;
GO

-- 3. Top 10 named customers by sales
SELECT TOP 10
    c.CustomerID,
    pp.FirstName + ' ' + pp.LastName AS CustomerName,
    SUM(soh.TotalDue) AS TotalSpent
FROM Sales.Customer c
JOIN Person.Person pp
    ON c.PersonID = pp.BusinessEntityID
JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
WHERE c.PersonID IS NOT NULL
GROUP BY c.CustomerID, pp.FirstName, pp.LastName
ORDER BY TotalSpent DESC;
GO


-- 4. Customers with highest order counts
SELECT TOP 10
    c.CustomerID,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY OrderCount DESC;
GO

--Select top 10 c.CustomerID, COUNT(soh.SalesOrderID) as OrderCount
from Sales.Customer as c 
JOIN Sales.SalesOrderHeader  as soh 
ON
c.CustomerID = soh.CustomerID 
Group By c.CustomerID
Order by OrderCount DESC


-- 5. Average spend per customer
SELECT
    AVG(CustomerSpend.TotalSpent) AS AvgCustomerSpending
FROM (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSpent
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
) AS CustomerSpend;
GO

--No 5. Using CTE
WITH CustomerSpend AS (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSpent
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    AVG(TotalSpent) AS AvgCustomerSpending
FROM CustomerSpend;
GO
