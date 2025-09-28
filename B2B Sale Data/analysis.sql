USE b2b_sales;

-- tổng doanh thu theo ProductCategory
SELECT p.ProductCategory, SUM(s.Sales) AS TotalSales, COUNT(DISTINCT s.OrderID) AS NumberOfOrders
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY p.ProductCategory
ORDER BY TotalSales DESC;

-- doanh thu theo tháng/năm
SELECT YEAR(s.OrderDate) AS Year, MONTH(s.OrderDate) AS Month, SUM(s.Sales) AS MonthlySales
FROM Sales s
GROUP BY Year, Month
ORDER BY Year, Month;

-- 10 khách hàng mua nhiều nhất
SELECT s.CustomerName, SUM(s.Sales) AS TotalSpent
FROM Sales s
GROUP BY CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;

-- doanh thu theo khách hàng và loại sản phẩm
SELECT s.CustomerName, p.ProductCategory, SUM(s.Sales) AS TotalSales
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY s.CustomerName, p.ProductCategory
ORDER BY TotalSales DESC
LIMIT 10;
