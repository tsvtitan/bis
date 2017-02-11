CREATE OR ALTER PROCEDURE GET_DRIVERS_REPORT 
returns (DRIVER_ID   Varchar(32),
         DRIVER_NAME Varchar(100))
AS 

begin
FOR SELECT D.DRIVER_ID,
           A.USER_NAME AS DRIVER_NAME       
        FROM DRIVERS  D
        INNER JOIN ACCOUNTS A ON A.ACCOUNT_ID = D.DRIVER_ID 
            INTO :DRIVER_ID,
             :DRIVER_NAME DO BEGIN       
    SUSPEND;
    END
end