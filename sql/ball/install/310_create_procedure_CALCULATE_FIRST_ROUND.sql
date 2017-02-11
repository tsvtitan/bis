/* Создание процедуры расчета первого раунда */

CREATE OR ALTER PROCEDURE CALCULATE_FIRST_ROUND
(
  TIRAGE_ID VARCHAR(32)
)
AS
BEGIN

  DELETE FROM WINNINGS
        WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                               FROM LOTTERY
                              WHERE TIRAGE_ID=:TIRAGE_ID
                                AND ROUND_NUM=1
                                AND SUBROUND_ID IS NULL);

  INSERT INTO WINNINGS (LOTTERY_ID,TICKET_ID)
  SELECT LOTTERY_ID, TICKET_ID
    FROM GET_TICKET_LINES(:TIRAGE_ID,1,NULL);

END
--

/* Фиксация изменений */

COMMIT