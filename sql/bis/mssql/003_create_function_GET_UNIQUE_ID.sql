/* Создание таблицы просмотра уникального идентификатора */

CREATE VIEW /*PREFIX*/S_GET_UNIQUE_ID
AS
SELECT SUBSTRING(T.ID,25,12)+
       SUBSTRING(T.ID,20,4)+
       SUBSTRING(T.ID,15,4)+
       SUBSTRING(T.ID,10,4)+
       SUBSTRING(T.ID,1,8) AS ID  
   FROM (SELECT CAST(NEWID() AS CHAR(37)) AS ID) T

--


/* Создание функции генерации уникального идентификатора */

CREATE FUNCTION /*PREFIX*/GET_UNIQUE_ID()
RETURNS VARCHAR(32)
BEGIN
  DECLARE @RET VARCHAR(37);
  SET @RET=(SELECT ID FROM /*PREFIX*/S_GET_UNIQUE_ID);
  RETURN @RET;
END

--
