# Exploratory Data Analysis

📌 Colab Notebook: [Link](https://colab.research.google.com/drive/1rHmiespKPmdhjbclWoxnG3EL3JTQQPuN?usp=sharing)

---

## Truy vấn SQL

### 1. Tổng doanh thu theo ProductCategory
```DAX
SELECT p.ProductCategory, SUM(s.Sales) AS TotalSales, COUNT(DISTINCT s.OrderID) AS NumberOfOrders
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY p.ProductCategory
ORDER BY TotalSales DESC;
```
<img width="304" height="150" alt="image" src="https://github.com/user-attachments/assets/caa9e06b-0928-43e9-835e-075d2edeb360" />

- **Mục tiêu**: Xác định loại sản phẩm đóng góp nhiều doanh thu nhất.
- **Insight**:  
  Classic Cars là *ProductCategory* có doanh thu cao nhất và cũng có số lượng đơn hàng lớn nhất → Có thể tập trung marketing cho **Classic Cars**.

---

### 2. Top 10 khách hàng chi tiêu nhiều nhất
```DAX
SELECT s.CustomerName, SUM(s.Sales) AS TotalSpent
FROM Sales s
GROUP BY CustomerName
ORDER BY TotalSpent DESC
LIMIT 10;
```
<img width="247" height="195" alt="image" src="https://github.com/user-attachments/assets/3655d51f-9105-48d2-8986-5afce6796460" />

- **Mục tiêu**: Xác định khách hàng trọng điểm.
- **Insight**:  
  - **Euro Shopping Channel** là khách hàng quan trọng nhất, chi tiêu gấp ~1.4 lần so với khách hàng đứng thứ 2 (**Mini Gifts Distributors Ltd.**)  
  - Top 2 khách hàng chiếm tỷ trọng lớn trong doanh thu → cần duy trì quan hệ tốt, đồng thời mở rộng thêm khách hàng để giảm phụ thuộc.

---

### 3. Doanh thu theo khách hàng & loại sản phẩm
```DAX
SELECT s.CustomerName, p.ProductCategory, SUM(s.Sales) AS TotalSales
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY s.CustomerName, p.ProductCategory
ORDER BY TotalSales DESC
LIMIT 10;
```
<img width="339" height="194" alt="image" src="https://github.com/user-attachments/assets/d28f7534-909c-4e38-8079-4af402a163cc" />

- **Mục tiêu**: Xem khách hàng mua sản phẩm nào nhiều nhất.
- **Insight**:  
  - Classic Cars thống trị trong doanh thu khách hàng lớn.  
  - Top 5 dòng doanh thu đều gắn với **Classic Cars & Vintage Cars** → Đây là sản phẩm chủ lực cần tập trung sản xuất & marketing.  
  - Rủi ro: Nếu thị trường Classic Cars bão hòa, doanh thu sẽ bị ảnh hưởng nặng → cần chiến lược đa dạng hóa (Vintage Cars, Trucks, Ships...).

---

# Power BI Dashboard

📌 Report: [Link](https://app.powerbi.com/groups/me/reports/02295276-4b4a-4740-89ee-defe18d2e63f?ctid=0d7d3f95-ac10-4910-a150-837060e32c7c&pbi_source=linkShare&bookmarkGuid=f91da584-2e63-4c81-86be-15302f909a85)

---

## Measures (DAX)

### 1. Revenue
```DAX
Revenue = SUM(Sales[Sales])
```
→ Tổng doanh thu thực tế thu được từ các đơn hàng  

<img width="271" height="123" alt="image" src="https://github.com/user-attachments/assets/91298b25-ab7a-46f5-ba92-4b76a300fecf" />


---

### 2. MSRP Revenue
```DAX
MSRP Revenue = SUM(Sales[MSRP Price])
```
 Doanh thu giả định nếu tất cả sản phẩm được bán đúng giá niêm yết (MSRP).

<img width="756" height="236" alt="image" src="https://github.com/user-attachments/assets/a65d003a-b03a-41ce-9211-043269eae305" />

→ Dựa vào kết quả có thể thấy nếu như các sản phẩm của Classic Cars mà được bán với giá niêm yết thì sẽ làm giảm tỷ lệ chênh lệch giữa giá bán thực tế và giá niêm yết -> Cho thấy nếu cố gắng bán sản phẩm bằng hoặc gần bằng giá niêm yết sẽ làm tăng giá trị doanh thu.

---

### 3. PriceDiff
```DAX
PriceDiff = [Revenue] - [MSRP Revenue]
```
- Nếu **âm** → bán thấp hơn MSRP.  
- Nếu **dương** → bán cao hơn MSRP.

---

### 4. % PriceDiff
```DAX
% PriceDiff = ([Revenue] - [MSRP Revenue]) / [MSRP Revenue]
```
→ Tỷ lệ % chênh lệch so với MSRP.

---

### 5. Pre Month Revenue
```DAX
Pre Month Revenue =
    CALCULATE([Revenue], DATEADD('Date'[OrderDate], -1, MONTH))
```
→ Doanh thu tháng trước (dùng KPI để so sánh xu hướng).

<img width="334" height="201" alt="image" src="https://github.com/user-attachments/assets/cb742b96-ae35-43b8-985a-d525f39709ec" />


---

### 6. Pre Month Order
```DAX
Pre Month Order =
    CALCULATE([Total Order], DATEADD('Date'[OrderDate], -1, MONTH))
```
→ Tổng đơn hàng của tháng trước → phân tích xu hướng đặt hàng.

<img width="315" height="198" alt="image" src="https://github.com/user-attachments/assets/ef4b4cc9-cc62-4478-817f-889911dd2f78" />

---

<img width="1608" height="904" alt="image" src="https://github.com/user-attachments/assets/b5e6c47f-b5bd-40eb-b211-6c3d393e9d79" />

---

<img width="1320" height="786" alt="image" src="https://github.com/user-attachments/assets/63715708-a0f5-473c-b382-d901d7f9c584" />
