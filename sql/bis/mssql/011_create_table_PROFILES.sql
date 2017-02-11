/* �������� ������� �������� */

CREATE TABLE /*PREFIX*/PROFILES
(
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  APPLICATION_ID VARCHAR(32) NOT NULL,
  PROFILE IMAGE,
  PRIMARY KEY (ACCOUNT_ID,APPLICATION_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (APPLICATION_ID) REFERENCES /*PREFIX*/APPLICATIONS (APPLICATION_ID)
)

--

/* �������� ��������� ������� �������� */

CREATE VIEW /*PREFIX*/S_PROFILES
AS
SELECT P.*,
       AC.USER_NAME AS USER_NAME,
       AP.NAME AS APPLICATION_NAME
  FROM /*PREFIX*/PROFILES P
  JOIN /*PREFIX*/ACCOUNTS AC ON AC.ACCOUNT_ID=P.ACCOUNT_ID
  JOIN /*PREFIX*/APPLICATIONS AP ON AP.APPLICATION_ID=P.APPLICATION_ID
			
--

/* �������� ��������� ���������� ������� */

CREATE PROCEDURE /*PREFIX*/I_PROFILE
  @ACCOUNT_ID VARCHAR(32),
  @APPLICATION_ID VARCHAR(32),
  @PROFILE IMAGE
AS
BEGIN
  INSERT INTO /*PREFIX*/PROFILES (ACCOUNT_ID,APPLICATION_ID,PROFILE)
       VALUES (@ACCOUNT_ID,@APPLICATION_ID,@PROFILE);
END;

--

/* �������� ��������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/U_PROFILE
  @ACCOUNT_ID VARCHAR(32),
  @APPLICATION_ID VARCHAR(32),
  @PROFILE IMAGE,
  @OLD_ACCOUNT_ID VARCHAR(32),
  @OLD_APPLICATION_ID VARCHAR(32)
AS
BEGIN
  UPDATE /*PREFIX*/PROFILES
     SET ACCOUNT_ID=@ACCOUNT_ID,
         APPLICATION_ID=@APPLICATION_ID,
         PROFILE=@PROFILE
   WHERE ACCOUNT_ID=@OLD_ACCOUNT_ID
     AND APPLICATION_ID=@OLD_APPLICATION_ID;
END;

--

/* �������� ��������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/D_PROFILE
  @OLD_ACCOUNT_ID VARCHAR(32),
  @OLD_APPLICATION_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/PROFILES 
        WHERE ACCOUNT_ID=@OLD_ACCOUNT_ID
	  AND APPLICATION_ID=@OLD_APPLICATION_ID;
END;

--