USE ecommerce_db;

# Doanh thu theo Giới_Tính và Danh_Mục_Mua_Hàng
SELECT c.Giới_Tính, p.Danh_Mục_Mua_Hàng, SUM(f.Số_Tiền_Mua) AS DoanhThu
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
JOIN dimProduct p ON f.ProductKey = p.ProductKey
GROUP BY c.Giới_Tính, p.Danh_Mục_Mua_Hàng
ORDER BY DoanhThu DESC;

# Sản phẩm nào có tỷ lệ trả hàng cao nhất
SELECT p.Danh_Mục_Mua_Hàng, AVG(f.Tỷ_Lệ_Trả_Hàng) AS TyLeTraHang
FROM factSales f
JOIN dimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.Danh_Mục_Mua_Hàng
ORDER BY TyLeTraHang DESC;

# Khách hàng trung thành vs không trung thành
SELECT c.Giới_Tính, c.Tuổi, AVG(f.Trung_Thành_Thương_Hiệu) AS DiemTrungThanh
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
GROUP BY c.Giới_Tính, c.Tuổi
ORDER BY DiemTrungThanh DESC;

# Doanh thu theo tháng
SELECT DATE_FORMAT(f.Thời_Gian_Mua_Date, '%Y-%m') AS Month, 
       SUM(f.Số_Tiền_Mua) AS DoanhThu
FROM factSales f
GROUP BY Month
ORDER BY Month;

# Doanh thu, tần suất mua, độ hài lòng theo giới tính và kênh mua
SELECT c.Giới_Tính, ch.Kênh_Mua, 
       SUM(f.Số_Tiền_Mua) AS DoanhThu, AVG(f.Tần_Suất_Mua) AS TB_TanSuatMua,
       AVG(f.Mức_Độ_Hài_Lòng) AS TB_HaiLong
FROM factSales f
JOIN dimCustomer c ON f.Mã_Khách_Hàng = c.Mã_Khách_Hàng
JOIN dimChannel ch ON f.ChannelKey = ch.ChannelKey
GROUP BY c.Giới_Tính, ch.Kênh_Mua
ORDER BY DoanhThu DESC;

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
