/* �������� ��������� ���������� ������� ������ */

CREATE PROCEDURE /*PREFIX*/LOCK_ACCOUNT
(
  ACCOUNT_ID VARCHAR(32)
)
AS
BEGIN

  UPDATE /*PREFIX*/ACCOUNTS
     SET LOCKED=1
   WHERE ACCOUNT_ID=:ACCOUNT_ID;

END

--

/* �������� ��������� */

COMMIT