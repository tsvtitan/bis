/* Создание функции подсчета длины строки */

DECLARE EXTERNAL FUNCTION STRING_LENGTH
   CSTRING(32767)
RETURNS INT BY VALUE
ENTRY_POINT 'STRING_LENGTH' MODULE_NAME 'udfibase.dll';

--

/* Фиксация изменений */

COMMIT


