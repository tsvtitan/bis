program ClassCompletion;

uses
  Forms,
  MainForm in 'MainForm.pas' {fmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
