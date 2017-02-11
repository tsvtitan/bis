/* �������� ������� �������� */

CREATE TABLE /*PREFIX*/PAYMENTS
(
  PAYMENT_ID VARCHAR(32) NOT NULL,
  ACCOUNT_ID VARCHAR(32) NOT NULL,
  DEAL_ID VARCHAR(32) NOT NULL,
  DATE_PAYMENT DATETIME NOT NULL,
  AMOUNT FLOAT NOT NULL,
  PERIOD INTEGER NOT NULL,
  STATE INTEGER NOT NULL,
  DESCRIPTION VARCHAR(250),  
  PRIMARY KEY (PAYMENT_ID),
  FOREIGN KEY (ACCOUNT_ID) REFERENCES /*PREFIX*/ACCOUNTS (ACCOUNT_ID),
  FOREIGN KEY (DEAL_ID) REFERENCES /*PREFIX*/DEALS (DEAL_ID)
)

--

/* �������� ��������� ������� �������� */

CREATE VIEW /*PREFIX*/S_PAYMENTS
AS
   SELECT P.*, 
          A.USER_NAME,
          D.DEAL_NUM
     FROM /*PREFIX*/PAYMENTS P
     JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=P.ACCOUNT_ID
     JOIN /*PREFIX*/DEALS D ON D.DEAL_ID=P.DEAL_ID

--

/* �������� ��������� ���������� ������� */

CREATE PROCEDURE /*PREFIX*/I_PAYMENT
  @PAYMENT_ID VARCHAR(32),
  @ACCOUNT_ID VARCHAR(32),
  @DEAL_ID VARCHAR(32),
  @DATE_PAYMENT DATETIME,
  @AMOUNT FLOAT,
  @PERIOD INTEGER,
  @STATE INTEGER,
  @DESCRIPTION VARCHAR(250)  
AS
BEGIN
  INSERT INTO /*PREFIX*/PAYMENTS (PAYMENT_ID,ACCOUNT_ID,DEAL_ID,DATE_PAYMENT,
                                  AMOUNT,PERIOD,STATE,DESCRIPTION)
       VALUES (@PAYMENT_ID,@ACCOUNT_ID,@DEAL_ID,@DATE_PAYMENT,
               @AMOUNT,@PERIOD,@STATE,@DESCRIPTION);
END;

--

/* �������� ��������� ��������� ������� */

CREATE PROCEDURE /*PREFIX*/U_PAYMENT
  @PAYMENT_ID VARCHAR(32),
  @ACCOUNT_ID VARCHAR(32),
  @DEAL_ID VARCHAR(32),
  @DATE_PAYMENT DATETIME,
  @AMOUNT FLOAT,
  @PERIOD INTEGER,
  @STATE INTEGER,
  @DESCRIPTION VARCHAR(250),
  @OLD_PAYMENT_ID VARCHAR(32)
AS
BEGIN
  UPDATE /*PREFIX*/PAYMENTS
     SET PAYMENT_ID=@PAYMENT_ID,
         ACCOUNT_ID=@ACCOUNT_ID,
         DEAL_ID=@DEAL_ID,
         DATE_PAYMENT=@DATE_PAYMENT,
         AMOUNT=@AMOUNT,
         PERIOD=@PERIOD,
         STATE=@STATE,
         DESCRIPTION=@DESCRIPTION
   WHERE PAYMENT_ID=@OLD_PAYMENT_ID;
END;

--

/* �������� ��������� �������� ������� */

CREATE PROCEDURE /*PREFIX*/D_PAYMENT
  @OLD_PAYMENT_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/PAYMENTS
        WHERE PAYMENT_ID=@OLD_PAYMENT_ID;
END;

--