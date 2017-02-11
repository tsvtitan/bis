/* Создание процедуры обработки результата с ручным управлением */

CREATE PROCEDURE /*PREFIX*/PR_MANUAL
(
  ORDER_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32)
)
AS
BEGIN

  UPDATE /*PREFIX*/ORDERS
     SET TYPE_PROCESS=1,
         DATE_END=CURRENT_TIMESTAMP,
         WHO_PROCESS_ID=:ACCOUNT_ID
   WHERE ORDER_ID=:ORDER_ID;

END

--

/* Фиксация изменений */

COMMIT