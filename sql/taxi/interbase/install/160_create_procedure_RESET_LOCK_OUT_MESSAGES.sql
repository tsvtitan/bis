/* Создание процедуры сброса генератора блокировки исходящих сообщений */

CREATE PROCEDURE RESET_LOCK_OUT_MESSAGES
AS
  DECLARE VARIABLE SQL VARCHAR(250);
BEGIN
  SQL='SET GENERATOR GEN_LOCK_OUT_MESSAGES TO 0';
  EXECUTE STATEMENT SQL;
END;

--

/* Фиксация изменений */

COMMIT