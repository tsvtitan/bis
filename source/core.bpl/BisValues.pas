unit BisValues;

interface

uses BisVariants;

type
  TBisValue=class(TBisVariant)
  private
    FName: String;
  public
    property Name: String read FName write FName;
  end;

  TBisValues=class(TBisVariants)
  private
    function GetItem(Index: Integer): TBisValue;
    procedure SetItem(Index: Integer; Value: TBisValue);
  protected
    function GetVariantClass: TBisVariantClass; override;
  public
    function Find(const Name: String): TBisValue; reintroduce;
    function IndexOfName(const Name: String): Integer;
    function ValueByName(Name: String): TBisValue;
    function GetValue(Name: String): Variant;
    function Add(Name: String; Value: Variant): TBisValue; reintroduce; overload;
    function Add(Name: String): TBisValue; reintroduce; overload;
    procedure CopyFrom(Source: TBisValues; WithClear: Boolean=true);

    property Items[Index: Integer]: TBisValue read GetItem write SetItem; default;
  end;

implementation

uses Windows, SysUtils, Variants,
     DBConsts;

{ TBisValues }

function TBisValues.GetVariantClass: TBisVariantClass;
begin
  Result:=TBisValue;
end;

function TBisValues.GetItem(Index: Integer): TBisValue;
begin
  Result:=TBisValue(inherited Items[Index]);
end;

procedure TBisValues.SetItem(Index: Integer; Value: TBisValue);
begin
  inherited Items[Index]:=Value;
end;

function TBisValues.GetValue(Name: String): Variant;
var
  Item: TBisValue;
begin
  Result:=Null;
  Item:=Find(Name);
  if Assigned(Item) then
    Result:=Item.Value;
end;

function TBisValues.ValueByName(Name: String): TBisValue;
begin
  Result:=Find(Name);
  if not Assigned(Result) then
    raise Exception.CreateFmt(SParameterNotFound,[Name]);
end;

procedure TBisValues.CopyFrom(Source: TBisValues; WithClear: Boolean);
var
  i: Integer;
  Item: TBisValue;
begin
  if WithClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      Add(Item.Name,Item.Value);
    end;
  end;
end;

function TBisValues.IndexOfName(const Name: String): Integer;
var
  i: Integer;
  Item: TBisValue;
begin
  Result:=-1;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Name,Name) then begin
      Result:=i;
      exit;
    end;
  end;
end;

function TBisValues.Find(const Name: String): TBisValue;
var
  Index: Integer;
begin
  Result:=nil;
  Index:=IndexOfName(Name);
  if Index>-1 then
    Result:=Items[Index];
end;

function TBisValues.Add(Name: String; Value: Variant): TBisValue;
begin
  Result:=Find(Name);
  if not Assigned(Result) then begin
    Result:=TBisValue(inherited Add(Value));
    Result.Name:=Name;
  end;
end;

function TBisValues.Add(Name: String): TBisValue;
begin
  Result:=Add(Name,Null);
end;

end.