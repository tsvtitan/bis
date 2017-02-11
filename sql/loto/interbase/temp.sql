
SELECT F1_01,F1_02,F1_03,F1_04,F1_05,F1_06,F1_07,F1_08,F1_09
  FROM /*PREFIX*/TICKETS T
 WHERE TIRAGE_ID='635CECDFF74AB3D54C74D7F58727E537'
   AND ((F1_01 IN ('1','2','3','4','5') OR F1_01 IS NULL)  AND
        (F1_02 IN ('1','2','3','4','5') OR F1_02 IS NULL)  AND
        (F1_03 IN ('1','2','3','4','5') OR F1_03 IS NULL)  AND
        (F1_04 IN ('1','2','3','4','5') OR F1_04 IS NULL)  AND
        (F1_05 IN ('1','2','3','4','5') OR F1_05 IS NULL)  AND
        (F1_06 IN ('1','2','3','4','5') OR F1_06 IS NULL)  AND
        (F1_07 IN ('1','2','3','4','5') OR F1_07 IS NULL)  AND
        (F1_08 IN ('1','2','3','4','5') OR F1_08 IS NULL)  AND
        (F1_09 IN ('1','2','3','4','5') OR F1_09 IS NULL))

UNION ALL

SELECT F2_01,F2_02,F2_03,F2_04,F2_05,F2_06,F2_07,F2_08,F2_09
  FROM /*PREFIX*/TICKETS T
 WHERE TIRAGE_ID='635CECDFF74AB3D54C74D7F58727E537'
   AND ((F2_01 IN ('1','2','3','4','5') OR F2_01 IS NULL)  AND
        (F2_02 IN ('1','2','3','4','5') OR F2_02 IS NULL)  AND
        (F2_03 IN ('1','2','3','4','5') OR F2_03 IS NULL)  AND
        (F2_04 IN ('1','2','3','4','5') OR F2_04 IS NULL)  AND
        (F2_05 IN ('1','2','3','4','5') OR F2_05 IS NULL)  AND
        (F2_06 IN ('1','2','3','4','5') OR F2_06 IS NULL)  AND
        (F2_07 IN ('1','2','3','4','5') OR F2_07 IS NULL)  AND
        (F2_08 IN ('1','2','3','4','5') OR F2_08 IS NULL)  AND
        (F2_09 IN ('1','2','3','4','5') OR F2_09 IS NULL))

UNION ALL

SELECT F3_01,F3_02,F3_03,F3_04,F3_05,F3_06,F3_07,F3_08,F3_09
  FROM /*PREFIX*/TICKETS T
 WHERE TIRAGE_ID='635CECDFF74AB3D54C74D7F58727E537'
   AND ((F3_01 IN ('1','2','3','4','5') OR F3_01 IS NULL)  AND
        (F3_02 IN ('1','2','3','4','5') OR F3_02 IS NULL)  AND
        (F3_03 IN ('1','2','3','4','5') OR F3_03 IS NULL)  AND
        (F3_04 IN ('1','2','3','4','5') OR F3_04 IS NULL)  AND
        (F3_05 IN ('1','2','3','4','5') OR F3_05 IS NULL)  AND
        (F3_06 IN ('1','2','3','4','5') OR F3_06 IS NULL)  AND
        (F3_07 IN ('1','2','3','4','5') OR F3_07 IS NULL)  AND
        (F3_08 IN ('1','2','3','4','5') OR F3_08 IS NULL)  AND
        (F3_09 IN ('1','2','3','4','5') OR F3_09 IS NULL))

UNION ALL

SELECT
       (CASE WHEN F4_01 IS NULL THEN '' ELSE F4_01 END)||'-'||
       (CASE WHEN F4_02 IS NULL THEN '' ELSE F4_02 END)||'-'||
       (CASE WHEN F4_03 IS NULL THEN '' ELSE F4_03 END)||'-'||
       (CASE WHEN F4_04 IS NULL THEN '' ELSE F4_04 END)||'-'||
       (CASE WHEN F4_05 IS NULL THEN '' ELSE F4_05 END)||'-'||
       (CASE WHEN F4_06 IS NULL THEN '' ELSE F4_06 END)||'-'||
       (CASE WHEN F4_07 IS NULL THEN '' ELSE F4_07 END)||'-'||
       (CASE WHEN F4_08 IS NULL THEN '' ELSE F4_08 END)||'-'||
       (CASE WHEN F4_09 IS NULL THEN '' ELSE F4_09 END)

  FROM /*PREFIX*/TICKETS T
 WHERE TIRAGE_ID='635CECDFF74AB3D54C74D7F58727E537'
   AND ((F4_01 IN ('6','2','3','4','5') OR F4_01 IS NULL)  AND
        (F4_02 IN ('6','2','3','4','5') OR F4_02 IS NULL)  AND
        (F4_03 IN ('6','2','3','4','5') OR F4_03 IS NULL)  AND
        (F4_04 IN ('6','2','3','4','5') OR F4_04 IS NULL)  AND
        (F4_05 IN ('6','2','3','4','5') OR F4_05 IS NULL)  AND
        (F4_06 IN ('6','2','3','4','5') OR F4_06 IS NULL)  AND
        (F4_07 IN ('6','2','3','4','5') OR F4_07 IS NULL)  AND
        (F4_08 IN ('6','2','3','4','5') OR F4_08 IS NULL)  AND
        (F4_09 IN ('6','2','3','4','5') OR F4_09 IS NULL))

