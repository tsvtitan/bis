/* Создание просмотра поступлений учетных записей */

CREATE VIEW /*PREFIX*/S_ACCOUNT_RECEIPTS
(
  ACCOUNT_ID,
  SUM_RECEIPT
)
AS
SELECT ACCOUNT_ID, SUM(SUM_RECEIPT)
  FROM /*PREFIX*/RECEIPTS
 GROUP BY ACCOUNT_ID

--

/* Фиксация изменений */

COMMIT