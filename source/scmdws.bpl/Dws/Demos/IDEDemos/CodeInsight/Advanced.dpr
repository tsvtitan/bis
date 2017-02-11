program Advanced;

uses
  Forms,
  AdvancedForm in 'AdvancedForm.pas' {fmAdvanced};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmAdvanced, fmAdvanced);
  Application.Run;
end.
