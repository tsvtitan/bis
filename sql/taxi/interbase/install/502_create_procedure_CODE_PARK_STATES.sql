/* �������� ��������� ������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/CODE_PARK_STATES
(
  ACCOUNT_ID VARCHAR(32),
  IN_MESSAGE_ID VARCHAR(32)
)
AS
  DECLARE CONTACT VARCHAR(100);
  DECLARE SENDER_ID VARCHAR(32);
  DECLARE S VARCHAR(1000);
  DECLARE PARK_NAME VARCHAR(100);
  DECLARE SUM_CHARGE NUMERIC(15,2);
  DECLARE SUM_RECEIPT NUMERIC(15,2);
  DECLARE BALANCE NUMERIC(15,2);
  DECLARE MIN_BALANCE NUMERIC(15,2);
  DECLARE CNT INTEGER;
  DECLARE FLAG INTEGER;
BEGIN
  SELECT CONTACT, SENDER_ID
    FROM /*PREFIX*/IN_MESSAGES
   WHERE IN_MESSAGE_ID=:IN_MESSAGE_ID
    INTO :CONTACT, :SENDER_ID;

  IF ((CONTACT IS NOT NULL) AND (SENDER_ID IS NOT NULL)) THEN BEGIN

    SELECT COUNT(*)
      FROM /*PREFIX*/DRIVERS D
      JOIN /*PREFIX*/ ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID
     WHERE D.DRIVER_ID=:SENDER_ID
       AND A.LOCKED<>1
      INTO :CNT;

    IF (CNT>0) THEN BEGIN

      SELECT (CASE WHEN SUM(SUM_CHARGE) IS NULL THEN 0.0 ELSE SUM(SUM_CHARGE) END)
        FROM /*PREFIX*/CHARGES
       WHERE ACCOUNT_ID=:SENDER_ID
        INTO :SUM_CHARGE;

      SELECT (CASE WHEN SUM(SUM_RECEIPT) IS NULL THEN 0.0 ELSE SUM(SUM_RECEIPT) END)
        FROM /*PREFIX*/RECEIPTS
       WHERE ACCOUNT_ID=:SENDER_ID
        INTO :SUM_RECEIPT;

      BALANCE=SUM_RECEIPT-SUM_CHARGE;

      SELECT MIN_BALANCE
        FROM /*PREFIX*/DRIVERS
       WHERE DRIVER_ID=:SENDER_ID
        INTO :MIN_BALANCE;

      IF ((MIN_BALANCE IS NULL) OR ((MIN_BALANCE IS NOT NULL) AND (BALANCE>MIN_BALANCE))) THEN BEGIN

        S='';
        FLAG=0;

        FOR SELECT P.NAME,
                   (SELECT COUNT(*)
                      FROM /*PREFIX*/PARK_STATES PS
                     WHERE PS.DATE_OUT IS NULL
                       AND PS.PARK_ID=P.PARK_ID)
              FROM /*PREFIX*/PARKS P
             ORDER BY P.PRIORITY
              INTO :PARK_NAME, :CNT DO BEGIN

          IF (FLAG=0) THEN
            S=PARK_NAME||'-'||CAST(CNT AS VARCHAR(10));
          ELSE
            S=S||','||PARK_NAME||'-'||CAST(CNT AS VARCHAR(10));

          FLAG=1;
        END

        INSERT INTO /*PREFIX*/OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                            TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED)
                                    VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:SENDER_ID,CURRENT_TIMESTAMP,
                                            :S,NULL,0,:CONTACT,NULL,1,NULL);
      END

    END

  END
END

--

/* �������� ��������� */

COMMIT