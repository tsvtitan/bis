/* �������� ������� ����������� ��������� ���������� */

CREATE TABLE /*PREFIX*/APPLICATION_INTERFACES
(
  APPLICATION_ID VARCHAR(32) NOT NULL,
  INTERFACE_ID VARCHAR(32) NOT NULL,
  ACCOUNT_ID VARCHAR(32) NOT NULL,
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

CREATE PROCEDURE /*PREFIX*/I_APPLICATION_INTERFACE
(
  IN APPLICATION_ID VARCHAR(32),
  IN INTERFACE_ID VARCHAR(32),
	IN ACCOUNT_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN AUTO_RUN INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/APPLICATION_INTERFACES (APPLICATION_ID,INTERFACE_ID,ACCOUNT_ID,PRIORITY,AUTO_RUN)
       VALUES (APPLICATION_ID,INTERFACE_ID,ACCOUNT_ID,PRIORITY,AUTO_RUN);
END;

--

/* �������� ��������� ��������� ���������� � ���������� */

CREATE PROCEDURE /*PREFIX*/U_APPLICATION_INTERFACE
(
  IN APPLICATION_ID VARCHAR(32),
	IN ACCOUNT_ID VARCHAR(32),
  IN INTERFACE_ID VARCHAR(32),
  IN PRIORITY INTEGER,
  IN AUTO_RUN INTEGER,
  IN OLD_APPLICATION_ID VARCHAR(32),
  IN OLD_INTERFACE_ID VARCHAR(32),
	IN OLD_ACCOUNT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/APPLICATION_INTERFACES AI
     SET AI.APPLICATION_ID=APPLICATION_ID,
         AI.INTERFACE_ID=INTERFACE_ID,
				 AI.ACCOUNT_ID=ACCOUNT_ID, 
         AI.PRIORITY=PRIORITY,
	       AI.AUTO_RUN=AUTO_RUN
   WHERE AI.APPLICATION_ID=OLD_APPLICATION_ID
	   AND AI.INTERFACE_ID=OLD_INTERFACE_ID
		 AND AI.ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--

/* �������� ��������� �������� ���������� � ���������� */

CREATE PROCEDURE /*PREFIX*/D_APPLICATION_INTERFACE
(
  IN OLD_APPLICATION_ID VARCHAR(32),
	IN OLD_INTERFACE_ID VARCHAR(32),
	IN OLD_ACCOUNT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/APPLICATION_INTERFACES 
        WHERE APPLICATION_ID=OLD_APPLICATION_ID
				  AND INTERFACE_ID=OLD_INTERFACE_ID
					AND ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

--