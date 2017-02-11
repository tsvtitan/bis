unit BisNetInit;

interface

uses BisObjectModules;

procedure InitObjectModule(AModule: TBisObjectModule); stdcall;

exports
  InitObjectModule;

implementation

uses Classes, SysUtils, Variants, TypInfo,
     IdException,
     BisCore, BisUtils, BisDialogs, BisExceptNotifier,
     BisScriptUnits;

type
  TBisNetScriptUnit=class(TBisScriptUnit)
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure InitObjectModule(AModule: TBisObjectModule); stdcall;
begin
  AModule.ScriptUnits.AddClass(TBisNetScriptUnit);
end;

{ TBisNetScriptUnit }

constructor TBisNetScriptUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UnitName:='Net';
end;


end.
