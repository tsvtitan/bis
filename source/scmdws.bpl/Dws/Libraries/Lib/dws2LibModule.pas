unit dws2LibModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, dws2Exprs;

type
  Tdws2Lib = class(TDataModule)
    dws2Unit1: Tdws2Unit;
  private
    FScript: TDelphiWebScriptII;
    procedure SetScript(const Value: TDelphiWebScriptII);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
  end;

procedure Register;

var
  dws2Lib: Tdws2Lib;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2Lib]);
end;

{ Tdws2Lib }

procedure Tdws2Lib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = Script) then
    SetScript(nil)
end;

procedure Tdws2Lib.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  if Assigned(Value) then
    Value.FreeNotification(Self);

  FScript := Value;
  for x := 0 to ComponentCount - 1 do
    if Components[x] is Tdws2Unit then
      Tdws2Unit(Components[x]).Script := Value;
end;

end.
