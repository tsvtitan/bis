/* �������� ������� ������� */

CREATE TABLE /*PREFIX*/ADVERTISMENTS
(
  ADVERTISMENT_ID VARCHAR(32) NOT NULL,
  SERVICE_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  ADVERTISMENT_TYPE INTEGER NOT NULL,
  LOCATION INTEGER NOT NULL,
  VALUE LONGBLOB NOT NULL,
  LINK VARCHAR(250) NOT NULL,
  PRIMARY KEY (ADVERTISMENT_ID),
  FOREIGN KEY (SERVICE_ID) REFERENCES /*PREFIX*/SERVICES (SERVICE_ID)
)

--

/* �������� ��������� ������� ������� */

CREATE VIEW /*PREFIX*/S_ADVERTISMENTS
AS
   SELECT A.*, 
          S.NAME AS SERVICE_NAME
     FROM /*PREFIX*/ADVERTISMENTS A
     JOIN /*PREFIX*/SERVICES S ON S.SERVICE_ID=A.SERVICE_ID

--

/* �������� ��������� ���������� ������� */

CREATE PROCEDURE /*PREFIX*/I_ADVERTISMENT
(
  IN ADVERTISMENT_ID VARCHAR(32),
  IN SERVICE_ID VARCHAR(32),
	IN NAME VARCHAR(100),
	IN DESCRIPTION VARCHAR(250),
	IN ADVERTISMENT_TYPE INTEGER,
	IN LOCATION INTEGER,
	IN VALUE LONGBLOB,
	IN LINK VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/ADVERTISMENTS (ADVERTISMENT_ID,SERVICE_ID,NAME,DESCRIPTION,ADVERTISMENT_TYPE,
	                                     LOCATION,VALUE,LINK)
       VALUES (ADVERTISMENT_ID,SERVICE_ID,NAME,DESCRIPTION,ADVERTISMENT_TYPE,
			         LOCATION,VALUE,LINK);
END;

--

/* �������� ��������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/U_ADVERTISMENT
(
  IN ADVERTISMENT_ID VARCHAR(32),
  IN SERVICE_ID VARCHAR(32),
	IN NAME VARCHAR(100),
	IN DESCRIPTION VARCHAR(250),
	IN ADVERTISMENT_TYPE INTEGER,
  IN LOCATION INTEGER,
	IN VALUE LONGBLOB,
	IN LINK VARCHAR(250),
  IN OLD_ADVERTISMENT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/ADVERTISMENTS A
     SET A.ADVERTISMENT_ID=ADVERTISMENT_ID,
         A.SERVICE_ID=SERVICE_ID,
         A.NAME=NAME,
         A.DESCRIPTION=DESCRIPTION,
				 A.ADVERTISMENT_TYPE=ADVERTISMENT_TYPE,
				 A.LOCATION=LOCATION,
				 A.VALUE=VALUE,
				 A.LINK=LINK
   WHERE A.ADVERTISMENT_ID=OLD_ADVERTISMENT_ID;
END;


--

/* �������� ��������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/D_ADVERTISMENT
(
  IN OLD_ADVERTISMENT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/ADVERTISMENTS
        WHERE ADVERTISMENT_ID=OLD_ADVERTISMENT_ID;
END;

--