/* —оздание просмотра сто€нок с водител€ми у которых положительный баланс */

CREATE VIEW /*PERFIX*/S_PARK_POSITIVE_STATES
AS
SELECT *
  FROM /*PREFIX*/S_PARK_STATES
 WHERE (MIN_BALANCE IS NULL)
    OR (ACTUAL_BALANCE>MIN_BALANCE)

--

/* ‘иксаци€ изменений */

COMMIT