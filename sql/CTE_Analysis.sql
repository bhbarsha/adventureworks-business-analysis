USE AdventureWorks2022;
GO



-- 1. Rank customers by total spending using a CTE
WITH CustomerSpending AS (
    SELECT
        c.CustomerID,
        SUM(soh.TotalDue) AS TotalSpent
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh
        ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
)
SELECT
    CustomerID,
    TotalSpent,
    RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingRank
FROM CustomerSpending
ORDER BY SpendingRank;
GO


-- 2. Rank products within each category
WITH ProductSales AS (
    SELECT
        pc.Name AS CategoryName,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail sod
    JOIN Production.Product p
        ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name, p.Name
)
SELECT
    CategoryName,
    ProductName,
    TotalSales,
    RANK() OVER (PARTITION BY CategoryName ORDER BY TotalSales DESC) AS CategoryRank
FROM ProductSales
ORDER BY CategoryName, CategoryRank;
GO

-- 3. Top 3 products in each category
WITH ProductSales AS (
    SELECT
        pc.Name AS CategoryName,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderDetail sod
    JOIN Production.Product p
        ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name, p.Name
),
RankedProducts AS (
    SELECT
        CategoryName,
        ProductName,
        TotalSales,
        RANK() OVER (PARTITION BY CategoryName ORDER BY TotalSales DESC) AS CategoryRank
    FROM ProductSales
)
SELECT
    CategoryName,
    ProductName,
    TotalSales,
    CategoryRank
FROM RankedProducts
WHERE CategoryRank <= 3
ORDER BY CategoryName, CategoryRank;
GO

-- 4. High-value customer segmentation
WITH CustomerSales AS (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSpent
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSpent,
    CASE
        WHEN TotalSpent >= 20000 THEN 'High Value'
        WHEN TotalSpent >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerSegment
FROM CustomerSales
ORDER BY TotalSpent DESC;
GO
