/* �������� ������� ������ �������� */

CREATE TABLE /*PREFIX*/MEMBERS
(
  MEMBER_ID VARCHAR(32) NOT NULL,
  SURNAME VARCHAR(100) NOT NULL,
  NAME VARCHAR(100) NOT NULL,
  PATRONYMIC VARCHAR(100) NOT NULL,
  WORK_PLACE VARCHAR(250),  
  WORK_POSITION VARCHAR(100),
  PRIMARY KEY (MEMBER_ID)
)

--

/* �������� ��������� ������� ������ �������� */

CREATE VIEW /*PREFIX*/S_MEMBERS
(
  MEMBER_ID,
  SURNAME,
  NAME,
  PATRONYMIC,
  WORK_PLACE,  
  WORK_POSITION
)
AS
  SELECT M.*
    FROM /*PREFIX*/MEMBERS M

--

/* �������� ��������� ���������� ����� �������� */

CREATE PROCEDURE /*PREFIX*/I_MEMBER
(
  MEMBER_ID VARCHAR(32),
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  WORK_PLACE VARCHAR(250),  
  WORK_POSITION VARCHAR(100)
)
AS
BEGIN
  INSERT INTO /*PREFIX*/MEMBERS (MEMBER_ID,SURNAME,NAME,PATRONYMIC,WORK_PLACE,WORK_POSITION)
       VALUES (:MEMBER_ID,:SURNAME,:NAME,:PATRONYMIC,:WORK_PLACE,:WORK_POSITION);
END;

--

/* �������� ��������� ��������� ����� �������� */

CREATE PROCEDURE /*PREFIX*/U_MEMBER
(
  MEMBER_ID VARCHAR(32),
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  WORK_PLACE VARCHAR(250),  
  WORK_POSITION VARCHAR(100),
  OLD_MEMBER_ID VARCHAR(32)
)
AS
BEGIN
  UPDATE /*PREFIX*/MEMBERS
     SET MEMBER_ID=:MEMBER_ID,
         SURNAME=:SURNAME,
         NAME=:NAME,
         PATRONYMIC=:PATRONYMIC,
         WORK_PLACE=:WORK_PLACE,
         WORK_POSITION=:WORK_POSITION
   WHERE MEMBER_ID=:OLD_MEMBER_ID;
END;

--

/* �������� ��������� �������� ����� �������� */

CREATE PROCEDURE /*PREFIX*/D_MEMBER
(
  OLD_MEMBER_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/MEMBERS
        WHERE MEMBER_ID=:OLD_MEMBER_ID;
END;

--

/* �������� ��������� */

COMMIT