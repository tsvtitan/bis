/* Создание процедуры определения действия Создание заказа */

CREATE PROCEDURE /*PREFIX*/DA_CREATE_ORDER
(
  ORDER_ID VARCHAR(32)
)
RETURNS
(
  DETECTED INTEGER
)
AS
  DECLARE CNT INTEGER;
BEGIN
  DETECTED=0;

   SELECT COUNT(*)
     FROM /*PREFIX*/ORDERS
    WHERE ORDER_ID=:ORDER_ID
     INTO CNT;

  IF (CNT=0) THEN
    DETECTED=1;

  SUSPEND;
END

--

/* Фиксация изменений */

COMMIT