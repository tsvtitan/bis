program RegExprDebugger;

uses
  Forms,
  UFrmDebugger in 'UFrmDebugger.pas' {FrmDebugger};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDebugger, FrmDebugger);
  Application.Run;
end.
