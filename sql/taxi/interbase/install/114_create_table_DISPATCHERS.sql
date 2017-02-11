/* �������� ������� ����������� */

CREATE TABLE /*PREFIX*/DISPATCHERS
(
  DISPATCHER_ID VARCHAR(32) NOT NULL,
  CALC_ID VARCHAR(32),
  PHONE_HOME VARCHAR(100),
  PASSPORT VARCHAR(250),
  PLACE_BIRTH VARCHAR(250),
  DATE_BIRTH DATE,
  ADDRESS_RESIDENCE VARCHAR(250),
  ADDRESS_ACTUAL VARCHAR(250),
  PRIMARY KEY (DISPATCHER_ID),
  FOREIGN KEY (DISPATCHER_ID) REFERENCES ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (CALC_ID) REFERENCES CALCS (CALC_ID)
)

--

/* �������� ��������� ����������� */

CREATE VIEW /*PREFIX*/S_DISPATCHERS
(
    DISPATCHER_ID,
    CALC_ID,
    PHONE_HOME,
    PASSPORT,
    PLACE_BIRTH,
    DATE_BIRTH,
    ADDRESS_RESIDENCE,
    ADDRESS_ACTUAL,
    PHONE,
    DESCRIPTION,
    USER_NAME,
    DATE_CREATE,
    LOCKED,
    SURNAME,
    NAME,
    PATRONYMIC,
    CALC_NAME)
AS
SELECT D.*,
       A.PHONE,
       A.DESCRIPTION,
       A.USER_NAME,
       A.DATE_CREATE,
       A.LOCKED,
       A.SURNAME,
       A.NAME,
       A.PATRONYMIC,
       CL.NAME AS CALC_NAME
  FROM /*PREFIX*/DISPATCHERS D
  JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=D.DISPATCHER_ID
  LEFT JOIN /*PREFIX*/CALCS CL ON CL.CALC_ID=D.CALC_ID

--

/* �������� ��������� ���������� ���������� */

CREATE OR ALTER PROCEDURE I_DISPATCHER (
  DISPATCHER_ID VARCHAR(32),
  CALC_ID VARCHAR(32),
  PHONE VARCHAR(100),
  PHONE_HOME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PASSPORT VARCHAR(250),
  PLACE_BIRTH VARCHAR(250),
  DATE_BIRTH DATE,
  ADDRESS_RESIDENCE VARCHAR(250),
  ADDRESS_ACTUAL VARCHAR(250),
  USER_NAME VARCHAR(100),
  LOCKED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100))
AS
  DECLARE ROLE_ID VARCHAR(32);
BEGIN

  INSERT INTO ACCOUNTS(ACCOUNT_ID,DATE_CREATE,USER_NAME,LOCKED,SURNAME,NAME,PATRONYMIC,IS_ROLE,PHONE,DESCRIPTION)
       VALUES (:DISPATCHER_ID,CURRENT_TIMESTAMP,:USER_NAME,:LOCKED,:SURNAME,:NAME,:PATRONYMIC,0,:PHONE,:DESCRIPTION);

  INSERT INTO DISPATCHERS (DISPATCHER_ID,CALC_ID,PHONE_HOME,
                           PASSPORT,PLACE_BIRTH,DATE_BIRTH,
                           ADDRESS_RESIDENCE,ADDRESS_ACTUAL)
       VALUES (:DISPATCHER_ID,:CALC_ID,:PHONE_HOME,
               :PASSPORT,:PLACE_BIRTH,:DATE_BIRTH,
               :ADDRESS_RESIDENCE,:ADDRESS_ACTUAL);

  ROLE_ID='FF7F332564F795C8411BF28652B22BEA'; /* ���������� */
  INSERT INTO ACCOUNT_ROLES (ROLE_ID,ACCOUNT_ID)
       VALUES (:ROLE_ID,:DISPATCHER_ID);

END;

--

/* �������� ��������� ��������� ���������� */

CREATE OR ALTER PROCEDURE U_DISPATCHER (
  DISPATCHER_ID VARCHAR(32),
  CALC_ID VARCHAR(32),
  PHONE VARCHAR(100),
  PHONE_HOME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PASSPORT VARCHAR(250),
  PLACE_BIRTH VARCHAR(250),
  DATE_BIRTH DATE,
  ADDRESS_RESIDENCE VARCHAR(250),
  ADDRESS_ACTUAL VARCHAR(250),
  USER_NAME VARCHAR(100),
  LOCKED INTEGER,
  SURNAME VARCHAR(100),
  NAME VARCHAR(100),
  PATRONYMIC VARCHAR(100),
  OLD_DISPATCHER_ID VARCHAR(32))
AS
BEGIN

  UPDATE /*PREFIX*/ACCOUNTS
     SET ACCOUNT_ID=:DISPATCHER_ID,
         USER_NAME=:USER_NAME,
         LOCKED=:LOCKED,
         SURNAME=:SURNAME,
         NAME=:NAME,
         PATRONYMIC=:PATRONYMIC,
         IS_ROLE=0,
         PHONE=:PHONE,
         DESCRIPTION=:DESCRIPTION
   WHERE ACCOUNT_ID=:OLD_DISPATCHER_ID;

  UPDATE /*PREFIX*/DISPATCHERS
     SET DISPATCHER_ID=:DISPATCHER_ID,
         CALC_ID=:CALC_ID,
         PHONE_HOME=:PHONE_HOME,
         PASSPORT=:PASSPORT,
         PLACE_BIRTH=:PLACE_BIRTH,
         DATE_BIRTH=:DATE_BIRTH,
         ADDRESS_RESIDENCE=:ADDRESS_RESIDENCE,
         ADDRESS_ACTUAL=:ADDRESS_ACTUAL
   WHERE DISPATCHER_ID=:OLD_DISPATCHER_ID;

END;

--

/* �������� ��������� �������� ���������� */

CREATE PROCEDURE /*PREFIX*/D_DISPATCHER
(
  OLD_DISPATCHER_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/DISPATCHERS 
        WHERE DISPATCHER_ID=:OLD_DISPATCHER_ID;

  DELETE FROM /*PREFIX*/ACCOUNTS
        WHERE ACCOUNT_ID=:OLD_DISPATCHER_ID;
END;

--

/* �������� ��������� */

COMMIT