program sipphone;

uses
  Forms,
  sipclientmain in 'sipclientmain.pas' {MainForm},
  mainframe in 'mainframe.pas' {DialFrm: TFrame},
  accountsframe in 'accountsframe.pas' {AccountsFrm: TFrame},
  audioframe in 'audioframe.pas' {AudioFrm: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
