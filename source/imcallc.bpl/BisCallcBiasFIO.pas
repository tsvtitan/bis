unit BisCallcBiasFIO;

interface

uses SysUtils;

type

{----------------------------------------------------------------------}
{ �������������� ������� �������                                       }
{ ���������:                                                           }
{  cLastName - ������� � ������������ ������                           }
{  nPadeg    - ����� (���������� �������� 1..6)                        }
{              1-������������                                          }
{              2-�����������                                           }
{              3-���������                                             }
{              4-�����������                                           }
{              5-������������                                          }
{              6-����������                                            }
{----------------------------------------------------------------------}
  TTypeCase=(tcNone,tcNominitive,tcGenitive,tcDative,tcAccusative,tcInstrumental,tcPrepositional);

function GetGenitiveCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
function GetGenitiveCase(const FIO: String): String; overload; // �����������
function GetDativeCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
function GetDativeCase(const FIO: String): String; overload; // ���������
function GetInstrumentalCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
function GetInstrumentalCase(const FIO: String): String; overload; // ������������
function GetAccusativeCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
function GetAccusativeCase(const FIO: String): String; overload; // �����������
function GetPrepositionalCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
function GetPrepositionalCase(const FIO: String): String; overload; // ����������
function GetSex(InPatronymic: String): Char;
function IsMale(InPatronymic: String): Boolean;
function IsFeminine(InPatronymic: String): Boolean;

implementation

uses Classes;

type
  EDeclenError = class(Exception)
  public
    ErrorCode : Integer;
  end;


const
  Vocalic      : Set of Char = ['�','�','�','�','�','�','�','�','�','�']; // �������
  Consonant    : Set of Char = ['�','�','�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�']; // ���������
  SoftSibilant : Set of Char = ['�','�'];        // ������ ������� ���������
  HardSibilant : Set of Char = ['�','�'];        // ������� ������� ���������
  GKX          : Set of Char = ['�','�','�'];    // ���������� ��� ��������� -�
  WordDelims   : Set of Char = [' ', #9];        // ����������� ���� � ���

  exInvalidCase = -1;
  exInvalidSex  = -2;

var
  aEnd : array[1..6] of String;                  // ������ ���������

  FirstNameMExeptions               : TStringList;
  FirstNameWExeptions               : TStringList;
  LastNameExeptions                 : TStringList;
  FirstPartLastNameExeptions        : TStringList;
  FirstNameParallelForms            : TStringList;
  FirstNameMExeptionsPresent        : Boolean;
  FirstNameWExeptionsPresent        : Boolean;
  LastNameExeptionsPresent          : Boolean;
  FirstPartLastNameExeptionsPresent : Boolean;
  FirstNameParallelFormsPresent     : Boolean;



////////////////////////////////////////////

{----------------------------------------------------------------------}
{ ���������� True ���� �������� ����� ���� LongInt ��������� �         }
{ ������� ���������.                                                   }
{ ���������:                                                           }
{  vBeg   - ������ ���������                                           }
{  vEnd   - ����� ���������                                            }
{  vValue - ����������� �����                                          }
{----------------------------------------------------------------------}
function IsRangeInt(vBeg: LongInt; vEnd: LongInt; vValue: Integer): Boolean;
begin
  Result := (vValue >= vBeg) and (vValue <= vEnd);
end; { IsRangeInt }


function RetCountWord(InFio: String; Ch: Char): Integer;
var
  i: Integer;
  chNew: Char;
begin
  Result:=0;
  for i:=1 to Length(InFio) do begin
    chNew:=InFio[i];
    if chNew=ch then
      Inc(Result);
  end;
end;

{----------------------------------------------------------------------}
{ ����������� ���� �� ��������                                         }
{----------------------------------------------------------------------}
function GetSex(InPatronymic: String): Char;
var
  nLen : Integer;
begin
  InPatronymic := AnsiLowerCase(InPatronymic);
  nLen := Length(InPatronymic);
  if (InPatronymic[nLen] = '�') or
     (Copy(InPatronymic, nLen-3, 4) = '����')
     // ���� ����� �������� ������ �������� ������� �������
  then Result := '�'
  else Result := '�';
end;

function IsMale(InPatronymic: String): Boolean;
var
  C: Char;
begin
  C:=GetSex(InPatronymic);
  Result:=C='�';
end;

function IsFeminine(InPatronymic: String): Boolean;
begin
  Result:=not IsMale(InPatronymic);
end;

{----------------------------------------------------------------------}
{ ������������ ������� ���������, ��� ��������������� �������          }
{ ������� ������� : 1-������������                                     }
{                   2-�����������                                      }
{                   3-���������                                        }
{                   4-�����������                                      }
{                   5-������������                                     }
{                   6-����������                                       }
{----------------------------------------------------------------------}
procedure SetEndings(c1, c2, c3, c4, c5, c6: String);
begin
  aEnd[1] := c1;
  aEnd[2] := c2;
  aEnd[3] := c3;
  aEnd[4] := c4;
  aEnd[5] := c5;
  aEnd[6] := c6;
end; { SetEndings }

{----------------------------------------------------------------------}
{ ������� ������� ���������                                            }
{----------------------------------------------------------------------}
procedure ClearEndings;
begin
  SetEndings('','','','','','');
end; { ClearEndings }


{----------------------------------------------------------------------}
{ ���������� ���������� ������ � ����� �� ����� �������                }
{----------------------------------------------------------------------}
function CountSyllable(AnyWord: String): Integer;
var
  ii : Integer;
begin
  AnyWord := AnsiLowerCase(AnyWord);
  Result := 0;
  for ii:=1 to Length(AnyWord) do
    if AnyWord[ii] in Vocalic then Inc(Result);
end;

{----------------------------------------------------------------------}
{ ���������� ������������ ����� ����� �� -� ��� cFirstName �� -�       }
{----------------------------------------------------------------------}
function NameParallelForm(cFirstName: String): String;
var
  i : Integer;
  S : String;
begin
  Result := cFirstName;
  if FirstNameParallelFormsPresent then begin
    for i:=0 to FirstNameParallelForms.Count-1 do begin
      S := FirstNameParallelForms[i];
      if cFirstName = Copy(S, 1, Pos('=', S)-1) then begin
        Result := Copy(S, Pos('=', S)+1, Length(S));
        Break;
      end;
    end;
  end;
end;


{----------------------------------------------------------------------}
{ ���������� ����� � ������� ������ ����� ���������� � �������         }
{ �����                                                                }
{----------------------------------------------------------------------}
function Proper(cStr: String): String;
var
  nLen, I : Integer;
begin
//  Result := AnsiProperCase(cStr,[' ','-']);
  Result := AnsiLowerCase(cStr);
  I := 1;
  nLen := Length(Result);
  while I <= nLen do begin
    while (I <= nLen) and ((Result[I] = ' ') or (Result[I] = '-'))do Inc(I);
    if I <= nLen then Result[I] := AnsiUpperCase(Result[I])[1];
    while (I <= nLen) and not ((Result[I] = ' ') or (Result[I] = '-')) do Inc(I);
  end;
end; { Proper }

{----------------------------------------------------------------------}
{ �������� �� ������������ ���������                                   }
{ ���������:                                                           }
{  AnyWord    - ������� ��� ���                                        }
{  Male       - ��� (True - �������; False - �������)                  }
{  IsLastName - ���� �������� �������                                  }
{  Multiple   - ���� ��������� ������� (True - ���������)              }
{----------------------------------------------------------------------}

function NonDeclension(AnyWord: String; Male, IsLastName, Multiple: Boolean): Boolean;
var
  nLen, I   : Integer;
  cLastChar : Char;
  cEnding   : String;
begin
  Result := True;
  if AnyWord = '' then Exit;       // �� ��������� ������ ������ � ������ �������

  nLen := Length(AnyWord);
  cLastChar := AnyWord[nLen];

  if IsLastName then begin         // ��������� �������
    if Multiple then begin         // ������� ���������
      if (                         // "�������" ��������� � ������������ ����� �������
        (AnyWord = '���')   or     // ���-������
        (AnyWord = '���')   or     // ���-��������
        (AnyWord = '�����') or     // �����-����
        (AnyWord = '����')         // ����-�����
                                   // ������ ������������ ��������� (� �.�.����� �������)
         ) then Exit;
      if FirstPartLastNameExeptionsPresent then   // �������� ������� ����������
        if FirstPartLastNameExeptions.Find(AnyWord, I) then Exit;
    end;

// �� ����������: ������� ������� �� -���, -���, -���, -��, -��
    if (
      (Copy(AnyWord, nLen-2, 3) = '���') or         // ���������
      (Copy(AnyWord, nLen-2, 3) = '���') or         // ������
      (Copy(AnyWord, nLen-2, 3) = '���') or         // �������
      (Copy(AnyWord, nLen-1, 2) = '��')  or         // ������
      (Copy(AnyWord, nLen-1, 2) = '��')) then Exit; // �����

    cEnding := Copy(AnyWord, nLen-1, 2);            // ��� ��������� �����

// �� ����������: ������� �� -�, -� � �������������� ������� �
    if (
      (cEnding ='��') or           // ������ ������, ����� ������
      (cEnding ='��')) then Exit;  // �������� �����

// �� ����������: ������� �������, �������������� �� ��������� ���� � -�
    if (not Male) and (cLastChar in Consonant + ['�']) then Exit;

    if LastNameExeptionsPresent then     // �������� ������� ����������
      if LastNameExeptions.Find(AnyWord, I) then Exit;

    Result := (cLastChar in ['�','�','�','�',    '�','�','�','�']);
  end
  else begin                             // ��������� ���
    if Male then begin                   // ������� �����
      if FirstNameMExeptionsPresent then // �������� ������� ����������
        if FirstNameMExeptions.Find(AnyWord, I) then Exit;
    end
    else begin                           // ������� �����
      if cLastChar in Consonant then Exit;
      if FirstNameWExeptionsPresent then // �������� ������� ����������
        if FirstNameWExeptions.Find(AnyWord, I) then Exit;
    end;
    Result := (cLastChar in ['�','�','�','�',    '�','�','�','�']);
  end;
end; { NonDeclension }

{----------------------------------------------------------------------}
{ ��������� ����� �� ����������� �� ��� ����������� ������ (��� Index  }
{ �������, ��� ����� ���� ������������ ������ ������)                  }
{ ���������:                                                           }
{   Index  - ����� �����                                               }
{   Source - �����������                                               }
{----------------------------------------------------------------------}
function A_ExtractWord(Index: Integer; Source: String): String;
var
  tmpS    : String;
  i, iPos : Integer;
begin
  tmpS := Trim(Source);
  for i := 1 to Index-1 do begin
    iPos := Pos(' ', tmpS);
    if iPos = 0 then iPos := Length(tmpS);
    tmpS := Trim(Copy(tmpS, iPos+1, Length(tmpS)));
  end;
  iPos := Pos(' ', tmpS);
  if iPos = 0 then iPos := Length(tmpS);
  Result := Trim(Copy(tmpS, 1, iPos));
end;


{----------------------------------------------------------------------}
{ ���������� ��� �� �������, ���, ��������                             }
{ ���������:                                                           }
{  cFIO        - ���������� ���������� �������, ��� � ��������,        }
{                ���������� ����� �������                              }
{  cLastName   - ������������ �������                                  }
{  cFirstName  - ������������ ���                                      }
{  cMiddleName - ������������ ��������                                 }
{----------------------------------------------------------------------}

function ExtractWord(InFio: string;
                     var cLastName,cFirstName,cMiddleName: String; Delims: Char): string;
var
  Apos: Integer;
  Last: Integer;
  tmps: string;
begin
  Result:=InFio;
  tmps:=InFio;
  Apos:=Pos(Delims,tmps);
  if APos<>0 then begin
   cLastName:=Copy(InFio,1,APos-1);
   tmps:=Copy(InFio,APos+1,Length(InFio)-Length(cLastName));
  end else begin
   cLastName:=InFio;
   exit;
  end;
  last:=APos;
  APos:=Pos(Delims,tmps);
  if APos<>0 then begin
   cFirstName:=Copy(tmps,1,APos-1);
   tmps:=Copy(InFio,APos+last+1,Length(InFio)-Length(cFirstName));
  end else begin
   cFirstName:=tmps;
   exit;
  end;

  cMiddleName:=Copy(tmps,1,Length(tmps));

end;

procedure SeparateFIO(cFIO: String; var cLastName, cFirstName, cMiddleName: String);
var
  PointPos, nLen : Integer;
begin
  ExtractWord(cFIO,cLastName,cFirstName,cMiddleName,' ');
  PointPos := Pos('.', cFirstName);
  if PointPos <> 0 then begin                            // �������� ��� ����������
    nLen := Length(cFirstName);
    if PointPos <> nLen then begin                       // �������� �������� ������
      cMiddleName := Copy(cFirstName, PointPos+1, nLen); // ������� ��������
      cFirstName := Copy(cFirstName, 1, PointPos);       // ������� �����
    end;
  end;
end;



{----------------------------------------------------------------------}
{ �������������� ������� �������                                       }
{ ���������:                                                           }
{  cLastName - ������� � ������������ ������                           }
{  nPadeg    - ����� (���������� �������� 1..6)                        }
{              1-������������                                          }
{              2-�����������                                           }
{              3-���������                                             }
{              4-�����������                                           }
{              5-������������                                          }
{              6-����������                                            }
{----------------------------------------------------------------------}
function GetLastNameM(cLastName: String; nPadeg: Integer; Multiple: Boolean): String;
var
  nLen      : Integer;
  cEnd      : String;
  nDelimPos : Integer;
  cFstPart  : String;
  cEndPart  : String;
begin
  nDelimPos := Pos('-', cLastName);                      // ������� �����������
  if nDelimPos > 0 then begin                            // ������� ���������
    cFstPart := Trim(Copy(cLastName, 1, nDelimPos - 1)); // �������� ����� �� ������
    cEndPart := Trim(Copy(cLastName, nDelimPos + 1, Length(cLastName)));
    Result := GetLastNameM(cFstPart, nPadeg, True) +     // �������� ������ �����
              '-' +                                      // ������������ �����
              GetLastNameM(cEndPart, nPadeg, False);     // �������� �������
    Exit;
  end;
  cLastName := Proper(cLastName);
  Result := cLastName;
  if NonDeclension(cLastName, True, True, Multiple) then Exit;  // �������� �� ����
  ClearEndings;                                          // ������� ������ ���������
  nLen := Length(cLastName);                             // ����� �������
  cEnd := Copy(cLastName, nLen - 1, 2);                  // ����� �������� 2 ����� �������
  if (cEnd = '��') then begin
    SetEndings('','���','���','���','��','��');
    if nPadeg > 1 then cLastName := Copy(cLastName, 1, nLen - 2);
  end else
  if (cEnd = '��') then begin
    SetEndings('','���','���','���','��','��');
    if CountSyllable(cLastName) = 1 then begin
      SetEndings('�','�','�','�','��','�');              // ���
      cLastName := Copy(cLastName, 1, nLen - 1);         // ��������� �������
    end
    else begin
      if cLastName[nLen-2] in (GKX + SoftSibilant) then aEnd[5] := '��';
      if nPadeg > 1 then cLastName := Copy(cLastName, 1, nLen - 2);
    end;
  end else
  if (cEnd = '��') or (cEnd = '��') or (cEnd = '��') or (cEnd = '��') then begin
    if (cEnd = '��') and (cLastName[nLen-2] in GKX) then begin
      SetEndings(cEnd,'���','���','���','��','��');
      cLastName := Copy(cLastName, 1, nLen-2);
    end else
    if (cEnd = '��') and
       (cLastName[nLen-2] in HardSibilant+SoftSibilant+['�','�']) then begin
      SetEndings(cEnd,'���','���','���','��','��');      // ��������, �����, �����
      cLastName := Copy(cLastName, 1, nLen-2);
    end
    else begin
      SetEndings('�','�','�','�','��','�');
      cLastName := Copy(cLastName, 1, nLen - 1);         // ��������� �������
    end;
  end else
  if (cEnd = '��') or (cEnd = '��') or (cEnd = '��') or (cEnd = '��') or
     (cEnd = '��') then begin
    SetEndings('','�','�','�','��','�');
    if (cLastName = '���') and (nPadeg > 1) then cLastName := '���';
    // ���� ������� - ���� ����, �� ��.�. -�� (��� - �����)
    if CountSyllable(cLastName) = 1 then aEnd[5] := '��';
    if cLastName = '�����' then aEnd[5] := '��';
  end else
  if (cEnd = '��') or (cEnd = '��')then begin
    SetEndings('','�','�','�','��','�');
  end else
  if (cEnd = '��') then begin
    SetEndings('','�','�','�','��','�');
    if (nPadeg > 1) and (CountSyllable(cLastName) > 1) then
      cLastName := Copy(cLastName, 1, nLen - 2) + '�';   // �������� ������� (������� - ��������; ��� - �����)
  end else
  if (cEnd='��') then begin
    SetEndings('','�','�','�','��','�');
    if (nPadeg > 1) then begin                           //����������� cLastName
      case AnsiLowerCase(cLastName[nLen - 2])[1] of      // ������ 3 ����� � �����
        '�',         // ����
        '�',         // ���������
        '�',         // ���������
        '�',         // ��������
        '�' : begin  // ��������
                aEnd[5] := '��';
                cLastName := Copy(cLastName, 1, nLen - 2) + '��';
              end;
        '�' : if cLastName[nLen-3] in Vocalic then
                // ���� ���������� - �������
                cLastName := Copy(cLastName, 1, nLen - 2) + '��'   // �������
              else begin
                aEnd[5] := '��';                                   // �������, ����
                if cLastName[nLen-3] = '�' then aEnd[5] := '��';   // ��������
              end;
        '�',                                                       // ������
        '�' : if cLastName[nLen - 3] in Vocalic then
                if CountSyllable(cLastName) > 2 then
                  cLastName := Copy(cLastName, 1, nLen - 2) + '�'; // ������� ����� �� �������� cLastName (�������,�����)
        '�' : if (nLen > 3) then begin
                if (cLastName[nLen-3] in Vocalic) then begin
                  // ���� ���������� - �������
                  aEnd[5] := '��';
                  cLastName := Copy(cLastName, 1, nLen - 2) +'�';  // �������
                end;
              end
              else aEnd[5] := '��';                                // ���
      else
        cLastName := Copy(cLastName, 1, nLen - 2) + '�';           // ��������
      end; { case }
    end; { if }
  end else begin
    cEnd := Copy(cLastName,nLen,1);                    // ����� �������� ����� �������
    if (cEnd = '�') and (cLastName[nLen-1] in Consonant) then begin
      SetEndings('�','�','�','�','��','�');
      // ���� ����� -� ����� [�,�,�] ��� ������ ������� ��� [�,�], �� ��������� ���.�. -�
      if cLastName[nLen-1] in (GKX + SoftSibilant + ['�','�']) then aEnd[2] := '�';
      // ���� ����� -� ����� �������, �� ��������� ��.�. -�� (��� �������� �� ����� �����)
      // ��� -��. ����� ��� �������������� �������� ������� �� ������ �� ��������� �������
      if (cLastName[nLen-1] in (SoftSibilant + HardSibilant + ['�'])) and
         (cLastName[nLen-2] in Vocalic)  then aEnd[5] := '��'; // �������, ������� �� ������
      cLastName := Copy(cLastName, 1, nLen - 1);
    end else
    if (cEnd = '�') and (cLastName[nLen-1] in (Consonant+['�'])) then begin
      SetEndings('�','�','�','�','��','�');
      cLastName := Copy(cLastName, 1, nLen - 1);
    end else
    if cEnd = '�' then begin
      SetEndings('','�','�','�','��','�');
      if nPadeg > 1 then cLastName := Copy(cLastName, 1, nLen - 1);
    end else
    if cEnd[1] in Consonant then begin
      SetEndings('','�','�','�','��','�');
      if cEnd[1] in HardSibilant then aEnd[5] := '��';
    end;
  end;
  Result := cLastName + aEnd[nPadeg];
end; { GetLastNameM }

{----------------------------------------------------------------------}
{ �������������� ������� �������                                       }
{ ���������:                                                           }
{  cLastName - ������� � ������������ ������                           }
{  nPadeg    - ����� (���������� �������� 1..6)                        }
{              1-������������                                          }
{              2-�����������                                           }
{              3-���������                                             }
{              4-�����������                                           }
{              5-������������                                          }
{              6-����������                                            }
{----------------------------------------------------------------------}
function GetLastNameW(cLastName: String; nPadeg: Integer; Multiple: Boolean): String;
var
  nLen      : Integer;
  cEnd      : String;
  nDelimPos : Integer;
  cFstPart  : String;
  cEndPart  : String;
begin
  nDelimPos := Pos('-', cLastName);                      // ������� �����������
  if nDelimPos > 0 then begin                            // ������� ���������
    cFstPart := Trim(Copy(cLastName, 1, nDelimPos - 1)); // �������� ����� �� ������
    cEndPart := Trim(Copy(cLastName, nDelimPos + 1, Length(cLastName)));
    Result := GetLastNameW(cFstPart, nPadeg, True) +     // �������� ������ �����
              '-' +                                      // ������������ �����
              GetLastNameW(cEndPart, nPadeg, False);     // �������� �������
    Exit;
  end;
  cLastName := Proper(cLastName);
  Result := cLastName;
  if NonDeclension(cLastName, False, True, Multiple) then Exit; // �������� �� ����
  ClearEndings;                                          // ������� ������ ���������
  nLen := Length(cLastName);                             // ����� �������
  cEnd := Copy(cLastName, nLen - 3, 4);                  // ����� �������� 4 ����� �������
  if cEnd = '����' then begin
    SetEndings('�','��','��','�','��','��');
    cLastName := Copy(cLastName, 1, nLen - 1);           // ��������� �������
  end else begin
    cEnd := Copy(cLastName, nLen - 2, 3);                // ����� ��������� 3 �����
    if (cEnd = '���') or (cEnd = '���') or (cEnd = '���') or (cEnd = '���') then begin
      SetEndings('�','��','��','�','��','��');
      cLastName := Copy(cLastName, 1, nLen - 1);         // ��������� �������
    end else begin
      cEnd := Copy(cLastName, nLen - 1, 2);              // ����� �������� 2 ����� �������
      if (cEnd = '��') or (cEnd = '��') then begin
        if cEnd = '��' then begin
          SetEndings('��','��','��','��','��','��');
          if cLastName[nLen-2] in (SoftSibilant + HardSibilant + ['�']) then
            SetEndings('��','e�','e�','��','e�','e�');   // �������, �����
        end
        else SetEndings('��','��','��','��','��','��');
        cLastName := Copy(cLastName, 1, nLen - 2);       // ��������� �������
      end else begin
        cEnd := Copy(cLastName, nLen, 1);                // ����� �������� ����� �������
        if (cEnd = '�') and (cLastName[nLen-1] in Consonant) then begin
          SetEndings('�','�','�','�','��','�');
          // ���� ����� -� ����� [�,�,�] ��� ������ ������� ��� [�,�], �� ��������� ���.�. -�
          if cLastName[nLen-1] in (GKX + SoftSibilant + ['�','�']) then aEnd[2] := '�';
          // ���� ����� -� ����� �������, �� ��������� ��.�. -�� (��� �������� �� ����� �����)
          // ��� -��. ���� ��� �������������� �������� ������� �� ������ �� ��������� �������
          if (cLastName[nLen-1] in (SoftSibilant + HardSibilant + ['�'])) and
             (cLastName[nLen-2] in Vocalic)  then aEnd[5] := '��'; // �������, ������� �� ������
          cLastName := Copy(cLastName, 1, nLen - 1);
        end else
        if (cEnd = '�') and (cLastName[nLen-1] in (Consonant+['�'])) then begin
          SetEndings('�','�','�','�','��','�');
          cLastName := Copy(cLastName, 1, nLen - 1);
        end;
      end;
    end;
  end;
  Result := cLastName + aEnd[nPadeg];                    // ��������� � ������� ���������
end; { GetLastNameW }

{----------------------------------------------------------------------}
{ ������� �������������� �������� �����                                }
{ ���������:                                                           }
{  cFirstName - ��� � ������������ ������                              }
{  nPadeg     - ����� (���������� �������� 1..6)                       }
{               1-������������                                         }
{               2-�����������                                          }
{               3-���������                                            }
{               4-�����������                                          }
{               5-������������                                         }
{               6-����������                                           }
{----------------------------------------------------------------------}
function GetFirstNameM(cFirstName: String; nPadeg: Integer): String;
var
  nLen : Integer;
  cEnd : String;
begin
  cFirstName := Proper(cFirstName);
  Result := cFirstName;
  if nPadeg > 1 then begin                               // ����� �� ������������ - ���������� ��������
    nLen := Length(cFirstName);
    cEnd := Copy(cFirstName, nLen, 1);                   // ������� ���������
    if cEnd = '�' then
      cFirstName := NameParallelForm(cFirstName);        // ������� �� ������������ �����, ���� ��� ����
    if NonDeclension(cFirstName, True, False, False) then Exit;  // �������� �� ����
    SetEndings('','�','�','�','��','�');                 // ������ ��������� �� ���������
    if (cFirstName='���') then
      cFirstName := '���'                                // ��� - ��� � ���������� �������
    else if (cFirstName = '�����') then
      cFirstName := '����'                               // ����� - ���� �������� �������
    else begin
      if (cEnd = '�') or (cEnd = '�') then begin
        SetEndings(cEnd,'�','�','�','��','�');
        if cFirstName[nLen-1] = '�' then aEnd[6] := '�'; // � �������
        cFirstName := Copy(cFirstName, 1, nLen-1);
      end else
      if (cEnd = '�') then begin                         // ������
        SetEndings('�','�','�','�','��','�');
        if cFirstName[nLen-1] in (GKX + SoftSibilant + ['�','�']) then
          aEnd[2] := '�';                                // ����
        cFirstName := Copy(cFirstName, 1, nLen-1);
      end
      else if (cEnd = '�') then begin                    // ����, �������
        SetEndings('�','�','�','�','��','�');
        cFirstName := Copy(cFirstName, 1, nLen-1);
      end;
    end;
    Result := cFirstName + aEnd[nPadeg];
  end;
end; { GetFirstNameM }

{----------------------------------------------------------------------}
{ ������� �������������� �������� �����                                }
{ ���������:                                                           }
{  cFirstName - ��� � ������������ ������                              }
{  nPadeg     - ����� (���������� �������� 1..6)                       }
{               1-������������                                         }
{               2-�����������                                          }
{               3-���������                                            }
{               4-�����������                                          }
{               5-������������                                         }
{               6-����������                                           }
{----------------------------------------------------------------------}
function GetFirstNameW(cFirstName: String; nPadeg: Integer): String;
var
  nLen : Integer;
  cEnd : String;
begin
  cFirstName := Proper(cFirstName);
  Result := cFirstName;
  if NonDeclension(cFirstName, False, False, False) then Exit; // �������� �� ����
  ClearEndings;                                          // ������� ������ ���������
  nLen := Length(cFirstName);
  cEnd := Copy(cFirstName, nLen, 1);                     // ������� ���������
  if cEnd = '�' then begin
    SetEndings('�','�','�','�','��','�');
    if cFirstName[nLen-1] in (GKX + SoftSibilant + ['�','�']) then
      aEnd[2] := '�';                                    // ��������
    cFirstName := Copy(cFirstName, 1, nLen - 1);
  end else
  if cEnd = '�' then begin
    SetEndings('�','�','�','�','��','�');                // ����� - � �����
    if cFirstName[nLen - 1] in ['�','�'] then begin
      aEnd[3] := '�';
      aEnd[6] := '�';                                    // ����� - � ����� ��� - � ���
    end;
    cFirstName := Copy(cFirstName, 1, nLen - 1);
  end else
  if cEnd = '�' then begin                               // ������
    SetEndings('�','�','�','�','��','�');
    cFirstName:=Copy(cFirstName, 1, nLen - 1);
  end;
  Result := cFirstName + aEnd[nPadeg];
end; { GetFirstNameW }

{----------------------------------------------------------------------}
{ ������� �������������� �������� ��������                             }
{ ���������:                                                           }
{  cMiddleName  - �������� � ������������ ������                       }
{  nPadeg       - ����� (���������� �������� 1..6)                     }
{                1-������������                                        }
{                2-�����������                                         }
{                3-���������                                           }
{                4-�����������                                         }
{                5-������������                                        }
{                6-����������                                          }
{----------------------------------------------------------------------}
function GetMiddleNameM(cMiddleName: String; nPadeg: Integer): String;
begin
  cMiddleName := Proper(cMiddleName);
  Result := cMiddleName;
  if cMiddleName = '' then Exit;
  SetEndings('','�','�','�','��','�');
  if cMiddleName[Length(cMiddleName)] <> '�' then ClearEndings; // ���� � ������
  Result := cMiddleName + aEnd[nPadeg];
end; { GetMiddleNameM }

{----------------------------------------------------------------------}
{ ������� �������������� �������� ��������                             }
{ ���������:                                                           }
{  cMiddleName - �������� � ������������ ������                        }
{  nPadeg      - ����� (���������� �������� 1..6)                      }
{                1-������������                                        }
{                2-�����������                                         }
{                3-���������                                           }
{                4-�����������                                         }
{                5-������������                                        }
{                6-����������                                          }
{----------------------------------------------------------------------}
function GetMiddleNameW(cMiddleName: String; nPadeg: Integer): String;
var
  nLen : Integer;
  cEnd : String;
begin
  cMiddleName := Proper(cMiddleName);
  Result := cMiddleName;
  if cMiddleName = '' then Exit;
  nLen := Length(cMiddleName);
  cEnd := Copy(cMiddleName, nLen, 1);                    // ������� ���������
  SetEndings('�','�','�','�','��','�');
  if cEnd = '�' then cMiddleName := Copy(cMiddleName, 1, nLen - 1)
                else ClearEndings;                       // ������� ������ ���������
  Result := cMiddleName + aEnd[nPadeg];
end; { GetMiddleNameW }


{----------------------------------------------------------------------}
{ ������� ������ ���������                                             }
{----------------------------------------------------------------------}
function CreateDeclenError(ErrorCode: Integer): EDeclenError;
type
  TErrorRec = record
    Code  : Integer;
    Ident : String;
  end;
const
  DeclenErrorMap: array[0..1] of TErrorRec = (
    (Code: exInvalidCase; Ident: '������������ �������� ������'),
    (Code: exInvalidSex;  Ident: '������������ ���'));
var
  i : Integer;
begin
  Result:=nil;
  i := Low(DeclenErrorMap);
  while (i <= High(DeclenErrorMap)) and (DeclenErrorMap[i].Code <> ErrorCode) do
    Inc(i);
  if i <= High(DeclenErrorMap) then
    Result := EDeclenError.Create(DeclenErrorMap[i].Ident);
  Result.ErrorCode := ErrorCode;
end;

{----------------------------------------------------------------------}
{ ������� �������������� �������, �����, �������� �� �������������     }
{ ������ � ����� ������ �����                                          }
{ ���������:                                                           }
{  cLastName    - �������                                              }
{  cFirstName   - ���                                                  }
{  cMiddleName  - ��������                                             }
{  �Sex         - ��� (���������� �������� "�", "�")                   }
{  nPadeg       - ����� (���������� �������� 1..6)                     }
{                 1-������������                                       }
{                 2-�����������                                        }
{                 3-���������                                          }
{                 4-�����������                                        }
{                 5-������������                                       }
{                 6-����������                                         }
{----------------------------------------------------------------------}
function GetFIO(cLastName, cFirstName, cMiddleName: String;
                cSex: String; nPadeg: Integer): String;
var
  nLen : Integer;
begin
  cLastName   := Trim(cLastName);
  cFirstName  := Trim(cFirstName);
  cMiddleName := Trim(cMiddleName);
  if IsRangeInt(1, 6, nPadeg) then begin
    if cSex = '' then                                                 // ���� ��� �� �����
      if cMiddleName <> '' then begin                                 // �� ������ ��������
        nLen := Length(cMiddleName);
        if nLen>0 then
         if cMiddleName[nLen] <> '.' then                              // � ��� �� �������
          cSex := GetSex(cMiddleName)                                 // ��������� ���
         else begin
          Result := Trim(Proper(cLastName) + ' ' + Proper(cFirstName) + Proper(cMiddleName));
          Exit;                                                       // ������� ������ �� �����
         end;
      end
      else begin
        Result := Trim(Proper(cLastName) + ' ' + Proper(cFirstName));
        Exit;                                                         // ������� ������ �� �����
      end;
    cSex := AnsiLowerCase(cSex);
    if cSex = '�' then begin
      Result := GetLastNameM(cLastName, nPadeg, False);               // ����������� �������

      nLen := Length(cFirstName);
      if nLen>0 then
       if cFirstName[nLen] = '.' then                                  // ������ ������� �����
        Result := Result + ' ' + Proper(cFirstName)                   // ������� ���
       else
        Result := Result + ' ' + GetFirstNameM(cFirstName, nPadeg);   // ����������� ���

      nLen := Length(cMiddleName);
      if nLen>0 then
       if cMiddleName[nLen] = '.' then                                 // ������ ������� ��������
        Result := Result + Proper(cMiddleName)                        // ������� ���
       else
        Result := Result + ' ' + GetMiddleNameM(cMiddleName, nPadeg); // ����������� ��������
    end else
    if cSex = '�' then begin
      Result := GetLastNameW(cLastName, nPadeg, False);               // ����������� �������

      nLen := Length(cFirstName);
      if nLen>0 then
       if cFirstName[nLen] = '.' then                                  // ������ ������� �����
        Result := Result + ' ' + Proper(cFirstName)                   // ������� ���
       else
        Result := Result + ' ' + GetFirstNameW(cFirstName, nPadeg);   // ����������� ���

      nLen := Length(cMiddleName);
      if nLen>0 then
      if cMiddleName[nLen] = '.' then                                 // ������ ������� ��������
        Result := Result + Proper(cMiddleName)                        // ������� ���
      else
        Result := Result + ' ' + GetMiddleNameW(cMiddleName, nPadeg); // ����������� ��������
    end else
      raise CreateDeclenError(exInvalidSex);
  end else
      raise CreateDeclenError(exInvalidCase);
  Result := Trim(Result);
end;

{----------------------------------------------------------------------}
{ ������� �������������� �������, �����, ��������, ����������          }
{ ����� �������, �� ������������� ������ � ����� ������ �����          }
{ ���������:                                                           }
{  cFIO         - �������                                              }
{  �Sex         - ��� (���������� �������� "�", "�")                   }
{  nPadeg       - ����� (���������� �������� 1..6)                     }
{                 1-������������                                       }
{                 2-�����������                                        }
{                 3-���������                                          }
{                 4-�����������                                        }
{                 5-������������                                       }
{                 6-����������                                         }
{----------------------------------------------------------------------}

function TrimCharForOne(const Ch: Char; const s: string): string;
var
    I: Integer;
    tmps: string;
begin
    for i:=1 to Length(s) do begin
     if i=1 then begin
       tmps:=s[i];
     end else begin
       if (s[i]<>Ch) then
        tmps:=tmps+s[i]
       else
        if (s[i-1]<>Ch) then
          tmps:=tmps+s[i];
     end;
    end;
    Result:=tmps;
end;

function GetFIOFromStr(cFIO: String; cSex: String; TypeCase: TTypeCase): String;
var
  F, I, O : String;
  nPadeg: Byte;
  tmps: string;
begin
  nPadeg:=Integer(TypeCase);
  if nPadeg<>0 then begin
    tmps:=Trim(TrimCharForOne(' ',cFIO));
    SeparateFIO(tmps, F, I, O);
    Result := GetFIO(F, I, O, cSex, nPadeg);
  end; 
end;


function GetGenitiveCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
begin
  Result:='';
  if (Length(InSurName)>0) and
     (Length(InName)>0) and
     (Length(InPatronymic)>0) then begin
    Result:=GetFIO(InSurName,InName,InPatronymic,'',Integer(tcGenitive));
    SeparateFIO(Result,OutSurName,OutName,OutPatronymic);
  end;
end;

function GetGenitiveCase(const FIO: String): String; overload;
begin
  if Length(FIO)>3 then
    Result:=GetFIOFromStr(FIO,'',tcGenitive);
end;

function GetDativeCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
begin
  Result:='';
  if (Length(InSurName)>0) and
     (Length(InName)>0) and
     (Length(InPatronymic)>0) then begin
    Result:=GetFIO(InSurName,InName,InPatronymic,'',Integer(tcDative));
    SeparateFIO(Result,OutSurName,OutName,OutPatronymic);
  end;
end;

function GetDativeCase(const FIO: String): String; overload;
begin
  if Length(FIO)>3 then
    Result:=GetFIOFromStr(FIO,'',tcDative);
end;

function GetInstrumentalCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String; overload;
begin
  Result:='';
  if (Length(InSurName)>0) and
     (Length(InName)>0) and
     (Length(InPatronymic)>0) then begin
    Result:=GetFIO(InSurName,InName,InPatronymic,'',Integer(tcInstrumental));
    SeparateFIO(Result,OutSurName,OutName,OutPatronymic);
  end;
end;

function GetInstrumentalCase(const FIO: String): String; overload;
begin
  if Length(FIO)>3 then
    Result:=GetFIOFromStr(FIO,'',tcInstrumental);
end;

function GetAccusativeCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): string; overload;
begin
  Result:='';
  if (Length(InSurName)>0) and
     (Length(InName)>0) and
     (Length(InPatronymic)>0) then begin
    Result:=GetFIO(InSurName,InName,InPatronymic,'',Integer(tcAccusative));
    SeparateFIO(Result,OutSurName,OutName,OutPatronymic);
  end;
end;

function GetAccusativeCase(const FIO: String): String; overload;
begin
  if Length(FIO)>3 then
    Result:=GetFIOFromStr(FIO,'',tcAccusative);
end;

function GetPrepositionalCase(const InSurName, InName, InPatronymic: String; var OutSurName, OutName, OutPatronymic: String): String;
begin
  Result:='';
  if (Length(InSurName)>0) and
     (Length(InName)>0) and
     (Length(InPatronymic)>0) then begin
    Result:=GetFIO(InSurName,InName,InPatronymic,'',Integer(tcPrepositional));
    SeparateFIO(Result,OutSurName,OutName,OutPatronymic);
  end;
end;

function GetPrepositionalCase(const FIO: String): String;
begin
  if Length(FIO)>3 then
    Result:=GetFIOFromStr(FIO,'',tcPrepositional);
end;

end.

