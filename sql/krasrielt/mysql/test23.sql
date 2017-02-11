SELECT M.*
  FROM MENUS M
 WHERE M.INTERFACE_ID IN (SELECT INTERFACE_ID 
                            FROM APPLICATION_INTERFACES
                           WHERE APPLICATION_ID='0C01388702B3A0114EDB4DD78F39A492' 
                             AND ACCOUNT_ID IN ('3AC5EA48DEA3A72A4380D9CC5923471F'))
    OR M.INTERFACE_ID IS NULL														