USE AdventureWorks2022;
GO


Select * from Sales.SalesOrderHeader


--1.View Top 10 Sales of 2014
--SELECT Distinct Year(ShipDate)
Select TOP 10 * 
FROM Sales.SalesOrderHeader
Where Year(ShipDate) =2014
Order By SubTotal DESC
GO

-- 2. Total sales revenue by year and month
SELECT Year( ShipDate) as Year, FORMAT(Shipdate,'yy-MMM') as Year_Month, SUM(TotalDue) AS TotalSalesRevenue
FROM Sales.SalesOrderHeader
Group By Year(ShipDate), MONTH(Shipdate), FORMAT(Shipdate,'yy-MMM')
Order By  Year(ShipDate), MONTH(Shipdate)
GO

-- 3. Total orders by year
SELECT
    Year(Shipdate)  as Year ,COUNT(*) AS TotalOrders
FROM Sales.SalesOrderHeader
Group By Year(ShipDate)
GO

-- 4. Average order value by year
SELECT
    Year(Shipdate)  as Year, AVG(TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader
Group By YEAR(Shipdate)
GO

-- 5. Total freight by territory 
SELECT
    Name as Territory, SUM(Freight) AS TotalFreight
FROM Sales.SalesOrderHeader as S
JOIN Sales.SalesTerritory as T ON 
S. TerritoryID = T.TerritoryID 
Group By T.Name
Order By SUM(Freight) DESC
GO

-- 6. Sales by territory id
SELECT
    TerritoryID,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TotalSales DESC;
GO

-- 7. Order count by status
SELECT
    Status,
    COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY Status
ORDER BY OrderCount DESC;
GO
