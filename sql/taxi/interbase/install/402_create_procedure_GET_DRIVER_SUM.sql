/* �������� ��������� ������� ������� */

CREATE PROCEDURE /*PREFIX*/GET_DRIVER_SUM
(
  DRIVER_ID VARCHAR(32),
  COST NUMERIC(15,2)
)
RETURNS
(
  RET_SUM NUMERIC(15,2)
)
AS
  DECLARE TYPE_CALC INTEGER;
  DECLARE PERCENT NUMERIC(4,2);
  DECLARE CALC_SUM NUMERIC(15,2);
  DECLARE PROC_NAME VARCHAR(100);
BEGIN
  RET_SUM=COST;

  IF ((DRIVER_ID IS NOT NULL) AND (COST IS NOT NULL)) THEN BEGIN

    SELECT C.TYPE_CALC, C.PERCENT, C.CALC_SUM, C.PROC_NAME
      FROM /*PREFIX*/DRIVERS D
      JOIN /*PREFIX*/CALCS C ON C.CALC_ID=D.CALC_ID
     WHERE D.DRIVER_ID=:DRIVER_ID
      INTO :TYPE_CALC, :PERCENT, :CALC_SUM, :PROC_NAME;

    IF (TYPE_CALC=0) THEN
      RET_SUM=COST;

    IF (TYPE_CALC=1) THEN
      RET_SUM=COST;

    IF ((TYPE_CALC=2) AND (PERCENT IS NOT NULL)) THEN BEGIN

      RET_SUM=(COST*PERCENT)/100;

    END

    IF ((TYPE_CALC=3) AND (CALC_SUM IS NOT NULL)) THEN BEGIN

      RET_SUM=COST-CALC_SUM;

    END

  END

  SUSPEND;

END

--

/* �������� ��������� */

COMMIT