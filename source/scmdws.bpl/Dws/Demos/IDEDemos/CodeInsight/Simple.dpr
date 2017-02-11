program Simple;

uses
  Forms,
  SimpleForm in 'SimpleForm.pas' {fmSimple};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmSimple, fmSimple);
  Application.Run;
end.
