/* �������� ��������� ����������� ���������� ����� ������ */

CREATE PROCEDURE /*PREFIX*/DR_CREATE_ORDER
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
BEGIN
  DETECTED=0;

   SELECT COUNT(*)
     FROM /*PREFIX*/ORDERS
    WHERE ORDER_ID=:ORDER_ID
     INTO CNT;

  IF (CNT=1) THEN
    DETECTED=1;

  SUSPEND;
END

--

/* �������� ��������� */

COMMIT