/* ��������� ��������� �������� ���� */

ALTER PROCEDURE /*PREFIX*/D_MENU
  @OLD_MENU_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/APPLICATION_MENUS
        WHERE MENU_ID=@OLD_MENU_ID;

  DELETE FROM /*PREFIX*/MENUS
        WHERE MENU_ID=@OLD_MENU_ID;
END;

--
