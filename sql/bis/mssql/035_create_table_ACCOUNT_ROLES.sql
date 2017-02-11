/* �������� ������� ����� ������������ */

CREATE TABLE /*PREFIX*/ACCOUNT_ROLES
(
  ROLE_ID VARCHAR(32) NOT NULL,
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  PRIMARY KEY (ROLE_ID,ACCOUNT_ID),
  FOREIGN KEY (ROLE_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID)
)

--

/* �������� ��������� ������� ����� ������������ */

CREATE VIEW /*PREFIX*/S_ACCOUNT_ROLES
AS
SELECT AP.*,
       R.USER_NAME AS ROLE_NAME,
       A.USER_NAME AS USER_NAME
  FROM /*PREFIX*/ACCOUNT_ROLES AP
  JOIN /*PREFIX*/ACCOUNTS R ON R.ACCOUNT_ID=AP.ROLE_ID
  JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=AP.ACCOUNT_ID
			
--

/* �������� ��������� ���������� ���� ������������ */

CREATE PROCEDURE /*PREFIX*/I_ACCOUNT_ROLE
  @ROLE_ID VARCHAR(32),
  @ACCOUNT_ID VARCHAR(32)
AS
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNT_ROLES (ROLE_ID,ACCOUNT_ID)
       VALUES (@ROLE_ID,@ACCOUNT_ID);
END;

--

/* �������� ��������� ��������� ���� � ������������ */

CREATE PROCEDURE /*PREFIX*/U_ACCOUNT_ROLE
  @ROLE_ID VARCHAR(32),
  @ACCOUNT_ID VARCHAR(32),
  @OLD_ROLE_ID VARCHAR(32),
  @OLD_ACCOUNT_ID VARCHAR(32)
AS
BEGIN
  UPDATE /*PREFIX*/ACCOUNT_ROLES
     SET ROLE_ID=@ROLE_ID,
         ACCOUNT_ID=@ACCOUNT_ID
   WHERE ROLE_ID=@OLD_ROLE_ID
     AND ACCOUNT_ID=@OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ���� � ������������ */

CREATE PROCEDURE /*PREFIX*/D_ACCOUNT_ROLE
  @OLD_ROLE_ID VARCHAR(32),
  @OLD_ACCOUNT_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNT_ROLES 
        WHERE ROLE_ID=@OLD_ROLE_ID
          AND ACCOUNT_ID=@OLD_ACCOUNT_ID;
END;

--