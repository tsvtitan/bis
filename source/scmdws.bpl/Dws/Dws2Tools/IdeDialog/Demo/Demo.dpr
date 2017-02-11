program Demo;

uses
  Forms,
  Main in 'Main.pas' {DemoFrm},
  uDmClasses in 'uDmClasses.pas' {dmClasses: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDemoFrm, DemoFrm);
  Application.CreateForm(TdmClasses, dmClasses);
  Application.Run;
end.
