/* Выгрузка населенных пунктов */

SELECT * FROM /*PREFIX*/LOCALITIES

--

/* Выгрузка улиц */

SELECT * FROM /*PREFIX*/STREETS

--

/* Выгрузка типов организаций */

SELECT * FROM /*PREFIX*/FIRM_TYPES

--

/* Выгрузка организаций */

SELECT * FROM /*PREFIX*/FIRMS

--

/* Выгрузка учетных записей */

SELECT * FROM /*PREFIX*/ACCOUNTS

--

/* Выгрузка приложений */

SELECT * FROM /*PREFIX*/APPLICATIONS

--

/* Выгрузка профилей */

SELECT * FROM /*PREFIX*/PROFILES

--

/* Выгрузка ролей учетных записей */

SELECT * FROM /*PREFIX*/ACCOUNT_ROLES

--

/* Выгрузка сессий */

SELECT * FROM /*PREFIX*/SESSIONS

--

/* Выгрузка блокировок */

SELECT * FROM /*PREFIX*/LOCKS

--

/* Выгрузка оповещений */

SELECT * FROM /*PREFIX*/ALARMS

--

/* Выгрузка констант */

SELECT * FROM /*PREFIX*/CONSTS

--

/* Выгрузка обмена */

SELECT * FROM /*PREFIX*/EXCHANGES

--

/* Выгрузка интерфейсов */

SELECT * FROM /*PREFIX*/INTERFACES

--

/* Выгрузка скриптов */

SELECT * FROM /*PREFIX*/SCRIPTS

--

/* Выгрузка отчетов */

SELECT * FROM /*PREFIX*/REPORTS

--

/* Выгрузка документов */

SELECT * FROM /*PREFIX*/DOCUMENTS

--

/* Выгрузка заданий */

SELECT * FROM /*PREFIX*/TASKS

--

/* Выгрузка меню */

SELECT * FROM /*PREFIX*/MENUS
ORDER BY "LEVEL"

--

/* Выгрузка меню приложений */

SELECT * FROM /*PREFIX*/APPLICATION_MENUS

--

/* Выгрузка прав доступа */

SELECT * FROM /*PREFIX*/PERMISSIONS

--

/* Выгрузка интерфейсов приложений */

SELECT * FROM /*PREFIX*/APPLICATION_INTERFACES

--

/* Выгрузка журнала действий */

SELECT * FROM /*PREFIX*/JOURNAL_ACTIONS

--

/* Выгрузка черного списка */

SELECT * FROM /*PREFIX*/BLACKS

--

/* Выгрузка типов автомобилей */

SELECT * FROM /*PREFIX*/CAR_TYPES

--

/* Выгрузка автомобилей */

SELECT * FROM /*PREFIX*/CARS

--

/* Выгрузка расчетов */

SELECT * FROM /*PREFIX*/CALCS

--

/* Выгрузка водителей */

SELECT * FROM /*PREFIX*/DRIVERS

--

/* Выгрузка смен */

SELECT * FROM /*PREFIX*/SHIFTS
WHERE DATE_BEGIN<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))

--

/* Выгрузка диспетчеров */

SELECT * FROM /*PREFIX*/DISPATCHERS

--

/* Выгрузка видов поступлений */

SELECT * FROM /*PREFIX*/RECEIPT_TYPES

--

/* Выгрузка поступлений */

SELECT * FROM /*PREFIX*/RECEIPTS
 WHERE DATE_RECEIPT<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
   AND RECEIPT_TYPE_ID<>'41C4384E4D878D7947BCDB2C69681382' 

--

/* Выгрузка видов списаний */

SELECT * FROM /*PREFIX*/CHARGE_TYPES

--

/* Выгрузка списаний */

SELECT * FROM /*PREFIX*/CHARGES
 WHERE DATE_CHARGE<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
   AND CHARGE_TYPE_ID<>'07BA0951D3B0A2984307761888D416F6' 


--

/* Выгрузка скидок */

SELECT * FROM /*PREFIX*/DISCOUNTS

--

/* Выгрузка скидок организаций */

SELECT * FROM /*PREFIX*/FIRM_DISCOUNTS

--

/* Выгрузка объектов карты */

SELECT * FROM /*PREFIX*/MAP_OBJECTS

--

/* Выгрузка тарифов */

SELECT * FROM /*PREFIX*/RATES

--

/* Выгрузка источников */

SELECT * FROM /*PREFIX*/SOURCES

--

/* Выгрузка услуг */

SELECT * FROM /*PREFIX*/SERVICES

--

/* Выгрузка действий */

SELECT * FROM /*PREFIX*/ACTIONS

--

/* Выгрузка результатов */

SELECT * FROM /*PREFIX*/RESULTS

--

/* Выгрузка стоянок */

SELECT * FROM /*PREFIX*/PARKS

--

/* Выгрузка состояния стоянок */

SELECT * FROM /*PREFIX*/PARK_STATES
WHERE DATE_IN<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))

--

/* Выгрузка зон */

SELECT * FROM /*PREFIX*/ZONES

--

/* Выгрузка стоимости поездок */

SELECT * FROM /*PREFIX*/COSTS

--

/* Выгрузка состава зон */

SELECT * FROM /*PREFIX*/COMPOSITIONS

--

/* Выгрузка стоимости подачи */

SELECT * FROM /*PREFIX*/ZONE_PARKS

--

/* Выгрузка заказов */

SELECT * FROM /*PREFIX*/ORDERS
WHERE DATE_ACCEPT<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
  AND PARENT_ID IS NULL

--

/* Выгрузка истории заказов */

SELECT * FROM /*PREFIX*/ORDERS
WHERE DATE_ACCEPT<(SELECT DATE_TO FROM /*PREFIX*/GET_DATE_TO(1))
  AND PARENT_ID IS NOT NULL

--

/* Выгрузка маршрутов */

SELECT * FROM /*PREFIX*/ROUTES
WHERE ORDER_ID IN (SELECT ORDER_ID FROM /*PREFIX*/ORDERS
                    WHERE DATE_ACCEPT<(SELECT DATE_TO FROM GET_DATE_TO(1)))

--

/* Выгрузка услуг заказов */

SELECT * FROM /*PREFIX*/ORDER_SERVICES
WHERE ORDER_ID IN (SELECT ORDER_ID FROM /*PREFIX*/ORDERS
                    WHERE DATE_ACCEPT<(SELECT DATE_TO FROM GET_DATE_TO(1)))

--

/* Выгрузка шаблонов сообщений */

SELECT * FROM /*PREFIX*/PATTERN_MESSAGES

--

/* Выгрузка исходящих сообщений */

SELECT * FROM /*PREFIX*/OUT_MESSAGES
WHERE DATE_CREATE<(SELECT DATE_TO FROM GET_DATE_TO(1))

--

/* Выгрузка кодов сообщений */

SELECT * FROM /*PREFIX*/CODE_MESSAGES

--

/* Выгрузка входящих сообщений */

SELECT * FROM /*PREFIX*/IN_MESSAGES
WHERE DATE_SEND<(SELECT DATE_TO FROM GET_DATE_TO(1))

--
