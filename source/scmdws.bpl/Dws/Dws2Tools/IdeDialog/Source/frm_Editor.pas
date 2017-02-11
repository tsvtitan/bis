{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is frm_Editor source code, released May 16,     }
{    2002.                                                             }
{                                                                      }
{    The Initial Developer of the Original Code is Fabio Augusto Dal   }
{    Castel. Significant portions were contributed by Pietro Barbaro   }
{    and Mark Ericksen. Portions created by their respective authors   }
{    are Copyright (C) 2002, 2003 by the respective author.            }
{                                                                      }
{    All Rights Reserved.                                              }
{                                                                      }
{**********************************************************************}

{$I dws2.inc}

unit frm_Editor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, ActnList, ExtCtrls, SynEdit, ComCtrls, ToolWin, Buttons,
  StdCtrls, Tabs, SynEditHighlighter,
  {$IFDEF NEWDESIGN}
  StrUtils,
  {$ENDIF}
  dws2Comp, dws2Symbols, dws2Compiler, dws2Exprs, dws2Errors,
  dws2ThreadedDebugger, dwsIDETypes, dws2VCLSymbolsToTree, dws2IDEUtils,
  dws2SynEditUtils, SynEditMiscClasses, SynEditSearch, dws2VclIdeUtils,
  SynCompletionProposal;

type
  TfrmEditor = class(TForm)
    ActionList: TActionList;
    pmEditorPopupMenu: TPopupMenu;
    ActFileOpen: TAction;
    ActFileSaveAs: TAction;
    ActFileExit: TAction;
    ActEditCopy: TAction;
    ActEditCut: TAction;
    ActEditDelete: TAction;
    ActEditPaste: TAction;
    ActEditSelectAll: TAction;
    ActEditUndo: TAction;
    ActEditRedo: TAction;
    ActRunCompile: TAction;
    ActRunExecute: TAction;
    StatusBar: TStatusBar;
    pnlCompilerMessages: TPanel;
    SplitterMessages: TSplitter;
    ListBoxCompilerMessages: TListBox;
    SynEdit: TSynEdit;
    PopupMnuEditUndo: TMenuItem;
    PopupMnuEditRedo: TMenuItem;
    N4: TMenuItem;
    PopupMnuEditCut: TMenuItem;
    PopupMnuEditCopy: TMenuItem;
    PopupMnuEditPaste: TMenuItem;
    PopupMnuEditDelete: TMenuItem;
    N5: TMenuItem;
    PopupMnuEditSelectAll: TMenuItem;
    ActEditFind: TAction;
    ActEditReplace: TAction;
    ActEditFindNext: TAction;
    ActEditFindPrev: TAction;
    ActRunStepOver: TAction;
    ActRunStepInto: TAction;
    ActRunRunToCursor: TAction;
    ActRunRunUntilReturn: TAction;
    ActRunShowExecutionPoint: TAction;
    ActRunProgramPause: TAction;
    ActRunProgramReset: TAction;
    PnlCaptionMessages: TPanel;
    SBCloseMessages: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ActRunToggleBreakpoint: TAction;
    ActRunClearAllBreakpoints: TAction;
    ImgGutterGlyphs: TImageList;
    ActRunEvaluate: TAction;
    ActFileNew: TAction;
    ActRunCallStack: TAction;
    ActFileSave: TAction;
    PnInputOutput: TPanel;
    MemoInputOutput: TMemo;
    pcMessages: TPageControl;
    tsCompiler: TTabSheet;
    tsInputOutput: TTabSheet;
    PnlMessages: TPanel;
    ActViewMessages: TAction;
    CBImmediate: TComboBox;
    ButtonsImages: TImageList;
    FontDialog1: TFontDialog;
    AFonts: TAction;
    pCodeExplorer: TPanel;
    SplitterToolWindows: TSplitter;
    CodeExplorerTree: TTreeView;
    ActViewCodeTree: TAction;
    PCaptionCodeTree: TPanel;
    SBCloseCodeTree: TSpeedButton;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label1: TLabel;
    ActHelp: TAction;
    ActAbout: TAction;
    acnClose: TAction;
    ControlBar1: TControlBar;
    ToolBar6: TToolBar;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolBar7: TToolBar;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    ToolButton43: TToolButton;
    ToolButton5: TToolButton;
    ToolButton8: TToolButton;
    ToolButton11: TToolButton;
    mMain: TMainMenu;
    miFile: TMenuItem;
    New1: TMenuItem;
    N9: TMenuItem;
    Open1: TMenuItem;
    N10: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N11: TMenuItem;
    Exit1: TMenuItem;
    miEdit: TMenuItem;
    miView: TMenuItem;
    miRun: TMenuItem;
    miHelp: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N2: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Selectall1: TMenuItem;
    N3: TMenuItem;
    Find1: TMenuItem;
    Replace1: TMenuItem;
    Findnext1: TMenuItem;
    Findprevious1: TMenuItem;
    miViewViewMessagesWindow: TMenuItem;
    miViewCodeTreeWindow: TMenuItem;
    N1: TMenuItem;
    miViewEditorFonts: TMenuItem;
    miViewRefreshCodeTree: TMenuItem;
    Compile1: TMenuItem;
    Execute1: TMenuItem;
    N6: TMenuItem;
    Stepinto1: TMenuItem;
    Stepover1: TMenuItem;
    Runtocursor1: TMenuItem;
    Rununtilreturn1: TMenuItem;
    Showexecutionpoint1: TMenuItem;
    Programpause1: TMenuItem;
    Programreset1: TMenuItem;
    N7: TMenuItem;
    Togglebreakpoint1: TMenuItem;
    Clearallbreakpoints1: TMenuItem;
    Evaluate1: TMenuItem;
    Callstack1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ilSymbolImages: TImageList;
    N8: TMenuItem;
    ActCompleteClassAtCursor: TAction;
    ActCompleteAllClasses: TAction;
    N12: TMenuItem;
    miCompleteClasses: TMenuItem;
    miCompleteCursorClass: TMenuItem;
    ActToggleImplDeclPos: TAction;
    SynEditSearch: TSynEditSearch;
    synCodeProposal: TSynCompletionProposal;
    synParamProposal: TSynCompletionProposal;
    synSymbolHint: TSynCompletionProposal;
    tInsightCompileTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure ActFileNewExecute(Sender: TObject);
    procedure ActFileOpenExecute(Sender: TObject);
    procedure ActFileSaveAsExecute(Sender: TObject);
    procedure ActFileExitExecute(Sender: TObject);

    procedure ActEditCopyExecute(Sender: TObject);
    procedure ActEditCutExecute(Sender: TObject);
    procedure ActEditDeleteExecute(Sender: TObject);
    procedure ActEditPasteExecute(Sender: TObject);
    procedure ActEditSelectAllExecute(Sender: TObject);
    procedure ActEditUndoExecute(Sender: TObject);
    procedure ActEditRedoExecute(Sender: TObject);
    procedure ActEditFindExecute(Sender: TObject);
    procedure ActEditReplaceExecute(Sender: TObject);
    procedure ActEditFindNextExecute(Sender: TObject);
    procedure ActEditFindPrevExecute(Sender: TObject);

    procedure ActEditCopyUpdate(Sender: TObject);
    procedure ActEditCutUpdate(Sender: TObject);
    procedure ActEditDeleteUpdate(Sender: TObject);
    procedure ActEditPasteUpdate(Sender: TObject);
    procedure ActEditUndoUpdate(Sender: TObject);
    procedure ActEditRedoUpdate(Sender: TObject);
    procedure ActEditReplaceUpdate(Sender: TObject);
    procedure ActEditFindNextUpdate(Sender: TObject);
    procedure ActEditFindPrevUpdate(Sender: TObject);

    procedure ActRunCompileExecute(Sender: TObject);
    procedure ActRunExecuteExecute(Sender: TObject);
    procedure ActRunStepIntoExecute(Sender: TObject);
    procedure ActRunStepOverExecute(Sender: TObject);
    procedure ActRunRunToCursorExecute(Sender: TObject);
    procedure ActRunRunUntilReturnExecute(Sender: TObject);
    procedure ActRunShowExecutionPointExecute(Sender: TObject);
    procedure ActRunProgramPauseExecute(Sender: TObject);
    procedure ActRunProgramResetExecute(Sender: TObject);
    procedure ActRunToggleBreakpointExecute(Sender: TObject);
    procedure ActRunClearAllBreakpointsExecute(Sender: TObject);
    procedure ActRunEvaluateExecute(Sender: TObject);
    procedure ActRunCallStackExecute(Sender: TObject);

    procedure ActFileSaveUpdate(Sender: TObject);

    procedure ActRunExecuteUpdate(Sender: TObject);
    procedure ActRunStepIntoUpdate(Sender: TObject);
    procedure ActRunStepOverUpdate(Sender: TObject);
    procedure ActRunRunToCursorUpdate(Sender: TObject);
    procedure ActRunRunUntilReturnUpdate(Sender: TObject);
    procedure ActRunShowExecutionPointUpdate(Sender: TObject);
    procedure ActRunProgramPauseUpdate(Sender: TObject);
    procedure ActRunProgramResetUpdate(Sender: TObject);
    procedure ActRunEvaluateUpdate(Sender: TObject);
    procedure ActRunCallStackUpdate(Sender: TObject);
    procedure ActRunOutputUpdate(Sender: TObject);
    procedure SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure SynEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure SynEditStatusChange(Sender: TObject; Changes: TSynStatusChanges);

    procedure SBCloseMessagesClick(Sender: TObject);
    procedure ListBoxCompilerMessagesClick(Sender: TObject);
    procedure ActFileSaveExecute(Sender: TObject);
    procedure SynEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ActViewMessagesExecute(Sender: TObject);
    procedure MemoInputOutputChange(Sender: TObject);
    procedure CBImmediateKeyPress(Sender: TObject; var Key: Char);
    procedure AFontsExecute(Sender: TObject);
    procedure CodeExplorerTreeDblClick(Sender: TObject);
    procedure ActViewCodeTreeExecute(Sender: TObject);
    procedure ActHelpExecute(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure acnCloseExecute(Sender: TObject);
    procedure SynEditChange(Sender: TObject);
    procedure ActFileNewUpdate(Sender: TObject);
    procedure ActFileOpenUpdate(Sender: TObject);
    procedure ActFileSaveAsUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActCompleteAllClassesExecute(Sender: TObject);
    procedure ActCompleteClassAtCursorExecute(Sender: TObject);
    procedure CodeExplorerTreeKeyPress(Sender: TObject; var Key: Char);
    procedure ActToggleImplDeclPosExecute(Sender: TObject);
    procedure ProposalExecute(Kind: SynCompletionType; Sender: TObject;
      var CurrentInput: String; var x, y: Integer;
      var CanExecute: Boolean);
    procedure tInsightCompileTimerTimer(Sender: TObject);
    procedure SynEditGutterClick(Sender: TObject; Button: TMouseButton; X, Y,
      Line: Integer; Mark: TSynEditMark);
  private
    FDebugMode: boolean;
    FNeedBaseCompile: boolean;
    FNeedInsightCompile: boolean;
    FEditorReadOnly: Boolean;
    FLoadedScriptIsFileName : Boolean;
    FUnitInserts,
    FUnitItemLists: TStringList;

    FExecuteFailed: boolean;
    FHighlightLine: Integer;
    FSearchFromCursor: Boolean;
    FCurrentLine: Integer;
    FEditorHighLighter: TSynCustomHighlighter;
    FScriptName: string;
    FTitle: string;

    procedure InitThreadRunner;
    procedure CheckSaveChanges;
    function CheckCompiled: boolean;
    procedure SetCompileNeeded;
    procedure DoScriptOpen(const AScriptName: string; AScript: TStrings; AReadOnly, IsFileName: Boolean);
    function GetShowMessages: Boolean;
    procedure PaintGutterGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
    procedure SetCurrentLine(const Value: Integer);
    procedure SetShowMessages(const Value: Boolean);
    procedure ShowSearchReplaceDialog(AReplace: Boolean);
    procedure StatusInfo(const AInfo: string);
    procedure UpdateCallStack;
    procedure UpdateOutput(text: string = '');
    procedure UpdateErrorMessages;
    procedure HighlightMsg(Msg: Tdws2Msg);
    procedure RefreshCodeExplorer;

    function CheckForErrors: boolean;
    procedure CheckInternalErrors;
    procedure CheckCompilerErrors;
    procedure CheckRuntimeErrors;
    procedure captureErrorMessage(e: Exception);
    procedure SetDebugMode(const Value: boolean);

    property ShowMessages: Boolean read GetShowMessages write SetShowMessages;
    property CurrentLine: Integer read FCurrentLine write SetCurrentLine;
    procedure SetScriptName(const Value: string);

    function parseCommand(aStr: string; var procName: string;
      var procParams: TArrayOfVariant): byte;

    function getCurrentLine(aMsg: TDws2Msg): integer;
    function getFirstLineError: integer;
    function GetInDebugPause: Boolean;
    function GetInDebugSession: Boolean;
    procedure SetEditorReadOnly(const Value: Boolean);
    procedure SetTitle(const Value: string);

  protected
    FDebugger: TDws2ThreadedDebugger;
    FProgram: TProgram;
    FInsightProgram: TProgram;    // program used for CodeInsight features. (separate so debugging isn't affected)

    FDWScript: TDelphiWebScriptII;

    FScriptHandler: IExternalScriptHandler;
    FOptionSetter: IExternalOptionSetter;
    FOptions: TEditorOptions;
    function GetShortScriptName: string;
    procedure CreateParams(var Params: TCreateParams); Override;
    procedure UpdateDialogTitle; dynamic;
    procedure InitializeCodeInsight;
    procedure BuildUnitLists;
    procedure CompileCodeInsightProgram;
  public
    constructor Create(AOwner: TComponent; aScriptProvider: IExternalScriptHandler;
                       aOptionSetter: IExternalOptionSetter); reintroduce;
    destructor Destroy; override;

    property DebugMode: boolean read FDebugMode write SetDebugMode;
    property InDebugPause: Boolean read GetInDebugPause;
    property InDebugSession: Boolean read GetInDebugSession;
    property EditorReadOnly : Boolean read FEditorReadOnly write SetEditorReadOnly;
    property ScriptName: string read FScriptName write SetScriptName;
    property Title: string read FTitle write SetTitle;

    // EditorHighLighter: SynEdit highlighter for the IDE
    property EditorHighLigther: TSynCustomHighlighter read FEditorHighLighter write FEditorHighLighter;

    procedure SearchReplaceText(AReplace: Boolean; ABackwards: Boolean);
    procedure HighlightLine(ACol, ALine: Integer);
    procedure PrepareIDE;
    procedure OpenIDE;
    procedure ThreadRunnerDebugPause(sender: TObject; Prog: TProgram; Expr: TExpr);
    procedure ThreadRunnerDebugTrapError;
    procedure ThreadRunnerDebugResume(Sender: TObject);
    procedure ThreadRunnerTerminate(Sender: TObject);
    function Compile: boolean;
    procedure Execute; overload;
    function Execute(const sFunctionName: string; const Params: array of Variant): Variant; overload;
    function ExecuteCommand(const CommandText: string): variant;
    procedure Continue;
    procedure StepInto;
    procedure StepOver;
    procedure RunToLine(Line: integer);
    procedure RunUntilReturn;
    procedure Pause;
    procedure Reset(forceRecompile: boolean = false);
    procedure FinalizeProgram;
  end;

implementation

uses frm_EditorSearch, frm_EditorReplace, frm_EditorConfirmReplace,
  frm_EditorEvaluate, frm_EditorCallStack,
  {$IFDEF NEWVARIANTS}Variants, {$ENDIF} SynEditTypes;

{$R *.DFM}

var
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCursor: boolean;
  gbSearchInSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;

  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;

const
  PROC_IMAGEINDEX = 1;
  FUNC_IMAGEINDEX = 2;

type
  TGutterMarkDrawPlugin = class(TSynEditPlugin)
  protected
    FForm: TfrmEditor;
    procedure AfterPaint(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer); override;
    procedure LinesInserted(FirstLine, Count: integer); override;
    procedure LinesDeleted(FirstLine, Count: integer); override;
  public
    constructor Create(AForm: TfrmEditor);
  end;

// --- TGutterMarkDrawPlugin ---------------------------------------------

constructor TGutterMarkDrawPlugin.Create(AForm: TfrmEditor);
begin
  inherited Create(AForm.SynEdit);
  FForm := AForm;
end;

procedure TGutterMarkDrawPlugin.AfterPaint(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
begin
  FForm.PaintGutterGlyphs(ACanvas, AClip, FirstLine, LastLine);
end;

procedure TGutterMarkDrawPlugin.LinesDeleted(FirstLine, Count: integer);
begin
  // To do
end;

procedure TGutterMarkDrawPlugin.LinesInserted(FirstLine, Count: integer);
begin
  // To do
end;

// --- TfrmEditor --------------------------------------------------------

constructor TfrmEditor.Create(AOwner: TComponent; aScriptProvider: IExternalScriptHandler;
                              aOptionSetter: IExternalOptionSetter);
begin
  inherited Create(AOwner);
  FUnitInserts   := TStringList.Create;
  FUnitItemLists := TStringList.Create;

  FScriptHandler := aScriptProvider;
  Assert(FScriptHandler<>nil, 'An IExternalScriptHandler interface must be assigned');
  FOptionSetter := aOptionSetter;
  Assert(FOptionSetter<>nil, 'An IExternalOptionSetter interface must be assigned');

  FLoadedScriptIsFileName := False;

  { Get the options from the controller. Enable/disable actions accordingly }
//  ApplyEditorOptions(FScriptHandler.GetOptions);
end;

procedure TfrmEditor.FormShow(Sender: TObject);
begin
  // focus code editor by default
  ActiveControl := SynEdit;
  FScriptHandler.EditorOpen;
end;

destructor TfrmEditor.Destroy;
begin
  FScriptHandler := nil;     // de-reference the interface
  FOptionSetter := nil;
  FUnitInserts.Free;
  FUnitItemLists.Free;
  inherited;
end;

procedure TfrmEditor.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
    exStyle := exStyle Or WS_EX_APPWINDOW;
end;

procedure TfrmEditor.OpenIDE;
begin
  if not FDebugMode then
  begin
    raise Exception.Create('Warning: IDE Can''t start while DebugMode flag is off.');
//    ShowMessage('Warning: IDE Can''t start while DebugMode flag is off.');
//    Exit;
  end
  else begin
//    PrepareIDE;

    if (WindowState = wsMinimized) then
      WindowState := wsNormal
    else if Visible then
      SetFocus
    else
      Show;
  end;
end;

procedure TfrmEditor.CheckSaveChanges;
var
  s: string;
begin
  if FDebugger.InDebugSession then
  begin
    s := 'Debug session in progress. Terminate?';
    if Application.MessageBox(PChar(s), PChar(Application.Title), MB_OKCANCEL or MB_ICONQUESTION) = IDCANCEL then
      Abort;
    ActRunProgramReset.Execute;
  end;

  if SynEdit.Modified then
  begin
    BringToFront;
    MessageBeep(MB_ICONQUESTION);
    if (FScriptName <> '') then
      s := 'Save changes to "' + GetShortScriptName + '"'
    else
      s := 'Save changes to new script?';
    case Application.MessageBox(PChar(s), PChar(Application.Title), MB_YESNOCANCEL or MB_ICONQUESTION) of
      IDYES:    ActFileSave.Execute;
      IDCANCEL: Abort;
    end;
  end;
end;

procedure TfrmEditor.DoScriptOpen(const AScriptName: string; AScript: TStrings; AReadOnly, IsFileName: Boolean);
begin
  CheckSaveChanges;

  SynEdit.Lines.Assign(AScript);
  SynEdit.Modified := False;
  SynEdit.ReadOnly := FEditorReadOnly and ((FileGetAttr(AScriptName) and faReadOnly) <> 0);

  FLoadedScriptIsFileName := IsFileName;
  if FLoadedScriptIsFileName then
    ChDir(ExtractFilePath(AScriptName));
  ScriptName := AScriptName;

  SynEditChange(SynEdit);              // (?) LoadFromFile doesn't call OnChange event

  FDebugger.ClearAllStatements;
  SynEdit.InvalidateGutter;
  CodeExplorerTree.Items.Clear;
  StatusInfo('');
end;


function TfrmEditor.GetShowMessages: Boolean;
begin
  Result := PnlMessages.Visible;
end;

procedure TfrmEditor.SetShowMessages(const Value: Boolean);
begin
  PnlMessages.Visible := Value;
  SplitterMessages.Visible := Value;
end;

procedure TfrmEditor.HighlightLine(ACol, ALine: Integer);
var
  L: Integer;
begin
  if FHighlightLine <> 0 then
  begin
    // Clear last line
    L := FHighlightLine;
    FHighlightLine := 0;
    SynEdit.InvalidateLine(L);
  end;

  if ALine <> 0 then
  begin
    // Position the caret
    SynEdit.CaretXY := Point(ACol, ALine);

    // Highlight line
    FHighlightLine := ALine;
    SynEdit.InvalidateLine(FHighlightLine);
  end;
end;

procedure TfrmEditor.PaintGutterGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
var
  X, Y: Integer;
  ImgIndex: integer;
begin
  X := 2;
  Y := (SynEdit.LineHeight - ImgGutterGlyphs.Height) div 2 + SynEdit.LineHeight * (FirstLine - SynEdit.TopLine);
  while FirstLine <= LastLine do
  begin
    ImgIndex := -1;
    if FirstLine = FCurrentLine then
    begin
      if FDebugger.Breakpoint[FirstLine] then
        ImgIndex := 2
      else
        ImgIndex := 1;
    end
    else if FDebugger.Statement[FirstLine] then
    begin
      if FDebugger.Breakpoint[FirstLine] then
        ImgIndex := 3
      else
        ImgIndex := 0;
    end
    else if FDebugger.Breakpoint[FirstLine] then
      ImgIndex := 3;       // Temporary... Should be 4

    if ImgIndex >= 0 then
      ImgGutterGlyphs.Draw(ACanvas, X, Y, ImgIndex);
    Inc(FirstLine);
    Inc(Y, SynEdit.LineHeight);
  end;
end;

procedure TfrmEditor.SetCurrentLine(const Value: Integer);
var
  L: Integer;
begin
  if FCurrentLine <> Value then
  begin
    if FCurrentLine <> 0 then
    begin
      // Clear last line
      L := FCurrentLine;
      FCurrentLine := 0;
      SynEdit.InvalidateLine(L);
    end;

    FCurrentLine := Value;
    if (FCurrentLine > 0) and (SynEdit.CaretY <> FCurrentLine) then
      SynEdit.CaretXY := Point(1, FCurrentLine);
    SynEdit.InvalidateLine(FCurrentLine);
  end;
end;

procedure TfrmEditor.SearchReplaceText(AReplace, ABackwards: Boolean);
var
  Options: TSynSearchOptions;
begin
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];

  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not FSearchFromCursor then
    Include(Options, ssoEntireScope);
  if gbSearchInSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);

  if SynEdit.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    if ssoBackwards in Options then
      SynEdit.BlockEnd := SynEdit.BlockBegin
    else
      SynEdit.BlockBegin := SynEdit.BlockEnd;
    SynEdit.CaretXY := SynEdit.BlockBegin;
  end;

  if frmEditorConfirmReplace <> nil then
    frmEditorConfirmReplace.Free;
end;

procedure TfrmEditor.ShowSearchReplaceDialog(AReplace: Boolean);
var
  dlg: TfrmEditorSearch;
begin
  if AReplace then
    dlg := TfrmEditorReplace.Create(Self)
  else
    dlg := TfrmEditorSearch.Create(Self);

  with dlg do
    try
      SearchBackwards := gbSearchBackwards;
      SearchCaseSensitive := gbSearchCaseSensitive;
      SearchFromCursor := gbSearchFromCursor;
      SearchInSelectionOnly := gbSearchInSelectionOnly;
      SearchWholeWords := gbSearchWholeWords;

      SearchText := gsSearchText;
      if gbSearchTextAtCaret then
      begin
        if SynEdit.SelAvail and (SynEdit.BlockBegin.Y = SynEdit.BlockEnd.Y)
        then
          SearchText := SynEdit.SelText
        else
          SearchText := SynEdit.GetWordAtRowCol(SynEdit.CaretXY);
      end;

      SearchTextHistory := gsSearchTextHistory;
      if AReplace then
        with dlg as TfrmEditorReplace do
        begin
          ReplaceText := gsReplaceText;
          ReplaceTextHistory := gsReplaceTextHistory;
        end;

      if ShowModal = mrOK then
      begin
        gbSearchBackwards := SearchBackwards;
        gbSearchCaseSensitive := SearchCaseSensitive;
        gbSearchFromCursor := SearchFromCursor;
        gbSearchInSelectionOnly := SearchInSelectionOnly;
        gbSearchWholeWords := SearchWholeWords;
        gsSearchText := SearchText;
        gsSearchTextHistory := SearchTextHistory;

        if AReplace then
          with dlg as TfrmEditorReplace do
          begin
            gsReplaceText := ReplaceText;
            gsReplaceTextHistory := ReplaceTextHistory;
          end;

        FSearchFromCursor := gbSearchFromCursor;
        if gsSearchText <> '' then
        begin
          SearchReplaceText(AReplace, gbSearchBackwards);
          FSearchFromCursor := True;
        end
      end;
    finally
      dlg.Free;
    end;
end;

procedure TfrmEditor.StatusInfo(const AInfo: string);
begin
  StatusBar.Panels.Items[3].Text := AInfo;
  StatusBar.Refresh;
end;

procedure TfrmEditor.ThreadRunnerDebugPause(Sender: TObject;
  Prog: TProgram; Expr: TExpr);
begin
  if FDebugMode then
  begin
    OpenIDE;
    if assigned(FProgram) and not FProgram.Msgs.HasExecutionErrors then
    begin
      CurrentLine := Expr.Pos.Line;

      if frmEditorCallStack.Visible and (frmEditorCallStack.Caller = Self) then
        UpdateCallStack;

      UpdateOutput;
      UpdateErrorMessages;

      StatusInfo('Paused.');
    end
    else
      ThreadRunnerDebugTrapError
  end;
end;

procedure TfrmEditor.ThreadRunnerDebugTrapError;
begin
  UpdateErrorMessages;
  StatusInfo('A RunTime Error occurred!');
end;

procedure TfrmEditor.ThreadRunnerDebugResume(Sender: TObject);
begin
  if FDebugMode then
  begin
    CurrentLine := 0;
    StatusInfo('Running...');
  end;
end;

procedure TfrmEditor.ThreadRunnerTerminate(Sender: TObject);
const
  ArrInfo: array[Boolean] of string = ('Finished.', 'Aborted.');
begin
  if FDebugMode and assigned(FProgram) then
  begin
//    StatusInfo(ArrInfo[(FProgram.ProgramState = psStopped)]);
    StatusInfo(ArrInfo[(FProgram.ProgramState = psTerminated)]);

    CurrentLine := 0;
    HighlightLine(0, 0);

    if frmEditorCallStack.Visible then
      frmEditorCallStack.Close;

    UpdateOutput;
  end;
end;

procedure TfrmEditor.UpdateCallStack;
begin
  FDebugger.GetCallStack(frmEditorCallStack.Items);
end;

procedure TfrmEditor.UpdateOutput(text: string);
var
  s: string;
begin
  if text = '' then
  begin
    if not Assigned(FProgram) then
      Exit;
    if FProgram.Result is Tdws2DefaultResult then
      s := Tdws2DefaultResult(FProgram.Result).Text;
  end
  else
    s := Text;

  MemoInputOutput.Lines.Text := s;
  MemoInputOutput.SelStart := Length(s);
  MemoInputOutput.SelLength := 0;
  PCMessages.ActivePage := TSInputOutput;
end;

// --- Events ------------------------------------------------------------

procedure TfrmEditor.FormCreate(Sender: TObject);
begin
  FDebugger := Tdws2ThreadedDebugger.Create(Self);
  FDebugger.OnDebugPause := ThreadRunnerDebugPause;
  FDebugger.OnDebugResume := ThreadRunnerDebugResume;
  FDebugger.OnDebugTerminate := ThreadRunnerTerminate;
  SetCompileNeeded;
  FTitle := 'Script Editor';

  TGutterMarkDrawPlugin.Create(Self);
  frmEditorEvaluate := TfrmEditorEvaluate.Create(Self);
  frmEditorCallStack := TfrmEditorCallStack.Create(Self);
end;

procedure TfrmEditor.FormDestroy(Sender: TObject);
begin
  ActRunProgramResetExecute(Sender);
  if Assigned(FDebugger) then
    FreeAndNil(FDebugger);
end;

procedure TfrmEditor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FScriptHandler.EditorCanClose;
  if CanClose then
  begin
//    Action := caHide;
    CheckSaveChanges;
    ActRunProgramReset.Execute;
    if Assigned(FDebugger) then
    begin
      FDebugger.ClearAllBreakpoints;
      FDebugger.ClearAllStatements;
    end;
  end
//  else
//    Action := caNone;
end;

procedure TfrmEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FScriptHandler.EditorClose;
end;

procedure TfrmEditor.ActFileNewExecute(Sender: TObject);
begin
  CheckSaveChanges;
  SynEdit.Lines.Clear;
  SynEdit.Modified := False;
  SetCompileNeeded;
  FScriptName := '';

  SynEditChange(SynEdit);            // (?) Lines.Clear doesn't call OnChange event

  FDebugger.ClearAllStatements;
  SynEdit.InvalidateGutter;
  SynEdit.ReadOnly := FEditorReadOnly;
  CodeExplorerTree.Items.Clear;
end;

procedure TfrmEditor.ActFileOpenExecute(Sender: TObject);
var
  aName: string;
  aReadOnly, IsFileName : Boolean;
  aScript: TStringList;
begin
  aScript := TStringList.Create;
  try
    aReadOnly  := False;
    IsFileName := False;
    if FScriptHandler.LoadScript(aName, aScript, aReadOnly, IsFileName) then
      DoScriptOpen(aName, aScript, aReadOnly, IsFileName);
  finally
    aScript.Free;
  end;
end;

procedure TfrmEditor.ActFileSaveExecute(Sender: TObject);
begin
  if (FScriptName <> '') and (not SynEdit.ReadOnly) then
  begin
    FScriptHandler.SaveScript(FScriptName, SynEdit.Lines);
    SynEdit.Modified := False;
  end
  else
    ActFileSaveAs.Execute;
end;

procedure TfrmEditor.ActFileSaveAsExecute(Sender: TObject);
var
  NewName: string;
begin
  NewName := FScriptName;    // give default value
  if not FScriptHandler.SaveScriptAs(NewName, SynEdit.Lines) then
    Abort;

  SynEdit.Modified := False;
  ScriptName := NewName;
end;

procedure TfrmEditor.acnCloseExecute(Sender: TObject);
begin
  hide;
end;

procedure TfrmEditor.ActFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditor.ActEditCopyExecute(Sender: TObject);
begin
  SynEdit.CopyToClipboard;
end;

procedure TfrmEditor.ActEditCutExecute(Sender: TObject);
begin
  SynEdit.CutToClipboard;
end;

procedure TfrmEditor.ActEditDeleteExecute(Sender: TObject);
begin
  SynEdit.SelText := '';
end;

procedure TfrmEditor.ActEditPasteExecute(Sender: TObject);
begin
  SynEdit.PasteFromClipboard;
end;

procedure TfrmEditor.ActEditSelectAllExecute(Sender: TObject);
begin
  SynEdit.SelectAll;
end;

procedure TfrmEditor.ActEditUndoExecute(Sender: TObject);
begin
  SynEdit.Undo;
end;

procedure TfrmEditor.ActEditRedoExecute(Sender: TObject);
begin
  SynEdit.Redo;
end;

procedure TfrmEditor.ActEditFindExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(False)
end;

procedure TfrmEditor.ActEditReplaceExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(True)
end;

procedure TfrmEditor.ActEditFindNextExecute(Sender: TObject);
begin
  SearchReplaceText(False, False);
end;

procedure TfrmEditor.ActEditFindPrevExecute(Sender: TObject);
begin
  SearchReplaceText(False, True);
end;

procedure TfrmEditor.ActEditCopyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := SynEdit.SelAvail;
end;

procedure TfrmEditor.ActEditCutUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := SynEdit.SelAvail and (not SynEdit.ReadOnly);
end;

procedure TfrmEditor.ActEditDeleteUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := SynEdit.SelAvail and (not SynEdit.ReadOnly);
end;

procedure TfrmEditor.ActEditPasteUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := SynEdit.CanPaste;
end;

procedure TfrmEditor.ActEditUndoUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := SynEdit.CanUndo;
end;

procedure TfrmEditor.ActEditRedoUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := SynEdit.CanRedo;
end;

procedure TfrmEditor.ActEditReplaceUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := not SynEdit.ReadOnly;
end;

procedure TfrmEditor.ActEditFindNextUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (gsSearchText <> '');
end;

procedure TfrmEditor.ActEditFindPrevUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (gsSearchText <> '');
end;

procedure TfrmEditor.ActViewMessagesExecute(Sender: TObject);
begin
  ShowMessages := not ShowMessages;
end;

procedure TfrmEditor.ActViewCodeTreeExecute(Sender: TObject);
begin
  PCodeExplorer.Visible := not PCodeExplorer.Visible;
  SplitterToolWindows.Visible := not SplitterToolWindows.Visible;
end;

procedure TfrmEditor.ActRunCompileExecute(Sender: TObject);
begin
  StatusInfo('Compiling...');
  try
    CheckCompiled;
  finally
    StatusInfo('Compiled.');
  end;
end;

procedure TfrmEditor.ActRunExecuteExecute(Sender: TObject);
begin
  if FDebugger.InDebugSession then
  begin
    if FDebugger.InDebugPause then
      Continue;
  end
  else begin
    if CheckCompiled then
    begin
      Execute;
      UpdateErrorMessages;
    end;
  end;
end;

procedure TfrmEditor.ActRunStepIntoExecute(Sender: TObject);
begin
  if CheckCompiled then
    StepInto;
end;

procedure TfrmEditor.ActRunStepOverExecute(Sender: TObject);
begin
  if CheckCompiled then
    StepOver;
end;

procedure TfrmEditor.ActRunRunToCursorExecute(Sender: TObject);
begin
  if CheckCompiled then
    RunToLine(SynEdit.CaretY);
end;

procedure TfrmEditor.ActRunRunUntilReturnExecute(Sender: TObject);
begin
  if CheckCompiled then
    RunUntilReturn;
end;

procedure TfrmEditor.ActRunShowExecutionPointExecute(Sender: TObject);
begin
  if FCurrentLine > 0 then
    SynEdit.CaretXY := Point(1, FCurrentLine);
end;

procedure TfrmEditor.ActRunProgramPauseExecute(Sender: TObject);
begin
  StatusInfo('Pausing...');
  Pause;
end;

procedure TfrmEditor.ActRunToggleBreakpointExecute(Sender: TObject);
begin
  FDebugger.ToggleBreakpoint(SynEdit.CaretY);
  SynEdit.InvalidateLine(SynEdit.CaretY);
end;

procedure TfrmEditor.ActRunClearAllBreakpointsExecute(Sender: TObject);
begin
  FDebugger.ClearAllBreakpoints;
  SynEdit.Invalidate;
end;

procedure TfrmEditor.ActRunEvaluateExecute(Sender: TObject);
var
  s: string;
begin
  frmEditorEvaluate.Debugger := FDebugger;
  frmEditorEvaluate.Show;

  // Try selected text
  s := Trim(SynEdit.SelText);
  if s = '' then
    // If there isn't, try word at cursor
    s := Trim(SynEdit.WordAtCursor);

  frmEditorEvaluate.Expression := s;
end;

procedure TfrmEditor.ActRunCallStackExecute(Sender: TObject);
begin
  UpdateCallStack;
  frmEditorCallStack.Caller := Self;
  frmEditorCallStack.Show;
end;

procedure TfrmEditor.ActFileSaveUpdate(Sender: TObject);
begin
  (sender as TAction).enabled := {(FScriptName <> '') and }(eoAllowSave in FOptions);
end;

procedure TfrmEditor.ActFileNewUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (eoAllowNew in FOptions);
end;

procedure TfrmEditor.ActFileOpenUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (eoAllowOpen in FOptions);
end;

procedure TfrmEditor.ActFileSaveAsUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (eoAllowSaveAs in FOptions);
end;

procedure TfrmEditor.ActRunExecuteUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunStepIntoUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunStepOverUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunRunToCursorUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunRunUntilReturnUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunShowExecutionPointUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunProgramPauseUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not FDebugger.InDebugSession) or FDebugger.InDebugPause;
end;

procedure TfrmEditor.ActRunProgramResetUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FDebugger.InDebugSession;
end;

procedure TfrmEditor.ActRunEvaluateUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (FDebugger.InDebugSession) and (FDebugger.InDebugPause);
end;

procedure TfrmEditor.ActRunCallStackUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (FDebugger.InDebugSession) and (FDebugger.InDebugPause);
end;

procedure TfrmEditor.ActRunOutputUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (FProgram <> nil) and (FProgram.Result <> nil);
end;

procedure TfrmEditor.SynEditGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
begin
  if Line > 0 then                // Could be -1
  begin
    FDebugger.ToggleBreakpoint(Line);
    SynEdit.InvalidateLine(Line);
  end;
end;

procedure TfrmEditor.SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
begin
  if ASearch = AReplace then
    Action := raSkip
  else
  begin
    APos := Point(Column, Line);
    APos := SynEdit.ClientToScreen(SynEdit.RowColumnToPixels(APos));
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

    if frmEditorConfirmReplace = nil then
      frmEditorConfirmReplace := TfrmEditorConfirmReplace.Create(Application);

    frmEditorConfirmReplace.PrepareShow(EditRect, APos.X, APos.Y, APos.Y + SynEdit.LineHeight, ASearch);

    case frmEditorConfirmReplace.ShowModal of
      mrYes:      Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo:       Action := raSkip;
    else
      Action := raCancel;
    end;
  end;
end;

procedure TfrmEditor.SynEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  if Line = FCurrentLine then
  begin
    Special := True;
    FG := clWhite;
    BG := clBlue;
  end
  else if Line = FHighlightLine then
  begin
    Special := True;
    FG := clWhite;
    BG := clMaroon;
  end
  else if FDebugger.BreakPoint[Line] then
  begin
    Special := True;
    FG := clWhite;
    BG := clRed;
  end;
end;

procedure TfrmEditor.SynEditStatusChange(Sender: TObject; Changes: TSynStatusChanges);
const
  ArrModified: array[Boolean] of string = ('', 'Modified');
var
  CursorPos: TPoint;
begin
  CursorPos := SynEdit.CaretXY;
  StatusBar.Panels.Items[0].Text := Format('%6d:%3d', [CursorPos.Y, CursorPos.X]);
  StatusBar.Panels.Items[1].Text := ArrModified[SynEdit.Modified];

  if SynEdit.ReadOnly then
    StatusBar.Panels.Items[2].Text := 'Read only'
  else if SynEdit.InsertMode then
    StatusBar.Panels.Items[2].Text := 'Insert'
  else
    StatusBar.Panels.Items[2].Text := 'Overwrite';

  // Clear current highlight (when cursor moves)
  HighlightLine(0, 0);
end;

procedure TfrmEditor.SBCloseMessagesClick(Sender: TObject);
begin
  ActViewMessages.Execute;
end;

procedure TfrmEditor.ListBoxCompilerMessagesClick(Sender: TObject);
var
  Msg: Tdws2Msg;
begin
  if ListBoxCompilerMessages.ItemIndex > -1 then
  begin
    Msg := ListBoxCompilerMessages.Items.Objects[ListBoxCompilerMessages.ItemIndex] as Tdws2Msg;
    HighlightMsg(Msg);
  end;
end;

procedure TfrmEditor.HighlightMsg(Msg: Tdws2Msg);
begin
  // If is a position message, highlight the line
  if Msg is TScriptMsg then
    with Msg as TScriptMsg do
    begin
      HighlightLine(Pos.Col, Pos.Line);
      SynEdit.SetFocus;
    end;
end;

procedure TfrmEditor.ActRunProgramResetExecute(Sender: TObject);
begin
  reset;
  CurrentLine := 0;
  UpdateErrorMessages;
  UpdateOutput('');
end;

procedure TfrmEditor.UpdateErrorMessages;
var
  ScriptMsg: TScriptMsg;
  i: integer;
begin
  // Fill compiler messages list
  ScriptMsg := nil;

  try
    ListBoxCompilerMessages.Items.BeginUpdate;
    try
      ListBoxCompilerMessages.Items.Clear;
      if Assigned(FProgram) then
      begin
        for i := 0 to FProgram.Msgs.Count - 1 do
        begin
          ListBoxCompilerMessages.Items.AddObject(FProgram.Msgs[i].AsInfo, FProgram.Msgs[i]);
          if (ScriptMsg = nil) and (FProgram.Msgs[i] is TScriptMsg) then
            ScriptMsg := (FProgram.Msgs[i] as TScriptMsg);
        end;
        // Highlight line of first message with line information (TScriptMsg)
        if ScriptMsg <> nil then
          HighlightLine(ScriptMsg.Pos.Col, ScriptMsg.Pos.Line);
      end;

    finally
      ListBoxCompilerMessages.Items.EndUpdate;
      // If there is any message, show compiler messages
      if ListBoxCompilerMessages.Items.Count > 0 then begin
        ShowMessages := True;
        PCMessages.ActivePage := TSCompiler;
      end;
    end;
  except
  end;
end;

// ToolTip Insight
procedure TfrmEditor.SynEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
//var
//  Expression, appVal: string;
////s: TSymbol;
//  sym: TSymbol;
//  PosXY: TPoint;
begin
  // Reset the hint timer when the mouse moves
  synSymbolHint.DeactivateTimer;
  synSymbolHint.ActivateTimer(Sender as TCustomSynEdit);
  { TODO -oMark : Finish this for debug usage. }
//
//  SynEdit.Hint := '';
//  if (FDebugger.InDebugSession) and (FDebugger.InDebugPause) then
//  begin
//    { TODO : Only show hint if it is a TDataSymbol }
//    { TODO : FIX: Build SynEdit tool-tip debug value function and use that. }
//    { TODO : FIX: AV error if breakpoint set and executed with a hint evalute attempted. Locks IDE and contained app must be reset. Appears to be a thread issue. }
//    PosXY := SynEdit.WordStartEx( SynEdit.PixelsToRowColumn(Point(X, Y)) );
//    sym := FProgram.SymbolDictionary.FindSymbolAtPosition(PosXY.x, PosXY.y);
//    if Assigned(sym) and (sym is TDataSymbol) then
//    begin
//        Expression := sym.Name;
////      Expression := Trim(Synedit.GetWordAtRowCol(SynEdit.PixelsToRowColumn(Point(X, Y))));
////      if (Expression <> '') then
////      begin
//      appVal := FDebugger.evaluate(Expression);
//      // when the symbol is unknown don't show anything
//      if  (pos('UNKNOW TYPE', upperCase(appVal)) = 0) and
//          (pos('EXPRESSION EXPECTED', upperCase(appVal)) = 0) then
//      begin
//        SynEdit.Hint := Expression + ' = ' + appVal;
//        Application.ActivateHint(ClientToScreen(Point(X,Y)));
//        // PIETRO
//        // why don't show hint?
//      end;
//    end;
//  end;
end;

function TfrmEditor.CheckCompiled: boolean;
begin
//  CheckScriptModified;
//  Result := false;

  if FDebugger.InDebugSession then
    result := true
  else begin
    try
      Result := Compile;
    finally
      SynEdit.InvalidateGutter;
      UpdateErrorMessages;
    end;
  end;
  RefreshCodeExplorer;
end;

procedure TfrmEditor.MemoInputOutputChange(Sender: TObject);
begin
  ShowMessages := True;
  PCMessages.ActivePage := TSInputOutput;
end;

// -------------------------------------------------------------------------
// CBImmediateKeyPress:
// - simple parser for function call
// - it fires on pressing RETURN key
// -------------------------------------------------------------------------
procedure TfrmEditor.CBImmediateKeyPress(Sender: TObject; var Key: Char);
var
  command: string;
  procName: string;
  procParams: TArrayOfVariant;
  retVal: variant;
begin
  if Key <> #13 then
    Exit;

  // Clear Messages
  UpdateOutput('');

  if CBImmediate.Text = '' then
    Exit;

  if FDebugger.InDebugSession then
  begin      // Session in progress
    try
      if CBImmediate.Text[1] = '?' then
        command := Trim(Copy(CBImmediate.Text, 2, Length(CBImmediate.Text)-1))
      else
        command := CBImmediate.Text;
      UpdateOutput(FDebugger.Evaluate(command));
    finally
    end;
  end
  else if true then
  begin
    if (parseCommand(CBImmediate.text, procName, procParams) <> 0) then
      UpdateOutput('Errors in command text... ')
    else begin
      if (procName <> '') then
        retVal := Execute(procName, procParams);
      if not VarIsNull(retVal) then
        MemoInputOutput.Lines.add('Result: ' + varToStr(retVal));
    end;
  end;
end;

procedure TfrmEditor.AFontsExecute(Sender: TObject);
begin
  FontDialog1.Font := SynEdit.Font;
  if FontDialog1.Execute then
    SynEdit.Font := FontDialog1.Font;
end;

procedure TfrmEditor.RefreshCodeExplorer;
begin
  if not CodeExplorerTree.Visible then
    Exit;

  CompileCodeInsightProgram;

  SymbolsToDefaultDelphiTree(FInsightProgram, CodeExplorerTree);
end;

procedure TfrmEditor.CodeExplorerTreeDblClick(Sender: TObject);
var
  Node: TTreeNode;
  UsePos: TSymbolPosition;
  NewPoint: TPoint;
begin
  { Jump to that symbol location stored in data node. }
  Node := CodeExplorerTree.Selected;
  if Assigned(Node) then
  begin
    UsePos := TSymbolPosition(Node.Data);  // uses pointer to data in TProgram.SymbolDictionary
    { Focus the desired position }
    if Assigned(UsePos) then
    begin
      NewPoint.X := UsePos.ScriptPos.Col;
      NewPoint.Y := UsePos.ScriptPos.Line;
      SynEdit.CaretXY := NewPoint;
      // set the SynEdit to the active control
      ActiveControl := SynEdit;

      { Try to roughly center the new position in the window }
      SynEdit.TopLine := NewPoint.Y - (SynEdit.LinesInWindow div 2);
    end;
  end;
end;

// -----------------------------------------------------------------------
// remove 'coOptimize' when set debugMode to true.
// This is due to the fact that the code optimization throw away useful
// information
// -----------------------------------------------------------------------
procedure TfrmEditor.SetDebugMode(const Value: boolean);
begin
  if Assigned(FDWScript) And Assigned(FDWScript.Config) then
  begin
    if Value = True then
      FDWScript.Config.CompilerOptions := FDWScript.Config.CompilerOptions
        - [coOptimize]
    else
      FDWScript.Config.CompilerOptions := FDWScript.Config.CompilerOptions
        + [coOptimize];
  end;

  if FDebugMode <> Value then
    // if changed means we need to compile
    SetCompileNeeded;
  FDebugMode := Value;
end;

function TfrmEditor.Compile: boolean;
begin
  Result := False;

  if not FNeedBaseCompile and Assigned(FProgram) then
  begin
    Result := True;
    Exit;
  end;

  // Destroy current program
  Reset(true);

  // Compile new program
  FProgram := CompileWithSymbolsAndMap(FDWScript, SynEdit.Lines.Text);
  if not Assigned(FProgram) then
    raise Exception.Create('ScriptEngine: Compile failed!')
  else if (FProgram.Msgs.HasCompilerErrors) then
    CheckCompilerErrors
  else begin
    FDebugger.ScanStatements(FProgram);
    FNeedBaseCompile := False;
    Result := True;
  end;
end;

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
procedure TFrmEditor.execute;
begin
  execute('', []);
end;

function TfrmEditor.execute(const sFunctionName: string;
  const Params: array of Variant): Variant;
var
  Info: TProgramInfo;
  res: IInfo;
begin
  //result := null;
  if DebugMode then
  begin
    // Debug mode
    if FDebugger = nil then
      Exit;
    if not FDebugger.InDebugSession then
      InitThreadRunner;
    if (sFunctionName = '') then
      FDebugger.ClearProcedureName
    else
      FDebugger.SetProcedureName(sFunctionName, params);
    try
      FDebugger.Run;
      while FDebugger.InDebugSession do
        Application.ProcessMessages;
    finally
      // chech if FDebugger has finished without errors
      if not assigned(FProgram) then
        // reset ??? --> do nothing
      else if  FProgram.msgs.HasCompilerErrors or
          FProgram.msgs.HasErrors  or
          FProgram.msgs.HasExecutionErrors then
      begin
        // errors occoured
        // --> open ide and show error lines
        OpenIde;
        CurrentLine := getFirstLineError;
        UpdateErrorMessages;
        CheckForErrors;
      end
      else if (sFunctionName <> '') then
        // function call
        // --> get result value
        result := FDebugger.GetExecuteCallResult;

      FinalizeProgram;
    end;
  end
//  else if not FNeedBaseCompile or compile then
  else if compile then
  begin
    // running without debugger
    if FProgram.msgs.HasErrors then
      // ohps, internal errors...
      // call events and no execution
      CheckInternalErrors
    else begin
      if (sFunctionName = '') then
      begin
        try
          Fprogram.execute;
          CheckForErrors;
        except
          on e: exception do
          begin
            if not CheckForErrors then
              // errore non catturato da DWS2
              // --> lo catturo io...
              captureErrorMessage(e);
          end;
        end;
        finalizeProgram;
      end
      else begin
        // execute a procedure call
        FProgram.BeginProgram(false);
        if Fprogram.msgs.HasErrors then
          CheckInternalErrors
        else begin
          Info := TProgramInfo.Create(FProgram.Table, FProgram);

          // Execute Call
          try
            res := Info.Func[sFunctionName].Call(Params);
            if (Assigned(res)) And (not VarIsEmpty(res.Value)) then
              Result := res.Value;
            CheckForErrors;
          except
            on e: exception do
            begin
              if not CheckForErrors then
                // errore strano non catturato da DWS:
                // lo catturo io...
                CaptureErrorMessage(e);
            end;
          end;
          FinalizeProgram;
          Info.Free;
        end;
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------
// use this function if you need to execute a command (function) where
// it is required to do a parsing of parameters
// it an error occourred during parsin, the function raise a
// 'Compiler' error
// ----------------------------------------------------------------------
function TfrmEditor.ExecuteCommand(const commandText: string): variant;
var
  procName: string;
  procParams: TArrayOfVariant;
begin
  result := '';
  if  (commandText <> '') then
  begin
    if (parseCommand(commandText, procName, procParams) <> 0) then
      FScriptHandler.HandleError(errCompiler, 'Errors in command text...')
    else if (procName <> '') then
      result := Execute(procName, procParams);
  end;
end;


procedure TfrmEditor.continue;
begin
  if FDebugMode and FDebugger.InDebugSession then
    FDebugger.Run;
end;

procedure TfrmEditor.StepInto;
begin
  if not FDebugMode then
    Exit;
  FDebugger.StepInto;
end;

procedure TfrmEditor.StepOver;
begin
  if not FDebugMode then
    Exit;
  FDebugger.StepOver;
end;

procedure TfrmEditor.RunToLine(Line: integer);
begin
  if not FDebugMode then
    Exit;
  if not FDebugger.InDebugSession then
    InitThreadRunner;
  FDebugger.RunToLine(Line);
end;

procedure TfrmEditor.RunUntilReturn;
begin
  if not FDebugMode then
    Exit;
  FDebugger.RunUntilReturn;
end;

procedure TfrmEditor.pause;
begin
  if not FDebugMode then
    Exit;
  FDebugger.Pause;
end;

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
function TfrmEditor.CheckForErrors: boolean;
begin
  CheckInternalErrors;
  checkCompilerErrors;
  CheckRuntimeErrors;
  if not assigned(FProgram) then
    result := false
  else
    result := FProgram.Msgs.HasErrors or FProgram.msgs.HasCompilerErrors or
      FProgram.msgs.HasExecutionErrors;
end;

// --------------------------------------------------------------------
// Check internal errors
// for each errors call 'OnError' event
// --------------------------------------------------------------------
procedure TfrmEditor.CheckInternalErrors;
var
  i: integer;
  lineExpr: string;
  cLine: integer;
begin
  if assigned(FProgram) and FProgram.Msgs.HasErrors then
  begin
    for i := 0 to FProgram.Msgs.Count - 1 do
    if (FProgram.Msgs[i] is TErrorMsg) then
    begin
      cLine := getCurrentLine(FProgram.Msgs[i]);
      if (cLine = -1) then
        // no info on current line:
        lineExpr := ''
      else
        lineExpr := 'Line (' + IntToStr(cLine) +
          ') --> ' + synedit.Lines[cLine - 1] + #13#10;
      FScriptHandler.HandleError(errInternal, lineExpr + TErrorMsg(FProgram.Msgs[i]).AsInfo);
      FExecuteFailed := true;
    end;
  end;
end;
// --------------------------------------------------------------------
// Check compiler errors
// --------------------------------------------------------------------
procedure TfrmEditor.CheckCompilerErrors;
var
  i: integer;
begin
  if Assigned(FProgram) and FProgram.Msgs.HasCompilerErrors then
  begin
    for i := 0 to FProgram.Msgs.Count - 1 do
      if (FProgram.Msgs[i] is TCompilerErrorMsg)  then
        FScriptHandler.HandleError(errCompiler, TCompilerErrorMsg(FProgram.Msgs[i]).AsInfo);
  end;
end;
// --------------------------------------------------------------------
// Check runtime errors
// --------------------------------------------------------------------
procedure TfrmEditor.CheckRuntimeErrors;
var
  i: integer;
  lineExpr: string;
  cLine: integer;
begin
  if assigned(FProgram) and FProgram.Msgs.HasExecutionErrors then
  begin
    for i := 0 to FProgram.Msgs.Count - 1 do
    begin
      if (FProgram.Msgs[i] is TExecutionErrorMsg) then
      begin
        cLine := getCurrentLine(FProgram.Msgs[i]);
        if (cLine = -1) then
          // no info on current line:
          lineExpr := ''
        else
          lineExpr := 'Line (' + IntToStr(cLine) +
            ') --> ' + synedit.Lines[cLine - 1] + #13#10;
        FScriptHandler.HandleError(errRuntime, lineExpr + TExecutionErrorMsg(FProgram.Msgs[i]).AsInfo);
        FExecuteFailed := true;
      end;
    end;
  end;
end;

// --------------------------------------------------------------------
// this function is required because in some cases DWS2 does not
// capture errors
// As an example, this script raise an access violation without
// raising an exception (only in case of procedure call) because
// the 'x' string is not initialized when try to access the
// first character
//
// procedure foo;
// var x: string;
// begin
//  if(x[1] = 'a') then         // error here
//    showMessage('no error!');
// end;
// --------------------------------------------------------------------
procedure TfrmEditor.captureErrorMessage(e: Exception);
begin
  // if event handling exception is defined,
  // --> send it as runtimeError
  if not FScriptHandler.HandleError(errRuntime, e.Message) then
    // no event handling exception, so raise general exception
    raise e;
end;

procedure TfrmEditor.reset(forceRecompile: boolean = false);
begin
  if assigned(FDebugger) then
    FDebugger.reset;
  if forceRecompile then
  begin
    SetCompileNeeded;
    if Assigned(FProgram) then
      FreeAndNil(FProgram);
    if Assigned(FInsightProgram) then
      FreeAndNil(FInsightProgram);
  end;
end;

procedure TfrmEditor.InitThreadRunner;
begin

  // here we are for sure in DebugMode
  if not DebugMode then
    Exit;

  if FNeedBaseCompile or not assigned(FProgram) then
    Compile;

  if DebugMode and assigned(FProgram) then
  begin
    FProgram.Msgs.Clear;
    FDebugger.Prepare(FProgram);
  end;
end;


procedure TfrmEditor.SetScriptName(const Value: string);
begin
  FScriptName := Value;
  UpdateDialogTitle;
end;

procedure TfrmEditor.ActHelpExecute(Sender: TObject);
begin
  // show short help on line
  if not FScriptHandler.ShowHelp then
    Application.MessageBox('No help on line available', 'Help on line', 0);
end;

procedure TfrmEditor.ActAboutExecute(Sender: TObject);
begin
  if not FScriptHandler.ShowAboutBox then
    Application.MessageBox('No about information available', 'Not available', 0);
end;

// ----------------------------------------------------------------------
// parse command for immediate evaluation
// return   0     parsing ok
//          1     left parenthesis > right parenthesis
// if there are more than required right parenthesis, there are ignored
// ----------------------------------------------------------------------
function TfrmEditor.parseCommand(aStr: string; var procName: string;
  var procParams: TArrayOfVariant): byte;
var
  i, j, k, curParam: integer;
  nOpen, nClose, i1: integer;
begin
  result := 0;
  procName := '';
  curParam := 0;
  // extract procedure name (or variable name)
  i := pos('(', aStr);
  if (i = 0) then
    procName := aStr
  else begin
    procName := trim(copy(aStr, 1, i-1));
    //
    // going to extract parameters
    aStr := trim(copy(aStr, i+1, length(aStr)));
    while (aStr <> '') do
    begin
      i := pos('(', aStr);
      j := pos(')', aStr);
      k := pos(',', aStr);
      inc(curParam);
      SetLength(procParams, curParam);
      if (i > 0) and (k > i) then
      begin
        // next parameter is a function
        // take the entire string as a single parameter
        nOpen := 1;
        nClose := 0;
        i1 := i + 1;
        while (i1 < length(aStr)) and (nOpen > nClose) do
        begin
          if (aStr[i1] = '(') then
            inc(nOpen)
          else if (aStr[i1] = ')') then
            inc(nClose);
          inc(i1);
        end;
        if (nOpen > nClose) then
          result := 1
        else if (nOpen < nClose) then
        else begin
          procParams[curParam-1] := trim(copy(aStr, 1, i1));
          if (i1 = length(aStr)) then
            aStr := ''
          else
            aStr := trim(copy(aStr, i1+1, length(aStr)));
        end;
      end
      else begin
        // no parameters function
        if (k = 0) then
        begin
          // all the rest of the string is the last parameter
          if (j = 0) then
            // no close parenthesis? Very strange...
            result := 1
          else
            procParams[curParam-1] := trim(copy(aStr, 1, j-1));
          aStr := '';
        end
        else begin
          procParams[curParam-1] := trim(copy(aStr, 1, k-1));
          if (k = length(aStr)) then
            aStr := ''
          else
            aStr := trim(copy(aStr, k+1, length(aStr)));
        end;
      end;
    end;
  end;
end;

procedure TfrmEditor.finalizeProgram;
begin
  //
  // test su psReadyToInitialize is required because EndProgram
  // does not test and try to clear stack raising an error.
  if  assigned(FProgram) and
      not (FProgram.ProgramState = psReadyToRun) then
    FProgram.EndProgram;
end;

function TfrmEditor.getCurrentLine(aMsg: TDws2Msg): integer;
begin
  result := -1;
  if (DebugMode and Assigned(FDebugger)) then
    // debugger is active --> get last line evaluated
    result := FDebugger.lastExpr.pos.line
  else if (aMsg is TScriptMsg) and assigned(FProgram) then
    // try to get the line from aMsg
    result := TScriptMsg(aMsg).Pos.line;
end;

function TfrmEditor.getFirstLineError: integer;
var
  i: integer;
begin
  result := -1;
  if (result = -1) and (DebugMode and Assigned(FDebugger)) then
    // debugger is active --> get last line evaluated
    result := FDebugger.lastExpr.pos.line
  else if assigned(fProgram) then
  begin
    // try to get the line from msgs
    for i := 0 to FProgram.Msgs.Count - 1 do
    begin
      if (FProgram.Msgs[i] is TScriptMsg) then
      begin
        result := TScriptMsg(FProgram.Msgs[i]).Pos.line;
        break;
      end;
    end;
  end;
end;

function TfrmEditor.GetInDebugPause: Boolean;
begin
  Result := (FDebugger <> nil) and FDebugger.InDebugPause;
end;

function TfrmEditor.GetInDebugSession: Boolean;
begin
  Result := (FDebugger <> nil) and FDebugger.InDebugSession;
end;

procedure TfrmEditor.SetEditorReadOnly(const Value: Boolean);
begin
  FEditorReadOnly := Value;
  SynEdit.ReadOnly := FEditorReadOnly;   // set editor to ReadOnly
end;

function TfrmEditor.GetShortScriptName: string;
begin
  if FLoadedScriptIsFileName then
    Result := ExtractFileName(FScriptName)
  else
    Result := FScriptName;
end;

procedure TfrmEditor.SynEditChange(Sender: TObject);
begin
  SetCompileNeeded;
end;

procedure TfrmEditor.PrepareIDE;
begin
  // fetch the settings
  FOptions := FOptionSetter.GetOptions;
  pCodeExplorer.Align := FOptionSetter.GetCodeExplorerAlignment;
  FDWScript := FScriptHandler.GetDWScript;
  FScriptHandler.FetchInitialScript(SynEdit.Lines);
  SetCompileNeeded;

  // apply settings
  SynEdit.Gutter.ShowLineNumbers := eoShowLineNumbers in FOptions;
  EditorReadOnly := eoReadOnly in FOptions;
  ActHelp.Enabled := eoShowHelpMenu in FOptions;
  ActHelp.Visible := ActHelp.Enabled;
  ActAbout.Enabled := eoShowAboutMenu in FOptions;
  ActAbout.Visible := ActAbout.Enabled;
  miHelp.Visible := ActHelp.Visible and ActAbout.Visible; // only display Help menu if has sub-items

  with FOptionSetter.GetTimerSettings do
  begin
    synCodeProposal.TimerInterval := CodeProposal;
    synParamProposal.TimerInterval := ParamProposal;
    synSymbolHint.TimerInterval := HintProposal;
  end;

  CurrentLine := 0;   // clear any selected lines for current execution

  InitializeCodeInsight;
end;

procedure TfrmEditor.ActCompleteAllClassesExecute(Sender: TObject);
begin
  // internally compiles the script
  CompleteAllClasses(FDWScript, SynEdit.Lines);
  CheckCompiled;     // recompile the script and display any errors
end;

procedure TfrmEditor.ActCompleteClassAtCursorExecute(Sender: TObject);
begin
  Compile;           // compile first (don't report errors)
  CompleteClassAtCursor(FDWScript, FProgram, SynEdit.CaretY, SynEdit.CaretX, SynEdit.Lines);
  CheckCompiled;     // recompile the script and display any errors
end;

procedure TfrmEditor.CodeExplorerTreeKeyPress(Sender: TObject;
  var Key: Char);
begin
  { Treat user hitting 'return' as a double-click }
  if Key = #13 then
  begin
    CodeExplorerTreeDblClick(nil);
    Key := #0;      // set it as handled
  end;
end;

procedure TfrmEditor.ActToggleImplDeclPosExecute(Sender: TObject);
begin
  ToggleFromDecl2Impl(SynEdit, FProgram);
end;

procedure TfrmEditor.SetTitle(const Value: string);
begin
  FTitle := Value;
  UpdateDialogTitle;
end;

procedure TfrmEditor.UpdateDialogTitle;
var
  ShortName: string;
begin
  { Set form caption to show desired text }
  ShortName := GetShortScriptName;
  if ShortName = '' then
    Self.Caption := FTitle
  else
    Self.Caption := GetShortScriptName + ' - ' + FTitle;
end;

procedure TfrmEditor.BuildUnitLists;
var
  Prg: TProgram;
  DispOpts: TdSyn_DisplayOptions;
begin
  // set to default
  DispOpts := [doSynStyle];
  if eoShowCodeInsightIcons in FOptions then  // if graphics used,
    Include(DispOpts, doIncludeImage);        // add the graphics

  { Internally compile an empty script. Build a list of all base symbols that
    are available to the script. Re-use this symbol list so it doesn't get
    rebuilt with each use. The list of items available to the script will not
    change during script execution or usage. These are compiled into the
    application so we only need to process them once.}
  Prg := CompileWithSymbolsAndMap(FDWScript, ''); // use NO script. Just want things available outside of script.   SynEdit1.Lines.Text);
  try
    LoadUnitDeclaredSymbols(Prg, FUnitItemLists, FUnitInserts, DispOpts,
                            [{coIncludeContext, coIncludeUnit}], True);
  finally
    Prg.Free;
  end;
end;

procedure TfrmEditor.ProposalExecute(Kind: SynCompletionType;
  Sender: TObject; var CurrentInput: String; var x, y: Integer;
  var CanExecute: Boolean);
var
  prog: TProgram;
begin
  CompileCodeInsightProgram;

  case Kind of
  ctCode :
    begin
      // use the compiled program to fetch out the symbols in the script. Re-use
      // the symbols from the FUnitXXX lists.
      CanExecute := PerformCodeCompletion(SynEdit, FInsightProgram,
                                          TSynCompletionProposal(Sender),
                                          FUnitItemLists, FUnitInserts, x, y,
                                          eoShowCodeInsightIcons in FOptions,
                                          eoShowPropertyAccessors in FOptions);
    end;
  ctParams :
    begin
      CanExecute := PerformParamProposal(SynEdit, FInsightProgram,
                                         TSynCompletionProposal(Sender), x, y);
    end;
  ctHint :
    begin
      if Assigned(FProgram) and FProgram.IsDebugging then
        prog := FProgram
      else
        prog := FInsightProgram;

      CanExecute := PerformHintProposal(SynEdit, prog,
                                        TSynCompletionProposal(Sender), x, y,
                                        eoShowCodeInsightIcons in FOptions);
    end;
  end;
end;

procedure TfrmEditor.CompileCodeInsightProgram;
begin
  // if the script is modified in some way, recompile it
  if FNeedInsightCompile then
  begin
    // free the previously compiled program
    FreeAndNil(FInsightProgram);
    // recompile the script
    FInsightProgram := CompileWithSymbolsAndMap(FDWScript, SynEdit.Lines.Text);
    FNeedInsightCompile := False;
    // Must reset the code explorer because the position objects become invalid
    // if they get out of synch with the program.
    RefreshCodeExplorer;
  end;
end;

procedure TfrmEditor.InitializeCodeInsight;
begin
  { Clear all columns }
  synCodeProposal.Columns.Clear;
  { Want graphics, add column for that spacing }
  if eoShowCodeInsightIcons in FOptions then
  begin
    with synCodeProposal.Columns.Add do
      BiggestWord := 'ww';
  end;
  { Always add back this column }
  with synCodeProposal.Columns.Add do
    BiggestWord := 'constructor';

  { TODO -oMark : Determine how to handle graphics for IDE... make them external? link to an image list? }

  { Rebuild the Unit lists to reflect graphics choice }
  BuildUnitLists;
end;

procedure TfrmEditor.SetCompileNeeded;
begin
  FNeedBaseCompile := True;
  FNeedInsightCompile := True;
  // reset the time if user is typing continously. 
  tInsightCompileTimer.Enabled := False;
  tInsightCompileTimer.Enabled := True;
end;

procedure TfrmEditor.tInsightCompileTimerTimer(Sender: TObject);
begin
  { After the script has been modified compile the FInsightProgram to keep the
    CodeBrowserTree current. Otherwise it gets left blank until some CodeInsight
    feature is explicitly invoked. }
  tInsightCompileTimer.Enabled := False;
  CompileCodeInsightProgram;  // will auto-update the tree
end;

end.

