program Project7;

uses
  Forms,
  Unit9 in 'Unit9.pas' {Form9},
  VTHeaderPopup in 'VirtualTreeView\Source\VTHeaderPopup.pas',
  VirtualTrees in 'VirtualTreeView\Source\VirtualTrees.pas',
  VTAccessibilityFactory in 'VirtualTreeView\Source\VTAccessibilityFactory.pas',
  BisDBTree in 'BisDBTree.pas',
  DB in 'DB.pas',
  BisValues in '..\..\core.bpl\BisValues.pas',
  BisVariants in '..\..\core.bpl\BisVariants.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.
