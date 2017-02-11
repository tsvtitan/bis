/* �������� ������� ������������ ������� */

CREATE TABLE /*PREFIX*/REPORTS
(
  REPORT_ID VARCHAR(32) NOT NULL,
  ENGINE VARCHAR(100) NOT NULL,
  REPORT BLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (REPORT_ID),
  FOREIGN KEY (REPORT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ������������ ������� */

CREATE VIEW /*PREFIX*/S_REPORTS
(
  REPORT_ID,
  ENGINE,
  REPORT,
  PLACE,
  INTERFACE_NAME
)
AS
  SELECT R.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/REPORTS R
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=R.REPORT_ID

--

/* �������� ��������� ���������� ������������� ������ */

CREATE PROCEDURE /*PREFIX*/I_REPORT
(
  REPORT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  INTERFACE_TYPE INTEGER,
  ENGINE VARCHAR(100),
  REPORT BLOB,
  PLACE INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/INTERFACES (INTERFACE_ID,NAME,DESCRIPTION,INTERFACE_TYPE,"MODULE_NAME",MODULE_INTERFACE)
       VALUES (:REPORT_ID,:NAME,:DESCRIPTION,:INTERFACE_TYPE,NULL,NULL);
  
    INSERT INTO /*PREFIX*/REPORTS (REPORT_ID,ENGINE,REPORT,PLACE)
       VALUES (:REPORT_ID,:ENGINE,:REPORT,:PLACE);
                 
END;

--

/* �������� ��������� ��������� ������������� ������ */

CREATE PROCEDURE /*PREFIX*/U_REPORT
(
  REPORT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  INTERFACE_TYPE INTEGER,
  ENGINE VARCHAR(100),
  REPORT BLOB,
  PLACE INTEGER,
  OLD_REPORT_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/INTERFACES
       SET INTERFACE_ID=:REPORT_ID,
           NAME=:NAME,
           DESCRIPTION=:DESCRIPTION
     WHERE INTERFACE_ID=:OLD_REPORT_ID;
  
  UPDATE /*PREFIX*/REPORTS
     SET REPORT_ID=:REPORT_ID,
         ENGINE=:ENGINE,
         REPORT=:REPORT,
         PLACE=:PLACE
   WHERE REPORT_ID=:OLD_REPORT_ID;
     
END;

--

/* �������� ��������� �������� ������������� ������ */

CREATE PROCEDURE /*PREFIX*/D_REPORT
(
  OLD_REPORT_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/REPORTS
        WHERE REPORT_ID=:OLD_REPORT_ID;
  
    DELETE FROM /*PREFIX*/INTERFACES
          WHERE INTERFACE_ID=:OLD_REPORT_ID;
END;

--

/* �������� ��������� */

COMMIT