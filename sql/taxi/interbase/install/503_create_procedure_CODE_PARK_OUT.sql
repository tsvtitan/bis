/* �������� ��������� ������ �� ������� */

CREATE PROCEDURE /*PREFIX*/CODE_PARK_OUT
(
  ACCOUNT_ID VARCHAR(32),
  IN_MESSAGE_ID VARCHAR(32)
)
AS
  DECLARE CONTACT VARCHAR(100);
  DECLARE SENDER_ID VARCHAR(32);
  DECLARE S VARCHAR(1000);
  DECLARE PARK_NAME VARCHAR(100);
  DECLARE PARK_STATE_ID VARCHAR(32);
  DECLARE CNT INTEGER;
  DECLARE D TIMESTAMP;
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


      SELECT COUNT(*)
        FROM /*PREFIX*/ORDERS
       WHERE DRIVER_ID=:SENDER_ID
         AND PARENT_ID IS NULL
         AND DATE_HISTORY IS NULL
         AND FINISHED<>1
        INTO :CNT;

      IF (CNT>0) THEN BEGIN

        S='�� �� ������ ������� �� ������� �� ����� ���������� ������';

        INSERT INTO /*PREFIX*/OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                            TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED)
                                     VALUES (/*PREFIX*/GET_UNIQUE_ID(),:ACCOUNT_ID,:SENDER_ID,CURRENT_TIMESTAMP,
                                             :S,NULL,0,:CONTACT,NULL,1,NULL);

      END ELSE BEGIN

        FOR SELECT P.NAME, PS.PARK_STATE_ID
              FROM /*PREFIX*/PARK_STATES PS
              JOIN /*PREFIX*/PARKS P ON P.PARK_ID=PS.PARK_ID
             WHERE PS.DRIVER_ID=:SENDER_ID
               AND PS.DATE_OUT IS NULL
              INTO :PARK_NAME, :PARK_STATE_ID DO BEGIN

          D=CURRENT_TIMESTAMP;
          S='�� ����� �� ������� '||PARK_NAME||' � '||/*PERFIX*/FORMAT_DATETIME('hh:nn:ss dd.mm.yyyy',D);

          UPDATE /*PREFIX*/PARK_STATES
             SET DATE_OUT=:D
           WHERE PARK_STATE_ID=:PARK_STATE_ID;

          INSERT INTO /*PREFIX*/OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                              TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED)
                                      VALUES (/*PREFIX*/GET_UNIQUE_ID(),:ACCOUNT_ID,:SENDER_ID,CURRENT_TIMESTAMP,
                                              :S,NULL,0,:CONTACT,NULL,1,NULL);
        END

      END

    END

  END
END

--

/* �������� ��������� */

COMMIT