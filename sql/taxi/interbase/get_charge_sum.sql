SELECT CT.NAME, F.SMALL_NAME, T.SUM_CHARGE
 FROM
(
        SELECT C.CHARGE_TYPE_ID,
               A.FIRM_ID,
               SUM(C.SUM_CHARGE) AS SUM_CHARGE
          FROM CHARGES C
          JOIN DRIVERS D ON D.DRIVER_ID=C.ACCOUNT_ID
          JOIN ACCOUNTS A ON A.ACCOUNT_ID=D.DRIVER_ID
         WHERE C.DATE_CHARGE>='01.10.2010'
           AND C.FIRM_ID='C49DF004D660BBAF434839044848F5B8'
         GROUP BY C.CHARGE_TYPE_ID, A.FIRM_ID

         ) T
  JOIN FIRMS F ON F.FIRM_ID=T.FIRM_ID
  JOIN CHARGE_TYPES CT ON CT.CHARGE_TYPE_ID=T.CHARGE_TYPE_ID
 ORDER BY CT.NAME, F.SMALL_NAME
