/* Создание функции удаления пробелов */

DECLARE EXTERNAL FUNCTION /*PREFIX*/TRIM
    CSTRING(32767)
RETURNS CSTRING(32767)
ENTRY_POINT 'TRIM' MODULE_NAME 'udfibase.dll'

--

/* Фиксация изменений */

COMMIT


