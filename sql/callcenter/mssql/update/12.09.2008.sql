/* Создание просмотра информации о кредиторах */

CREATE VIEW /*PREFIX*/S_INFORMATION_OBLIGEES
AS
  SELECT T.*,
         (T.DEAL_COUNT-T.PAYMENT_COUNT) AS REMAINDER_COUNT,
         (T.INITIAL_DEBT-T.DEBT) AS REMAINDER
    FROM (SELECT F.FIRM_ID,
                 F.SMALL_NAME,
                 A.NUM AS AGREEMENT_NUM,
                 A.DATE_BEGIN,
                 C.NAME AS CURRENCY_NAME,
                (CASE
                   WHEN D1.DEAL_COUNT IS NULL THEN 0
                   ELSE D1.DEAL_COUNT
                 END) AS DEAL_COUNT,
                (CASE
                   WHEN D1.INITIAL_DEBT IS NULL THEN 0
                   ELSE D1.INITIAL_DEBT
                 END) AS INITIAL_DEBT,
                (CASE 
                   WHEN D3.PAYMENT_COUNT IS NULL THEN 0
                   ELSE D3.PAYMENT_COUNT
                 END) AS PAYMENT_COUNT,
                (CASE
                   WHEN D2.DEBT IS NULL THEN 0 
                   ELSE D2.DEBT
                 END) AS DEBT
            FROM /*PREFIX*/FIRMS F 
            JOIN /*PREFIX*/AGREEMENTS A ON A.FIRM_ID=F.FIRM_ID
            JOIN /*PREFIX*/VARIANTS V ON V.VARIANT_ID=A.VARIANT_ID
            JOIN /*PREFIX*/CURRENCY C ON C.CURRENCY_ID=V.CURRENCY_ID
            LEFT JOIN (SELECT AGREEMENT_ID, 
                              SUM(INITIAL_DEBT) AS INITIAL_DEBT,
                              COUNT(*) AS DEAL_COUNT
                         FROM /*PREFIX*/ DEALS
                        GROUP BY AGREEMENT_ID) D1 ON D1.AGREEMENT_ID=A.AGREEMENT_ID
            LEFT JOIN (SELECT D.AGREEMENT_ID, 
                              SUM(P.AMOUNT) AS DEBT
                         FROM /*PREFIX*/ PAYMENTS P
                         JOIN /*PREFIX*/ DEALS D ON D.DEAL_ID=P.DEAL_ID
                        WHERE P.STATE=1
                        GROUP BY D.AGREEMENT_ID) D2 ON D2.AGREEMENT_ID=A.AGREEMENT_ID
            LEFT JOIN (SELECT D.AGREEMENT_ID,
                              COUNT(*) AS PAYMENT_COUNT
                         FROM DEALS D
                         JOIN (SELECT DEAL_ID,
                                      SUM(AMOUNT) AS DEBT
                                 FROM /*PREFIX*/ PAYMENTS
                                WHERE STATE=1
                                GROUP BY DEAL_ID) P ON P.DEAL_ID=D.DEAL_ID
                        WHERE (D.INITIAL_DEBT-P.DEBT)<=0
                        GROUP BY D.AGREEMENT_ID) D3 ON D3.AGREEMENT_ID=A.AGREEMENT_ID) T

--







