ALTER PROCEDURE /*PREFIX*/CALC_EFFICIENCY_ROUBLE
  @AGREEMENT_ID VARCHAR(32),
  @DATE_BEGIN DATETIME,
  @DATE_END DATETIME
AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @DEBTOR_NUM VARCHAR(100),
          @DATE_DEBT DATETIME,
          @DEBTOR_NAME VARCHAR(300),
          @DEBT_PERIOD INTEGER,
          @AMOUNT_ARRIVAL FLOAT,
          @COST_SERVICE FLOAT,
          @FIXED_PART FLOAT,
          @VARIABLE_PART FLOAT,
          @AMOUNT_REMUNERATION FLOAT,
          @MAX_DATE DATETIME,
          @MIN_DATE DATETIME,
          @ACTIVE_BRIEFCASE FLOAT,
          @EFFICIENCY FLOAT;

  CREATE TABLE #CALC_EFFICIENCY_ROUBLE
  (
    DEBTOR_NUM VARCHAR(100),
    DATE_DEBT DATETIME,
    DEBTOR_NAME VARCHAR(300),
    DEBT_PERIOD INTEGER,
    AMOUNT_ARRIVAL FLOAT,
    COST_SERVICE FLOAT,
    FIXED_PART FLOAT,
    VARIABLE_PART FLOAT,
    AMOUNT_REMUNERATION FLOAT
  );
  
  SELECT @MIN_DATE=MIN(DATE_PAYMENT), @MAX_DATE=MAX(DATE_PAYMENT) 
    FROM /*PREFIX*/PAYMENTS
   WHERE STATE=1
     AND DEAL_ID IN (SELECT DEAL_ID FROM /*PREFIX*/DEALS 
                      WHERE AGREEMENT_ID=@AGREEMENT_ID
                        AND DATE_CLOSE IS NULL);

  IF (@DATE_BEGIN IS NOT NULL) SET @MIN_DATE=@DATE_BEGIN;

  IF (@DATE_END IS NOT NULL) SET @MAX_DATE=@DATE_END;

  SELECT @ACTIVE_BRIEFCASE=SUM(INITIAL_DEBT)  
    FROM /*PREFIX*/DEALS
   WHERE AGREEMENT_ID=@AGREEMENT_ID
     AND DATE_CLOSE IS NULL;

  SET @EFFICIENCY=0.0;
  
  IF (@ACTIVE_BRIEFCASE>0.0) BEGIN

    SELECT @EFFICIENCY=(P.AMOUNT/@ACTIVE_BRIEFCASE*100)
      FROM (SELECT (CASE 
                      WHEN P1.AMOUNT IS NULL THEN 0
                      ELSE P1.AMOUNT
                    END) AS AMOUNT
              FROM /*PREFIX*/DEALS D  
              LEFT JOIN (SELECT DEAL_ID, SUM(AMOUNT) AS AMOUNT 
                           FROM /*PREFIX*/PAYMENTS 
                          WHERE STATE=1
                            AND DATE_PAYMENT>=@MIN_DATE 
                            AND DATE_PAYMENT<=@MAX_DATE 
                          GROUP BY DEAL_ID)AS P1 ON P1.DEAL_ID=D.DEAL_ID
             WHERE D.AGREEMENT_ID=@AGREEMENT_ID
               AND D.DATE_CLOSE IS NULL) P;
  END;

  DECLARE CUR CURSOR  
      FOR SELECT D.DEBTOR_NUM,
                 DATEADD(DAY,-D1.DEBT_PERIOD,CURRENT_TIMESTAMP) AS DATE_DEBT, 
                 DB.SURNAME+' '+DB.NAME+' '+DB.PATRONYMIC AS DEBTOR_NAME,
                 D1.DEBT_PERIOD AS DEBT_PERIOD,
                 (CASE 
                    WHEN P1.AMOUNT IS NULL THEN 0
                    ELSE P1.AMOUNT
                  END) AS AMOUNT_ARRIVAL,
                 (CASE
                    WHEN (@EFFICIENCY<5.0) THEN CASE 
                                                WHEN (D1.DEBT_PERIOD<90) THEN 0.0
                                                WHEN (D1.DEBT_PERIOD>=90) AND (D1.DEBT_PERIOD<=180) THEN 8.5
                                                WHEN (D1.DEBT_PERIOD>180) AND (D1.DEBT_PERIOD<=270) THEN 12.5
                                                WHEN (D1.DEBT_PERIOD>270) AND (D1.DEBT_PERIOD<=360) THEN 14.5
                                                ELSE 17.0
                                               END
                    WHEN (@EFFICIENCY>=5.0) 
                     AND (@EFFICIENCY<10.0) THEN CASE 
                                                WHEN (D1.DEBT_PERIOD<90) THEN 0.0
                                                WHEN (D1.DEBT_PERIOD>=90) AND (D1.DEBT_PERIOD<=180) THEN 12.5
                                                WHEN (D1.DEBT_PERIOD>180) AND (D1.DEBT_PERIOD<=270) THEN 14.5
                                                WHEN (D1.DEBT_PERIOD>270) AND (D1.DEBT_PERIOD<=360) THEN 17.0
                                                ELSE 20.0
                                               END
                    WHEN (@EFFICIENCY>=10.0) 
                     AND (@EFFICIENCY<15.0) THEN CASE 
                                                WHEN (D1.DEBT_PERIOD<90) THEN 0.0
                                                WHEN (D1.DEBT_PERIOD>=90) AND (D1.DEBT_PERIOD<=180) THEN 14.5
                                                WHEN (D1.DEBT_PERIOD>180) AND (D1.DEBT_PERIOD<=270) THEN 17.0
                                                WHEN (D1.DEBT_PERIOD>270) AND (D1.DEBT_PERIOD<=360) THEN 20.0
                                                ELSE 23.0
                                               END
                    WHEN (@EFFICIENCY>=15.0) THEN CASE 
                                                WHEN (D1.DEBT_PERIOD<90) THEN 0.0
                                                WHEN (D1.DEBT_PERIOD>=90) AND (D1.DEBT_PERIOD<=180) THEN 17.0
                                                WHEN (D1.DEBT_PERIOD>180) AND (D1.DEBT_PERIOD<=270) THEN 20.0
                                                WHEN (D1.DEBT_PERIOD>270) AND (D1.DEBT_PERIOD<=360) THEN 23.0
                                                ELSE 25.5
                                               END
                  END)AS COST_SERVICE
  
            FROM /*PREFIX*/DEALS D
            JOIN /*PREFIX*/DEBTORS DB ON DB.DEBTOR_ID=D.DEBTOR_ID
            JOIN (SELECT DEAL_ID, ARREAR_PERIOD+DATEDIFF(DAY,DATE_ISSUE,CURRENT_TIMESTAMP) AS DEBT_PERIOD 
                    FROM /*PREFIX*/DEALS) AS D1 ON D1.DEAL_ID=D.DEAL_ID
            LEFT JOIN (SELECT DEAL_ID, SUM(AMOUNT) AS AMOUNT 
                         FROM /*PREFIX*/PAYMENTS 
                        WHERE STATE=1
                          AND DATE_PAYMENT>=@MIN_DATE 
                          AND DATE_PAYMENT<=@MAX_DATE 
                        GROUP BY DEAL_ID)AS P1 ON P1.DEAL_ID=D.DEAL_ID
           WHERE D.AGREEMENT_ID=@AGREEMENT_ID
             AND D.DATE_CLOSE IS NULL 
      FOR READ ONLY;

  OPEN CUR;

  FETCH NEXT FROM CUR
  INTO @DEBTOR_NUM,@DATE_DEBT,@DEBTOR_NAME,@DEBT_PERIOD,@AMOUNT_ARRIVAL,
       @COST_SERVICE;

  WHILE @@FETCH_STATUS=0 BEGIN
    
    IF (@AMOUNT_ARRIVAL>0.0) BEGIN

      SET @FIXED_PART=0.0; 
     
      SET @VARIABLE_PART=@AMOUNT_ARRIVAL*@COST_SERVICE/100;

      SET @AMOUNT_REMUNERATION=@FIXED_PART+@VARIABLE_PART;

      INSERT INTO #CALC_EFFICIENCY_ROUBLE (DEBTOR_NUM,DATE_DEBT,DEBTOR_NAME,DEBT_PERIOD,AMOUNT_ARRIVAL,
                                           COST_SERVICE,FIXED_PART,VARIABLE_PART,AMOUNT_REMUNERATION)
           VALUES (@DEBTOR_NUM,@DATE_DEBT,@DEBTOR_NAME,@DEBT_PERIOD,@AMOUNT_ARRIVAL,
                   @COST_SERVICE,@FIXED_PART,@VARIABLE_PART,@AMOUNT_REMUNERATION);
    END;

    FETCH NEXT FROM CUR 
    INTO @DEBTOR_NUM,@DATE_DEBT,@DEBTOR_NAME,@DEBT_PERIOD,@AMOUNT_ARRIVAL,
         @COST_SERVICE;
  END;

  CLOSE CUR;
  DEALLOCATE CUR;

  SET NOCOUNT OFF;

  SELECT * FROM #CALC_EFFICIENCY_ROUBLE
   ORDER BY DEBTOR_NAME;

  DROP TABLE #CALC_EFFICIENCY_ROUBLE; 
END;
