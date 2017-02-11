unit BisScriptConsts;

interface

uses Contnrs, TypInfo,
     BisScriptSymbols, BisScriptType, BisScriptVars;

type

  TBisScriptConst=class(TBisScriptVar)
  private
    function GetValue: Variant;
  public
    property Value: Variant read GetValue;
  end;

  TBisScriptConsts=class(TBisScriptvars)
  private
    function GetItem(Index: Integer): TBisScriptConst;
  protected
    function GetScriptSymbolClass: TBisScriptSymbolClass; override;
  public
    function Find(Name: String): TBisScriptConst; reintroduce;
    function Add(Name: String; Value: Variant; TypeName: String): TBisScriptConst; reintroduce;

    property Items[Index: Integer]: TBisScriptConst read GetItem; default;
  end;

implementation

uses Variants;

{ TBisScriptConst }

function TBisScriptConst.GetValue: Variant;
begin
  Result:=inherited Value;
end;

{ TBisScriptConsts }

function TBisScriptConsts.Find(Name: String): TBisScriptConst;
begin
  Result:=TBisScriptConst(inherited Find(Name));
end;

function TBisScriptConsts.GetItem(Index: Integer): TBisScriptConst;
begin
  Result:=TBisScriptConst(inherited Items[Index]);
end;

function TBisScriptConsts.GetScriptSymbolClass: TBisScriptSymbolClass;
begin
  Result:=TBisScriptConst;
end;

function TBisScriptConsts.Add(Name: String; Value: Variant; TypeName: String): TBisScriptConst;
begin
  Result:=TBisScriptConst(inherited Add(Name,Value,TypeName,stkUnknown));
end;


end.
