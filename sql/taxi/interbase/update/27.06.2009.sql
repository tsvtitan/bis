/* Создание процедуры таймаута */

create or alter procedure DR_TIME_OUT (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable PERIOD integer;
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

   SELECT PERIOD
     FROM /*PREFIX*/ACTIONS
    WHERE ACTION_ID=:ACTION_ID
     INTO :PERIOD;

  IF (PERIOD IS NOT NULL) THEN BEGIN

    SELECT DATE_BEGIN
      FROM /*PREFIX*/ORDERS
     WHERE ORDER_ID=:ORDER_ID
      INTO :DATE_BEGIN;

    IF (DATE_BEGIN IS NOT NULL) THEN BEGIN

      IF ((DATE_BEGIN+(PERIOD*(1e0/24/60/60)))<=CURRENT_TIMESTAMP) THEN
        DETECTED=1;

    END

  END

  SUSPEND;
END

--

/* Создание процедуры выполнения результата создания заказа */

create or alter procedure PR_CREATE_ORDER (
    ORDER_ID varchar(32),
    ACCOUNT_ID varchar(32)) 
as
  declare variable DATE_BEGIN TIMESTAMP;
  declare variable DATE_ARRIVAL TIMESTAMP;
  declare variable BEFORE_PERIOD INTEGER;
  declare variable DATE_ACCEPT TIMESTAMP;
  declare variable STATUS INTEGER;
BEGIN

  DATE_BEGIN=CURRENT_TIMESTAMP;

  SELECT DATE_ACCEPT, DATE_ARRIVAL, BEFORE_PERIOD,
         (CASE WHEN (FINISHED=0) AND (CURRENT_TIMESTAMP>=(DATE_ARRIVAL-(BEFORE_PERIOD*(1e0/24/60)))) THEN 0
               WHEN (FINISHED=0) AND (CURRENT_TIMESTAMP<(DATE_ARRIVAL-(BEFORE_PERIOD*(1e0/24/60)))) THEN 1
               WHEN FINISHED=1 THEN 2
           END) AS STATUS
    FROM /*PREIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DATE_ACCEPT, :DATE_ARRIVAL, :BEFORE_PERIOD, :STATUS;

  IF (STATUS=1) THEN
    DATE_BEGIN=DATE_ARRIVAL-(BEFORE_PERIOD*(1e0/24/60));

  UPDATE /*PREFIX*/ORDERS
     SET DATE_BEGIN=:DATE_BEGIN,
         TYPE_PROCESS=0
   WHERE ORDER_ID=:ORDER_ID;

END

--