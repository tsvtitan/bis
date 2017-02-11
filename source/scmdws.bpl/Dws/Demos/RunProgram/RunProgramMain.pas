unit RunProgramMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dws2Comp, Spin;

type
  TForm1 = class(TForm)
    MSource: TMemo;
    Button1: TButton;
    Script: TDelphiWebScriptII;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses
  dws2Exprs;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  prog: TProgram;
begin
  prog := Script.Compile(MSource.Text);
  try
    if not prog.Msgs.HasCompilerErrors then
    begin
      prog.BeginProgram;

      prog.Info['x'] := Edit1.Text;
      prog.Info['y'] := Edit2.Text;

      prog.RunProgram(0);

      Edit3.Text := prog.Info['z'];

      prog.EndProgram;
    end
    else
      ShowMessage(prog.Msgs.Msgs[0].AsInfo);
  finally
    prog.Free;
  end;
end;

end.
