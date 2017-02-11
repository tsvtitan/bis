/* �������� ������� ���� */

CREATE TABLE /*PREFIX*/MENUS
(
  MENU_ID VARCHAR(32) NOT NULL,
  INTERFACE_ID VARCHAR(32),
  PARENT_ID VARCHAR(32),
  NAME VARCHAR(100) NOT NULL,
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER NOT NULL,
  SHORTCUT INTEGER,
  PICTURE BLOB,
  "LEVEL" INTEGER NOT NULL,
  PRIMARY KEY (MENU_ID),
  FOREIGN KEY (INTERFACE_ID) REFERENCES /*PREFIX*/INTERFACES (INTERFACE_ID),
  FOREIGN KEY (PARENT_ID) REFERENCES /*PREFIX*/MENUS (MENU_ID)
)

--

/* �������� ��������� ������� ���� */

CREATE VIEW /*PREFIX*/S_MENUS
(
  MENU_ID,
  INTERFACE_ID,
  PARENT_ID,
  NAME,
  DESCRIPTION,
  PRIORITY,
  SHORTCUT,
  PICTURE,
  "LEVEL",
  INTERFACE_NAME,
  PARENT_NAME
)
AS
   SELECT M.*, 
          I.NAME AS INTERFACE_NAME,
          M1.NAME AS PARENT_NAME                    
     FROM /*PREFIX*/MENUS M
     LEFT JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=M.INTERFACE_ID
     LEFT JOIN    /*PREFIX*/MENUS M1 ON M1.MENU_ID=M.PARENT_ID

--

/* �������� ��������� ���������� ���� */

CREATE PROCEDURE /*PREFIX*/I_MENU
(
  MENU_ID VARCHAR(32),
  INTERFACE_ID VARCHAR(32),
  PARENT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER,
  SHORTCUT INTEGER,
  PICTURE BLOB
)
AS
  DECLARE VARIABLE LV INTEGER;
BEGIN
  IF (:PARENT_ID IS NULL) THEN BEGIN
    LV=1;
  END ELSE BEGIN
    SELECT M."LEVEL"+1
      FROM /*PREFIX*/MENUS M
     WHERE M.MENU_ID=:PARENT_ID
      INTO :LV;
  END
  INSERT INTO /*PREFIX*/MENUS (MENU_ID,INTERFACE_ID,PARENT_ID,NAME,DESCRIPTION,PRIORITY,SHORTCUT,PICTURE,"LEVEL")
       VALUES (:MENU_ID,:INTERFACE_ID,:PARENT_ID,:NAME,:DESCRIPTION,:PRIORITY,:SHORTCUT,:PICTURE,:LV);
END;

--

/* �������� ��������� ���������� ������� ���� */

CREATE PROCEDURE /*PREFIX*/R_MENU_LEVELS
(
  PARENT_ID VARCHAR(32),
  "LEVEL" INTEGER
)
AS
  DECLARE VARIABLE MENU_ID VARCHAR(32);
  DECLARE VARIABLE L INTEGER;
BEGIN
  FOR SELECT M.MENU_ID
        FROM /*PREFIX*/MENUS M
       WHERE M.PARENT_ID=:PARENT_ID
        INTO :MENU_ID DO BEGIN

    L=:"LEVEL"+1;

    UPDATE /*PREFIX*/MENUS
       SET "LEVEL"=:L
     WHERE MENU_ID=:MENU_ID;

    EXECUTE PROCEDURE /*PREFIX*/R_MENU_LEVELS(:MENU_ID,:L);

  END
END;

--

/* �������� ��������� ��������� ���� */

CREATE PROCEDURE /*PREFIX*/U_MENU
(
  MENU_ID VARCHAR(32),
  INTERFACE_ID VARCHAR(32),
  PARENT_ID VARCHAR(32),
  NAME VARCHAR(100),
  DESCRIPTION VARCHAR(250),
  PRIORITY INTEGER,
  SHORTCUT INTEGER,
  PICTURE BLOB,
  OLD_MENU_ID VARCHAR(32)
)
AS
  DECLARE VARIABLE LV INTEGER;
BEGIN
  IF (:PARENT_ID IS NULL) THEN BEGIN
    LV=1;
  END ELSE BEGIN
    SELECT M."LEVEL"+1
      FROM /*PREFIX*/MENUS M
     WHERE M.MENU_ID=:PARENT_ID
      INTO :LV;
  END

  UPDATE /*PREFIX*/MENUS
     SET MENU_ID=:MENU_ID,
         INTERFACE_ID=:INTERFACE_ID,
         PARENT_ID=:PARENT_ID,
         NAME=:NAME,
         DESCRIPTION=:DESCRIPTION,
         PRIORITY=:PRIORITY,
         SHORTCUT=:SHORTCUT,
         PICTURE=:PICTURE,
         "LEVEL"=:LV
   WHERE MENU_ID=:OLD_MENU_ID;
    
  EXECUTE PROCEDURE /*PREFIX*/R_MENU_LEVELS(:MENU_ID,:LV);
END;

--

/* �������� ��������� �������� ���� */

CREATE PROCEDURE /*PREFIX*/D_MENU
(
  OLD_MENU_ID VARCHAR(32)
)
AS
BEGIN
  DELETE FROM /*PREFIX*/MENUS
        WHERE MENU_ID=:OLD_MENU_ID;
END;

--
