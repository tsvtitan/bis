/* �������� ������� ����������� */

CREATE TABLE /*PREFIX*/RESULTS
(
  RESULT_ID VARCHAR(32) NOT NULL,
  ACTION_ID VARCHAR(32) NOT NULL,
  NEXT_ID VARCHAR(32),
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  PROC_DETECT VARCHAR(100),
  PROC_PROCESS VARCHAR(100),
  FONT_COLOR INTEGER,
  BRUSH_COLOR INTEGER,
  PRIORITY INTEGER,
  PRIMARY KEY (RESULT_ID),
  FOREIGN KEY (ACTION_ID) REFERENCES ACTIONS (ACTION_ID),
  FOREIGN KEY (NEXT_ID) REFERENCES ACTIONS (ACTION_ID)
)

--

/* �������� ��������� ����������� */

CREATE VIEW /*PREFIX*/S_RESULTS
(
  RESULT_ID,
  ACTION_ID,
  NEXT_ID,
  NAME,
  DESCRIPTION,
  PROC_DETECT,
  PROC_PROCESS,
  FONT_COLOR,
  BRUSH_COLOR,
  PRIORITY,
  ACTION_NAME,
  NEXT_NAME
)
AS
SELECT R.*,
       A1.NAME AS ACTION_NAME,
       A2.NAME AS NEXT_NAME
  FROM /*PREFIX*/RESULTS R
  JOIN /*PREFIX*/ACTIONS A1 ON A1.ACTION_ID=R.ACTION_ID
  LEFT JOIN /*PREFIX*/ACTIONS A2 ON A2.ACTION_ID=R.NEXT_ID

--

/* �������� ��������� ���������� ���������� */

CREATE PROCEDURE /*PREFIX*/I_RESULT
(
  RESULT_ID VARCHAR(32),
  ACTION_ID VARCHAR(32),
  NEXT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PROC_DETECT VARCHAR(100),
  PROC_PROCESS VARCHAR(100),
  FONT_COLOR INTEGER,
  BRUSH_COLOR INTEGER,
  PRIORITY INTEGER
)
AS
BEGIN
  INSERT INTO /*PREFIX*/RESULTS (RESULT_ID,ACTION_ID,NEXT_ID,NAME,DESCRIPTION,
                                 PROC_DETECT,PROC_PROCESS,FONT_COLOR,BRUSH_COLOR,PRIORITY)
       VALUES (:RESULT_ID,:ACTION_ID,:NEXT_ID,:NAME,:DESCRIPTION,
               :PROC_DETECT,:PROC_PROCESS,:FONT_COLOR,:BRUSH_COLOR,:PRIORITY);
END;

--

/* �������� ��������� ��������� ���������� */

CREATE PROCEDURE /*PREFIX*/U_RESULT
(
  RESULT_ID VARCHAR(32),
  ACTION_ID VARCHAR(32),
  NEXT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PROC_DETECT VARCHAR(100),
  PROC_PROCESS VARCHAR(100),
  FONT_COLOR INTEGER,
  BRUSH_COLOR INTEGER,
  PRIORITY INTEGER,
  OLD_RESULT_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/RESULTS
     SET RESULT_ID=:RESULT_ID,
         ACTION_ID=:ACTION_ID,
         NEXT_ID=:NEXT_ID,
         NAME=:NAME,
         DESCRIPTION=:DESCRIPTION,
         PROC_DETECT=:PROC_DETECT,
         PROC_PROCESS=:PROC_PROCESS,
         FONT_COLOR=:FONT_COLOR,
         BRUSH_COLOR=:BRUSH_COLOR,
         PRIORITY=:PRIORITY
   WHERE RESULT_ID=:OLD_RESULT_ID;
END;

--

/* �������� ��������� �������� ���������� */

CREATE PROCEDURE /*PREFIX*/D_RESULT
(
  OLD_RESULT_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/RESULTS 
        WHERE RESULT_ID=:OLD_RESULT_ID;
END;

--

/* �������� ��������� */

COMMIT