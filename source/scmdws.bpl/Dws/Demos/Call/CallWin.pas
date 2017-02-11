unit CallWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dws2Comp, ExtCtrls, StdCtrls, dws2VCLGUIFunctions, Spin;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Splitter1: TSplitter;
    DelphiWebScriptII: TDelphiWebScriptII;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    Button2: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Button3: TButton;
    Edit3: TEdit;
    Label3: TLabel;
    Button4: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    SpinEdit6: TSpinEdit;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  prog: TProgram;
begin
  prog := DelphiWebScriptII.Compile(Memo1.Text);

  prog.BeginProgram;

  prog.Info.Func['Test1'].Call([Edit1.Text]);

  prog.EndProgram;

  prog.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  prog: TProgram;
begin
  prog := DelphiWebScriptII.Compile(Memo1.Text);

  prog.BeginProgram;

  Edit3.Text := prog.Info.Func['Test2'].Call([Edit2.Text]).Value;

  prog.EndProgram;

  prog.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  prog: TProgram;
  funcInf: IInfo;
begin
  prog := DelphiWebScriptII.Compile(Memo1.Text);

  prog.BeginProgram;

  funcInf := prog.Info.Func['Test3'];
  funcInf.Parameter['Msg'].Value := Edit2.Text;

  funcInf.Call;

  Edit3.Text := funcInf.Parameter['Msg'].Value;

  prog.EndProgram;

  prog.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  prog: TProgram;
  funcInf, resultInf: IInfo;
begin
  prog := DelphiWebScriptII.Compile(Memo1.Text);

  prog.BeginProgram;

  funcInf := prog.Info.Func['Test4'];
  funcInf.Parameter['Struct'].Member['a'].Element([0]).Value := SpinEdit1.Value;
  funcInf.Parameter['Struct'].Member['a'].Element([1]).Value := SpinEdit2.Value;
  funcInf.Parameter['Struct'].Member['b'].Value := SpinEdit3.Value;

  resultInf := funcInf.Call;

  SpinEdit4.Value := resultInf.Member['a'].Element([0]).Value;
  SpinEdit5.Value := resultInf.Member['a'].Element([1]).Value;
  SpinEdit6.Value := resultInf.Member['b'].Value;

  prog.EndProgram;

  prog.Free;
end;

end.
