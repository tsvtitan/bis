DROP PROCEDURE /*PREFIX*/R_PRESENTATION

--

CREATE PROCEDURE /*PREFIX*/R_PRESENTATION
(
  IN PRESENTATION_ID VARCHAR(32)
)
BEGIN
  DECLARE ATABLE VARCHAR(100);
	DECLARE COLUMN_ID VARCHAR(32);
	DECLARE PUBLISHING_ID VARCHAR(32);
	DECLARE VIEW_ID VARCHAR(32);
	DECLARE TYPE_ID VARCHAR(32);
	DECLARE OPERATION_ID VARCHAR(32);
	DECLARE CONDITIONS LONGBLOB;
	DECLARE SORTING VARCHAR(250);
	DECLARE PARAM_IDS VARCHAR(1000);
	DECLARE COLUMN_NAME VARCHAR(100);
	DECLARE OLD_COLUMN_ID VARCHAR(32);
	DECLARE PARAM_ID VARCHAR(32);
	DECLARE PARAM_TYPE INTEGER;
	DECLARE PARAM_COUNT INTEGER;
	DECLARE PRESENTATION_TYPE INTEGER;
	DECLARE REAL_COUNT INTEGER;
	DECLARE CP_STRING_BEFORE VARCHAR(100);
	DECLARE CP_STRING_AFTER VARCHAR(100);
	DECLARE CP_USE_STRING_BEFORE INTEGER;
	DECLARE CP_USE_STRING_AFTER INTEGER;
	DECLARE FIELD_NAME VARCHAR(1000);
	DECLARE SELECT_NAME VARCHAR(200);
	DECLARE NEW_QUERY VARCHAR(2000);
	DECLARE DONE INTEGER DEFAULT 0;
	DECLARE C1 CURSOR FOR SELECT PC.COLUMN_ID, C.NAME, CP.PARAM_ID, P.PARAM_TYPE,
	                             CP.STRING_BEFORE AS CP_STRING_BEFORE,CP.STRING_AFTER AS CP_STRING_AFTER,
															 CP.USE_STRING_BEFORE AS CP_USE_STRING_BEFORE,CP.USE_STRING_AFTER AS CP_USE_STRING_AFTER,
															 -- PC.STRING_BEFORE AS PC_STRING_BEFORE,PC.STRING_AFTER AS PC_STRING_AFTER,
															 PR.PUBLISHING_ID,PR.VIEW_ID,PR.TYPE_ID,PR.OPERATION_ID,PR.CONDITIONS,PR.SORTING,
															 PR.PRESENTATION_TYPE,
															 (SELECT COUNT(*) FROM /*PREFIX*/COLUMN_PARAMS CP1 WHERE CP1.COLUMN_ID=CP.COLUMN_ID) AS PARAM_COUNT
  												FROM /*PREFIX*/PRESENTATION_COLUMNS PC
  												JOIN /*PREFIX*/COLUMNS C ON C.COLUMN_ID=PC.COLUMN_ID
  												JOIN /*PREFIX*/COLUMN_PARAMS CP ON CP.COLUMN_ID=C.COLUMN_ID
  												JOIN /*PREFIX*/PARAMS P ON P.PARAM_ID=CP.PARAM_ID
													JOIN /*PREFIX*/PRESENTATIONS PR ON PR.PRESENTATION_ID=PC.PRESENTATION_ID
 												 WHERE PC.PRESENTATION_ID=PRESENTATION_ID
                         ORDER BY PC.PRIORITY, CP.PRIORITY;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE=1;												
	
  SELECT P.TABLE_NAME INTO ATABLE
    FROM /*PREFIX*/PRESENTATIONS P
   WHERE P.PRESENTATION_ID=PRESENTATION_ID
	   AND P.PRESENTATION_TYPE IN (0,2,3);
	
	IF (ATABLE<>'') THEN
	
		SET @QUERY=CONCAT('DROP TABLE IF EXISTS /*PREFIX*/',ATABLE);
    PREPARE STMT FROM @QUERY;
    EXECUTE STMT;
    DEALLOCATE PREPARE STMT;

	  SET @QUERY=CONCAT('CREATE TABLE /*PREFIX*/',ATABLE,' AS SELECT T.* FROM (SELECT OP.OBJECT_ID,PO.PUBLISHING_ID,P.NAME AS PUBLISHING_NAME,');
	  SET @QUERY=CONCAT(@QUERY,'O.VIEW_ID,V.NAME AS VIEW_NAME,O.TYPE_ID,T.NAME AS TYPE_NAME,O.OPERATION_ID,OT.NAME AS OPERATION_NAME,');
	  SET @QUERY=CONCAT(@QUERY,'PO.DATE_BEGIN,O.ACCOUNT_ID,A.USER_NAME,A.PHONE');
	  SET PARAM_IDS='';
	  SET OLD_COLUMN_ID='';
	  SET FIELD_NAME='';
	  SET REAL_COUNT=0;
		
	  OPEN C1;
    FETCH C1 INTO COLUMN_ID,COLUMN_NAME,PARAM_ID,PARAM_TYPE,
		              CP_STRING_BEFORE,CP_STRING_AFTER,CP_USE_STRING_BEFORE,CP_USE_STRING_AFTER,
		              PUBLISHING_ID,VIEW_ID,TYPE_ID,OPERATION_ID,CONDITIONS,SORTING,PRESENTATION_TYPE,PARAM_COUNT;
    WHILE NOT DONE DO
	
		  IF (OLD_COLUMN_ID<>COLUMN_ID) THEN
  		  SET REAL_COUNT=0;
	  	END IF;
		
		  SET REAL_COUNT=REAL_COUNT+1;
		
	  /*CASE 
 	    WHEN PARAM_TYPE=0 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE USING cp1251),NULL))');
      WHEN PARAM_TYPE=2 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE,SIGNED),NULL))');
      WHEN PARAM_TYPE=3 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE,DECIMAL(15,2)),NULL))');
	    ELSE SET NEW_QUERY='';
    END CASE;*/
		
		  SET SELECT_NAME='CONVERT(OP.VALUE USING cp1251)'; 
		  IF (PRESENTATION_TYPE IN (2,3)) AND (PARAM_TYPE=0) THEN
			  SET SELECT_NAME='IFNULL((SELECT EXPORT FROM /*PREFIX*/PARAM_VALUES WHERE NAME=OP.VALUE AND PARAM_ID=OP.PARAM_ID),CONVERT(OP.VALUE USING cp1251))';
			END IF;
			
		  SET FIELD_NAME=CONCAT('IFNULL(MIN(IF(OP.PARAM_ID=''',
		                        PARAM_ID,
				  									''',CONCAT(''',
					  								IFNULL(CP_STRING_BEFORE,''),
						  							''',',
														SELECT_NAME,
														',''',
							  						IFNULL(CP_STRING_AFTER,''),
								  					'''),NULL)),CONCAT(''',
														IF(CP_USE_STRING_BEFORE=1,IFNULL(CP_STRING_BEFORE,''),''),
														''',''',
														IF(CP_USE_STRING_AFTER=1,IFNULL(CP_STRING_AFTER,''),''),
														'''))');
		
		  IF (REAL_COUNT=PARAM_COUNT) THEN
    		IF (PARAM_COUNT=1) THEN
	    	  SET NEW_QUERY=FIELD_NAME;
 		    ELSE	
  		      SET NEW_QUERY=CONCAT(NEW_QUERY,',',FIELD_NAME,')');
	  	    END IF;
		    SET @QUERY=CONCAT(@QUERY,',CAST(',NEW_QUERY,' AS CHAR(250)) AS ''',COLUMN_NAME,'''');
  			SET NEW_QUERY='';
		  ELSE
		    IF (REAL_COUNT=1) THEN
			    SET NEW_QUERY=CONCAT('CONCAT(',FIELD_NAME);
			  ELSE	
  			  SET NEW_QUERY=CONCAT(NEW_QUERY,',',FIELD_NAME);
			  END IF;
		  END IF;
				
		  IF TRIM(PARAM_IDS)='' THEN
  		  SET PARAM_IDS=CONCAT('''',PARAM_ID,''''); 
		  ELSE
  		  SET PARAM_IDS=CONCAT(PARAM_IDS,',',CONCAT('''',PARAM_ID,'''')); 
		  END IF;
		
  		SET OLD_COLUMN_ID=COLUMN_ID;
		
      FETCH C1 INTO COLUMN_ID,COLUMN_NAME,PARAM_ID,PARAM_TYPE,
			              CP_STRING_BEFORE,CP_STRING_AFTER,CP_USE_STRING_BEFORE,CP_USE_STRING_AFTER,
			              PUBLISHING_ID,VIEW_ID,TYPE_ID,OPERATION_ID,CONDITIONS,SORTING,PRESENTATION_TYPE,PARAM_COUNT;
    END WHILE;
    CLOSE C1;		 

	  SET @QUERY=CONCAT(@QUERY,' FROM /*PREFIX*/OBJECT_PARAMS OP ');
	  SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=OP.OBJECT_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=O.ACCOUNT_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/PUBLISHING_OBJECTS PO ON PO.OBJECT_ID=OP.OBJECT_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/PUBLISHING P ON P.PUBLISHING_ID=PO.PUBLISHING_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=O.VIEW_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=O.TYPE_ID ');
		SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/OPERATIONS OT ON OT.OPERATION_ID=O.OPERATION_ID ');
		
	  IF TRIM(PARAM_IDS)<>'' THEN
  	  SET @QUERY=CONCAT(@QUERY,'WHERE OP.PARAM_ID IN (',PARAM_IDS,') ');
		  SET @QUERY=CONCAT(@QUERY,'AND OP.DATE_CREATE=(SELECT MAX(DATE_CREATE) FROM /*PREFIX*/OBJECT_PARAMS WHERE PARAM_ID=OP.PARAM_ID AND OBJECT_ID=O.OBJECT_ID) ');
			IF PUBLISHING_ID IS NOT NULL THEN
  	    SET @QUERY=CONCAT(@QUERY,'AND PO.PUBLISHING_ID=''',PUBLISHING_ID,''' ');
			END IF;
			IF VIEW_ID IS NOT NULL THEN
    	  SET @QUERY=CONCAT(@QUERY,'AND O.VIEW_ID=''',VIEW_ID,''' ');
			END IF;
			IF TYPE_ID IS NOT NULL THEN
    	  SET @QUERY=CONCAT(@QUERY,'AND O.TYPE_ID=''',TYPE_ID,''' ');
			END IF;
			IF OPERATION_ID IS NOT NULL THEN
     	  SET @QUERY=CONCAT(@QUERY,'AND O.OPERATION_ID=''',OPERATION_ID,''' ');
			END IF;
  	  SET @QUERY=CONCAT(@QUERY,'AND PO.DATE_BEGIN>=DATE_ADD(CURRENT_TIMESTAMP,INTERVAL -1 MONTH) ');
  	  SET @QUERY=CONCAT(@QUERY,'AND (PO.DATE_END IS NULL OR PO.DATE_END>=CURRENT_TIMESTAMP) ');
  	  SET @QUERY=CONCAT(@QUERY,'AND O.STATUS=1 ');
		  SET @QUERY=CONCAT(@QUERY,'GROUP BY OP.OBJECT_ID, PO.PUBLISHING_ID ');
      SET @QUERY=CONCAT(@QUERY,'ORDER BY PO.DATE_BEGIN DESC) T ');
			IF (TRIM(CONVERT(CONDITIONS USING cp1251))<>'') THEN
    	  SET @QUERY=CONCAT(@QUERY,'WHERE ',CONVERT(CONDITIONS USING cp1251),' ');
			END IF;
			IF TRIM(SORTING)<>'' THEN 
        SET @QUERY=CONCAT(@QUERY,'ORDER BY ',SORTING);
			END IF;

			-- SELECT @QUERY;
			
  	  PREPARE STMT FROM @QUERY;
      EXECUTE STMT;
      DEALLOCATE PREPARE STMT; 

      SET @QUERY=CONCAT('ALTER TABLE /*PREFIX*/',ATABLE,' ADD PRIMARY KEY (OBJECT_ID,PUBLISHING_ID)');
  		PREPARE STMT FROM @QUERY;
      EXECUTE STMT;
      DEALLOCATE PREPARE STMT; 

      SET @QUERY=CONCAT('ALTER TABLE /*PREFIX*/',ATABLE,' ENGINE = MEMORY');
  		PREPARE STMT FROM @QUERY;
      EXECUTE STMT;
      DEALLOCATE PREPARE STMT;       
		
	  END IF;	
  END IF;		
END;


