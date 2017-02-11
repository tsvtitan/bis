CREATE OR ALTER PROCEDURE GET_ORDER_DETAILS (ORDER_NUM  Integer,
       DATE_BEGIN TIMESTAMP,
       DATE_END   TIMESTAMP)
returns (ORDER_NUM_R  Integer,
         WHO_HISTORY  Varchar(100),
         WHO_PROCESS  Varchar(100),
         ACTION_NAME  Varchar(100),
         RESULT_NAME  Varchar(100),
         DATE_BEGIN_R TIMESTAMP,
         DATE_END_R   TIMESTAMP,
         DESCRIPTION  Varchar(250),
         DATE_HISTORY TIMESTAMP,
         RAZN         Double precision)
AS 
  declare variable D1 Date;
  declare variable D2 Date;
begin
  D1=CAST(DATE_BEGIN AS DATE);
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN((CASE
              WHEN DATE_BEGIN IS NOT NULL THEN DATE_BEGIN
              ELSE DATE_HISTORY END))
      FROM ORDERS
      INTO :D1;
  END


 D2=CAST(DATE_END AS DATE);
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX((CASE
              WHEN DATE_BEGIN IS NOT NULL THEN DATE_BEGIN
              ELSE DATE_HISTORY END))
      FROM ORDERS
      INTO :D2;
  END        
   
IF(:ORDER_NUM IS NULL) THEN BEGIN       
FOR SELECT
      O.ORDER_NUM,
      (SELECT AC.USER_NAME 
      FROM ACCOUNTS AC
      WHERE AC.ACCOUNT_ID = O.WHO_HISTORY_ID) AS WHO_HISTORY,  
       O.DATE_HISTORY,
       (SELECT AC.USER_NAME 
       FROM ACCOUNTS AC
       WHERE AC.ACCOUNT_ID = O.WHO_PROCESS_ID) AS WHO_PROCESS,
       A.NAME AS ACTION_NAME,
       R.NAME AS RESULT_NAME,
       O.DATE_BEGIN,
       O.DATE_END,
       (O.DATE_END -  O.DATE_BEGIN) AS RAZN,
       O.DESCRIPTION  
FROM ORDERS O
LEFT JOIN RESULTS R ON O.RESULT_ID = R.RESULT_ID 
LEFT JOIN ACTIONS A ON O.ACTION_ID = A.ACTION_ID
        WHERE CAST((CASE
              WHEN O.DATE_BEGIN IS NOT NULL THEN O.DATE_BEGIN
              ELSE O.DATE_HISTORY END) AS DATE) >= :D1 
              AND  
              CAST((CASE
              WHEN O.DATE_BEGIN IS NOT NULL THEN O.DATE_BEGIN
              ELSE O.DATE_HISTORY END) AS DATE) <= :D2
         
        ORDER BY O.ORDER_NUM, (CASE
        WHEN O.DATE_BEGIN IS NOT NULL THEN O.DATE_BEGIN
        ELSE O.DATE_HISTORY END)                 
            INTO 
            :ORDER_NUM_R,
            :WHO_HISTORY,
            :DATE_HISTORY,
            :WHO_PROCESS,
            :ACTION_NAME,
            :RESULT_NAME,
            :DATE_BEGIN_R,
            :DATE_END_R,
            :RAZN,
            :DESCRIPTION          
          DO BEGIN       
    SUSPEND;
    END END ELSE BEGIN
    
    FOR SELECT
      O.ORDER_NUM,
      (SELECT AC.USER_NAME 
      FROM ACCOUNTS AC
      WHERE AC.ACCOUNT_ID = O.WHO_HISTORY_ID) AS WHO_HISTORY,  
       O.DATE_HISTORY,
       (SELECT AC.USER_NAME 
       FROM ACCOUNTS AC
       WHERE AC.ACCOUNT_ID = O.WHO_PROCESS_ID) AS WHO_PROCESS,
       A.NAME AS ACTION_NAME,
       R.NAME AS RESULT_NAME,
       O.DATE_BEGIN,
       O.DATE_END,
       (O.DATE_END -  O.DATE_BEGIN) AS RAZN,
       O.DESCRIPTION  
FROM ORDERS O
LEFT JOIN RESULTS R ON O.RESULT_ID = R.RESULT_ID 
LEFT JOIN ACTIONS A ON O.ACTION_ID = A.ACTION_ID
        WHERE CAST((CASE
              WHEN O.DATE_BEGIN IS NOT NULL THEN O.DATE_BEGIN
              ELSE O.DATE_HISTORY END) AS DATE) >= :D1 
              AND  
              CAST((CASE
              WHEN O.DATE_BEGIN IS NOT NULL THEN O.DATE_BEGIN
              ELSE O.DATE_HISTORY END) AS DATE) <= :D2
              AND O.ORDER_NUM = :ORDER_NUM
        
        ORDER BY O.ORDER_NUM, (CASE
        WHEN O.DATE_BEGIN IS NOT NULL THEN O.DATE_BEGIN
        ELSE O.DATE_HISTORY END)                 
            INTO 
            :ORDER_NUM_R,
            :WHO_HISTORY,
            :DATE_HISTORY,
            :WHO_PROCESS,
            :ACTION_NAME,
            :RESULT_NAME,
            :DATE_BEGIN_R,
            :DATE_END_R,
            :RAZN,
            :DESCRIPTION          
          DO BEGIN       
    SUSPEND;  
     
    END 
    END
end