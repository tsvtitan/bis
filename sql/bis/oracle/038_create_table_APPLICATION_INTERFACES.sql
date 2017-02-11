/* �������� ������� ����������� ��������� ���������� */

CREATE TABLE /*PREFIX*/APPLICATION_INTERFACES
(
  APPLICATION_ID VARCHAR2(32) NOT NULL,
  INTERFACE_ID VARCHAR2(32) NOT NULL,
  ACCOUNT_ID VARCHAR2(32) NOT NULL,
  PRIORITY INTEGER NOT NULL,
  AUTO_RUN INTEGER NOT NULL,
  PRIMARY KEY (APPLICATION_ID,INTERFACE_ID),
  FOREIGN KEY (APPLICATION_ID) REFERENCES /*PREFIX*/APPLICATIONS (APPLICATION_ID),
  FOREIGN KEY (INTERFACE_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID)
)

--

/* �������� ��������� ������� ����������� ��������� ���������� */

CREATE VIEW /*PREFIX*/S_APPLICATION_INTERFACES
AS
SELECT AI.*,
       A.NAME AS APPLICATION_NAME,
       I.NAME AS INTERFACE_NAME,
       AC.USER_NAME
  FROM /*PREFIX*/APPLICATION_INTERFACES AI
  JOIN /*PREFIX*/APPLICATIONS A ON A.APPLICATION_ID=AI.APPLICATION_ID
  JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=AI.INTERFACE_ID
  JOIN /*PREFIX*/ACCOUNTS AC ON AC.ACCOUNT_ID=AI.ACCOUNT_ID
			
--

/* �������� ��������� ���������� ���������� ���������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/I_APPLICATION_INTERFACE
(
  APPLICATION_ID IN VARCHAR2,
  INTERFACE_ID IN VARCHAR2,
  ACCOUNT_ID IN VARCHAR2,
  PRIORITY IN INTEGER,
  AUTO_RUN IN INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/APPLICATION_INTERFACES (APPLICATION_ID,INTERFACE_ID,ACCOUNT_ID,PRIORITY,AUTO_RUN)
       VALUES (APPLICATION_ID,INTERFACE_ID,ACCOUNT_ID,PRIORITY,AUTO_RUN);
END;

--

/* �������� ��������� ��������� ���������� � ���������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/U_APPLICATION_INTERFACE
(
  APPLICATION_ID IN VARCHAR2,
  ACCOUNT_ID IN VARCHAR2,
  INTERFACE_ID IN VARCHAR2,
  PRIORITY IN INTEGER,
  AUTO_RUN IN INTEGER,
  OLD_APPLICATION_ID IN VARCHAR2,
  OLD_INTERFACE_ID IN VARCHAR2,
  OLD_ACCOUNT_ID IN VARCHAR2
)
AS
BEGIN
  UPDATE /*PREFIX*/APPLICATION_INTERFACES
     SET APPLICATION_ID=U_APPLICATION_INTERFACE.APPLICATION_ID,
         INTERFACE_ID=U_APPLICATION_INTERFACE.INTERFACE_ID,
         ACCOUNT_ID=U_APPLICATION_INTERFACE.ACCOUNT_ID, 
         PRIORITY=U_APPLICATION_INTERFACE.PRIORITY,
         AUTO_RUN=U_APPLICATION_INTERFACE.AUTO_RUN
   WHERE APPLICATION_ID=OLD_APPLICATION_ID
	 AND INTERFACE_ID=OLD_INTERFACE_ID
	 AND ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ���������� � ���������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/D_APPLICATION_INTERFACE
(
  OLD_APPLICATION_ID IN VARCHAR2,
  OLD_INTERFACE_ID IN VARCHAR2,
  OLD_ACCOUNT_ID IN VARCHAR2
)
AS
BEGIN
  DELETE FROM /*PREFIX*/APPLICATION_INTERFACES 
        WHERE APPLICATION_ID=OLD_APPLICATION_ID
		  AND INTERFACE_ID=OLD_INTERFACE_ID
	      AND ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� */

COMMIT