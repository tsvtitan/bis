/* Создание процедуры разблокировки заказа */

CREATE PROCEDURE /*PREFIX*/UNLOCK_ORDER
(
  ORDER_ID VARCHAR(32)
)
AS
BEGIN

  UPDATE /*PREFIX*/ORDERS
     SET WHO_PROCESS_ID=NULL,
         DATE_BEGIN=NULL,
         DATE_END=NULL
   WHERE ORDER_ID=:ORDER_ID;

END

--

/* Фиксация изменений */

COMMIT