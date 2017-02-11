// Copyright Joen Joensen 2002.
// this is released as a DWS Demo under MPL.
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dws2Comp, dws2Exprs, FiberLibrary, DWSII_FiberLibrary;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    DelphiWebScriptII1: TDelphiWebScriptII;
    dws2Unit1: Tdws2Unit;
    Memo2: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public
    Lib : TDWSII_FiberLibraryExtension;
    FiberList : TDWSFiberList;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FiberList := TDWSFiberList.Create;
  FiberList.DWS := DelphiWebScriptII1;
  FiberList.GenerateFiber;
  Lib := TDWSII_FiberLibraryExtension.Create(Self);
  Lib.DWS2Unit := dws2Unit1;
  Memo1.lines.LoadFromFile('default.dws');
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  Prog : TProgram;
  XC : Integer;

begin
  Prog := DelphiWebScriptII1.Compile(memo1.text);
  Memo2.Clear;
  For XC := 0 to Prog.Msgs.Count -1 do
  Begin
    Memo2.lines.add(Prog.Msgs.Msgs[XC].AsInfo);
  End;
  Prog.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  FiberList.StartDWSFiber(memo1.Text)
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FiberList.RunAllFibers;
end;

end.
