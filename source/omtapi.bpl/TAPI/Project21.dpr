program Project21;

uses
  Forms,
  Unit21 in 'Unit21.pas' {Form21},
  BisTapi in '..\..\core.bpl\BisTapi.pas',
  BisCodec in '..\..\core.bpl\BisCodec.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm21, Form21);
  Application.Run;
end.
