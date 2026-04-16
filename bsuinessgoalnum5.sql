SELECT c.Gender, COUNT(*) AS NumPurchases
FROM Spring26_S008_T2_Buys b
JOIN Spring26_S008_T2_Customer c
    ON b.CustomerID = c.CustomerID
JOIN Spring26_S008_T2_Product p
    ON b.ProductID = p.ProductID
WHERE b.TransactionDate >= DATE '2025-01-01'
AND p.ProductName LIKE '%Game%'
GROUP BY CUBE(c.Gender);

---------------------------------------
SELECT 
    c.Gender,
    COUNT(*) AS NumAboveAverageCustomers,
    SUM(t.TotalSpent) AS TotalSpendingFromHighCustomers
FROM Spring26_S008_T2_Customer c
JOIN (
    SELECT 
        CustomerID,
        SUM(Cost) AS TotalSpent
    FROM Spring26_S008_T2_Buys
    WHERE TransactionDate BETWEEN DATE '2025-01-01' AND DATE '2026-01-31'
    GROUP BY CustomerID
    HAVING SUM(Cost) > (
        SELECT AVG(CustomerTotal)
        FROM (
            SELECT SUM(Cost) AS CustomerTotal
            FROM Spring26_S008_T2_Buys
            WHERE TransactionDate BETWEEN DATE '2025-01-01' AND DATE '2026-01-31'
            GROUP BY CustomerID
        )
    )
) 
t
ON c.CustomerID = t.CustomerID
GROUP BY c.Gender;
----------------------------THIS ^^^ IS FINE BUT COULD BE BETTER AND I NEED TO ADD ROLLUP OR CUBE SO OUTPUT NEEDS TO BE FIXED ALONG WITH GOAL

SELECT 
    c.Gender,
    COUNT(*) AS NumAboveAverageCustomers,
    SUM(t.TotalSpent) AS TotalSpendingFromHighCustomers
FROM Spring26_S008_T2_Customer c
JOIN (
    SELECT 
        CustomerID,
        SUM(Cost) AS TotalSpent
    FROM Spring26_S008_T2_Buys
    GROUP BY CustomerID
    HAVING SUM(Cost) > (
        SELECT AVG(CustomerTotal)
        FROM (
            SELECT SUM(Cost) AS CustomerTotal
            FROM Spring26_S008_T2_Buys
            GROUP BY CustomerID
        )
    )
)
ON c.CustomerID = t.CustomerID
GROUP BY c.Gender;


SELECT 
    c.CustomerID,
    c.Gender,
    SUM(b.Cost) AS TotalSpent
FROM Spring26_S008_T2_Buys b
JOIN Spring26_S008_T2_Customer c
    ON b.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.Gender
HAVING SUM(b.Cost) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT SUM(Cost) AS CustomerTotal
        FROM Spring26_S008_T2_Buys
        GROUP BY CustomerID
    )
)
ORDER BY CUSTOMERID;


SELECT 
    c.Gender,
    t.CustomerID,
    t.TotalSpent,
    t.LastTransactionDate
FROM Spring26_S008_T2_Customer c
JOIN (
    SELECT 
        CustomerID,
        SUM(Cost) AS TotalSpent,
        MAX(TransactionDate) AS LastTransactionDate
    FROM Spring26_S008_T2_Buys
    GROUP BY CustomerID
    HAVING SUM(Cost) > (
        SELECT AVG(CustomerTotal)
        FROM (
            SELECT SUM(Cost) AS CustomerTotal
            FROM Spring26_S008_T2_Buys
            GROUP BY CustomerID
        )
    )
) t
ON c.CustomerID = t.CustomerID
ORDER BY t.LastTransactionDate DESC;