/* �������� ��������� �������� ���������� ����, ����������� � ������ �������� */

CREATE PROCEDURE /*PREFIX*/DISTRIBUTION_STATUS
  @AGREEMENT_ID VARCHAR(32),
  @DATE_BEGIN DATETIME,
  @DATE_END DATETIME
AS
BEGIN
  DECLARE @MIN_DATE DATETIME,
          @MAX_DATE DATETIME,
          @SQL NVARCHAR(2000),
          @STATUS_ID VARCHAR(32),
          @NAME VARCHAR(100),
          @CONDITION VARCHAR(250),
          @TABLE_NAME VARCHAR(100),
          @PRIORITY INTEGER,
          @STATUS_COUNT INTEGER,
          @FLAG INTEGER;

  IF (@AGREEMENT_ID IS NOT NULL) BEGIN 
    SELECT @MIN_DATE=MIN(DATE_ISSUE), @MAX_DATE=MAX(DATE_ISSUE) 
      FROM /*PREFIX*/DEALS
     WHERE DATE_CLOSE IS NULL
       AND AGREEMENT_ID=@AGREEMENT_ID;
  END ELSE BEGIN
    SELECT @MIN_DATE=MIN(DATE_ISSUE), @MAX_DATE=MAX(DATE_ISSUE) 
      FROM /*PREFIX*/DEALS
     WHERE DATE_CLOSE IS NULL;
  END;

  IF (@DATE_BEGIN IS NOT NULL) SET @MIN_DATE=@DATE_BEGIN;

  IF (@DATE_END IS NOT NULL) SET @MAX_DATE=@DATE_END;

  SET NOCOUNT ON;
  
  CREATE TABLE #DISTRIBUTION_STATUS
  (
    STATUS_ID VARCHAR(32),
    NAME VARCHAR(100),
    STATUS_COUNT INTEGER,
    PRIORITY INTEGER
  );

  DECLARE CUR CURSOR  
      FOR SELECT STATUS_ID,
                 NAME,
                 CONDITION,
                 TABLE_NAME,
                 PRIORITY
            FROM /*PREFIX*/STATUSES
           ORDER BY PRIORITY 
      FOR READ ONLY;

  OPEN CUR;

  FETCH NEXT FROM CUR
  INTO @STATUS_ID,@NAME,@CONDITION,@TABLE_NAME,@PRIORITY;

  WHILE @@FETCH_STATUS=0 BEGIN

    SET @STATUS_COUNT=0;
    SET @SQL=N'SELECT @CNT=COUNT(*) FROM '+@TABLE_NAME;    
    SET @FLAG=0;
    
    IF (@CONDITION IS NOT NULL) AND (RTRIM(LTRIM(@CONDITION))<>'') BEGIN
      SET @SQL=@SQL+' WHERE '+@CONDITION;      
      SET @FLAG=1;
    END;

    IF (@AGREEMENT_ID IS NOT NULL) BEGIN
      IF (@FLAG=0) BEGIN
        SET @SQL=@SQL+' WHERE AGREEMENT_ID='+QUOTENAME(@AGREEMENT_ID,'''');    
      END ELSE BEGIN
        SET @SQL=@SQL+' AND AGREEMENT_ID='+QUOTENAME(@AGREEMENT_ID,'''');    
      END;
    END;

    EXECUTE sp_executesql @SQL, N'@CNT INTEGER OUTPUT', @CNT=@STATUS_COUNT OUTPUT;
    
    INSERT INTO #DISTRIBUTION_STATUS (STATUS_ID,NAME,STATUS_COUNT,PRIORITY)
         VALUES (@STATUS_ID,@NAME,@STATUS_COUNT,@PRIORITY);

    FETCH NEXT FROM CUR 
    INTO @STATUS_ID,@NAME,@CONDITION,@TABLE_NAME,@PRIORITY;
  END;

  CLOSE CUR;
  DEALLOCATE CUR;

  SET NOCOUNT OFF;

  SELECT * FROM #DISTRIBUTION_STATUS
   ORDER BY PRIORITY;

  DROP TABLE #DISTRIBUTION_STATUS; 

END;

--
