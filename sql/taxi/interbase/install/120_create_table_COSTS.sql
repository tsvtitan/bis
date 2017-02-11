/* �������� ������� ��������� ������� */

CREATE TABLE /*PREFIX*/COSTS
(
  ZONE_FROM_ID VARCHAR(32) NOT NULL,
  ZONE_TO_ID VARCHAR(32) NOT NULL,
  COST NUMERIC (15,2),
  DISTANCE INTEGER,
  PERIOD INTEGER,
  PRIMARY KEY (ZONE_FROM_ID,ZONE_TO_ID),
  FOREIGN KEY (ZONE_FROM_ID) REFERENCES /*PREFIX*/ZONES (ZONE_ID),
  FOREIGN KEY (ZONE_TO_ID) REFERENCES /*PREFIX*/ZONES (ZONE_ID)
)

--

/* �������� ��������� ��������� ������� */

CREATE VIEW /*PREFIX*/S_COSTS
(
  ZONE_FROM_ID,
  ZONE_TO_ID,
  COST,
  DISTANCE,
  PERIOD,
  ZONE_FROM_NAME,
  ZONE_TO_NAME
)
AS
SELECT C.*,
       ZF.NAME AS ZONE_FROM_NAME,
       ZT.NAME AS ZONE_TO_NAME
  FROM /*PREFIX*/COSTS C
  JOIN /*PREFIX*/ZONES ZF ON ZF.ZONE_ID=C.ZONE_FROM_ID
  JOIN /*PREFIX*/ZONES ZT ON ZT.ZONE_ID=C.ZONE_TO_ID

--

/* �������� ��������� ���������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/I_COST
(
  ZONE_FROM_ID VARCHAR(32),
  ZONE_TO_ID VARCHAR(32),
  COST NUMERIC (15,2),
  DISTANCE INTEGER,
  PERIOD INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/COSTS (ZONE_FROM_ID,ZONE_TO_ID,COST,DISTANCE,PERIOD)
       VALUES (:ZONE_FROM_ID,:ZONE_TO_ID,:COST,:DISTANCE,:PERIOD);
END;

--

/* �������� ��������� ��������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/U_COST
(
  ZONE_FROM_ID VARCHAR(32),
  ZONE_TO_ID VARCHAR(32),
  COST NUMERIC (15,2),
  DISTANCE INTEGER,
  PERIOD INTEGER,
  OLD_ZONE_FROM_ID VARCHAR(32),
  OLD_ZONE_TO_ID VARCHAR(32)
)
AS
  DECLARE CT INTEGER;
BEGIN

  CT=0;
  SELECT COUNT(*)
    FROM /*PREFIX*/COSTS
   WHERE ZONE_FROM_ID=:ZONE_FROM_ID
     AND ZONE_TO_ID=:ZONE_TO_ID
    INTO CT;

  IF (CT=0) THEN BEGIN

    INSERT INTO /*PREFIX*/COSTS (ZONE_FROM_ID,ZONE_TO_ID,COST,DISTANCE,PERIOD)
         VALUES (:ZONE_FROM_ID,:ZONE_TO_ID,:COST,:DISTANCE,:PERIOD);

  END ELSE BEGIN

    UPDATE /*PREFIX*/COSTS
       SET ZONE_FROM_ID=:ZONE_FROM_ID,
           ZONE_TO_ID=:ZONE_TO_ID,
           COST=:COST,
           DISTANCE=:DISTANCE,
           PERIOD=:PERIOD
     WHERE ZONE_FROM_ID=:OLD_ZONE_FROM_ID
       AND ZONE_TO_ID=:OLD_ZONE_TO_ID;

  END
END;

--

/* �������� ��������� �������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/D_COST
(
  OLD_ZONE_FROM_ID VARCHAR(32),
  OLD_ZONE_TO_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/COSTS 
        WHERE ZONE_FROM_ID=:OLD_ZONE_FROM_ID
          AND ZONE_TO_ID=:OLD_ZONE_TO_ID;
END;

--

/* �������� ��������� */

COMMIT