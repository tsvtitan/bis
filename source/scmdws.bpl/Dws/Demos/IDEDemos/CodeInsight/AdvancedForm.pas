{ NOTE: Properties of the TSynCompletionProposal components are very
  important.
  Sample setup:
  +-Code Complete--
    +-Column ('BiggestWord' set to 'ww')     // used for images
    +-Column ('BiggestWord' set to 'constructor')
    +-DefaultType := ctCode
    +-Options := [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion];
    +-NbLinesInWindow := 16;  // helpful
    +-EndOfTokenChr := '()[]. ';
    +-TriggerChars := '.';
    +-with Columns.Add do
      BiggestWord := 'constructor';
    +-ShortCut := 16416;
  +-Param proposal--
    +-DefaultType := ctParams;
    +-Options := [scoLimitToMatchedText, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion];
    +-ClBackground := clInfoBk;
    +-EndOfTokenChr := '()[]. ';
    +-TriggerChars := '(';
    +-ShortCut := 24608;
    +-TimerInterval := 500;
  +-Hint proposal--
    +-DefaultType := ctHint;
    +-Options := [scoAnsiStrings, scoLimitToMatchedText, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion, scoConsiderWordBreakChars];
    +-EndOfTokenChr := '()[]. ';
    +-TriggerChars := ' ';
    +-ShortCut := 0;
    +-TimerInterval := 500;  }

{$INCLUDE dws2.inc}

unit AdvancedForm;

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, dws2VCLGUIFunctions, dws2FileFunctions, dws2Comp, dws2Exprs,
  SynEditHighlighter, SynHighlighterPas, SynCompletionProposal, SynEdit,
  dws2VclIdeUtils, ImgList, StdCtrls, ExtCtrls, Menus, ActnList;

type
  TfmAdvanced = class(TForm)
    SynEdit1: TSynEdit;
    CodeProposal: TSynCompletionProposal;
    SynPasSyn1: TSynPasSyn;
    DelphiWebScriptII1: TDelphiWebScriptII;
    dws2Unit1: Tdws2Unit;
    dws2FileFunctions1: Tdws2FileFunctions;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    ParamProposal: TSynCompletionProposal;
    ScriptHint: TSynCompletionProposal;
    pOptions: TPanel;
    chkIncludeGraphics: TCheckBox;
    alActions: TActionList;
    actCompleteClass: TAction;
    pMenu: TPopupMenu;
    actCompleteClass1: TMenuItem;
    actCompleteAllClasses: TAction;
    lbMessages: TListBox;
    chkIncludeReadWrite: TCheckBox;
    Completeallclasses1: TMenuItem;
    ilSymbolImages: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ProposalExecute(Kind: SynCompletionType; Sender: TObject;
      var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure SynEdit1Change(Sender: TObject);
    procedure SynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure chkIncludeGraphicsClick(Sender: TObject);
    procedure actCompleteClassExecute(Sender: TObject);
    procedure actCompleteAllClassesExecute(Sender: TObject);
  private
    FUnitInserts,
    FUnitItemLists: TStringList;
    FScriptModified : Boolean;
    FProgram : TProgram;    // compiled program (re-used if unchanged), may be nil
    procedure BuildUnitLists(UseGraphics: Boolean);
  public
    procedure CompileIfNeeded;
  end;

var
  fmAdvanced: TfmAdvanced;

implementation

uses dws2SynEditUtils, dws2IDEUtils;

{$R *.dfm}

procedure TfmAdvanced.FormCreate(Sender: TObject);
begin
  FScriptModified := True;    // default to true, create the compiled program (using the script) upon the first use

  FUnitInserts   := TStringList.Create;
  FUnitItemLists := TStringList.Create;

  BuildUnitLists(chkIncludeGraphics.Checked);
end;

procedure TfmAdvanced.FormDestroy(Sender: TObject);
begin
  FUnitInserts.Free;
  FUnitItemLists.Free;
end;

procedure TfmAdvanced.ProposalExecute(Kind: SynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
begin
  CompileIfNeeded;

  case Kind of
  ctCode :
    begin
      // use the compiled program to fetch out the symbols in the script. Re-use
      // the symbols from the FUnitXXX lists.
      CanExecute := PerformCodeCompletion(SynEdit1, FProgram,
                                          TSynCompletionProposal(Sender),
                                          FUnitItemLists, FUnitInserts, x, y,
                                          chkIncludeGraphics.Checked,
                                          chkIncludeReadWrite.Checked);
    end;
  ctParams :
    begin
      CanExecute := PerformParamProposal(SynEdit1, FProgram,
                                         TSynCompletionProposal(Sender), x, y);
    end;
  ctHint :
    begin
      CanExecute := PerformHintProposal(SynEdit1, FProgram,
                                        TSynCompletionProposal(Sender), x, y,
                                        chkIncludeGraphics.Checked);
    end;
  end;
end;

procedure TfmAdvanced.SynEdit1Change(Sender: TObject);
begin
  { Mark the script as "dirty". Next time a proposal is needed, the script
    should be re-compiled. }
  FScriptModified := True;
end;

procedure TfmAdvanced.SynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  // Reset the hint timer when the mouse moves
  ScriptHint.DeactivateTimer;
  ScriptHint.ActivateTimer(Sender as TCustomSynEdit);
end;

procedure TfmAdvanced.chkIncludeGraphicsClick(Sender: TObject);
begin
  { Clear all columns }
  CodeProposal.Columns.Clear;
  { Want graphics, add column for that spacing }
  if chkIncludeGraphics.Checked then
  begin
    with CodeProposal.Columns.Add do
      BiggestWord := 'ww';
  end;
  { Always add back this column }
  with CodeProposal.Columns.Add do
    BiggestWord := 'constructor';

  { Rebuild the Unit lists to reflect graphics choice }
  BuildUnitLists(chkIncludeGraphics.Checked);
end;

procedure TfmAdvanced.BuildUnitLists(UseGraphics: Boolean);
var
  Prg: TProgram;
  DispOpts: TdSyn_DisplayOptions;
begin
  // set to default
  DispOpts := [doSynStyle];
  if UseGraphics then                   // if graphics used,
    Include(DispOpts, doIncludeImage);  // add the graphics

  { Internally compile an empty script. Build a list of all base symbols that
    are available to the script. Re-use this symbol list so it doesn't get
    rebuilt with each use. The list of items available to the script will not
    change during script execution or usage. These are compiled into the
    application so we only need to process them once.}
  Prg := CompileWithSymbolsAndMap(DelphiWebScriptII1, ''); // use NO script. Just want things available outside of script.   SynEdit1.Lines.Text);
  try
    LoadUnitDeclaredSymbols(Prg, FUnitItemLists, FUnitInserts, DispOpts,
                            [{coIncludeContext, coIncludeUnit}], True);
  finally
    Prg.Free;
  end;
end;

procedure TfmAdvanced.actCompleteClassExecute(Sender: TObject);
begin
  CompileIfNeeded;
  try
    CompleteClassAtCursor(DelphiWebScriptII1, FProgram, SynEdit1.CaretY, SynEdit1.CaretX, SynEdit1.Lines, False);
    FScriptModified := True;
  finally
    CompileIfNeeded;
  end;
end;

procedure TfmAdvanced.actCompleteAllClassesExecute(Sender: TObject);
begin
  CompileIfNeeded;
  try
    CompleteAllClasses(DelphiWebScriptII1, SynEdit1.Lines, False);
    FScriptModified := True;
  finally
    CompileIfNeeded;
  end;
end;

procedure TfmAdvanced.CompileIfNeeded;
var
  i: Integer;
begin
  // if the script is dirty, recompile it
  if FScriptModified then begin
    // free the previously compiled program
    FreeAndNil(FProgram);
    // recompile the script
    FProgram := CompileWithSymbolsAndMap(DelphiWebScriptII1, SynEdit1.Lines.Text);
    { Show messages }
    lbMessages.Items.Clear;
    for i := 0 to FProgram.Msgs.Count - 1 do
      lbMessages.Items.AddObject(FProgram.Msgs[i].AsInfo, FProgram.Msgs[i]);
    { If compile was without error }
    if lbMessages.Items.Count = 0 then
      lbMessages.Items.Add('**Compiled**');
  end;
end;

end.
