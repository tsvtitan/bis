/* Создание процедуры обработки результата заказ создан */

CREATE PROCEDURE /*PREFIX*/PR_CREATE_ORDER
(
  ORDER_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32)
)
AS
BEGIN

  UPDATE /*PREFIX*/ORDERS
     SET DATE_BEGIN=CURRENT_TIMESTAMP
   WHERE ORDER_ID=:ORDER_ID;

END

--

/* Фиксация изменений */

COMMIT