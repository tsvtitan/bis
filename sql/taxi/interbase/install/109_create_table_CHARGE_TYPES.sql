/* �������� ������� ����� �������� */

CREATE TABLE /*PREFIX*/CHARGE_TYPES
(
  CHARGE_TYPE_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  SUM_CHARGE NUMERIC(15,2),
  PRIMARY KEY (CHARGE_TYPE_ID)
)

--

/* �������� ��������� ����� �������� */

CREATE VIEW /*PREFIX*/S_CHARGE_TYPES
AS
SELECT * FROM /*PREFIX*/CHARGE_TYPES

--

/* �������� ��������� ���������� ���� ����������� */

CREATE PROCEDURE /*PREFIX*/I_CHARGE_TYPE
(
  CHARGE_TYPE_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  SUM_CHARGE NUMERIC(15,2)
)
AS
BEGIN
  INSERT INTO /*PREFIX*/CHARGE_TYPES (CHARGE_TYPE_ID,NAME,DESCRIPTION,SUM_CHARGE)
       VALUES (:CHARGE_TYPE_ID,:NAME,:DESCRIPTION,:SUM_CHARGE);
END;

--

/* �������� ��������� ��������� ���� �������� */

CREATE PROCEDURE /*PREFIX*/U_CHARGE_TYPE
(
  CHARGE_TYPE_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  SUM_CHARGE NUMERIC(15,2),
  OLD_CHARGE_TYPE_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/CHARGE_TYPES
     SET CHARGE_TYPE_ID=:CHARGE_TYPE_ID,
         NAME=:NAME,
         DESCRIPTION=:DESCRIPTION,
         SUM_CHARGE=:SUM_CHARGE
   WHERE CHARGE_TYPE_ID=:OLD_CHARGE_TYPE_ID;
END;

--

/* �������� ��������� �������� ���� �������� */

CREATE PROCEDURE /*PREFIX*/D_CHARGE_TYPE
(
  OLD_CHARGE_TYPE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/CHARGE_TYPES 
        WHERE CHARGE_TYPE_ID=:OLD_CHARGE_TYPE_ID;
END;

--

/* �������� ��������� */

COMMIT