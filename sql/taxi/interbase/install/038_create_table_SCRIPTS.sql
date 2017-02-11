/* �������� ������� ������������ �������� */

CREATE TABLE /*PREFIX*/SCRIPTS
(
  SCRIPT_ID VARCHAR(32) NOT NULL,
  ENGINE VARCHAR(100) NOT NULL,
  SCRIPT BLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (SCRIPT_ID),
  FOREIGN KEY (SCRIPT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ������������ �������� */

CREATE VIEW /*PREFIX*/S_SCRIPTS
(
  SCRIPT_ID,
  ENGINE,
  SCRIPT,
  PLACE,
  INTERFACE_NAME
)
AS
  SELECT R.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/SCRIPTS R
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=R.SCRIPT_ID

--

/* �������� ��������� ���������� ������������� �������� */

CREATE PROCEDURE /*PREFIX*/I_SCRIPT
(
  SCRIPT_ID VARCHAR(32),
  ENGINE VARCHAR(100),
  SCRIPT BLOB,
  PLACE INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/SCRIPTS (SCRIPT_ID,ENGINE,SCRIPT,PLACE)
       VALUES (:SCRIPT_ID,:ENGINE,:SCRIPT,:PLACE);
END;

--

/* �������� ��������� ��������� ������������� ������� */

CREATE PROCEDURE /*PREFIX*/U_SCRIPT
(
  SCRIPT_ID VARCHAR(32),
  ENGINE VARCHAR(100),
  SCRIPT BLOB,
  PLACE INTEGER,
  OLD_SCRIPT_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/SCRIPTS
     SET SCRIPT_ID=:SCRIPT_ID,
         ENGINE=:ENGINE,
         SCRIPT=:SCRIPT,
         PLACE=:PLACE
   WHERE SCRIPT_ID=:OLD_SCRIPT_ID;
END;

--

/* �������� ��������� �������� ������������� ������� */

CREATE PROCEDURE /*PREFIX*/D_SCRIPT
(
  OLD_SCRIPT_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/SCRIPTS
        WHERE SCRIPT_ID=:OLD_SCRIPT_ID;
END;

--

/* �������� ��������� */

COMMIT