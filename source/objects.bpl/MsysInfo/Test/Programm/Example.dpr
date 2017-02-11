program Example;

uses
  Forms,
  UntFormMain in 'UntFormMain.pas' {frmFormMain},
  UntForm1 in 'UntForm1.pas' {Form1},
  UntForm2 in 'UntForm2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFormMain, frmFormMain);
  Application.Run;
end.
