unit BisScriptUnits;

interface

uses Classes, Contnrs,
     BisObject, BisCoreObjects,
     BisScriptTypes, BisScriptVars, BisScriptFuncs;

type

  TBisScriptUnit=class(TBisCoreObject)
  private
    FDepends: TStrings;
    FTypes: TBisScriptTypes;
    FVars: TBisScriptVars;
    FFuncs: TBisScriptFuncs;
    function GetUnitName: String;
    procedure SetUnitName(Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Depends: TStrings read FDepends;
    property Types: TBisScriptTypes read FTypes;
    property Vars: TBisScriptVars read FVars;
    property Funcs: TBisScriptFuncs read FFuncs;

    property UnitName: String read GetUnitName write SetUnitName;
  end;

  TBisScriptUnitClass=class of TBisScriptUnit;

  TBisScriptUnits=class(TBisCoreObjects)
  private
    function GetItem(Index: Integer): TBisScriptUnit;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public

    function Find(UnitName: String): TBisScriptUnit; reintroduce;
    function Add(UnitName: String): TBisScriptUnit; reintroduce;

    function AddClass(AClass: TBisScriptUnitClass): TBisScriptUnit;
    function AddUnit(AIface: TBisScriptUnit): Boolean;

    property Items[Index: Integer]: TBisScriptUnit read GetItem; default;
  end;

implementation

uses SysUtils,
     BisUtils;

{ TBisScriptUnit }

constructor TBisScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDepends:=TStringList.Create;
  FTypes:=TBisScriptTypes.Create;
  FVars:=TBisScriptVars.Create;
  FFuncs:=TBisScriptFuncs.Create;
end;

destructor TBisScriptUnit.Destroy;
begin
  FFuncs.Free;
  FVars.Free;
  FTypes.Free;
  FDepends.Free;
  inherited Destroy;
end;

function TBisScriptUnit.GetUnitName: String;
begin
  Result:=ObjectName;
end;

procedure TBisScriptUnit.SetUnitName(Value: String);
begin
  ObjectName:=Value;
end;

{ TBisScriptUnits }

function TBisScriptUnits.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisScriptUnit;
end;

function TBisScriptUnits.Add(UnitName: String): TBisScriptUnit;
begin
  Result:=TBisScriptUnit(inherited Add(UnitName));
end;

function TBisScriptUnits.AddClass(AClass: TBisScriptUnitClass): TBisScriptUnit;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    if not Assigned(Find(Result.UnitName)) then begin
      AddObject(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;

function TBisScriptUnits.AddUnit(AIface: TBisScriptUnit): Boolean;
begin
  Result:=false;
  if Assigned(AIface) and not Assigned(Find(AIface.UnitName)) then begin
    AddObject(AIface);
    Result:=true;
  end;
end;


function TBisScriptUnits.Find(UnitName: String): TBisScriptUnit;
begin
  Result:=TBisScriptUnit(inherited Find(UnitName));
end;

function TBisScriptUnits.GetItem(Index: Integer): TBisScriptUnit;
begin
  Result:=TBisScriptUnit(inherited Items[Index]);
end;


end.
