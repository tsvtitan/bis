/* �������� ������� ���������� */

CREATE TABLE /*PREFIX*/LOTTERY
(
  LOTTERY_ID VARCHAR(32) NOT NULL,
  TIRAGE_ID VARCHAR(32) NOT NULL,
  ROUND_NUM INTEGER NOT NULL,
  BARREL_NUM VARCHAR(2) NOT NULL,
  INPUT_DATE TIMESTAMP NOT NULL,
  PRIZE_ID VARCHAR(32),
  PRIMARY KEY (LOTTERY_ID),
  FOREIGN KEY (TIRAGE_ID) REFERENCES /*PREFIX*/TIRAGES (TIRAGE_ID),
  FOREIGN KEY (PRIZE_ID) REFERENCES /*PREFIX*/PRIZES (PRIZE_ID)
)

--

/* �������� ��������� ������� ���������� */

CREATE VIEW /*PREFIX*/S_LOTTERY
(
  LOTTERY_ID,
  TIRAGE_ID,
  ROUND_NUM,
  BARREL_NUM,
  INPUT_DATE,
  PRIZE_ID,
  TIRAGE_NUM,
  PRIZE_NAME
)
AS
  SELECT L.*,
         T.NUM AS TIRAGE_NUM,
         P.NAME AS PRIZE_NAME
    FROM /*PREFIX*/LOTTERY L
    JOIN /*PREFIX*/TIRAGES T ON T.TIRAGE_ID=L.TIRAGE_ID
    LEFT JOIN /*PREFIX*/PRIZES P ON L.PRIZE_ID=P.PRIZE_ID

--

/* �������� ��������� ���������� ��������� */

CREATE PROCEDURE /*PREFIX*/I_LOTTERY
(
  LOTTERY_ID VARCHAR(32),
  TIRAGE_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  BARREL_NUM VARCHAR(2),
  INPUT_DATE TIMESTAMP,
  PRIZE_ID VARCHAR(32)
)
AS
BEGIN
  INSERT INTO /*PREFIX*/LOTTERY (LOTTERY_ID,TIRAGE_ID,ROUND_NUM,BARREL_NUM,INPUT_DATE,PRIZE_ID)
       VALUES (:LOTTERY_ID,:TIRAGE_ID,:ROUND_NUM,:BARREL_NUM,:INPUT_DATE,:PRIZE_ID);
END;

--

/* �������� ��������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/U_LOTTERY
(
  LOTTERY_ID VARCHAR(32),
  TIRAGE_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  BARREL_NUM VARCHAR(2),
  INPUT_DATE TIMESTAMP,
  PRIZE_ID VARCHAR(32),
  OLD_LOTTERY_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/LOTTERY
     SET LOTTERY_ID=:LOTTERY_ID,
         TIRAGE_ID=:TIRAGE_ID,
         ROUND_NUM=:ROUND_NUM,
         BARREL_NUM=:BARREL_NUM,
         INPUT_DATE=:INPUT_DATE,
         PRIZE_ID=:PRIZE_ID
   WHERE LOTTERY_ID=:OLD_LOTTERY_ID;
END;

--

/* �������� ��������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/D_LOTTERY
(
  OLD_LOTTERY_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/LOTTERY
        WHERE LOTTERY_ID=:OLD_LOTTERY_ID;
END;

--

/* �������� ��������� */

COMMIT