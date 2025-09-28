USE Foodpanda;

# Doanh thu & số đơn hàng theo nhà hàng
SELECT r.restaurantName, COUNT(o.orderId) AS total_orders, SUM(o.price) AS total_revenue
FROM `Order` o
JOIN Restaurant r ON o.restaurantName = r.restaurantName
GROUP BY r.restaurantName
ORDER BY total_revenue DESC;

# Doanh thu theo loại món
SELECT d.category, COUNT(o.orderId) AS total_orders, SUM(o.price) AS total_revenue
FROM `Order` o
JOIN Dish d ON o.dishName = d.dishName AND o.restaurantName = d.restaurantName
GROUP BY d.category
ORDER BY total_revenue DESC;

# Khách hàng theo nhóm tuổi và giới tính
SELECT c.age, c.gender, COUNT(c.customerId) AS total_customers
FROM Customer c
GROUP BY c.age, c.gender
ORDER BY total_customers DESC;

# Tỷ lệ khách hàng churned theo nhóm tuổi
SELECT c.age, COUNT(*) AS total_customers, 
		SUM(CASE WHEN o.churned='Inactive' THEN 1 ELSE 0 END) AS churned_customers, 
        ROUND(SUM(CASE WHEN o.churned='Inactive' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churn_rate_percent
FROM `Order` o
JOIN Customer c ON o.customerId = c.customerId
GROUP BY c.age
ORDER BY churn_rate_percent DESC;

# Top 5 món được đặt nhiều nhất
SELECT o.dishName, o.restaurantName, SUM(o.quantity) AS total_quantity, SUM(o.price) AS total_revenue
FROM `Order` o
GROUP BY o.dishName, o.restaurantName
ORDER BY total_quantity DESC
LIMIT 5;

# Đánh giá trung bình từng nhà hàng
SELECT o.restaurantName, AVG(o.rating) AS avg_rating, COUNT(o.rating) AS total_ratings
FROM `Order` o
WHERE o.rating IS NOT NULL
GROUP BY o.restaurantName
ORDER BY avg_rating DESC;

# Doanh thu theo hình thức thanh toán
SELECT o.paymentMethod, COUNT(o.orderId) AS total_orders, SUM(o.price) AS total_revenue
FROM `Order` o
GROUP BY o.paymentMethod
ORDER BY total_revenue DESC;

# Khách trung thành nhất
SELECT o.customerId, MAX(o.orderFrequency) AS max_orders, MAX(o.loyaltyPoints) AS max_points
FROM `Order` o
GROUP BY o.customerId
ORDER BY max_points DESC
LIMIT 10;

# Doanh thu theo tháng
SELECT MONTH(o.orderDate) AS month, SUM(o.price) AS monthly_revenue
FROM `Order` o
GROUP BY MONTH(o.orderDate)
ORDER BY month;

# Số đơn hàng theo ngày
SELECT o.orderDate, COUNT(o.orderId) AS orders_per_day
FROM `Order` o
GROUP BY o.orderDate
ORDER BY o.orderDate;
