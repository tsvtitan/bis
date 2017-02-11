program dws2SessServer;

uses
  QForms,
  SessServer in 'SessServer.pas' {Form1},
  loSessionTrackingDM in 'loSessionTrackingDM.pas' {DataModule1: TDataModule},
  {$IFDEF MSWINDOWS}
  dws2SessionBasics in '..\..\3dparty\dws2\Libraries\WebLib\dws2SessionBasics.pas';
  {$ENDIF}
  {$IFDEF LINUX}
  dws2SessionBasics in '../../3dparty/dws2/Libraries/WebLib/dws2SessionBasics.pas';
  {$ENDIF}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
