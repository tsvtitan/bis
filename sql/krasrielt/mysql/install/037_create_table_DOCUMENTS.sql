/* �������� ������� ���������� */

CREATE TABLE /*PREFIX*/DOCUMENTS
(
  DOCUMENT_ID VARCHAR(32) NOT NULL,
  OLE_CLASS VARCHAR(100) NOT NULL,
  DOCUMENT LONGBLOB NOT NULL,
  PLACE INTEGER NOT NULL,
  PRIMARY KEY (DOCUMENT_ID),
  FOREIGN KEY (DOCUMENT_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID)
)

--

/* �������� ��������� ������� ���������� */

CREATE VIEW /*PREFIX*/S_DOCUMENTS
AS
  SELECT D.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/DOCUMENTS D
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=D.DOCUMENT_ID

--

/* �������� ��������� ���������� ��������� */

CREATE PROCEDURE /*PREFIX*/I_DOCUMENT
(
  IN DOCUMENT_ID VARCHAR(32),
  IN OLE_CLASS VARCHAR(100),
  IN DOCUMENT LONGBLOB,
  IN PLACE INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/DOCUMENTS (DOCUMENT_ID,OLE_CLASS,DOCUMENT,PLACE)
       VALUES (DOCUMENT_ID,OLE_CLASS,DOCUMENT,PLACE);
END;

--

/* �������� ��������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/U_DOCUMENT
(
  IN DOCUMENT_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN INTERFACE_TYPE INTEGER,
  IN OLE_CLASS VARCHAR(100),
  IN DOCUMENT LONGBLOB,
  IN PLACE INTEGER,
  IN OLD_DOCUMENT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/INTERFACES I
	   SET I.INTERFACE_ID=DOCUMENT_ID,
				 I.NAME=NAME,
				 I.DESCRIPTION=DESCRIPTION
	 WHERE I.INTERFACE_ID=OLD_DOCUMENT_ID; 

  UPDATE /*PREFIX*/DOCUMENTS D
     SET D.DOCUMENT_ID=DOCUMENT_ID,
         D.OLE_CLASS=OLE_CLASS,
         D.DOCUMENT=DOCUMENT,
         D.PLACE=PLACE
   WHERE D.DOCUMENT_ID=OLD_DOCUMENT_ID;
END;

--

/* �������� ��������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/D_DOCUMENT
(
  IN OLD_DOCUMENT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/DOCUMENTS
        WHERE DOCUMENT_ID=OLD_DOCUMENT_ID;
				
  DELETE FROM /*PREFIX*/INTERFACES
	      WHERE INTERFACE_ID=OLD_DOCUMENT_ID;						
END;

--