program smpp;

uses
  Forms,
  BisMainFm in 'BisMainFm.pas' {BisMainForm},
  BisUtils in '..\..\core.bpl\BisUtils.pas',
  cUnicodeCodecs in '..\..\smgsm.bpl\cUnicodeCodecs.pas',
  BisSmpp in '..\..\omnet.bpl\BisSmpp.pas',
  BisSmppClient in '..\BisSmppClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBisMainForm, BisMainForm);
  Application.Run;
end.
