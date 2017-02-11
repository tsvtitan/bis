/* �������� ��������� �������� ����������� �������� ����������� */

CREATE PROCEDURE /*PREFIX*/ANALYSIS_WORK_EMPLOYEE
  @ACCOUNT_ID VARCHAR(32),
  @DATE_BEGIN DATETIME,
  @DATE_END DATETIME
AS
BEGIN
  DECLARE @MIN_DATE DATETIME,
          @MAX_DATE DATETIME;

  IF (@ACCOUNT_ID IS NOT NULL) BEGIN
    SELECT @MIN_DATE=MIN(CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104)), 
           @MAX_DATE=MAX(CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104))
      FROM /*PREFIX*/TASKS
     WHERE PERFORMER_ID=@ACCOUNT_ID
       AND RESULT_ID IS NOT NULL;
  END ELSE BEGIN
    SELECT @MIN_DATE=MIN(CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104)), 
           @MAX_DATE=MAX(CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104))
      FROM /*PREFIX*/TASKS
     WHERE RESULT_ID IS NOT NULL;
  END; 

  IF (@DATE_BEGIN IS NOT NULL) SET @MIN_DATE=@DATE_BEGIN;

  IF (@DATE_END IS NOT NULL) SET @MAX_DATE=@DATE_END;
  
  IF (@ACCOUNT_ID IS NOT NULL) BEGIN
    
    SELECT AC.ACCOUNT_ID,
           AC.SURNAME,
           AC.NAME,
           AC.PATRONYMIC,
           A.ACTION_ID,
           A.NAME AS ACTION_NAME,
           R.RESULT_ID,
           R.NAME AS RESULT_NAME,
           AR.PRIORITY,
           COUNT(*) AS TASK_COUNT
      FROM /*PREFIX*/TASKS T 
      JOIN /*PREFIX*/ACTIONS A ON A.ACTION_ID=T.ACTION_ID
      JOIN /*PREFIX*/RESULTS R ON R.RESULT_ID=T.RESULT_ID
      JOIN /*PREFIX*/ACTION_RESULTS AR ON AR.ACTION_ID=A.ACTION_ID AND AR.RESULT_ID=R.RESULT_ID
      JOIN /*PREFIX*/ACCOUNTS AC ON AC.ACCOUNT_ID=T.PERFORMER_ID
     WHERE T.RESULT_ID IS NOT NULL
       AND T.PERFORMER_ID=@ACCOUNT_ID
       AND CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104)>=@MIN_DATE
       AND CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104)<=@MAX_DATE   
     GROUP BY AC.ACCOUNT_ID, AC.SURNAME, AC.NAME, AC.PATRONYMIC, A.ACTION_ID, A.NAME, R.NAME, R.RESULT_ID, AR.PRIORITY
     ORDER BY AC.SURNAME, AC.NAME, AC.PATRONYMIC, A.NAME, AR.PRIORITY;

  END ELSE BEGIN

    SELECT AC.ACCOUNT_ID,
           AC.SURNAME,
           AC.NAME,
           AC.PATRONYMIC,
           A.ACTION_ID,
           A.NAME AS ACTION_NAME,
           R.RESULT_ID,
           R.NAME AS RESULT_NAME,
           AR.PRIORITY,
           COUNT(*) AS TASK_COUNT
      FROM /*PREFIX*/TASKS T 
      JOIN /*PREFIX*/ACTIONS A ON A.ACTION_ID=T.ACTION_ID
      JOIN /*PREFIX*/RESULTS R ON R.RESULT_ID=T.RESULT_ID
      JOIN /*PREFIX*/ACTION_RESULTS AR ON AR.ACTION_ID=A.ACTION_ID AND AR.RESULT_ID=R.RESULT_ID
      JOIN /*PREFIX*/ACCOUNTS AC ON AC.ACCOUNT_ID=T.PERFORMER_ID
     WHERE T.RESULT_ID IS NOT NULL
       AND CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104)>=@MIN_DATE
       AND CONVERT(DATETIME,CONVERT(VARCHAR(10),DATE_BEGIN,104),104)<=@MAX_DATE   
     GROUP BY AC.ACCOUNT_ID, AC.SURNAME, AC.NAME, AC.PATRONYMIC, A.ACTION_ID, A.NAME, R.NAME, R.RESULT_ID, AR.PRIORITY
     ORDER BY AC.SURNAME, AC.NAME, AC.PATRONYMIC, A.NAME, AR.PRIORITY;

  END;

END;

--
