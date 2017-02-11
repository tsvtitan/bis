SELECT T.* FROM (
SELECT OP.OBJECT_ID,PO.PUBLISHING_ID,P.NAME AS PUBLISHING_NAME,O.VIEW_ID,V.NAME AS VIEW_NAME,O.TYPE_ID,T.NAME AS TYPE_NAME,O.OPERATION_ID,
OT.NAME AS OPERATION_NAME,PO.DATE_BEGIN,O.ACCOUNT_ID,A.USER_NAME,A.PHONE,IFNULL(MIN(IF(OP.PARAM_ID='0538CA0399AB9FA9468D1A4741BA5090',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '�����',IFNULL(MIN(IF(OP.PARAM_ID='CE659B2F7353BD004164E11CF5B84711',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '����',IFNULL(MIN(IF(OP.PARAM_ID='AF5827387B5B969945648D50FA542E63',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '����.',IFNULL(MIN(IF(OP.PARAM_ID='D2744730B67587E64F188F456B71BC0B',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '��������',IFNULL(MIN(IF(OP.PARAM_ID='E7F33B7C110F96E240BC3C739F3172EB',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '�����',CONCAT(IFNULL(MIN(IF(OP.PARAM_ID='A753A13C38F2846842B225E8FE9608F5',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')),IFNULL(MIN(IF(OP.PARAM_ID='93B2E581C50EAC7B4D4F7610B78639E9',
CONCAT('/',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('/','')),IFNULL(MIN(IF(OP.PARAM_ID='1B5C7024F91CA674453748230A848286',
CONCAT('/',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('/',''))) AS '��, �2',IFNULL(MIN(IF(OP.PARAM_ID='776FCE172335B3F444FE4225ACC8C543',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '���',CONCAT(IFNULL(MIN(IF(OP.PARAM_ID='A1BF4E0914809A1C4669F69D1477F627',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')),IFNULL(MIN(IF(OP.PARAM_ID='A7E7C7A7C184956443532919F7C4852E',
CONCAT('/',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('/',''))) AS '����',IFNULL(MIN(IF(OP.PARAM_ID='214045FA4B538BC2408FBE3C2201BA9A',
CONCAT('',CONVERT(OP.VALUE USING cp1251),''),NULL)),CONCAT('','')) AS '����' 
FROM /*PREFIX*/OBJECT_PARAMS OP JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=OP.OBJECT_ID JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=O.ACCOUNT_ID 
JOIN /*PREFIX*/PUBLISHING_OBJECTS PO ON PO.OBJECT_ID=OP.OBJECT_ID JOIN /*PREFIX*/PUBLISHING P ON P.PUBLISHING_ID=PO.PUBLISHING_ID 
JOIN /*PREFIX*/VIEWS V ON V.VIEW_ID=O.VIEW_ID JOIN /*PREFIX*/TYPES T ON T.TYPE_ID=O.TYPE_ID 
JOIN /*PREFIX*/OPERATIONS OT ON OT.OPERATION_ID=O.OPERATION_ID WHERE OP.PARAM_ID IN ('0538CA0399AB9FA9468D1A4741BA5090',
'CE659B2F7353BD004164E11CF5B84711','AF5827387B5B969945648D50FA542E63','D2744730B67587E64F188F456B71BC0B','E7F33B7C110F96E240BC3C739F3172EB',
'A753A13C38F2846842B225E8FE9608F5','93B2E581C50EAC7B4D4F7610B78639E9','1B5C7024F91CA674453748230A848286','776FCE172335B3F444FE4225ACC8C543',
'A1BF4E0914809A1C4669F69D1477F627','A7E7C7A7C184956443532919F7C4852E','214045FA4B538BC2408FBE3C2201BA9A') 
AND OP.DATE_CREATE=(SELECT MAX(DATE_CREATE) FROM /*PREFIX*/OBJECT_PARAMS WHERE PARAM_ID=OP.PARAM_ID AND OBJECT_ID=O.OBJECT_ID) 
AND PO.PUBLISHING_ID IS NULL AND PO.DATE_BEGIN>=DATE_ADD(CURRENT_TIMESTAMP,INTERVAL -1 MONTH) 
AND (PO.DATE_END IS NULL OR PO.DATE_END>=CURRENT_TIMESTAMP) AND O.STATUS=1 
GROUP BY OP.OBJECT_ID, PO.PUBLISHING_ID ORDER BY PO.DATE_BEGIN DESC) T 
WHERE `�����`=1 ORDER BY `�����`