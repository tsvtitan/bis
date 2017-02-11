/* ��������� ��������� �������� ������ */

CREATE OR ALTER PROCEDURE /*PREFIX*/D_TIRAGE
(
  OLD_TIRAGE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/WINNINGS
        WHERE LOTTERY_ID IN (SELECT LOTTERY_ID FROM /*PREFIX*/LOTTERY
                              WHERE TIRAGE_ID=:OLD_TIRAGE_ID);

  DELETE FROM /*PREFIX*/LOTTERY
        WHERE TIRAGE_ID=:OLD_TIRAGE_ID;

  DELETE FROM /*PREFIX*/SUBROUNDS
        WHERE TIRAGE_ID=:OLD_TIRAGE_ID;

  DELETE FROM /*PREFIX*/TICKETS
        WHERE TIRAGE_ID=:OLD_TIRAGE_ID;

  DELETE FROM /*PREFIX*/TIRAGES
        WHERE TIRAGE_ID=:OLD_TIRAGE_ID;

  EXECUTE PROCEDURE SET_STATISTICS;

END;

--

/* �������� ��������� */

COMMIT