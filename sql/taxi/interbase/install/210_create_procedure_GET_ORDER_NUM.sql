/* Создание процедуры получения номера заказа */

CREATE PROCEDURE /*PREFIX*/GET_ORDER_NUM
RETURNS
(
  ORDER_NUM VARCHAR(10)
)
AS
BEGIN
  SELECT GEN_ID(/*PREFIX*/GEN_ORDER_NUM,1)
    FROM RDB$DATABASE
    INTO ORDER_NUM;
END

--

/* Фиксация изменений */

COMMIT