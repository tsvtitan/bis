/* Создание процедуры обработки результата нет стоянки */

CREATE PROCEDURE /*PREFIX*/PR_NO_PARK
(
  ORDER_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32)
)
AS
  DECLARE ZONE_ID VARCHAR(32);
  DECLARE PARK_ID VARCHAR(32);
  DECLARE DRIVER_ID VARCHAR(32);
  DECLARE CNT INTEGER;
BEGIN

  SELECT ZONE_ID, PARK_ID, DRIVER_ID
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:ORDER_ID
     INTO :ZONE_ID, :PARK_ID, :DRIVER_ID;

  IF (DRIVER_ID IS NULL) THEN BEGIN

    IF (ZONE_ID IS NOT NULL) THEN BEGIN

      IF (PARK_ID IS NULL) THEN BEGIN

        FOR SELECT P.PARK_ID
              FROM /*PREFIX*/ZONE_PARKS ZP
              JOIN /*PREFIX*/PARKS P ON P.PARK_ID=ZP.PARK_ID
             WHERE (((P.MAX_COUNT IS NOT NULL) AND
                     (P.MAX_COUNT> (SELECT COUNT(*)
                                      FROM /*PREFIX*/PARK_STATES
                                     WHERE DATE_OUT IS NULL
                                       AND PARK_ID=P.PARK_ID)))
                    OR (P.MAX_COUNT IS NULL))
               AND ZP.ZONE_ID=:ZONE_ID
             ORDER BY ZP.DISTANCE, ZP.PERIOD
              INTO :PARK_ID DO BEGIN

          SELECT COUNT(*)
            FROM /*PREFIX*/PARK_STATES
           WHERE PARK_ID=:PARK_ID
             AND DATE_OUT IS NULL
            INTO :CNT;

          IF (CNT>0) THEN
            BREAK;

          PARK_ID=NULL;

        END

        IF (PARK_ID IS NOT NULL) THEN BEGIN

          UPDATE /*PREFIX*/ORDERS
             SET PARK_ID=:PARK_ID,
                 DATE_END=CURRENT_TIMESTAMP,
                 WHO_PROCESS_ID=:ACCOUNT_ID
           WHERE ORDER_ID=:ORDER_ID;

        END ELSE BEGIN

          EXECUTE PROCEDURE PR_MANUAL(ORDER_ID,ACCOUNT_ID);

        END

      END

    END ELSE BEGIN

      EXECUTE PROCEDURE PR_MANUAL(ORDER_ID,ACCOUNT_ID);

    END

  END

END

--

/* Фиксация изменений */

COMMIT