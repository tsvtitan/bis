{
 Note: This is not really the way how you should use packages, but for this simple
       example..
}

unit in1Register;

interface

uses
  dws2Comp, in1, forms;

procedure SetScript(const AScript: TDelphiWebScriptII);

implementation

procedure SetScript(const AScript: TDelphiWebScriptII);
begin
  TDataModule1.Create(Application);
  DataModule1.dws2Unit1.Script := AScript;
end;

exports
  SetScript; // bleeding edge..
end.

