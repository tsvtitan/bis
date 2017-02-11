/* Создание процедуры установки статуса билета */

CREATE PROCEDURE /*PREFIX*/SET_TICKET_STATUS
(
  TICKET_ID VARCHAR(32),
  NOT_USED INTEGER
)
AS
BEGIN
  UPDATE /*PREFIX*/TICKETS
     SET NOT_USED=:NOT_USED
   WHERE TICKET_ID=:TICKET_ID;
END;

--

/* Фиксация изменений */

COMMIT