unit SimpleDemoWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, StdCtrls;

type
  TFSimpleDemo = class(TForm)
    MSource: TMemo;
    MResult: TMemo;
    BNCompileAndExecute: TButton;
    DelphiWebScriptII1: TDelphiWebScriptII;
    Label1: TLabel;
    procedure BNCompileAndExecuteClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FSimpleDemo: TFSimpleDemo;

implementation

{$R *.DFM}

uses
  dws2Exprs, dws2Compiler;

procedure TFSimpleDemo.BNCompileAndExecuteClick(Sender: TObject);
var
  x: Integer;
  Prog: TProgram;
begin
  // Compile the script program
  Prog := DelphiWebScriptII1.Compile(MSource.Text);

  // Display error messages (if any)
  if Prog.Msgs.HasCompilerErrors then
    for x := 0 to Prog.Msgs.Count - 1 do
      ShowMessage(Prog.Msgs[x].AsInfo);

  // Execute the script program
  Prog.Execute;

  // Display the output
  MResult.Text := Tdws2DefaultResult(Prog.Result).Text;

  // Display error messages (if any)
  for x := 0 to Prog.Msgs.Count - 1 do
    ShowMessage(Prog.Msgs[x].AsInfo);
end;

end.
