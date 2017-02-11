/* —оздание просмотра управлени€ документами */

CREATE VIEW /*PREFIX*/S_MANAGEMENTS
AS
SELECT M.*,
       P.FIRM_ID AS POSITION_FIRM_ID,
       D.VIEW_ID, 
       D.NUM AS DOC_NUM,
       D.DATE_DOC,
       D.NAME AS DOC_NAME,
       T1.SMALL_NAME AS WHO_FIRM,
       T1.USER_NAME AS WHO_ACCOUNT,
       P.PRIORITY
  FROM /*PREFIX*/MOTIONS M
  JOIN /*PREFIX*/POSITIONS P ON P.POSITION_ID=M.POSITION_ID
  JOIN /*PREFIX*/DOCS D ON D.DOC_ID=M.DOC_ID
  LEFT JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=M.ACCOUNT_ID
  LEFT JOIN (SELECT M.DOC_ID,
                    P.PLAN_ID,
                    D.VIEW_ID,
                    F.SMALL_NAME,
                    A.USER_NAME,
                    M.DATE_PROCESS
               FROM /*PREFIX*/MOTIONS M 
               JOIN /*PREFIX*/POSITIONS P ON P.POSITION_ID=M.POSITION_ID
               JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=M.ACCOUNT_ID
               JOIN /*PREFIX*/DOCS D ON D.DOC_ID=M.DOC_ID                
               LEFT JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=A.FIRM_ID
              WHERE M.DATE_PROCESS IS NOT NULL
                AND M.ACCOUNT_ID IS NOT NULL) T1 ON T1.DOC_ID=M.DOC_ID 
                                          AND T1.PLAN_ID=P.PLAN_ID
                                          AND T1.VIEW_ID=D.VIEW_ID
                                          AND T1.DATE_PROCESS=M.DATE_ISSUE
 WHERE M.DATE_PROCESS IS NULL
   AND M.ACCOUNT_ID IS NULL

--
