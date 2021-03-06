CREATE PROCEDURE GET_ACCOUNTS
(
  DATE_BEGIN TIMESTAMP,
  DATE_END TIMESTAMP
)
RETURNS
(
  ACCOUNT_ID VARCHAR(32),
  USER_NAME VARCHAR(100),
  DATE_CREATE TIMESTAMP
)
AS
  DECLARE D1 TIMESTAMP;
  DECLARE D2 TIMESTAMP;
BEGIN

  D1=DATE_BEGIN;
  IF (D1 IS NULL) THEN BEGIN
    SELECT MIN(DATE_CREATE)
      FROM ACCOUNTS
      INTO :D1;
  END

  D2=DATE_END;
  IF (D2 IS NULL) THEN BEGIN
    SELECT MAX(DATE_CREATE)
      FROM ACCOUNTS
      INTO :D2;
  END

  FOR SELECT ACCOUNT_ID, USER_NAME, DATE_CREATE
        FROM ACCOUNTS
       WHERE DATE_CREATE>=:D1
         AND DATE_CREATE<=:D2
       ORDER BY DATE_CREATE ASC
        INTO :ACCOUNT_ID, :USER_NAME, :DATE_CREATE DO BEGIN

    SUSPEND;
  END
END;
