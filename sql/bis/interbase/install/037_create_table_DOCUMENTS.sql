/* �������� ������� ������������ ���������� */

CREATE TABLE /*PREFIX*/DOCUMENTS
(
  DOCUMENT_ID VARCHAR(32) NOT NULL,
  OLE_CLASS VARCHAR(100) NOT NULL,
  DOCUMENT BLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (DOCUMENT_ID),
  FOREIGN KEY (DOCUMENT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ������������ ���������� */

CREATE VIEW /*PREFIX*/S_DOCUMENTS
(
  DOCUMENT_ID,
  OLE_CLASS,
  DOCUMENT,
  PLACE,
  INTERFACE_NAME
)
AS
  SELECT D.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/DOCUMENTS D
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=D.DOCUMENT_ID

--

/* �������� ��������� ���������� ������������� ��������� */

CREATE OR ALTER PROCEDURE /*PREFIX*/I_DOCUMENT
(
  DOCUMENT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  INTERFACE_TYPE INTEGER,
  OLE_CLASS VARCHAR(100),
  DOCUMENT BLOB,
  PLACE INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/INTERFACES (INTERFACE_ID,NAME,DESCRIPTION,INTERFACE_TYPE,"MODULE_NAME",MODULE_INTERFACE)
       VALUES (:DOCUMENT_ID,:NAME,:DESCRIPTION,:INTERFACE_TYPE,NULL,NULL);

    INSERT INTO /*PREFIX*/DOCUMENTS (DOCUMENT_ID,OLE_CLASS,DOCUMENT,PLACE)
       VALUES (:DOCUMENT_ID,:OLE_CLASS,:DOCUMENT,:PLACE);
END;

--

/* �������� ��������� ��������� ������������� ��������� */

CREATE OR ALTER PROCEDURE /*PREFIX*/U_DOCUMENT
(
  DOCUMENT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  INTERFACE_TYPE INTEGER,
  OLE_CLASS VARCHAR(100),
  DOCUMENT BLOB,
  PLACE INTEGER,
  OLD_DOCUMENT_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/INTERFACES
       SET INTERFACE_ID=:DOCUMENT_ID,
           NAME=:NAME,
           DESCRIPTION=:DESCRIPTION
     WHERE INTERFACE_ID=:OLD_DOCUMENT_ID;

  UPDATE /*PREFIX*/DOCUMENTS D
     SET DOCUMENT_ID=:DOCUMENT_ID,
         OLE_CLASS=:OLE_CLASS,
         DOCUMENT=:DOCUMENT,
         PLACE=:PLACE
   WHERE DOCUMENT_ID=:OLD_DOCUMENT_ID;
END;

--

/* �������� ��������� �������� ������������� ��������� */

CREATE OR ALTER PROCEDURE /*PREFIX*/D_DOCUMENT
(
  OLD_DOCUMENT_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/DOCUMENTS
        WHERE DOCUMENT_ID=:OLD_DOCUMENT_ID;
                
  DELETE FROM /*PREFIX*/INTERFACES
          WHERE INTERFACE_ID=:OLD_DOCUMENT_ID;
END;

--

/* �������� ��������� */

COMMIT