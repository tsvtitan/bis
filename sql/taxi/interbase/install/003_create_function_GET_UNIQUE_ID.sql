/* Создание функции генерации уникального идентификатора */

DECLARE EXTERNAL FUNCTION /*PREFIX*/GET_UNIQUE_ID RETURNS CSTRING(32)
ENTRY_POINT 'GET_UNIQUE_ID' MODULE_NAME 'udfibase.dll'

--

/* Фиксация изменений */

COMMIT


