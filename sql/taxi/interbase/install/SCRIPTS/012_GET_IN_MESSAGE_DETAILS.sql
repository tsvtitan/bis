CREATE OR ALTER PROCEDURE GET_IN_MESSAGE_DETAILS (CONTACT    Varchar(20),
       DATE_BEGIN TIMESTAMP,
       DATE_END   TIMESTAMP)
returns (TYPE_MESSAGE Integer,
         USER_NAME    Varchar(100),
         CONTACT_R    Varchar(100),
         DATE_IN      TIMESTAMP,
         DATE_SEND    TIMESTAMP,
         CODE         Varchar(100),
         TEXT_IN      Varchar(4000))
AS 
  declare variable D1 Date;
  declare variable D2 Date;
begin
  D1=CAST(DATE_BEGIN AS DATE);
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN(DATE_IN)
      FROM IN_MESSAGES
      INTO :D1;
  END


 D2=CAST(DATE_END AS DATE);
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX(DATE_IN)
      FROM IN_MESSAGES
      INTO :D2;
  END        
   
IF(:CONTACT IS NULL) THEN BEGIN       
FOR 

SELECT
IM.TYPE_MESSAGE,
A.USER_NAME,
IM.CONTACT,
IM.DATE_IN,
IM.DATE_SEND,
CM.CODE,
IM.TEXT_IN       
FROM IN_MESSAGES IM
LEFT JOIN CODE_MESSAGES CM ON CM.CODE_MESSAGE_ID = IM.CODE_MESSAGE_ID
LEFT JOIN ACCOUNTS A ON A.ACCOUNT_ID = IM.SENDER_ID
 WHERE DATE_IN IS NOT NULL 
       AND CAST(IM.DATE_IN  AS DATE) >= :D1 
       AND  CAST(IM.DATE_IN  AS DATE) <= :D2  
ORDER BY IM.CONTACT, IM.DATE_IN      
            INTO 
            :TYPE_MESSAGE,
            :USER_NAME,
            :CONTACT_R,
            :DATE_IN,
            :DATE_SEND,
            :CODE,
            :TEXT_IN                
          DO BEGIN       
    SUSPEND;
    END END ELSE BEGIN
    
    FOR SELECT
IM.TYPE_MESSAGE,
A.USER_NAME,
IM.CONTACT,
IM.DATE_IN,
IM.DATE_SEND,
CM.CODE,
IM.TEXT_IN       
FROM IN_MESSAGES IM
LEFT JOIN CODE_MESSAGES CM ON CM.CODE_MESSAGE_ID = IM.CODE_MESSAGE_ID
LEFT JOIN ACCOUNTS A ON A.ACCOUNT_ID = IM.SENDER_ID
        WHERE DATE_IN IS NOT NULL 
       AND CAST(IM.DATE_IN  AS DATE) >= :D1 
       AND  CAST(IM.DATE_IN  AS DATE) <= :D2  
              
              AND IM.CONTACT = :CONTACT
        
       ORDER BY IM.CONTACT, IM.DATE_IN      
            INTO 
            :TYPE_MESSAGE,
            :USER_NAME,
            :CONTACT_R,
            :DATE_IN,
            :DATE_SEND,
            :CODE,
            :TEXT_IN         
          DO BEGIN       
    SUSPEND;  
     
    END 
    END
end