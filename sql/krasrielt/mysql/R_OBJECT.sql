DROP PROCEDURE /*PREFIX*/R_OBJECT

--

CREATE PROCEDURE /*PREFIX*/R_OBJECT
(
  IN OBJECT_ID VARCHAR(32)
)
BEGIN
	DECLARE PRESENTATION_ID VARCHAR(32);
	DECLARE PUBLISHING_ID VARCHAR(32);
	DECLARE PUBLISHING_NAME VARCHAR(100);
	DECLARE VIEW_ID VARCHAR(32);
	DECLARE VIEW_NAME VARCHAR(100);
	DECLARE TYPE_ID VARCHAR(32);
  DECLARE TYPE_NAME VARCHAR(100);
	DECLARE OPERATION_ID VARCHAR(32);
  DECLARE OPERATION_NAME VARCHAR(100);
  DECLARE DATE_BEGIN DATETIME;
	DECLARE ACCOUNT_ID VARCHAR(32);
  DECLARE USER_NAME VARCHAR(100);
	DECLARE PHONE VARCHAR(100);
	DECLARE STATUS INTEGER;
	
	DECLARE D1 INTEGER DEFAULT 0;
	DECLARE C1 CURSOR FOR SELECT P.PRESENTATION_ID, T.*
	                        FROM /*PREFIX*/PRESENTATIONS P
													JOIN (SELECT PO.PUBLISHING_ID, P.NAME AS PUBLISHING_NAME,
	                                     O.VIEW_ID, V.NAME AS VIEW_NAME, O.TYPE_ID, T.NAME AS TYPE_NAME, 
																			 O.OPERATION_ID, OT.NAME AS OPERATION_NAME,
															         PO.DATE_BEGIN, O.ACCOUNT_ID, A.USER_NAME, A.PHONE, O.STATUS
                                  FROM /*PREFIX*/PUBLISHING_OBJECTS PO 
													        JOIN /*PREFIX*/PUBLISHING P ON P.PUBLISHING_ID=PO.PUBLISHING_ID
	                                JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=PO.OBJECT_ID
													        JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=O.VIEW_ID
													        JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=O.TYPE_ID
													        JOIN /*PREFIX*/OPERATIONS OT ON OT.OPERATION_ID=O.OPERATION_ID
													        JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=O.ACCOUNT_ID
                                 WHERE PO.OBJECT_ID=OBJECT_ID
                                   AND PO.DATE_BEGIN>=DATE_ADD(CURRENT_TIMESTAMP,INTERVAL -1 MONTH) 
	                                 AND (PO.DATE_END IS NULL OR PO.DATE_END>=CURRENT_TIMESTAMP)
	                                 AND O.STATUS IN (0,1,2)
																) T ON (P.PUBLISHING_ID IS NULL OR P.PUBLISHING_ID=T.PUBLISHING_ID)	 
                                   AND (P.VIEW_ID IS NULL OR P.VIEW_ID=T.VIEW_ID)
	                                 AND (P.TYPE_ID IS NULL OR P.TYPE_ID=T.TYPE_ID)
	                                 AND (P.OPERATION_ID IS NULL OR P.OPERATION_ID=T.OPERATION_ID)
                         WHERE P.PRESENTATION_TYPE IN (0,2,3)
												 ORDER BY P.PRESENTATION_ID;																	 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET D1=1;			
	
  OPEN C1;
  FETCH C1 INTO PRESENTATION_ID, PUBLISHING_ID, PUBLISHING_NAME,
	              VIEW_ID, VIEW_NAME, TYPE_ID, TYPE_NAME, OPERATION_ID, OPERATION_NAME,
						    DATE_BEGIN, ACCOUNT_ID, USER_NAME, PHONE, STATUS;
  WHILE NOT D1 DO	
	
	  CALL R_OBJECT_PRESENTATION(PRESENTATION_ID, OBJECT_ID, PUBLISHING_ID, PUBLISHING_NAME,
                               VIEW_ID, VIEW_NAME, TYPE_ID, TYPE_NAME, OPERATION_ID, OPERATION_NAME,
					                     DATE_BEGIN, ACCOUNT_ID, USER_NAME, PHONE, STATUS); 
		
    FETCH C1 INTO PRESENTATION_ID,PUBLISHING_ID, PUBLISHING_NAME,
	                VIEW_ID, VIEW_NAME, TYPE_ID, TYPE_NAME, OPERATION_ID, OPERATION_NAME,
		  				    DATE_BEGIN, ACCOUNT_ID, USER_NAME, PHONE, STATUS;
  END WHILE;
  CLOSE C1;	
	
END;