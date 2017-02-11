/* �������� ��������� �������� ������� ������ */

CREATE PROCEDURE /*PREFIX*/CREATE_ORDER_HISTORY
(
  OLD_ORDER_ID VARCHAR(32),
  NEW_ORDER_ID VARCHAR(32),
  ACCOUNT_ID VARCHAR(32),
  ACTION_ID VARCHAR(32),
  RESULT_ID VARCHAR(32),
  TYPE_PROCESS INTEGER,
  DATE_BEGIN TIMESTAMP,
  WITH_DEPENDS INTEGER
)
AS
BEGIN

  INSERT INTO /*PREFIX*/ORDERS (ORDER_ID,PARENT_ID,ACTION_ID,RATE_ID,CAR_TYPE_ID,
                                WHO_ACCEPT_ID,STREET_ID,ZONE_ID,FIRM_ID,CAR_ID,
                                WHO_PROCESS_ID,RESULT_ID,PARK_ID,SOURCE_ID,DISCOUNT_ID,
                                DRIVER_ID,ORDER_NUM,PHONE,HOUSE,FLAT,PORCH,
                                DATE_ACCEPT,DATE_ARRIVAL,DATE_BEGIN,DATE_END,CUSTOMER,
                                DESCRIPTION,COST_RATE,COST_FACT,TYPE_ACCEPT,
                                TYPE_PROCESS,DATE_HISTORY,WHO_HISTORY_ID,BEFORE_PERIOD,
                                FINISHED)
  SELECT :NEW_ORDER_ID,NULL,:ACTION_ID,RATE_ID,CAR_TYPE_ID,
         WHO_ACCEPT_ID,STREET_ID,ZONE_ID,FIRM_ID,CAR_ID,
         NULL,:RESULT_ID,PARK_ID,SOURCE_ID,DISCOUNT_ID,
         DRIVER_ID,ORDER_NUM,PHONE,HOUSE,FLAT,PORCH,
         DATE_ACCEPT,DATE_ARRIVAL,:DATE_BEGIN,NULL,CUSTOMER,
         DESCRIPTION,COST_RATE,COST_FACT,TYPE_ACCEPT,
         :TYPE_PROCESS,NULL,NULL,BEFORE_PERIOD,FINISHED
    FROM /*PREFIX*/ORDERS
   WHERE ORDER_ID=:OLD_ORDER_ID;

  IF (WITH_DEPENDS IS NOT NULL) THEN BEGIN

    INSERT INTO /*PREFIX*/ROUTES (ROUTE_ID,ORDER_ID,ZONE_ID,STREET_ID,HOUSE,
                                FLAT,PORCH,DISTANCE,COST,PERIOD,AMOUNT,PRIORITY)
    SELECT GET_UNIQUE_ID(),:NEW_ORDER_ID,ZONE_ID,STREET_ID,HOUSE,
           FLAT,PORCH,DISTANCE,COST,PERIOD,AMOUNT,PRIORITY
      FROM /*PREFIX*/ROUTES
     WHERE ORDER_ID=:OLD_ORDER_ID;


    INSERT INTO /*PREFIX*/ORDER_SERVICES (ORDER_ID,SERVICE_ID,COST,
                                          DESCRIPTION,AMOUNT,PRIORITY)
    SELECT :NEW_ORDER_ID,SERVICE_ID,COST,
           DESCRIPTION,AMOUNT,PRIORITY
      FROM /*PREFIX*/ORDER_SERVICES
     WHERE ORDER_ID=:OLD_ORDER_ID;

  END

  UPDATE /*PREFIX*/ORDERS
     SET PARENT_ID=:NEW_ORDER_ID,
         DATE_HISTORY=CURRENT_TIMESTAMP,
         WHO_HISTORY_ID=:ACCOUNT_ID
   WHERE ORDER_ID=:OLD_ORDER_ID;

  UPDATE /*PREFIX*/ORDERS
     SET PARENT_ID=:NEW_ORDER_ID
   WHERE PARENT_ID=:OLD_ORDER_ID;

END

--

/* �������� ��������� */

COMMIT