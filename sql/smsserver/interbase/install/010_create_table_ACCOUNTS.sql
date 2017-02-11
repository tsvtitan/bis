/* �������� ������� ������������� */

CREATE TABLE /*PREFIX*/ACCOUNTS
(
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  FIRM_ID VARCHAR(32),
  DATE_CREATE TIMESTAMP NOT NULL,
  USER_NAME VARCHAR(100) NOT NULL,
  "PASSWORD" VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  DB_USER_NAME VARCHAR(100),
  DB_PASSWORD VARCHAR(100),
  IS_ROLE INTEGER,
  LOCKED INTEGER,  
  AUTO_CREATED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  PHONE VARCHAR(100),
  EMAIL VARCHAR(100),
  PHOTO BLOB,
  PRIMARY KEY (ACCOUNT_ID),
  FOREIGN KEY (FIRM_ID) REFERENCES /*PREFIX*/FIRMS (FIRM_ID)
)

--

/* �������� ��������� ������� ������������� */

CREATE VIEW /*PREFIX*/S_ACCOUNTS
(
  ACCOUNT_ID,
  FIRM_ID,
  DATE_CREATE,
  USER_NAME,
  "PASSWORD",
  DESCRIPTION,
  DB_USER_NAME,
  DB_PASSWORD,
  IS_ROLE,
  LOCKED,
  AUTO_CREATED,
  SURNAME,
  NAME,
  PATRONYMIC,
  PHONE,
  EMAIL,
  PHOTO,
  FIRM_SMALL_NAME
)
AS
  SELECT A.*, 
         F.SMALL_NAME AS FIRM_SMALL_NAME
    FROM /*PREFIX*/ACCOUNTS A
    LEFT JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=A.FIRM_ID

--

/* �������� ��������� ���������� ������������ */

CREATE PROCEDURE /*PREFIX*/I_ACCOUNT
(
  ACCOUNT_ID VARCHAR(32),
  FIRM_ID VARCHAR(32),
  DATE_CREATE TIMESTAMP,
  USER_NAME VARCHAR(100),
  "PASSWORD" VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  DB_USER_NAME VARCHAR(100),
  DB_PASSWORD VARCHAR(100),
  IS_ROLE INTEGER,
  LOCKED INTEGER,
  AUTO_CREATED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  PHONE VARCHAR(100),
  EMAIL VARCHAR(100),
  PHOTO BLOB
)
AS
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNTS (ACCOUNT_ID,FIRM_ID,DATE_CREATE,USER_NAME,"PASSWORD",DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
                                  IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL,PHOTO)
       VALUES (:ACCOUNT_ID,:FIRM_ID,:DATE_CREATE,:USER_NAME,:"PASSWORD",:DESCRIPTION,:DB_USER_NAME,:DB_PASSWORD,
               :IS_ROLE,:LOCKED,:AUTO_CREATED,:SURNAME,:NAME,:PATRONYMIC,:PHONE,:EMAIL,:PHOTO);
END;

--

/* �������� ��������� ��������� ������������ */

CREATE PROCEDURE /*PREFIX*/U_ACCOUNT
(
  ACCOUNT_ID VARCHAR(32),
  FIRM_ID VARCHAR(32),
  DATE_CREATE TIMESTAMP,
  USER_NAME VARCHAR(100),
  "PASSWORD" VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  DB_USER_NAME VARCHAR(100),
  DB_PASSWORD VARCHAR(100),
  IS_ROLE INTEGER,
  LOCKED INTEGER,
  AUTO_CREATED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  PHONE VARCHAR(100),
  EMAIL VARCHAR(100),
  PHOTO BLOB,
  OLD_ACCOUNT_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/ACCOUNTS
     SET ACCOUNT_ID=:ACCOUNT_ID,
         FIRM_ID=:FIRM_ID,
         DATE_CREATE=:DATE_CREATE,
         USER_NAME=:USER_NAME,
         "PASSWORD"=:"PASSWORD",
         DESCRIPTION=:DESCRIPTION,
         DB_USER_NAME=:DB_USER_NAME,
         DB_PASSWORD=:DB_PASSWORD,
         IS_ROLE=:IS_ROLE,
         LOCKED=:LOCKED,
         AUTO_CREATED=:AUTO_CREATED,
         SURNAME=:SURNAME,
         NAME=:NAME,
         PATRONYMIC=:PATRONYMIC,
         PHONE=:PHONE,
         EMAIL=:EMAIL,
         PHOTO=:PHOTO
   WHERE ACCOUNT_ID=:OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ������������ */

CREATE PROCEDURE /*PREFIX*/D_ACCOUNT
(
  OLD_ACCOUNT_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNTS
        WHERE ACCOUNT_ID=:OLD_ACCOUNT_ID;
END;

--
