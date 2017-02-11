/* �������� ������� ������������� */

CREATE TABLE /*PREFIX*/ACCOUNTS
(
  ACCOUNT_ID VARCHAR2(32) NOT NULL,
  FIRM_ID VARCHAR2(32),
  DATE_CREATE DATE NOT NULL,
  USER_NAME VARCHAR2(100) NOT NULL,
  PASSWORD VARCHAR2(100),
  DESCRIPTION VARCHAR2(250),
  DB_USER_NAME VARCHAR2(100),
  DB_PASSWORD VARCHAR2(100),
  IS_ROLE INTEGER,
  LOCKED INTEGER,  
  AUTO_CREATED INTEGER,
  SURNAME VARCHAR2(100),
  NAME VARCHAR2(100),
  PATRONYMIC VARCHAR2(100),
  PHONE VARCHAR2(100),
  EMAIL VARCHAR2(100),
  PHOTO BLOB,
  PRIMARY KEY (ACCOUNT_ID),
  FOREIGN KEY (FIRM_ID) REFERENCES FIRMS (FIRM_ID)
)

--

/* �������� ��������� ������� ������������� */

CREATE VIEW /*PREFIX*/S_ACCOUNTS
AS
   SELECT A.*, 
          F.SMALL_NAME AS FIRM_SMALL_NAME
     FROM /*PREFIX*/ACCOUNTS A
     LEFT JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=A.FIRM_ID

--

/* �������� ��������� ���������� ������������ */

CREATE OR REPLACE PROCEDURE /*PREFIX*/I_ACCOUNT
(
  ACCOUNT_ID IN VARCHAR2,
  FIRM_ID IN VARCHAR2,
  DATE_CREATE IN DATE,
  USER_NAME IN VARCHAR2,
  PASSWORD IN VARCHAR2,
  DESCRIPTION IN VARCHAR2,
  DB_USER_NAME IN VARCHAR2,
  DB_PASSWORD IN VARCHAR2,
  IS_ROLE IN INTEGER,
  LOCKED IN INTEGER,  
  AUTO_CREATED IN INTEGER,
  SURNAME IN VARCHAR2,
  NAME IN VARCHAR2,
  PATRONYMIC IN VARCHAR2,
  PHONE IN VARCHAR2,
  EMAIL IN VARCHAR2,
  PHOTO IN BLOB
)
AS
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNTS (ACCOUNT_ID,FIRM_ID,DATE_CREATE,USER_NAME,PASSWORD,DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
	                              IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL,PHOTO)
       VALUES (ACCOUNT_ID,FIRM_ID,DATE_CREATE,USER_NAME,PASSWORD,DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
               IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL,PHOTO);
END;

--

/* �������� ��������� ��������� ������������ */

CREATE OR REPLACE PROCEDURE /*PREFIX*/U_ACCOUNT
(
  ACCOUNT_ID IN VARCHAR2,
  FIRM_ID IN VARCHAR2,
  DATE_CREATE IN DATE,
  USER_NAME IN VARCHAR2,
  PASSWORD IN VARCHAR2,
  DESCRIPTION IN VARCHAR2,
  DB_USER_NAME IN VARCHAR2,
  DB_PASSWORD IN VARCHAR2,
  IS_ROLE IN INTEGER,
  LOCKED IN INTEGER,  
  AUTO_CREATED IN INTEGER,
  SURNAME IN VARCHAR2,
  NAME IN VARCHAR2,
  PATRONYMIC IN VARCHAR2,
  PHONE IN VARCHAR2,
  EMAIL IN VARCHAR2,
  PHOTO IN BLOB,
  OLD_ACCOUNT_ID IN VARCHAR2
)
AS
BEGIN
  UPDATE /*PREFIX*/ACCOUNTS
     SET ACCOUNT_ID=U_ACCOUNT.ACCOUNT_ID,
         FIRM_ID=U_ACCOUNT.FIRM_ID,
		 DATE_CREATE=U_ACCOUNT.DATE_CREATE,
         USER_NAME=U_ACCOUNT.USER_NAME,
         PASSWORD=U_ACCOUNT.PASSWORD,
         DESCRIPTION=U_ACCOUNT.DESCRIPTION,
         DB_USER_NAME=U_ACCOUNT.DB_USER_NAME,
         DB_PASSWORD=U_ACCOUNT.DB_PASSWORD,
         IS_ROLE=U_ACCOUNT.IS_ROLE,
		 LOCKED=U_ACCOUNT.LOCKED,
		 AUTO_CREATED=U_ACCOUNT.AUTO_CREATED,
		 SURNAME=U_ACCOUNT.SURNAME,
		 NAME=U_ACCOUNT.NAME,
		 PATRONYMIC=U_ACCOUNT.PATRONYMIC,
		 PHONE=U_ACCOUNT.PHONE,
		 EMAIL=U_ACCOUNT.EMAIL,
		 PHOTO=U_ACCOUNT.PHOTO 
   WHERE ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ������������ */

CREATE OR REPLACE PROCEDURE /*PREFIX*/D_ACCOUNT
(
  OLD_ACCOUNT_ID IN VARCHAR
)
AS
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNTS
        WHERE ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� */

COMMIT