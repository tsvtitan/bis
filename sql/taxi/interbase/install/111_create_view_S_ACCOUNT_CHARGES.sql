/* Создание просмотра списаний учетных записей */

CREATE VIEW /*PREFIX*/S_ACCOUNT_CHARGES
(
  ACCOUNT_ID,
  SUM_CHARGE
)
AS
SELECT ACCOUNT_ID, SUM(SUM_CHARGE)
  FROM /*PREFIX*/CHARGES
 GROUP BY ACCOUNT_ID

--

/* Фиксация изменений */

COMMIT