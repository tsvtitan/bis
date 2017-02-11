/* �������� ������� ����������� */

CREATE TABLE /*PREFIX*/FIRMS
(
  FIRM_ID VARCHAR2(32) NOT NULL,
  FIRM_TYPE_ID VARCHAR2(32) NOT NULL,
  PARENT_ID VARCHAR2(32),
  SMALL_NAME VARCHAR2(250) NOT NULL,
  FULL_NAME VARCHAR2(250) NOT NULL,
  INN VARCHAR2(12),
  PAYMENT_ACCOUNT VARCHAR2(20),
  BANK VARCHAR2(250),
  BIK VARCHAR2(20),
  CORR_ACCOUNT VARCHAR2(20),
  LEGAL_ADDRESS VARCHAR2(250),
  LEGAL_INDEX VARCHAR2(10),
  POST_ADDRESS VARCHAR2(250),
  POST_INDEX VARCHAR2(10),
  PHONE VARCHAR2(250),
  FAX VARCHAR2(250),
  EMAIL VARCHAR2(100),
  SITE VARCHAR2(100),
  OKONH VARCHAR2(20),
  OKPO VARCHAR2(20),
  KPP VARCHAR2(20),
  DIRECTOR VARCHAR2(250),
  ACCOUNTANT VARCHAR2(250),
  CONTACT_FACE VARCHAR2(250),
  PRIMARY KEY (FIRM_ID),
  FOREIGN KEY (FIRM_TYPE_ID) REFERENCES FIRM_TYPES (FIRM_TYPE_ID),
  FOREIGN KEY (PARENT_ID) REFERENCES FIRMS (FIRM_ID)
)

--

/* �������� ��������� ������� ����������� */

CREATE VIEW /*PREFIX*/S_FIRMS
AS
   SELECT F.*, 
          FT.NAME AS FIRM_TYPE_NAME,
          F1.SMALL_NAME AS PARENT_SMALL_NAME
     FROM /*PREFIX*/FIRMS F
     JOIN /*PREFIX*/FIRM_TYPES FT ON FT.FIRM_TYPE_ID=F.FIRM_TYPE_ID
     LEFT JOIN	/*PREFIX*/FIRMS F1 ON F1.FIRM_ID=F.PARENT_ID

--

/* �������� ��������� ���������� ����������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/I_FIRM
(
  FIRM_ID IN VARCHAR2,
  FIRM_TYPE_ID IN VARCHAR2,
  PARENT_ID IN VARCHAR2,
  SMALL_NAME IN VARCHAR2,
  FULL_NAME IN VARCHAR2,
  INN IN VARCHAR2,
  PAYMENT_ACCOUNT IN VARCHAR2,
  BANK IN VARCHAR2,
  BIK IN VARCHAR2,
  CORR_ACCOUNT IN VARCHAR2,
  LEGAL_ADDRESS IN VARCHAR2,
  LEGAL_INDEX IN VARCHAR2,
  POST_ADDRESS IN VARCHAR2,
  POST_INDEX IN VARCHAR2,
  PHONE IN VARCHAR2,
  FAX IN VARCHAR2,
  EMAIL IN VARCHAR2,
  SITE IN VARCHAR2,
  OKONH IN VARCHAR2,
  OKPO IN VARCHAR2,
  KPP IN VARCHAR2,
  DIRECTOR IN VARCHAR2,
  ACCOUNTANT IN VARCHAR2,
  CONTACT_FACE IN VARCHAR2
)
AS
BEGIN
  INSERT INTO /*PREFIX*/FIRMS (FIRM_ID,FIRM_TYPE_ID,PARENT_ID,SMALL_NAME,FULL_NAME,INN,PAYMENT_ACCOUNT,
                               BANK,BIK,CORR_ACCOUNT,LEGAL_ADDRESS,LEGAL_INDEX,POST_ADDRESS,POST_INDEX,
                               PHONE,FAX,EMAIL,SITE,OKONH,OKPO,KPP,DIRECTOR,ACCOUNTANT,CONTACT_FACE)
       VALUES (FIRM_ID,FIRM_TYPE_ID,PARENT_ID,SMALL_NAME,FULL_NAME,INN,PAYMENT_ACCOUNT,
               BANK,BIK,CORR_ACCOUNT,LEGAL_ADDRESS,LEGAL_INDEX,POST_ADDRESS,POST_INDEX,
               PHONE,FAX,EMAIL,SITE,OKONH,OKPO,KPP,DIRECTOR,ACCOUNTANT,CONTACT_FACE);
END;

--

/* �������� ��������� ��������� ����������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/U_FIRM
(
  FIRM_ID IN VARCHAR2,
  FIRM_TYPE_ID IN VARCHAR2,
  PARENT_ID IN VARCHAR2,
  SMALL_NAME IN VARCHAR2,
  FULL_NAME IN VARCHAR2,
  INN IN VARCHAR2,
  PAYMENT_ACCOUNT IN VARCHAR2,
  BANK IN VARCHAR2,
  BIK IN VARCHAR2,
  CORR_ACCOUNT IN VARCHAR2,
  LEGAL_ADDRESS IN VARCHAR2,
  LEGAL_INDEX IN VARCHAR2,
  POST_ADDRESS IN VARCHAR2,
  POST_INDEX IN VARCHAR2,
  PHONE IN VARCHAR2,
  FAX IN VARCHAR2,
  EMAIL IN VARCHAR2,
  SITE IN VARCHAR2,
  OKONH IN VARCHAR2,
  OKPO IN VARCHAR2,
  KPP IN VARCHAR2,
  DIRECTOR IN VARCHAR2,
  ACCOUNTANT IN VARCHAR2,
  CONTACT_FACE IN VARCHAR2,
  OLD_FIRM_ID IN VARCHAR2
)
AS
BEGIN
  UPDATE /*PREFIX*/FIRMS
     SET FIRM_ID=U_FIRM.FIRM_ID,
         FIRM_TYPE_ID=U_FIRM.FIRM_TYPE_ID,
		 PARENT_ID=U_FIRM.PARENT_ID,
		 SMALL_NAME=U_FIRM.SMALL_NAME,
		 FULL_NAME=U_FIRM.FULL_NAME,
		 INN=U_FIRM.INN,
		 PAYMENT_ACCOUNT=U_FIRM.PAYMENT_ACCOUNT,
                 BANK=U_FIRM.BANK,
		 BIK=U_FIRM.BIK,
		 CORR_ACCOUNT=U_FIRM.CORR_ACCOUNT,
                 LEGAL_ADDRESS=U_FIRM.LEGAL_ADDRESS,
                 LEGAL_INDEX=U_FIRM.LEGAL_INDEX,
                 POST_ADDRESS=U_FIRM.POST_ADDRESS,
                 POST_INDEX=U_FIRM.POST_INDEX,
		 PHONE=U_FIRM.PHONE,
		 FAX=U_FIRM.FAX,
		 EMAIL=U_FIRM.EMAIL,
		 SITE=U_FIRM.SITE,
  		 OKONH=U_FIRM.OKONH,
		 OKPO=U_FIRM.OKPO,
		 KPP=U_FIRM.KPP,
		 DIRECTOR=U_FIRM.DIRECTOR,
		 ACCOUNTANT=U_FIRM.ACCOUNTANT,
		 CONTACT_FACE=U_FIRM.CONTACT_FACE
   WHERE FIRM_ID=OLD_FIRM_ID;
END;

--

/* �������� ��������� �������� ����������� */

CREATE OR REPLACE PROCEDURE /*PREFIX*/D_FIRM
(
  OLD_FIRM_ID IN VARCHAR2
)
AS
BEGIN
  DELETE FROM /*PREFIX*/FIRMS
        WHERE FIRM_ID=OLD_FIRM_ID;
END;

--

/* �������� ��������� */

COMMIT