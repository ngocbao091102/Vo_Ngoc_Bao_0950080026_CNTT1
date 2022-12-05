-- Bài 1:Viết các hàm:
-- ➢ Nhập vào MaNV để biết tuổi của nhân viên này.
đi
tạo  hàm fn_TuoiNV(@MaNV nvarchar ( 9 ))
trả về  int
như
bắt đầu
	return ( chọn  NĂM ( getdate ()) - NĂM (NGSINH) là  N ' Tuổi'
		từ NHANVIEN nơi MANV = @MaNV)
chấm dứt
đi
đi
print  ' Tuoi nhan vien:' +  convert ( nvarchar , dbo . fn_TuoiNV ( ' 001' ))

đi

-- ➢ Nhập vào Manv để biết số lượng đề tài mà nhân viên này đã tham gia
đi
tạo  hàm fn_DemDeAnNV(@MaNV varchar ( 9 ))
trả về  int
như
	bắt đầu
		quay lại ( chọn  COUNT (MADA) từ PHANCONG trong đó MA_NVIEN = @MaNV)
	chấm dứt
đi

đi
print  ' so Du an nhan vien da lam' +  convert ( varchar , dbo . fn_DemDeAnNV ( ' 003' ))
đi
-- ➢ Truyền tham số vào phái nam hoặc phái nữ, xuất lượng nhân viên theo phái
đi
tạo  hàm fn_DemNV_Phai(@Phai nvarchar ( 5 ) = N ' %' )
trả về  int
như 
	bắt đầu
		return ( chọn  COUNT ( * ) từ NHANVIEN mà PHAI like @phai )
	chấm dứt
đi

đi
print  ' So luong nhan vien nu:' +  convert ( varchar , fn_DemNV_Phai( N ' Nữ' ))
đi

-- ➢ Truyền tham số đầu vào là tên phòng, tính lương trung bình của phòng đó, Cho biết
-- họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình
-- của phòng đó.
đi
tạo  hàm fn_Luong_NhanVien_PB(@TenPhongBan nvarchar ( 20 ))
trả về bảng @tbLuongNV (tên đầy đủ nvarchar ( 50 ),luong float )
như 
	bắt đầu
		khai báo float @LuongTB
		select @LuongTB =  AVG (LUONG) from NHANVIEN
		nội tham gia PHONGBAN trên  PHONGBAN . MAPHG  =  NHANVIEN . PHG
		trong đó TENPHG = @TenPhongBan
		-- print 'Luong Trung Binh:'+ convert(nvarchar,@LuongTB)
		-- chèn vào bảng
		chèn  vào @tbLuongNV
			chọn HONV +  ' ' + TENLOT + ' ' + TENNV, LUONG từ NHANVIEN
			đâu LUONG > @LuongTB
		trở về
	chấm dứt
đi

-- ➢ Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên trưởng phòng
-- và số lượng đề án mà phòng ban đó chủ trì.
đi
tạo  hàm fn_SoLuongDeAnTheoPB(@MaPB int )
trả về bảng @tbListPB (TenPB nvarchar ( 20 ), MaTB nvarchar ( 10 ), TenTP nvarchar ( 50 ), soluong int )
như
bắt đầu
	chèn  vào @tbListPB
	chọn TENPHG,TRPHG,HONV + ' ' + TENLOT +  ' '  + TENNV là  ' Ten Truong Phog' , COUNT (MADA) là  ' SoLuongDeAn'
		từ PHƯỜNG BAN
		tham gia bên trong DEAN trên  DEAN . PHONG  =  PHONGBAN . MAPHG
		tham gia bên trong NHANVIEN trên  NHANVIEN . MANV  =  PHONGBAN . TRPHG
		nơi  PHONGBÂN . MAPHG  = @MaPB
		nhóm theo TENPHG,TRPHG,TENNV,HONV,TENLOT
	trở về
chấm dứt
đi

-- Bài 2:
-- Create the view:
-- ➢ Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.
đi
tạo chế độ xem v_DD_PhongBan
như
chọn HONV, TENNV, DIADIEM từ PHONGBAN
tham gia bên trong DIADIEM_PHG trên  DIADIEM_PHG . MAPHG  =  PHONGBAN . MAPHG
tham gia bên trong NHANVIEN trên  NHANVIEN . PHG  =  PHONGBAN . MAPHG 

đi

-- ➢ Hiển thị thông tin TenNv, Lương, Tuổi.
đi
tạo view v_TuoiNV
như
select TENNV,LUONG, YEAR ( GETDATE ()) - YEAR (NGSINH) as  ' Tuoi'  from NHANVIEN
đi

-- ➢ Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất
đi
tạo chế độ xem v_LuongNV_PB
như
chọn  trên cùng ( 1 ) TENPHG,TRPHG, B . HONV + ' ' + B . TENLOT + ' ' + B . TENNV  là  ' TENTP' , COUNT ( A . MANV ) là  ' SoLuongNV '  từ NHANVIEN A
nội tham gia PHONGBAN trên  PHONGBAN . MAPHG  =  A . PHG
internal join NHANVIEN B on  B . MANV  =  PHONGBAN . TRPHG
nhóm theo TENPHG,TRPHG, B . TENNV , B . HONV , B. _ TENLOT 
order by SoLuongNV desc
đi