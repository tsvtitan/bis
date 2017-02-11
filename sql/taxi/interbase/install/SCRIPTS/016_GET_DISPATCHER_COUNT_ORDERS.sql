CREATE OR ALTER PROCEDURE GET_DISPATCHER_COUNT_ORDERS (DATE_BEGIN Date,
       DATE_END   Date,
       DRIVER_ID  Varchar(32))
returns (DATE_BEGIN_R  TIMESTAMP,
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
         DRIVER_ID_R   Varchar(32),
         DRIVER_NAME   Varchar(100),
         SHIFT_BEGIN   TIMESTAMP)
AS 
  declare variable D1 Date;
  declare variable D2 Date;
begin

 D1=CAST(DATE_BEGIN AS DATE);
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN(DATE_END)
      FROM ORDERS
      INTO :D1;
  END


 D2=CAST(DATE_END AS DATE);
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX(DATE_END)
      FROM ORDERS
      INTO :D2;
  END         
IF(:DRIVER_ID IS NULL) THEN BEGIN       
FOR SELECT MIN(O.DATE_END) AS DATE_BEGIN,        
        EXTRACT(YEARDAY FROM O.DATE_END) AS DATE_YEAR_DAY,
        (CASE WHEN EXTRACT(WEEKDAY FROM O.DATE_END) = 0 THEN 7
         ELSE EXTRACT(WEEKDAY FROM O.DATE_END) END) AS DATE_WEEKDAY,
        EXTRACT(MONTH FROM O.DATE_END) AS DATE_MONTH,
        EXTRACT(YEAR FROM O.DATE_END) AS DATE_YEAR,
        MIN(D.DISPATCHER_ID) AS DRIVER_ID_R,
        MAX(A.USER_NAME) AS DRIVER_NAME,            
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_END) = 1  THEN COUNT(*) 
        ELSE 0 END) AS HOUR_01,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_END) = 2   THEN COUNT(*) 
        ELSE 0 END) AS HOUR_02,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 3 THEN COUNT(*)
        ELSE 0 END) AS HOUR_03,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 4 THEN COUNT(*)
        ELSE 0 END) AS HOUR_04,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 5 THEN COUNT(*)
        ELSE 0 END) AS HOUR_05,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 6 THEN COUNT(*)
        ELSE 0 END) AS HOUR_06,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 7 THEN COUNT(*)
        ELSE 0 END) AS HOUR_07,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 8 THEN COUNT(*)
        ELSE 0 END) AS HOUR_08,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 9 THEN COUNT(*)
        ELSE 0 END) AS HOUR_09,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 10 THEN COUNT(*)
        ELSE 0 END) AS HOUR_10,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 11 THEN COUNT(*)
        ELSE 0 END) AS HOUR_11,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 12 THEN COUNT(*)
        ELSE 0 END) AS HOUR_12,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 13 THEN COUNT(*)
        ELSE 0 END) AS HOUR_13, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 14 THEN COUNT(*)
        ELSE 0 END) AS HOUR_14, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 15 THEN COUNT(*)
        ELSE 0 END) AS HOUR_15, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 16 THEN COUNT(*)
        ELSE 0 END) AS HOUR_16, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 17 THEN COUNT(*)
        ELSE 0 END) AS HOUR_17, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 18 THEN COUNT(*)
        ELSE 0 END) AS HOUR_18, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 19 THEN COUNT(*)
        ELSE 0 END) AS HOUR_19, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 20 THEN COUNT(*)
        ELSE 0 END) AS HOUR_20,         
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 21 THEN COUNT(*)
        ELSE 0 END) AS HOUR_21,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 22 THEN COUNT(*)
        ELSE 0 END) AS HOUR_22,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 23 THEN COUNT(*)
        ELSE 0 END) AS HOUR_23,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 0 THEN COUNT(*)
        ELSE 0 END) AS HOUR_24,
        COUNT(EXTRACT(HOUR FROM O.DATE_END)) AS COUNT_TO_DAY      
      
       FROM DISPATCHERS  D
        INNER JOIN ACCOUNTS A ON A.ACCOUNT_ID = D.DISPATCHER_ID 
        INNER JOIN ORDERS O ON O.WHO_PROCESS_ID = D.DISPATCHER_ID
        
         
        WHERE CAST(O.DATE_END AS DATE) >= :D1 AND  CAST(O.DATE_END AS DATE) <= :D2
        GROUP BY D.DISPATCHER_ID,         
            EXTRACT(YEAR FROM O.DATE_END),
            EXTRACT(MONTH FROM O.DATE_END),
            EXTRACT(DAY FROM O.DATE_END),
            EXTRACT(HOUR FROM O.DATE_END),           
            EXTRACT(YEARDAY FROM O.DATE_END),
            EXTRACT(WEEKDAY FROM O.DATE_END)
            ORDER BY D.DISPATCHER_ID 
            INTO :DATE_BEGIN_R, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,            
             :DATE_MONTH,
             :DATE_YEAR,
             :DRIVER_ID_R,
             :DRIVER_NAME,  
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
         :COUNT_TO_DAY
          DO BEGIN       
    SUSPEND;
    END
    END ELSE BEGIN
    FOR SELECT MIN(O.DATE_END) AS DATE_BEGIN,        
        EXTRACT(YEARDAY FROM O.DATE_END) AS DATE_YEAR_DAY,
        (CASE WHEN EXTRACT(WEEKDAY FROM O.DATE_END) = 0 THEN 7
         ELSE EXTRACT(WEEKDAY FROM O.DATE_END) END) AS DATE_WEEKDAY,
        EXTRACT(MONTH FROM O.DATE_END) AS DATE_MONTH,
        EXTRACT(YEAR FROM O.DATE_END) AS DATE_YEAR,
        MIN(D.DISPATCHER_ID) AS DRIVER_ID_R,
        MAX(A.USER_NAME) AS DRIVER_NAME,            
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_END) = 1  THEN COUNT(*) 
        ELSE 0 END) AS HOUR_01,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_END) = 2   THEN COUNT(*) 
        ELSE 0 END) AS HOUR_02,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 3 THEN COUNT(*)
        ELSE 0 END) AS HOUR_03,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 4 THEN COUNT(*)
        ELSE 0 END) AS HOUR_04,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 5 THEN COUNT(*)
        ELSE 0 END) AS HOUR_05,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 6 THEN COUNT(*)
        ELSE 0 END) AS HOUR_06,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 7 THEN COUNT(*)
        ELSE 0 END) AS HOUR_07,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 8 THEN COUNT(*)
        ELSE 0 END) AS HOUR_08,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 9 THEN COUNT(*)
        ELSE 0 END) AS HOUR_09,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 10 THEN COUNT(*)
        ELSE 0 END) AS HOUR_10,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 11 THEN COUNT(*)
        ELSE 0 END) AS HOUR_11,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 12 THEN COUNT(*)
        ELSE 0 END) AS HOUR_12,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 13 THEN COUNT(*)
        ELSE 0 END) AS HOUR_13, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 14 THEN COUNT(*)
        ELSE 0 END) AS HOUR_14, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 15 THEN COUNT(*)
        ELSE 0 END) AS HOUR_15, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 16 THEN COUNT(*)
        ELSE 0 END) AS HOUR_16, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 17 THEN COUNT(*)
        ELSE 0 END) AS HOUR_17, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 18 THEN COUNT(*)
        ELSE 0 END) AS HOUR_18, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 19 THEN COUNT(*)
        ELSE 0 END) AS HOUR_19, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 20 THEN COUNT(*)
        ELSE 0 END) AS HOUR_20,         
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 21 THEN COUNT(*)
        ELSE 0 END) AS HOUR_21,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 22 THEN COUNT(*)
        ELSE 0 END) AS HOUR_22,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 23 THEN COUNT(*)
        ELSE 0 END) AS HOUR_23,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_END)) = 0 THEN COUNT(*)
        ELSE 0 END) AS HOUR_24,
        COUNT(EXTRACT(HOUR FROM O.DATE_END)) AS COUNT_TO_DAY        
                 
         FROM DISPATCHERS  D
        INNER JOIN ACCOUNTS A ON A.ACCOUNT_ID = D.DISPATCHER_ID 
        INNER JOIN ORDERS O ON O.WHO_PROCESS_ID = D.DISPATCHER_ID
      
         
        WHERE CAST(O.DATE_END AS DATE) >= :D1 AND  CAST(O.DATE_END AS DATE) <= :D2
        AND D.DISPATCHER_ID = :DRIVER_ID 
        GROUP BY D.DISPATCHER_ID,         
            EXTRACT(YEAR FROM O.DATE_END),
            EXTRACT(MONTH FROM O.DATE_END),
            EXTRACT(DAY FROM O.DATE_END),
            EXTRACT(HOUR FROM O.DATE_END),           
            EXTRACT(YEARDAY FROM O.DATE_END),
            EXTRACT(WEEKDAY FROM O.DATE_END)
            ORDER BY D.DISPATCHER_ID 
            INTO :DATE_BEGIN_R, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,            
             :DATE_MONTH,
             :DATE_YEAR,
             :DRIVER_ID_R,
             :DRIVER_NAME,  
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
         :COUNT_TO_DAY 
          DO BEGIN
    SUSPEND;
    END
    
     
    END
end