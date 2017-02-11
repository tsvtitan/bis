program DialEx;

uses
  Forms,
  main in 'main.pas' {Form1},
  linedlg in 'linedlg.pas' {SelLineDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
