unit BisScriptSymbols;

interface

uses Classes, Contnrs;

type

  TBisScriptSymbol=class(TObject)
  private
    FName: String;
    FDescription: String;
  public
    constructor Create; virtual;

    property Name: String read FName;
    property Description: String read FDescription write FDescription;
  end;

  TBisScriptSymbolClass=class of TBisScriptSymbol;

  TBisScriptSymbols=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisScriptSymbol;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; virtual;
    function AddClass(Name: String; AClass: TBisScriptSymbolClass): TBisScriptSymbol;
  public
    function Find(Name: String): TBisScriptSymbol;
    function Add(Name: String): TBisScriptSymbol;

    property Items[Index: Integer]: TBisScriptSymbol read GetItem; default;
  end;

implementation

uses SysUtils;

{ TBisScriptSymbol }

constructor TBisScriptSymbol.Create;
begin
  inherited Create; 
end;

{ TBisScriptSymbols }

function TBisScriptSymbols.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptSymbol;
end;

function TBisScriptSymbols.GetItem(Index: Integer): TBisScriptSymbol;
begin
  Result:=TBisScriptSymbol(inherited Items[Index]);
end;

function TBisScriptSymbols.Find(Name: String): TBisScriptSymbol;
var
  i: Integer;
  Item: TBisScriptSymbol;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.Name,Name) then begin
      Result:=Item;
      Break;
    end;
  end;
end;

function TBisScriptSymbols.Add(Name: String): TBisScriptSymbol;
var
  AClass: TBisScriptSymbolClass;
begin
  Result:=nil;
  if not Assigned(Find(Name)) then begin
    AClass:=GetScriptSymbolClass;
    if Assigned(AClass) then begin
      Result:=AClass.Create;
      Result.FName:=Name;
      inherited Add(Result);
    end;
  end;
end;

function TBisScriptSymbols.AddClass(Name: String; AClass: TBisScriptSymbolClass): TBisScriptSymbol;
begin
  Result:=nil;
  if not Assigned(Find(Name)) then begin
    if Assigned(AClass) then begin
      Result:=AClass.Create;
      Result.FName:=Name;
      inherited Add(Result);
    end;
  end;
end;


end.
