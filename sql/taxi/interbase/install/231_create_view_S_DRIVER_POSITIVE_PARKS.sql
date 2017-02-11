/* —оздание просмотра водителей на сто€нках с положительным балансом */

CREATE VIEW /*PERFIX*/S_DRIVER_POSITIVE_PARKS
AS
SELECT *
  FROM /*PREFIX*/S_DRIVER_PARKS
 WHERE (MIN_BALANCE IS NULL)
    OR (ACTUAL_BALANCE>MIN_BALANCE)

--

/* ‘иксаци€ изменений */

COMMIT