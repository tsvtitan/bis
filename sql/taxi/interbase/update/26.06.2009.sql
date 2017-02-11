/* Создание процедуры определения подтверждения заказа */

create or alter procedure DR_CONFIRM_ORDER (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='A87C64B41C87907A4B8C58C5F6A19E2F' /* Водитель принял заказ */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения полного расчета */

create or alter procedure DR_FULL_CALC (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='0388BCC17DE1A1754B566F18AEEED771' /* Клиент рассчитался полностью */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения клиента в машине */

create or alter procedure DR_CLIENT_IN_CAR (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='3FD0D3ABD5E0B697483FF8520EDDBD6D' /* Клиент сел в машину */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения прибытия водителя */

create or alter procedure DR_ARRIVAL_DRIVER (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='618A0B399123BEEA474944099929C541' /* Водитель прибыл */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения частичного расчета */

create or alter procedure DR_PARTLY_CALC (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='E0D06394F6BC81BA481D1F94D12B3FB4' /* Клиент отказался платить */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения отказа водителя */

create or alter procedure DR_REFUSE_DRIVER (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='2D41BEAE73EE84B04F4E6210C399BB63' /*Водитель отказалася от заказа */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения отказа клиента */

create or alter procedure DR_REFUSE_CLIENT (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='9273E67428E797614B153E4C799D6F48' /* Клиент отказался от заказа */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

/* Создание процедуры определения изменения маршрута */

create or alter procedure DR_CHANGE_ROUTE (
    ORDER_ID varchar(32),
    ACTION_ID varchar(32),
    RESULT_ID varchar(32)) 
returns (
    DETECTED integer) 
as
declare variable CNT integer;
declare variable DRIVER_ID varchar(32);
declare variable DATE_BEGIN timestamp;
BEGIN
  DETECTED=0;

  SELECT DRIVER_ID, DATE_BEGIN
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :DRIVER_ID, :DATE_BEGIN;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/IN_MESSAGES
     WHERE SENDER_ID=:DRIVER_ID
       AND CODE_MESSAGE_ID='F42D57842950B923481A9B2D02B925CB' /* Клиент хочет сменить маршрут */
       AND TYPE_MESSAGE=0
       AND DATE_IN>:DATE_BEGIN
      INTO CNT;

    IF (CNT>0) THEN
      DETECTED=1;

  END

  SUSPEND;
END

--

