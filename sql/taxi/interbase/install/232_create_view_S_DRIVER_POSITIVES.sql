/* �������� ��������� ��������� � ������������� �������� */

CREATE VIEW /*PERFIX*/S_DRIVER_POSITIVES
AS
SELECT *
  FROM /*PREFIX*/S_DRIVERS
 WHERE (MIN_BALANCE IS NULL)
    OR (ACTUAL_BALANCE>MIN_BALANCE)

--

/* �������� ��������� */

COMMIT