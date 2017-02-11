/* �������� ��������� ������� ������� */

CREATE PROCEDURE /*PREFIX*/CLEAR_TICKETS
(
  TIRAGE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/TICKET_PRIZES
        WHERE TICKET_ID IN (SELECT TICKET_ID
                              FROM /*PREFIX*/TICKETS
                             WHERE TIRAGE_ID=:TIRAGE_ID);

  DELETE FROM /*PREFIX*/TICKETS
        WHERE TIRAGE_ID=:TIRAGE_ID;
END;

--

/* �������� ��������� */

COMMIT