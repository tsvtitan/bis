/* �������� ��������� ��������� ������� ������ */

CREATE PROCEDURE /*PREFIX*/GET_SECOND_ROUND
(
  TIRAGE_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32)
)
RETURNS
(
  TICKET_COUNT INTEGER
)
AS
BEGIN
  TICKET_COUNT=0;

  SELECT COUNT(*)
    FROM /*PREFIX*/GET_TICKET_LINE_COUNT(:TIRAGE_ID,:PRIZE_ID,2,1)
   WHERE LINE_COUNT>3
    INTO :TICKET_COUNT;

--  SUSPEND;
END;

--

/* �������� ��������� */

COMMIT