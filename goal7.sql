SELECT ProductName, TotalSales
FROM (
    SELECT p.ProductName, SUM(b.Cost) AS TotalSales
    FROM Spring26_S008_T2_Buys b
    JOIN Spring26_S008_T2_Product p
        ON b.ProductID = p.ProductID
    WHERE p.ProductType = 'Console'
    GROUP BY ROLLUP(p.ProductName)
)
WHERE (ProductName IS NULL OR TotalSales > (
    SELECT AVG(TotalSales)
    FROM (
        SELECT p2.ProductName, SUM(b2.Cost) AS TotalSales
        FROM Spring26_S008_T2_Buys b2
        JOIN Spring26_S008_T2_Product p2
            ON b2.ProductID = p2.ProductID
        WHERE p2.ProductType = 'Console'
        GROUP BY p2.ProductName
    )
));
