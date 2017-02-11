{$I dws2.inc}

unit Main;

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF NEWVARIANTS}
  Variants,
  {$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, dws2IdeDialog, SynEditHighlighter, SynHighlighterPas, dws2Comp,
  dws2Exprs, StdCtrls, Buttons, dws2VCLGUIFunctions, dwsIDETypes;

type
  TDemoFrm = class(TForm)
    DelphiWebScriptII1: TDelphiWebScriptII;
    dws2Unit1: Tdws2Unit;
    SynPasSyn1: TSynPasSyn;
    CBDebugMode: TCheckBox;
    Memo: TMemo;
    BAddLine: TButton;
    BGetLinesCount: TButton;
    BClearLines: TButton;
    GroupBox1: TGroupBox;
    ELine: TEdit;
    OpenDialog: TOpenDialog;
    EScriptFile: TEdit;
    Label1: TLabel;
    SBLoadScript: TSpeedButton;
    BOpenIDE: TButton;
    Label2: TLabel;
    BTrapError: TButton;
    Label3: TLabel;
    ELaunchProc: TEdit;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    btnDebugSession: TButton;
    btnDebugPause: TButton;
    btnSoftReset: TButton;
    btnHardReset: TButton;
    btnExecProgram: TButton;
    Label5: TLabel;
    SaveDialog: TSaveDialog;
    dws2IdeDialog: Tdws2IdeDialog;
    procedure dws2IdeDialogError(Sender: TObject; ErrType: TErrType; ErrString: String);
    procedure dws2IdeDialogScriptSaved(Sender: TObject; Script: TStrings);
    procedure CBDebugModeClick(Sender: TObject);
    procedure dws2Unit1FunctionsAddLineEval(Info: TProgramInfo);
    procedure dws2Unit1FunctionsGetLinesCountEval(Info: TProgramInfo);
    procedure dws2Unit1FunctionsClearLinesEval(Info: TProgramInfo);
    procedure BAddLineClick(Sender: TObject);
    procedure BGetLinesCountClick(Sender: TObject);
    procedure BClearLinesClick(Sender: TObject);
    procedure SBLoadScriptClick(Sender: TObject);
    procedure BOpenIDEClick(Sender: TObject);
    procedure BTrapErrorClick(Sender: TObject);
    procedure ELaunchProcKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDebugSessionClick(Sender: TObject);
    procedure btnDebugPauseClick(Sender: TObject);
    procedure dws2IdeDialogEditorClose(Sender: TObject;
      var CanClose: Boolean);
    procedure btnSoftResetClick(Sender: TObject);
    procedure btnHardResetClick(Sender: TObject);
    procedure btnExecProgramClick(Sender: TObject);
    procedure dws2IdeDialogLoadScript(Sender: TObject;
      var ScriptName: String; const AScript: TStrings; var AReadOnly,
      IsAFileName, WasLoaded: Boolean);
    procedure dws2IdeDialogSaveScript(Sender: TObject;
      const ScriptName: String; const AScript: TStrings);
    procedure dws2IdeDialogSaveAsScript(Sender: TObject;
      var ScriptName: String; const AScript: TStrings;
      var WasSaved: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DemoFrm: TDemoFrm;

implementation

{$R *.dfm}

uses uDmClasses;

//*******************************************************************
// dws2Unit Functions
//*******************************************************************

procedure TDemoFrm.dws2Unit1FunctionsAddLineEval(Info: TProgramInfo);
begin
  Memo.Lines.Add(Info['Line']);
end;

procedure TDemoFrm.dws2Unit1FunctionsGetLinesCountEval(Info: TProgramInfo);
begin
  Info['Result'] := Memo.Lines.Count;
end;

procedure TDemoFrm.dws2Unit1FunctionsClearLinesEval(Info: TProgramInfo);
begin
  Memo.Clear;
end;

//*******************************************************************
// dws2IdeDialog Events
//*******************************************************************

procedure TDemoFrm.dws2IdeDialogError(Sender: TObject; ErrType: TErrType; ErrString: String);
begin
//  case ErrType of
//    errCompiler:
//        ShowMessage('Syntax Error: ' + ErrString);
//    errRuntime:
//        ShowMessage('RunTime Error: ' + ErrString);
//    errInternal:
//        ShowMessage('Internal Error: ' + ErrString);
//  end;
end;

procedure TDemoFrm.dws2IdeDialogScriptSaved(Sender: TObject; Script: TStrings);
begin
  ShowMessage(Format('The Script has been saved (%d lines).', [Script.Count]));
end;


//*******************************************************************
// Form Events
//*******************************************************************

procedure TDemoFrm.CBDebugModeClick(Sender: TObject);
begin
  dws2IdeDialog.DebugMode := CBDebugMode.Checked;
end;

procedure TDemoFrm.BAddLineClick(Sender: TObject);
begin
  dws2IdeDialog.Execute('AddLine', [ELine.Text]);
end;

procedure TDemoFrm.BGetLinesCountClick(Sender: TObject);
begin
  ShowMessage(VarToStr(dws2IdeDialog.Execute('GetLinesCount')));
end;

procedure TDemoFrm.BClearLinesClick(Sender: TObject);
begin
  dws2IdeDialog.Execute('ClearLines');
end;

procedure TDemoFrm.SBLoadScriptClick(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    EScriptFile.Text := OpenDialog.FileName;
    dws2IdeDialog.Script.LoadFromFile(EScriptFile.Text);
    ShowMessage(Format('Script %s loaded succesfully', [EScriptFile.Text]));
  end;
end;

procedure TDemoFrm.BOpenIDEClick(Sender: TObject);
begin
  dws2IdeDialog.OpenIDE;
end;

procedure TDemoFrm.BTrapErrorClick(Sender: TObject);
begin
  CBDebugMode.Checked := True;
  {$IFDEF NEWDESIGN}
  EScriptFile.Text := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                      'Scripts\BubbleSortErr.dws';
  {$ELSE} // D5 way
  EScriptFile.Text := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) +
                      'Scripts\BubbleSortErr.dws';
  {$ENDIF}
  dws2IdeDialog.Script.LoadFromFile(EScriptFile.Text);
  try
    dws2IdeDialog.Execute('DoBubbleSort');
  except
    On E:Exception do
      ShowMessage('Exception raised by Execute.' + #13#10 + E.Message);
  end;
end;

procedure TDemoFrm.ELaunchProcKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  try
    dws2IdeDialog.ExecuteCommand(ELaunchProc.Text);
  except
    On E: Exception do
      ShowMessage('Exception raised by Execute.' + #13#10 + E.Message);
  end;
end;

procedure TDemoFrm.Button1Click(Sender: TObject);
begin
  dmClasses.dwsClasses.Script := DelphiWebScriptII1;
end;

procedure TDemoFrm.Button2Click(Sender: TObject);
begin
  dmClasses.dwsClasses.Script := nil;
end;

procedure TDemoFrm.FormShow(Sender: TObject);
begin
  caption := caption + ' - IDE Release ' + dws2IdeDialog.Version;
end;

procedure TDemoFrm.btnDebugSessionClick(Sender: TObject);
begin
  if dws2IdeDialog.InDebugSession then
    ShowMessage('Yes, I am working...')
  else
    ShowMessage('Idle');
end;

procedure TDemoFrm.btnDebugPauseClick(Sender: TObject);
begin
  if dws2IdeDialog.InDebugPause then
    ShowMessage('Yes, debug pause')
  else
    ShowMessage('No pause');
end;

procedure TDemoFrm.dws2IdeDialogEditorClose(Sender: TObject;
  var CanClose: Boolean);
begin
//  showMessage('Closing editor...');
end;

procedure TDemoFrm.btnSoftResetClick(Sender: TObject);
begin
  dws2IdeDialog.reset;
end;

procedure TDemoFrm.btnHardResetClick(Sender: TObject);
begin
  dws2IdeDialog.reset(true);
end;

procedure TDemoFrm.btnExecProgramClick(Sender: TObject);
begin
  dws2IdeDialog.Execute;
end;

procedure TDemoFrm.dws2IdeDialogLoadScript(Sender: TObject;
  var ScriptName: String; const AScript: TStrings; var AReadOnly,
  IsAFileName, WasLoaded: Boolean);
begin
  { Load a script with a prompt to the user }
  IsAFileName := True;
  if OpenDialog.Execute then
  begin
    ScriptName := OpenDialog.FileName;
    AScript.LoadFromFile(ScriptName);
    WasLoaded := True;
  end;
end;

procedure TDemoFrm.dws2IdeDialogSaveScript(Sender: TObject;
  const ScriptName: String; const AScript: TStrings);
begin
  { Just save the script - no prompting needed }
  AScript.SaveToFile(ScriptName);
end;

procedure TDemoFrm.dws2IdeDialogSaveAsScript(Sender: TObject;
  var ScriptName: String; const AScript: TStrings; var WasSaved: Boolean);
begin
  { Save the script with a prompt to the user }
  WasSaved := False;
  SaveDialog.FileName := ScriptName;    // default with existing name
  if SaveDialog.Execute then
  begin
    AScript.SaveToFile(SaveDialog.FileName);
    // if made it here, successful
    WasSaved := True;
    ScriptName := SaveDialog.FileName;  // store new name
  end;
end;

end.

