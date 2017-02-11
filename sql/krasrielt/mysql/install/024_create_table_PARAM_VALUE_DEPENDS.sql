/* �������� ������� ������������ �������� ���������� */

CREATE TABLE /*PREFIX*/PARAM_VALUE_DEPENDS
(
  WHAT_PARAM_VALUE_ID VARCHAR(32) NOT NULL,
  FROM_PARAM_VALUE_ID VARCHAR(32) NOT NULL,
  PRIMARY KEY (WHAT_PARAM_VALUE_ID,FROM_PARAM_VALUE_ID),
  FOREIGN KEY (WHAT_PARAM_VALUE_ID) REFERENCES PARAM_VALUES (PARAM_VALUE_ID),
  FOREIGN KEY (FROM_PARAM_VALUE_ID) REFERENCES PARAM_VALUES (PARAM_VALUE_ID)
)

--

/* �������� ��������� ������� ������������ �������� ���������� */

CREATE VIEW /*PREFIX*/S_PARAM_VALUE_DEPENDS
AS
SELECT PVD.*,
       PV1.NAME AS WHAT_PARAM_VALUE_NAME,
       PV2.NAME AS FROM_PARAM_VALUE_NAME,
       PV1.EXPORT AS WHAT_PARAM_VALUE_EXPORT,
       PV2.EXPORT AS FROM_PARAM_VALUE_EXPORT,
			 PV1.PARAM_ID AS WHAT_PARAM_ID,
			 PV1.PRIORITY AS WHAT_PRIORITY,
			 PV2.PARAM_ID AS FROM_PARAM_ID,
			 PV2.PRIORITY AS FROM_PRIORITY,
			 P1.NAME AS WHAT_PARAM_NAME,
			 P2.NAME AS FROM_PARAM_NAME
  FROM /*PREFIX*/PARAM_VALUE_DEPENDS PVD
  JOIN /*PREFIX*/PARAM_VALUES PV1 ON PV1.PARAM_VALUE_ID=PVD.WHAT_PARAM_VALUE_ID
  JOIN /*PREFIX*/PARAM_VALUES PV2 ON PV2.PARAM_VALUE_ID=PVD.FROM_PARAM_VALUE_ID
	JOIN /*PREFIX*/PARAMS P1 ON P1.PARAM_ID=PV1.PARAM_ID
	JOIN /*PREFIX*/PARAMS P2 ON P2.PARAM_ID=PV2.PARAM_ID	

--

/* �������� ��������� ���������� ����������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/I_PARAM_VALUE_DEPEND
(
  IN WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN FROM_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  INSERT INTO /*PREFIX*/PARAM_VALUE_DEPENDS (WHAT_PARAM_VALUE_ID,FROM_PARAM_VALUE_ID)
       VALUES (WHAT_PARAM_VALUE_ID,FROM_PARAM_VALUE_ID);
END;

--

/* �������� ��������� ��������� ����������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/U_PARAM_VALUE_DEPEND
(
  IN WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN FROM_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_FROM_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PARAM_VALUE_DEPENDS PVD
     SET PVD.WHAT_PARAM_VALUE_ID=WHAT_PARAM_VALUE_ID,
         PVD.FROM_PARAM_VALUE_ID=FROM_PARAM_VALUE_ID
   WHERE PVD.WHAT_PARAM_VALUE_ID=OLD_WHAT_PARAM_VALUE_ID
	   AND PVD.FROM_PARAM_VALUE_ID=OLD_FROM_PARAM_VALUE_ID;
END;

--

/* �������� ��������� �������� ����������� �������� ��������� */

CREATE PROCEDURE /*PREFIX*/D_PARAM_VALUE_DEPEND
(
  IN OLD_WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_FROM_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PARAM_VALUE_DEPENDS 
        WHERE WHAT_PARAM_VALUE_ID=OLD_WHAT_PARAM_VALUE_ID
          AND FROM_PARAM_VALUE_ID=OLD_FROM_PARAM_VALUE_ID;
END;

--