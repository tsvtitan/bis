/* �������� ������� ������������� */

CREATE TABLE /*PREFIX*/ACCOUNTS
(
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  FIRM_ID VARCHAR(32),
  DATE_CREATE DATETIME NOT NULL,
  USER_NAME VARCHAR(100) NOT NULL,
  PASSWORD VARCHAR(100),
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
  PHOTO IMAGE,
  PRIMARY KEY (ACCOUNT_ID)
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

CREATE PROCEDURE /*PREFIX*/I_ACCOUNT
  @ACCOUNT_ID VARCHAR(32),
  @FIRM_ID VARCHAR(32),
  @DATE_CREATE DATETIME,
  @USER_NAME VARCHAR(100),
  @PASSWORD VARCHAR(100),
  @DESCRIPTION VARCHAR(250),
  @DB_USER_NAME VARCHAR(100),
  @DB_PASSWORD VARCHAR(100),
  @IS_ROLE INTEGER,
  @LOCKED INTEGER,  
  @AUTO_CREATED INTEGER,
  @SURNAME VARCHAR(100),
  @NAME VARCHAR(100),
  @PATRONYMIC VARCHAR(100),
  @PHONE VARCHAR(100),
  @EMAIL VARCHAR(100),
  @PHOTO IMAGE
AS
BEGIN
  DECLARE @CNT INT;
  SET @CNT=(SELECT COUNT(*) FROM ACCOUNTS WHERE UPPER(USER_NAME)=UPPER(@USER_NAME));
  IF (@CNT>0) BEGIN
    RAISERROR('������� ������ (%s) ��� ����������.',16,1,@USER_NAME);
    RETURN;
  END

  INSERT INTO /*PREFIX*/ACCOUNTS (ACCOUNT_ID,FIRM_ID,DATE_CREATE,USER_NAME,PASSWORD,DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
	                          IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL,PHOTO)
       VALUES (@ACCOUNT_ID,@FIRM_ID,@DATE_CREATE,@USER_NAME,@PASSWORD,@DESCRIPTION,@DB_USER_NAME,@DB_PASSWORD,
	       @IS_ROLE,@LOCKED,@AUTO_CREATED,@SURNAME,@NAME,@PATRONYMIC,@PHONE,@EMAIL,@PHOTO);
END;


--

/* �������� ��������� ��������� ������������ */

CREATE PROCEDURE /*PREFIX*/U_ACCOUNT
  @ACCOUNT_ID VARCHAR(32),
  @FIRM_ID VARCHAR(32),
  @DATE_CREATE DATETIME,
  @USER_NAME VARCHAR(100),
  @PASSWORD VARCHAR(100),
  @DESCRIPTION VARCHAR(250),
  @DB_USER_NAME VARCHAR(100),
  @DB_PASSWORD VARCHAR(100),
  @IS_ROLE INTEGER,
  @LOCKED INTEGER,  
  @AUTO_CREATED INTEGER,
  @SURNAME VARCHAR(100),
  @NAME VARCHAR(100),
  @PATRONYMIC VARCHAR(100),
  @PHONE VARCHAR(100),
  @EMAIL VARCHAR(100),
  @PHOTO IMAGE,
  @OLD_ACCOUNT_ID VARCHAR(32)
AS
BEGIN
  DECLARE @CNT INT;
  SET @CNT=(SELECT COUNT(*) FROM ACCOUNTS WHERE UPPER(USER_NAME)=UPPER(@USER_NAME) AND ACCOUNT_ID<>@OLD_ACCOUNT_ID);
  IF (@CNT>0) BEGIN
    RAISERROR('������� ������ %s ��� ����������.',16,1,@USER_NAME);
    RETURN;
  END

  UPDATE /*PREFIX*/ACCOUNTS
     SET ACCOUNT_ID=@ACCOUNT_ID,
         FIRM_ID=@FIRM_ID,
         DATE_CREATE=@DATE_CREATE,
         USER_NAME=@USER_NAME,
         PASSWORD=@PASSWORD,
         DESCRIPTION=@DESCRIPTION,
         DB_USER_NAME=@DB_USER_NAME,
         DB_PASSWORD=@DB_PASSWORD,
         IS_ROLE=@IS_ROLE,
	 LOCKED=@LOCKED,
	 AUTO_CREATED=@AUTO_CREATED,
	 SURNAME=@SURNAME,
	 NAME=@NAME,
	 PATRONYMIC=@PATRONYMIC,
	 PHONE=@PHONE,
	 EMAIL=@EMAIL,
         PHOTO=@PHOTO
   WHERE ACCOUNT_ID=@OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ������������ */

CREATE PROCEDURE /*PREFIX*/D_ACCOUNT
  @OLD_ACCOUNT_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNTS
        WHERE ACCOUNT_ID=@OLD_ACCOUNT_ID;
END;

--