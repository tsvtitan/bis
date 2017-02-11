/* Создание процедуры расчета третьего раунда */

CREATE OR ALTER PROCEDURE CALCULATE_THIRD_ROUND
(
  TIRAGE_ID VARCHAR(32)
)
AS
BEGIN

  DELETE FROM WINNINGS
        WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                               FROM LOTTERY
                              WHERE TIRAGE_ID=:TIRAGE_ID
                                AND ROUND_NUM=3
                                AND SUBROUND_ID IS NULL);

  INSERT INTO WINNINGS (LOTTERY_ID,TICKET_ID)
  SELECT T.LOTTERY_ID, T.TICKET_ID
    FROM (SELECT TICKET_ID, LOTTERY_ID, COUNT(*) AS AMOUNT
            FROM GET_TICKET_LINES(:TIRAGE_ID,3,NULL)
           GROUP BY TICKET_ID, LOTTERY_ID) T
   WHERE T.AMOUNT>=6;

END

--

/* Фиксация изменений */

COMMIT