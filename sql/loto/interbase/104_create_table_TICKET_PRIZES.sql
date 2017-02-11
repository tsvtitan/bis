/* �������� ������� ������ ������� */

CREATE TABLE /*PREFIX*/TICKET_PRIZES
(
  TICKET_ID VARCHAR(32) NOT NULL,
  PRIZE_ID VARCHAR(32) NOT NULL,
  PRIORITY INTEGER,
  ISSUE_DATE TIMESTAMP,
  PRIMARY KEY (TICKET_ID,PRIZE_ID),
  FOREIGN KEY (TICKET_ID) REFERENCES /*PREFIX*/TICKETS (TICKET_ID),
  FOREIGN KEY (PRIZE_ID) REFERENCES /*PREFIX*/PRIZES (PRIZE_ID)
)

--

/* �������� ��������� ������� ������ ������� */

CREATE VIEW /*PREFIX*/S_TICKET_PRIZES
(
  TICKET_ID,
  PRIZE_ID,
  PRIORITY,
  ISSUE_DATE,
  TICKET_NUM,
  TICKET_SERIES,
  PRIZE_NAME
)
AS
SELECT TP.*,
       T.NUM AS TICKET_NUM,
       T.SERIES AS TICKET_SERIES,
       P.NAME AS PRIZE_NAME
  FROM /*PREFIX*/TICKET_PRIZES TP
  JOIN /*PREFIX*/TICKETS T ON T.TICKET_ID=TP.TICKET_ID
  JOIN /*PREFIX*/PRIZES P ON P.PRIZE_ID=TP.PRIZE_ID
			
--

/* �������� ��������� ���������� ����� ������ */

CREATE PROCEDURE /*PREFIX*/I_TICKET_PRIZE
(
  TICKET_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32),
  PRIORITY INTEGER,
  ISSUE_DATE TIMESTAMP
)
AS
BEGIN
  INSERT INTO /*PREFIX*/TICKET_PRIZES (TICKET_ID,PRIZE_ID,PRIORITY,ISSUE_DATE)
       VALUES (:TICKET_ID,:PRIZE_ID,:PRIORITY,:ISSUE_DATE);
END;

--

/* �������� ��������� ��������� ����� � ������ */

CREATE PROCEDURE /*PREFIX*/U_TICKET_PRIZE
(
  TICKET_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32),
  PRIORITY INTEGER,
  ISSUE_DATE TIMESTAMP,
  OLD_TICKET_ID VARCHAR(32),
  OLD_PRIZE_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/TICKET_PRIZES
     SET TICKET_ID=:TICKET_ID,
         PRIZE_ID=:PRIZE_ID,
         PRIORITY=:PRIORITY,
         ISSUE_DATE=:ISSUE_DATE
   WHERE TICKET_ID=:OLD_TICKET_ID
     AND PRIZE_ID=:OLD_PRIZE_ID;
END;

--

/* �������� ��������� �������� ����� � ������ */

CREATE PROCEDURE /*PREFIX*/D_TICKET_PRIZE
(
  OLD_TICKET_ID VARCHAR(32),
  OLD_PRIZE_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/TICKET_PRIZES 
        WHERE TICKET_ID=:OLD_TICKET_ID
          AND PRIZE_ID=:OLD_PRIZE_ID;
END;

--

/* �������� ��������� */

COMMIT