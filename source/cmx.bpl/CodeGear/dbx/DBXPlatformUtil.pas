unit DBXPlatformUtil;

interface
{$IFDEF CLR}
uses System.Text, System.Collections, System.Reflection, SqlTimSt;
{$ELSE}
uses Math, WideStrings, SqlTimSt;
{$ENDIF}

resourcestring
  SIllegalArgument = 'Illegal argument';
  SUnsupportedOperation = 'Unsupported operation';

type
  TDBXDynamicCharArray = array of Char;
  TDBXDynamicBooleanArray = array of Boolean;
  TDBXWideStringArray = array of WideString;
  TDBXObjectArray = array of TObject;

  TDBXInt32Object = class
  public
    constructor Create(const Value: Integer);
    destructor Destroy; override;
    function IntValue: Integer;
  private
    FValue: Integer;
  end;

  TDBXTokenizer = class
  private
    FOriginal: WideString;
    FDelimiters: WideString;
    FNextPos: Integer;
  public
    constructor Create(const Original: WideString; const Delimiters: WideString);
    function HasMoreTokens: Boolean;
    function NextToken: WideString;
  end;

function Incr(var Arg: Integer): Integer; inline;
function Decr(var Arg: Integer): Integer; inline;
function IncrAfter(var Arg: Integer): Integer; inline;
function DecrAfter(var Arg: Integer): Integer; inline;
function C_Conditional(const Condition: Boolean; const TruePart, FalsePart: WideString): WideString;
function CompareTimeStamp(const ATimeStamp: TSQLTimeStamp; const BTimeStamp: TSQLTimeStamp): Integer;

{$IFDEF CLR}
const
  NullString = nil;

type
  TDBXStringList = ArrayList;
  TDBXArrayList = ArrayList;
  TDBXWideStringBuffer = System.Text.StringBuilder;
  TDBXFreeArray = TObject;

  TDBXObjectStore = class(Hashtable)
  private
    function GetObjectFromName(const Name: WideString): TObject; inline;
    procedure SetObjectByName(const Name: WideString; const Value: TObject); inline;
  public
    constructor Create;
    property Objects[const Name: WideString]: TObject read GetObjectFromName write SetObjectByName; default;
  end;

  TDBXStringStore = class(Hashtable)
  private
    function GetString(const Name: WideString): WideString; inline;
    procedure SetString(const Name: WideString; const Value: WideString); inline;
  public
    constructor Create;
    function Contains(const Name: WideString): Boolean;
    property Strings[const Name: WideString]: WideString read GetString write SetString; default;
  end;

function ObjectEquals(const Obj1: TObject; const Obj2: TObject): Boolean;
procedure FreeObjectArray(ArrayObject: TDBXFreeArray);
function StringIndexOf(const Str: WideString; const Ch: WideChar): Integer; overload; inline;
function StringIndexOf(const Str: WideString; const Part: WideString): Integer; overload; inline;
function StringIndexOf(const Str: WideString; const Part: WideString; FromIndex: Integer): Integer; overload; inline;
function StringLastIndexOf(const Str: WideString; const Part: WideString): Integer; inline;
function StringStartsWith(const Str: WideString; const Part: WideString): Boolean; inline;
function StringEndsWith(const Str: WideString; const Part: WideString): Boolean; inline;
function StringIsNil(const Str: WideString): Boolean;
function IsIdentifierStart(const Ch: WideChar): Boolean; inline;
function IsIdentifierPart(const Ch: WideChar): Boolean; inline;
function SubString(Buffer: TDBXWideStringBuffer; Index: Integer): WideString;
function FormatMessage(const FormatString: WideString; const Parameters: TDBXWideStringArray): WideString;

{$ELSE}
const
  NullString = '';

type
  TDBXStringList = TWideStringList;
  TDBXFreeArray = TDBXObjectArray;

  TDBXWideStringBuffer = class
  private
    FBuffer: WideString;
    FCount: Integer;
  public
    constructor Create; overload;
    constructor Create(InitialSize: Integer); overload;
    procedure Append(const Value: WideString); overload;
    procedure Append(const Value: Integer); overload;
    procedure Append(const Value: TDBXWideStringBuffer); overload;
    property Length: Integer read FCount write FCount;
    procedure Replace(const Original, Replacement: WideString; const StartIndex: Integer; const Count: Integer);
    function ToString: WideString;
    function Substring(const Ordinal: Integer): WideString;
  end;

  TDBXArrayList = class
  private
    FList: TDBXObjectArray;
    FCount: Integer;
  private
    function GetValue(Index: Integer): TObject;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(Element: TObject);
  public
    property Count: Integer read FCount;
    property Values[Index: Integer]: TObject read GetValue; default;
  end;

  TDBXObjectStore = class(TDBXStringList)
  private
    function GetObjectFromName(const Name: WideString): TObject;
    procedure SetObjectByName(const Name: WideString; const Value: TObject);
  public
    destructor Destroy; override;
    function ContainsKey(const Name: WideString): Boolean;
    property Objects[const Name: WideString]: TObject read GetObjectFromName write SetObjectByName; default;
  end;

  TDBXStringStore = class(TDBXStringList)
  private
    function GetString(const Name: WideString): WideString;
    procedure SetString(const Name: WideString; const Value: WideString);
  public
    function Contains(const Name: WideString): Boolean;
    property Strings[const Name: WideString]: WideString read GetString write SetString; default;
  end;

function ObjectEquals(const Obj1: TObject; const Obj2: TObject): Boolean;
procedure FreeObjectArray(var ArrayObject: TDBXFreeArray);
function StringIndexOf(const Str: WideString; const Ch: WideChar): Integer; overload;
function StringIndexOf(const Str: WideString; const Part: WideString): Integer; overload; inline;
function StringIndexOf(const Str: WideString; const Part: WideString; FromIndex: Integer): Integer; overload; inline;
function StringLastIndexOf(const Str: WideString; const Part: WideString): Integer;
function StringStartsWith(const Str: WideString; const Part: WideString): Boolean; inline;
function StringEndsWith(const Str: WideString; const Part: WideString): Boolean; inline;
function StringIsNil(const Str: WideString): Boolean; inline;
function IsIdentifierStart(const Ch: WideChar): Boolean;
function IsIdentifierPart(const Ch: WideChar): Boolean;
function SubString(Buffer: TDBXWideStringBuffer; Index: Integer): WideString; inline;
function FormatMessage(const FormatString: WideString; const Parameters: TDBXWideStringArray): WideString;

{$ENDIF}

implementation
{$IFDEF CLR}
uses
  SysUtils;
{$ELSE}
uses
  SysUtils, StrUtils, WideStrUtils;
{$ENDIF}

resourcestring
  SUnmatchedBrace = 'Unmatched brace found in format string: %s';
  SParameterIndexOutOfRange = 'Unmatched brace found in format string: %d';

constructor TDBXInt32Object.Create(const Value: Integer);
begin
  inherited Create;
  FValue := Value;
end;

destructor TDBXInt32Object.Destroy;
begin
  inherited Destroy;
end;


function TDBXInt32Object.IntValue: Integer;
begin
  Result := FValue;
end;

constructor TDBXTokenizer.Create(const Original: WideString; const Delimiters: WideString);
begin
  Inherited Create;
  FOriginal := Original;
  FDelimiters := Delimiters;
  FNextPos := 1;
end;

function TDBXTokenizer.HasMoreTokens: Boolean;
var
  Ch: WideChar;
begin
  Result := False;
  while FNextPos <= Length(FOriginal) do
  begin
    Ch := FOriginal[FNextPos];
    if StringIndexOf(FDelimiters,Ch) < 0 then
    begin
      Result := True;
      Exit;
    end;
    Inc(FNextPos);
  end;
end;

function TDBXTokenizer.NextToken: WideString;
var
  Ch: WideChar;
  StartPos: Integer;
begin
  if not HasMoreTokens then
    Result := ''
  else
  begin
    StartPos := FNextPos;
    while FNextPos <= Length(FOriginal) do
    begin
      Ch := FOriginal[FNextPos];
      if StringIndexOf(FDelimiters,Ch) < 0 then
        Inc(FNextPos)
      else
        Break;
    end;
    Result := Copy(FOriginal, StartPos, FNextPos - StartPos);
  end;
end;

function Incr(var Arg: Integer): Integer; inline;
begin
  Inc(Arg);
  Result := Arg;
end;

function Decr(var Arg: Integer): Integer; inline;
begin
  Dec(Arg);
  Result := Arg;
end;

function IncrAfter(var Arg: Integer): Integer; inline;
begin
  Result := Arg;
  Inc(Arg);
end;

function DecrAfter(var Arg: Integer): Integer; inline;
begin
  Result := Arg;
  Dec(Arg);
end;

function C_Conditional(const Condition: Boolean; const TruePart, FalsePart: WideString): WideString;
begin
  if Condition then
    Result := TruePart
  else
    Result := FalsePart;
end;

function CompareTimeStamp(const ATimeStamp: TSQLTimeStamp; const BTimeStamp: TSQLTimeStamp): Integer;
var
  Status: Integer;
begin
  Status := ATimeStamp.Year - BTimeStamp.Year;
  if Status = 0 then
    Status := ATimeStamp.Month - BTimeStamp.Month;
  if Status = 0 then
    Status := ATimeStamp.Day - BTimeStamp.Day;
  if Status = 0 then
    Status := ATimeStamp.Hour - BTimeStamp.Hour;
  if Status = 0 then
    Status := ATimeStamp.Hour - BTimeStamp.Hour;
  if Status = 0 then
    Status := ATimeStamp.Minute - BTimeStamp.Minute;
  if Status = 0 then
    Status := ATimeStamp.Second - BTimeStamp.Second;
  if Status = 0 then
    Status := ATimeStamp.Fractions - BTimeStamp.Fractions;
  Result := Status;
end;

{$IFDEF CLR}
function ObjectEquals(const Obj1: TObject; const Obj2: TObject): Boolean;
begin
  Result := Obj1.Equals(Obj2);
end;

procedure FreeObjectArray(ArrayObject: TDBXFreeArray);
begin
end;

function StringIndexOf(const Str: WideString; const Ch: WideChar): Integer;
begin
  Result := Str.IndexOf(Ch);
end;

function StringIndexOf(const Str: WideString; const Part: WideString): Integer;
begin
  Result := Str.IndexOf(Part);
end;

function StringIndexOf(const Str: WideString; const Part: WideString; FromIndex: Integer): Integer;
begin
  Result := Str.IndexOf(Part, FromIndex);
end;

function StringLastIndexOf(const Str: WideString; const Part: WideString): Integer;
begin
  Result := Str.LastIndexOf(Part);
end;

function StringStartsWith(const Str: WideString; const Part: WideString): Boolean;
begin
  Result := Str.StartsWith(Part);
end;

function StringEndsWith(const Str: WideString; const Part: WideString): Boolean;
begin
  Result := Str.EndsWith(Part);
end;

function StringIsNil(const Str: WideString): Boolean;
begin
  Result := TObject(Str) = nil;
end;

function IsIdentifierStart(const Ch: WideChar): Boolean;
begin
  Result := System.Char.IsLetter(Ch) or (Ch = '$') or (Ch = '_');
end;

function IsIdentifierPart(const Ch: WideChar): Boolean;
begin
  Result := System.Char.IsLetterOrDigit(Ch) or (Ch = '$') or (Ch = '_');
end;

function SubString(Buffer: TDBXWideStringBuffer; Index: Integer): WideString;
begin
  Buffer.ToString.Substring(Index);
end;

function FormatMessage(const FormatString: WideString; const Parameters: TDBXWideStringArray): WideString;
var
  Objects: array of TObject;
  Index: Integer;
begin
  SetLength(Objects, Length(Parameters));
  for Index := Low(Objects) to High(Objects) do
    Objects[Index] := Parameters[Index];
  Result := System.String.Format(FormatString, Objects);
end;

type
  TDefaultEqualityComparer = class(TObject,IEqualityComparer)
  public
    function Equals(X: TObject; Y: TObject): Boolean;
    function GetHashCode(Obj: TObject): Integer;
  end;

function TDefaultEqualityComparer.Equals(X: TObject; Y: TObject): Boolean;
begin
  Result := X.Equals(Y)
end;

function TDefaultEqualityComparer.GetHashCode(Obj: TObject): Integer;
begin
  Result := Obj.GetHashCode;
end;

constructor TDBXObjectStore.Create;
begin
  Inherited Create(TDefaultEqualityComparer.Create);
end;

function TDBXObjectStore.GetObjectFromName(const Name: WideString): TObject;
begin
  Result := Inherited Item[TObject(Name)];
end;

procedure TDBXObjectStore.SetObjectByName(const Name: WideString; const Value: TObject);
begin
  Inherited Item[TObject(Name)] := Value;
end;

constructor TDBXStringStore.Create;
begin
  Inherited Create(TDefaultEqualityComparer.Create);
end;

function TDBXStringStore.Contains(const Name: WideString): Boolean;
begin
  Result := ContainsKey(TObject(Name));
end;

function TDBXStringStore.GetString(const Name: WideString): WideString;
begin
  Result := Item[TObject(Name)] as WideString;
end;

procedure TDBXStringStore.SetString(const Name: WideString; const Value: WideString);
begin
  Item[TObject(Name)] := TObject(Value);
end;

{$ELSE}

function ObjectEquals(const Obj1: TObject; const Obj2: TObject): Boolean;
begin
  Result := (Obj1 = Obj2);
end;

procedure FreeObjectArray(var ArrayObject: TDBXFreeArray);
var
  Index: Integer;
begin
  if ArrayObject <> nil then
  begin
    for Index := Low(ArrayObject) to High(ArrayObject) do
      ArrayObject[Index].Free;
    ArrayObject := nil;
  end;
end;

function StringIndexOf(const Str: WideString; const Ch: WideChar): Integer;
var
  Ptr: PWideChar;
begin
  Ptr := WStrScan(PWideChar(Str),Ch);
  if Ptr = nil then
    Result := -1
  else
    Result := Ptr - PWideChar(Str);
end;

function StringIndexOf(const Str: WideString; const Part: WideString): Integer;
begin
  Result := Pos(Part,Str)-1;
end;

function StringIndexOf(const Str: WideString; const Part: WideString; FromIndex: Integer): Integer;
begin
  Result := PosEx(Part,Str,FromIndex+1)-1;
end;

function StringLastIndexOf(const Str: WideString; const Part: WideString): Integer;
var
  PosA, PosB: Integer;
  FirstChar: WideChar;
begin
  if Length(Part) = 0 then
    Result := Length(Str)-1
  else if Length(Part) > Length(Str) then
    Result := -1
  else
  begin
    Result := -1;
    FirstChar := Part[1];
    for PosA := Length(Str)-Length(Part)+1 downto 1 do
    begin
      if Str[PosA] = FirstChar then
      begin
        PosB := 2;
        while (PosB <= Length(Part)) and (Str[PosA+PosB-1] = Part[PosB]) do
          Inc(PosB);
        if PosB > Length(Part) then
        begin
          Result := PosA - 1;
          exit;
        end;
      end;
    end;
  end;
end;

function StringStartsWith(const Str: WideString; const Part: WideString): Boolean;
begin
  Result := AnsiStartsText(Part,Str);
end;

function StringEndsWith(const Str: WideString; const Part: WideString): Boolean;
begin
  Result := AnsiEndsText(Part,Str);
end;

function StringIsNil(const Str: WideString): Boolean;
begin
  Result := Str = NullString;
end;

function IsIdentifierStart(const Ch: WideChar): Boolean;
begin
  case Ch of
    'a'..'z',
    'A'..'Z',
    '_':
      Result := True;
    else
      Result := False;
  end;
end;

function IsIdentifierPart(const Ch: WideChar): Boolean;
begin
  case Ch of
    'a'..'z',
    'A'..'Z',
    '0'..'9',
    '_':
      Result := True;
    else
      Result := False;
  end;
end;

function SubString(Buffer: TDBXWideStringBuffer; Index: Integer): WideString;
begin
  Result := Buffer.SubString(Index);
end;

function FormatMessage(const FormatString: WideString; const Parameters: TDBXWideStringArray): WideString;
var
  Buffer: TDBXWideStringBuffer;
  Ch: WideChar;
  Index: Integer;
  Start: Integer;
  ParameterIndex: Integer;
  Quoted: Boolean;
begin
  Index := 1;
  Quoted := False;
  Buffer := TDBXWideStringBuffer.Create;
  while Index <= Length(FormatString) do
  begin
    Ch := FormatString[Index];
    case Ch of
      '{':
        begin
          Start := Index+1;
          while (Index < Length(FormatString)) and (Ch <> '}') do
          begin
            Inc(Index);
            Ch := FormatString[Index];
          end;
          if Ch <> '}' then
            raise Exception.Create(SysUtils.Format(SUnmatchedBrace,[FormatString]));
          ParameterIndex := StrToInt(Copy(FormatString,Start,Index-Start));
          if (ParameterIndex < 0) or (ParameterIndex > Length(Parameters)) then
            raise Exception.Create(SysUtils.Format(SParameterIndexOutOfRange,[ParameterIndex]));
          Buffer.Append(Parameters[ParameterIndex]);
          Inc(Index);
        end;

      '''':
        begin
          if (Index=Length(FormatString)) or (FormatString[Index+1] <> '''') then
            Quoted := not Quoted
          else
          begin
            Buffer.Append(Ch);
            Inc(Index);
          end;
        end;

      else
        Buffer.Append(Ch);
        Inc(Index);
    end;
  end;
  Result := Buffer.ToString;
  FreeAndNil(Buffer);
end;

constructor TDBXWideStringBuffer.Create;
begin
  inherited Create;
end;

constructor TDBXWideStringBuffer.Create(InitialSize: Integer);
begin
  inherited Create;
  SetLength(FBuffer,InitialSize);
end;

function TDBXWideStringBuffer.ToString: WideString;
begin
  if FCount > System.Length(FBuffer) then
    SetLength(FBuffer,FCount);
  Result := Copy(FBuffer,0,FCount);
end;

function TDBXWideStringBuffer.Substring(const Ordinal: Integer): WideString;
begin
  if Ordinal >= FCount then
    Result := ''
  else
    Result := Copy(FBuffer, Ordinal, FCount - Ordinal);
end;

procedure TDBXWideStringBuffer.Append(const Value: WideString);
var
  Pos: Integer;
begin
  if FCount+System.Length(Value) > System.Length(FBuffer) then
    SetLength(FBuffer,Math.Max(2*System.Length(FBuffer),System.Length(FBuffer)+System.Length(Value)));
  for Pos := 1 to System.Length(Value) do
    FBuffer[FCount+Pos] := Value[Pos];
  FCount := FCount + System.Length(Value);
end;

procedure TDBXWideStringBuffer.Append(const Value: Integer);
begin
  Append(IntToStr(Value));
end;

procedure TDBXWideStringBuffer.Append(const Value: TDBXWideStringBuffer);
begin
  Append(Value.ToString);
end;

procedure Zap(Buffer: TDBXWideStringBuffer);
var
  I: Integer;
begin
  for I := Buffer.FCount+1 to Length(Buffer.FBuffer) do
    Buffer.FBuffer[I] := ' ';
end;

procedure TDBXWideStringBuffer.Replace(const Original, Replacement: WideString; const StartIndex: Integer; const Count: Integer);
var
  Part: WideString;
begin
  Part := Copy(FBuffer, StartIndex+1, Count);
  Part := WideReplaceStr(Part, Original, Replacement);
  Self.FCount := StartIndex;
  Zap(Self);
  Append(Part);
  Zap(Self);
end;

constructor TDBXArrayList.Create;
begin
  SetLength(FList,30);
end;

destructor TDBXArrayList.Destroy;
begin
  SetLength(FList,0);
end;

function TDBXArrayList.GetValue(Index: Integer): TObject;
begin
  Result := FList[Index];
end;

procedure TDBXArrayList.Add(Element: TObject);
begin
  if FCount >= Length(FList) then
    SetLength(FList,FCount*2);
  FList[FCount] := Element;
  Inc(FCount);
end;

procedure TDBXArrayList.Clear;
var
  Index: Integer;
begin
  for Index := 0 to FCount - 1 do
    FreeAndNil(FList[Index]);
  FCount := 0;
end;

destructor TDBXObjectStore.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to Count - 1 do
  begin
    GetObject(Index).Free;
    PutObject(Index,nil);
  end;
  inherited Destroy;
end;

function TDBXObjectStore.ContainsKey(const Name: WideString): Boolean;
begin
  Result := (IndexOf(Name) >= 0);
end;

function TDBXObjectStore.GetObjectFromName(const Name: WideString): TObject;
var
  Index: Integer;
begin
  Index := IndexOf(Name);
  if Index < 0 then
    Result := nil
  else
    Result := Inherited Objects[Index];
end;

procedure TDBXObjectStore.SetObjectByName(const Name: WideString; const Value: TObject);
var
  Index: Integer;
begin
  Index := IndexOf(Name);
  if Index < 0 then
    AddObject(Name, Value)
  else
    Inherited Objects[Index] := Value;
end;

function TDBXStringStore.GetString(const Name: WideString): WideString;
begin
  Result := Inherited Values[Name];
end;

procedure TDBXStringStore.SetString(const Name: WideString; const Value: WideString);
begin
  Inherited Values[Name] := Value;
end;

function TDBXStringStore.Contains(const Name: WideString): Boolean;
begin
  Result := (IndexOf(Name) >= 0);
end;

{$ENDIF}

end.
