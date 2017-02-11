/* Создание процедуры получения третьего раунда */

CREATE OR ALTER PROCEDURE GET_THIRD_ROUND
(
  TIRAGE_ID VARCHAR(32)
)
RETURNS
(
  TICKET_COUNT INTEGER
)
AS
BEGIN
  TICKET_COUNT=0;

  EXECUTE PROCEDURE CALCULATE_THIRD_ROUND(:TIRAGE_ID);

  SELECT COUNT(*)
    FROM WINNINGS
   WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                          FROM LOTTERY
                         WHERE TIRAGE_ID=:TIRAGE_ID
                           AND ROUND_NUM=3
                           AND SUBROUND_ID IS NULL)
    INTO :TICKET_COUNT;

END

--

/* Фиксация изменений */

COMMIT