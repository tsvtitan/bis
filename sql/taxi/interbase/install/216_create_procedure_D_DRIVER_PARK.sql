/* �������� ��������� ������ �������� �� ������� */

CREATE PROCEDURE /*PREFIX*/D_DRIVER_PARK
(
  DRIVER_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  DATE_OUT TIMESTAMP
)
AS
BEGIN
  UPDATE /*PREFIX*/PARK_STATES
     SET DATE_OUT=:DATE_OUT
   WHERE DRIVER_ID=:DRIVER_ID
     AND PARK_ID=:PARK_ID;
END;

--

/* �������� ��������� */

COMMIT