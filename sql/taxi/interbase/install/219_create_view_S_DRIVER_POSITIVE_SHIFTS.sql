/* �������� ��������� ��������� �� ������ � ������������� �������� */

CREATE VIEW /*PREFIX*/S_DRIVER_POSITIVE_SHIFTS
AS
SELECT *
  FROM /*PREFIX*/S_DRIVER_SHIFTS
 WHERE (MIN_BALANCE IS NULL)
    OR (ACTUAL_BALANCE>MIN_BALANCE)

--

/* �������� ��������� */

COMMIT