CREATE DATABASE QUANLIMUAHANG
go
use QUANLIMUAHANG
CREATE TABLE KHACHHANG(
MKH VARCHAR (255) PRIMARY KEY,
TenKH VARCHAR (255),
Email VARCHAR(255),
Phone VARCHAR(255),
DiaChi VARCHAR(255)
)
GO
CREATE TABLE SANPHAM(
MSP VARCHAR(255) PRIMARY KEY,
TenSP VARCHAR(255),
MoTa VARCHAR(255),
GiaSP INT,
SoLuongSP INT
)
GO
CREATE TABLE DONHANG(
MDH VARCHAR(255) PRIMARY KEY,
MPTTT VARCHAR(255)
FOREIGN KEY (MPTTT) REFERENCES PHUONGTHUCTHANHTOAN(MPTTT),
MKH VARCHAR(255)
FOREIGN KEY (MKH) REFERENCES KHACHHANG (MKH),
NgayDD DATE,
TTDH VARCHAR(255),
TongTien INT
)
GO
CREATE TABLE PHUONGTHUCTHANHTOAN(
MPTTT VARCHAR(255) PRIMARY KEY,
TenPTTT VARCHAR(255),
PhiTT INT
)
GO
CREATE TABLE CHITIETDONHANG(
MCTDH VARCHAR(255) PRIMARY KEY,
MDH VARCHAR(255)
FOREIGN KEY (MDH) REFERENCES DONHANG (MDH),
MSP VARCHAR(255)
FOREIGN KEY (MSP) REFERENCES SANPHAM (MSP),
SoLuongSPM INT,
GiaSPM INT,
ThanhTien INT
)
GO
INSERT INTO KHACHHANG VALUES
-- MKH TenKH Email Phone Diachi
('KH01', 'Hoang Van Nhat', 'Nhat@gmail.com' , '012345678', 'Lien Chieu- Da Nang'),
('KH02', 'Nguyen Nhat Anh','Anh@gmail.com','012345687', 'Son Tra - Da Nang'),
('KH03','Tran Anh Tuan', 'Tuan@gmail.com','012345688','Hai Chau - Da Nang'),
('KH04','Le Van Hoang', 'Hoang@gmail.com','012365478','Lien Chieu - Da Nang'),
('KH05' , 'Nguyen Minh Huy', 'Huy@gmail.com', '012398745','Hoa Vang - Da Nang')
GO
INSERT INTO SANPHAM VALUES
---MSP TenSp Mota GiaSP SoLuongSp
('SP1', 'Banh Donut', 'Banh ngot trang mieng','60000','20'),
('SP2','Banh Tiramisu','Banh ngot xuast su tu Y','50000','30'),
('SP3','Banh Mochi','Banh ngot tu Nhat Ban','40000','30'),
('SP4','Banh Black Forest','Banh ngot tu Duc','45000','20'),
('SP5','Banh Limburg Pie','Banh ngot tu Ha Lan','30000','20'),
('SP6','Banh Tao','Banh xuat su tu My','60000','25')
INSERT INTO PHUONGTHUCTHANHTOAN VALUES
--MPTTT TenPTTT PhiTT
('PTTT1','Thanh toan khi nhan duoc hang','20000'),
('PTTT2','Thanh Toan online','10000')
GO
INSERT INTO DONHANG VALUES
--MDH MPTTT MKH NgayDH TrangThai TongTien
('DH1','PTTT1','KH01','2022-2-20','Da dat hang','160000'),
('DH2','PTTT1','KH03','2022-2-22','Dang giao hang','155000'),
('DH3','PTTT2','KH04','2022-2-25','Giao hang thanh cong','120000')
GO
INSERT INTO DONHANG VALUES
--MDH MPTTT MKH NgayDH TrangThai TongTien
('DH4','PTTT2','KH04','2022-2-25','Giao hang thanh cong','120000')
INSERT INTO DONHANG VALUES
('DH5','PTTT1','KH05','2022-2-21','Da dat hang','100000')



INSERT INTO CHITIETDONHANG VALUES
--MCTDH MDH MSP SoLuongSPM GiaSPM ThanhTien
('CTDH1','DH1','SP1','2','70000','140000'),
('CTDH2','DH2','SP5','2','40000','80000'),
('CTDH3','DH2','SP4','1','55000','55000'),
('CTDH4','DH3','SP2','1','60000','60000'),
('CTDH5','DH3','SP3','1','50000','50000')
GO
INSERT INTO CHITIETDONHANG VALUES
('CTDH6','DH4','SP2','1','60000','60000'),
('CTDH7','DH4','SP3','1','50000','50000')
--Tong tien ma khach hang do da mua
CREATE VIEW TONGTIEN AS
SELECT KH.MKH,KH.TenKH, SUM(DH.TongTien) AS N'TongTien' FROM DONHANG DH
JoIN KHACHHANG KH
ON KH.MKH = DH.MKH
GROUP BY KH.MKH,KH.TenKH
GO
DROP VIEW TONGTIEN
SELECT * FROM TONGTIEN

GO
---
CREATE VIEW VIEW_TONGTIEN AS
SELECT KHACHHANG.MKH, KHACHHANG.TenKH, SUM(DONHANG.TongTien) AS N'Tong tien' FROM DONHANG
JOIN KHACHHANG ON KHACHHANG.MKH = DONHANG.MKH
GROUP BY KHACHHANG.MKH, KHACHHANG.TenKH
SELECT * FROM VIEW_TONGTIEN

--xem khách hàng có trạng thái đơn hàng là đã đặt hàng và tổng tiền lớn hơn 150000
CREATE VIEW V_KHACHHANG AS
SELECT KHACHHANG.MKH, KHACHHANG.TenKH,KHACHHANG.Phone, DONHANG.TongTien FROM KHACHHANG
INNER JOIN DONHANG ON KHACHHANG.MKH = DONHANG.MKH
WHERE DONHANG.TTDH = 'Da Dat Hang' AND DONHANG.TongTien > 150000
SELECT * FROM V_KHACHHANG

-- nhap vao MSP in ra gia tien cua san pham do 
CREATE FUNCTION GiaTienSP (@MSP VARCHAR(255))
RETURNS INT
AS
BEGIN
DECLARE @GiaTienSP int
SELECT @GiaTienSP = SP.GiaSP FROM SANPHAM SP WHERE MSP = @MSP
RETURN @GiaTienSP
END
GO
SELECT dbo.GiaTienSP ('SP3')
GO
SELECT dbo.GiaTienSP (MSP) FROM SANPHAM

GO
-- Nhập vào MKH và in ra tổng số tiền mà người đó đã mua
CREATE FUNCTION TongTienKH (@MKH VARCHAR(255))
RETURNS INT
AS
BEGIN
DECLARE @TongTienKH int
SELECT @TongTienKH = SUM(DH.TongTien) FROM KHACHHANG KH JOIN DONHANG DH
ON KH.MKH = DH.MKH WHERE @MKH = DH.MKH
RETURN @TongTienKH
END
GO
DROP FUNCTION TongTienKH




GO
SELECT dbo.TongTienKH('KH04')
--
SELECT * FROM KHACHHANG KH JOIN DONHANG DH
ON KH.MKH = DH.MKH
WHERE DH.TongTien =
(SELECT MAX(SUM(DH.TongTien)) FROM DONHANG DH WHERE month(DH.NgayDD) = 2 )



-- Nhập vào số tháng in ra người mua nhiều hàng nhất
GO
CREATE FUNCTION NguoiMuaHang(@thang INT)
RETURNS VARCHAR(255)
AS
BEGIN
DECLARE @Nguoimuahang VARCHAR(255)

SELECT top 1 @Nguoimuahang = KH.TenKH FROM DONHANG DH JOIN KHACHHANG KH ON DH.MKH = KH.MKH
WHERE month(DH.NgayDD) = @thang GROUP BY KH.MKH,KH.TenKH Order by SUM(DH.TongTien) DESC
RETURN @Nguoimuahang
END
GO
DROP FUNCTION NguoiMuaHang
SELECT dbo.NguoiMuaHang('2')
GO
SELECT SUM(DH.TongTien) FROM DONHANG DH WHERE MONTH(DH.NgayDD) = '2'



GO
-- Tạo thủ tục lưu trữ: Nhập vào MSP đưa ra thông tin chi tiết về MSP đó
CREATE PROC SANPHAMM(@MSP VARCHAR(10)) AS
BEGIN
  IF(exists(SELECT * FROM SANPHAM SP WHERE SP.MSP=@MSP))
    SELECT * FROM SANPHAM SP WHERE SP.MSP=@MSP
  ELSE
    print N'Không tìm thấy sản phẩm có mã ' + @MSP;
END;
GO
EXEC SANPHAMM '*';
GO
EXEC SANPHAMM 'SP1';
GO
DROP PROC SANPHAMM
GO

CREATE PROC DOANHTHUTRONGTHANG(@month INT) AS
BEGIN
  IF(exists(SELECT * FROM DONHANG DH WHERE MONTH(DH.NgayDD) = @month))
   SELECT SUM(DH.TongTien) AS N'DOAnh thu trong tháng' FROM DONHANG DH WHERE MONTH(DH.NgayDD) = @month AND DH.TTDH = 'Giao hang thanh cong'
  ELSE
    print N'Doanh thu thang nay khong co' ;
END;
GO
DROP PROC DOANHTHUTRONGTHANG
GO
EXEC DOANHTHUTRONGTHANG 3;
---Tạo trigger cập nhật số lượng sản phẩm trong kho sau khi người dùng đặt hàng: Phong
CREATE TRIGGER trg_DatHang ON CHITIETDONHANG AFTER INSERT AS
BEGIN
	UPDATE SANPHAM
	SET SoLuongSP = SoLuongSP - ( 
		SELECT SoLuongSPM 
		FROM inserted 
		WHERE MSP = SANPHAM.MSP
	)
	FROM SANPHAM
	JOIN inserted ON SANPHAM.MSP = inserted.MSP
END
SELECT * FROM SANPHAM
INSERT INTO CHITIETDONHANG (MCTDH, MDH, MSP, SoLuongSPM, GiaSPM, ThanhTien) VALUES ('CTDH14','DH1','SP2','10','40000','400000')
--- Tạo triiger cập nhật số lượng sản phẩm trong kho sau khi người dùng hủy đặt hàng: Phong
CREATE TRIGGER trg_HuyDatHang ON CHITIETDONHANG FOR DELETE AS
BEGIN
	UPDATE SANPHAM
	SET SoLuongSP = SoLuongSP + (
		SELECT SoLuongSPM
		FROM deleted
		WHERE MSP = SANPHAM.MSP
	)
	FROM SANPHAM
	JOIN deleted ON SANPHAM.MSP = deleted.MSP
END
SELECT * FROM SANPHAM
DELETE FROM CHITIETDONHANG
WHERE MCTDH = 'CTDH14'

-- Event  cứ 5s tăng 1 số lượng vào toàn bộ sản phẩm và tăng trong vòng 1 phút: Phong
create event example
on schedule every 5 second
starts current_timestamp
ends current_timestamp + interval 1 minute
DO
   UPDATE SANPHAM SET SoLuongSP = SoLuongSP + 1
   WHERE MaSP  lIKE 'SP%';

show events from ql_muahang;
drop event if exists example;



--TRIGGER CẬP NHẬT HÀNG TRONG KHO SAU KHI ĐẶT HÀNG: Phương Anh
CREATE   TRIGGER TRG_DATHANG ON CHITIETDONHANG
AFTER INSERT AS
BEGIN
    UPDATE SANPHAM   SET  SoLuongSP = SoLuongSP - (
                                       SELECT SoLuongSPM
									   FROM inserted
									   WHERE MSP = SANPHAM.MSP )
    FROM SANPHAM
	JOIN inserted ON SANPHAM.MSP = inserted.MSP
END


-- Tạo 1 event tự động cập nhật số lượng bánh trong 
-- bảng SANPHAM mỗi loại hàng đều là 30 sp sau 7r sáng hằng ngày:  Phương Anh 
   CREATE EVENT EV_CAPNHAT
   ON schedule
   EVERY '1' DAY
   STARTS '2022-03-13 07:30:00'
   ON COMPLETION PRESERVE
   DO
   UPDATE SANPHAM SP SET SoLuongSP = 30
   WHERE MSP  lIKE 'SP%'

--TRIGGER GIỚI HẠN SỐ LƯỢNG SẢN PHẨM THÊM VÀO DƯỚI 25 SẢN PHẨM: Bảo


CREATE TRIGGER DEMO
ON dbo.SANPHAM FOR INSERT 
AS 
BEGIN
DECLARE @SP INT;
SELECT @SP = dbo.SANPHAM.SoLuongSP FROM dbo.SANPHAM;
IF @SP>25
BEGIN
RAISERROR(N'VƯỢT QUÁ SỐ LƯỢNG SẢN PHẦM CHO PHÉP',16,1)
ROLLBACK TRANSACTION

END

END

-----



--xóa sản phẩm đồng thời hủy đơn hàng có sản phẩm đó: Nhung
create trigger tr_xoasanpham on SANPHAM
instead of delete as
begin 
declare @MSP varchar(255) = (select MSP from deleted)
delete from SANPHAM where MSP = @MSP

delete from CHITIETDONHANG where MSP = @MSP
end
select * from SANPHAM
select * from CHITIETDONHANG
delete from SANPHAM where MSP =SP4
-- Tạo trigger để kiểm tra thông tin khách hàng đã từng đặt hàng chưa và áp dụng mã giảm giá cho khách hàng đã từng đặt hàng: Việt Anh 
CREATE TRIGGER TRG_INSERT_ORDER
ON DONHANG, KHACHHANG
FOR INSERT
AS
BEGIN
	IF EXIST( SELECT * FROM ORDER JOIN DONHANG.MKH = KHACHHANG.MKH)
BEGIN
UPDATE JOIN DONHANG.MKH = KHACHHANG.MKH 
TONGTIEN SET TONGTIEN = TONGTIEN - (TONGTIEN * 0.5);
END
END

-- Kiểm tra giá sản phẩm lớn hơn 40000: Vĩ

CREATE TRIGGER trg_Checkcost40000

ON SANPHAM
FOR INSERT, UPDATE

AS
	IF( SELECT GiaSP FROM INSERTED) < 40000
	BEGIN
		PRINT N'SP < 40000';
		ROLLBACK TRAN;
	END;
