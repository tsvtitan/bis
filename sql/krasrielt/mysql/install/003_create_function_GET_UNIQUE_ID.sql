/* Создание функции генерации уникального идентификатора */

CREATE FUNCTION /*PREFIX*/GET_UNIQUE_ID RETURNS STRING SONAME 'udfmysql.dll';

--
