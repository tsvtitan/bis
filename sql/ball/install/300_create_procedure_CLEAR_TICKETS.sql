/* Создание процедуры очистки билетов */

CREATE PROCEDURE /*PREFIX*/CLEAR_TICKETS
(
  TIRAGE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/TICKETS
        WHERE TIRAGE_ID=:TIRAGE_ID;
END;

--

/* Фиксация изменений */

COMMIT