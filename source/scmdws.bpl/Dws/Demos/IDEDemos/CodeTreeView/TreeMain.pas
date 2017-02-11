{ Demo of dws2SymbolsToTree.pas - 14 Jan 2003 (Mark Ericksen)
  This demonstrates how to take a compiled program (one that includes both
  a ContextMap and a SymbolDictionary) and display the symbols in a TTreeView.
  It also demonstrates how to link a TTreeNode to locating the symbol in the
  text script. This is useful for code navigation by selecting the node and
  double-clicking it to bring the focus to that element in the script.
  The unit "dws2SymbolsToTree.pas" includes two high-level functions that
  will display the symbols in the style of Delphi's CodeExplorer and another
  in the style of a Tdws2Unit.

  There are additional routines that can be used to create custom organizations.
  The high-level calls can be used as a model for building a customized order.

  NOTE: This demo uses a TSynEdit control. This is not necessary for using the
        dws2SymbolsToTree code. Using the SynEdit control keeps the demo code
        shorter and easier to understand.
}

{$I dws2.inc }

unit TreeMain;

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, SynEditHighlighter, SynHighlighterPas,
  SynEdit, StdCtrls, ImgList, dws2Comp, dws2Exprs,
  dws2IDEUtils,      // used to define the image indexes used
  dws2VCLSymbolsToTree; // has the logic for putting DWSII symbols into a TreeView

type
  TForm1 = class(TForm)
    SynEdit1: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    Splitter1: TSplitter;
    Panel1: TPanel;
    TreeView1: TTreeView;
    pOptions: TPanel;
    rgrpFormat: TRadioGroup;
    DelphiWebScriptII1: TDelphiWebScriptII;
    btnRefresh: TButton;
    ilTreeView: TImageList;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure rgrpFormatClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { We still need a valid pointer to some TProgram information for the
      Dbl-Click jump-to code to work. Compile it and leave it around. }
    FProgram: TProgram;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  // default fill the list
  btnRefreshClick(nil);
end;

procedure TForm1.btnRefreshClick(Sender: TObject);
begin
  { Compile the script to a program }
  if Assigned(FProgram) then
  begin
    FProgram.Free;
    FProgram := nil;
  end;
  
  if not Assigned(FProgram) then
    FProgram := CompileWithSymbolsAndMap(DelphiWebScriptII1, SynEdit1.Lines.Text);

  { Use the format specified }
  case rgrpFormat.ItemIndex of
    { Delphi CodeExplorer style }
    0 : SymbolsToDefaultDelphiTree(FProgram, TreeView1);
    { Tdws2Unit style }
    1 : SymbolsToUnitTree(FProgram, TreeView1);
  end;
end;

procedure TForm1.rgrpFormatClick(Sender: TObject);
begin
  // simulate a click so the view will change
  btnRefreshClick(nil);
end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
var
  Node: TTreeNode;
  UsePos: TSymbolPosition;
  NewPoint: TPoint;
begin
  { Jump to that symbol location stored in data node. }
  Node := TreeView1.Selected;
  if Assigned(Node) then
  begin
    UsePos := TSymbolPosition(Node.Data);  // uses pointer to data in TProgram.SymbolDictionary
    { Focus the desired position }
    if Assigned(UsePos) then
    begin
      NewPoint.X := UsePos.ScriptPos.Col;
      NewPoint.Y := UsePos.ScriptPos.Line;
      SynEdit1.CaretXY := NewPoint;
      // set the SynEdit to the active control
      ActiveControl := SynEdit1;

      { Try to roughly center the new position in the window }
      SynEdit1.TopLine := NewPoint.Y - (SynEdit1.LinesInWindow div 2);
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(FProgram) then
    FProgram.Free;
end;

end.
