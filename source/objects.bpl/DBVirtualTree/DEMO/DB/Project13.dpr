program Project13;

uses
  Forms,
  Unit12 in 'Unit12.pas' {Form12},
  kbmMemTable in 'kbmMemTable.pas',
  DTDBTreeView in 'DTDBTreeView.pas',
  VirtualTrees in 'VirtualTrees.pas',
  VirtualDBTreeEx in 'VirtualDBTreeEx.pas',
  BisDBTree in 'BisDBTree.pas',
  BisOrders in '..\..\..\..\core.bpl\BisOrders.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.