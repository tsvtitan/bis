/* �������� ������� ������������ �������� */

CREATE TABLE /*PREFIX*/SCRIPTS
(
  SCRIPT_ID VARCHAR(32) NOT NULL,
  ENGINE VARCHAR(100) NOT NULL,
  SCRIPT LONGBLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (SCRIPT_ID),
  FOREIGN KEY (SCRIPT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ������������ �������� */

CREATE VIEW /*PREFIX*/S_SCRIPTS
AS
  SELECT R.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/SCRIPTS R
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=R.SCRIPT_ID

--

/* �������� ��������� ���������� ������������� �������� */

CREATE PROCEDURE /*PREFIX*/I_SCRIPT
(
  IN SCRIPT_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN INTERFACE_TYPE INTEGER,
  IN ENGINE VARCHAR(100),
  IN SCRIPT LONGBLOB,
  IN PLACE INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/INTERFACES (INTERFACE_ID,NAME,DESCRIPTION,INTERFACE_TYPE,MODULE_NAME,MODULE_INTERFACE)
       VALUES (SCRIPT_ID,NAME,DESCRIPTION,INTERFACE_TYPE,NULL,NULL);
			 
  INSERT INTO /*PREFIX*/SCRIPTS (SCRIPT_ID,ENGINE,SCRIPT,PLACE)
       VALUES (SCRIPT_ID,ENGINE,SCRIPT,PLACE);
END;

--

/* �������� ��������� ��������� ������������� ������� */

CREATE PROCEDURE /*PREFIX*/U_SCRIPT
(
  IN SCRIPT_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN INTERFACE_TYPE INTEGER,
  IN ENGINE VARCHAR(100),
  IN SCRIPT LONGBLOB,
  IN PLACE INTEGER,
  IN OLD_SCRIPT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/INTERFACES I
	   SET I.INTERFACE_ID=SCRIPT_ID,
				 I.NAME=NAME,
				 I.DESCRIPTION=DESCRIPTION
	 WHERE I.INTERFACE_ID=OLD_SCRIPT_ID; 

	UPDATE /*PREFIX*/SCRIPTS S
     SET S.SCRIPT_ID=SCRIPT_ID,
         S.ENGINE=ENGINE,
         S.SCRIPT=SCRIPT,
         S.PLACE=PLACE
   WHERE S.SCRIPT_ID=OLD_SCRIPT_ID;
END;

--

/* �������� ��������� �������� ������������� ������� */

CREATE PROCEDURE /*PREFIX*/D_SCRIPT
(
  IN OLD_SCRIPT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/SCRIPTS
        WHERE SCRIPT_ID=OLD_SCRIPT_ID;
				
  DELETE FROM /*PREFIX*/INTERFACES
	      WHERE INTERFACE_ID=OLD_SCRIPT_ID;				
END;

--
