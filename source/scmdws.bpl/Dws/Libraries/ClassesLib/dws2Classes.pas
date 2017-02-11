unit dws2Classes;

interface

{$IFDEF MSWINDOWS}
uses Windows, SysUtils, Classes;
{$ENDIF}
{$IFDEF LINUX}
uses Libc, SysUtils, Variants, TypInfo, Types, Classes;
{$ENDIF}

type
{ Tdws2Strings class }

  TStringsDefined = set of (sdDelimiter, sdQuoteChar);

  Tdws2Strings = class(TPersistent)
  private
    FDefined: TStringsDefined;
    FDelimiter: Char;
    FQuoteChar: Char;
    FUpdateCount: Integer;
    function GetCommaText: string;
    function GetDelimitedText: string;
    function GetName(Index: Integer): string;
    function GetValue(const Name: string): string;
    procedure ReadData(Reader: TReader);
    procedure SetCommaText(const Value: string);
    procedure SetDelimitedText(const Value: string);
    procedure SetValue(const Name, Value: string);
    procedure WriteData(Writer: TWriter);
    function GetDelimiter: Char;
    procedure SetDelimiter(const Value: Char);
    function GetQuoteChar: Char;
    procedure SetQuoteChar(const Value: Char);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Error(const Msg: string; Data: Integer); overload;
    procedure Error(Msg: PResStringRec; Data: Integer); overload;
    function ExtractName(const S: string): string;
    function Get(Index: Integer): string; virtual; abstract;
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual; abstract;
    function GetObject(Index: Integer): IUnknown; virtual;
    function GetTextStr: string; virtual;
    procedure Put(Index: Integer; const S: string); virtual;
    procedure PutObject(Index: Integer; AObject: IUnknown); virtual;
    procedure SetCapacity(NewCapacity: Integer); virtual;
    procedure SetTextStr(const Value: string); virtual;
    procedure SetUpdateState(Updating: Boolean); virtual;
    property UpdateCount: Integer read FUpdateCount;
    function CompareStrings(const S1, S2: string): Integer; virtual;
  public
    destructor Destroy; override;
    function Add(const S: string): Integer; virtual;
    function AddObject(const S: string; AObject: IUnknown): Integer; virtual;
    procedure Append(const S: string);
    procedure AddStrings(Strings: Tdws2Strings); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure Clear; virtual; abstract;
    procedure Delete(Index: Integer); virtual; abstract;
    procedure EndUpdate;
    function Equals(Strings: Tdws2Strings): Boolean;
    procedure Exchange(Index1, Index2: Integer); virtual;
    function GetText: PChar; virtual;
    function IndexOf(const S: string): Integer; virtual;
    function IndexOfName(const Name: string): Integer; virtual;
    function IndexOfObject(AObject: IUnknown): Integer; virtual;
    procedure Insert(Index: Integer; const S: string); virtual; abstract;
    procedure InsertObject(Index: Integer; const S: string;
      AObject: IUnknown); virtual;
    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure Move(CurIndex, NewIndex: Integer); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SetText(Text: PChar); virtual;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property CommaText: string read GetCommaText write SetCommaText;
    property Count: Integer read GetCount;
    property Delimiter: Char read GetDelimiter write SetDelimiter;
    property DelimitedText: string read GetDelimitedText write SetDelimitedText;
    property Names[Index: Integer]: string read GetName;
    property Objects[Index: Integer]: IUnknown read GetObject write PutObject;
    property QuoteChar: Char read GetQuoteChar write SetQuoteChar;
    property Values[const Name: string]: string read GetValue write SetValue;
    property Strings[Index: Integer]: string read Get write Put; default;
    property Text: string read GetTextStr write SetTextStr;
  end;

{ Tdws2StringList class }

  Tdws2StringList = class;

  PStringItem = ^TStringItem;
  TStringItem = record
    FString: string;
    FObject: IUnknown;
  end;

  PStringItemList = ^TStringItemList;
  TStringItemList = array[0..MaxListSize] of TStringItem;
  TStringListSortCompare = function(List: Tdws2StringList; Index1, Index2: Integer): Integer;

  Tdws2StringList = class(Tdws2Strings)
  private
    FList: PStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FCaseSensitive: Boolean;
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TStringListSortCompare);
    procedure SetSorted(Value: Boolean);
    procedure SetCaseSensitive(const Value: Boolean);
  protected
    function Get(Index: Integer): string; override;
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): IUnknown; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure PutObject(Index: Integer; AObject: IUnknown); override;
    procedure SetCapacity(NewCapacity: Integer); override;
    function CompareStrings(const S1, S2: string): Integer; override;
    procedure InsertItem(Index: Integer; const S: string; AObject: IUnknown); virtual;
  public
    destructor Destroy; override;
    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: IUnknown): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1, Index2: Integer); override;
    function Find(const S: string; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: string): Integer; override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure InsertObject(Index: Integer; const S: string;
      AObject: IUnknown); override;
    procedure Sort; virtual;
    procedure CustomSort(Compare: TStringListSortCompare); virtual;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive;
  end;

implementation

{$IFDEF MSWINDOWS}
uses RTLConsts, SysConst, Types;
{$ENDIF}
{$IFDEF LINUX}
uses RTLConsts, SysConst;
{$ENDIF}

{ Tdws2Strings }

destructor Tdws2Strings.Destroy;
begin
  inherited Destroy;
end;

function Tdws2Strings.Add(const S: string): Integer;
begin
  Result := GetCount;
  Insert(Result, S);
end;

function Tdws2Strings.AddObject(const S: string; AObject: IUnknown): Integer;
begin
  Result := Add(S);
  PutObject(Result, AObject);
end;

procedure Tdws2Strings.Append(const S: string);
begin
  Add(S);
end;

procedure Tdws2Strings.AddStrings(Strings: Tdws2Strings);
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
      AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

procedure Tdws2Strings.Assign(Source: TPersistent);
begin
  if Source is Tdws2Strings then
  begin
    BeginUpdate;
    try
      Clear;
      FDefined := Tdws2Strings(Source).FDefined;
      FQuoteChar := Tdws2Strings(Source).FQuoteChar;
      FDelimiter := Tdws2Strings(Source).FDelimiter;
      AddStrings(Tdws2Strings(Source));
    finally
      EndUpdate;
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure Tdws2Strings.BeginUpdate;
begin
  if FUpdateCount = 0 then SetUpdateState(True);
  Inc(FUpdateCount);
end;

procedure Tdws2Strings.DefineProperties(Filer: TFiler);

  function DoWrite: Boolean;
  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is Tdws2Strings then
        Result := not Equals(Tdws2Strings(Filer.Ancestor))
    end
    else Result := Count > 0;
  end;

begin
  Filer.DefineProperty('Strings', ReadData, WriteData, DoWrite);
end;

procedure Tdws2Strings.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then SetUpdateState(False);
end;

function Tdws2Strings.Equals(Strings: Tdws2Strings): Boolean;
var
  I, Count: Integer;
begin
  Result := False;
  Count := GetCount;
  if Count <> Strings.GetCount then Exit;
  for I := 0 to Count - 1 do if Get(I) <> Strings.Get(I) then Exit;
  Result := True;
end;

procedure Tdws2Strings.Error(const Msg: string; Data: Integer);

  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure Tdws2Strings.Error(Msg: PResStringRec; Data: Integer);
begin
  Error(LoadResString(Msg), Data);
end;

procedure Tdws2Strings.Exchange(Index1, Index2: Integer);
var
  TempObject: IUnknown;
  TempString: string;
begin
  BeginUpdate;
  try
    TempString := Strings[Index1];
    TempObject := Objects[Index1];
    Strings[Index1] := Strings[Index2];
    Objects[Index1] := Objects[Index2];
    Strings[Index2] := TempString;
    Objects[Index2] := TempObject;
  finally
    EndUpdate;
  end;
end;

function Tdws2Strings.ExtractName(const S: string): string;
var
  P: Integer;
begin
  Result := S;
  P := AnsiPos('=', Result);
  if P <> 0 then
    SetLength(Result, P-1) else
    SetLength(Result, 0);
end;

function Tdws2Strings.GetCapacity: Integer;
begin  // descendants may optionally override/replace this default implementation
  Result := Count;
end;

function Tdws2Strings.GetCommaText: string;
var
  FOldDefined: TStringsDefined;
  FOldDelimiter: Char;
  FOldQuoteChar: Char;
begin
  FOldDefined := FDefined;
  FOldDelimiter := FDelimiter;
  FOldQuoteChar := FQuoteChar;
  Delimiter := ',';
  QuoteChar := '"';
  try
    Result := GetDelimitedText;
  finally
    FDelimiter := FOldDelimiter;
    FQuoteChar := FOldQuoteChar;
    FDefined := FDefined;
  end;
end;

function Tdws2Strings.GetDelimitedText: string;
var
  S: string;
  P: PChar;
  I, Count: Integer;
begin
  Count := GetCount;
  if (Count = 1) and (Get(0) = '') then
    Result := QuoteChar + QuoteChar
  else
  begin
    Result := '';
    for I := 0 to Count - 1 do
    begin
      S := Get(I);
      P := PChar(S);
      while not (P^ in [#0..' ', QuoteChar, Delimiter]) do
      {$IFDEF MSWINDOWS}
        P := CharNext(P);
      {$ELSE}
        Inc(P);
      {$ENDIF}
      if (P^ <> #0) then S := AnsiQuotedStr(S, QuoteChar);
      Result := Result + S + Delimiter;
    end;
    System.Delete(Result, Length(Result), 1);
  end;
end;

function Tdws2Strings.GetName(Index: Integer): string;
begin
  Result := ExtractName(Get(Index));
end;

function Tdws2Strings.GetObject(Index: Integer): IUnknown;
begin
  Result := nil;
end;

function Tdws2Strings.GetText: PChar;
begin
  Result := StrNew(PChar(GetTextStr));
end;

function Tdws2Strings.GetTextStr: string;
var
  I, L, Size, Count: Integer;
  P: PChar;
  S, LB: string;
begin
  Count := GetCount;
  Size := 0;
  LB := sLineBreak;
  for I := 0 to Count - 1 do Inc(Size, Length(Get(I)) + Length(LB));
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L);
      Inc(P, L);
    end;
    L := Length(LB);
    if L <> 0 then
    begin
      System.Move(Pointer(LB)^, P^, L);
      Inc(P, L);
    end;
  end;
end;

function Tdws2Strings.GetValue(const Name: string): string;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then
    Result := Copy(Get(I), Length(Name) + 2, MaxInt) else
    Result := '';
end;

function Tdws2Strings.IndexOf(const S: string): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if CompareStrings(Get(Result), S) = 0 then Exit;
  Result := -1;
end;

function Tdws2Strings.IndexOfName(const Name: string): Integer;
var
  P: Integer;
  S: string;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := AnsiPos('=', S);
    if (P <> 0) and (CompareStrings(Copy(S, 1, P - 1), Name) = 0) then Exit;
  end;
  Result := -1;
end;

function Tdws2Strings.IndexOfObject(AObject: IUnknown): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then Exit;
  Result := -1;
end;

procedure Tdws2Strings.InsertObject(Index: Integer; const S: string;
  AObject: IUnknown);
begin
  Insert(Index, S);
  PutObject(Index, AObject);
end;

procedure Tdws2Strings.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure Tdws2Strings.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: string;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetString(S, nil, Size);
    Stream.Read(Pointer(S)^, Size);
    SetTextStr(S);
  finally
    EndUpdate;
  end;
end;

procedure Tdws2Strings.Move(CurIndex, NewIndex: Integer);
var
  TempObject: IUnknown;
  TempString: string;
begin
  if CurIndex <> NewIndex then
  begin
    BeginUpdate;
    try
      TempString := Get(CurIndex);
      TempObject := GetObject(CurIndex);
      Delete(CurIndex);
      InsertObject(NewIndex, TempString, TempObject);
    finally
      EndUpdate;
    end;
  end;
end;

procedure Tdws2Strings.Put(Index: Integer; const S: string);
var
  TempObject: IUnknown;
begin
  TempObject := GetObject(Index);
  Delete(Index);
  InsertObject(Index, S, TempObject);
end;

procedure Tdws2Strings.PutObject(Index: Integer; AObject: IUnknown);
begin
end;

procedure Tdws2Strings.ReadData(Reader: TReader);
begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do Add(Reader.ReadString);
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure Tdws2Strings.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure Tdws2Strings.SaveToStream(Stream: TStream);
var
  S: string;
begin
  S := GetTextStr;
  Stream.WriteBuffer(Pointer(S)^, Length(S));
end;

procedure Tdws2Strings.SetCapacity(NewCapacity: Integer);
begin
  // do nothing - descendants may optionally implement this method
end;

procedure Tdws2Strings.SetCommaText(const Value: string);
begin
  Delimiter := ',';
  QuoteChar := '"';
  SetDelimitedText(Value);
end;

procedure Tdws2Strings.SetText(Text: PChar);
begin
  SetTextStr(Text);
end;

procedure Tdws2Strings.SetTextStr(const Value: string);
var
  P, Start: PChar;
  S: string;
begin
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in [#0, #10, #13]) do Inc(P);
        SetString(S, Start, P - Start);
        Add(S);
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
  finally
    EndUpdate;
  end;
end;

procedure Tdws2Strings.SetUpdateState(Updating: Boolean);
begin
end;

procedure Tdws2Strings.SetValue(const Name, Value: string);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + '=' + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

procedure Tdws2Strings.WriteData(Writer: TWriter);
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do Writer.WriteString(Get(I));
  Writer.WriteListEnd;
end;

procedure Tdws2Strings.SetDelimitedText(const Value: string);
var
  P, P1: PChar;
  S: string;
begin
  BeginUpdate;
  try
    Clear;
    P := PChar(Value);
    while P^ in [#1..' '] do
    {$IFDEF MSWINDOWS}
      P := CharNext(P);
    {$ELSE}
      Inc(P);
    {$ENDIF}
    while P^ <> #0 do
    begin
      if P^ = QuoteChar then
        S := AnsiExtractQuotedStr(P, QuoteChar)
      else
      begin
        P1 := P;
        while (P^ > ' ') and (P^ <> Delimiter) do
        {$IFDEF MSWINDOWS}
          P := CharNext(P);
        {$ELSE}
          Inc(P);
        {$ENDIF}
        SetString(S, P1, P - P1);
      end;
      Add(S);
      while P^ in [#1..' '] do
      {$IFDEF MSWINDOWS}
        P := CharNext(P);
      {$ELSE}
        Inc(P);
      {$ENDIF}
      if P^ = Delimiter then
      begin
        P1 := P;
        {$IFDEF MSWINDOWS}
        if CharNext(P1)^ = #0 then
        {$ELSE}
        Inc(P1);
        if P1^ = #0 then
        {$ENDIF}
          Add('');
        repeat
          {$IFDEF MSWINDOWS}
          P := CharNext(P);
          {$ELSE}
          Inc(P);
          {$ENDIF}
        until not (P^ in [#1..' ']);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

function Tdws2Strings.GetDelimiter: Char;
begin
  if not (sdDelimiter in FDefined) then
    Delimiter := ',';
  Result := FDelimiter;
end;

function Tdws2Strings.GetQuoteChar: Char;
begin
  if not (sdQuoteChar in FDefined) then
    QuoteChar := '"';
  Result := FQuoteChar;
end;

procedure Tdws2Strings.SetDelimiter(const Value: Char);
begin
  if (FDelimiter <> Value) or not (sdDelimiter in FDefined) then
  begin
    Include(FDefined, sdDelimiter);
    FDelimiter := Value;
  end
end;

procedure Tdws2Strings.SetQuoteChar(const Value: Char);
begin
  if (FQuoteChar <> Value) or not (sdQuoteChar in FDefined) then
  begin
    Include(FDefined, sdQuoteChar);
    FQuoteChar := Value;
  end
end;

function Tdws2Strings.CompareStrings(const S1, S2: string): Integer;
begin
  Result := AnsiCompareText(S1, S2);
end;

{ Tdws2StringList }

destructor Tdws2StringList.Destroy;
begin
  inherited Destroy;
  if FCount <> 0 then Finalize(FList^[0], FCount);
  FCount := 0;
  SetCapacity(0);
end;

function Tdws2StringList.Add(const S: string): Integer;
begin
  Result := AddObject(S, nil);
end;

function Tdws2StringList.AddObject(const S: string; AObject: IUnknown): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(S, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error(@SDuplicateString, 0);
      end;
  InsertItem(Result, S, AObject);
end;

procedure Tdws2StringList.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    FCount := 0;
    SetCapacity(0);
  end;
end;

procedure Tdws2StringList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TStringItem));
end;

procedure Tdws2StringList.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error(@SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error(@SListIndexError, Index2);
  ExchangeItems(Index1, Index2);
end;

procedure Tdws2StringList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: Integer;
  Item1, Item2: PStringItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := Integer(Item1^.FString);
  Integer(Item1^.FString) := Integer(Item2^.FString);
  Integer(Item2^.FString) := Temp;
  Temp := Integer(Item1^.FObject);
  Integer(Item1^.FObject) := Integer(Item2^.FObject);
  Integer(Item2^.FObject) := Temp;
end;

function Tdws2StringList.Find(const S: string; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(FList^[I].FString, S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function Tdws2StringList.Get(Index: Integer): string;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := FList^[Index].FString;
end;

function Tdws2StringList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function Tdws2StringList.GetCount: Integer;
begin
  Result := FCount;
end;

function Tdws2StringList.GetObject(Index: Integer): IUnknown;
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

procedure Tdws2StringList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function Tdws2StringList.IndexOf(const S: string): Integer;
begin
  if not Sorted then Result := inherited IndexOf(S) else
    if not Find(S, Result) then Result := -1;
end;

procedure Tdws2StringList.Insert(Index: Integer; const S: string);
begin
  InsertObject(Index, S, nil);
end;

procedure Tdws2StringList.InsertObject(Index: Integer; const S: string;
  AObject: IUnknown);
begin
  if Sorted then Error(@SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then Error(@SListIndexError, Index);
  InsertItem(Index, S, AObject);
end;

procedure Tdws2StringList.InsertItem(Index: Integer; const S: string; AObject: IUnknown);
begin
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TStringItem));
  with FList^[Index] do
  begin
    Pointer(FString) := nil;
    FObject := AObject;
    FString := S;
  end;
  Inc(FCount);
end;

procedure Tdws2StringList.Put(Index: Integer; const S: string);
begin
  if Sorted then Error(@SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  FList^[Index].FString := S;
end;

procedure Tdws2StringList.PutObject(Index: Integer; AObject: IUnknown);
begin
  if (Index < 0) or (Index >= FCount) then Error(@SListIndexError, Index);
  FList^[Index].FObject := AObject;
end;

procedure Tdws2StringList.QuickSort(L, R: Integer; SCompare: TStringListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure Tdws2StringList.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity < FCapacity then
    FillChar(FList[NewCapacity], (FCapacity - NewCapacity) * SizeOf(TStringItem), 0);

  ReallocMem(FList, NewCapacity * SizeOf(TStringItem));

  if NewCapacity > FCapacity then
    FillChar(FList[FCapacity], (NewCapacity - FCapacity) * SizeOf(TStringItem), 0);
    
  FCapacity := NewCapacity;
end;

procedure Tdws2StringList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

function StringListCompareStrings(List: Tdws2StringList; Index1, Index2: Integer): Integer;
begin
  Result := List.CompareStrings(List.FList^[Index1].FString,
                                List.FList^[Index2].FString);
end;

procedure Tdws2StringList.Sort;
begin
  CustomSort(StringListCompareStrings);
end;

procedure Tdws2StringList.CustomSort(Compare: TStringListSortCompare);
begin
  if not Sorted and (FCount > 1) then
    QuickSort(0, FCount - 1, Compare);
end;

function Tdws2StringList.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

procedure Tdws2StringList.SetCaseSensitive(const Value: Boolean);
begin
  if Value <> FCaseSensitive then
  begin
    FCaseSensitive := Value;
    if Sorted then Sort;
  end;
end;

end.
