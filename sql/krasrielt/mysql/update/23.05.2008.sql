DROP PROCEDURE /*PREFIX*/P_AMOUNT_ALL

--


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


DROP PROCEDURE /*PREFIX*/P_AMOUNT_DETAIL

--

CREATE PROCEDURE /*PREFIX*/P_AMOUNT_DETAIL
(
  IN ACCOUNT_ID VARCHAR(32),
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
	 	 
  SELECT V.NAME AS VIEW_NAME,
         T.NAME AS TYPE_NAME,

		  	 (SELECT COUNT(*) 
			      FROM PUBLISHING_OBJECTS PO 
			      JOIN OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
				   WHERE O.VIEW_ID=VT.VIEW_ID AND O.TYPE_ID=VT.TYPE_ID 
  				   AND O.OPERATION_ID='9BB38FBAEE8B88A54FD02C983AE5C607' 
						 AND O.ACCOUNT_ID=ACCOUNT_ID
						 AND PO.PUBLISHING_ID=PUBLISHING_ID
						 AND PO.DATE_BEGIN>=ADATE_BEGIN
						 AND PO.DATE_BEGIN<=ADATE_END
						 ) AS SELL_AMOUNT,
					 
			   (SELECT COUNT(*) 
			      FROM PUBLISHING_OBJECTS PO 
			      JOIN OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
				   WHERE O.VIEW_ID=VT.VIEW_ID AND O.TYPE_ID=VT.TYPE_ID 
   				   AND O.OPERATION_ID='A7D600213026BBCE43F7B4676A8DC7F1' 
	  				 AND O.ACCOUNT_ID=ACCOUNT_ID
						 AND PO.PUBLISHING_ID=PUBLISHING_ID
						 AND PO.DATE_BEGIN>=ADATE_BEGIN
						 AND PO.DATE_BEGIN<=ADATE_END
						 ) AS BUY_AMOUNT,

		  	 (SELECT COUNT(*) 
			      FROM PUBLISHING_OBJECTS PO 
			      JOIN OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
				   WHERE O.VIEW_ID=VT.VIEW_ID AND O.TYPE_ID=VT.TYPE_ID 
				     AND O.OPERATION_ID='D5F0B39F9E48A9304EA0A28ABFA2132F' 
					   AND O.ACCOUNT_ID=ACCOUNT_ID
						 AND PO.PUBLISHING_ID=PUBLISHING_ID
						 AND PO.DATE_BEGIN>=ADATE_BEGIN
						 AND PO.DATE_BEGIN<=ADATE_END
						 ) AS CHANGE_AMOUNT,

			   (SELECT COUNT(*) 
			      FROM PUBLISHING_OBJECTS PO 
			      JOIN OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
				   WHERE O.VIEW_ID=VT.VIEW_ID AND O.TYPE_ID=VT.TYPE_ID 
				     AND O.OPERATION_ID='31B977EB8E80ABEB4BB4215FD6777072' 
					   AND O.ACCOUNT_ID=ACCOUNT_ID
						 AND PO.PUBLISHING_ID=PUBLISHING_ID
						 AND PO.DATE_BEGIN>=ADATE_BEGIN
						 AND PO.DATE_BEGIN<=ADATE_END
						 ) AS DELIVER_AMOUNT,

			   (SELECT COUNT(*) 
			      FROM PUBLISHING_OBJECTS PO 
			      JOIN OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
				   WHERE O.VIEW_ID=VT.VIEW_ID AND O.TYPE_ID=VT.TYPE_ID 
				     AND O.OPERATION_ID='8B5206B8E53DB842408847A0C46E0A1D' 
					   AND O.ACCOUNT_ID=ACCOUNT_ID
						 AND PO.PUBLISHING_ID=PUBLISHING_ID
						 AND PO.DATE_BEGIN>=ADATE_BEGIN
						 AND PO.DATE_BEGIN<=ADATE_END
						 ) AS SHOOT_AMOUNT

	  FROM VIEW_TYPES VT 
	  JOIN VIEWS V ON V.VIEW_ID=VT.VIEW_ID
	  JOIN TYPES T ON T.TYPE_ID=VT.TYPE_ID
   ORDER BY V.PRIORITY, VT.PRIORITY;
 
END;

--

DROP VIEW /*PREFIX*/S_PUBLISHING_OBJECTS

--

CREATE VIEW /*PREFIX*/S_PUBLISHING_OBJECTS
AS
SELECT PO.*,
       P.NAME AS PUBLISHING_NAME,
			 O.ACCOUNT_ID,
			 O.OPERATION_ID,
			 O.TYPE_ID,
			 O.VIEW_ID,
			 O.STATUS,
       A.USER_NAME,
       V.NAME AS VIEW_NAME,
	     T.NAME AS TYPE_NAME,
	     OP.NAME AS OPERATION_NAME 			 
  FROM /*PREFIX*/PUBLISHING_OBJECTS PO
  JOIN /*PREFIX*/PUBLISHING P ON P.PUBLISHING_ID=PO.PUBLISHING_ID
  JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
	JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=O.ACCOUNT_ID
  JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=O.VIEW_ID
  JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=O.TYPE_ID
  JOIN /*PREFIX*/OPERATIONS OP ON OP.OPERATION_ID=O.OPERATION_ID

--

DROP PROCEDURE /*PREFIX*/I_PUBLISHING_OBJECT

--

CREATE PROCEDURE /*PREFIX*/I_PUBLISHING_OBJECT
(
  IN PUBLISHING_ID VARCHAR(32),
  IN OBJECT_ID VARCHAR(32),
	IN DATE_BEGIN DATETIME,
	IN DATE_END DATETIME,
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN STATUS INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/OBJECTS (OBJECT_ID,ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,STATUS)
       VALUES (OBJECT_ID,ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,STATUS);

  INSERT INTO /*PREFIX*/PUBLISHING_OBJECTS (PUBLISHING_ID,OBJECT_ID,DATE_BEGIN,DATE_END)
       VALUES (PUBLISHING_ID,OBJECT_ID,DATE_BEGIN,DATE_END);
END;

--

DROP PROCEDURE /*PREFIX*/U_PUBLISHING_OBJECT

--

CREATE PROCEDURE /*PREFIX*/U_PUBLISHING_OBJECT
(
  IN PUBLISHING_ID VARCHAR(32),
  IN OBJECT_ID VARCHAR(32),
	IN DATE_BEGIN DATETIME,
	IN DATE_END DATETIME,
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN STATUS INTEGER,
  IN OLD_PUBLISHING_ID VARCHAR(32),
  IN OLD_OBJECT_ID VARCHAR(32)
)
BEGIN

 UPDATE /*PREFIX*/OBJECTS O
     SET O.OBJECT_ID=OBJECT_ID,
         O.ACCOUNT_ID=ACCOUNT_ID,
         O.VIEW_ID=VIEW_ID,
      	 O.TYPE_ID=TYPE_ID,
	       O.OPERATION_ID=OPERATION_ID,
	       O.STATUS=STATUS
   WHERE O.OBJECT_ID=OLD_OBJECT_ID;

  UPDATE /*PREFIX*/PUBLISHING_OBJECTS PO
     SET PO.PUBLISHING_ID=PUBLISHING_ID,
		     PO.OBJECT_ID=OBJECT_ID,
				 PO.DATE_BEGIN=DATE_BEGIN,
				 PO.DATE_END=DATE_END
   WHERE PO.PUBLISHING_ID=OLD_PUBLISHING_ID
	   AND PO.OBJECT_ID=OLD_OBJECT_ID;
END;

--

DROP PROCEDURE /*PREFIX*/D_PUBLISHING_OBJECT

--

CREATE PROCEDURE /*PREFIX*/D_PUBLISHING_OBJECT
(
  IN OLD_PUBLISHING_ID VARCHAR(32),
	IN OLD_OBJECT_ID VARCHAR(32)
)
BEGIN

  DELETE FROM /*PREFIX*/OBJECT_PARAMS
        WHERE OBJECT_ID=OLD_OBJECT_ID;

  DELETE FROM /*PREFIX*/PUBLISHING_OBJECTS 
        WHERE PUBLISHING_ID=OLD_PUBLISHING_ID
          AND OBJECT_ID=OLD_OBJECT_ID;

	DELETE FROM /*PREFIX*/OBJECTS
        WHERE OBJECT_ID=OLD_OBJECT_ID;
				
END;

--

DROP VIEW /*PREFIX*/S_OBJECT_PARAMS

--

CREATE VIEW /*PREFIX*/S_OBJECT_PARAMS
AS
SELECT OP.*,
       A.USER_NAME,
       P.NAME AS PARAM_NAME,
       P.DESCRIPTION AS PARAM_DESCRIPTION
  FROM /*PREFIX*/OBJECT_PARAMS OP
  JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=OP.ACCOUNT_ID
  JOIN /*PREFIX*/PARAMS P ON P.PARAM_ID=OP.PARAM_ID
  JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=OP.OBJECT_ID

--