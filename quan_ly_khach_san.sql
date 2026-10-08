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
    ma_dich_vu VARCHAR(10),
    so_luong INT,
    don_gia INT,
    PRIMARY KEY (id_hoa_don, ma_dich_vu),
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