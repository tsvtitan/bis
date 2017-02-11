/* Создание просмотра свободных стоянок */

CREATE VIEW /*PREFIX*/S_PARK_FREE
AS
SELECT P.*
  FROM /*PREFIX*/S_PARKS P
 WHERE ((P.MAX_COUNT IS NOT NULL) AND
        (P.MAX_COUNT> (SELECT COUNT(*)
                         FROM /*PREFIX*/PARK_STATES
                        WHERE DATE_OUT IS NULL
                          AND PARK_ID=P.PARK_ID))) 
    OR (P.MAX_COUNT IS NULL)

--

/* Фиксация изменений */

COMMIT