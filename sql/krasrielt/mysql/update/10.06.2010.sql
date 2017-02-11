DROP PROCEDURE P_AMOUNT_DETAIL

--

CREATE PROCEDURE P_AMOUNT_DETAIL
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
  	  FROM  PUBLISHING_OBJECTS PO
	   WHERE PO.PUBLISHING_ID=PUBLISHING_ID;
	END IF;	 
	 
  IF (ADATE_END IS NULL) THEN
    SELECT MAX(PO.DATE_BEGIN) INTO ADATE_END
	    FROM  PUBLISHING_OBJECTS PO
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
   ORDER BY V.NUM, VT.PRIORITY;
 
END;

--

DROP PROCEDURE P_AMOUNT_ALL

--

CREATE PROCEDURE P_AMOUNT_ALL
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
  	  FROM PUBLISHING_OBJECTS PO
	   WHERE PO.PUBLISHING_ID=PUBLISHING_ID;
	END IF;	 
	 
  IF (ADATE_END IS NULL) THEN
    SELECT MAX(PO.DATE_BEGIN) INTO ADATE_END
	    FROM PUBLISHING_OBJECTS PO
	   WHERE PO.PUBLISHING_ID=PUBLISHING_ID;
	END IF;	 
	 	 
   
  SELECT F.SMALL_NAME,
         A1.USER_NAME, 
       
         (SELECT COUNT(*)
            FROM PUBLISHING_OBJECTS PO1
            JOIN OBJECTS O1 ON O1.OBJECT_ID=PO1.OBJECT_ID
           WHERE PO1.PUBLISHING_ID=PO.PUBLISHING_ID
             AND O1.DESIGN_ID IS NULL
             AND O1.ACCOUNT_ID=O.ACCOUNT_ID
             AND O1.VIEW_ID=O.VIEW_ID
             AND O1.TYPE_ID=O.TYPE_ID
             AND O1.OPERATION_ID=O.OPERATION_ID
             AND PO1.DATE_BEGIN>=ADATE_BEGIN
		         AND PO1.DATE_BEGIN<=ADATE_END
             ) AS COUNT_USUAL,
           
         (SELECT COUNT(*)
            FROM PUBLISHING_OBJECTS PO1
            JOIN OBJECTS O1 ON O1.OBJECT_ID=PO1.OBJECT_ID
           WHERE PO1.PUBLISHING_ID=PO.PUBLISHING_ID
             AND O1.DESIGN_ID='EFFBC1828CFFAFF94FEB837AD64E6763'
             AND O1.ACCOUNT_ID=O.ACCOUNT_ID
             AND O1.VIEW_ID=O.VIEW_ID
             AND O1.TYPE_ID=O.TYPE_ID
             AND O1.OPERATION_ID=O.OPERATION_ID
             AND PO1.DATE_BEGIN>=ADATE_BEGIN
		         AND PO1.DATE_BEGIN<=ADATE_END
             ) AS COUNT_BOLD,
           
         (SELECT COUNT(*)
            FROM PUBLISHING_OBJECTS PO1
            JOIN OBJECTS O1 ON O1.OBJECT_ID=PO1.OBJECT_ID
           WHERE PO1.PUBLISHING_ID=PO.PUBLISHING_ID
             AND O1.DESIGN_ID='73B26297A1CAB2AC4DC8A97137E79C64'
             AND O1.ACCOUNT_ID=O.ACCOUNT_ID
             AND O1.VIEW_ID=O.VIEW_ID
             AND O1.TYPE_ID=O.TYPE_ID
             AND O1.OPERATION_ID=O.OPERATION_ID
             AND PO1.DATE_BEGIN>=ADATE_BEGIN
		         AND PO1.DATE_BEGIN<=ADATE_END
             ) AS COUNT_FRAME,
           
         (SELECT COUNT(*)
            FROM PUBLISHING_OBJECTS PO1
            JOIN OBJECTS O1 ON O1.OBJECT_ID=PO1.OBJECT_ID
           WHERE PO1.PUBLISHING_ID=PO.PUBLISHING_ID
             AND O1.DESIGN_ID='03B44FE6DEE1AEE54BDDC3C15F17DFAF'
             AND O1.ACCOUNT_ID=O.ACCOUNT_ID
             AND O1.VIEW_ID=O.VIEW_ID
             AND O1.TYPE_ID=O.TYPE_ID
             AND O1.OPERATION_ID=O.OPERATION_ID
             AND PO1.DATE_BEGIN>=ADATE_BEGIN
		         AND PO1.DATE_BEGIN<=ADATE_END
             ) AS COUNT_DOT
           
       FROM PUBLISHING_OBJECTS PO
       JOIN OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
       JOIN ACCOUNTS A1 ON A1.ACCOUNT_ID=O.ACCOUNT_ID
       LEFT JOIN FIRMS F ON F.FIRM_ID=A1.FIRM_ID 
      WHERE PO.PUBLISHING_ID=PUBLISHING_ID  
        AND PO.DATE_BEGIN>=ADATE_BEGIN
		    AND PO.DATE_BEGIN<=ADATE_END
      GROUP BY F.SMALL_NAME, A1.USER_NAME
      ORDER BY F.SMALL_NAME, A1.USER_NAME;    
    
END;

--