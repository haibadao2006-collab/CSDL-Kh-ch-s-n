DROP DATABASE IF EXISTS quan_ly_khach_san;
CREATE DATABASE quan_ly_khach_san;
USE quan_ly_khach_san;

-- Bảng Chi nhánh
CREATE TABLE chi_nhanh (
    id_chi_nhanh VARCHAR(10) PRIMARY KEY,
    ten_chi_nhanh VARCHAR(50),
    dia_chi VARCHAR(100)
);

-- Bảng SDT chi nhánh (thuộc tính đa hình)
CREATE TABLE chi_nhanh_sdt (
    id_chi_nhanh VARCHAR(10),
    so_dien_thoai VARCHAR(15),
    PRIMARY KEY (id_chi_nhanh, so_dien_thoai),
    FOREIGN KEY (id_chi_nhanh) REFERENCES chi_nhanh(id_chi_nhanh) ON DELETE CASCADE
);

-- Bảng Phòng
CREATE TABLE phong (
    so_phong VARCHAR(10),
    id_chi_nhanh VARCHAR(10),
    loai_phong VARCHAR(20),
    tinh_trang_phong VARCHAR(20),
    gia_tien INT,
    PRIMARY KEY (so_phong, id_chi_nhanh),
    FOREIGN KEY (id_chi_nhanh) REFERENCES chi_nhanh(id_chi_nhanh) ON DELETE CASCADE
);

-- Bảng Nhân viên
CREATE TABLE nhan_vien (
    id_nhan_vien VARCHAR(10) PRIMARY KEY,
    id_chi_nhanh VARCHAR(10),
    ten_nhan_vien VARCHAR(50),
    so_dien_thoai VARCHAR(15),
    dia_chi VARCHAR(100),
    ngay_sinh DATETIME,
    chuc_vu VARCHAR(30),
    email VARCHAR(100),
    cccd VARCHAR(20),
    salary INT,
    FOREIGN KEY (id_chi_nhanh) REFERENCES chi_nhanh(id_chi_nhanh)
);

-- Bảng Khách hàng
CREATE TABLE khach_hang (
    id_khach_hang VARCHAR(10) PRIMARY KEY,
    ten_khach_hang VARCHAR(100),
    cccd VARCHAR(20),
    sdt VARCHAR(15)
);

-- Bảng chi tiết dịch vụ
CREATE TABLE dich_vu (
    id_dich_vu VARCHAR(10) PRIMARY KEY,
    ten_dich_vu VARCHAR(100),
    gia_tien INT
);

-- Bảng Phiếu đặt phòng
CREATE TABLE phieu_dat_phong (
    id_phieu_dat_phong VARCHAR(10) PRIMARY KEY,
    id_khach_hang VARCHAR(10),
    so_phong VARCHAR(10),
    id_chi_nhanh VARCHAR(10),
    id_nhan_vien VARCHAR(10),
    ngay_dat_phong DATETIME,
    ngay_tra_phong DATETIME,
    gia_tien INT,
    FOREIGN KEY (id_khach_hang) REFERENCES khach_hang(id_khach_hang),
    FOREIGN KEY (so_phong, id_chi_nhanh) REFERENCES phong(so_phong, id_chi_nhanh),
    FOREIGN KEY (id_nhan_vien) REFERENCES nhan_vien(id_nhan_vien)
);

-- Bảng hóa đơn dịch vụ
CREATE TABLE hoa_don_dich_vu (
    id_hoa_don VARCHAR(10) PRIMARY KEY,
    id_khach_hang VARCHAR(10),
    id_phieu_dat_phong VARCHAR(10) NULL, 
    id_nhan_vien VARCHAR(10),
    ngay_lap DATETIME,
    trang_thai_thanh_toan VARCHAR(30),
    tong_tien_dich_vu INT DEFAULT 0,
    FOREIGN KEY (id_khach_hang) REFERENCES khach_hang(id_khach_hang),
    FOREIGN KEY (id_phieu_dat_phong) REFERENCES phieu_dat_phong(id_phieu_dat_phong),
    FOREIGN KEY (id_nhan_vien) REFERENCES nhan_vien(id_nhan_vien)
);

-- Bảng chi tiết hóa đơn dịch vụ
CREATE TABLE chi_tiet_hoa_don_dich_vu (
    id_hoa_don VARCHAR(10),
    id_dich_vu VARCHAR(10),
    so_luong INT,
    don_gia INT,
    PRIMARY KEY (id_hoa_don, id_dich_vu),
    FOREIGN KEY (id_hoa_don) REFERENCES hoa_don_dich_vu(id_hoa_don) ON DELETE CASCADE,
    FOREIGN KEY (id_dich_vu) REFERENCES dich_vu(id_dich_vu)
);

-- Bảng hóa đơn thanh toán
CREATE TABLE hoa_don_thanh_toan (
    id_hoa_don_thanh_toan VARCHAR(10) PRIMARY KEY,
    id_phieu_dat_phong VARCHAR(10) UNIQUE,
    id_nhan_vien VARCHAR(10),
    ngay_lap_hoa_don DATETIME,
    tong_tien_thanh_toan INT DEFAULT 0,
    FOREIGN KEY (id_phieu_dat_phong) REFERENCES phieu_dat_phong(id_phieu_dat_phong),
    FOREIGN KEY (id_nhan_vien) REFERENCES nhan_vien(id_nhan_vien)
);
-- Thêm dữ liệu cho 3 Chi nhánh
INSERT INTO chi_nhanh (id_chi_nhanh, ten_chi_nhanh, dia_chi) VALUES
('CN01', 'Chi nhánh Hà Nội', '123 Hà Đông, Hà Nội'),
('CN02', 'Chi nhánh Đà Nẵng', '456 Hoàn Kiếm, Hà Nội'),
('CN03', 'Chi nhánh Hồ Chí Minh', '789 Cầu Giấy, Hà Nội');

-- Thêm dữ liệu cho 10 Phòng (phân bổ cho các chi nhánh)
INSERT INTO phong (so_phong, id_chi_nhanh, loai_phong, tinh_trang_phong, gia_tien) VALUES
('P101', 'CN01', 'Thường', 'Trống', 500000),
('P102', 'CN01', 'Thường', 'Đang thuê', 500000),
('V101', 'CN01', 'VIP', 'Trống', 2000000),
('P201', 'CN02', 'Thường', 'Bảo trì', 500000),
('P202', 'CN02', 'Thường', 'Trống', 500000),
('V201', 'CN02', 'VIP', 'Đang thuê', 2000000),
('P301', 'CN03', 'Thường', 'Trống', 500000),
('P302', 'CN03', 'Thường', 'Đang thuê', 500000),
('V301', 'CN03', 'VIP', 'Trống', 2000000),
('V302', 'CN03', 'VIP', 'Trống', 2000000);

-- Thêm dữ liệu cho 5 Dịch vụ
INSERT INTO dich_vu (id_dich_vu, ten_dich_vu, gia_tien) VALUES
('DV01', 'Giặt ủi', 50000),
('DV02', 'Ăn sáng Buffet', 150000),
('DV03', 'Thuê xe máy', 150000),
('DV04', 'Spa & Massage', 500000),
('DV05', 'Đưa đón sân bay', 300000);

-- Thêm dữ liệu cho 10 Khách hàng (Trong đó có cả khách vãng lai)
INSERT INTO khach_hang (id_khach_hang, ten_khach_hang, cccd, sdt) VALUES
('KH01', 'Nguyễn Văn An', '001090123456', '0901234567'),
('KH02', 'Trần Thị Bình', '002091234567', '0912345678'),
('KH03', 'Lê Hoàng Cường', '003092345678', '0923456789'),
('KH04', 'Phạm Mỹ Dung', '004093456789', '0934567890'),
('KH05', 'Hoàng Văn Em', '005094567890', '0945678901'),
('KH06', 'Vũ Thu Phương', '006095678901', '0956789012'),
('KH07', 'Đặng Kim Giang', '007096789012', '0967890123'),
('KH08', 'Bùi Đức Hùng', '008097890123', '0978901234'),
('KH09', 'Lưu Trần Tiến', NULL, NULL),
('KH10', 'Nguyễn Thảo Anh', NULL, NULL);
