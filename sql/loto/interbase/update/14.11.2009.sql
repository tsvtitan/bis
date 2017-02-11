/* ���������� ��������� ��������� ������� �� ����� */

ALTER PROCEDURE /*PREFIX*/GET_TICKET_LINE
(
  TIRAGE_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32),
  ROUND_NUM INTEGER,
  ROUND_NUM_EX INTEGER,
  LINE_NUM INTEGER
)
RETURNS
(
  TICKET_ID VARCHAR(32)
)
AS
  DECLARE SQL VARCHAR(2000);
  DECLARE S VARCHAR(250);
  DECLARE F VARCHAR(10);
  DECLARE FN VARCHAR(15);
  DECLARE I INTEGER;
  DECLARE BARREL_NUM VARCHAR(2);
BEGIN

  F='F'||CAST(LINE_NUM AS VARCHAR(10));

  SQL='SELECT TICKET_ID FROM /*PREFIX*/TICKETS '||
      ' WHERE TIRAGE_ID='''||TIRAGE_ID||''' AND NOT_USED=0 '||
      '   AND (CAST(NUM AS INTEGER)<45001 OR CAST(NUM AS INTEGER)>65000) ';

  S='';

  IF (PRIZE_ID IS NOT NULL) THEN BEGIN
    FOR SELECT BARREL_NUM
          FROM /*PREFIX*/LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND PRIZE_ID=:PRIZE_ID
           AND ROUND_NUM IN (:ROUND_NUM,:ROUND_NUM_EX)
         ORDER BY INPUT_DATE
          INTO :BARREL_NUM DO BEGIN
      IF (S='') THEN BEGIN
        S=''''||BARREL_NUM||'''';
      END ELSE BEGIN
        S=S||','''||BARREL_NUM||'''';
      END
    END
  END ELSE BEGIN
    FOR SELECT BARREL_NUM
          FROM /*PREFIX*/LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND PRIZE_ID IS NULL
           AND ROUND_NUM IN (:ROUND_NUM,:ROUND_NUM_EX)
         ORDER BY INPUT_DATE
          INTO :BARREL_NUM DO BEGIN
      IF (S='') THEN BEGIN
        S=''''||BARREL_NUM||'''';
      END ELSE BEGIN
        S=S||','''||BARREL_NUM||'''';
      END
    END
  END

  IF (S<>'') THEN BEGIN

    SQL=SQL||'AND (';
    I=1;
    WHILE (I<10) DO BEGIN
      FN=F||'_0'||CAST(I AS VARCHAR(1));
      SQL=SQL||'('||FN||' IN ('||S||') OR '||FN||' IS NULL)';
      IF (I<9) THEN BEGIN
        SQL=SQL||' AND ';
      END
      I=I+1;
    END
    SQL=SQL||')';

    FOR EXECUTE STATEMENT SQL
                     INTO :TICKET_ID DO BEGIN
      SUSPEND;
    END

  END

END;

--

/* ��������� ��������� ��������� ������� �� ����� */

ALTER PROCEDURE /*PREFIX*/GET_TICKET_SERIES
(
  TIRAGE_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32),
  ROUND_NUM INTEGER
)
RETURNS
(
  TICKET_ID VARCHAR(32)
)
AS
  DECLARE SQL VARCHAR(2000);
  DECLARE S VARCHAR(250);
  DECLARE BARREL_NUM VARCHAR(2);
BEGIN

  SQL='SELECT TICKET_ID FROM /*PREFIX*/TICKETS '||
      ' WHERE TIRAGE_ID='''||TIRAGE_ID||''' AND NOT_USED=0 '||
      '   AND (CAST(NUM AS INTEGER)<45001 OR CAST(NUM AS INTEGER)>65000) ';

  S='';

  IF (PRIZE_ID IS NOT NULL) THEN BEGIN
    FOR SELECT BARREL_NUM
          FROM /*PREFIX*/LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND PRIZE_ID=:PRIZE_ID
           AND ROUND_NUM=:ROUND_NUM
         ORDER BY INPUT_DATE
          INTO :BARREL_NUM DO BEGIN
      IF (S='') THEN BEGIN
        S=BARREL_NUM;
      END ELSE BEGIN
        S=S||BARREL_NUM;
      END
    END
  END ELSE BEGIN
    FOR SELECT BARREL_NUM
          FROM /*PREFIX*/LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND PRIZE_ID IS NULL
           AND ROUND_NUM=:ROUND_NUM
         ORDER BY INPUT_DATE
          INTO :BARREL_NUM DO BEGIN
      IF (S='') THEN BEGIN
        S=BARREL_NUM;
      END ELSE BEGIN
        S=S||BARREL_NUM;
      END
    END
  END

  IF (S<>'') THEN BEGIN

    SQL=SQL||'AND SERIES LIKE '''||S||'%'' ';

    FOR EXECUTE STATEMENT SQL
                     INTO :TICKET_ID DO BEGIN
      SUSPEND;

    END

  END

END;

--

/* ��������� ��������� ��������� ������� �� ������ */

ALTER PROCEDURE /*PREFIX*/GET_TICKET_NUM
(
  TIRAGE_ID VARCHAR(32),
  PRIZE_ID VARCHAR(32),
  ROUND_NUM INTEGER
)
RETURNS
(
  TICKET_ID VARCHAR(32)
)
AS
  DECLARE SQL VARCHAR(2000);
  DECLARE S VARCHAR(250);
  DECLARE BARREL_NUM VARCHAR(2);
BEGIN

  SQL='SELECT TICKET_ID FROM /*PREFIX*/TICKETS '||
      ' WHERE TIRAGE_ID='''||TIRAGE_ID||''' AND NOT_USED=0 '||
      '   AND (CAST(NUM AS INTEGER)<45001 OR CAST(NUM AS INTEGER)>65000) ';

  S='';

  IF (PRIZE_ID IS NOT NULL) THEN BEGIN
    FOR SELECT BARREL_NUM
          FROM /*PREFIX*/LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND PRIZE_ID=:PRIZE_ID
           AND ROUND_NUM=:ROUND_NUM
         ORDER BY INPUT_DATE DESC
          INTO :BARREL_NUM DO BEGIN
      IF (S='') THEN BEGIN
        S=BARREL_NUM;
      END ELSE BEGIN
        S=S||BARREL_NUM;
      END
    END
  END ELSE BEGIN
    FOR SELECT BARREL_NUM
          FROM /*PREFIX*/LOTTERY
         WHERE TIRAGE_ID=:TIRAGE_ID
           AND PRIZE_ID IS NULL
           AND ROUND_NUM=:ROUND_NUM
         ORDER BY INPUT_DATE DESC
          INTO :BARREL_NUM DO BEGIN
      IF (S='') THEN BEGIN
        S=BARREL_NUM;
      END ELSE BEGIN
        S=S||BARREL_NUM;
      END
    END
  END

  IF (S<>'') THEN BEGIN

    SQL=SQL||'AND NUM LIKE ''%'||S||''' ';

    FOR EXECUTE STATEMENT SQL
                     INTO :TICKET_ID DO BEGIN
      SUSPEND;

    END

  END

END;

--

/* �������� ��������� */

COMMIT