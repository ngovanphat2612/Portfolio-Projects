# Exploratory Data Analysis

📌 Colab Notebook: [Link](https://colab.research.google.com/drive/19fWSwd6Pzgmpt2uZGmctln5sd2bVmMs5?usp=sharing)

---

## Truy vấn SQL

### 1. Doanh thu & số đơn hàng theo nhà hàng
```DAX
# Doanh thu & số đơn hàng theo nhà hàng
SELECT r.restaurantName, COUNT(o.orderId) AS total_orders, SUM(o.price) AS total_revenue
FROM `Order` o
JOIN Restaurant r ON o.restaurantName = r.restaurantName
GROUP BY r.restaurantName
ORDER BY total_revenue DESC;
```
<img width="286" height="117" alt="image" src="https://github.com/user-attachments/assets/536eaacb-c27c-4aa8-ae48-12c511592d0d" />

- **Mục tiêu**:
  - Xác định những nhà hàng mang lại **doanh thu cao nhất**.
  - Đo lường **số lượng đơn hàng** để so sánh giữa các nhà hàng.
  - Giúp nhận diện các đối tác (restaurant partner) quan trọng của FoodPanda.
- **Insight**:  
  - Subway dẫn đầu về cả số đơn hàng (1,260) và doanh thu (≈ 1M). 
  - KFC và Pizza Hut cạnh tranh sát sao về doanh thu (~989K).
  </br>-> Điều này cho thấy Subway và KFC là partner chiến lược của FoodPanda, cần ưu tiên trong các chiến dịch marketing & hợp tác.


---

### 2. Doanh thu theo loại món
```DAX
# Doanh thu theo loại món
SELECT d.category, COUNT(o.orderId) AS total_orders, SUM(o.price) AS total_revenue
FROM `Order` o
JOIN Dish d ON o.dishName = d.dishName AND o.restaurantName = d.restaurantName
GROUP BY d.category
ORDER BY total_revenue DESC;
```
<img width="264" height="121" alt="image" src="https://github.com/user-attachments/assets/4178f9ab-4580-48bc-86e4-045cf4da7394" />


- **Mục tiêu**: Phân tích loại món (category) nào mang lại nhiều doanh thu và đơn hàng nhất, từ đó xác định nhóm sản phẩm chủ lực của các nhà hàng.
- **Insight**:
  - Italian và Continental là 2 nhóm món có doanh thu cao nhất (~1.3M mỗi loại), đồng thời cũng có số đơn hàng nhiều nhất → đây là nhóm đặc sản chính cần tập trung.
  - Fast Food đứng thứ 3 cả về đơn và doanh thu → phù hợp cho nhóm khách hàng trẻ, ăn nhanh.
  
---

### 3. Phân bố khách hàng theo độ tuổi và giới tính
```DAX
# Khách hàng theo nhóm tuổi và giới tính
SELECT c.age, c.gender, COUNT(c.customerId) AS total_customers
FROM Customer c
GROUP BY c.age, c.gender
ORDER BY total_customers DESC;
```
<img width="236" height="191" alt="image" src="https://github.com/user-attachments/assets/9c9a76ff-500a-4a8c-9a79-200e92e9a735" />


- **Mục tiêu**: Phân tích cấu trúc khách hàng theo độ tuổi và giới tính để nhận diện nhóm khách hàng chính, từ đó xây dựng chiến lược marketing phù hợp.
- **Insight**:  
  - Nhóm Teenager chiếm tỷ trọng cao nhất (≈ 2,062 khách) → Đây là khách hàng trọng tâm, cần các chiến dịch hướng đến giới trẻ.
  - Trong nhóm Teenager, Male, Other, Female khá cân bằng → cho thấy phân bổ giới tính tương đối đồng đều.

---

### 4. Tỷ lệ khách hàng rời bỏ (Churn Rate) theo nhóm tuổi
```DAX
# Tỷ lệ khách hàng churned theo nhóm tuổi
SELECT c.age, COUNT(*) AS total_customers, 
		SUM(CASE WHEN o.churned='Inactive' THEN 1 ELSE 0 END) AS churned_customers, 
        ROUND(SUM(CASE WHEN o.churned='Inactive' THEN 1 ELSE 0 END)*100/COUNT(*),2) AS churn_rate_percent
FROM `Order` o
JOIN Customer c ON o.customerId = c.customerId
GROUP BY c.age
ORDER BY churn_rate_percent DESC;
```
<img width="416" height="94" alt="image" src="https://github.com/user-attachments/assets/d64e8b54-7508-4b5e-846a-8f260dcc07a3" />

- **Mục tiêu**: Đo lường tỷ lệ khách hàng rời bỏ dịch vụ (churned) theo từng nhóm tuổi, nhằm xác định đâu là nhóm có rủi ro mất khách hàng cao nhất.
- **Insight**:  
  - Nhóm Senior có churn rate cao nhất (51.43%) → nhóm dễ rời bỏ dịch vụ, cần cải thiện trải nghiệm hoặc chương trình chăm sóc khách hàng riêng cho họ.
  - Churn rate giữa các nhóm tuổi không chênh lệch nhiều (48–51%), nghĩa là rủi ro mất khách hàng phổ biến trên toàn bộ độ tuổi, nhưng Seniors là nhóm cần được ưu tiên giữ chân.

---
### 5. Top 5 món ăn được đặt nhiều nhất
```DAX
# Top 5 món được đặt nhiều nhất
SELECT o.dishName, o.restaurantName, SUM(o.quantity) AS total_quantity, SUM(o.price) AS total_revenue
FROM `Order` o
GROUP BY o.dishName, o.restaurantName
ORDER BY total_quantity DESC
LIMIT 5;
```
<img width="360" height="120" alt="image" src="https://github.com/user-attachments/assets/17bf2b0e-ac32-425b-94c1-63d5a82b946d" />

- **Mục tiêu**: Xác định những món ăn bán chạy nhất trên toàn hệ thống, giúp đánh giá xu hướng khẩu vị khách hàng và hỗ trợ các quyết định về menu, marketing, cũng như tối ưu nguồn nguyên liệu.
- **Insight**:  
  - Pasta là món ăn phổ biến nhất, xuất hiện 2 lần trong Top 5 (Subway & Pizza Hut), với tổng lượng đặt hơn 1,700 phần.
  - Pizza cũng là món hot trend, được đặt nhiều từ Subway và KFC.
  - Sandwich (Pizza Hut) góp mặt trong top 5, cho thấy khách hàng ưa chuộng món ăn nhanh, tiện lợi.

---

### 6. Đánh giá trung bình từng nhà hàng
```DAX
# Đánh giá trung bình từng nhà hàng
SELECT o.restaurantName, AVG(o.rating) AS avg_rating, COUNT(o.rating) AS total_ratings
FROM `Order` o
WHERE o.rating IS NOT NULL
GROUP BY o.restaurantName
ORDER BY avg_rating DESC;
```
<img width="333" height="124" alt="image" src="https://github.com/user-attachments/assets/1d489890-1b4b-4c6f-8749-9899adb47634" />

- **Mục tiêu**: Phân tích mức độ hài lòng của khách hàng đối với từng nhà hàng thông qua điểm rating trung bình. Điều này giúp nhận diện nhà hàng nào đang giữ chân khách hàng tốt và nhà hàng nào cần cải thiện chất lượng dịch vụ/đồ ăn.
- **Insight**:  
  - Subway dẫn đầu với mức rating trung bình 2.09/5, tuy nhiên điểm số này vẫn còn thấp → cần chiến lược nâng cao trải nghiệm khách hàng.
  - KFC và McDonald's có mức rating gần tương đương (~2.0), cho thấy sự cạnh tranh khốc liệt trong phân khúc fast food.
  </br>->Điểm số trung bình toàn ngành khá thấp (dưới 2.1/5) → khách hàng nhìn chung chưa thực sự hài lòng.

---

### 7. Doanh thu theo hình thức thanh toán
```DAX
# Doanh thu theo hình thức thanh toán
SELECT o.paymentMethod, COUNT(o.orderId) AS total_orders, SUM(o.price) AS total_revenue
FROM `Order` o
GROUP BY o.paymentMethod
ORDER BY total_revenue DESC;
```
<img width="284" height="82" alt="image" src="https://github.com/user-attachments/assets/4ff1d002-0793-4cf3-aa32-421d13d143a9" />

- **Mục tiêu**: Phân tích hành vi thanh toán của khách hàng để xem kênh nào được ưa chuộng nhất và đóng góp nhiều doanh thu nhất. Thông tin này hỗ trợ việc ưu tiên phát triển và tối ưu hóa các phương thức thanh toán.
- **Insight**:  
  - Cash vẫn là hình thức thanh toán phổ biến nhất, chiếm doanh thu cao nhất 1.65M (≈ 34%).
  - Card và Wallet gần như ngang bằng, với doanh thu ~1.59M và ~1.56M.
  </br>Xu hướng cho thấy khách hàng đang dần dịch chuyển từ tiền mặt sang các phương thức thanh toán điện tử (Card, Wallet) → gợi ý doanh nghiệp nên tiếp tục đẩy mạnh ưu đãi & tiện ích cho thanh toán không tiền mặt để khuyến khích chuyển đổi.

---

### 8. Khách hàng trung thành nhất
```DAX
# Khách trung thành nhất
SELECT o.customerId, MAX(o.orderFrequency) AS max_orders, MAX(o.loyaltyPoints) AS max_points
FROM `Order` o
GROUP BY o.customerId
ORDER BY max_points DESC
LIMIT 10;
```
<img width="253" height="194" alt="image" src="https://github.com/user-attachments/assets/23389bcc-5d9c-4e8c-945c-c6bcddfc6188" />

- **Mục tiêu**: Xác định những khách hàng trung thành nhất, dựa trên loyalty points và tần suất đặt hàng (order frequency). Đây là nhóm khách hàng có giá trị cao cần được chăm sóc đặc biệt.
- **Insight**:  
  - Có nhiều khách hàng đạt mức Loyalty Points tối đa (500) → thể hiện mức độ gắn bó rất cao.
  - Đây chính là nhóm khách hàng VIP, cần được ưu đãi đặc biệt (voucher, chương trình thành viên, khuyến mãi cá nhân hóa).
  - Việc giữ chân nhóm này sẽ giảm churn rate và duy trì doanh thu ổn định.

---

### 9. Doanh thu theo tháng
```DAX
# Doanh thu theo tháng
SELECT MONTH(o.orderDate) AS month, SUM(o.price) AS monthly_revenue
FROM `Order` o
GROUP BY MONTH(o.orderDate)
ORDER BY month;
```

<img width="180" height="230" alt="image" src="https://github.com/user-attachments/assets/0d5ac1a8-6376-4ea2-bfd1-55700c90ef3f" />

---

### 10. Số đơn hàng theo ngày
```DAX
# Số đơn hàng theo ngày
SELECT o.orderDate, COUNT(o.orderId) AS orders_per_day
FROM `Order` o
GROUP BY o.orderDate
ORDER BY o.orderDate;
```
<img width="208" height="403" alt="image" src="https://github.com/user-attachments/assets/dc482950-1a28-4b8b-98eb-524c0ff172da" />

---
# Power BI Dashboard

📌 Report: [Link](https://app.powerbi.com/groups/me/reports/91b03657-b5fa-4ab3-a495-c7f08600e0d8?ctid=0d7d3f95-ac10-4910-a150-837060e32c7c&pbi_source=linkShare)

---

## Measures (DAX)

### 1. Revenue, Orders, Customers
```DAX
Total Revenue = SUM(Orders[price])
Total Order = SUM(Orders[quantity])
Total Customer = DISTINCTCOUNT(Customer[customerId])
```

→ Tổng doanh thu thực tế thu được từ các đơn hàng  

<img width="861" height="131" alt="image" src="https://github.com/user-attachments/assets/e57620bf-55c6-4f9e-8a53-8debccd9784e" />

---

### 2. Doanh thu từ các nhà hàng

<img width="347" height="288" alt="image" src="https://github.com/user-attachments/assets/488ef855-0153-4e1f-94b0-4e6785a2e394" />

---

### 3. Doanh thu và số lần Orders  của tháng này và tháng trước

<img width="624" height="190" alt="image" src="https://github.com/user-attachments/assets/89f37451-b7a1-485d-9f0c-a65a04c0b465" />

---

```DAX
% Churn = [Churned Customers]/[Total Customer]
AVG Rating = AVERAGE(Orders[rating])
Churned Customers = CALCULATE(DISTINCTCOUNT(Customer[customerId]), Orders[churned] = "Inactive")
Prev Month Order = CALCULATE([Total Order], DATEADD('Date'[date], -1, MONTH))
Prev Month Revenue = CALCULATE([Total Revenue], DATEADD('Date'[date], -1, MONTH))
```

---

<img width="1294" height="729" alt="image" src="https://github.com/user-attachments/assets/ab584b33-8afd-4bc5-bc92-7c87585783b3" />

---

<img width="1291" height="732" alt="image" src="https://github.com/user-attachments/assets/cc75dfc8-df0c-4a97-ab1e-3f60a9a3e4c2" />

---

<img width="1397" height="715" alt="image" src="https://github.com/user-attachments/assets/3db5fc92-6bc5-42de-82ec-607bf1fb84df" />
