/* �������� ��������� ��������� ������ ������� */

CREATE PROCEDURE /*PREFIX*/GET_CLIENT_USER_NAME
RETURNS
(
  USER_NAME VARCHAR(10)
)
AS
BEGIN
  SELECT GEN_ID(/*PREFIX*/GEN_CLIENT_USER_NAME,1)
    FROM RDB$DATABASE
    INTO USER_NAME;
END

--

/* �������� ��������� */

COMMIT