CREATE OR ALTER PROCEDURE GET_COUNT_ORDERS2 (DATE_BEGIN Date,
       DATE_END   Date,
       ZONE_ID    Varchar(32))
returns (DATE_ACCEPT   TIMESTAMP,
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
         ZONE_ID_R     Varchar(32),
         ZONE_NAME     Varchar(100))
AS 
  declare variable D1 TimeStamp;
  declare variable D2 TimeStamp;
begin

 D1=DATE_BEGIN;
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN(DATE_ACCEPT)
      FROM ORDERS
      INTO :D1;
  END


  D2=DATE_END;
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX(DATE_ACCEPT)
      FROM ORDERS
      INTO :D2;
  END         
IF(:ZONE_ID IS NULL) THEN BEGIN       
FOR SELECT  MIN(O.DATE_ACCEPT) AS DATE_ACCEPT,        
        EXTRACT(YEARDAY FROM O.DATE_ACCEPT) AS DATE_YEAR_DAY,
        (CASE WHEN EXTRACT(WEEKDAY FROM O.DATE_ACCEPT) = 0 THEN 7
         ELSE EXTRACT(WEEKDAY FROM O.DATE_ACCEPT) END) AS DATE_WEEKDAY,         
--        EXTRACT(WEEKDAY FROM O.DATE_ACCEPT) AS DATE_WEEKDAY,
        EXTRACT(MONTH FROM O.DATE_ACCEPT) AS DATE_MONTH,
        EXTRACT(YEAR FROM O.DATE_ACCEPT) AS DATE_YEAR,
        MIN(O.ZONE_ID) AS ZONE_ID_R,
        MIN(Z.NAME) AS ZONE_NAME,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_ACCEPT) = 1  THEN COUNT(*) 
        ELSE 0 END) AS HOUR_01,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_ACCEPT) = 2   THEN COUNT(*) 
        ELSE 0 END) AS HOUR_02,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 3 THEN COUNT(*)
        ELSE 0 END) AS HOUR_03,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 4 THEN COUNT(*)
        ELSE 0 END) AS HOUR_04,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 5 THEN COUNT(*)
        ELSE 0 END) AS HOUR_05,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 6 THEN COUNT(*)
        ELSE 0 END) AS HOUR_06,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 7 THEN COUNT(*)
        ELSE 0 END) AS HOUR_07,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 8 THEN COUNT(*)
        ELSE 0 END) AS HOUR_08,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 9 THEN COUNT(*)
        ELSE 0 END) AS HOUR_09,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 10 THEN COUNT(*)
        ELSE 0 END) AS HOUR_10,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 11 THEN COUNT(*)
        ELSE 0 END) AS HOUR_11,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 12 THEN COUNT(*)
        ELSE 0 END) AS HOUR_12,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 13 THEN COUNT(*)
        ELSE 0 END) AS HOUR_13, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 14 THEN COUNT(*)
        ELSE 0 END) AS HOUR_14, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 15 THEN COUNT(*)
        ELSE 0 END) AS HOUR_15, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 16 THEN COUNT(*)
        ELSE 0 END) AS HOUR_16, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 17 THEN COUNT(*)
        ELSE 0 END) AS HOUR_17, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 18 THEN COUNT(*)
        ELSE 0 END) AS HOUR_18, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 19 THEN COUNT(*)
        ELSE 0 END) AS HOUR_19, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 20 THEN COUNT(*)
        ELSE 0 END) AS HOUR_20,         
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 21 THEN COUNT(*)
        ELSE 0 END) AS HOUR_21,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 22 THEN COUNT(*)
        ELSE 0 END) AS HOUR_22,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 23 THEN COUNT(*)
        ELSE 0 END) AS HOUR_23,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 0 THEN COUNT(*)
        ELSE 0 END) AS HOUR_24,
        COUNT(EXTRACT(HOUR FROM O.DATE_ACCEPT)) AS COUNT_TO_DAY          
        FROM ROUTES R INNER JOIN ZONES Z ON R.ZONE_ID = Z.ZONE_ID
        LEFT JOIN ORDERS O ON  O.ORDER_ID = R.ORDER_ID
        WHERE CAST(O.DATE_ACCEPT AS DATE) >= :D1 AND  CAST(O.DATE_ACCEPT AS DATE) <= :D2        
        GROUP BY O.ZONE_ID,
                 
            EXTRACT(YEAR FROM O.DATE_ACCEPT),
            EXTRACT(MONTH FROM O.DATE_ACCEPT),
            EXTRACT(DAY FROM O.DATE_ACCEPT),
            EXTRACT(HOUR FROM O.DATE_ACCEPT),           
            EXTRACT(YEARDAY FROM O.DATE_ACCEPT),
            EXTRACT(WEEKDAY FROM O.DATE_ACCEPT)
            ORDER BY O.ZONE_ID
            INTO :DATE_ACCEPT, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,            
             :DATE_MONTH,
             :DATE_YEAR,
             :ZONE_ID_R,
             :ZONE_NAME,  
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
    FOR SELECT  MIN(O.DATE_ACCEPT) AS DATE_ACCEPT,        
        EXTRACT(YEARDAY FROM O.DATE_ACCEPT) AS DATE_YEAR_DAY,
        (CASE WHEN EXTRACT(WEEKDAY FROM O.DATE_ACCEPT) = 0 THEN 7
         ELSE EXTRACT(WEEKDAY FROM O.DATE_ACCEPT) END) AS DATE_WEEKDAY,         
--        EXTRACT(WEEKDAY FROM O.DATE_ACCEPT) AS DATE_WEEKDAY,
        EXTRACT(MONTH FROM O.DATE_ACCEPT) AS DATE_MONTH,
        EXTRACT(YEAR FROM O.DATE_ACCEPT) AS DATE_YEAR,
        MIN(O.ZONE_ID) AS ZONE_ID_R,
        MIN(Z.NAME) AS ZONE_NAME,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_ACCEPT) = 1  THEN COUNT(*) 
        ELSE 0 END) AS HOUR_01,        
        (CASE WHEN EXTRACT(HOUR FROM O.DATE_ACCEPT) = 2   THEN COUNT(*) 
        ELSE 0 END) AS HOUR_02,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 3 THEN COUNT(*)
        ELSE 0 END) AS HOUR_03,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 4 THEN COUNT(*)
        ELSE 0 END) AS HOUR_04,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 5 THEN COUNT(*)
        ELSE 0 END) AS HOUR_05,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 6 THEN COUNT(*)
        ELSE 0 END) AS HOUR_06,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 7 THEN COUNT(*)
        ELSE 0 END) AS HOUR_07,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 8 THEN COUNT(*)
        ELSE 0 END) AS HOUR_08,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 9 THEN COUNT(*)
        ELSE 0 END) AS HOUR_09,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 10 THEN COUNT(*)
        ELSE 0 END) AS HOUR_10,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 11 THEN COUNT(*)
        ELSE 0 END) AS HOUR_11,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 12 THEN COUNT(*)
        ELSE 0 END) AS HOUR_12,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 13 THEN COUNT(*)
        ELSE 0 END) AS HOUR_13, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 14 THEN COUNT(*)
        ELSE 0 END) AS HOUR_14, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 15 THEN COUNT(*)
        ELSE 0 END) AS HOUR_15, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 16 THEN COUNT(*)
        ELSE 0 END) AS HOUR_16, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 17 THEN COUNT(*)
        ELSE 0 END) AS HOUR_17, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 18 THEN COUNT(*)
        ELSE 0 END) AS HOUR_18, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 19 THEN COUNT(*)
        ELSE 0 END) AS HOUR_19, 
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 20 THEN COUNT(*)
        ELSE 0 END) AS HOUR_20,         
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 21 THEN COUNT(*)
        ELSE 0 END) AS HOUR_21,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 22 THEN COUNT(*)
        ELSE 0 END) AS HOUR_22,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 23 THEN COUNT(*)
        ELSE 0 END) AS HOUR_23,
        (CASE WHEN (EXTRACT(HOUR FROM O.DATE_ACCEPT)) = 0 THEN COUNT(*)
        ELSE 0 END) AS HOUR_24,
        COUNT(EXTRACT(HOUR FROM O.DATE_ACCEPT)) AS COUNT_TO_DAY              
        FROM ROUTES R INNER JOIN ZONES Z ON R.ZONE_ID = Z.ZONE_ID
        LEFT JOIN ORDERS O ON  O.ORDER_ID = R.ORDER_ID
        WHERE CAST(O.DATE_ACCEPT AS DATE) >= :D1 AND  CAST(O.DATE_ACCEPT AS DATE) <= :D2
              AND Z.ZONE_ID = :ZONE_ID
        GROUP BY O.ZONE_ID,         
            EXTRACT(YEAR FROM O.DATE_ACCEPT),
            EXTRACT(MONTH FROM O.DATE_ACCEPT),
            EXTRACT(DAY FROM O.DATE_ACCEPT),
            EXTRACT(HOUR FROM O.DATE_ACCEPT),           
            EXTRACT(YEARDAY FROM O.DATE_ACCEPT),
            EXTRACT(WEEKDAY FROM O.DATE_ACCEPT)
            ORDER BY O.ZONE_ID
            INTO :DATE_ACCEPT, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,
             :DATE_MONTH,
             :DATE_YEAR,
             :ZONE_ID_R,
             :ZONE_NAME,  
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