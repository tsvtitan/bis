/* �������� ��������� �������� ����������� ���������� �� ����� */

CREATE PROCEDURE MAP_GET_ROUTE_DISTANCE
(
  LAT1 NUMERIC(17,13),
  LON1 NUMERIC(17,13),
  LAT2 NUMERIC(17,13),
  LON2 NUMERIC(17,13)
)
RETURNS
(
  DISTANCE NUMERIC(15,2)
)
AS
BEGIN
  DISTANCE=0.0;
END

--
