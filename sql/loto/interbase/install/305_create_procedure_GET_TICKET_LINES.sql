/* �������� ��������� ��������� ������� ������ � ������� */

CREATE PROCEDURE /*PREFIX*/GET_TICKET_LINES
(
  TIRAGE_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  ROUND_NUM_EX INTEGER
)
RETURNS
(
 TICKET_ID VARCHAR(32),
 LINE_NUM INTEGER
)
AS
BEGIN

  FOR SELECT TICKET_ID,1
        FROM /*PREFIX*/GET_TICKET_LINE(:TIRAGE_ID,:PRIZE_ID,:ROUND_NUM,:ROUND_NUM_EX,1)
       UNION
      SELECT TICKET_ID,2
        FROM /*PREFIX*/GET_TICKET_LINE(:TIRAGE_ID,:PRIZE_ID,:ROUND_NUM,:ROUND_NUM_EX,2)
       UNION
      SELECT TICKET_ID,3
        FROM /*PREFIX*/GET_TICKET_LINE(:TIRAGE_ID,:PRIZE_ID,:ROUND_NUM,:ROUND_NUM_EX,3)
       UNION
      SELECT TICKET_ID,4
        FROM /*PREFIX*/GET_TICKET_LINE(:TIRAGE_ID,:PRIZE_ID,:ROUND_NUM,:ROUND_NUM_EX,4)
        INTO :TICKET_ID, :LINE_NUM DO BEGIN

    SUSPEND;

  END

END;

--

/* �������� ��������� */

COMMIT