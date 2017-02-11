/* �������� ��������� �������� ����� ���������� */

CREATE PROCEDURE /*PREFIX*/P_AMOUNT_ALL
(
  IN PUBLISHING_ID VARCHAR(32),
  IN DATE_BEGIN DATETIME,
	IN DATE_END DATETIME
)
BEGIN
  DECLARE ADATE_BEGIN DATETIME;
  DECLARE ADATE_END DATETIME;
	
	SET ADATE_BEGIN=DATE_BEGIN;
	SET ADATE_END=DATE_END;

  IF (ADATE_BEGIN IS NULL) THEN
    SELECT MIN(PO.DATE_BEGIN) INTO ADATE_BEGIN
  	  FROM /*PREFIX*/PUBLISHING_OBJECTS PO
	   WHERE PO.PUBLISHING_ID=PUBLISHING_ID;
	END IF;	 
	 
  IF (ADATE_END IS NULL) THEN
    SELECT MAX(PO.DATE_BEGIN) INTO ADATE_END
	    FROM /*PREFIX*/PUBLISHING_OBJECTS PO
	   WHERE PO.PUBLISHING_ID=PUBLISHING_ID;
	END IF;	 
	 	 
  SELECT T.* 
	  FROM (SELECT A2.USER_NAME AS WHO_NAME,
                 F.SMALL_NAME AS FIRM_SMALL_NAME,
                 A1.USER_NAME,
			           COUNT(*) AS AMOUNT
            FROM (SELECT PO.PUBLISHING_ID,
                         O.ACCOUNT_ID,
                         (SELECT ACCOUNT_ID FROM /*PREFIX*/OBJECT_PARAMS OP 
			                     WHERE OP.OBJECT_ID=O.OBJECT_ID LIMIT 0,1) AS WHO_ID
                    FROM /*PREFIX*/PUBLISHING_OBJECTS PO 
                    JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
                   WHERE PO.PUBLISHING_ID=PUBLISHING_ID
									   AND PO.DATE_BEGIN>=ADATE_BEGIN
										 AND PO.DATE_BEGIN<=ADATE_END) T
            JOIN /*PREFIX*/ACCOUNTS A1 ON A1.ACCOUNT_ID=T.ACCOUNT_ID
            JOIN /*PREFIX*/ACCOUNTS A2 ON A2.ACCOUNT_ID=T.WHO_ID
            LEFT JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=A1.FIRM_ID
           GROUP BY T.PUBLISHING_ID,T.ACCOUNT_ID) T
   ORDER BY T.WHO_NAME, T.FIRM_SMALL_NAME, T.USER_NAME;
END;


--

