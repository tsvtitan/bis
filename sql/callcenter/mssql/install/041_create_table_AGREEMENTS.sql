/* �������� ������� ��������� */

CREATE TABLE /*PREFIX*/AGREEMENTS
(
  AGREEMENT_ID VARCHAR(32) NOT NULL,
  FIRM_ID VARCHAR(32) NOT NULL,
  VARIANT_ID VARCHAR(32) NOT NULL,
  PARENT_ID VARCHAR(32),
  NUM VARCHAR(100) NOT NULL,
  DATE_BEGIN DATETIME NOT NULL,
  DATE_END DATETIME,
  PRIMARY KEY (AGREEMENT_ID),
  FOREIGN KEY (FIRM_ID) REFERENCES /*PREFIX*/FIRMS (FIRM_ID),
  FOREIGN KEY (VARIANT_ID) REFERENCES /*PREFIX*/VARIANTS (VARIANT_ID),
  FOREIGN KEY (PARENT_ID) REFERENCES /*PREFIX*/AGREEMENTS (AGREEMENT_ID)
)

--

/* �������� ��������� ������� ��������� */

CREATE VIEW /*PREFIX*/S_AGREEMENTS
AS
  SELECT A.*, 
         F.SMALL_NAME AS FIRM_SMALL_NAME,
         V.NAME AS VARIANT_NAME,
         A1.NUM AS PARENT_NUM
    FROM /*PREFIX*/AGREEMENTS A
    JOIN /*PREFIX*/FIRMS F ON A.FIRM_ID=F.FIRM_ID
    JOIN /*PREFIX*/VARIANTS V ON A.VARIANT_ID=V.VARIANT_ID
    LEFT JOIN /*PREFIX*/AGREEMENTS A1 ON A1.AGREEMENT_ID=A.PARENT_ID
--

/* �������� ��������� ���������� �������� */

CREATE PROCEDURE /*PREFIX*/I_AGREEMENT
  @AGREEMENT_ID VARCHAR(32),
  @FIRM_ID VARCHAR(32),
  @VARIANT_ID VARCHAR(32),
  @PARENT_ID VARCHAR(32),
  @NUM VARCHAR(100),
  @DATE_BEGIN DATETIME,
  @DATE_END DATETIME
AS
BEGIN
  INSERT INTO /*PREFIX*/AGREEMENTS (AGREEMENT_ID,FIRM_ID,VARIANT_ID,PARENT_ID,NUM,DATE_BEGIN,DATE_END)
       VALUES (@AGREEMENT_ID,@FIRM_ID,@VARIANT_ID,@PARENT_ID,@NUM,@DATE_BEGIN,@DATE_END);
END;

--

/* �������� ��������� ��������� �������� */

CREATE PROCEDURE /*PREFIX*/U_AGREEMENT
  @AGREEMENT_ID VARCHAR(32),
  @FIRM_ID VARCHAR(32),
  @VARIANT_ID VARCHAR(32),
  @PARENT_ID VARCHAR(32),
  @NUM VARCHAR(100),
  @DATE_BEGIN DATETIME,
  @DATE_END DATETIME,
  @OLD_AGREEMENT_ID VARCHAR(32)
AS
BEGIN
  UPDATE /*PREFIX*/AGREEMENTS
     SET AGREEMENT_ID=@AGREEMENT_ID,
         FIRM_ID=@FIRM_ID,
         VARIANT_ID=@VARIANT_ID,
	 PARENT_ID=@PARENT_ID,
	 NUM=@NUM,
         DATE_BEGIN=@DATE_BEGIN,
         DATE_END=@DATE_END
   WHERE AGREEMENT_ID=@OLD_AGREEMENT_ID;
END;

--

/* �������� ��������� �������� �������� */

CREATE PROCEDURE /*PREFIX*/D_AGREEMENT
  @OLD_AGREEMENT_ID VARCHAR(32)
AS
BEGIN
  DELETE FROM /*PREFIX*/AGREEMENTS
        WHERE AGREEMENT_ID=@OLD_AGREEMENT_ID;
END;

--