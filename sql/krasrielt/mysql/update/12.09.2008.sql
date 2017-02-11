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

CREATE VIEW /*PREFIX*/S_DOCUMENTS
AS
  SELECT D.*, 
         I.NAME AS INTERFACE_NAME
    FROM /*PREFIX*/DOCUMENTS D
    JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=D.DOCUMENT_ID

--

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

CREATE PROCEDURE /*PREFIX*/U_DOCUMENT
(
  IN DOCUMENT_ID VARCHAR(32),
  IN OLE_CLASS VARCHAR(100),
  IN DOCUMENT LONGBLOB,
  IN PLACE INTEGER,
  IN OLD_DOCUMENT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/DOCUMENTS D
     SET D.DOCUMENT_ID=DOCUMENT_ID,
         D.OLE_CLASS=OLE_CLASS,
         D.DOCUMENT=DOCUMENT,
         D.PLACE=PLACE
   WHERE D.DOCUMENT_ID=OLD_DOCUMENT_ID;
END;

--

CREATE PROCEDURE /*PREFIX*/D_DOCUMENT
(
  IN OLD_DOCUMENT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/DOCUMENTS
        WHERE DOCUMENT_ID=OLD_DOCUMENT_ID;
END;

--

CREATE TABLE /*PREFIX*/CONSTS
(
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  VALUE LONGBLOB NOT NULL,
  PRIMARY KEY (NAME)
)

--

CREATE VIEW /*PREFIX*/S_CONSTS
AS
SELECT * FROM /*PREFIX*/CONSTS

--

CREATE PROCEDURE /*PREFIX*/I_CONST
(
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN VALUE LONGBLOB
)
BEGIN
  INSERT INTO /*PREFIX*/CONSTS (NAME,DESCRIPTION,VALUE)
       VALUES (NAME,DESCRIPTION,VALUE);
END;

--

CREATE PROCEDURE /*PREFIX*/U_CONST
(
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN VALUE LONGBLOB,
  IN OLD_NAME VARCHAR(100)
)
BEGIN
  UPDATE /*PREFIX*/CONSTS C
     SET C.NAME=NAME,
         C.DESCRIPTION=DESCRIPTION,
         C.VALUE=VALUE
   WHERE C.NAME=OLD_NAME;
END;

--

CREATE PROCEDURE /*PREFIX*/D_CONST
(
  IN OLD_NAME VARCHAR(100)
)
BEGIN
  DELETE FROM /*PREFIX*/CONSTS 
        WHERE NAME=OLD_NAME;
END;

--

ALTER TABLE PARAM_VALUES
ADD EXPORT VARCHAR(100)

--

DROP VIEW /*PREFIX*/S_PARAM_VALUES

--

CREATE VIEW /*PREFIX*/S_PARAM_VALUES
AS
SELECT PV.*,
       P.NAME AS PARAM_NAME,
			 P.ELEMENT_TYPE
  FROM /*PREFIX*/PARAM_VALUES PV
  JOIN /*PREFIX*/PARAMS P ON P.PARAM_ID=PV.PARAM_ID

--

DROP PROCEDURE /*PREFIX*/I_PARAM_VALUE

--

CREATE PROCEDURE /*PREFIX*/I_PARAM_VALUE
(
  IN PARAM_VALUE_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
	IN EXPORT VARCHAR(100)
)
BEGIN
  INSERT INTO /*PREFIX*/PARAM_VALUES (PARAM_VALUE_ID,PARAM_ID,NAME,DESCRIPTION,PRIORITY,EXPORT)
       VALUES (PARAM_VALUE_ID,PARAM_ID,NAME,DESCRIPTION,PRIORITY,EXPORT);
END;

--

DROP PROCEDURE /*PREFIX*/U_PARAM_VALUE

--

CREATE PROCEDURE /*PREFIX*/U_PARAM_VALUE
(
  IN PARAM_VALUE_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
	IN EXPORT VARCHAR(100),
  IN OLD_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PARAM_VALUES PV
     SET PV.PARAM_VALUE_ID=PARAM_VALUE_ID,
         PV.PARAM_ID=PARAM_ID,
         PV.NAME=NAME,
	       PV.DESCRIPTION=DESCRIPTION,
				 PV.PRIORITY=PRIORITY,
				 PV.EXPORT=EXPORT
   WHERE PV.PARAM_VALUE_ID=OLD_PARAM_VALUE_ID;
END;



