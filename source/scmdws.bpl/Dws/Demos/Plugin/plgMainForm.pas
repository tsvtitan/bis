unit plgMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, BrowserFrm, dws2Comp, dws2Exprs, dws2VCLGUIFunctions;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DelphiWebScriptII1: TDelphiWebScriptII;
    OpenDialog1: TOpenDialog;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    Memo2: TMemo;
    Splitter2: TSplitter;
    Label3: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Prog: TProgram;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Assigned(Prog) then
    Prog.Free;
  Prog := DelphiWebScriptII1.Compile('');

  if Assigned(BrowserForm) then
    BrowserForm.Free;

  BrowserForm := TBrowserForm.Create(Application);
  BrowserForm.SymbolTable := Prog.Table;
  BrowserForm.Show;
end;

procedure TForm1.Button1Click(Sender: TObject);
type
  TInitProc = procedure(const AScript: TDelphiWebScriptII);
var
  module: HMODULE;
  initProc: TInitProc;
begin
  if Opendialog1.Execute then
  begin
    module := LoadPackage(OpenDialog1.FileName);
    initproc := GetProcAddress(module, PChar('SetScript')); // bleeding edge..
    if Assigned(initproc) then
    begin
      initProc(DelphiWebScriptII1);
      ListBox1.Items.Add(OpenDialog1.FileName);
    end
    else
    begin
      UnloadPackage(module);
      ShowMessage('No "SetScript" procedure found...');
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  x: integer;
begin
  if Assigned(BrowserForm) then
    FreeAndNil(BrowserForm);

  if Assigned(Prog) then
    Prog.Free;

  memo2.Lines.Clear;

  Prog := DelphiWebScriptII1.Compile(memo1.Lines.Text);
  for x := 0 to Prog.Msgs.Count - 1 do
    memo2.Lines.add(Prog.Msgs[x].AsInfo);
    
  Prog.Execute;
  for x := 0 to Prog.Msgs.Count - 1 do
    memo2.Lines.add(Prog.Msgs[x].AsInfo);
end;

end.

