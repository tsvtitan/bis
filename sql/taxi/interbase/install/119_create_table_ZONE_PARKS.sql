/* �������� ������� ��������� ������ */

CREATE TABLE /*PREFIX*/ZONE_PARKS
(
  ZONE_ID VARCHAR(32) NOT NULL,
  PARK_ID VARCHAR(32) NOT NULL,
  COST NUMERIC (15,2),
  DISTANCE INTEGER,
  PERIOD INTEGER,
  PRIMARY KEY (ZONE_ID,PARK_ID),
  FOREIGN KEY (ZONE_ID) REFERENCES /*PREFIX*/ZONES (ZONE_ID),
  FOREIGN KEY (PARK_ID) REFERENCES /*PREFIX*/PARKS (PARK_ID)
)

--

/* �������� ��������� ��������� ������ */

CREATE VIEW /*PREFIX*/S_ZONE_PARKS
(
  ZONE_ID,
  PARK_ID,
  COST,
  DISTANCE,
  PERIOD,
  ZONE_NAME,
  PARK_NAME,
  PARK_DESCRIPTION
)
AS
SELECT ZP.*,
       Z.NAME AS ZONE_NAME,
       P.NAME AS PARK_NAME,
       P.DESCRIPTION AS PARK_DESCRIPTION
  FROM /*PREFIX*/ZONE_PARKS ZP
  JOIN /*PREFIX*/ZONES Z ON Z.ZONE_ID=ZP.ZONE_ID
  JOIN /*PREFIX*/PARKS P ON P.PARK_ID=ZP.PARK_ID

--

/* �������� ��������� ���������� ��������� ������ */

CREATE PROCEDURE /*PREFIX*/I_ZONE_PARK
(
  ZONE_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  COST NUMERIC (15,2),
  DISTANCE INTEGER,
  PERIOD INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/ZONE_PARKS (ZONE_ID,PARK_ID,COST,DISTANCE,PERIOD)
       VALUES (:ZONE_ID,:PARK_ID,:COST,:DISTANCE,:PERIOD);
END;

--

/* �������� ��������� ��������� ��������� ������ */

CREATE PROCEDURE /*PREFIX*/U_ZONE_PARK
(
  ZONE_ID VARCHAR(32),
  PARK_ID VARCHAR(32),
  COST NUMERIC (15,2),
  DISTANCE INTEGER,
  PERIOD INTEGER,
  OLD_ZONE_ID VARCHAR(32),
  OLD_PARK_ID VARCHAR(32)
)
AS
  DECLARE CT INTEGER;
BEGIN

  CT=0;
  SELECT COUNT(*)
    FROM /*PREFIX*/ZONE_PARKS
   WHERE ZONE_ID=:ZONE_ID
     AND PARK_ID=:PARK_ID
    INTO CT;

  IF (CT=0) THEN BEGIN

    INSERT INTO /*PREFIX*/ZONE_PARKS (ZONE_ID,PARK_ID,COST,DISTANCE,PERIOD)
         VALUES (:ZONE_ID,:PARK_ID,:COST,:DISTANCE,:PERIOD);

  END ELSE BEGIN

    UPDATE /*PREFIX*/ZONE_PARKS
       SET ZONE_ID=:ZONE_ID,
           PARK_ID=:PARK_ID,
           COST=:COST,
           DISTANCE=:DISTANCE,
           PERIOD=:PERIOD
     WHERE ZONE_ID=:OLD_ZONE_ID
       AND PARK_ID=:OLD_PARK_ID;

  END
END;

--

/* �������� ��������� �������� ��������� ������ */

CREATE PROCEDURE /*PREFIX*/D_ZONE_PARK
(
  OLD_ZONE_ID VARCHAR(32),
  OLD_PARK_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/ZONE_PARKS 
        WHERE ZONE_ID=:OLD_ZONE_ID
          AND PARK_ID=:OLD_PARK_ID;
END;

--

/* �������� ��������� */

COMMIT