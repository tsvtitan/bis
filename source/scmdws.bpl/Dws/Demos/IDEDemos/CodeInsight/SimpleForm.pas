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
{ Known issues:
   No hints for methods of objects. (members of records too) }
unit SimpleForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, dws2VCLGUIFunctions, dws2FileFunctions, dws2Comp, dws2Exprs,
  SynEditHighlighter, SynHighlighterPas, SynCompletionProposal, SynEdit,
  ImgList, StdCtrls;

type
  TfmSimple = class(TForm)
    SynEdit1: TSynEdit;
    CodeProposal: TSynCompletionProposal;
    SynPasSyn1: TSynPasSyn;
    DelphiWebScriptII1: TDelphiWebScriptII;
    dws2Unit1: Tdws2Unit;
    dws2FileFunctions1: Tdws2FileFunctions;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    ParamProposal: TSynCompletionProposal;
    ScriptHint: TSynCompletionProposal;
    procedure SynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ProposalExecute(Kind: SynCompletionType; Sender: TObject;
      var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
  private
  public
  end;

var
  fmSimple: TfmSimple;

implementation

{$R *.dfm}

uses dws2SynEditUtils;

procedure TfmSimple.ProposalExecute(Kind: SynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
begin
  // Perform the funtion, recompile the script every time (regardless of if it
  // changed or not). Very simple approach to using it.
  case Kind of
  ctCode   : CanExecute := PerformCodeCompletion(SynEdit1, DelphiWebScriptII1,
                                                 TSynCompletionProposal(Sender),
                                                 x, y, False, True);
  ctParams : CanExecute := PerformParamProposal(SynEdit1, DelphiWebScriptII1,
                                                TSynCompletionProposal(Sender),
                                                x, y);
  ctHint   : CanExecute := PerformHintProposal(SynEdit1, DelphiWebScriptII1,
                                               TSynCompletionProposal(Sender),
                                               x, y, False);
  end;
end;

procedure TfmSimple.SynEdit1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  // Reset the hint timer when the mouse moves
  ScriptHint.DeactivateTimer;
  ScriptHint.ActivateTimer(Sender as TCustomSynEdit);
end;

end.
