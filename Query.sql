-- Danh sách phòng trống, theo id chi nhánh > loại phòng
SELECT * from phong
WHERE tinh_trang_phong = 'Trống'
ORDER BY id_chi_nhanh asc, loai_phong asc

-- Danh sách phòng đang có khách ở
SELECT * from phong p
JOIN phieu_dat_phong pdp ON pdp.so_phong = p.so_phong AND pdp.id_chi_nhanh = p.id_chi_nhanh
WHERE tinh_trang_phong = 'Đang thuê' and CURRENT_TIMESTAMP() BETWEEN pdp.ngay_dat_phong AND pdp.ngay_tra_phong
ORDER BY p.id_chi_nhanh asc, p.loai_phong asc

--Lịch sử đặt phòng của 1 khách
SELECT pdp.id_phieu_dat_phong,
	   k.ten_khach_hang,
	   p.so_phong,
       p.loai_phong,
       p.id_chi_nhanh,
       pdp.ngay_dat_phong,
       pdp.ngay_tra_phong,
       pdp.gia_tien as tien_phong
FROM phieu_dat_phong pdp
JOIN khach_hang k ON pdp.id_khach_hang = k.id_khach_hang
JOIN phong p ON p.so_phong = pdp.so_phong and p.id_chi_nhanh = pdp.id_chi_nhanh 
WHERE k.id_khach_hang='KH01'
ORDER BY pdp.ngay_dat_phong ASC


--Lịch sử sử dụng dịch vụ của 1 khách
SELECT pdp.id_phieu_dat_phong,
       k.ten_khach_hang,
       pdp.so_phong,
       pdp.id_chi_nhanh,
       dv.ten_dich_vu,
       ct.so_luong,
       ct.don_gia,
       (ct.so_luong * ct.don_gia) AS thanh_tien,
       hddv.ngay_lap,
       hddv.trang_thai_thanh_toan
FROM phieu_dat_phong pdp
JOIN khach_hang k ON pdp.id_khach_hang = k.id_khach_hang
JOIN hoa_don_dich_vu hddv ON pdp.id_phieu_dat_phong = hddv.id_phieu_dat_phong
JOIN chi_tiet_hoa_don_dich_vu ct ON hddv.id_hoa_don = ct.id_hoa_don
JOIN dich_vu dv ON ct.id_dich_vu = dv.id_dich_vu
WHERE pdp.id_phieu_dat_phong = 'PDP01' 
ORDER BY hddv.ngay_lap ASC;

-- CHi tiết hóa đơn thanh toán
SELECT hdtt.id_hoa_don_thanh_toan,
	   k.ten_khach_hang,
       nv.ten_nhan_vien,
       pdp.so_phong,
       (pdp.gia_tien+IFNULL(SUM(hddv.tong_tien_dich_vu),0)) as tong_tien_thanh_toan,
       hdtt.ngay_lap_hoa_don
FROM hoa_don_thanh_toan hdtt
JOIN phieu_dat_phong pdp ON hdtt.id_phieu_dat_phong = pdp.id_phieu_dat_phong
JOIN khach_hang k ON pdp.id_khach_hang = k.id_khach_hang
JOIN nhan_vien nv ON hdtt.id_nhan_vien = nv.id_nhan_vien
LEFT JOIN hoa_don_dich_vu hddv ON pdp.id_phieu_dat_phong = hddv.id_phieu_dat_phong
WHERE pdp.id_phieu_dat_phong = 'PDP01'
GROUP BY hdtt.id_hoa_don_thanh_toan;
