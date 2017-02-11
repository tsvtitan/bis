program plgMain;

uses
  Forms,
  plgMainForm in 'plgMainForm.pas' {Form1},
  BrowserFrm in 'BrowserFrm.pas' {BrowserForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
