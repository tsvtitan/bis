unit BisVariants;

interface

uses Classes, Contnrs, TypInfo;

type
  TBisVariant=class(TObject)
  private
    FValue: Variant;
  public
    constructor Create; virtual;
    function ValueExists: Boolean;
    function AsString(const Default: String=''): String;
    function AsInteger(const Default: Integer=0): Integer;
    function AsEnumeration(Info: PTypeInfo; const Default: Variant): Variant;
    function AsBoolean(const Default: Boolean=false): Boolean;
    function AsExtended(const Default: Extended=0.0): Extended;

    property Value: Variant read FValue write FValue;
  end;

  TBisVariantClass=class of TBisVariant;

  TBisVariants=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisVariant;
    procedure SetItem(Index: Integer; Value: TBisVariant);
  protected
    function GetVariantClass: TBisVariantClass; virtual;
  public
    function Find(Value: Variant): TBisVariant;
    function Add(Value: Variant): TBisVariant;
    function AddUnique(Value: Variant): TBisVariant;
    procedure AssignArray(Source: array of const);
    procedure CopyFrom(Source: TBisVariants; WithClear: Boolean=true);
    procedure AddStringsText(const Text: String);

    property Items[Index: Integer]: TBisVariant read GetItem write SetItem; default;
  end;

implementation

uses Variants,
     BisUtils;

{ TBisVariant }

constructor TBisVariant.Create;
begin
  inherited Create;
end;

function TBisVariant.AsBoolean(const Default: Boolean): Boolean;
begin
  Result:=Boolean(AsEnumeration(TypeInfo(Boolean),Integer(Default)));
end;

function TBisVariant.AsEnumeration(Info: PTypeInfo; const Default: Variant): Variant;
var
  Data: PTypeData;
  ADefault: Integer;
  AValue: Integer;
begin
  Result:=Default;
  if Assigned(Info) and (Info.Kind=tkEnumeration) then begin

    Data:=GetTypeData(Info);

    ADefault:=VarToIntDef(Default,Data.MinValue);
    AValue:=GetEnumValue(Info,FValue);
    if AValue in [Data.MinValue..Data.MaxValue] then
      Result:=AValue
    else begin
      AValue:=VarToIntDef(FValue,Adefault);
      if AValue in [Data.MinValue..Data.MaxValue] then
        Result:=AValue;
    end;

  end;
end;

function TBisVariant.AsExtended(const Default: Extended): Extended;
begin
  Result:=VarToExtendedDef(FValue,Default);
end;

function TBisVariant.AsInteger(const Default: Integer): Integer;
begin
  Result:=VarToIntDef(FValue,Default);
end;

function TBisVariant.AsString(const Default: String): String;
begin
  Result:=VarToStrDef(FValue,Default);
end;

function TBisVariant.ValueExists: Boolean;
begin
  Result:=not (VarIsNull(FValue) or
               VarIsEmpty(FValue) or
               VarIsError(FValue));
end;

{ TBisVariants }

function TBisVariants.GetItem(Index: Integer): TBisVariant;
begin
  Result:=TBisVariant(inherited Items[Index]);
end;

procedure TBisVariants.SetItem(Index: Integer; Value: TBisVariant);
begin
  inherited Items[Index]:=Value;
end;

function TBisVariants.Find(Value: Variant): TBisVariant;
var
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    if VarSameValue(Items[i].Value,Value) then begin
      Result:=Items[i];
      exit;
    end;
  end;
end;

function TBisVariants.GetVariantClass: TBisVariantClass;
begin
  Result:=TBisVariant;
end;

function TBisVariants.Add(Value: Variant): TBisVariant;
var
  AClass: TBisVariantClass;
begin
  Result:=nil;
  AClass:=GetVariantClass;
  if Assigned(AClass) then begin
    Result:=AClass.Create;
    Result.Value:=Value;
    inherited Add(Result);
  end;
end;

procedure TBisVariants.AddStringsText(const Text: String);
var
  Strings: TStringList;
  i: Integer;
begin
  Strings:=TStringList.Create;
  try
    Strings.Text:=Text;
    for i:=0 to Strings.Count-1 do
      Add(Strings[i]);
  finally
    Strings.Free;
  end;
end;

function TBisVariants.AddUnique(Value: Variant): TBisVariant;
begin
  Result:=nil;
  if not Assigned(Find(Value)) then begin
    Result:=Add(Value);
  end;
end;

procedure TBisVariants.AssignArray(Source: array of const);
var
  i: Integer;
  V: Variant;
  VType: Byte;
begin
  for i:=Low(Source) to High(Source) do begin
    V:='';
    VType:=TVarRec(Source[i]).VType;
    case VType of
     { vtInteger: V:=TVarRec(Source[i]).VInteger;
      vtBoolean: V:=TVarRec(Source[i]).VBoolean;
      vtChar: V:=TVarRec(Source[i]).VChar;
      vtExtended: V:=TVarRec(Source[i]).VExtended^;
      vtString: V:=TVarRec(Source[i]).VString^;
      vtAnsiString: V:=String(PAnsiChar(TVarRec(Source[i]).VAnsiString));
      vtCurrency: V:=TVarRec(Source[i]).VCurrency^;
      vtVariant: V:=TVarRec(Source[i]).VVariant^;
      vtWideString: V:=WideString(TVarRec(Source[i]).VWideString);
      vtWideChar: V:=WideChar(TVarRec(Source[i]).VWideChar);   }

      vtInteger: V:=TVarRec(Source[i]).VInteger;
      vtBoolean: V:=TVarRec(Source[i]).VBoolean;
      vtChar: V:=TVarRec(Source[i]).VChar;
      vtExtended: V:=TVarRec(Source[i]).VExtended^;
      vtString: V:=TVarRec(Source[i]).VString^;
      vtPointer: V:=String(PAnsiChar(TVarRec(Source[i]).VAnsiString));
      vtPChar: ;
      vtObject: ;
      vtClass: ;
      vtWideChar: V:=WideChar(TVarRec(Source[i]).VWideChar);
      vtPWideChar: ;
      vtAnsiString: V:=String(PAnsiChar(TVarRec(Source[i]).VAnsiString));
      vtCurrency: V:=TVarRec(Source[i]).VCurrency^;
      vtVariant: V:=TVarRec(Source[i]).VVariant^;
      vtInterface:  ;
      vtWideString: V:=WideString(TVarRec(Source[i]).VWideString);
      vtInt64: V:=TVarRec(Source[i]).VInt64^;
    end;
    Add(V);
  end;
end;

procedure TBisVariants.CopyFrom(Source: TBisVariants; WithClear: Boolean);
var
  i: Integer;
  Item: TBisVariant;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      Add(Item.Value);
    end;
  end;
end;

end.
