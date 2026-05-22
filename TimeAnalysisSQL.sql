USE AdventureWorks2022;
GO

-- 1. Sales by year
SELECT
    YEAR(OrderDate) AS SalesYear,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;
GO

-- 2. Sales by month
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(TotalDue) AS MonthlySales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;
GO

-- 3. Order count by year
SELECT
    YEAR(OrderDate) AS SalesYear,
    COUNT(*) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;
GO

-- 4. Year-over-year growth
WITH YearlySales AS (
    SELECT
        YEAR(OrderDate) AS SalesYear,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
)
SELECT
    SalesYear,
    TotalSales,
    LAG(TotalSales) OVER (ORDER BY SalesYear) AS PreviousYearSales,
    ROUND(
        ((TotalSales - LAG(TotalSales) OVER (ORDER BY SalesYear)) * 100.0)
        / NULLIF(LAG(TotalSales) OVER (ORDER BY SalesYear), 0),
        2
    ) AS YoYGrowthPercent
FROM YearlySales
ORDER BY SalesYear;
GO