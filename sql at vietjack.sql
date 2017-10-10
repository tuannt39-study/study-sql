
--Function tạo mã tự động tăng
--1. Kiểu chữ cái trước và số sau: “KH001 > KH002 > … > KH999”
CREATE FUNCTION AUTO_IDKH()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MAKH) FROM KHACHHANG) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MAKH, 3)) FROM KHACHHANG
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'KH00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'KH0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
Sử dụng: Thiết lập mặc định hàm DBO.AUTO_IDKH() cho trường MAKH
CREATE TABLE KHACHHANG(
	MAKH CHAR(5) PRIMARY KEY CONSTRAINT IDKH DEFAULT DBO.AUTO_IDKH(),
	HOTEN NVARCHAR(50) NOT NULL,
	SDT VARCHAR(11) NULL,
	DIACHI NVARCHAR(100) NULL,
	EMAIL VARCHAR(50) NULL
)
--2. Kiểu chỉ bao gồm chữ cái: AAAA > AAAB > … > ZZZZZ
CREATE FUNCTION TAOMAVE(@BEFORECODE CHAR(6))---65->90
RETURNS CHAR(6)
AS
BEGIN
	DECLARE @ONE AS SMALLINT, @TWO SMALLINT, @THREE SMALLINT, @FOUR SMALLINT, @FIVE SMALLINT, @SIX SMALLINT
	DECLARE @MAVE CHAR(6)
	SELECT @ONE=ASCII(LEFT(@BEFORECODE,1))
	SELECT @TWO=ASCII(SUBSTRING(@BEFORECODE,2,1))
	SELECT @THREE=ASCII(SUBSTRING(@BEFORECODE,3,1))
	SELECT @FOUR=ASCII(SUBSTRING(@BEFORECODE,4,1))
	SELECT @FIVE=ASCII(SUBSTRING(@BEFORECODE,5,1))
	SELECT @SIX=ASCII(RIGHT(@BEFORECODE,1))
	IF @SIX<90
		SELECT @SIX=@SIX+1
	ELSE
		BEGIN
			SELECT @SIX=65
			IF @FIVE<90
				SELECT @FIVE=@FIVE+1
			ELSE
				BEGIN
					SELECT @FIVE=65
					IF @FOUR<90
						SELECT @FOUR=@FOUR+1
					ELSE
						BEGIN
							SELECT @FOUR=65
							IF @THREE<90
								SELECT @THREE=@THREE+1
							ELSE
								BEGIN
									SELECT @THREE=65
									IF @TWO<90
										SELECT @TWO=@TWO+1
									ELSE
										BEGIN
											SELECT @TWO=65
											IF @ONE<90
												SELECT @ONE=@ONE+1
											ELSE
												RETURN NULL
										END				
								END			
						END		
				END	
		END
	SELECT @MAVE=CHAR(@ONE)+CHAR(@TWO)+CHAR(@THREE)+CHAR(@FOUR)+CHAR(@FIVE)+CHAR(@SIX)
	RETURN @MAVE
END
--3. Kiểu Ngày Tháng Năm + Chữ cái + Số tự động tăng: 01012001DV00001 > 02012001DV00002
CREATE FUNCTION auto_iddv()
RETURNS VARCHAR(15)
AS
BEGIN
	DECLARE @id VARCHAR(15)
	IF (SELECT COUNT(MaDV) FROM DATVE) = 0
		SET @id = '0'
	ELSE
		SELECT @id = MAX(RIGHT(MaDV, 5)) FROM DATVE
		SELECT @id = CASE
			WHEN @id = 99999 THEN CONVERT(VARCHAR,GETDATE(),112) + 'DV00001'
			WHEN @id >= 0 and @id < 9 THEN CONVERT(VARCHAR,GETDATE(),112) + 'DV0000' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 9 THEN CONVERT(VARCHAR,GETDATE(),112) + 'DV000' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 99 THEN CONVERT(VARCHAR,GETDATE(),112) + 'DV00' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 999 THEN CONVERT(VARCHAR,GETDATE(),112) + 'DV0' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
			WHEN @id >= 9999 THEN CONVERT(VARCHAR,GETDATE(),112) + 'DV' + CONVERT(CHAR, CONVERT(INT, @id) + 1)
		END
	RETURN @id
END


--MySQL convert có dấu sang không dấu
--function convertAlias($cs){
$vietnamese=array("à","á","ạ","ả","ã","â","ầ","ấ","ậ","ẩ","ẫ","ă","ằ","ắ","ặ","ẳ","ẵ",
"è","é","ẹ","ẻ","ẽ","ê","ề","ế","ệ","ể","ễ",
"ì","í","ị","ỉ","ĩ",
"ò","ó","ọ","ỏ","õ","ô","ồ","ố","ộ","ổ","ỗ","ơ","ờ","ớ","ợ","ở","ỡ",
"ù","ú","ụ","ủ","ũ","ư","ừ","ứ","ự","ử","ữ",
"ỳ","ý","ỵ","ỷ","ỹ",
"đ",
"À","Á","Ạ","Ả","Ã"," ","Ầ","Ấ","Ậ","Ẩ","Ẫ","Ă","Ằ","Ắ","Ặ","Ẳ","Ẵ",
"È","É","Ẹ","Ẻ","Ẽ","Ê","Ề","Ế","Ệ","Ể","Ễ",
"Ì","Í","Ị","Ỉ","Ĩ",
"Ò","Ó","Ọ","Ỏ","Õ","Ô","Ồ","Ố","Ộ","Ổ","Ỗ","Ơ","Ờ","Ớ","Ợ","Ở","Ỡ",
"Ù","Ú","Ụ","Ủ","Ũ","Ư","Ừ","Ứ","Ự","Ử","Ữ",
"Ỳ","Ý","Ỵ","Ỷ","Ỹ",
"Đ");
$latin=array("a","a","a","a","a","a","a","a","a","a","a","a","a","a","a","a","a",
"e","e","e","e","e","e","e","e","e","e","e",
"i","i","i","i","i",
"o","o","o","o","o","o","o","o","o","o","o","o","o","o","o","o","o",
"u","u","u","u","u","u","u","u","u","u","u",
"y","y","y","y","y",
"d",
"A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A","A",
"E","E","E","E","E","E","E","E","E","E","E",
"I","I","I","I","I",
"O","O","O","O","O","O","O","O","O","O","O","O","O","O","O","O","O",
"U","U","U","U","U","U","U","U","U","U","U",
"Y","Y","Y","Y","Y",
"D");
$csLatin= str_replace($vietnamese,$latin,$cs);
return $csLatin;
}


--http://vietjack.com/mysql/index.jsp

-- Tạo Database trong MySQL
CREATE DATABASE sinhvien;

--  Tạo bảng trong MySQL
SELECT * FROM sinhvienk60 WHERE ten="Thanh";

-- Xóa cơ sở dữ liệu trong MySQL
DROP DATABASE sinhvien;

-- Chọn cơ sở dữ liệu trong MySQL
USE sinhvien;

-- Tạo bảng trong MySQL
CREATE TABLE sinhvienk60 (
mssv INT NOT NULL AUTO_INCREMENT,
ho VARCHAR(255) NOT NULL,
ten VARCHAR(255) NOT NULL,
tuoi INT NOT NULL,
diemthi FLOAT(4,2) NOT NULL,
PRIMARY KEY (mssv)
);

-- Xóa bảng trong MySQL
DROP TABLE sinhvienk60;

-- Truy vấn INSERT trong MySQL - để chèn dữ liệu vào trong bảng MySQL
INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Dinh Van", "Cao", 8);

INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Nguyen Van", "Thanh", 9);

INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Nguyen Hoang", "Manh", 7.5);

INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Tran Van", "Nam", 10);

-- Truy vấn SELECT trong MySQL - lấy dữ liệu từ bảng MySQL
SELECT * FROM sinhvienk60;

-- Mệnh đề WHERE trong MySQL - lọc các kết quả thu được
SELECT * FROM sinhvienk60 WHERE ten="Thanh";

-- Truy vấn UPDATE trong MySQL - sửa đổi bất kỳ giá trị trường nào trong bất cứ bảng MySQL nào
UPDATE sinhvienk60 SET ten="Huong" WHERE mssv=3;

-- Truy vấn DELETE trong MySQL - xóa một bản ghi từ bất cứ bảng MySQl nào
DELETE FROM sinhvienk60 WHERE mssv=4;


-- Mệnh đề LIKE trong MySQL - lọc các kết quả thu được
SELECT * FROM sinhvienk60 WHERE ho LIKE 'Nguyen%';

-- Mệnh đề ORDER BY trong MySQL - sắp xếp dữ liệu từ bảng MySQL - ASC tăng dần - DESC giảm dần
SELECT * FROM sinhvienk60 ORDER BY diemthi ASC;

-- Sử dụng JOIN trong MySQL - ghim các cột của hai hoặc nhiều bảng vào trong một bảng đơn
//Lua chon co so du lieu
USE sinhvien;
//Tao bang
CREATE TABLE hocphik60 (
 ten VARCHAR(255) NOT NULL,
hocphi INT NOT NULL
);

//Chen du lieu vao bang
INSERT INTO hocphik60 (ten, hocphi)
VALUES ('Nam', 4000000);

INSERT INTO hocphik60 (ten, hocphi)
VALUES ('Thanh', 3500000);

INSERT INTO hocphik60 (ten, hocphi)
VALUES ('Cao', 4500000);

INSERT INTO hocphik60 (ten, hocphi)
VALUES ('Huong', 3000000);

SELECT a.mssv, a.ten, b.hocphi
    FROM sinhvienk60 a, hocphik60 b
    WHERE a.ten = b.ten;

-- Sử dụng RIGHT JOIN trong MySQL - trả về tất cả hàng từ bảng bên phải, ngay cả khi không có so khớp nào trong bảng bên trái, hiển thị NULL
SELECT a.mssv, a.ten, b.hocphi
    FROM sinhvienk60 a RIGHT JOIN hocphik60 b
    ON a.ten = b.ten;

-- Xử lý giá trị NULL trong MySQL
--IS NULL: Toán tử này trả về true nếu giá trị cột là NULL.
--IS NOT NULL: Toán tử này trả về true nếu giá trị côt không là NULL.
--<=>: Toán tử này so sánh các giá trị, mà (không giống toán tử =) là true khi hai giá trị là NULL.
//Chon co so du lieu

USE sinhvien;
//Tao bang hocphik59

CREATE TABLE hocphik59 (
 ten VARCHAR(255) NOT NULL,
hocphi INT
);

//Chen du lieu vao bang hocphik59
INSERT INTO hocphik59 (ten, hocphi)
VALUES ('Nam', 4000000);

INSERT INTO hocphik59 (ten, hocphi)
VALUES ('Thanh', NULL);

INSERT INTO hocphik59 (ten, hocphi)
VALUES ('Cao', NULL);

INSERT INTO hocphik59 (ten, hocphi)
VALUES ('Huong', 3000000);

SELECT * FROM hocphik59;

SELECT * FROM hocphik59 WHERE hocphi = NULL;

SELECT * FROM hocphik59 WHERE hocphi != NULL;

SELECT * FROM hocphik59 
   WHERE hocphi IS NULL;
   
SELECT * FROM hocphik59 
   WHERE hocphi IS NOT NULL;   

   -- Regexp trong MySQL
--^	Phần đầu của chuỗi
--$	Phần cuối của chuỗi
--.	Bất kỳ ký tự đơn nào
--[...]	Bất kỳ ký tự nào được liệt kê trong dấu ngoặc vuông
--[^...]	Bất kỳ ký tự nào không được liệt kê trong dấu ngoặc vuông
--p1|p2|p3	Bất kỳ mẫu p1, p2 hoặc p3 nào
--*	0 hoặc nhiều instance (sự thể hiện) của phần tử ở trước
--+	1 hoặc nhiều instance (sự thể hiện) của phần tử ở trước
--{n}	n instance (sự thể hiện) của phần tử ở trước
--{m,n}	Từ m tới n instance (sự thể hiện) của phần tử ở trước

-- Truy vấn để tìm tất cả ten bắt đầu với '^Ng':
SELECT ten FROM sinhvienk60 WHERE ten REGEXP '^Ng';

-- Truy vấn để tìm tất cả ten kết thúc với 'ng$':
SELECT ten FROM sinhvienk60 WHERE ten REGEXP 'ng$';

-- Truy vấn để tìm tất cả ten chứa 'ao':
SELECT ten FROM sinhvienk60 WHERE ten REGEXP 'ao';

-- Truy vấn để tìm tất cả ten bắt đầu với một nguyên âm và kết thúc với 'nh':
SELECT ten FROM sinhvienk60 WHERE ten REGEXP '^[aeiou]|nh$';

-- Transaction trong MySQL - là một đơn vị công việc được thực hiện bởi một Database
//Lua chon co so du lieu
USE sinhvien;
//Tao bang sinhvienk60

--Bảng hỗ trợ cho các Transaction - InnoDB
CREATE TABLE sinhvienk60 (
   ten VARCHAR(40) NOT NULL,
   diemthi  INT
) TYPE=InnoDB;

-- Lệnh ALTER trong MySQL - Thay đổi tên, thêm, xóa cột, bảng, bất kỳ trường nào.
--Tạo bảng hocphik61
//Lua chon co so du lieu
USE sinhvien;
//Tao bang hocphik61

CREATE TABLE hocphik61 (
   ten VARCHAR(40),
   hocphi  INT
);

//Hien thi tat ca cac cot trong bang hocphik61
SHOW COLUMNS FROM hocphik61;

--Xóa, thêm hoặc tái định vị một cột trong MySQL
ALTER TABLE hocphik61  DROP ten;
ALTER TABLE hocphik61 ADD ten VARCHAR(40);
SHOW COLUMNS FROM hocphik61;

ALTER TABLE hocphik61 DROP ten;
ALTER TABLE hocphik61 ADD ten VARCHAR(40) FIRST; //them cot ten thanh cot dau tien
ALTER TABLE hocphik61 DROP ten;
ALTER TABLE hocphik61 ADD ten VARCHAR(40) AFTER hocphi; //them cot ten sau cot hocphi

--Thay đổi một định nghĩa hoặc tên cột trong MySQL
ALTER TABLE hocphik61 MODIFY ten VARCHAR(20);
ALTER TABLE hocphik61 CHANGE ten hoten VARCHAR(60);
ALTER TABLE hocphik61 CHANGE hoten hoten VARCHAR(40);

--Tác động của ALTER TABLE trên các giá trị NULL và DEFAULT
ALTER TABLE hocphik61 
    MODIFY hocphi BIGINT NOT NULL DEFAULT 4000000;

	--Thay đổi giá trị DEFAULT của một cột trong MySQL
ALTER TABLE hocphik61 ALTER hocphi SET DEFAULT 3000000;
//hien thi cac cot
SHOW COLUMNS FROM hocphik61;

ALTER TABLE hocphik61 ALTER hocphi DROP DEFAULT;

//hien thi cac cot
SHOW COLUMNS FROM hocphik61;

--Thay đổi một kiểu bảng trong MySQL
ALTER TABLE hocphik61 ENGINE = MyISAM;
SHOW TABLE STATUS LIKE 'hocphik61'

--Thay tên cho bảng trong MySQL
ALTER TABLE hocphik61 RENAME TO hocphik62;

-- Chỉ mục (INDEX) trong MySQL - chỉ mục là một cấu trúc dữ liệu mà cải thiện tốc độ của các hoạt động trong một bảng
--Simple Index và Unique Index trong MySQL
CREATE UNIQUE INDEX tenchimuc
ON sinhvienk60 (ten)

CREATE UNIQUE INDEX tenchimuc
ON sinhvienk60 (ten DESC)

--Lệnh ALTER để thêm và xóa INDEX trong MySQL
ALTER TABLE sinhvienk59 ADD INDEX (ho);

ALTER TABLE sinhvienk59 DROP INDEX (ho);

--Lệnh ALTER để thêm và xóa PRIMARY KEY
ALTER TABLE sinhvienk59 MODIFY diemthi INT NOT NULL;
ALTER TABLE sinhvienk59 ADD PRIMARY KEY (diemthi);

ALTER TABLE sinhvienk59 DROP PRIMARY KEY;
--Hiển thị thông tin chỉ mục trong MySQL
--HOW INDEX FROM ten_bang\G
--.........

-- Bảng tạm trong MySQL - bảng tạm là chúng sẽ bị xóa khi phiên (session) hiện tại trên Client kết thúc.
--Tạo bảng tạm bangdiemk60 trong csdl sinhvien
//Chon co so du lieu
USE sinhvien;

//Tao bang tam bangdiemk60
CREATE TEMPORARY TABLE bangdiemk60 (
ho VARCHAR(50) NOT NULL,
ten VARCHAR(20) NOT NULL,
diemgk FLOAT(4,2) NOT NULL DEFAULT 0.00,
diemck FLOAT(4,2) NOT NULL DEFAULT 0.00
);

//Chen du lieu vao bang
INSERT INTO bangdiemk60 (ho, ten, diemgk, diemck)
VALUES ('Tran Minh', 'Chinh', 8, 9);

//hien thi du lieu cua bang
SELECT * FROM bangdiemk60;
--Xóa bảng tạm trong MySQL
DROP TABLE bangdiemk60;

//Bay gio, neu ban su dung lenh SELECT
SELECT * FROM bangdiemk60;
//thi no se cho mot loi nhu sau
//--Error Code: 1146. Table 'sinhvien.bangdiemk60' doesn't exist

-- Mô phỏng bảng trong MySQL
--Tạo bảng mô phỏng cho sinhvienk60
//Bước 1: Lấy toàn bộ cấu trúc của bảng với lệnh SHOW CREATE TABLE ten_bang;:
SHOW CREATE TABLE sinhvienk60;

CREATE TABLE `sinhvienk60` (
  `mssv` int(11) NOT NULL AUTO_INCREMENT,
  `ho` varchar(255) NOT NULL,
  `ten` varchar(255) NOT NULL,
  `diemthi` float(4,2) NOT NULL,
  PRIMARY KEY (`mssv`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8

//Bước 2: Thay tên bảng này và tạo bảng khác.
CREATE TABLE `sinhvienk61` (
  `mssv` int(11) NOT NULL AUTO_INCREMENT,
  `ho` varchar(255) NOT NULL,
  `ten` varchar(255) NOT NULL,
  `diemthi` float(4,2) NOT NULL,
  PRIMARY KEY (`mssv`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8

//Bước 3: Sau khi thực thi bước 2, bạn sẽ mô phỏng một bảng trong Database. Nếu bạn muốn sao chép dữ liệu từ bảng cũ, thì bạn có thể thực hiện bằng việc sử dụng lệnh INSERT INTO … SELECT.
INSERT INTO sinhvienk61 (mssv, ho, ten, diemthi)
      SELECT mssv, ho, ten, diemthi FROM sinhvienk60;

-- Lấy và sử dụng MySQL Metadata
//Lấy số hàng bị tác động bởi một Truy vấn trong MySQL
$result_id = mysql_query ($query, $conn_id);
# report 0 rows if the query failed
$count = ($result_id ? mysql_affected_rows ($conn_id) : 0);
print ("$count rows were affected\n");
//Liệt kê các bảng và cơ sở dữ liệu trong MySQL
<?php
$con = mysql_connect("localhost", "userid", "password");
if (!$con)
{
  die('Khong the ket noi: ' . mysql_error());
}

$db_list = mysql_list_dbs($con);

while ($db = mysql_fetch_object($db_list))
{
  echo $db->Database . "<br />";
}
mysql_close($con);
?>
//Lấy Server Metadata trong MySQL
SELECT VERSION( )	Phiên bản Server (dạng chuỗi)
SELECT DATABASE( )	Tên cơ sở dữ liệu hiện tại (là trống nếu không có)
SELECT USER( )	Username hiện tại
SHOW STATUS	Trạng thái Server
SHOW VARIABLES	Các biến cấu hình Server

-- Sử dụng Sequence trong MySQL - một tập hợp các số nguyên 1, 2, 3, … mà được tạo theo nhu cầu
//Sử dụng AUTO_INCREMENT column - tự động tằng bởi mysql
//Tao bang sinhvienk60
CREATE TABLE sinhvienk60 (
mssv INT NOT NULL AUTO_INCREMENT,
ho VARCHAR(255) NOT NULL,
ten VARCHAR(255) NOT NULL,
tuoi INT NOT NULL,
diemthi FLOAT(4,2) NOT NULL,
PRIMARY KEY (mssv)
);

//Chen du lieu vao bang
INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Dinh Van", "Cao", 8);

INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Nguyen Van", "Thanh", 9);

INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Nguyen Hoang", "Manh", 7.5);

INSERT INTO sinhvienk60 (ho, ten, diemthi)
VALUES ("Tran Van", "Nam", 10);

//Lấy các giá trị AUTO_INCREMENT
mysql_query ("INSERT INTO sinhvienk60 (ho,ten,diemthi)
VALUES('Nguyen Van','Thanh','9')", $conn_id);
$seq = mysql_insert_id ($conn_id);

//Đánh số lại một Sequence đang tồn tại
//Dau tien, ban xoa cot
ALTER TABLE sinhvienk60 DROP mssv;

//Sau do, them lai cot do
ALTER TABLE sinhvienk60
    ADD mssv INT NOT NULL AUTO_INCREMENT,
    ADD PRIMARY KEY (mssv);

//Bắt đầu một Sequence tại một giá trị cụ thể
//Tao bang sinhvienk60 voi mssv bat dau tu 10
CREATE TABLE sinhvienk60 (
mssv INT NOT NULL AUTO_INCREMENT = 10,
ho VARCHAR(255) NOT NULL,
ten VARCHAR(255) NOT NULL,
tuoi INT NOT NULL,
diemthi FLOAT(4,2) NOT NULL,
PRIMARY KEY (mssv)
);

//Cách khác, bạn có thể tạo bảng và sau đó thiết lập giá trị khởi tạo cho Sequence với lệnh ALTER TABLE.
//Dau tien, ban tao bang
//Sau do, thiet lap gia tri khoi tao cho sequence nhu sau:
ALTER TABLE ten_bang AUTO_INCREMENT = 100;

-- Xử lý bản sao trong MySQL
//Ngăn cản bản sao xuất hiện trong một bảng
CREATE TABLE nhanvienIT
(
    ho CHAR(20),
    ten CHAR(20),
    diachi CHAR(30)
);

CREATE TABLE nhanvienIT
(
   ho CHAR(20) NOT NULL,
   ten CHAR(20) NOT NULL,
   diachi CHAR(30),
   PRIMARY KEY (ho, ten)
);

mysql> INSERT IGNORE INTO nhanvienIT (ho, ten)
    -> VALUES( 'Jay', 'Thomas');
Query OK, 1 row affected (0.00 sec)
mysql> INSERT IGNORE INTO nhanvienIT (ho, ten)
    -> VALUES( 'Jay', 'Thomas');
Query OK, 0 rows affected (0.00 sec)

mysql> REPLACE INTO nhanvienIT (ho, ten)
    -> VALUES( 'Ajay', 'Kumar');
Query OK, 1 row affected (0.00 sec)
mysql> REPLACE INTO nhanvienIT (ho, ten)
    -> VALUES( 'Ajay', 'Kumar');
Query OK, 2 rows affected (0.00 sec)

CREATE TABLE nhanvienIT
(
   ho CHAR(20) NOT NULL,
   ten CHAR(20) NOT NULL,
   diachi CHAR(30)
   UNIQUE (ho, ten)
);

//Đếm và xác định các bản sao trong MySQL
SELECT COUNT(*) as sobansao, ho, ten
    FROM nhanvienIT
    GROUP BY ho, ten
    HAVING sobansao > 1;

//Loại bỏ bản sao từ một kết quả truy vấn
SELECT DISTINCT ho, ten
    FROM nhanvienIT
    ORDER BY ten;

//Ngoài DISTINCT, bạn thêm một mệnh đề GROUP BY để xác định các cột bạn đang chọn.
SELECT ho, ten
    FROM nhanvienIT
    GROUP BY (ho, ten);

//Xóa bản sao bởi sử dụng bảng thay thế	
CREATE TABLE nhanvienIT1 SELECT ho, ten, diachi
                     FROM nhanvienIT;
                     GROUP BY (ho, ten);
DROP TABLE nhanvienIT;
ALTER TABLE nhanvienIT1 RENAME TO nhanvienIT;

ALTER IGNORE TABLE nhanvienIT
    ADD PRIMARY KEY (ho, ten);

-- Injection trong MySQL và SQL
//SQL Injection là user input thông qua webpage chèn nó vào trong sql database
//Trong ví dụ dưới, name bị giới hạn là các ký tự chữ-số cộng với dấu gạch dưới và có độ dài từ 8 đến 20 ký tự (bạn có thể sửa đổi nếu thấy cần thiết).
if (preg_match("/^\w{8,20}$/", $_GET['username'], $matches))
{
   $result = mysql_query("SELECT * FROM nhanvienIT 
                          WHERE username=$matches[0]");
}
 else 
{
   echo "Ten su dung khong duoc chap nhan";
}
//May mắn là, nếu bạn sử dụng MySQL, hàm mysql_query() không cho phép Query Stacking hoặc thực thi nhiều truy vấn SQL trong một lời gọi hàm đơn. Nếu bạn nỗ lực để thực hiện nhiều truy vấn, lời gọi hàm sẽ thất bại.
// gia su co input nhu sau:
$name = "Thanh'; DELETE FROM nhanvienIT;";
mysql_query("SELECT * FROM nhanvienIT WHERE name='{$name}'");

//Ngăn chặn SQL Injection
if (get_magic_quotes_gpc()) 
{
  $name = stripslashes($name);
}
$name = mysql_real_escape_string($name);
mysql_query("SELECT * FROM nhanvienIT WHERE name='{$name}'");

//Để định vị một LIKE Quandary, một kỹ thuật do người dùng tạo phải chuyển đổi các ký tự '%' và '_' do người dùng cung cấp thành literal (hằng). Sử dụng hàm addcslashes(), một hàm mà giúp bạn xác định một dãy ký tự để thoát.
//LIKE Quandary trong MySQL
$sub = addcslashes(mysql_real_escape_string("%something_"), "%_");
// $sub == \%something\_
mysql_query("SELECT * FROM messages WHERE subject LIKE '{$sub}%'");

-- Export và Phương thức Backup trong MySQL
//Export với lệnh SELECT…INTO OUTFILE trong MySQL
SELECT * FROM sinhvienk60 
    INTO OUTFILE '/tmp/vietjack.txt';

	
SELECT * FROM passwd INTO OUTFILE '/tmp/vietjack.txt'
    FIELDS TERMINATED BY ',' ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n';
	
//Xuất bảng dưới dạng dữ liệu thô
$ mysqldump -u root -p --no-create-info \
            --tab=/tmp sinhvien sinhvienk60
password ******

//Xuất nội dung hoặc định nghĩa bảng trong định dạng SQL
$ mysqldump -u root -p sinhvien sinhvienk60 > dump.txt
password ******

$ mysqldump -u root -p sinhvien > database_dump.txt
password ******

$ mysqldump -u root -p --all-databases > database_dump.txt
password ******

//Sao chép bảng hoặc cơ sở dữ liệu tới Host khác
$ mysqldump -u root -p ten_database ten_bang > dump.txt
password *****

$ mysql -u root -p ten_database < dump.txt
password *****

$ mysqldump -u root -p ten_database \
       | mysql -h other-host.com ten_database

-- Import và phương thức Recovery trong MySQL
//Import với LOAD DATA
mysql> LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE sinhvienk60;

mysql> LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE sinhvienk60
  -> FIELDS TERMINATED BY ':'
  -> LINES TERMINATED BY '\r\n';
  
mysql> LOAD DATA LOCAL INFILE 'dump.txt' 
    -> INTO TABLE sinhvienk60 (b, c, a);
	
//Import với mysqlimport

$ mysqlimport -u root -p --local ten_database dump.txt
password *****

$ mysqlimport -u root -p --local --fields-terminated-by=":" \
   --lines-terminated-by="\r\n"  ten_database dump.txt
password *****

$ mysqlimport -u root -p --local --columns=b,c,a \
    ten_database dump.txt
password *****

//Xử lý trích dẫn và các ký tự đặc biệt


-- Mệnh đề GROUP BY trong MySQL - Nhóm giá trị từ 1 cột và thực hiện tính toán trên cột đó với hàm COUNT, SUM, AVG,...
mysql> SELECT COUNT(*) FROM sinhvienk58;

SELECT diemthi, COUNT(*)
    FROM   sinhvienk58 
    GROUP BY diemthi;
	
-- Mệnh đề IN trong MySQL - thay thế cho nhiều điều kiện OR
SELECT * FROM sinhvienk58 
    WHERE diemthi= 8.50 OR  
    diemthi= 9.00 OR  diemthi= 9.50; 

SELECT * FROM sinhvienk58 
    WHERE diemthi IN ( 8.50, 9.00, 9.50 );
//Lenh nay cho ket qua nhu tren

-- Mệnh đề BETWEEN trong MySQL - thay thế một tổ hợp các điều kiện "lớn hơn hoặc bằng AND nhỏ hơn hoặc bằng".
mysql> SELECT * FROM sinhvienk58;

SELECT * FROM sinhvienk58 
    WHERE diemthi >= 8.50 AND
    diemthi <= 9.50;

SELECT * FROM sinhvienk58 
    WHERE diemthi BETWEEN 8.50 AND 9.50; 
//Lenh nay cho ket qua nhu tren	
	

-- Từ khóa UNION trong MySQL - lựa chọn các hàng (hàng này sau hàng kia) từ các bảng hoặc một số tập hợp các hàng từ một bảng đơn dưới dạng một tập kết quả đơn.
//bang nhanvienIT co cac ban ghi sau:
mysql> SELECT * FROM nhanvienIT;

//bang nhanvienBH co cac ban ghi sau:
mysql> SELECT * FROM nhanvienBH;

//bang chinhanhlamviec co cac ban ghi sau
mysql> SELECT * FROM chinhanhlamviec;

SELECT ho, ten, diachi FROM nhanvienIT
 UNION
 SELECT lname, fname, addr FROM nhanvienBH
 UNION
 SELECT chinhanh, '', diachi FROM chinhanhlamviec;
 
SELECT ho, ten, diachi FROM nhanvienIT
 UNION ALL
 SELECT lname, fname, addr FROM nhanvienBH
 UNION
 SELECT chinhanh, '', diachi FROM chinhanhlamviec; 

-- Hàm hữu ích trong MySQL
--Hàm COUNT trong MySQL - Hàm tập hợp COUNT trong MySQL được sử dụng để đếm số hàng trong một bảng dữ liệu.
--Hàm MAX trong MySQL - Hàm tập hợp MAX trong MySQL cho phép chúng ta lựa chọn giá trị lớn nhất (tối đa) trong một cột cụ thể.
--Hàm MIN trong MySQL - Hàm tập hợp MIN trong MySQL cho phép chúng ta lựa chọn giá trị nhỏ nhất (tối thiểu) trong một cột cụ thể.
--Hàm AVG trong MySQL - Hàm tập hợp AVG trong MySQL cho phép chúng ta lựa chọn giá trị trung bình trong một cột cụ thể.
--Hàm SUM trong MySQL - Hàm tập hợp AVG trong MySQL cho phép chúng ta lựa chọn giá trị trung bình trong một cột cụ thể.
--Hàm SQRT trong MySQL - Được sử dụng để tính căn bậc hai của một số đã cho.
--Hàm RAND trong MySQL - Được sử dụng để tạo một số ngẫu nhiên bởi sử dụng lệnh trong MySQL.
--Hàm CONCAT trong MySQL - Được sử dụng để nối bất kỳ chuỗi nào trong bất kỳ lệnh MySQL nào.
--Hàm xử lý DATE và Time trong MySQL - Danh sách đầy đủ các hàm liên quan tới Date và Time trong MySQL.
--Hàm xử lý số trong MySQL - Danh sách đầy đủ các hàm cần thiết để thao tác với số trong MySQL.
--Hàm xử lý chuỗi trong MySQL - Danh sách đầy đủ các hàm cần thiết để thao tác với chuỗi trong MySQL.

