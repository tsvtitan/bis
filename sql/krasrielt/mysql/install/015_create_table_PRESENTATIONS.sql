/* �������� ������� ������������� */

CREATE TABLE /*PREFIX*/PRESENTATIONS
(
  PRESENTATION_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  TABLE_NAME VARCHAR(100),
  SORTING VARCHAR(250),
  PRESENTATION_TYPE INTEGER NOT NULL,   
  PUBLISHING_ID VARCHAR(32),
  VIEW_ID VARCHAR(32),
  TYPE_ID VARCHAR(32),
  OPERATION_ID VARCHAR(32),
  CONDITIONS LONGBLOB,
  EXPORT_MODE INTEGER NOT NULL,
  PRIMARY KEY (PRESENTATION_ID),
  FOREIGN KEY (PUBLISHING_ID) REFERENCES /*PREFIX*/PUBLISHING (PUBLISHING_ID),
  FOREIGN KEY (VIEW_ID) REFERENCES /*PREFIX*/VIEWS (VIEW_ID),
  FOREIGN KEY (TYPE_ID) REFERENCES /*PREFIX*/TYPES (TYPE_ID),
  FOREIGN KEY (OPERATION_ID) REFERENCES /*PREFIX*/OPERATIONS (OPERATION_ID)
)

--

/* �������� ��������� ������� ������������� */

CREATE VIEW /*PREFIX*/S_PRESENTATIONS
AS
SELECT P.*,
       PB.NAME AS PUBLISHING_NAME,
       V.NAME AS VIEW_NAME,
       V.NUM AS VIEW_NUM,
       T.NAME AS TYPE_NAME,
       T.NUM AS TYPE_NUM,
       O.NAME AS OPERATION_NAME,
       O.NUM AS OPERATION_NUM
  FROM /*PREFIX*/PRESENTATIONS P
	LEFT JOIN /*PREFIX*/PUBLISHING PB ON PB.PUBLISHING_ID=P.PUBLISHING_ID
	LEFT JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=P.VIEW_ID
	LEFT JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=P.TYPE_ID
	LEFT JOIN /*PREFIX*/OPERATIONS O ON O.OPERATION_ID=P.OPERATION_ID

--

/* �������� ��������� ���������� ������������� */

CREATE PROCEDURE /*PREFIX*/I_PRESENTATION
(
  IN PRESENTATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN TABLE_NAME VARCHAR(100),
  IN SORTING VARCHAR(250),
  IN PRESENTATION_TYPE INTEGER,
  IN PUBLISHING_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN CONDITIONS LONGBLOB
)
BEGIN
  INSERT INTO /*PREFIX*/PRESENTATIONS (PRESENTATION_ID,NAME,DESCRIPTION,TABLE_NAME,SORTING,PRESENTATION_TYPE,
                                       PUBLISHING_ID,VIEW_ID,TYPE_ID,OPERATION_ID,CONDITIONS)
       VALUES (PRESENTATION_ID,NAME,DESCRIPTION,TABLE_NAME,SORTING,PRESENTATION_TYPE,
               PUBLISHING_ID,VIEW_ID,TYPE_ID,OPERATION_ID,CONDITIONS);
END;

--

/* �������� ��������� ��������� ������������� */

CREATE PROCEDURE /*PREFIX*/U_PRESENTATION
(
  IN PRESENTATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN TABLE_NAME VARCHAR(100),
  IN SORTING VARCHAR(250),
  IN PRESENTATION_TYPE INTEGER, 
  IN PUBLISHING_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN CONDITIONS LONGBLOB,
  IN OLD_PRESENTATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PRESENTATIONS P
     SET P.PRESENTATION_ID=PRESENTATION_ID,
         P.NAME=NAME,
         P.DESCRIPTION=DESCRIPTION,
	 P.TABLE_NAME=TABLE_NAME,
	 P.SORTING=SORTING,
	 P.PRESENTATION_TYPE=PRESENTATION_TYPE,
	 P.PUBLISHING_ID=PUBLISHING_ID,
	 P.VIEW_ID=VIEW_ID,
	 P.TYPE_ID=TYPE_ID,
	 P.OPERATION_ID=OPERATION_ID,
	 P.CONDITIONS=CONDITIONS
   WHERE P.PRESENTATION_ID=OLD_PRESENTATION_ID;
END;

--

/* �������� ��������� �������� ������������� */

CREATE PROCEDURE /*PREFIX*/D_PRESENTATION
(
  IN OLD_PRESENTATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PRESENTATIONS 
        WHERE PRESENTATION_ID=OLD_PRESENTATION_ID;
END;

--