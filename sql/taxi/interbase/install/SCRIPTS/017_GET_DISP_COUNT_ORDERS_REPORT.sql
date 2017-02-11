CREATE OR ALTER PROCEDURE GET_DISP_COUNT_ORDERS_REPORT (DATE_BEGIN Date,
       DATE_END   Date,
       DRIVER_ID  Varchar(32))
returns (DATE_BEGIN_R   TIMESTAMP,
         WEEK_DAY_NAME  Varchar(20),
         DATE_YEAR_DAY  Integer,
         DATE_WEEKDAY   Integer,
         HOUR_01        Integer,
         HOUR_02        Integer,
         HOUR_03        Integer,
         HOUR_04        Integer,
         HOUR_05        Integer,
         HOUR_06        Integer,
         HOUR_07        Integer,
         HOUR_08        Integer,
         HOUR_09        Integer,
         HOUR_10        Integer,
         HOUR_11        Integer,
         HOUR_12        Integer,
         HOUR_13        Integer,
         HOUR_14        Integer,
         HOUR_15        Integer,
         HOUR_16        Integer,
         HOUR_17        Integer,
         HOUR_18        Integer,
         HOUR_19        Integer,
         HOUR_20        Integer,
         HOUR_21        Integer,
         HOUR_22        Integer,
         HOUR_23        Integer,
         HOUR_24        Integer,
         COUNT_TO_DAY   Integer,
         DATE_MONTH     Integer,
         DATE_YEAR      Integer,
         DRIVER_ID_R    Varchar(32),
         DRIVER_NAME    Varchar(100),
         FIRST_YEAR_DAY Integer,
         SHIFT_BEGIN    TIMESTAMP)
AS 

begin
FOR
 SELECT MIN(GCO.DATE_BEGIN_R) AS DATE_BEGIN,
        GCO.DATE_YEAR_DAY,
        GCO.DATE_WEEKDAY,
        MIN(GCO.DATE_MONTH) AS DATE_MONTH,
        MIN(GCO.DATE_YEAR) AS DATE_YEAR,          
        MIN(GCO.DRIVER_ID_R) AS DRIVER_ID_R,
        MIN(GCO.DRIVER_NAME) AS DRIVER_NAME,
        MIN(EXTRACT(WEEKDAY FROM CAST(('01.01.'||EXTRACT(YEAR FROM GCO.DATE_BEGIN_R)) AS DATE)) - 1) AS FIRST_YEAR_DAY,                
       (CASE 
             WHEN GCO.DATE_WEEKDAY = 1 THEN 'Ïí'
             WHEN GCO.DATE_WEEKDAY = 2 THEN 'Âò'
             WHEN GCO.DATE_WEEKDAY = 3 THEN 'Ñð'
             WHEN GCO.DATE_WEEKDAY = 4 THEN '×ò'
             WHEN GCO.DATE_WEEKDAY = 5 THEN 'Ïò'
             WHEN GCO.DATE_WEEKDAY = 6 THEN 'Ñá'
             WHEN GCO.DATE_WEEKDAY = 7 THEN 'Âñ'
       ELSE '' END) AS WEEK_DAY_NAME,
       MAX(GCO.HOUR_01) AS HOUR_01,
       MAX(GCO.HOUR_02) AS HOUR_02,
       MAX(GCO.HOUR_03) AS HOUR_03,
       MAX(GCO.HOUR_04) AS HOUR_04,
       MAX(GCO.HOUR_05) AS HOUR_05,
       MAX(GCO.HOUR_06) AS HOUR_06,
       MAX(GCO.HOUR_07) AS HOUR_07,
       MAX(GCO.HOUR_08) AS HOUR_08,
       MAX(GCO.HOUR_09) AS HOUR_09,
       MAX(GCO.HOUR_10) AS HOUR_10,
       MAX(GCO.HOUR_11) AS HOUR_11,
       MAX(GCO.HOUR_12) AS HOUR_12,
       MAX(GCO.HOUR_13) AS HOUR_13,
       MAX(GCO.HOUR_14) AS HOUR_14,
       MAX(GCO.HOUR_15) AS HOUR_15,
       MAX(GCO.HOUR_16) AS HOUR_16,
       MAX(GCO.HOUR_17) AS HOUR_17,
       MAX(GCO.HOUR_18) AS HOUR_18,
       MAX(GCO.HOUR_19) AS HOUR_19,
       MAX(GCO.HOUR_20) AS HOUR_20,
       MAX(GCO.HOUR_21) AS HOUR_21,
       MAX(GCO.HOUR_22) AS HOUR_22,
       MAX(GCO.HOUR_23) AS HOUR_23,
       MAX(GCO.HOUR_24) AS HOUR_24,
       SUM(GCO.COUNT_TO_DAY) AS COUNT_TO_DAY,
       MAX((SELECT MAX(S.DATE_BEGIN)
        FROM SHIFTS S
        WHERE CAST(S.DATE_BEGIN AS DATE) = CAST(GCO.DATE_BEGIN_R AS DATE) 
              AND S.ACCOUNT_ID = GCO.DRIVER_ID_R   
       )) AS SHIFT_BEGIN
               
FROM GET_DISPATCHER_COUNT_ORDERS(:DATE_BEGIN, :DATE_END, :DRIVER_ID) GCO
--LEFT JOIN SHIFTS S ON (CAST(S.DATE_BEGIN AS DATE) = CAST(GCO.DATE_BEGIN_R AS DATE) AND S.ACCOUNT_ID = GCO.DRIVER_ID_R)

GROUP BY GCO.DRIVER_ID_R, GCO.DATE_YEAR_DAY, GCO.DATE_WEEKDAY
ORDER BY GCO.DRIVER_ID_R, MIN(GCO.DATE_BEGIN_R)
            INTO :DATE_BEGIN_R, 
             :DATE_YEAR_DAY,
             :DATE_WEEKDAY,
             :DATE_MONTH,
             :DATE_YEAR,             
             :DRIVER_ID_R,
             :DRIVER_NAME,
             :FIRST_YEAR_DAY,
             :WEEK_DAY_NAME,
             :HOUR_01       ,
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
         :HOUR_24,
         :COUNT_TO_DAY,
         :SHIFT_BEGIN 
         DO BEGIN
    SUSPEND;
  END
end