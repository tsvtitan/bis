/* �������� ��������� ��������� ������� ������ �� ������ */

CREATE PROCEDURE /*PREFIX*/SET_TICKET_STATUS_EX
(
  TIRAGE_ID VARCHAR(32),
  TICKET_NUM VARCHAR(8),
  NOT_USED INTEGER
)
AS
BEGIN
  UPDATE /*PREFIX*/TICKETS
     SET NOT_USED=:NOT_USED
   WHERE TIRAGE_ID=:TIRAGE_ID
     AND NUM=:TICKET_NUM;
END;

--

/* �������� ��������� */

COMMIT