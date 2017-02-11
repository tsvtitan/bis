/* �������� ��������� �������� ����� �������� */

CREATE PROCEDURE /*PREFIX*/D_DRIVER_SHIFT
(
  SHIFT_ID VARCHAR(32),
  DRIVER_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  DATE_END TIMESTAMP
)
AS
BEGIN
  UPDATE /*PREFIX*/SHIFTS
     SET DATE_END=:DATE_END
   WHERE ACCOUNT_ID=:DRIVER_ID
     AND SHIFT_ID=:SHIFT_ID;

  IF (PARK_ID IS NOT NULL) THEN BEGIN

    UPDATE /*PREFIX*/PARK_STATES
       SET DATE_OUT=CURRENT_TIMESTAMP
     WHERE DRIVER_ID=:DRIVER_ID
       AND PARK_ID=:PARK_ID;

  END

END;


--

/* �������� ��������� */

COMMIT