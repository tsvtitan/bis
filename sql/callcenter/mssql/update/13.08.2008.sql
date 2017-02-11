/* ��������� ��������� ���������� ������� */

ALTER PROCEDURE /*PREFIX*/EXECUTE_TASK
  @TASK_ID VARCHAR(32),
  @ACCOUNT_ID VARCHAR(32),
  @PERFORMER_ID VARCHAR(32),
  @RESULT_ID VARCHAR(32),
  @DESCRIPTION VARCHAR(4000),
  @DATE_TASK DATETIME,
  @PLAN_ID VARCHAR(32)
AS
BEGIN
  DECLARE @RESULT_TYPE INTEGER;
  DECLARE @ACTION_ID VARCHAR(32);
  DECLARE @DEAL_ID VARCHAR(32);

  IF (@TASK_ID IS NOT NULL) BEGIN
    BEGIN TRANSACTION;

    SELECT @DEAL_ID=DEAL_ID FROM /*PREFIX*/TASKS WHERE TASK_ID=@TASK_ID;

    UPDATE /*PREFIX*/TASKS
       SET ACCOUNT_ID=@ACCOUNT_ID,
           PERFORMER_ID=@PERFORMER_ID,
           RESULT_ID=@RESULT_ID,
           DATE_END=CURRENT_TIMESTAMP,
           DESCRIPTION=@DESCRIPTION           
     WHERE TASK_ID=@TASK_ID; 
    
    SELECT @RESULT_TYPE=RESULT_TYPE, @ACTION_ID=ACTION_ID 
      FROM /*PREFIX*/RESULTS WHERE RESULT_ID=@RESULT_ID;

    IF (@RESULT_TYPE=1) BEGIN /* New task */
      IF (@ACTION_ID IS NOT NULL) BEGIN
        INSERT INTO /*PREFIX*/TASKS (TASK_ID,DEAL_ID,ACTION_ID,DATE_CREATE)
             VALUES (DBO.GET_UNIQUE_ID(),@DEAL_ID,@ACTION_ID,@DATE_TASK);
      END;
    END;

    IF (@RESULT_TYPE=2) BEGIN /* Close deal */
      UPDATE /*PREFIX*/DEALS
         SET DATE_CLOSE=@DATE_TASK
       WHERE DEAL_ID=@DEAL_ID;        
    END;

    IF (@RESULT_TYPE=3) BEGIN /* New plan */

      SET @ACTION_ID=(SELECT TOP 1 ACTION_ID FROM /*PREFIX*/PLAN_ACTIONS 
                       WHERE PLAN_ID=@PLAN_ID ORDER BY PRIORITY); 

      IF (@ACTION_ID IS NOT NULL) BEGIN
        INSERT INTO /*PREFIX*/TASKS (TASK_ID,DEAL_ID,ACTION_ID,DATE_CREATE)
             VALUES (DBO.GET_UNIQUE_ID(),@DEAL_ID,@ACTION_ID,@DATE_TASK);
      END;
    END;

    COMMIT TRANSACTION;
  END;
END;

--







