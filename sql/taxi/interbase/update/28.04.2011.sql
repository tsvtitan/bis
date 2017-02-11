CREATE OR ALTER PROCEDURE INCOMING_CALL_CHECK
(
  CALLER_PHONE VARCHAR(100),
  CALLER_DIVERSION VARCHAR(100),
  CHANNEL VARCHAR(100)
)
RETURNS
(
  ACCOUNT_ID VARCHAR(32),
  PHONE VARCHAR(100),
  OPERATOR_ID VARCHAR(32),
  FIRM_ID VARCHAR(32),
  CHECKED INTEGER
)
AS
DECLARE CNT INTEGER;
DECLARE RANGE_MIN BIGINT;
DECLARE RANGE_MAX BIGINT;
DECLARE PHONE_NUM BIGINT;
BEGIN
  CHECKED=0;

  IF (CHANNEL IS NOT NULL) THEN BEGIN

    FIRM_ID=NULL;

    IF ((CHANNEL='CallServerSipChannel2026672') OR
        (CHANNEL='CallServerSipChannel2231003')) THEN

      FIRM_ID='C49DF004D660BBAF434839044848F5B8';

    IF (CHANNEL='CallServerSipChannel2904021') THEN

      FIRM_ID='81DCAB751C23A5C942A41C19FE3FC78E';

  END

  IF ((CALLER_PHONE IS NOT NULL) /*AND (CALLER_PHONE<>'Anonymous')*/) THEN BEGIN

    PHONE=CALLER_PHONE;

    EXECUTE PROCEDURE TRANSFORM_PHONE (PHONE)
     RETURNING_VALUES PHONE;

    EXECUTE PROCEDURE CONVERT_PHONE(PHONE,1)
     RETURNING_VALUES PHONE;

    EXECUTE PROCEDURE GET_OPERATOR (PHONE)
     RETURNING_VALUES OPERATOR_ID, RANGE_MIN, RANGE_MAX, PHONE_NUM;

    SELECT FIRST 1
           ACCOUNT_ID
      FROM ACCOUNTS
     WHERE PHONE=:PHONE
      INTO :ACCOUNT_ID;

    IF (ACCOUNT_ID IS NULL) THEN BEGIN

      SELECT FIRST 1
             CLIENT_ID
        FROM CLIENT_PHONES
       WHERE PHONE=:PHONE
        INTO :ACCOUNT_ID;

    END

    SELECT COUNT(*)
      FROM BLACKS
     WHERE PHONE=:PHONE
      INTO :CNT;

    IF (CNT=0) THEN BEGIN

      CHECKED=1;

    END

  END

END

--

CREATE OR ALTER PROCEDURE GET_CALL_INFO
(
  ACCOUNT_ID VARCHAR(32),
  ACCOUNT_PHONE VARCHAR(32)
)
RETURNS
(
  CALL_ACCOUNT_ID VARCHAR(32),
  CALL_NAME VARCHAR(100),
  CALL_GROUP VARCHAR(4000),
  CALL_DESCRIPTION VARCHAR(250),
  CALL_KIND INTEGER
)
AS
DECLARE CALL_PHONE VARCHAR(100);
DECLARE PHONE VARCHAR(100);
DECLARE CNT INTEGER;
DECLARE USER_NAME VARCHAR(100);
DECLARE SURNAME VARCHAR(100);
DECLARE NAME VARCHAR(100);
DECLARE PATRONYMIC VARCHAR(100);
DECLARE DESCRIPTION VARCHAR(250);
DECLARE IS_ROLE INTEGER;
DECLARE FIRM_SMALL_NAME VARCHAR(250);
DECLARE CLIENT_GROUP_ID VARCHAR(32);
BEGIN
  CALL_KIND=0; /* Unknown */
  CALL_GROUP='����������';
  CALL_PHONE=ACCOUNT_PHONE;

  FOR SELECT A.ACCOUNT_ID, A.USER_NAME, A.SURNAME, A.NAME,
             A.PATRONYMIC, A.DESCRIPTION, A.IS_ROLE, F.SMALL_NAME
        FROM CLIENTS C
        JOIN ACCOUNTS A ON A.ACCOUNT_ID=C.CLIENT_ID
        LEFT JOIN FIRMS F ON F.FIRM_ID=A.FIRM_ID
        LEFT JOIN CLIENT_PHONES CP ON CP.CLIENT_ID=C.CLIENT_ID
       WHERE CP.PHONE=:CALL_PHONE
          OR A.PHONE=:CALL_PHONE
          OR A.ACCOUNT_ID=:ACCOUNT_ID
        INTO :ACCOUNT_ID, :USER_NAME, :SURNAME, :NAME,
             :PATRONYMIC, :DESCRIPTION, :IS_ROLE, :FIRM_SMALL_NAME DO BEGIN
    BREAK;
  END

  IF (ACCOUNT_ID IS NULL) THEN BEGIN

    FOR SELECT A.ACCOUNT_ID, A.USER_NAME, A.SURNAME, A.NAME,
               A.PATRONYMIC, A.DESCRIPTION, A.IS_ROLE, F.SMALL_NAME
          FROM ACCOUNTS A
          LEFT JOIN FIRMS F ON F.FIRM_ID=A.FIRM_ID
         WHERE A.PHONE=:CALL_PHONE
          INTO :ACCOUNT_ID, :USER_NAME, :SURNAME, :NAME,
               :PATRONYMIC, :DESCRIPTION, :IS_ROLE, :FIRM_SMALL_NAME DO BEGIN
      BREAK;
    END

  END ELSE BEGIN
  
    FOR SELECT A.ACCOUNT_ID, A.USER_NAME, A.SURNAME, A.NAME,
               A.PATRONYMIC, A.DESCRIPTION, A.IS_ROLE, F.SMALL_NAME
          FROM ACCOUNTS A
          LEFT JOIN FIRMS F ON F.FIRM_ID=A.FIRM_ID
         WHERE A.ACCOUNT_ID=:ACCOUNT_ID
          INTO :ACCOUNT_ID, :USER_NAME, :SURNAME, :NAME,
               :PATRONYMIC, :DESCRIPTION, :IS_ROLE, :FIRM_SMALL_NAME DO BEGIN
      BREAK;
    END
  
  END

  CALL_ACCOUNT_ID=ACCOUNT_ID;
    
  IF (ACCOUNT_ID IS NOT NULL) THEN BEGIN

    CALL_NAME=TRIM(CALL_PHONE);

    CALL_DESCRIPTION=NULL;
    IF (SURNAME IS NOT NULL) THEN
      CALL_DESCRIPTION=TRIM(SURNAME);
    IF (NAME IS NOT NULL) THEN
      CALL_DESCRIPTION=CALL_DESCRIPTION||' '||TRIM(NAME);
    IF (PATRONYMIC IS NOT NULL) THEN
      CALL_DESCRIPTION=CALL_DESCRIPTION||' '||TRIM(PATRONYMIC);
    IF (USER_NAME IS NOT NULL) THEN
      CALL_DESCRIPTION=TRIM(USER_NAME)||' - '||CALL_DESCRIPTION;

    IF (FIRM_SMALL_NAME IS NOT NULL) THEN BEGIN
      CALL_DESCRIPTION=CALL_DESCRIPTION||' ['||TRIM(FIRM_SMALL_NAME)||']';
    END

    SELECT COUNT(*)
      FROM CLIENTS
     WHERE CLIENT_ID=:ACCOUNT_ID
      INTO :CNT;

    IF (CNT>0) THEN BEGIN

      CLIENT_GROUP_ID=NULL;

      SELECT CLIENT_GROUP_ID
        FROM CLIENTS
       WHERE CLIENT_ID=:ACCOUNT_ID
        INTO :CLIENT_GROUP_ID;

      IF (CLIENT_GROUP_ID IS NOT NULL) THEN BEGIN

        CALL_GROUP=NULL;

        EXECUTE PROCEDURE GET_CLIENT_GROUP_PATH(CLIENT_GROUP_ID,'/')
         RETURNING_VALUES CALL_GROUP;

      END

      CALL_KIND=1; /* Client */
      IF (CALL_GROUP IS NOT NULL) THEN
        CALL_GROUP='�������/'||CALL_GROUP;
      ELSE
        CALL_GROUP='�������';


    END ElSE BEGIN

      SELECT COUNT(*)
        FROM DRIVERS
       WHERE DRIVER_ID=:ACCOUNT_ID
         INTO :CNT;

      IF (CNT>0) THEN BEGIN

        CALL_KIND=2; /* Driver */
        CALL_GROUP='��������';

      END ELSE BEGIN

        SELECT COUNT(*)
          FROM DISPATCHERS
         WHERE DISPATCHER_ID=:ACCOUNT_ID
           INTO :CNT;

        IF (CNT>0) THEN BEGIN
          CALL_KIND=3; /* Dispatcher */
          CALL_GROUP='����������';
        END ElSE BEGIN
          CALL_KIND=4; /* Account */
          CALL_GROUP='������� ������';
        END

      END

    END

  END ELSE BEGIN

    CALL_NAME=CALL_PHONE;

    IF (CALL_PHONE IS NULL) THEN BEGIN

      CALL_NAME='�� ��������';

    END

  END

END

--

