/* �������� ������� ������ */

CREATE TABLE /*PREFIX*/PRIZES
(
  PRIZE_ID VARCHAR(32) NOT NULL,
  TIRAGE_ID VARCHAR(32) NOT NULL,
  ROUND_NUM INTEGER NOT NULL,
  NAME VARCHAR(250) NOT NULL,
  COST NUMERIC(15,2) NOT NULL,
  PRIORITY INTEGER NOT NULL,
  PRIMARY KEY (PRIZE_ID),
  FOREIGN KEY (TIRAGE_ID) REFERENCES /*PREFIX*/TIRAGES (TIRAGE_ID)
)

--

/* �������� ��������� ������� ������ */

CREATE VIEW /*PREFIX*/S_PRIZES
(
  PRIZE_ID,
  TIRAGE_ID,
  ROUND_NUM,
  NAME,
  COST,
  PRIORITY,
  TIRAGE_NUM
)
AS
  SELECT P.*,
         T.NUM AS TIRAGE_NUM
    FROM /*PREFIX*/PRIZES P
    JOIN /*PREFIX*/TIRAGES T ON T.TIRAGE_ID=P.TIRAGE_ID

--

/* �������� ��������� ���������� ����� */

CREATE PROCEDURE /*PREFIX*/I_PRIZE
(
  PRIZE_ID VARCHAR(32),
  TIRAGE_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  NAME VARCHAR(250),
  COST NUMERIC(15,2),
  PRIORITY INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/PRIZES (PRIZE_ID,TIRAGE_ID,ROUND_NUM,NAME,COST,PRIORITY)
       VALUES (:PRIZE_ID,:TIRAGE_ID,:ROUND_NUM,:NAME,:COST,:PRIORITY);
END;

--

/* �������� ��������� ��������� ����� */

CREATE PROCEDURE /*PREFIX*/U_PRIZE
(
  PRIZE_ID VARCHAR(32),
  TIRAGE_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  NAME VARCHAR(250),
  COST NUMERIC(15,2),
  PRIORITY INTEGER,
  OLD_PRIZE_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/PRIZES
     SET PRIZE_ID=:PRIZE_ID,
         TIRAGE_ID=:TIRAGE_ID,
         ROUND_NUM=:ROUND_NUM,
         NAME=:NAME,
         COST=:COST,
         PRIORITY=:PRIORITY
   WHERE PRIZE_ID=:OLD_PRIZE_ID;
END;

--

/* �������� ��������� �������� ����� */

CREATE PROCEDURE /*PREFIX*/D_PRIZE
(
  OLD_PRIZE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/PRIZES
        WHERE PRIZE_ID=:OLD_PRIZE_ID;
END;

--

/* �������� ��������� */

COMMIT