program Query;
uses
  Forms,
  main in 'main.pas' {Form1},
  uib in '..\..\..\..\source\uib.pas',
  uibase in '..\..\..\..\source\uibase.pas',
  uibconst in '..\..\..\..\source\uibconst.pas',
  uiberror in '..\..\..\..\source\uiberror.pas',
  uibmetadata in '..\..\..\..\source\uibmetadata.pas',
  uibkeywords in '..\..\..\..\source\uibkeywords.pas',
  uiblib in '..\..\..\..\source\uiblib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
