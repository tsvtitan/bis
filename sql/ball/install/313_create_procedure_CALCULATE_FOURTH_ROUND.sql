/* Создание процедуры расчета четвертого раунда */

CREATE OR ALTER PROCEDURE CALCULATE_FOURTH_ROUND 
(
  TIRAGE_ID VARCHAR(32),
  SUBROUND_ID VARCHAR(32)
)
AS
BEGIN

  DELETE FROM WINNINGS
        WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                               FROM LOTTERY
                              WHERE TIRAGE_ID=:TIRAGE_ID
                                AND ROUND_NUM=4
                                AND SUBROUND_ID=:SUBROUND_ID);

  INSERT INTO WINNINGS (LOTTERY_ID,TICKET_ID)
  SELECT T.LOTTERY_ID, T.TICKET_ID
    FROM (SELECT TICKET_ID, LOTTERY_ID, COUNT(*) AS AMOUNT
            FROM GET_TICKET_LINES(:TIRAGE_ID,4,:SUBROUND_ID)
           GROUP BY TICKET_ID, LOTTERY_ID) T
   WHERE T.AMOUNT>=6
     AND T.TICKET_ID NOT IN (SELECT TICKET_ID
                               FROM WINNINGS
                              WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                                                     FROM LOTTERY
                                                    WHERE TIRAGE_ID=:TIRAGE_ID
                                                      AND ROUND_NUM=3
                                                      AND SUBROUND_ID IS NULL))
     AND T.TICKET_ID NOT IN (SELECT TICKET_ID
                               FROM WINNINGS
                              WHERE LOTTERY_ID IN (SELECT LOTTERY_ID
                                                     FROM LOTTERY
                                                    WHERE TIRAGE_ID=:TIRAGE_ID
                                                      AND ROUND_NUM=4
                                                      AND SUBROUND_ID<>:SUBROUND_ID));

END

--

/* Фиксация изменений */

COMMIT