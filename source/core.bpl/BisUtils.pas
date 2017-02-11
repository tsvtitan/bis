unit BisUtils;

interface

uses Windows, Classes, DB, Controls, Menus, Graphics,
     BisObject, BisCmdLine, BisVariants;

type
  TSetOfChar=set of char;

  TBisTickDifferenceType=(dtDefault,dtNanoSec,dtMilliSec,dtSec);


function ExpandFileNameEx(FileName: String): String;
function PrepareFileName(CmdLine: TBisCmdLine; FileName,Param: string; var Exists: Boolean): String;
procedure GetObjectProperties(AObject: TObject; Strings: TStringList);
function PrepareClassID(S: string): string;
function CreateClassID: string;
function GetUniqueID: String;
function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
function GetStringByStrings(Strings: TStrings; Delim: String): String;
procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
function FormatEx(const Msg: String; Args: TBisVariants): String; overload;
function FormatEx(const Msg: String; const Args: array of const): String; overload;
procedure FreeAndNilEx(var Obj);
function GetFieldTypeByVarType(VType: Word): TFieldType;
procedure GetWordsFromString(S: string; Strings: TStringList);
function GetFirstWord(S: String): String;
function CharIsControl(const C: AnsiChar): Boolean;
function CharIsPrintable(const C: AnsiChar): Boolean;
function CharIsNumber(const C: AnsiChar): Boolean;
function CharIsNumberEx(const C: Char): Boolean;
function CharIsDigit(const C: AnsiChar): Boolean;
function CharIsAlpha(const C: AnsiChar): Boolean;
function CharValidDate(const C: AnsiChar): Boolean;
function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
function GetChangedText(const Text: string; SelStart, SelLength: integer; Key: char): string;
function VarToDateDef(const V: Variant; const ADefault: TDateTime): TDateTime;
function VarToDateTimeDef(const V: Variant; const ADefault: TDateTime): TDateTime;
function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
function VarToExtendedDef(const V: Variant; const ADefault: Extended): Extended;
function IsClassParent(AClassIn: TClass; AClassParent: TClass): Boolean;
procedure ClearStrings(Strings: TStrings);
function GetFirstMenuChecked(Items: TMenuItem): TMenuItem;
procedure SaveObjectToFile(Obj: TObject; FileName: String);
function GetFilterString(Strings: TStrings; Operator: String): String;
function GetFileSizeEx(FileName: String): Integer;
function GetFileTimeEx(FileName: String): TDateTime;
function VisibleControlCharacters(const S: String; Delimiter: String='#'; Hex: Boolean=true): String;
function GetOnlyChars(const S: String; Chars: TSetOfChar): String;
function GetOnlyNumbers(const S: String): String;
function RemoveChars(const S: String; Chars: TSetOfChar): String;
function RemoveNoneFilenameChars(const S: String): String;
function QuotedChars(const S: String; Chars: TSetOfChar): String;
function QuotedFileName(const S: String): String;
procedure EnableControl(Control: TWinControl; Enabled: Boolean);
procedure GetDirFiles(Dir: String; FileDirs: TStringList; OnlyFiles, StopFirst: Boolean);
function GetTickCount(var Freq: Int64): Int64;
function GetTickDifference(const Tick,Freq: Int64; const DiffType: TBisTickDifferenceType): Int64; overload;
function GetTickDifference(const Tick1,Freq1,Tick2,Freq2: Int64; const DiffType: TBisTickDifferenceType): Int64; overload;
function RandomString(Count: Integer): String;
function ParseName(const S, Delim: String; var Name, Value: String): Boolean;
function ParseBetween(const S, LDelim, RDelim: String; var Value: String): Boolean;
function VarSameValueEx(const A, B: Variant): Boolean;
function ArraySameValues(Arr1,Arr2: array of Variant): Boolean;
function GetMemoryPageSize: Cardinal;
function IsMainThread: Boolean;
function GetComponentName(const Name,Default: String; Owner: TComponent): String;
procedure Output(const S: String);
function CreateDirEx(const Dir: String): Boolean;
function GetNameByClass(ClassName: String): String;

implementation

uses TypInfo, Variants, ActiveX, Contnrs, SysUtils, Math,
   //  IpTypes, IpFunctions,
     {BisCrypter, }BisConsts;

var
  AnsiCharTypes: array [AnsiChar] of Word;
const
  AnsiSigns=['-', '+'];
  DigitSigns=['0','1','2','3','4','5','6','7','8','9'];

const
  // CharType return values
  C1_UPPER  = $0001; // Uppercase
  C1_LOWER  = $0002; // Lowercase
  C1_DIGIT  = $0004; // Decimal digits
  C1_SPACE  = $0008; // Space characters
  C1_PUNCT  = $0010; // Punctuation
  C1_CNTRL  = $0020; // Control characters
  C1_BLANK  = $0040; // Blank characters
  C1_XDIGIT = $0080; // Hexadecimal digits
  C1_ALPHA  = $0100; // Any linguistic character: alphabetic, syllabary, or ideographic

function ExpandFileNameEx(FileName: String): String;
var
  Dir: String;
  ModuleName: String;
begin
  Result:=ExpandFileName(FileName);
  ModuleName:=GetModuleName(HInstance);
  Dir:=ExtractFileDir(ModuleName);
  if SetCurrentDir(Dir) then
    Result:=ExpandFileName(FileName);
end;

function PrepareFileName(CmdLine: TBisCmdLine; FileName,Param: string; var Exists: Boolean): String;
begin
  Result:=ExpandFileNameEx(FileName);
  if Assigned(CmdLine) then begin
    Exists:=CmdLine.ParamExists(Param);
    if Exists then begin
      Result:=CmdLine.ValueByParam(Param);
    end;

    Result:=ExpandFileNameEx(Result);
  end;
end;

procedure GetObjectProperties(AObject: TObject; Strings: TStringList);
var
  i: Integer;
  Count: Integer;
  PropList: PPropList;
  V: String;
begin
  if Assigned(AObject) and Assigned(Strings) then begin
    PropList:=nil;
    Count:=GetPropList(AObject,PropList);
    if Assigned(PropList) then begin
      for i:=0 to Count-1 do begin
        if Assigned(PropList[i]) then begin
          V:=VarToStrDef(GetPropValue(AObject,PropList[i].Name),'');
          if Trim(V)='' then begin
            Strings.Values[PropList[i].Name]:=' ';
          end else
            Strings.Values[PropList[i].Name]:=V;
        end;
      end;
    end;
  end;
end;

function PrepareClassID(S: string): string;
begin
  Result:=Copy(s, 26, 12)+Copy(s, 21, 4)+Copy(s, 16, 4)+Copy(s, 11, 4)+Copy(s, 2, 8);
end;

function CreateClassID: string;
var
  ClassID: TCLSID;
  P: PWideChar;
begin
  CoCreateGuid(ClassID);
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;

function GetUniqueID: String;
var
  s: string;
begin
  s:=Copy(CreateClassID, 1, 37);
  Result:=PrepareClassID(s);
end;

function Iff(IsTrue: Boolean; ValueTrue, ValueFalse: Variant): Variant;
begin
  if IsTrue then Result:=ValueTrue
  else Result:=ValueFalse;
end;

function GetStringByStrings(Strings: TStrings; Delim: String): String;
var
  i: Integer;
begin
  Result:='';
  for i:=0 to Strings.Count-1 do begin
    if i=0 then
      Result:=Strings[i]
    else
      Result:=Result+Delim+Strings[i]
  end;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

function FormatEx(const Msg: String; Args: TBisVariants): String;
var
  i: Integer;
  S: Char;
  Buf: String;
  NCount: Integer;
  Flag: Boolean;

const
  Delim='%';
  Accept=['s','d','u','e','f','g','n','m','p','x','*','.','0','1','2','3','4','5','6','7','8','9','#','-'];

  procedure SetResult;
  var
    V: Variant;
    NS: String;
  begin
    if Args.Count>NCount then begin
      V:=Args.Items[NCount].Value;
      NS:=VarToStrDef(V,'');
      try
        case VarType(V) of
          varShortInt, varSmallint, varInteger, varInt64: begin
            if Buf[1]='d' then
              Buf:=Format(Delim+Buf,[StrToInt(NS)]);
          end;
          varSingle, varDouble, varCurrency: begin
            if Buf[1] in ['e','f','g','n','m'] then
              Buf:=Format(Delim+Buf,[StrToFloat(NS)]);
          end;
//          varDate: Buf:=Format(Delim+Buf,[DateTimeToStr(NS)]);
        else
          Buf:=Format(Delim+Buf,[NS]);
        end;
      except
      end;
    end else
      Buf:=Delim+Buf;
    if S<>#0 then
      Result:=Result+Buf+S
    else Result:=Result+Buf;
  end;

begin
  S:=#0;
  Result:='';
  NCount:=0;
  Flag:=false;
  for i:=1 to Length(Msg) do begin
    S:=Msg[i];
    if (S=Delim) then begin
      if Flag then begin
        S:=#0;
        SetResult;
        Inc(NCount);
      end;
      Buf:='';
      Flag:=true;
    end else begin
      if not Flag then
        Result:=Result+S
      else begin
        if not (S in Accept) then begin
          SetResult;
          Flag:=false;
          Inc(NCount);
        end else begin
          Buf:=Buf+S;
        end;
      end;
    end;
  end;
  if Flag and (Trim(Buf)<>'') then begin
    S:=#0;
    SetResult;
  end;
end;

function FormatEx(const Msg: String; const Args: array of const): String;
var
  V: TBisVariants;
begin
  V:=TBisVariants.Create;
  try
    V.AssignArray(Args);
    Result:=FormatEx(Msg,V);
  finally
    V.Free;
  end; 
end;

procedure FreeAndNilEx(var Obj);
var
  Temp: TObject;
begin
  if Pointer(Obj)<>nil then begin
    Temp:=TObject(Obj);
    try
      Pointer(Obj):=nil;
      FreeAndNil(Temp); 
    except
    end;
  end;
end;

function GetFieldTypeByVarType(VType: Word): TFieldType;
begin
  Result:=ftUnknown;
  case VType of
    varEmpty: Result:=ftUnknown;
    varNull: Result:=ftUnknown;
    varSmallint: Result:=ftSmallint;
    varInteger: Result:=ftInteger;
    varSingle: Result:=ftFloat;
    varDouble: Result:=ftFloat;
    varCurrency: Result:=ftCurrency;
    varDate: Result:=ftDateTime;
    varOleStr: Result:=ftString;
    varDispatch: Result:=ftUnknown;
    varError: Result:=ftUnknown;
    varBoolean: Result:=ftBoolean;
    varVariant: Result:=ftVariant;
    varUnknown: Result:=ftUnknown;
    varShortInt: Result:=ftSmallint;
    varByte: Result:=ftSmallint;
    varWord: Result:=ftWord;
    varLongWord: Result:=ftInteger;
    varInt64: Result:=ftLargeint;
    varStrArg: Result:=ftString;
    varString: Result:=ftString;
  end;
end;

procedure GetWordsFromString(S: string; Strings: TStringList);
type
  TSetOfChar=set of char;

  function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
  var
    tmps: string;
    i: integer;
  begin
    for i:=1 to Length(s) do begin
      if S[i] in SetOfChar then break;
      tmps:=tmps+S[i];
      Pos:=i;
    end;
    Result:=tmps;
  end;

var
  Pos: Integer;
  word: string;
  incPos: Integer;
  isInc: Boolean;
const
  Separators: set of char = [#00,' ','-',#13, #10,'.',',','/','\', '#', '"', '''','!','?','$','@',
                             ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];
begin
  if SysUtils.Trim(S)='' then exit;
  incPos:=0;
  while true do begin
    Pos:=1;
    word:=GetFirstWord(s,Separators,Pos);
    if (s[Pos]=#13)or(s[Pos]=#10) then
      isInc:=false
    else isInc:=true;

    s:=Copy(s,Pos+1,Length(s)-Pos);
    if (SysUtils.Trim(word)<>'')and
       (Length(word)>1) then
          Strings.AddObject(word,TObject(Pointer(incPos)));
    if SysUtils.Trim(s)='' then exit;

    if isInc then
     incPos:=incPos+Pos;
  end;
end;

function GetFirstWord(S: String): String;
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
    Result:=S;
    GetWordsFromString(S,Str);
    if Str.Count>0 then
      Result:=Str.Strings[0];
  finally
    Str.Free;
  end;
end;

function CharIsNumber(const C: AnsiChar): Boolean;
begin
  Result := ((AnsiCharTypes[C] and C1_DIGIT) <> 0) or
             (C in AnsiSigns) or (C = DecimalSeparator);
end;

function CharIsNumberEx(const C: Char): Boolean;
begin
  Result := (C in DigitSigns) or
            (C in AnsiSigns) or (C = DecimalSeparator);
end;

function CharIsDigit(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_DIGIT) <> 0;
end;

function CharIsControl(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_CNTRL) <> 0;
end;

function CharIsPrintable(const C: AnsiChar): Boolean;
begin
  Result := not CharIsControl(C);
end;

function CharIsAlpha(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_ALPHA) <> 0;
end;

function CharValidDate(const C: AnsiChar): Boolean;
begin
  Result:=CharIsDigit(C) or
          (C = DateSeparator);
end;

function StrLeft(const S: AnsiString; Count: Integer): AnsiString;
begin
  Result := Copy(S, 1, Count);
end;

function GetChangedText(const Text: string; SelStart, SelLength: integer; Key: char): string;
begin
  Result := Text;
  if SelLength > 0 then
    Delete(Result, SelStart + 1, SelLength);
  if Key <> #0 then
    Insert(Key, Result, SelStart + 1);
end;

function VarToDateDef(const V: Variant; const ADefault: TDateTime): TDateTime;
begin
  try
    if not VarIsNull(V) then
      Result:=VarToDateTime(V)
    else
      Result:=ADefault;
  except
    Result:=ADefault;
  end;
end;

function VarToDateTimeDef(const V: Variant; const ADefault: TDateTime): TDateTime;
begin
  Result:=VarToDateDef(V,ADefault);
end;

function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
begin
  try
    if not VarIsNull(V) then
      case VarType(V) of
        varSmallint,varInteger,varShortInt,varByte,varWord,varLongWord,varInt64: Result:=V;
        varOleStr,varStrArg,varString: begin
          if not TryStrToInt(V,Result) then
            Result:=ADefault;
        end;
        varSingle,varDouble,varCurrency: Result:=Round(V);
        varBoolean: Result:=Integer(V);
      else
        Result:=ADefault
      end
    else
      Result:=ADefault;
  except
    Result:=ADefault;
  end;    
end;

function VarToExtendedDef(const V: Variant; const ADefault: Extended): Extended;
begin
  try
    if not VarIsNull(V) then
      case VarType(V) of
        varSmallint,varInteger,varShortInt,varByte,varWord,varLongWord,varInt64: Result:=V;
        varOleStr,varStrArg,varString: begin
          if not TryStrToFloat(V,Result) then
            Result:=ADefault;
        end;
        varSingle,varDouble,varCurrency: Result:=V;
        varBoolean: Result:=Integer(Round(V));
      else
        Result:=ADefault
      end
    else
      Result:=ADefault;
  except
    Result:=ADefault
  end;
end;

function IsClassParent(AClassIn: TClass; AClassParent: TClass): Boolean;
var
  AncestorClass: TClass;
begin
  AncestorClass := AClassIn;
  while (AncestorClass <> AClassParent) do
  begin
    if AncestorClass=nil then begin Result:=false; exit; end;
    AncestorClass := AncestorClass.ClassParent;
  end;
  Result:=true;
end;

procedure ClearStrings(Strings: TStrings);
var
  i: Integer;
  Obj: TObject;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to Strings.Count-1 do begin
        Obj:=Strings.Objects[i];
        if Assigned(Obj) then
          FreeAndNilEx(Obj);
      end;
      Strings.Clear;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

function GetFirstMenuChecked(Items: TMenuItem): TMenuItem;
var
  i: Integer;
begin
  Result:=nil;
  if Assigned(Items) then
    for i:=0 to Items.Count-1 do begin
      if Items[i].Checked then begin
        Result:=Items[i];
        exit;
      end;
    end;
end;

type
  TWrapper=class(TComponent)
  private
    FObj: TObject;
  published
    property Obj: TObject read FObj write FObj;
  end;

procedure SaveObjectToFile(Obj: TObject; FileName: String);
var
  Wrapper: TWrapper;
  Stream1: TMemoryStream;
  Stream2: TFileStream;
begin
  Wrapper:=TWrapper.Create(nil);
  Stream1:=TMemoryStream.Create;
  Stream2:=TFileStream.Create(FileName,fmCreate);
  try
    Wrapper.Obj:=Obj;
    Stream1.WriteComponent(Wrapper);
    Stream1.Position:=0;
    ObjectBinaryToText(Stream1,Stream2);
  finally
    Stream2.Free;
    Stream1.Free;
    Wrapper.Free;
  end;
end;

function GetFilterString(Strings: TStrings; Operator: String): String;
var
  i: Integer;
  Flag: Boolean;
begin
  Result:='';
  Flag:=false;
  for i:=0 to Strings.Count-1 do begin
    if Flag and (Strings.Strings[i]<>'') then begin
      Result:=Format('%s %s %s',[Result,Operator,Strings[i]]);
    end;
    if not Flag and (Strings[i]<>'') then begin
      Flag:=true;
      Result:=Strings[i];
    end;
  end;
end;

function GetFileSizeEx(FileName: String): Integer;
var
  H: THandle;
begin
  H:=FileOpen(FileName,fmOpenRead or fmShareDenyNone);
  try
    Result:=Windows.GetFileSize(H,nil);
  finally
    FileClose(H);
  end;
end;

function GetFileTimeEx(FileName: String): TDateTime;
var
  H: THandle;
  CreationTime, LastAccessTime, LastWriteTime: TFileTime;
  LocalFileTime: TFileTime;
  TimeExt: Integer;
begin
  H:=FileOpen(FileName,fmOpenRead or fmShareDenyNone);
  try
    GetFileTime(H,@CreationTime,@LastAccessTime,@LastWriteTime);
    FileTimeToLocalFileTime(LastWriteTime,LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime,LongRec(TimeExt).Hi, LongRec(TimeExt).Lo);
    Result:=FileDateToDateTime(TimeExt);
  finally
    FileClose(H);
  end;
end;

function VisibleControlCharacters(const S: String; Delimiter: String='#'; Hex: Boolean=true): String;
var
  I, L: Integer;
  B: Byte;
begin
  Result:='';
  L := Length(S);
  for i:=1 to L do begin
    if S[i] < ' ' then begin
      B:=Byte(S[i]);
      if Hex then
        Result:=Result+Delimiter+IntToHex(B,2)
      else
        Result:=Result+Delimiter+IntToStr(B);
    end else
      Result:=Result+S[i];
  end;
end;

function GetOnlyChars(const S: String; Chars: TSetOfChar): String;
var
  i: Integer;
  L: Integer;
begin
  Result:='';
  L:=Length(S);
  for i:=1 to L do begin
    if S[i] in Chars then
      Result:=Result+S[i];
  end;
end;

function GetOnlyNumbers(const S: String): String;
const
  Chars=['0','1','2','3','4','5','6','7','8','9'];
begin
  Result:=GetOnlyChars(S,Chars);
end;

function RemoveChars(const S: String; Chars: TSetOfChar): String;
var
  i: Integer;
begin
  Result:='';
  for i:=1 to Length(S) do
    if not (S[i] in Chars) then
      Result:=Result+S[i];
end;

function RemoveNoneFilenameChars(const S: String): String;
const
  NoneValid: set of char = ['/','\','"','?','*','<','>',':','|'];
begin
  Result:=RemoveChars(S,NoneValid);
end;

function QuotedChars(const S: String; Chars: TSetOfChar): String;
var
  i: Integer;
begin
  Result:=S;
  for i:=1 to Length(S) do
    if (S[i] in Chars) then begin
      Result:='"'+Result+'"';
      break;
    end;
end;

function QuotedFileName(const S: String): String;
const
  NoneValid: set of char = [' '];
begin
  Result:=QuotedChars(S,NoneValid);
end;

procedure EnableControl(Control: TWinControl; Enabled: Boolean);
var
  i: Integer;
begin
  if Assigned(Control) then begin
    Control.Enabled:=Enabled;
    for i:=0 to Control.ControlCount-1 do begin
      Control.Controls[i].Enabled:=Enabled;
      if (Control.Controls[i] is TWinControl) then
        EnableControl(TWinControl(Control.Controls[i]),Enabled);
    end;
  end;
end;

procedure GetDirFiles(Dir: String; FileDirs: TStringList; OnlyFiles, StopFirst: Boolean);
var
  AttrWord: Word;
  FMask: String;
  MaskPtr: PChar;
  Ptr: Pchar;
  FileInfo: TSearchRec;
  S: string;
begin
  if StopFirst then begin
    if FileDirs.Count>0 then
      exit;
  end;
  if not DirectoryExists(Dir) then exit;
  AttrWord :=faAnyFile+faReadOnly+faHidden+faSysFile+faVolumeID+faDirectory+faArchive;
  if SetCurrentDirectory(Pchar(Dir)) then begin
    FMask:='*.*';
    MaskPtr := PChar(FMask);
    while MaskPtr <> nil do begin
      Ptr := StrScan (MaskPtr, ';');
      if Ptr <> nil then
        Ptr^ := #0;
      if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then begin
        repeat
          S:=Dir+'\'+FileInfo.Name;
          if (FileInfo.Attr and faDirectory <> 0) then begin
            if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') and not OnlyFiles then begin
              with FileInfo.FindData do begin
                GetDirFiles(S,FileDirs,OnlyFiles,StopFirst);
                if not OnlyFiles then begin
                  FileDirs.Add(S);
                  if StopFirst then break;
                end;  
              end;
            end;
          end else begin
            with FileInfo.FindData do begin
              FileDirs.Add(S);
              if StopFirst then break;
            end;  
          end;
        until FindNext(FileInfo) <> 0;
        FindClose(FileInfo);
      end;
      if Ptr <> nil then begin
        Ptr^ := ';';
        Inc (Ptr);
      end;
      MaskPtr := Ptr;
    end;
  end;
end;

function GetTickCount(var Freq: Int64): Int64;
var
  Old: DWord;
begin
  Old:=SetThreadAffinityMask(GetCurrentThread,0);
  try
    QueryPerformanceFrequency(Freq);
    QueryPerformanceCounter(Result);
  finally
    SetThreadAffinityMask(GetCurrentThread,Old);
  end;
end;

function GetTickDifference(const Tick1,Freq1,Tick2,Freq2: Int64; const DiffType: TBisTickDifferenceType): Int64;
var
  Factor: Byte;
begin
  Result:=0;
  if Freq1>0 then begin

    Factor:=0;
    case DiffType of
      dtDefault: Factor:=0;
      dtNanoSec: Factor:=9;
      dtMilliSec: Factor:=3;
      dtSec: Factor:=0;
    end;

    Result:=Trunc((Tick2-Tick1)/((Freq1+Freq2)/2)*Power(10,Factor));
    if Result<0 then
      Result:=-Result;

  end;
end;

function GetTickDifference(const Tick,Freq: Int64; const DiffType: TBisTickDifferenceType): Int64;
var
  T2,F2: Int64;
  Old: DWord;
begin
  Result:=0;
  if Freq>0 then begin

    Old:=SetThreadAffinityMask(GetCurrentThread,0);
    try
      QueryPerformanceFrequency(F2);
      QueryPerformanceCounter(T2);
    finally
      SetThreadAffinityMask(GetCurrentThread,Old);
    end;

    Result:=GetTickDifference(Tick,Freq,T2,F2,DiffType);
  end;
end;

{function GetTickCountEx: Cardinal;
var
  nTime, freq: Int64;
begin
  if QueryPerformanceFrequency(freq) then begin
    if QueryPerformanceCounter(nTime) then begin
      Result:=Trunc((nTime / Freq) * 1000) and High(Cardinal)
    end else begin
      Result:=GetTickCount;
    end;
  end else begin
    Result:=GetTickCount;
  end;
end;}

function RandomString(Count: Integer): String;
var
  L: Integer;
  M: Integer;
  D: Integer;
  i: Integer;
  S: String;
begin
  L:=Length(GetUniqueID);
  M:=Count mod L;
  D:=Count div L;
  S:='';
  for i:=0 to D do begin
   if i=D then
     S:=S+Copy(GetUniqueID,1,M)
   else
     S:=S+GetUniqueID;
  end;
  Result:=PChar(S);
end;

function ParseName(const S, Delim: String; var Name, Value: String): Boolean;
var
  APos: Integer;
begin
  APos:=AnsiPos(Delim,S);
  if APos>0 then begin
    Name:=Copy(S,1,APos-1);
    Value:=Copy(S,APos+Length(Delim),Length(S));
  end else
    Name:=S;
  Result:=(Name<>'') or (Value<>'');
end;

function ParseBetween(const S, LDelim, RDelim: String; var Value: String): Boolean;
var
  APos: Integer;
  S1: String;
begin
  APos:=AnsiPos(LDelim,S);
  if APos>0 then begin
    Value:=Copy(S,1,APos-1);
    S1:=Copy(S,APos+Length(LDelim),Length(S));
    APos:=AnsiPos(RDelim,S1);
    if APos>0 then begin
      Value:=Copy(S1,1,APos-1);
    end else
      Value:=S1;
  end else
    Value:=S;
  Result:=Value<>'';
end;

function VarSameValueEx(const A, B: Variant): Boolean;
var
  VType: Word;
  LA, LB: TVarData;
  Dim1, Dim2, H, L: Integer;
  i: Integer;
  Ret: Boolean;
begin
  Result:=false;
  LA:=FindVarData(A)^;
  LB:=FindVarData(B)^;
  if LA.VType=varEmpty then
    Result:=LB.VType=varEmpty
  else if LA.VType=varNull then
    Result:=LB.VType=varNull
  else if LB.VType in [varEmpty,varNull] then
    Result := False
  else begin
    VType:=varArray or varVariant;
    if LA.VType<>VType then
      Result:=A=B
    else begin
      Dim1:=VarArrayDimCount(A);
      Dim2:=VarArrayDimCount(B);
      if (Dim1=Dim2) and (Dim1=1) then begin
        Ret:=false;
        L:=VarArrayLowBound(A,Dim1);
        H:=VarArrayHighBound(A,Dim1);
        for i:=L to H do begin
          if i=L then
            Ret:=VarSameValue(A[i],B[i])
          else
            Ret:=Ret and VarSameValue(A[i],B[i]);
        end;
        Result:=Ret;
      end;
    end;
  end;
end;

function ArraySameValues(Arr1,Arr2: array of Variant): Boolean;
var
  L1,L2: Integer;
  i: Integer;
  Flag: Boolean;
begin
  Result:=false;
  L1:=Length(Arr1);
  L2:=Length(Arr2);
  if L1=L2 then begin
    Flag:=false;
    for i:=Low(Arr1) to High(Arr1) do begin
      if i=Low(Arr1) then
        Flag:=VarSameValueEx(Arr1[i],Arr2[i])
      else
        Flag:=Flag and VarSameValueEx(Arr1[i],Arr2[i]);
    end;
    Result:=Flag;
  end;
end;

function GetMemoryPageSize: Cardinal;
var
  T: TSystemInfo;
begin
  GetSystemInfo(T);
  Result:=T.dwPageSize;
end;

function IsMainThread: Boolean;
begin
  Result:=GetCurrentThreadId=MainThreadID;
end;

function GetComponentName(const Name,Default: String; Owner: TComponent): String;
var
  Component: TComponent;
  Counter: Integer;
begin
  Result:=iff(Trim(Name)='',Default,Name);
  if Assigned(Owner) then begin
    Counter:=1;
    Component:=Owner.FindComponent(Result);
    while Assigned(Component) do begin
      Result:=Default+IntToStr(Counter);
      Component:=Owner.FindComponent(Result);
      Inc(Counter);
    end;
  end;
end;

procedure Output(const S: String);
begin
  OutputDebugString(PChar(S));
end;

function CreateDirEx(const Dir: String): Boolean;

  procedure GetDirs(str: TStringList);
  var
    i: Integer;
    s,tmps: string;
  begin
    tmps:='';
    for i:=1 to Length(Dir) do begin
      if dir[i]=PathDelim then begin
        s:=tmps;
        str.Add(s);
      end;
      tmps:=tmps+Dir[i];
    end;
    str.Add(Dir);
  end;

var
  Str: TStringList;
  i: Integer;
begin
  Str:=TStringList.Create;
  try
    GetDirs(str);
    for i:=0 to str.Count-1 do
      CreateDir(str.Strings[i]);
    Result:=DirectoryExists(Dir);
  finally
    Str.Free;
  end;
end;

function GetNameByClass(ClassName: String): String;
begin
  Result:=Copy(ClassName,Length(SDefaultClassPrefix)+1,Length(ClassName));
end;


///////////////////////////////////////////////

procedure LoadCharTypes;
var
  CurrChar: AnsiChar;
  CurrType: Word;
begin
  {$IFDEF MSWINDOWS}
  for CurrChar := Low(AnsiChar) to High(AnsiChar) do
  begin
    GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @CurrChar, SizeOf(AnsiChar), CurrType);
    AnsiCharTypes[CurrChar] := CurrType;
  end;
  {$ENDIF}
end;

initialization

  LoadCharTypes;

end.
