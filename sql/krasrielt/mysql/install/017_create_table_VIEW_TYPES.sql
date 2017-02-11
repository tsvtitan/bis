/* �������� ������� ������� ����� */

CREATE TABLE /*PREFIX*/VIEW_TYPES
(
  VIEW_ID VARCHAR(32) NOT NULL,
  TYPE_ID VARCHAR(32) NOT NULL,
  PRIORITY INTEGER NOT NULL,
  PRIMARY KEY (VIEW_ID,TYPE_ID),
  FOREIGN KEY (VIEW_ID) REFERENCES /*PREFIX*/VIEWS (VIEW_ID),
  FOREIGN KEY (TYPE_ID) REFERENCES /*PREFIX*/TYPES (TYPE_ID)
)

--

/* �������� ��������� ������� ������� ����� */

CREATE VIEW /*PREFIX*/S_VIEW_TYPES
AS
SELECT VT.*,
       V.NAME AS VIEW_NAME,
       V.NUM AS VIEW_NUM,
       V.DESCRIPTION AS VIEW_DESCRIPTION,
       T.NAME AS TYPE_NAME,
       T.NUM AS TYPE_NUM
  FROM /*PREFIX*/VIEW_TYPES VT
  JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=VT.VIEW_ID
  JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=VT.TYPE_ID
			
--

/* �������� ��������� ���������� ���� ���� */

CREATE PROCEDURE /*PREFIX*/I_VIEW_TYPE
(
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/VIEW_TYPES (VIEW_ID,TYPE_ID,PRIORITY)
       VALUES (VIEW_ID,TYPE_ID,PRIORITY);
END;

--

/* �������� ��������� ��������� ���� � ���� */

CREATE PROCEDURE /*PREFIX*/U_VIEW_TYPE
(
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN PRIORITY INTEGER,
  IN OLD_VIEW_ID VARCHAR(32),
  IN OLD_TYPE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/VIEW_TYPES VT
     SET VT.VIEW_ID=VIEW_ID,
         VT.TYPE_ID=TYPE_ID,
         VT.PRIORITY=PRIORITY
   WHERE VT.VIEW_ID=OLD_VIEW_ID
	   AND VT.TYPE_ID=OLD_TYPE_ID;
END;

--

/* �������� ��������� �������� ���� � ���� */

CREATE PROCEDURE /*PREFIX*/D_VIEW_TYPE
(
  IN OLD_VIEW_ID VARCHAR(32),
	IN OLD_TYPE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/VIEW_TYPES 
        WHERE VIEW_ID=OLD_VIEW_ID
				  AND TYPE_ID=OLD_TYPE_ID;
END;

--