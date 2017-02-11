{ NOTE: Properties of the TSynCompletionProposal components are very
  important.
  Sample setup:
  +-Code Complete--
    +-Columns (1 with 'BiggestWord' set to 'constructor')
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

unit OptimizedForm;

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, dws2VCLGUIFunctions, dws2FileFunctions, dws2Comp, dws2Exprs,
  SynEditHighlighter, SynHighlighterPas, SynCompletionProposal, SynEdit,
  dws2VclIdeUtils, ImgList, StdCtrls, ExtCtrls;

type
  TfmOptimized = class(TForm)
    SynEdit1: TSynEdit;
    CodeProposal: TSynCompletionProposal;
    SynPasSyn1: TSynPasSyn;
    DelphiWebScriptII1: TDelphiWebScriptII;
    dws2Unit1: Tdws2Unit;
    dws2FileFunctions1: Tdws2FileFunctions;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    ParamProposal: TSynCompletionProposal;
    ScriptHint: TSynCompletionProposal;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ProposalExecute(Kind: SynCompletionType; Sender: TObject;
      var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure SynEdit1Change(Sender: TObject);
    procedure SynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FUnitInserts,
    FUnitItemLists: TStringList;
    FScriptModified : Boolean;
    FProgram : TProgram;    // compiled program (re-used if unchanged), may be nil
  public
    { Public declarations }
  end;

var
  fmOptimized: TfmOptimized;

implementation

uses dws2SynEditUtils, dws2IDEUtils;

{$R *.dfm}

procedure TfmOptimized.FormCreate(Sender: TObject);
var
  Prg: TProgram;
begin
  FScriptModified := True;    // default to true, create the compiled program (using the script) upon the first use

  FUnitInserts   := TStringList.Create;
  FUnitItemLists := TStringList.Create;

  { Internally compile an empty script. Build a list of all base symbols that
    are available to the script. Re-use this symbol list so it doesn't get
    rebuilt with each use. The list of items available to the script will not
    change during script execution or usage. These are compiled into the
    application so we only need to process them once. }
  Prg := CompileWithSymbolsAndMap(DelphiWebScriptII1, ''); // use NO script. Just want things available outside of script.   SynEdit1.Lines.Text);
  try
    LoadUnitDeclaredSymbols(Prg, FUnitItemLists, FUnitInserts, [doSynStyle], [coIncludeContext, coIncludeUnit], True);
  finally
    Prg.Free;
  end;
end;

procedure TfmOptimized.FormDestroy(Sender: TObject);
begin
  FUnitInserts.Free;
  FUnitItemLists.Free;
end;

procedure TfmOptimized.ProposalExecute(Kind: SynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
begin
  // if the script is dirty, recompile it
  if FScriptModified then begin
    // free the previously compiled program
    FreeAndNil(FProgram);
    // recompile the script
    FProgram := CompileWithSymbolsAndMap(DelphiWebScriptII1, SynEdit1.Lines.Text);
  end;

  case Kind of
  ctCode :
    begin
      // use the compiled program to fetch out the symbols in the script. Re-use
      // the symbols from the FUnitXXX lists.
      CanExecute := PerformCodeCompletion(SynEdit1, FProgram,
                                          TSynCompletionProposal(Sender),
                                          FUnitItemLists, FUnitInserts, x, y,
                                          False, True);
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
                                        False);
    end;
  end;
end;

procedure TfmOptimized.SynEdit1Change(Sender: TObject);
begin
  { Mark the script as "dirty". Next time a proposal is needed, the script
    should be re-compiled. }
  FScriptModified := True;
end;

procedure TfmOptimized.SynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  // Reset the hint timer when the mouse moves
  ScriptHint.DeactivateTimer;
  ScriptHint.ActivateTimer(Sender as TCustomSynEdit);
end;

end.
