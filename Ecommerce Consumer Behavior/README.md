# Exploratory Data Analysis

📌 Colab Notebook: [Link](https://colab.research.google.com/drive/1GjZv77Cf5YKqVPRnZ_4JpuEMQv1RR3gC?usp=sharing)

---

Bộ dữ liệu này cung cấp một bộ sưu tập toàn diện về dữ liệu hành vi người tiêu dùng có thể được sử dụng cho nhiều nghiên cứu thị trường và phân tích thống kê. Bộ dữ liệu bao gồm thông tin về mô hình mua hàng, nhân khẩu học, sở thích sản phẩm, sự hài lòng của khách hàng, v.v., lý tưởng cho việc phân khúc thị trường, mô hình dự đoán và hiểu rõ quy trình ra quyết định của khách hàng.

## Truy vấn SQL

### 1. Doanh thu theo Giới_Tính và Danh_Mục_Mua_Hàng
```DAX
# Doanh thu theo Giới_Tính và Danh_Mục_Mua_Hàng
SELECT c.Giới_Tính, p.Danh_Mục_Mua_Hàng, SUM(f.Số_Tiền_Mua) AS DoanhThu
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
JOIN dimProduct p ON f.ProductKey = p.ProductKey
GROUP BY c.Giới_Tính, p.Danh_Mục_Mua_Hàng
ORDER BY DoanhThu DESC;
```
<img width="440" height="363" alt="image" src="https://github.com/user-attachments/assets/df9ec073-644f-4075-8602-d24364dd0c2f" />

- **Mục tiêu**:
  - Hiểu nhóm sản phẩm nào phổ biến với từng giới tính.
  - Xác định phân khúc khách hàng tiềm năng để tối ưu chiến dịch marketing.
  - Đề xuất chiến lược sản phẩm phù hợp cho từng nhóm giới tính.
- **Insight**:  
  - Khách hàng nữ chi tiêu cao nhất ở nhóm “Jewelry & Accessories”, cho thấy nhu cầu mạnh với thời trang và phụ kiện cá nhân. 
  - Khách hàng nam tập trung chi tiêu vào đồ gia dụng và thể thao, phản ánh sở thích tiện ích và hoạt động ngoài trời.
  - Doanh thu từ nhóm Packages (combo sản phẩm) của nữ khá cao → gợi ý triển khai chương trình khuyến mãi combo hoặc quà tặng kèm cho nhóm khách hàng này.
  </br>-> Tăng cường chiến dịch quảng cáo thời trang – phụ kiện hướng tới nữ giới.
	</br>-> Đối với nam giới, nên đẩy mạnh quảng bá online cho “Home Appliances” và “Sports & Outdoors”.


---

### 2. Sản phẩm nào có tỷ lệ trả hàng cao nhất
```DAX
# Sản phẩm nào có tỷ lệ trả hàng cao nhất
SELECT p.Danh_Mục_Mua_Hàng, AVG(f.Tỷ_Lệ_Trả_Hàng) AS TyLeTraHang
FROM factSales f
JOIN dimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Danh_Mục_Mua_Hàng
ORDER BY TyLeTraHang DESC;
```
<img width="317" height="271" alt="image" src="https://github.com/user-attachments/assets/1ca1ce8d-e158-4cf2-a6db-602eeb786631" />


- **Mục tiêu**:
  - Đánh giá chất lượng và mức độ hài lòng của khách hàng theo từng nhóm sản phẩm.
  - Đề xuất biện pháp giảm tỷ lệ trả hàng để tối ưu chi phí và trải nghiệm khách hàng.
- **Insight**:
  - “Travel & Leisure (Flights)” có tỷ lệ trả hàng cao nhất (1.32%), cho thấy rủi ro hoàn/hủy giao dịch cao, có thể do chính sách đặt vé linh hoạt hoặc thay đổi kế hoạch cá nhân.
  - “Gardening & Outdoors” và “Office Supplies” cũng có tỷ lệ trả hàng vượt mức trung bình → khả năng đến từ chất lượng không đồng nhất hoặc mô tả sản phẩm chưa rõ ràng.
  - Nhóm Electronics, Sports & Outdoors, và Health Care có tỷ lệ trả hàng thấp → đây là nhóm sản phẩm ổn định và đáng tin cậy.
  </br>-> Tăng chất lượng hình ảnh, mô tả sản phẩm chi tiết cho các danh mục có tỷ lệ trả hàng cao (đặc biệt là Jewelry & Accessories).

---

### 3. Khách hàng trung thành vs không trung thành
```DAX
# Khách hàng trung thành vs không trung thành
SELECT c.Giới_Tính, c.Tuổi, AVG(f.Trung_Thành_Thương_Hiệu) AS DiemTrungThanh
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
GROUP BY c.Giới_Tính, c.Tuổi
ORDER BY DiemTrungThanh DESC;
```
<img width="309" height="274" alt="image" src="https://github.com/user-attachments/assets/4d182de6-bdfc-4be8-ac7a-3a20e62c6f4c" />

---

### 4. Doanh thu theo tháng
```DAX
# Doanh thu theo tháng
SELECT DATE_FORMAT(f.Thời_Gian_Mua_Date, '%Y-%m') AS Month, 
       SUM(f.Số_Tiền_Mua) AS DoanhThu
FROM factSales f
GROUP BY Month
ORDER BY Month;
```
<img width="262" height="277" alt="image" src="https://github.com/user-attachments/assets/91282911-f7ef-4b8b-91b1-e335e0d410fa" />

---
### 5. Doanh thu, tần suất mua, độ hài lòng theo giới tính và kênh mua
```DAX
# Doanh thu, tần suất mua, độ hài lòng theo giới tính và kênh mua
SELECT c.Giới_Tính, ch.Kênh_Mua, 
       SUM(f.Số_Tiền_Mua) AS DoanhThu, AVG(f.Tần_Suất_Mua) AS TB_TanSuatMua,
       AVG(f.Mức_Độ_Hài_Lòng) AS TB_HaiLong
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
JOIN dimChannel ch ON f.ChannelKey = ch.ChannelKey
GROUP BY c.Giới_Tính, ch.Kênh_Mua
ORDER BY DoanhThu DESC;
```
<img width="584" height="276" alt="image" src="https://github.com/user-attachments/assets/4a32eff3-f213-4b53-9c09-10f5025ac39d" />

- **Mục tiêu**:
  - Xác định nhóm khách hàng tiềm năng nhất theo kênh bán hàng.
  - Đánh giá hiệu quả từng kênh phân phối (Online, In-Store, Mixed).
  - Đưa ra định hướng tối ưu chiến lược Marketing & Channel Mix cho từng nhóm giới tính.
- **Insight**:  
  - Nữ giới tạo ra doanh thu cao nhất trên tất cả các kênh, đặc biệt là Mixed channel (43.48k) và Online (42.93k)
  - Nam giới có mức hài lòng trung bình cao hơn một chút (5.69 ở Online), cho thấy nam giới Online có trải nghiệm tốt nhất.
  - Kênh Online mang lại mức độ hài lòng cao nhất trung bình (≈5.6) → là kênh tiềm năng để mở rộng đầu tư và cá nhân hóa trải nghiệm mua sắm.
  - In-Store tuy có tần suất mua khá cao (~7.0) nhưng mức hài lòng thấp hơn → cần xem xét các yếu tố về dịch vụ khách hàng, thời gian chờ thanh toán hoặc trưng bày sản phẩm.
    </br>Tăng đầu tư vào kênh Online & Mixed — đây là nơi doanh thu và hài lòng cao nhất, đặc biệt với nhóm khách hàng nữ.
    </br>Cải thiện trải nghiệm In-Store, ví dụ: rút ngắn thời gian thanh toán, tăng dịch vụ tư vấn, cá nhân hóa ưu đãi cho khách hàng trung thành.

---

### 6. (CASE WHEN) Nhóm khách hàng theo tuổi, thu nhập, tần suất mua
```DAX
# Nhóm khách hàng theo tuổi, thu nhập, tần suất mua
SELECT
    CASE 
        WHEN c.Tuổi < 25 THEN 'Dưới 25'
        WHEN c.Tuổi BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.Tuổi BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.Tuổi BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Nhom_Tuoi,
    c.Mức_Thu_Nhập AS ThuNhap,
    CASE 
        WHEN f.Tần_Suất_Mua < 2 THEN 'Thấp'
        WHEN f.Tần_Suất_Mua BETWEEN 2 AND 5 THEN 'Trung Bình'
        ELSE 'Cao'
    END AS TanSuatMua,
    COUNT(DISTINCT c.Mã_Khách_Hàng) AS SoKhachHang,
    SUM(f.Số_Tiền_Mua) AS DoanhThu,
    AVG(f.Trung_Thành_Thương_Hiệu) AS DiemTrungThanh
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
GROUP BY Nhom_Tuoi, ThuNhap, TanSuatMua
ORDER BY DoanhThu DESC;
```
<img width="675" height="276" alt="image" src="https://github.com/user-attachments/assets/c5852396-31bb-4507-b5b8-4f6316955e5c" />

- **Mục tiêu**:
  - Độ tuổi – phản ánh giai đoạn cuộc sống và hành vi tiêu dùng.
  - Mức thu nhập – ảnh hưởng trực tiếp đến khả năng chi tiêu.
  - Tần suất mua hàng – biểu thị mức độ gắn bó với thương hiệu.
- **Insight**:  
  - Nhóm tuổi 35–44 có thu nhập cao là khách hàng mang lại doanh thu lớn nhất (≈31.6k) — nhóm này có khả năng chi tiêu mạnh và mức độ trung thành ổn định.
  - Nhóm 25–34 tuổi (thu nhập High & Middle) cũng có doanh thu cao và tần suất mua cao → thể hiện hành vi mua hàng tích cực dù điểm trung thành chưa vượt trội.
  </br>->Nhóm có tần suất “Cao” chiếm phần lớn doanh thu → cho thấy mối quan hệ chặt chẽ giữa tần suất mua và tổng chi tiêu.

---

### 7. (CTE) Phân tích doanh thu và độ hài lòng theo category và kênh mua
```DAX
# Phân tích doanh thu và độ hài lòng theo category và kênh mua
WITH SalesSummary AS (
    SELECT 
        p.Danh_Mục_Mua_Hàng AS Category,
        ch.Kênh_Mua AS Channel,
        SUM(f.Số_Tiền_Mua) AS TotalRevenue,
        AVG(f.Mức_Độ_Hài_Lòng) AS AvgSatisfaction,
        COUNT(DISTINCT f.Mã_Khách_Hàng) AS NumCustomers
    FROM factSales f
    JOIN dimProduct p ON f.ProductKey = p.ProductKey
    JOIN dimChannel ch ON f.ChannelKey = ch.ChannelKey
    GROUP BY p.Danh_Mục_Mua_Hàng, ch.Kênh_Mua
)
SELECT *
FROM SalesSummary
WHERE TotalRevenue > 5000
ORDER BY TotalRevenue DESC;
```
<img width="643" height="222" alt="image" src="https://github.com/user-attachments/assets/5207f8fa-78e6-4e77-875a-8d973745a1e0" />

- **Mục tiêu**: xác định nhóm sản phẩm và kênh bán hàng mang lại giá trị cao nhất để hỗ trợ định hướng chiến lược marketing & bán hàng đa kênh
- **Insight**:  
  - Sports & Outdoors (Online) dẫn đầu doanh thu cao nhất (~7,098) nhưng điểm hài lòng chỉ ở mức 5.56/10.
    </br>→ Sản phẩm bán chạy, tuy nhiên trải nghiệm người dùng chưa thực sự tối ưu → Cải thiện hậu mãi, logistics hoặc chính sách đổi trả để giữ chân khách hàng lâu dài.
  - Software & Apps (Mixed) có mức độ hài lòng cao nhất điểm hài lòng 6.25 (cao nhất), doanh thu ~6,800.
  </br>→ Kênh “Mixed” (trực tuyến + cửa hàng) hoạt động hiệu quả, có thể nhờ vào tính linh hoạt và dễ tiếp cận → Tiếp tục mở rộng mô hình bán hàng lai, tăng cường trải nghiệm tích hợp giữa online–offline.
  - Toys & Games (Online) đạt cân bằng tốt, hài lòng cao (6.48), doanh thu ổn định (~5,900). 
	</br>→ Khách hàng trẻ, dễ tương tác trực tuyến — tiềm năng lớn để mở rộng thị phần thông qua các chương trình game.
  - Nhóm In-Store có xu hướng hài lòng thấp hơn: Jewelry & Accessories, Health Supplements có doanh thu ổn nhưng mức hài lòng thấp hơn mức trung bình.
	</br>→ Có thể do chất lượng dịch vụ tại cửa hàng hoặc giá cả chưa tương xứng → Tăng cường đào tạo nhân viên bán hàng & chính sách khuyến mãi riêng cho kênh offline.
---
# Power BI Dashboard

📌 Report: [Link](https://app.powerbi.com/groups/me/reports/bf2670e0-0e51-4447-8ce7-e4bfdee8c7b1?ctid=0d7d3f95-ac10-4910-a150-837060e32c7c&pbi_source=linkShare&bookmarkGuid=83f1f8ba-5dc7-4928-86fc-f8772f5c89d9)

---

## Model View

<img width="1464" height="779" alt="image" src="https://github.com/user-attachments/assets/aec2a7b9-2daf-4a8a-a9fb-8b121d776008" />

---

## Measures (DAX)

```DAX
% đánh giá = DIVIDE(COUNTROWS(factsales),CALCULATE(COUNTROWS(factsales),REMOVEFILTERS(factsales[Đánh_Giá_Sản_Phẩm])))

% KHTT = DIVIDE(CALCULATE(SUMX(dimcustomer, dimcustomer[TV_CTKHTT]), dimcustomer[TV_CTKHTT] = 1), DISTINCTCOUNT(dimcustomer[Mã_Khách_Hàng]))

% trả hàng = DIVIDE(SUM(factsales[Tỷ_Lệ_Trả_Hàng]), [Total Sales])

Đơn trả lại = SUM(factsales[Tỷ_Lệ_Trả_Hàng])

KH churn = CALCULATE(COUNT(factsales[Đánh_Giá_Sản_Phẩm]), factsales[Đánh_Giá_Sản_Phẩm] < 3)

KHTT = CALCULATE(COUNT(dimcustomer[TV_CTKHTT]), dimcustomer[TV_CTKHTT] = 1)

Prev đơn trả lại = CALCULATE([Đơn trả lại], DATEADD(dimtime[Thời_Gian_Mua_Date], -1, MONTH))

Prev KHTT = CALCULATE([KHTT], DATEADD(dimtime[Thời_Gian_Mua_Date], -1, MONTH))

Prev Month Total Sales = CALCULATE([Total Sales], DATEADD(dimtime[Thời_Gian_Mua_Date], -1, MONTH))

Prev Tần suất mua = CALCULATE(SUM(factsales[Tần_Suất_Mua]), DATEADD(dimtime[Thời_Gian_Mua_Date], -1, MONTH))

Tần suất mua = SUM(factsales[Tần_Suất_Mua])

Total Customers = DISTINCTCOUNT(dimcustomer[Mã_Khách_Hàng])

Total Sales = SUM(factsales[Số_Tiền_Mua])
```
<img width="1415" height="797" alt="image" src="https://github.com/user-attachments/assets/48dcaa99-4efe-4e4f-80c1-7a7ef15d35f0" />

---

<img width="1418" height="793" alt="image" src="https://github.com/user-attachments/assets/b35edb65-534b-4db2-bc77-4e0a8b7cf23a" />

---

<img width="1417" height="795" alt="image" src="https://github.com/user-attachments/assets/8160fddb-f496-4745-8d76-70e2e5e02a40" />

---

<img width="1415" height="795" alt="image" src="https://github.com/user-attachments/assets/459f47e3-5f18-4cb6-b9c1-805f5beb8035" />

---

<img width="1416" height="793" alt="image" src="https://github.com/user-attachments/assets/304f9abc-e485-41ef-a18c-4943f1c08b30" />

---

<img width="1417" height="793" alt="image" src="https://github.com/user-attachments/assets/44ad34b6-7e5d-4c96-a386-f03f1f4a5eb2" />

