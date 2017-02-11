CREATE OR ALTER PROCEDURE GET_COUNT_IN_MESSAGES (DATE_BEGIN Date,
       DATE_END   Date,
       CONTACT    Varchar(20))
returns (DATE_IN       TIMESTAMP,
         DATE_YEAR_DAY Integer,
         DATE_WEEKDAY  Integer,
         HOUR_01       Integer,
         HOUR_02       Integer,
         HOUR_03       Integer,
         HOUR_04       Integer,
         HOUR_05       Integer,
         HOUR_06       Integer,
         HOUR_07       Integer,
         HOUR_08       Integer,
         HOUR_09       Integer,
         HOUR_10       Integer,
         HOUR_11       Integer,
         HOUR_12       Integer,
         HOUR_13       Integer,
         HOUR_14       Integer,
         HOUR_15       Integer,
         HOUR_16       Integer,
         HOUR_17       Integer,
         HOUR_18       Integer,
         HOUR_19       Integer,
         HOUR_20       Integer,
         HOUR_21       Integer,
         HOUR_22       Integer,
         HOUR_23       Integer,
         HOUR_24       Integer,
         COUNT_TO_DAY  Integer,
         DATE_MONTH    Integer,
         DATE_YEAR     Integer,
         CONTACT_R     Varchar(20))
AS 
  declare variable D1 TimeStamp;
  declare variable D2 TimeStamp;
begin

 D1=DATE_BEGIN;
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN(DATE_IN)
      FROM IN_MESSAGES
      INTO :D1;
  END


  D2=DATE_END;
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX(DATE_IN)
      FROM IN_MESSAGES
      INTO :D2;
  END         
IF(:CONTACT IS NULL) THEN BEGIN       
FOR  SELECT MIN(O.DATE_IN) AS DATE_IN,
        EXTRACT(YEARDAY FROM O.DATE_IN) AS DATE_YEAR_DAY,
        (CASE WHEN EXTRACT(WEEKDAY FROM O.DATE_IN) = 0 THEN 7
         ELSE EXTRACT(WEEKDAY FROM O.DATE_IN) END) AS DATE_WEEKDAY,
        EXTRACT(MONTH FROM O.DATE_IN) AS DATE_MONTH,
        EXTRACT(YEAR FROM O.DATE_IN) AS DATE_YEAR,
        O.CONTACT AS CONTACT_R,                 
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_IN) = 1  THEN COUNT(*) 
        ELSE 0 END) AS HOUR_01,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_IN) = 2   THEN COUNT(*) 
        ELSE 0 END) AS HOUR_02,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 3 THEN COUNT(*)
        ELSE 0 END) AS HOUR_03,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 4 THEN COUNT(*)
        ELSE 0 END) AS HOUR_04,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 5 THEN COUNT(*)
        ELSE 0 END) AS HOUR_05,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 6 THEN COUNT(*)
        ELSE 0 END) AS HOUR_06,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 7 THEN COUNT(*)
        ELSE 0 END) AS HOUR_07,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 8 THEN COUNT(*)
        ELSE 0 END) AS HOUR_08,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 9 THEN COUNT(*)
        ELSE 0 END) AS HOUR_09,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 10 THEN COUNT(*)
        ELSE 0 END) AS HOUR_10,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 11 THEN COUNT(*)
        ELSE 0 END) AS HOUR_11,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 12 THEN COUNT(*)
        ELSE 0 END) AS HOUR_12,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 13 THEN COUNT(*)
        ELSE 0 END) AS HOUR_13, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 14 THEN COUNT(*)
        ELSE 0 END) AS HOUR_14, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 15 THEN COUNT(*)
        ELSE 0 END) AS HOUR_15, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 16 THEN COUNT(*)
        ELSE 0 END) AS HOUR_16, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 17 THEN COUNT(*)
        ELSE 0 END) AS HOUR_17, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 18 THEN COUNT(*)
        ELSE 0 END) AS HOUR_18, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 19 THEN COUNT(*)
        ELSE 0 END) AS HOUR_19, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 20 THEN COUNT(*)
        ELSE 0 END) AS HOUR_20,         
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 21 THEN COUNT(*)
        ELSE 0 END) AS HOUR_21,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 22 THEN COUNT(*)
        ELSE 0 END) AS HOUR_22,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 23 THEN COUNT(*)
        ELSE 0 END) AS HOUR_23,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 0 THEN COUNT(*)
        ELSE 0 END) AS HOUR_24,
        COUNT(EXTRACT(HOUR FROM O.DATE_IN)) AS COUNT_TO_DAY                 
        FROM IN_MESSAGES O        
        WHERE O.DATE_IN IS NOT NULL 
          AND CAST(O.DATE_IN AS DATE) >= CAST(:D1 AS DATE) AND  CAST(O.DATE_IN AS DATE) <= CAST(:D2 AS DATE)          
        GROUP BY O.CONTACT,       
            EXTRACT(YEAR FROM O.DATE_IN),
            EXTRACT(MONTH FROM O.DATE_IN),
            EXTRACT(DAY FROM O.DATE_IN),
            EXTRACT(HOUR FROM O.DATE_IN),           
            EXTRACT(YEARDAY FROM O.DATE_IN),
            EXTRACT(WEEKDAY FROM O.DATE_IN)
            ORDER BY O.CONTACT, MIN(O.DATE_IN)
            INTO :DATE_IN, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,            
             :DATE_MONTH,
             :DATE_YEAR,
             :CONTACT_R,
             :HOUR_01,
         :HOUR_02       ,
         :HOUR_03       ,
         :HOUR_04       ,
         :HOUR_05       ,
         :HOUR_06       ,
         :HOUR_07       ,
         :HOUR_08       ,
         :HOUR_09       ,
         :HOUR_10       ,
         :HOUR_11       ,
         :HOUR_12       ,
         :HOUR_13       ,
         :HOUR_14       ,
         :HOUR_15       ,
         :HOUR_16       ,
         :HOUR_17       ,
         :HOUR_18       ,
         :HOUR_19       ,
         :HOUR_20       ,
         :HOUR_21       ,
         :HOUR_22       ,
         :HOUR_23       ,
         :HOUR_24 ,
         :COUNT_TO_DAY DO BEGIN       
    SUSPEND;
    END
    END ELSE BEGIN
    FOR SELECT MIN(O.DATE_IN) AS DATE_IN,
        EXTRACT(YEARDAY FROM O.DATE_IN) AS DATE_YEAR_DAY,
        (CASE WHEN EXTRACT(WEEKDAY FROM O.DATE_IN) = 0 THEN 7
         ELSE EXTRACT(WEEKDAY FROM O.DATE_IN) END) AS DATE_WEEKDAY,
        EXTRACT(MONTH FROM O.DATE_IN) AS DATE_MONTH,
        EXTRACT(YEAR FROM O.DATE_IN) AS DATE_YEAR,
        O.CONTACT AS CONTACT_R,                
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_IN) = 1  THEN COUNT(*) 
        ELSE 0 END) AS HOUR_01,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_IN) = 2   THEN COUNT(*) 
        ELSE 0 END) AS HOUR_02,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 3 THEN COUNT(*)
        ELSE 0 END) AS HOUR_03,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 4 THEN COUNT(*)
        ELSE 0 END) AS HOUR_04,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 5 THEN COUNT(*)
        ELSE 0 END) AS HOUR_05,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 6 THEN COUNT(*)
        ELSE 0 END) AS HOUR_06,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 7 THEN COUNT(*)
        ELSE 0 END) AS HOUR_07,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 8 THEN COUNT(*)
        ELSE 0 END) AS HOUR_08,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 9 THEN COUNT(*)
        ELSE 0 END) AS HOUR_09,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 10 THEN COUNT(*)
        ELSE 0 END) AS HOUR_10,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 11 THEN COUNT(*)
        ELSE 0 END) AS HOUR_11,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 12 THEN COUNT(*)
        ELSE 0 END) AS HOUR_12,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 13 THEN COUNT(*)
        ELSE 0 END) AS HOUR_13, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 14 THEN COUNT(*)
        ELSE 0 END) AS HOUR_14, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 15 THEN COUNT(*)
        ELSE 0 END) AS HOUR_15, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 16 THEN COUNT(*)
        ELSE 0 END) AS HOUR_16, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 17 THEN COUNT(*)
        ELSE 0 END) AS HOUR_17, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 18 THEN COUNT(*)
        ELSE 0 END) AS HOUR_18, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 19 THEN COUNT(*)
        ELSE 0 END) AS HOUR_19, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 20 THEN COUNT(*)
        ELSE 0 END) AS HOUR_20,         
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 21 THEN COUNT(*)
        ELSE 0 END) AS HOUR_21,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 22 THEN COUNT(*)
        ELSE 0 END) AS HOUR_22,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 23 THEN COUNT(*)
        ELSE 0 END) AS HOUR_23,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_IN)) = 0 THEN COUNT(*)
        ELSE 0 END) AS HOUR_24,
        COUNT(EXTRACT(HOUR FROM O.DATE_IN)) AS COUNT_TO_DAY                 
        FROM IN_MESSAGES O
        LEFT JOIN ACCOUNTS A ON A.PHONE = O.CONTACT
        WHERE O.DATE_IN IS NOT NULL 
          AND CAST(O.DATE_IN AS DATE) >= CAST(:D1 AS DATE) AND  CAST(O.DATE_IN AS DATE) <= CAST(:D2 AS DATE)  
          AND O.CONTACT = :CONTACT          
        GROUP BY O.CONTACT,       
            EXTRACT(YEAR FROM O.DATE_IN),
            EXTRACT(MONTH FROM O.DATE_IN),
            EXTRACT(DAY FROM O.DATE_IN),
            EXTRACT(HOUR FROM O.DATE_IN),           
            EXTRACT(YEARDAY FROM O.DATE_IN),
            EXTRACT(WEEKDAY FROM O.DATE_IN)

            INTO :DATE_IN, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,            
             :DATE_MONTH,
             :DATE_YEAR,
             :CONTACT_R,               
             :HOUR_01,
         :HOUR_02       ,
         :HOUR_03       ,
         :HOUR_04       ,
         :HOUR_05       ,
         :HOUR_06       ,
         :HOUR_07       ,
         :HOUR_08       ,
         :HOUR_09       ,
         :HOUR_10       ,
         :HOUR_11       ,
         :HOUR_12       ,
         :HOUR_13       ,
         :HOUR_14       ,
         :HOUR_15       ,
         :HOUR_16       ,
         :HOUR_17       ,
         :HOUR_18       ,
         :HOUR_19       ,
         :HOUR_20       ,
         :HOUR_21       ,
         :HOUR_22       ,
         :HOUR_23       ,
         :HOUR_24 ,
         :COUNT_TO_DAY DO BEGIN
    SUSPEND;
    END
    
     
    END
end