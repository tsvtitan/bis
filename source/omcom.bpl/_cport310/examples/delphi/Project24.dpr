program Project24;

uses
  Forms,
  Unit24 in 'Unit24.pas' {Form24},
  BisBarcodeScanner in 'BisBarcodeScanner.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm24, Form24);
  Application.Run;
end.
