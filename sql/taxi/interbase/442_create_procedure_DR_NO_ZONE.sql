/* �������� ��������� ����������� ���������� �� ������� ���� ������ */

CREATE PROCEDURE /*PREFIX*/DR_NO_ZONE
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

  IF (ZONE_ID IS NULL) THEN
    DETECTED=1;

  SUSPEND;
END

--

/* �������� ��������� */

COMMIT