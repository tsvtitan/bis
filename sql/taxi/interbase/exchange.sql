/* �������� ���������� ������� */

SELECT * FROM /*PREFIX*/LOCALITIES

--

/* �������� ���� */

SELECT * FROM /*PREFIX*/STREETS

--

/* �������� ����� ����������� */

SELECT * FROM /*PREFIX*/FIRM_TYPES

--

/* �������� ����������� */

SELECT * FROM /*PREFIX*/FIRMS

--

/* �������� ������� ������� */

SELECT * FROM /*PREFIX*/ACCOUNTS

--

/* �������� ���������� */

SELECT * FROM /*PREFIX*/APPLICATIONS

--

/* �������� �������� */

SELECT * FROM /*PREFIX*/PROFILES

--

/* �������� ����� ������� ������� */

SELECT * FROM /*PREFIX*/ACCOUNT_ROLES

--

/* �������� ������ */

SELECT * FROM /*PREFIX*/SESSIONS

--

/* �������� ���������� */

SELECT * FROM /*PREFIX*/LOCKS

--

/* �������� ���������� */

SELECT * FROM /*PREFIX*/ALARMS

--

/* �������� �������� */

SELECT * FROM /*PREFIX*/CONSTS

--

/* �������� ������ */

SELECT * FROM /*PREFIX*/EXCHANGES

--

/* �������� ����������� */

SELECT * FROM /*PREFIX*/INTERFACES

--

/* �������� �������� */

SELECT * FROM /*PREFIX*/SCRIPTS

--

/* �������� ������� */

SELECT * FROM /*PREFIX*/REPORTS

--

/* �������� ���������� */

SELECT * FROM /*PREFIX*/DOCUMENTS

--

/* �������� ������� */

SELECT * FROM /*PREFIX*/TASKS

--

/* �������� ���� */

SELECT * FROM /*PREFIX*/MENUS
ORDER BY "LEVEL"

--

/* �������� ���� ���������� */

SELECT * FROM /*PREFIX*/APPLICATION_MENUS

--

/* �������� ���� ������� */

SELECT * FROM /*PREFIX*/PERMISSIONS

--

/* �������� ����������� ���������� */

SELECT * FROM /*PREFIX*/APPLICATION_INTERFACES

--

/* �������� ������� �������� */

SELECT * FROM /*PREFIX*/JOURNAL_ACTIONS

--

/* �������� ������� ������ */

SELECT * FROM /*PREFIX*/BLACKS

--

/* �������� ����� ����������� */

SELECT * FROM /*PREFIX*/CAR_TYPES

--

/* �������� ����������� */

SELECT * FROM /*PREFIX*/CARS

--

/* �������� �������� */

SELECT * FROM /*PREFIX*/CALCS

--

/* �������� ��������� */

SELECT * FROM /*PREFIX*/DRIVERS

--

/* �������� ���� */

SELECT * FROM /*PREFIX*/SHIFTS
WHERE DATE_BEGIN<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))

--

/* �������� ����������� */

SELECT * FROM /*PREFIX*/DISPATCHERS

--

/* �������� ����� ����������� */

SELECT * FROM /*PREFIX*/RECEIPT_TYPES

--

/* �������� ����������� */

SELECT * FROM /*PREFIX*/RECEIPTS
 WHERE DATE_RECEIPT<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
   AND RECEIPT_TYPE_ID<>'41C4384E4D878D7947BCDB2C69681382' 

--

/* �������� ����� �������� */

SELECT * FROM /*PREFIX*/CHARGE_TYPES

--

/* �������� �������� */

SELECT * FROM /*PREFIX*/CHARGES
 WHERE DATE_CHARGE<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
   AND CHARGE_TYPE_ID<>'07BA0951D3B0A2984307761888D416F6' 


--

/* �������� ������ */

SELECT * FROM /*PREFIX*/DISCOUNTS

--

/* �������� ������ ����������� */

SELECT * FROM /*PREFIX*/FIRM_DISCOUNTS

--

/* �������� �������� ����� */

SELECT * FROM /*PREFIX*/MAP_OBJECTS

--

/* �������� ������� */

SELECT * FROM /*PREFIX*/RATES

--

/* �������� ���������� */

SELECT * FROM /*PREFIX*/SOURCES

--

/* �������� ����� */

SELECT * FROM /*PREFIX*/SERVICES

--

/* �������� �������� */

SELECT * FROM /*PREFIX*/ACTIONS

--

/* �������� ����������� */

SELECT * FROM /*PREFIX*/RESULTS

--

/* �������� ������� */

SELECT * FROM /*PREFIX*/PARKS

--

/* �������� ��������� ������� */

SELECT * FROM /*PREFIX*/PARK_STATES
WHERE DATE_IN<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))

--

/* �������� ��� */

SELECT * FROM /*PREFIX*/ZONES

--

/* �������� ��������� ������� */

SELECT * FROM /*PREFIX*/COSTS

--

/* �������� ������� ��� */

SELECT * FROM /*PREFIX*/COMPOSITIONS

--

/* �������� ��������� ������ */

SELECT * FROM /*PREFIX*/ZONE_PARKS

--

/* �������� ������� */

SELECT * FROM /*PREFIX*/ORDERS
WHERE DATE_ACCEPT<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
  AND PARENT_ID IS NULL

--

/* �������� ������� ������� */

SELECT * FROM /*PREFIX*/ORDERS
WHERE DATE_ACCEPT<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
  AND PARENT_ID IS NOT NULL

--

/* �������� ��������� */

SELECT * FROM /*PREFIX*/ROUTES
WHERE ORDER_ID IN (SELECT ORDER_ID FROM /*PREFIX*/ORDERS
                    WHERE DATE_ACCEPT<(SELECT DATE_TO FROM GET_DATE_TO(1)))

--

/* �������� ����� ������� */

SELECT * FROM /*PREFIX*/ORDER_SERVICES
WHERE ORDER_ID IN (SELECT ORDER_ID FROM /*PREFIX*/ORDERS
                    WHERE DATE_ACCEPT<(SELECT DATE_TO FROM GET_DATE_TO(1)))

--

/* �������� �������� ��������� */

SELECT * FROM /*PREFIX*/PATTERN_MESSAGES

--

/* �������� ��������� ��������� */

SELECT * FROM /*PREFIX*/OUT_MESSAGES
WHERE DATE_CREATE<(SELECT DATE_TO FROM GET_DATE_TO(1))

--

/* �������� ����� ��������� */

SELECT * FROM /*PREFIX*/CODE_MESSAGES

--

/* �������� �������� ��������� */

SELECT * FROM /*PREFIX*/IN_MESSAGES
WHERE DATE_SEND<(SELECT DATE_TO FROM GET_DATE_TO(1))

--
