/* Создание функции форматирования даты и времени */

DECLARE EXTERNAL FUNCTION /*PREFIX*/FORMAT_DATETIME
    CSTRING(32767),
    TIMESTAMP
RETURNS CSTRING(255)
ENTRY_POINT 'FORMAT_DATETIME' MODULE_NAME 'udfibase.dll';

--

/* Фиксация изменений */

COMMIT


