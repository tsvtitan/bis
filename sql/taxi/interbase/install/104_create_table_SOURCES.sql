/* �������� ������� ���������� */

CREATE TABLE /*PREFIX*/SOURCES
(
  SOURCE_ID VARCHAR(32) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER,
  PRIMARY KEY (SOURCE_ID)
)

--

/* �������� ��������� ���������� */

CREATE VIEW /*PREFIX*/S_SOURCES
AS
SELECT * FROM /*PREFIX*/SOURCES

--

/* �������� ��������� ���������� ��������� */

CREATE PROCEDURE /*PREFIX*/I_SOURCE
(
  SOURCE_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/SOURCES (SOURCE_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (:SOURCE_ID,:NAME,:DESCRIPTION,:PRIORITY);
END;

--

/* �������� ��������� ��������� ��������� */

CREATE PROCEDURE /*PREFIX*/U_SOURCE
(
  SOURCE_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER,
  OLD_SOURCE_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/SOURCES
     SET SOURCE_ID=:SOURCE_ID,
         NAME=:NAME,
         DESCRIPTION=:DESCRIPTION,
         PRIORITY=:PRIORITY
   WHERE SOURCE_ID=:OLD_SOURCE_ID;
END;

--

/* �������� ��������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/D_SOURCE
(
  OLD_SOURCE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/SOURCES 
        WHERE SOURCE_ID=:OLD_SOURCE_ID;
END;

--

/* �������� ��������� */

COMMIT