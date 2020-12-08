CREATE DATABASE QUANLYQUANCAFE
GO

USE QUANLYQUANCAFE
GO

---FOOD
---TABLE
---FOODCATEGORY
---ACCOUNT
---BILL
---BILLDETAIL
CREATE TABLE FOODTABLE
(
	id				INT IDENTITY PRIMARY KEY,
	name			NVARCHAR(100) NOT NULL DEFAULT N'BÀN CHƯA CÓ TÊN',
	status			NVARCHAR(100) NOT NULL DEFAULT N'TRỐNG	'--Status miêu tả bàn đang trống hay đã được book

)
GO

CREATE TABLE ACCOUNT
(
	UserName		NVARCHAR(100) PRIMARY KEY,
	Displayname		NVARCHAR(100) NOT NULL DEFAULT N'USER',
	Password		NVARCHAR(1000) NOT NULL DEFAULT 0,
	TYPE			INT NOT NULL DEFAULT 0 --- TYPE 1(admin) || 0(user)

)
GO

CREATE TABLE FOODCATEGORY
(
---DANH MỤC MÓN ĂN
	id				INT IDENTITY PRIMARY KEY,
	name			NVARCHAR(100) NOT NULL DEFAULT N'CHƯA ĐƯỢC ĐƯỢC ĐẶT TÊN'

)
GO
CREATE TABLE FOOD
(
	id				INT IDENTITY PRIMARY KEY,
	name			NVARCHAR(100) NOT NULL DEFAULT N' CHƯA ĐƯỢC ĐẶT TÊN',
	idCategory		INT	NOT NULL,
	price			FLOAT	NOT NULL DEFAULT 0
	FOREIGN KEY		(idCategory) REFERENCES FOODCATEGORY(id)
)
GO
CREATE TABLE BILL
(
	id				INT IDENTITY PRIMARY KEY,
	DateCheckIn		DATE NOT NULL DEFAULT GETDATE(),
	DateCheckOut	DATE,
	idFoodTable		INT NOT NULL,
	status			INT NOT NULL DEFAULT 0--- KIỂM TRA BILL ĐÃ THANH TOÁN HAY CHƯA 1(ĐÃ TT) | 0(CHƯA TT)
	FOREIGN KEY		(idFoodTable)	REFERENCES FOODTABLE(id)
)
GO
CREATE TABLE BILLINFOR
(
	id				INT IDENTITY PRIMARY KEY,
	idBill			INT NOT NULL,
	idFood			INT NOT NULL,
	count			INT NOT NULL DEFAULT 0
	FOREIGN KEY		(idBill)	REFERENCES BILL(id),
	FOREIGN KEY		(idFood)	REFERENCES FOOD(id)
)
GO

INSERT INTO ACCOUNT(UserName, Displayname, Password, TYPE)

VALUES ( N'BAOTHANH',	--- USERNAME -NVARCHAR(100)
		N'DUONGLYBAOTHANH',	--- DISPLAYNAME -NVARCHAR(100)
		N'1',	--- PASSWORD - NVARCHAR(100)
		1)		--- TYPE - INT 
INSERT INTO ACCOUNT(UserName, Displayname, Password, TYPE)

VALUES ( N'STAFF',	--- USERNAME -NVARCHAR(100)
		N'STAFF',	--- DISPLAYNAME -NVARCHAR(100)
		N'1',	--- PASSWORD - NVARCHAR(100)
		0)		--- TYPE - INT 

GO

CREATE PROC USP_GetAccountByUserName
@userName nvarchar(100)
AS
BEGIN
	SELECT * FROM ACCOUNT WHERE UserName = @userName
END
GO

EXEC USP_GetAccountByUserName @userName = N'BAOTHANH' --nvarchar(100)

GO
CREATE PROC USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM ACCOUNT WHERE UserName = @userName AND Password = @passWord
END
GO

DECLARE @i INT = 0

WHILE @i <=20
BEGIN
	INSERT FOODTABLE (name) VALUES (N'Bàn ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END

GO
CREATE PROC USP_GetTableList
AS SELECT * FROM FOODTABLE
GO

UPDATE FOODTABLE SET status = N'Có người' Where id=43

EXEC USP_GetTableList


--- thêm category
INSERT FOODCATEGORY(name)

VALUES(N' Ăn sáng')
INSERT FOODCATEGORY(name)

VALUES(N' Cơm trưa')

INSERT FOODCATEGORY(name)

VALUES(N' Thức uống')

---thêm món ăn.
---Category Ăn sáng
INSERT INTO FOOD(name, idCategory, price)
VALUES(N' Bánh mì opla', --- name - nvarchar(100)
		1, --- idCategory - int
		20000)

INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Bún bò',1, 35000)

INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Cơm tấm',1, 30000)
---Category Ăn trưa
INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Cơm canh chua',2, 35000)

INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Cơm cá kho',2, 35000)

INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Cơm thịt kho',2, 35000)

---Category Thức uống
INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Cà phê',3, 20000)

INSERT INTO FOOD(name, idCategory, price)
VALUES(N'Nước cam',3, 25000)

---thêm bill dựa theo id bàn
INSERT INTO BILL(DateCheckIn, DateCheckOut,idFoodTable,status)
VALUES(GETDATE(), NULL, 23, 0)

INSERT INTO BILL(DateCheckIn, DateCheckOut,idFoodTable,status)
VALUES(GETDATE(), NULL, 24, 0)


INSERT INTO BILL(DateCheckIn, DateCheckOut,idFoodTable,status)
VALUES(GETDATE(), GETDATE(), 25, 1)

--- thêm BillInfor
INSERT INTO BILLINFOR(idBill, idFood, count)
VALUES (4, -- idBill - int
		1, -- idFood - int
		2  -- count	 - int
		) 
INSERT INTO BILLINFOR(idBill, idFood, count)
VALUES (4, -- idBill - int
		3, -- idFood - int
		4  -- count	 - int
		) 
INSERT INTO BILLINFOR(idBill, idFood, count)
VALUES (4, -- idBill - int
		5, -- idFood - int
		1  -- count	 - int
		) 
INSERT INTO BILLINFOR(idBill, idFood, count)
VALUES (5, -- idBill - int
		1, -- idFood - int
		2  -- count	 - int
		) 
INSERT INTO BILLINFOR(idBill, idFood, count)
VALUES (5, -- idBill - int
		6, -- idFood - int
		2  -- count	 - int
		) 
INSERT INTO BILLINFOR(idBill, idFood, count)
VALUES (6, -- idBill - int
		5, -- idFood - int
		2  -- count	 - int
		) 
GO

SELECT F.name, BI.count, F.price, F.price*BI.count AS TOTALPRICE FROM BILLINFOR AS BI , BILL AS B , FOOD AS F
WHERE idBill = B.ID AND BI.idFood = F.ID AND B.idFoodTable = 23

GO
CREATE PROC USP_INSERTBILL
@idTable INT
AS
BEGIN
	INSERT INTO BILL(DateCheckIn, DateCheckOut,idFoodTable,status)
	VALUES(GETDATE(), NULL, @idTable, 0)
END
GO

CREATE PROC USP_InsertBillInfor
@idBill INT, @idFood INT, @count INT
AS
BEGIN

	DECLARE @isExitsBillInfor INT
	DECLARE @foodCount INT = 1

	SELECT @isExitsBillInfor = id, @foodCount = B.count
	FROM BILLINFOR AS B
	WHERE idBill = @idBill and idFood = @idFood

	IF (@isExitsBillInfor > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE BILLINFOR SET count = @foodCount + @count WHERE idFood = @idFood
		ELSE
			DELETE BILLINFOR WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
		INSERT INTO BILLINFOR(idBill, idFood, count)
		VALUES (@idBill, -- idBill - int
				@idFood, -- idFood - int
				@count -- count	 - int
				) 
	END
END
GO

CREATE TRIGGER UTG_UPDATEBillInfor
ON BILLINFOR FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = idBill FROM INSERTED

	DECLARE @idTable INT
	SELECT @idTable = idFoodTable FROM BILL WHERE id = @idBill AND status = 0

	UPDATE FOODTABLE SET status = N'Có người' WHERE id = @idTable
END
GO

DELETE BILLINFOR
DELETE BILL

CREATE TRIGGER UTG_UPDATEBill
ON BILL FOR UPDATE
AS
BEGIN
	DECLARE @idBill INT

	SELECT @idBill = id FROM Inserted

	DECLARE @idTable INT

	SELECT @idTable = idFoodTable FROM BILL WHERE id = @idBill 

	DECLARE @count INT = 0

	SELECT @count = COUNT(*) FROM BILL WHERE idFoodTable = @idTable AND status = 0

	IF (@count = 0 )
		UPDATE FOODTABLE SET status = N'Trống' WHERE id = @idTable

END
GO

SELECT * FROM BILL
SELECT * FROM FOODTABLE
UPDATE BILL SET status = 1 WHERE id = 19

ALTER TABLE BILL ADD totalPrice FLOAT

DELETE BILLINFOR
DELETE BILL

GO

ALTER PROC USP_GetListBillByDate
@checkIn date, @checkOut date
AS
BEGIN
	SELECT ft.name as [Tên bàn],b.totalPrice [Tổng tiền], DateCheckIn as [Ngày vào], DateCheckOut as [Ngày ra] 
	FROM BILL as b, FOODTABLE as ft
	WHERE DateCheckIn >=@checkIn AND DateCheckOut <=@checkOut AND b.status = 1
	AND ft.id = b.idFoodTable
END
GO

SELECT * FROM BILL