/* �������� ������� ���������� ������� */

CREATE TABLE /*PREFIX*/LOCALITIES
(
  LOCALITY_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  PREFIX VARCHAR(10),
  PRIMARY KEY (LOCALITY_ID)
)

--

/* �������� ��������� ���������� ������� */

CREATE VIEW /*PREFIX*/S_LOCALITIES
AS
SELECT * FROM /*PREFIX*/LOCALITIES

--

/* �������� ��������� ���������� ����������� ������ */

CREATE PROCEDURE /*PREFIX*/I_LOCALITY
(
  LOCALITY_ID VARCHAR(32),
  NAME VARCHAR(100),
  PREFIX VARCHAR(10)
)
AS
BEGIN
  INSERT INTO /*PREFIX*/LOCALITIES (LOCALITY_ID,NAME,PREFIX)
       VALUES (:LOCALITY_ID,:NAME,:PREFIX);
END;

--

/* �������� ��������� ��������� ����������� ������ */

CREATE PROCEDURE /*PREFIX*/U_LOCALITY
(
  LOCALITY_ID VARCHAR(32),
  NAME VARCHAR(100),
  PREFIX VARCHAR(10),
  OLD_LOCALITY_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/LOCALITIES
     SET LOCALITY_ID=:LOCALITY_ID,
         NAME=:NAME,
         PREFIX=:PREFIX
   WHERE LOCALITY_ID=:OLD_LOCALITY_ID;
END;

--

/* �������� ��������� �������� ����������� ������ */

CREATE PROCEDURE /*PREFIX*/D_LOCALITY
(
  OLD_LOCALITY_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/LOCALITIES 
        WHERE LOCALITY_ID=:OLD_LOCALITY_ID;
END;

--
