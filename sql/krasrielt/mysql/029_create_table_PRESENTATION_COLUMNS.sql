/* �������� ������� ������������ ������������� */

CREATE TABLE /*PREFIX*/PRESENTATION_COLUMNS
(
  PRESENTATION_ID VARCHAR(32) NOT NULL,
  COLUMN_ID VARCHAR(32) NOT NULL,
  PRIORITY INTEGER NOT NULL,
  COLUMN_GROUP INTEGER NOT NULL DEFAULT 0,
  VALUE_DEFAULT VARCHAR(250),
  VISIBLE INTEGER NOT NULL,
  USE_DEPEND INTEGER NOT NULL,
  NOT_EMPTY INTEGER NOT NULL,
  PRIMARY KEY (PRESENTATION_ID,COLUMN_ID),
  FOREIGN KEY (PRESENTATION_ID) REFERENCES PRESENTATIONS (PRESENTATION_ID),
  FOREIGN KEY (COLUMN_ID) REFERENCES COLUMNS (COLUMN_ID)
)

--

/* �������� ��������� ������� ������������ ������������� */

CREATE VIEW /*PREFIX*/S_PRESENTATION_COLUMNS
AS
SELECT PC.*,
       P.NAME AS PRESENTATION_NAME,
       C.NAME AS COLUMN_NAME,
       C.DESCRIPTION AS COLUMN_DESCRIPTION
  FROM /*PREFIX*/PRESENTATION_COLUMNS PC
  JOIN /*PREFIX*/PRESENTATIONS P ON  P.PRESENTATION_ID=PC.PRESENTATION_ID
  JOIN /*PREFIX*/COLUMNS C ON C.COLUMN_ID=PC.COLUMN_ID
	
--

/* �������� ��������� ���������� ������� ������������� */

CREATE PROCEDURE /*PREFIX*/I_PRESENTATION_COLUMN
(
  IN PRESENTATION_ID VARCHAR(32),
  IN COLUMN_ID VARCHAR(32),
  IN PRIORITY INTEGER,
  IN COLUMN_GROUP INTEGER,
  IN VALUE_DEFAULT VARCHAR(250),
  IN VISIBLE INTEGER,
  IN USE_DEPEND INTEGER,
  IN NOT_EMPTY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/PRESENTATION_COLUMNS (PRESENTATION_ID,COLUMN_ID,PRIORITY,COLUMN_GROUP,
      	                                      VALUE_DEFAULT,VISIBLE,USE_DEPEND,NOT_EMPTY)
       VALUES (PRESENTATION_ID,COLUMN_ID,PRIORITY,COLUMN_GROUP,
               VALUE_DEFAULT,VISIBLE,USE_DEPEND,NOT_EMPTY);
END;

--

/* �������� ��������� ��������� ������� � ������������� */

CREATE PROCEDURE /*PREFIX*/U_PRESENTATION_COLUMN
(
  IN PRESENTATION_ID VARCHAR(32),
  IN COLUMN_ID VARCHAR(32),
  IN PRIORITY INTEGER,
  IN COLUMN_GROUP INTEGER,
  IN VALUE_DEFAULT VARCHAR(250),
  IN VISIBLE INTEGER,
  IN USE_DEPEND INTEGER,
  IN NOT_EMPTY INTEGER,
  IN OLD_PRESENTATION_ID VARCHAR(32),
  IN OLD_COLUMN_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PRESENTATION_COLUMNS CP
     SET CP.PRESENTATION_ID=PRESENTATION_ID,
         CP.COLUMN_ID=COLUMN_ID,
         CP.PRIORITY=PRIORITY,
         CP.COLUMN_GROUP=COLUMN_GROUP,
	 CP.VALUE_DEFAULT=VALUE_DEFAULT,
	 CP.VISIBLE=VISIBLE,
	 CP.USE_DEPEND=USE_DEPEND,
	 CP.NOT_EMPTY=NOT_EMPTY
   WHERE CP.PRESENTATION_ID=OLD_PRESENTATION_ID
     AND CP.COLUMN_ID=OLD_COLUMN_ID;
END;

--

/* �������� ��������� �������� ������� � ������������� */

CREATE PROCEDURE /*PREFIX*/D_PRESENTATION_COLUMN
(
  IN OLD_PRESENTATION_ID VARCHAR(32),
	IN OLD_COLUMN_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PRESENTATION_COLUMNS 
        WHERE PRESENTATION_ID=OLD_PRESENTATION_ID
	  AND COLUMN_ID=OLD_COLUMN_ID;
END;

--