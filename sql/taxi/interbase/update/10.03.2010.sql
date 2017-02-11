CREATE INDEX IDX_IN_MESSAGES_DATE_IN
ON IN_MESSAGES (DATE_IN)

--

DROP VIEW S_DRIVER_PARKS

--

CREATE VIEW S_DRIVER_PARKS
(
    PARK_STATE_ID,
    DRIVER_ID,
    PARK_ID,
    DATE_IN,
    DATE_OUT,
    DRIVER_NAME,
    DRIVER_PHONE,
    CAR_ID,
    MIN_BALANCE,
    PRIORITY,
    CAR_COLOR,
    CAR_BRAND,
    CAR_STATE_NUM,
    CAR_CALLSIGN,
    CAR_TYPE_ID,
    CAR_TYPE_NAME,
    CAR_TYPE_FONT_COLOR,
    CAR_TYPE_BRUSH_COLOR,
    PARK_NAME)
AS
SELECT PS.*,
       A.USER_NAME AS DRIVER_NAME,
       A.PHONE AS DRIVER_PHONE,
       D.CAR_ID,
       D.MIN_BALANCE,
       D.PRIORITY,
       C.COLOR AS CAR_COLOR,
       C.BRAND AS CAR_BRAND,
       C.STATE_NUM AS CAR_STATE_NUM,
       C.CALLSIGN AS CAR_CALLSIGN,
       C.CAR_TYPE_ID,
       CT.NAME AS CAR_TYPE_NAME,
       CT.FONT_COLOR AS CAR_TYPE_FONT_COLOR,
       CT.BRUSH_COLOR AS CAR_TYPE_BRUSH_COLOR,
       P.NAME AS PARK_NAME
  FROM PARK_STATES PS
  JOIN PARKS P ON P.PARK_ID=PS.PARK_ID
  JOIN ACCOUNTS A ON A.ACCOUNT_ID=PS.DRIVER_ID
  JOIN DRIVERS D ON D.DRIVER_ID=PS.DRIVER_ID
  JOIN CARS C ON C.CAR_ID=D.CAR_ID
  JOIN CAR_TYPES CT ON CT.CAR_TYPE_ID=C.CAR_TYPE_ID

--

/* �������� ������� ������������ �������� �������� */

CREATE TABLE /*PREFIX*/DRIVER_WEEK_SCHEDULES
(
  DRIVER_ID VARCHAR(32) NOT NULL,
  WEEK_DAY INTEGER NOT NULL,
  DAY_HOUR INTEGER NOT NULL,
  PRIMARY KEY (DRIVER_ID,WEEK_DAY,DAY_HOUR),
  FOREIGN KEY (DRIVER_ID) REFERENCES /*PREFIX*/DRIVERS (DRIVER_ID)
)

--

/* �������� ��������� ������������ �������� �������� */

CREATE VIEW /*PREFIX*/S_DRIVER_WEEK_SCHEDULES
(
  DRIVER_ID,
  WEEK_DAY,
  DAY_HOUR,
  DRIVER_NAME,
  DRIVER_PHONE
)
AS
SELECT DS.*,
       A.USER_NAME AS DRIVER_NAME,
       A.PHONE AS DRIVER_PHONE
  FROM /*PREFIX*/DRIVER_WEEK_SCHEDULES DS
  JOIN /*PREFIX*/DRIVERS D ON D.DRIVER_ID=DS.DRIVER_ID
  JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID

--

/* �������� ��������� ���������� ������������� ������� �������� */

CREATE OR ALTER PROCEDURE /*PREFIX*/I_DRIVER_WEEK_SCHEDULE
(
  DRIVER_ID VARCHAR(32),
  WEEK_DAY INTEGER,
  DAY_HOUR INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/DRIVER_WEEK_SCHEDULES (DRIVER_ID,WEEK_DAY,DAY_HOUR)
                                  VALUES (:DRIVER_ID,:WEEK_DAY,:DAY_HOUR);
END;

--

/* �������� ��������� ��������� ������������� ������� �������� */

CREATE OR ALTER PROCEDURE /*PREFIX*/U_DRIVER_WEEK_SCHEDULE
(
  DRIVER_ID VARCHAR(32),
  WEEK_DAY INTEGER,
  DAY_HOUR INTEGER,
  OLD_DRIVER_ID VARCHAR(32),
  OLD_WEEK_DAY INTEGER,
  OLD_DAY_HOUR INTEGER
)
AS
BEGIN
  UPDATE /*PREFIX*/DRIVER_WEEK_SCHEDULES
     SET DRIVER_ID=:DRIVER_ID,
         WEEK_DAY=:WEEK_DAY,
         DAY_HOUR=:DAY_HOUR
   WHERE DRIVER_ID=:OLD_DRIVER_ID
     AND WEEK_DAY=:OLD_WEEK_DAY
     AND DAY_HOUR=:OLD_DAY_HOUR;
END;

--

/* �������� ��������� �������� ������������� ������� �������� */

CREATE OR ALTER PROCEDURE /*PREFIX*/D_DRIVER_WEEK_SCHEDULE
(
  OLD_DRIVER_ID VARCHAR(32),
  OLD_WEEK_DAY INTEGER,
  OLD_DAY_HOUR INTEGER
)
AS
BEGIN
  DELETE FROM /*PREFIX*/DRIVER_WEEK_SCHEDULES 
        WHERE DRIVER_ID=:OLD_DRIVER_ID
          AND WEEK_DAY=:OLD_WEEK_DAY
          AND DAY_HOUR=:OLD_DAY_HOUR;
END;

--

CREATE OR ALTER PROCEDURE GET_DRIVER_WEEK_SHCHEDULES
RETURNS
(
  WEEK_DAY INTEGER,
  DAY_HOUR INTEGER,
  DRIVER_COUNT INTEGER
)
AS
BEGIN
  FOR SELECT WEEK_DAY,
             DAY_HOUR,
             COUNT(*)
        FROM DRIVER_WEEK_SCHEDULES
       GROUP BY WEEK_DAY, DAY_HOUR
       ORDER BY WEEK_DAY, DAY_HOUR
        INTO :WEEK_DAY, :DAY_HOUR, :DRIVER_COUNT DO BEGIN
    SUSPEND;
  END
END

--

DROP VIEW S_CLIENT_PHONES

--

CREATE VIEW S_CLIENT_PHONES
(
    CLIENT_ID,
    PHONE,
    METHOD_ID,
    DESCRIPTION,
    LOCALITY_ID,
    STREET_ID,
    HOUSE,
    FLAT,
    PORCH,
    ADDRESS_DESC,
    USER_NAME,
    SURNAME,
    NAME,
    PATRONYMIC,
    LOCKED,
    FIRM_SMALL_NAME,
    METHOD_NAME,
    STREET_NAME,
    STREET_PREFIX,
    LOCALITY_NAME,
    LOCALITY_PREFIX)
AS
SELECT CP.*,
       S1.LOCALITY_ID,
       C.STREET_ID,
       C.HOUSE,
       C.FLAT,
       C.PORCH,
       C.ADDRESS_DESC,
       A.USER_NAME,
       A.SURNAME,
       A.NAME,
       A.PATRONYMIC,
       A.LOCKED,
       F.SMALL_NAME AS FIRM_SMALL_NAME,
       M.NAME AS METHOD_NAME,
       S1.NAME AS STREET_NAME,
       S1.PREFIX AS STREET_PREFIX,
       L1.NAME AS LOCALITY_NAME,
       L1.PREFIX AS LOCALITY_PREFIX
  FROM CLIENT_PHONES CP
  JOIN CLIENTS C ON C.CLIENT_ID=CP.CLIENT_ID
  JOIN ACCOUNTS A ON A.ACCOUNT_ID=C.CLIENT_ID
  LEFT JOIN FIRMS F ON F.FIRM_ID=A.FIRM_ID
  LEFT JOIN METHODS M ON M.METHOD_ID=CP.METHOD_ID
  LEFT JOIN STREETS S1 ON S1.STREET_ID=C.STREET_ID
  LEFT JOIN LOCALITIES L1 ON L1.LOCALITY_ID=S1.LOCALITY_ID

--

/* ��������� */

D98222D30163A3FE4B647ABF4A2C179F
C83CCF38CF6CAB374FAB6FA49754B07F
7032584355F3A3C44394DAA17D8A9BA9
C0B2DFF0FD07BC1C43047D31AECDC8A2
4BB5C780923E872D436DA3DA31C9E0B0
C34718E32AF1B4264975480EE24B7A8D
015792E550DCA1544E8E5F0773FEBA3D
AF2D42CDBD398AFC4E0A988E3C57EF84
FDBF450952CB8E8A40A38BD5122034B3

--

CREATE OR ALTER PROCEDURE I_DRIVER_SHIFT
(
  SHIFT_ID VARCHAR(32),
  DRIVER_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  DATE_BEGIN TIMESTAMP,
  ACCOUNT_ID VARCHAR(32)
)
AS
DECLARE SUM_CHARGE NUMERIC(15,2);
DECLARE SUM_RECEIPT NUMERIC(15,2);
DECLARE BALANCE NUMERIC(15,2);
DECLARE MIN_BALANCE NUMERIC(15,2);
DECLARE PARK_NAME VARCHAR(100);
DECLARE PARK_DESCRIPTION VARCHAR(250);
DECLARE PRIORITY INTEGER;
DECLARE S VARCHAR(1000);
DECLARE CONTACT VARCHAR(100);
BEGIN

  EXECUTE PROCEDURE GET_ACCOUNT_BALANCE(:DRIVER_ID)
   RETURNING_VALUES :SUM_CHARGE, :SUM_RECEIPT, :BALANCE;

  SELECT MIN_BALANCE
    FROM DRIVERS
   WHERE DRIVER_ID=:DRIVER_ID
    INTO :MIN_BALANCE;

  IF ((MIN_BALANCE IS NULL) OR ((MIN_BALANCE IS NOT NULL) AND (BALANCE>MIN_BALANCE))) THEN BEGIN

    INSERT INTO /*PREFIX*/SHIFTS (SHIFT_ID,ACCOUNT_ID,DATE_BEGIN)
         VALUES (:SHIFT_ID,:DRIVER_ID,:DATE_BEGIN);

    SELECT PHONE
      FROM ACCOUNTS
     WHERE ACCOUNT_ID=:DRIVER_ID
      INTO :CONTACT;

    IF (PARK_ID IS NOT NULL) THEN BEGIN

      UPDATE /*PREFIX*/PARK_STATES
         SET DATE_OUT=:DATE_BEGIN
       WHERE DRIVER_ID=:DRIVER_ID
         AND DATE_OUT IS NULL;

      INSERT INTO /*PREFIX*/PARK_STATES(PARK_STATE_ID,DRIVER_ID,PARK_ID,DATE_IN)
           VALUES (/*PREFIX*/GET_UNIQUE_ID(),:DRIVER_ID,:PARK_ID,CURRENT_TIMESTAMP);

      SELECT COUNT(*)
        FROM PARK_STATES
       WHERE PARK_ID=:PARK_ID
         AND DATE_OUT IS NULL
        INTO PRIORITY;

      SELECT CONST_VALUE FROM GET_CONST_VALUE('D98222D30163A3FE4B647ABF4A2C179F') INTO :S;

      IF (S IS NOT NULL) THEN BEGIN

        SELECT NAME, DESCRIPTION
          FROM PARKS
         WHERE PARK_ID=:PARK_ID
          INTO :PARK_NAME, :PARK_DESCRIPTION;

        S=REPLACE_STRING(S,'%PRIORITY',CAST(PRIORITY AS VARCHAR(10)));
        S=REPLACE_STRING(S,'%PARK_NAME',PARK_NAME);
        S=REPLACE_STRING(S,'%PARK_DESCRIPTION',PARK_DESCRIPTION);
        S=REPLACE_STRING(S,'%BALANCE',CAST(BALANCE AS VARCHAR(30)));

        INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                  TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                          VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                                  :S,NULL,0,:CONTACT,NULL,1,NULL,CURRENT_TIMESTAMP);
      END

    END ELSE BEGIN

      SELECT CONST_VALUE FROM GET_CONST_VALUE('C83CCF38CF6CAB374FAB6FA49754B07F') INTO :S;

      IF (S IS NOT NULL) THEN BEGIN

        S=REPLACE_STRING(S,'%BALANCE',CAST(BALANCE AS VARCHAR(30)));

        INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                  TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                          VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                                  :S,NULL,0,:CONTACT,NULL,1,NULL,CURRENT_TIMESTAMP);

      END

    END
  END

END

--

CREATE OR ALTER PROCEDURE D_DRIVER_SHIFT (
  SHIFT_ID VARCHAR(32),
  DRIVER_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  DATE_END TIMESTAMP,
  ACCOUNT_ID VARCHAR(32),
  LOCKED INTEGER)
AS
DECLARE S VARCHAR(1000);
DECLARE CONTACT VARCHAR(100);
DECLARE HOURS NUMERIC(10,1);
DECLARE D TIMESTAMP;
DECLARE DATE_BEGIN TIMESTAMP;
BEGIN

  SELECT PHONE
    FROM ACCOUNTS
   WHERE ACCOUNT_ID=:DRIVER_ID
    INTO :CONTACT;

  UPDATE /*PREFIX*/ACCOUNTS
     SET LOCKED=:LOCKED
   WHERE ACCOUNT_ID=:DRIVER_ID;

  UPDATE /*PREFIX*/SHIFTS
     SET DATE_END=:DATE_END
   WHERE ACCOUNT_ID=:DRIVER_ID
     AND SHIFT_ID=:SHIFT_ID;

  IF (PARK_ID IS NOT NULL) THEN BEGIN

    UPDATE /*PREFIX*/PARK_STATES
       SET DATE_OUT=:DATE_END
     WHERE DRIVER_ID=:DRIVER_ID
       AND PARK_ID=:PARK_ID
       AND DATE_OUT IS NULL;

  END ELSE BEGIN

    UPDATE /*PREFIX*/PARK_STATES
       SET DATE_OUT=:DATE_END
     WHERE DRIVER_ID=:DRIVER_ID
       AND DATE_OUT IS NULL;

  END

  SELECT DATE_BEGIN
    FROM SHIFTS
   WHERE SHIFT_ID=:SHIFT_ID
    INTO :DATE_BEGIN;

  D=CURRENT_TIMESTAMP;

  HOURS=CAST((D-DATE_BEGIN)*(1e0*24) AS NUMERIC(10,1));

  SELECT CONST_VALUE FROM GET_CONST_VALUE('7032584355F3A3C44394DAA17D8A9BA9') INTO :S;

  IF (S IS NOT NULL) THEN BEGIN

    S=REPLACE_STRING(S,'%TIME_DATE',FORMAT_DATETIME('hh:nn:ss dd.mm.yyyy',D));
    S=REPLACE_STRING(S,'%HOURS',CAST(HOURS AS VARCHAR(30)));

    INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                              TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                      VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                              :S,NULL,0,:CONTACT,NULL,1,NULL,CURRENT_TIMESTAMP);
  END

END

--

CREATE OR ALTER PROCEDURE I_DRIVER_PARK (
  DRIVER_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32),
  DATE_IN TIMESTAMP)
AS
DECLARE SUM_CHARGE NUMERIC(15,2);
DECLARE SUM_RECEIPT NUMERIC(15,2);
DECLARE BALANCE NUMERIC(15,2);
DECLARE MIN_BALANCE NUMERIC(15,2);
DECLARE CONTACT VARCHAR(100);
DECLARE PARK_NAME VARCHAR(100);
DECLARE PARK_DESCRIPTION VARCHAR(250);
DECLARE PRIORITY INTEGER;
DECLARE S VARCHAR(1000);
BEGIN
  EXECUTE PROCEDURE GET_ACCOUNT_BALANCE(:DRIVER_ID)
   RETURNING_VALUES :SUM_CHARGE, :SUM_RECEIPT, :BALANCE;

  SELECT MIN_BALANCE
    FROM DRIVERS
   WHERE DRIVER_ID=:DRIVER_ID
    INTO :MIN_BALANCE;

  IF ((MIN_BALANCE IS NULL) OR ((MIN_BALANCE IS NOT NULL) AND (BALANCE>MIN_BALANCE))) THEN BEGIN

    SELECT PHONE
      FROM ACCOUNTS
     WHERE ACCOUNT_ID=:DRIVER_ID
      INTO :CONTACT;

    INSERT INTO /*PREFIX*/PARK_STATES(PARK_STATE_ID,DRIVER_ID,PARK_ID,DATE_IN)
         VALUES (/*PREFIX*/GET_UNIQUE_ID(),:DRIVER_ID,:PARK_ID,:DATE_IN);

    SELECT COUNT(*)
      FROM PARK_STATES
     WHERE PARK_ID=:PARK_ID
       AND DATE_OUT IS NULL
      INTO PRIORITY;

    SELECT CONST_VALUE FROM GET_CONST_VALUE('D98222D30163A3FE4B647ABF4A2C179F') INTO :S;

    IF (S IS NOT NULL) THEN BEGIN

      SELECT NAME, DESCRIPTION
        FROM PARKS
       WHERE PARK_ID=:PARK_ID
        INTO :PARK_NAME, :PARK_DESCRIPTION;

      S=REPLACE_STRING(S,'%PRIORITY',CAST(PRIORITY AS VARCHAR(10)));
      S=REPLACE_STRING(S,'%PARK_NAME',PARK_NAME);
      S=REPLACE_STRING(S,'%PARK_DESCRIPTION',PARK_DESCRIPTION);
      S=REPLACE_STRING(S,'%BALANCE',CAST(BALANCE AS VARCHAR(30)));

      INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                        VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                                :S,NULL,0,:CONTACT,NULL,1,NULL,CURRENT_TIMESTAMP);
    END

  END
END

--

CREATE OR ALTER PROCEDURE D_DRIVER_PARK (
  DRIVER_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32),
  DATE_OUT TIMESTAMP)
AS
DECLARE S VARCHAR(1000);
DECLARE PARK_NAME VARCHAR(100);
DECLARE CONTACT VARCHAR(100);
BEGIN
  UPDATE /*PREFIX*/PARK_STATES
     SET DATE_OUT=:DATE_OUT
   WHERE DRIVER_ID=:DRIVER_ID
     AND PARK_ID=:PARK_ID
     AND DATE_OUT IS NULL;

  SELECT PHONE
    FROM ACCOUNTS
   WHERE ACCOUNT_ID=:DRIVER_ID
    INTO :CONTACT;

  SELECT CONST_VALUE FROM GET_CONST_VALUE('C0B2DFF0FD07BC1C43047D31AECDC8A2') INTO :S;

  IF (S IS NOT NULL) THEN BEGIN

    SELECT NAME
      FROM PARKS
     WHERE PARK_ID=:PARK_ID
      INTO :PARK_NAME;

    S=REPLACE_STRING(S,'%PARK_NAME',PARK_NAME);
    S=REPLACE_STRING(S,'%TIME_DATE',FORMAT_DATETIME('hh:nn:ss dd.mm.yyyy',DATE_OUT));

    INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                              TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                      VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                              :S,NULL,0,:CONTACT,NULL,1,NULL,CURRENT_TIMESTAMP);
  END

END

--

CREATE OR ALTER PROCEDURE PR_FULL_CALC (
  ORDER_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32))
AS
DECLARE COST_RATE NUMERIC(15,2);
DECLARE COST_FACT NUMERIC(15,2);
DECLARE PHONE VARCHAR(100);
DECLARE DRIVER_ID VARCHAR(32);
DECLARE RECIPIENT_ID VARCHAR(32);
DECLARE SUM_CHARGE NUMERIC(15,2);
DECLARE SUM_RECEIPT NUMERIC(15,2);
DECLARE BALANCE NUMERIC(15,2);
DECLARE MIN_BALANCE NUMERIC(15,2);
DECLARE CHARGE_TYPE_ID VARCHAR(32);
DECLARE S VARCHAR(1000);
BEGIN

  SELECT PHONE, DRIVER_ID, COST_RATE, COST_FACT
    FROM ORDERS
   WHERE ORDER_ID=:ORDER_ID
    INTO :PHONE, :DRIVER_ID, :COST_RATE, :COST_FACT;

  IF ((COST_FACT IS NULL) OR (COST_FACT<=0.0))  THEN
    COST_FACT=:COST_RATE;

  IF (COST_FACT<=0.0) THEN BEGIN

    SELECT CONST_VALUE FROM GET_CONST_VALUE('4BB5C780923E872D436DA3DA31C9E0B0') INTO :S;

    IF (S IS NOT NULL) THEN BEGIN

      SELECT PHONE
        FROM ACCOUNTS
       WHERE ACCOUNT_ID=:DRIVER_ID
        INTO :PHONE;

      INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                        VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                                :S,NULL,0,:PHONE,NULL,2,NULL,CURRENT_TIMESTAMP);
    END

    EXECUTE PROCEDURE PR_MANUAL(ORDER_ID,ACCOUNT_ID);

  END ELSE BEGIN

    UPDATE ORDERS
       SET FINISHED=1,
           DATE_END=CURRENT_TIMESTAMP,
           WHO_PROCESS_ID=:ACCOUNT_ID,
           COST_FACT=:COST_FACT
     WHERE ORDER_ID=:ORDER_ID;

    IF (DRIVER_ID IS NOT NULL) THEN BEGIN

      IF (PHONE IS NOT NULL) THEN BEGIN

        IF (SUBSTR(PHONE,1,3)='+79')  THEN BEGIN

          RECIPIENT_ID=NULL;

          FOR SELECT ACCOUNT_ID
                FROM ACCOUNTS
               WHERE PHONE=:PHONE
                INTO :RECIPIENT_ID DO BEGIN

            IF (RECIPIENT_ID IS NOT NULL) THEN
              BREAK;
          END

          SELECT CONST_VALUE FROM GET_CONST_VALUE('05B75340B170BF5141FC63F5CDF7FCD6') INTO :S;

          IF (S IS NOT NULL) THEN BEGIN

            INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                      TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                              VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                      :S,NULL,0,:PHONE,NULL,2,NULL,CURRENT_TIMESTAMP);
          END

          SELECT CONST_VALUE FROM GET_CONST_VALUE('E9FFA9589ABD8C174474572B72017BCC') INTO :S;

          IF (S IS NOT NULL) THEN BEGIN

            INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                      TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                              VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                      :S,NULL,0,:PHONE,NULL,2,NULL,CURRENT_TIMESTAMP);
          END

        END

      END

      CHARGE_TYPE_ID='E1BC9789DA9DB2B041C0784EBE92BFC9'; /* ���������� ������ */

      SELECT RET_SUM
        FROM GET_DRIVER_SUM(:DRIVER_ID,:COST_FACT)
        INTO :SUM_CHARGE;

      INSERT INTO CHARGES (CHARGE_ID,WHO_CREATE_ID,CHARGE_TYPE_ID,ACCOUNT_ID,
                           SUM_CHARGE,DATE_CHARGE,DATE_CREATE,DESCRIPTION)
                   VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:CHARGE_TYPE_ID,:DRIVER_ID,
                           :SUM_CHARGE,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,NULL);

      EXECUTE PROCEDURE GET_ACCOUNT_BALANCE(:DRIVER_ID)
       RETURNING_VALUES :SUM_CHARGE, :SUM_RECEIPT, :BALANCE;

      SELECT MIN_BALANCE
        FROM DRIVERS
       WHERE DRIVER_ID=:DRIVER_ID
        INTO :MIN_BALANCE;

      IF ((MIN_BALANCE IS NULL) OR ((MIN_BALANCE IS NOT NULL) AND (BALANCE>MIN_BALANCE))) THEN BEGIN

        SELECT CONST_VALUE FROM GET_CONST_VALUE('16835607B30CA79F4CE883B53AFE972D') INTO :S;

      END ELSE BEGIN

        UPDATE SHIFTS
           SET DATE_END=CURRENT_TIMESTAMP
         WHERE ACCOUNT_ID=:DRIVER_ID
           AND DATE_END IS NULL;

        SELECT CONST_VALUE FROM GET_CONST_VALUE('634880F305E9AA434245E3E596697001') INTO :S;

      END

      SELECT PHONE
        FROM ACCOUNTS
       WHERE ACCOUNT_ID=:DRIVER_ID
        INTO :PHONE;

      IF (S IS NOT NULL) THEN BEGIN

        S=REPLACE_STRING(S,'%BALANCE',CAST(BALANCE AS VARCHAR(30)));

        INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                  TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                          VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                                  :S,NULL,0,:PHONE,NULL,2,NULL,CURRENT_TIMESTAMP);
      END

      EXECUTE PROCEDURE QUERY_PARK_STATES (ACCOUNT_ID,DRIVER_ID,PHONE);

    END
  END
END

--

CREATE OR ALTER PROCEDURE CODE_FREE_ORDERS (
  ACCOUNT_ID VARCHAR(32),
  IN_MESSAGE_ID VARCHAR(32))
AS
DECLARE CONTACT VARCHAR(100);
DECLARE SENDER_ID VARCHAR(32);
DECLARE ZONE_ID VARCHAR(32);
DECLARE S VARCHAR(1000);
DECLARE S1 VARCHAR(1000);
DECLARE F VARCHAR(1000);
DECLARE PARK_ID VARCHAR(32);
DECLARE PARK_NAME VARCHAR(100);
DECLARE SUM_CHARGE NUMERIC(15,2);
DECLARE SUM_RECEIPT NUMERIC(15,2);
DECLARE BALANCE NUMERIC(15,2);
DECLARE MIN_BALANCE NUMERIC(15,2);
DECLARE DRIVER_COUNT INTEGER;
DECLARE ORDER_COUNT INTEGER;
BEGIN
  SELECT CONTACT, SENDER_ID
    FROM IN_MESSAGES
   WHERE IN_MESSAGE_ID=:IN_MESSAGE_ID
    INTO :CONTACT, :SENDER_ID;

  IF ((CONTACT IS NOT NULL) AND (SENDER_ID IS NOT NULL)) THEN BEGIN

    SELECT COUNT(*)
      FROM DRIVERS D
      JOIN  ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID
     WHERE D.DRIVER_ID=:SENDER_ID
       AND A.LOCKED<>1
      INTO :DRIVER_COUNT;

    IF (DRIVER_COUNT>0) THEN BEGIN

      EXECUTE PROCEDURE GET_ACCOUNT_BALANCE(:SENDER_ID)
       RETURNING_VALUES :SUM_CHARGE, :SUM_RECEIPT, :BALANCE;

      SELECT MIN_BALANCE
        FROM DRIVERS
       WHERE DRIVER_ID=:SENDER_ID
        INTO :MIN_BALANCE;

      IF ((MIN_BALANCE IS NULL) OR ((MIN_BALANCE IS NOT NULL) AND (BALANCE>MIN_BALANCE))) THEN BEGIN
 
        S='';

        SELECT CONST_VALUE FROM GET_CONST_VALUE('C34718E32AF1B4264975480EE24B7A8D') INTO :F;

        IF (F IS NOT NULL) THEN BEGIN

          FOR SELECT ZONE_ID
                FROM ZONES
               ORDER BY PRIORITY
                INTO :ZONE_ID DO BEGIN

            PARK_NAME=NULL;

            FOR SELECT ZP.PARK_ID, P.NAME
                  FROM ZONE_PARKS ZP
                  JOIN PARKS P ON P.PARK_ID=ZP.PARK_ID
                 WHERE ZP.ZONE_ID=:ZONE_ID
                 ORDER BY ZP.DISTANCE, ZP.PERIOD
                  INTO :PARK_ID, :PARK_NAME DO BEGIN
              BREAK;
            END

            IF (PARK_ID IS NOT NULL) THEN BEGIN

              SELECT COUNT(*)
               FROM PARK_STATES
              WHERE DATE_OUT IS NULL
                AND PARK_ID=:PARK_ID
               INTO :DRIVER_COUNT;

              IF (PARK_NAME IS NOT NULL) THEN BEGIN

                SELECT COUNT(*)
                  FROM ORDERS
                 WHERE ZONE_ID=:ZONE_ID
                   AND PARENT_ID IS NULL
                   AND FINISHED=0
                   AND CURRENT_TIMESTAMP>=(DATE_ARRIVAL-(BEFORE_PERIOD*(1e0/24/60)))
                   AND DRIVER_ID IS NULL
                  INTO :ORDER_COUNT;

                IF (ORDER_COUNT>DRIVER_COUNT) THEN BEGIN

                  ORDER_COUNT=ORDER_COUNT-DRIVER_COUNT;

                  S1=F;
                  S1=REPLACE_STRING(S1,'%PARK_NAME',PARK_NAME);
                  S1=REPLACE_STRING(S1,'%COUNT',CAST(ORDER_COUNT AS VARCHAR(10)));

                  S=S||S1;
                END

              END

            END

          END

          IF (S='') THEN BEGIN

            S=NULL;

            SELECT CONST_VALUE FROM GET_CONST_VALUE('015792E550DCA1544E8E5F0773FEBA3D') INTO :S;

          END

          IF ((S IS NOT NULL) AND (S<>'')) THEN BEGIN

            INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                      TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                              VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:SENDER_ID,CURRENT_TIMESTAMP,
                                      :S,NULL,0,:CONTACT,NULL,1,NULL,CURRENT_TIMESTAMP);
          END


        END

      END

    END

  END
END

--

CREATE OR ALTER PROCEDURE TASK_HAPPY_BIRTHDAY (
  TASK_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32))
AS
DECLARE RECIPIENT_ID VARCHAR(32);
DECLARE PHONE VARCHAR(100);
DECLARE NAME VARCHAR(100);
DECLARE PATRONYMIC VARCHAR(100);
DECLARE S VARCHAR(1000);
DECLARE S1 VARCHAR(1000);
DECLARE D TIMESTAMP;
DECLARE CURRENT_DAY INTEGER;
DECLARE CURRENT_MONTH INTEGER;
BEGIN

  SELECT CONST_VALUE FROM GET_CONST_VALUE('AF2D42CDBD398AFC4E0A988E3C57EF84') INTO :S;

  IF (S IS NOT NULL) THEN BEGIN

    D=CURRENT_TIMESTAMP;

    CURRENT_DAY=EXTRACT(DAY FROM D);
    CURRENT_MONTH=EXTRACT(MONTH FROM D);

    FOR SELECT A.ACCOUNT_ID, A.PHONE, A.NAME, A.PATRONYMIC
          FROM DISPATCHERS D
          JOIN ACCOUNTS A ON A.ACCOUNT_ID=D.DISPATCHER_ID
         WHERE A.LOCKED<>1
           AND EXTRACT(DAY FROM D.DATE_BIRTH)=:CURRENT_DAY
           AND EXTRACT(MONTH FROM D.DATE_BIRTH)=:CURRENT_MONTH
          INTO :RECIPIENT_ID, :PHONE, :NAME, :PATRONYMIC DO BEGIN

      S1=S;
      S1=REPLACE_STRING(S1,'%NAME',NAME);
      S1=REPLACE_STRING(S1,'%PATRONYMIC',PATRONYMIC);

      INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                        VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                :S1,NULL,0,:PHONE,NULL,2,NULL,:D);

      D=CURRENT_TIMESTAMP+5*(1e0/24/60/60);
    END

    FOR SELECT A.ACCOUNT_ID, A.PHONE, A.NAME, A.PATRONYMIC
          FROM DRIVERS D
          JOIN ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID
         WHERE A.LOCKED<>1
           AND EXTRACT(DAY FROM D.DATE_BIRTH)=:CURRENT_DAY
           AND EXTRACT(MONTH FROM D.DATE_BIRTH)=:CURRENT_MONTH
          INTO :RECIPIENT_ID, :PHONE, :NAME, :PATRONYMIC DO BEGIN

      S1=S;
      S1=REPLACE_STRING(S1,'%NAME',NAME);
      S1=REPLACE_STRING(S1,'%PATRONYMIC',PATRONYMIC);

      INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                        VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                :S1,NULL,0,:PHONE,NULL,2,NULL,:D);

      D=CURRENT_TIMESTAMP+5*(1e0/24/60/60);
    END

    FOR SELECT A.ACCOUNT_ID, A.PHONE, A.NAME, A.PATRONYMIC
          FROM CLIENTS C
          JOIN ACCOUNTS A ON A.ACCOUNT_ID=C.CLIENT_ID
         WHERE A.LOCKED<>1
           AND EXTRACT(DAY FROM C.DATE_BIRTH)=:CURRENT_DAY
           AND EXTRACT(MONTH FROM C.DATE_BIRTH)=:CURRENT_MONTH
          INTO :RECIPIENT_ID, :PHONE, :NAME, :PATRONYMIC DO BEGIN

      S1=S;
      S1=REPLACE_STRING(S1,'%NAME',NAME);
      S1=REPLACE_STRING(S1,'%PATRONYMIC',PATRONYMIC);

      INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                        VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                :S1,NULL,0,:PHONE,NULL,2,NULL,:D);

      D=CURRENT_TIMESTAMP+5*(1e0/24/60/60);
    END

  END

END

--

CREATE OR ALTER PROCEDURE TASK_SHIFT_REMINDER (
  TASK_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32))
AS
DECLARE DRIVER_ID VARCHAR(32);
DECLARE PHONE VARCHAR(100);
DECLARE NAME VARCHAR(100);
DECLARE PATRONYMIC VARCHAR(100);
DECLARE S VARCHAR(1000);
DECLARE S1 VARCHAR(1000);
DECLARE D TIMESTAMP;
DECLARE DTIME TIMESTAMP;
DECLARE DAY_HOUR INTEGER;
DECLARE WEEK_DAY INTEGER;
DECLARE CNT INTEGER;
BEGIN

  SELECT CONST_VALUE FROM GET_CONST_VALUE('FDBF450952CB8E8A40A38BD5122034B3') INTO :S;

  IF (S IS NOT NULL) THEN BEGIN

    D=CURRENT_TIMESTAMP;

    FOR SELECT D.DRIVER_ID, A.PHONE, A.NAME, A.PATRONYMIC
          FROM DRIVERS D
          JOIN ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID
         WHERE A.LOCKED<>1
          INTO :DRIVER_ID, :PHONE, :NAME, :PATRONYMIC DO BEGIN

      WEEK_DAY=EXTRACT(WEEKDAY FROM D)-1;
      IF (WEEK_DAY<0) THEN
        WEEK_DAY=6;

      DAY_HOUR=EXTRACT(HOUR FROM D)+1;
      IF (DAY_HOUR>23) THEN BEGIN
        DAY_HOUR=0;
        WEEK_DAY=WEEK_DAY+1;
        IF (WEEK_DAY>6) THEN
          WEEK_DAY=0;
      END

      SELECT COUNT(*)
        FROM DRIVER_WEEK_SCHEDULES
       WHERE WEEK_DAY=:WEEK_DAY
         AND DAY_HOUR=:DAY_HOUR
         AND DRIVER_ID=:DRIVER_ID
        INTO :CNT;

      IF (CNT>0) THEN BEGIN

        SELECT COUNT(*)
          FROM SHIFTS
         WHERE DATE_END IS NULL
           AND ACCOUNT_ID=:DRIVER_ID
           AND DATE_BEGIN<=CURRENT_TIMESTAMP
          INTO :CNT;

        IF (CNT=0) THEN BEGIN

          DTIME=CAST((CAST(DAY_HOUR AS VARCHAR(2))||':00:00') AS TIME);

          S1=S;
          S1=REPLACE_STRING(S1,'%NAME',NAME);
          S1=REPLACE_STRING(S1,'%PATRONYMIC',PATRONYMIC);
          S1=REPLACE_STRING(S1,'%TIME',FORMAT_DATETIME('hh:nn',DTIME));

          INSERT INTO OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                    TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED,DATE_BEGIN)
                            VALUES (GET_UNIQUE_ID(),:ACCOUNT_ID,:DRIVER_ID,CURRENT_TIMESTAMP,
                                    :S1,NULL,0,:PHONE,NULL,1,NULL,:D);

          D=CURRENT_TIMESTAMP+5*(1e0/24/60/60);
        END

      END

    END

  END

END

--



