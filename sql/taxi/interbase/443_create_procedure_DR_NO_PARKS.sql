/* �������� ��������� ����������� ���������� ��� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/DR_NO_PARKS
(
  ORDER_ID VARCHAR(32),
  ACTION_ID VARCHAR(32),
  RESULT_ID VARCHAR(32)
)
RETURNS
(
  DETECTED INTEGER
)
AS
  DECLARE CNT INTEGER;
  DECLARE ZONE_ID VARCHAR(32);
BEGIN
  DETECTED=0;

   SELECT ZONE_ID
     FROM /*PREFIX*/ORDERS
    WHERE ORDER_ID=:ORDER_ID
     INTO :ZONE_ID;

  IF (ZONE_ID IS NOT NULL) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/PARK_STATES
     WHERE PARK_ID IN (SELECT PARK_ID FROM /*PREFIX*/ZONE_PARKS
                        WHERE ZONE_ID=:ZONE_ID)
       AND DATE_OUT IS NULL
      INTO CNT;

    IF (CNT=0) THEN
      DETECTED=1;
  END

  SUSPEND;
END

--

/* �������� ��������� */

COMMIT