/* �������� ������� ���� ���������� */

CREATE TABLE /*PREFIX*/APPLICATION_MENUS
(
  APPLICATION_ID VARCHAR(32) NOT NULL,
  MENU_ID VARCHAR(32) NOT NULL,
  PRIMARY KEY (APPLICATION_ID,MENU_ID),
  FOREIGN KEY (APPLICATION_ID) REFERENCES /*PREFIX*/APPLICATIONS (APPLICATION_ID),
  FOREIGN KEY (MENU_ID) REFERENCES /*PREFIX*/MENUS (MENU_ID)
)

--

/* �������� ��������� ������� ���� ���������� */

CREATE VIEW /*PREFIX*/S_APPLICATION_MENUS
AS
SELECT AM.*,
       A.NAME AS APPLICATION_NAME,
			 M.NAME AS MENU_NAME 
  FROM /*PREFIX*/APPLICATION_MENUS AM
	JOIN /*PREFIX*/APPLICATIONS A ON A.APPLICATION_ID=AM.APPLICATION_ID
	JOIN /*PREFIX*/MENUS M ON M.MENU_ID=AM.MENU_ID
			
--

/* �������� ��������� ���������� ���� ���������� */

CREATE PROCEDURE /*PREFIX*/I_APPLICATION_MENU
(
  IN APPLICATION_ID VARCHAR(32),
  IN MENU_ID VARCHAR(32)
)
BEGIN
  INSERT INTO /*PREFIX*/APPLICATION_MENUS (APPLICATION_ID,MENU_ID)
       VALUES (APPLICATION_ID,MENU_ID);
END;

--

/* �������� ��������� ��������� ���� � ���������� */

CREATE PROCEDURE /*PREFIX*/U_APPLICATION_MENU
(
  IN APPLICATION_ID VARCHAR(32),
  IN MENU_ID VARCHAR(32),
  IN OLD_APPLICATION_ID VARCHAR(32),
  IN OLD_MENU_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/APPLICATION_MENUS PO
     SET PO.APPLICATION_ID=APPLICATION_ID,
         PO.MENU_ID=MENU_ID
   WHERE PO.APPLICATION_ID=OLD_APPLICATION_ID
	   AND PO.MENU_ID=OLD_MENU_ID;
END;

--

/* �������� ��������� �������� ���� � ���������� */

CREATE PROCEDURE /*PREFIX*/D_APPLICATION_MENU
(
  IN OLD_APPLICATION_ID VARCHAR(32),
	IN OLD_MENU_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/APPLICATION_MENUS 
        WHERE APPLICATION_ID=OLD_APPLICATION_ID
				  AND MENU_ID=OLD_MENU_ID;
END;

--