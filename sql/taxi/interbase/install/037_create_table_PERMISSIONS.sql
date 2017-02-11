/* �������� ������� ���� ����������� */

CREATE TABLE /*PREFIX*/PERMISSIONS
(
  PERMISSION_ID VARCHAR(32) NOT NULL,
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  INTERFACE_ID VARCHAR(32) NOT NULL,
  RIGHT_ACCESS VARCHAR(250) NOT NULL,
  "VALUE" VARCHAR(250) NOT NULL,
  PRIMARY KEY (PERMISSION_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (INTERFACE_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ���� ����������� */

CREATE VIEW /*PREFIX*/S_PERMISSIONS
(
  PERMISSION_ID,
  ACCOUNT_ID,
  INTERFACE_ID,
  RIGHT_ACCESS,
  "VALUE",
  USER_NAME,
  INTERFACE_NAME
)
AS
   SELECT P.*, 
          A.USER_NAME AS USER_NAME,
          I.NAME AS INTERFACE_NAME
     FROM /*PREFIX*/PERMISSIONS P
     JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=P.ACCOUNT_ID
     JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=P.INTERFACE_ID

--

/* �������� ��������� ���������� ����� */

CREATE PROCEDURE /*PREFIX*/I_PERMISSION
(
  PERMISSION_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32),
  INTERFACE_ID VARCHAR(32),
  RIGHT_ACCESS VARCHAR(250),
  "VALUE" VARCHAR(250)
)
AS
BEGIN
  INSERT INTO /*PREFIX*/PERMISSIONS (PERMISSION_ID,ACCOUNT_ID,INTERFACE_ID,RIGHT_ACCESS,"VALUE")
       VALUES (:PERMISSION_ID,:ACCOUNT_ID,:INTERFACE_ID,:RIGHT_ACCESS,:"VALUE");
END;

--

/* �������� ��������� ��������� ����� */

CREATE PROCEDURE /*PREFIX*/U_PERMISSION
(
  PERMISSION_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32),
  INTERFACE_ID VARCHAR(32),
  RIGHT_ACCESS VARCHAR(250),
  "VALUE" VARCHAR(250),
  OLD_PERMISSION_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/PERMISSIONS
     SET PERMISSION_ID=:PERMISSION_ID,
         ACCOUNT_ID=:ACCOUNT_ID,
         INTERFACE_ID=:INTERFACE_ID,
         RIGHT_ACCESS=:RIGHT_ACCESS,
         "VALUE"=:"VALUE"
   WHERE PERMISSION_ID=:OLD_PERMISSION_ID;
END;

--

/* �������� ��������� �������� ����� */

CREATE PROCEDURE /*PREFIX*/D_PERMISSION
(
  OLD_PERMISSION_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/PERMISSIONS
        WHERE PERMISSION_ID=:OLD_PERMISSION_ID;
END;

--

/* �������� ��������� */

COMMIT