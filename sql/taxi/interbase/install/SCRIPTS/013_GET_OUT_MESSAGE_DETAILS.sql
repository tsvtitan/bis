CREATE OR ALTER PROCEDURE GET_OUT_MESSAGE_DETAILS (CONTACT    Varchar(20),
       DATE_BEGIN TIMESTAMP,
       DATE_END   TIMESTAMP)
returns (TYPE_MESSAGE Integer,
         PRIORITY     Varchar(20),
         USER_NAME    Varchar(100),
         CONTACT_R    Varchar(100),
         DATE_OUT     TIMESTAMP,
         DATE_CREATE  TIMESTAMP,
         DESCRIPTION  Varchar(250),
         TEXT_OUT     Varchar(4000))
AS 
  declare variable D1 Date;
  declare variable D2 Date;
begin
  D1=CAST(DATE_BEGIN AS DATE);
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN(DATE_OUT)
      FROM OUT_MESSAGES
      INTO :D1;
  END


 D2=CAST(DATE_END AS DATE);
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX(DATE_OUT)
      FROM OUT_MESSAGES
      INTO :D2;
  END        
   
IF(:CONTACT IS NULL) THEN BEGIN       
FOR 

SELECT
IM.TYPE_MESSAGE,
(CASE
WHEN IM.PRIORITY = 0 THEN '�������'
WHEN IM.PRIORITY = 1 THEN '�������'
WHEN IM.PRIORITY = 2 THEN '������'

ELSE ' ' END
) AS PRIORITY,

IM.CONTACT,
IM.DATE_OUT,
IM.TEXT_OUT,
IM.DESCRIPTION,
A.USER_NAME,
IM.DATE_CREATE   
FROM OUT_MESSAGES IM
LEFT JOIN ACCOUNTS A ON A.ACCOUNT_ID = IM.CREATOR_ID  
 WHERE DATE_OUT IS NOT NULL 
       AND CAST(IM.DATE_OUT  AS DATE) >= :D1 
       AND  CAST(IM.DATE_OUT  AS DATE) <= :D2  
ORDER BY IM.CONTACT, IM.DATE_OUT     
            INTO 
            :TYPE_MESSAGE,
            :PRIORITY,
            :CONTACT_R,
            :DATE_OUT,
            :TEXT_OUT,
            :DESCRIPTION,
            :USER_NAME,
            :DATE_CREATE                
          DO BEGIN       
    SUSPEND;
    END END ELSE BEGIN
    
    FOR 
    
    
    SELECT
IM.TYPE_MESSAGE,
(CASE
WHEN IM.PRIORITY = 0 THEN '�������'
WHEN IM.PRIORITY = 1 THEN '�������'
WHEN IM.PRIORITY = 2 THEN '������'

ELSE ' ' END
) AS PRIORITY,
IM.CONTACT,
IM.DATE_OUT,
IM.TEXT_OUT,
IM.DESCRIPTION,
A.USER_NAME,
IM.DATE_CREATE   
FROM OUT_MESSAGES IM
LEFT JOIN ACCOUNTS A ON A.ACCOUNT_ID = IM.CREATOR_ID  
 WHERE DATE_OUT IS NOT NULL 
       AND CAST(IM.DATE_OUT  AS DATE) >= :D1 
       AND  CAST(IM.DATE_OUT  AS DATE) <= :D2
       AND IM.CONTACT = :CONTACT  
ORDER BY IM.CONTACT, IM.DATE_OUT     
            INTO 
            :TYPE_MESSAGE,
            :PRIORITY,
            :CONTACT_R,
            :DATE_OUT,
            :TEXT_OUT,
            :DESCRIPTION,
            :USER_NAME,
            :DATE_CREATE             
          DO BEGIN       
    SUSPEND;  
     
    END 
    END
end