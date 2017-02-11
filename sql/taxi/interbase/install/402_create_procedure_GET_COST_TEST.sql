/* �������� ��������� ������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/GET_COST_TEST
(
  ORDER_ID VARCHAR(32),
  STREET_ID VARCHAR(32),
  ZONE_ID VARCHAR(32),
  CAR_ID VARCHAR(32),
  RATE_ID VARCHAR(32),
  CAR_TYPE_ID VARCHAR(32),
  FIRM_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  DRIVER_ID VARCHAR(32),
  SOURCE_ID VARCHAR(32),
  DISCOUNT_ID VARCHAR(32),
  HOUSE VARCHAR(10),
  FLAT VARCHAR(10),
  PORCH VARCHAR(10),
  PHONE VARCHAR(100),
  CUSTOMER VARCHAR(250),
  ORDER_NUM VARCHAR(10),
  BASE_COST NUMERIC(15,2),
  BASE_DISTANCE NUMERIC(15,2),
  BASE_PERIOD INTEGER
)
RETURNS
(
  COST NUMERIC(15,2)
)
AS
BEGIN
  COST=500;
END

--

/* �������� ��������� */

COMMIT