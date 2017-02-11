/* �������� ��������� ��������� ���������� �������� ������ */

CREATE PROCEDURE /*PREFIX*/PR_ARRIVAL_DRIVER
(
  ORDER_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32)
)
AS
  DECLARE PHONE VARCHAR(100);
  DECLARE DRIVER_ID VARCHAR(32);
  DECLARE COST_RATE NUMERIC(15,2);
  DECLARE COLOR VARCHAR(100);
  DECLARE BRAND VARCHAR(100);
  DECLARE STATE_NUM VARCHAR(50);
  DECLARE PREFIX VARCHAR(10);
  DECLARE STREET VARCHAR(100);
  DECLARE HOUSE VARCHAR(10);
  DECLARE FLAT VARCHAR(10);
  DECLARE PORCH VARCHAR(10);
  DECLARE LOCALITY VARCHAR(100);
  DECLARE RECIPIENT_ID VARCHAR(32);
  DECLARE S VARCHAR(1000);
  DECLARE CNT INTEGER;
BEGIN

  SELECT O.PHONE, O.DRIVER_ID, O.COST_RATE,
         C.COLOR, C.BRAND, C.STATE_NUM
    FROM /*PREFIX*/ORDERS O
    LEFT JOIN /*PREFIX*/DRIVERS D ON D.DRIVER_ID=O.DRIVER_ID
    LEFT JOIN /*PERFIX*/CARS C ON C.CAR_ID=D.CAR_ID
   WHERE ORDER_ID=:ORDER_ID
    INTO :PHONE, :DRIVER_ID, :COST_RATE,
         :COLOR, :BRAND, :STATE_NUM;

  UPDATE /*PREFIX*/ORDERS
     SET DATE_BEGIN=CURRENT_TIMESTAMP
   WHERE ORDER_ID=:ORDER_ID;

  IF (DRIVER_ID IS NOT NULL) THEN BEGIN

    IF (PHONE IS NOT NULL) THEN BEGIN

      IF (SUBSTR(PHONE,1,3)='+79')  THEN BEGIN

        RECIPIENT_ID=NULL;

        FOR SELECT ACCOUNT_ID
              FROM /*PREFIX*/ACCOUNTS
             WHERE PHONE=:PHONE
              INTO :RECIPIENT_ID DO BEGIN

          IF (RECIPIENT_ID IS NOT NULL) THEN
            BREAK;
        END

        S='��������, ����� '||COLOR||', '||BRAND||', '||STATE_NUM||'.';

        IF (COST_RATE>0) THEN BEGIN

          S=S||' ��������� = '||CAST(CAST(COST_RATE AS NUMERIC(15,0)) AS VARCHAR(30))||' �.';

        END ELSE BEGIN

          S=S||' ��������� �� ����������';

        END

        INSERT INTO /*PREFIX*/OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                            TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED)
                                    VALUES (/*PREFIX*/GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                            :S,NULL,0,:PHONE,NULL,0,NULL);
      END

    END

    SELECT PHONE
      FROM /*PREFIX*/ACCOUNTS
     WHERE ACCOUNT_ID=:DRIVER_ID
      INTO :PHONE;

    SELECT COUNT(*)
      FROM /*PREFIX*/ROUTES
     WHERE ORDER_ID=:ORDER_ID
      INTO CNT;

    IF (CNT>0) THEN BEGIN

      FOR SELECT S.PREFIX, S.NAME, R.HOUSE, R.FLAT, R.PORCH, L.NAME
            FROM /*PREFIX*/ROUTES R
            LEFT JOIN /*PREFIX*/STREETS S ON S.STREET_ID=R.STREET_ID
            LEFT JOIN /*PREFIX*/LOCALITIES L ON L.LOCALITY_ID=S.LOCALITY_ID
           WHERE R.ORDER_ID=:ORDER_ID
           ORDER BY R.PRIORITY
            INTO :PREFIX, :STREET, :HOUSE, :FLAT, :PORCH, :LOCALITY DO BEGIN
        BREAK;
      END

      S='';

      IF (PREFIX IS NOT NULL) THEN
        S=PREFIX||' ';

      S=S||STREET||' '||HOUSE;

      IF (FLAT IS NOT NULL) THEN
        S=S||'-'||FLAT;

      IF (PORCH IS NOT NULL) THEN
        S=S||' �.'||PORCH;

      S=S||', '||LOCALITY||'.';

    END ELSE BEGIN

      S='�������� �������.';

    END

    IF (COST_RATE>0) THEN BEGIN

      S=S||' ��������� = '||CAST(CAST(COST_RATE AS NUMERIC(15,0)) AS VARCHAR(30))||' �.';

    END ELSE BEGIN

      S=S||' ��������� �� ����������';

    END

    RECIPIENT_ID=DRIVER_ID;

    INSERT INTO /*PREFIX*/OUT_MESSAGES (OUT_MESSAGE_ID,CREATOR_ID,RECIPIENT_ID,DATE_CREATE,
                                        TEXT_OUT,DATE_OUT,TYPE_MESSAGE,CONTACT,DESCRIPTION,PRIORITY,LOCKED)
                                VALUES (/*PREFIX*/GET_UNIQUE_ID(),:ACCOUNT_ID,:RECIPIENT_ID,CURRENT_TIMESTAMP,
                                        :S,NULL,0,:PHONE,NULL,2,NULL);

  END

END

--

/* �������� ��������� */

COMMIT