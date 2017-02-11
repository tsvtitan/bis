/* �������� ������� ������������� ������������� */

CREATE TABLE /*PREFIX*/ACCOUNT_PRESENTATIONS
(
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  VIEW_ID VARCHAR(32) NOT NULL,
  TYPE_ID VARCHAR(32) NOT NULL,
  OPERATION_ID VARCHAR(32) NOT NULL,
  PRESENTATION_ID VARCHAR(32) NOT NULL,
  PUBLISHING_ID VARCHAR(32) NOT NULL,
  WEEKDAY INTEGER NOT NULL,
  PRIMARY KEY (ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,PUBLISHING_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (VIEW_ID) REFERENCES /*PREFIX*/VIEWS (VIEW_ID),
  FOREIGN KEY (TYPE_ID) REFERENCES /*PREFIX*/TYPES (TYPE_ID),
  FOREIGN KEY (OPERATION_ID) REFERENCES /*PREFIX*/OPERATIONS (OPERATION_ID),
  FOREIGN KEY (PUBLISHING_ID) REFERENCES /*PREFIX*/PUBLISHING (PUBLISHING_ID),
  FOREIGN KEY (PRESENTATION_ID) REFERENCES /*PREFIX*/PRESENTATIONS (PRESENTATION_ID)
)

--

/* �������� ��������� ������� ������������� ������������� */

CREATE VIEW /*PREFIX*/S_ACCOUNT_PRESENTATIONS
AS
SELECT AP.*,
			 A.USER_NAME,
			 V.NAME AS VIEW_NAME,
			 T.NAME AS TYPE_NAME,
			 O.NAME AS OPERATION_NAME,
			 P.NAME AS PRESENTATION_NAME,
			 PB.NAME AS PUBLISHING_NAME
  FROM /*PREFIX*/ACCOUNT_PRESENTATIONS AP
	JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=AP.ACCOUNT_ID
	JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=AP.VIEW_ID
	JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=AP.TYPE_ID
	JOIN /*PREFIX*/OPERATIONS O ON O.OPERATION_ID=AP.OPERATION_ID
  JOIN /*PREFIX*/PRESENTATIONS P ON P.PRESENTATION_ID=AP.PRESENTATION_ID
  JOIN /*PREFIX*/PUBLISHING PB ON PB.PUBLISHING_ID=AP.PUBLISHING_ID	
	
--

/* �������� ��������� ���������� ������������� ������������ */

CREATE PROCEDURE /*PREFIX*/I_ACCOUNT_PRESENTATION
(
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN PRESENTATION_ID VARCHAR(32),
  IN PUBLISHING_ID VARCHAR(32),
	IN WEEKDAY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNT_PRESENTATIONS (ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,
	                                             PRESENTATION_ID,PUBLISHING_ID,WEEKDAY)
       VALUES (ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,
			         PRESENTATION_ID,PUBLISHING_ID,WEEKDAY);
END;	

--

/* �������� ��������� ��������� ������������� � ������������ */

CREATE PROCEDURE /*PREFIX*/U_ACCOUNT_PRESENTATION
(
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN PRESENTATION_ID VARCHAR(32),
  IN PUBLISHING_ID VARCHAR(32),
	IN WEEKDAY INTEGER,
  IN OLD_ACCOUNT_ID VARCHAR(32),
  IN OLD_VIEW_ID VARCHAR(32),
  IN OLD_TYPE_ID VARCHAR(32),
  IN OLD_OPERATION_ID VARCHAR(32),
  IN OLD_PUBLISHING_ID VARCHAR(32)	
)
BEGIN
  UPDATE /*PREFIX*/ACCOUNT_PRESENTATIONS AP
     SET AP.ACCOUNT_ID=ACCOUNT_ID,
		     AP.VIEW_ID=VIEW_ID,
		     AP.TYPE_ID=TYPE_ID,
		     AP.OPERATION_ID=OPERATION_ID,
		     AP.PRESENTATION_ID=PRESENTATION_ID,
		     AP.PUBLISHING_ID=PUBLISHING_ID,
				 AP.WEEKDAY=WEEKDAY
   WHERE AP.ACCOUNT_ID=OLD_ACCOUNT_ID
	   AND AP.VIEW_ID=OLD_VIEW_ID
	   AND AP.TYPE_ID=OLD_TYPE_ID
	   AND AP.OPERATION_ID=OLD_OPERATION_ID
		 AND AP.PUBLISHING_ID=OLD_PUBLISHING_ID;
END;

--

/* �������� ��������� �������� ������������� � ������������ */

CREATE PROCEDURE /*PREFIX*/D_ACCOUNT_PRESENTATION
(
  IN OLD_ACCOUNT_ID VARCHAR(32),
	IN OLD_VIEW_ID VARCHAR(32),
	IN OLD_TYPE_ID VARCHAR(32),
	IN OLD_OPERATION_ID VARCHAR(32),
	IN OLD_PUBLISHING_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNT_PRESENTATIONS 
        WHERE ACCOUNT_ID=OLD_ACCOUNT_ID
				  AND VIEW_ID=OLD_VIEW_ID
				  AND TYPE_ID=OLD_TYPE_ID
				  AND OPERATION_ID=OLD_OPERATION_ID
					AND PUBLISHING_ID=OLD_PUBLISHING_ID;
END;

--