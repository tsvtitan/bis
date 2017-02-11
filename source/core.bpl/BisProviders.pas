unit BisProviders;

interface

uses Classes, Contnrs, DB, Graphics, Types, Variants,
     BisProvider;

type
  TBisProviders=class(TObjectList)
  private
    function GetItems(Index: Integer): TBisProvider;
  public

    function Find(ProviderName: String): TBisProvider;
    function AddClass(AClass: TBisProviderClass): TBisProvider;

    property Items[Index: Integer]: TBisProvider read GetItems;
  end;

implementation

uses SysUtils, BisUtils;

{ TBisProviders }

function TBisProviders.Find(ProviderName: String): TBisProvider;
var
  i: Integer;
  Item: TBisProvider;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.ProviderName,ProviderName) then begin
      Result:=Item;
      break;
    end;
  end;
end;

function TBisProviders.GetItems(Index: Integer): TBisProvider;
begin
  Result:=TBisProvider(inherited Items[Index]);
end;

function TBisProviders.AddClass(AClass: TBisProviderClass): TBisProvider;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(nil);
    if not Assigned(Find(Result.ProviderName)) then begin
      inherited Add(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;


end.
