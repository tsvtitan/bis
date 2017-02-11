/* �������� ������� ����������� */

CREATE TABLE /*PREFIX*/INTERFACES
(
  INTERFACE_ID VARCHAR2(32) NOT NULL,
  NAME VARCHAR2(100) NOT NULL,
  DESCRIPTION VARCHAR2(250),
  INTERFACE_TYPE INTEGER NOT NULL,
  MODULE_NAME VARCHAR2(100),
  MODULE_INTERFACE VARCHAR2(250) NULL,
  PRIMARY KEY (INTERFACE_ID)
)

--

/* �������� ��������� ������� ����������� */

CREATE VIEW /*PREFIX*/S_INTERFACES
AS
SELECT * FROM /*PREFIX*/INTERFACES

--

/* �������� ��������� ���������� ���������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/I_INTERFACE
(
  INTERFACE_ID IN VARCHAR2,
  NAME IN VARCHAR2,
  DESCRIPTION IN VARCHAR2,
  INTERFACE_TYPE IN INTEGER,
  MODULE_NAME IN VARCHAR2,
  MODULE_INTERFACE IN VARCHAR2
)
AS
BEGIN
  INSERT INTO /*PREFIX*/INTERFACES (INTERFACE_ID,NAME,DESCRIPTION,INTERFACE_TYPE,MODULE_NAME,MODULE_INTERFACE)
       VALUES (INTERFACE_ID,NAME,DESCRIPTION,INTERFACE_TYPE,MODULE_NAME,MODULE_INTERFACE);
END;

--

/* �������� ��������� ��������� ���������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/U_INTERFACE
(
  INTERFACE_ID IN VARCHAR2,
  NAME IN VARCHAR2,
  DESCRIPTION IN VARCHAR2,
  INTERFACE_TYPE IN INTEGER, 
  MODULE_NAME IN VARCHAR2,
  MODULE_INTERFACE IN VARCHAR2,
  OLD_INTERFACE_ID IN VARCHAR2
)
AS
BEGIN
  UPDATE /*PREFIX*/INTERFACES
     SET INTERFACE_ID=U_INTERFACE.INTERFACE_ID,
         NAME=U_INTERFACE.NAME,
         DESCRIPTION=U_INTERFACE.DESCRIPTION,
		 INTERFACE_TYPE=U_INTERFACE.INTERFACE_TYPE,
	     MODULE_NAME=U_INTERFACE.MODULE_NAME,
		 MODULE_INTERFACE=U_INTERFACE.MODULE_INTERFACE
   WHERE INTERFACE_ID=OLD_INTERFACE_ID;
END;

--

/* �������� ��������� �������� ���������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/D_INTERFACE
(
  OLD_INTERFACE_ID IN VARCHAR2
)
AS
BEGIN
  DELETE FROM /*PREFIX*/INTERFACES 
        WHERE INTERFACE_ID=OLD_INTERFACE_ID;
END;

--

/* �������� ��������� */

COMMIT