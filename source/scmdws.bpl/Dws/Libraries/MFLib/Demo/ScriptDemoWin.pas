unit ScriptDemoWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, Menus, ComCtrls, ExtCtrls, Db, DBTables,
  dws2Comp, dws2Exprs, dws2Symbols, dws2Errors,  dws2Debugger,
  dws2Compiler, dws2HtmlAdapter, dws2ComConnector, dws2FileFunctions,
  dws2VCLGUIFunctions, dws2MFZipLibModule, dws2MFLibModule,
  dws2ClassesLibModule, dws2GlobalVarsFunctions;

type
  TfrmScriptDemo = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    NewItem: TMenuItem;
    OpenItem: TMenuItem;
    SaveItem: TMenuItem;
    ExitItem: TMenuItem;
    N1: TMenuItem;
    ScriptMenu: TMenuItem;
    CompileItem: TMenuItem;
    ExecuteItem: TMenuItem;
    DemosMenu: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    HelpMenu: TMenuItem;
    SaveAsItem: TMenuItem;
    Panel2: TPanel;
    N5: TMenuItem;
    AboutItem: TMenuItem;
    HomepageItem: TMenuItem;
    Panel3: TPanel;
    lbLog: TListBox;
    lbMsgs: TListBox;
    memoResult: TRichEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    DebuggerMenu: TMenuItem;
    StopItem: TMenuItem;
    DebuggerNoneItem: TMenuItem;
    DebuggerSimpleItem: TMenuItem;
    SimpleDebugger: Tdws2SimpleDebugger;
    DebuggerRemoteItem: TMenuItem;
    script: TDelphiWebScriptII;
    memoSource: TRichEdit;
    N2: TMenuItem;
    StepItem: TMenuItem;
    N3: TMenuItem;
    OptionOptimizationItem: TMenuItem;
    ManualItem: TMenuItem;
    dws2GUIFunctions: Tdws2GUIFunctions;
    dws2FileFunctions: Tdws2FileFunctions;
    dws2GlobalVarsFunctions: Tdws2GlobalVarsFunctions;
    dws2ClassesLib: Tdws2ClassesLib;
    dws2MFLib: Tdws2MFLib;
    dws2MFZipLib: Tdws2MFZipLib;
    procedure NewItemClick(Sender: TObject);
    procedure CompileItemClick(Sender: TObject);
    procedure ExecuteItemClick(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure OpenItemClick(Sender: TObject);
    procedure SaveAsItemClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AboutItemClick(Sender: TObject);
    procedure memoSourceChange(Sender: TObject);
    procedure DemosMenuClick(Sender: TObject);
    procedure HomepageItemClick(Sender: TObject);
    procedure lbMsgsDblClick(Sender: TObject);
    procedure lbMsgsClick(Sender: TObject);
    procedure SimpleDebuggerDoDebug(Prog: TProgram; Expr: TExpr);
    procedure StopItemClick(Sender: TObject);
    procedure DebuggerNoneItemClick(Sender: TObject);
    procedure DebuggerSimpleItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DebuggerRemoteItemClick(Sender: TObject);
    procedure StepItemClick(Sender: TObject);
    procedure CompilerOptionClick(Sender: TObject);
    procedure ManualItemClick(Sender: TObject);
  private
    NextStep: Boolean;
    ErrorLine: Integer;
    ActiveMsg: Tdws2Msg;
    Prg: TProgram;
    ScriptChanged: Boolean;
    ScrFile: string;
    procedure OpenScript(sname: string);
    procedure CreateDemosMenu;
    procedure ShowMsg(Msg: Tdws2Msg);
    procedure ShowFirstMsg;
    procedure UpdateSyntax;
  public
    ProgPath: string;
    ScriptPath: string;
    DocuPath: string;
    CounterFrequency: Int64;
  end;

var
  frmScriptDemo: TfrmScriptDemo;

implementation

uses
  ShellApi, ScriptDemoTest, mwPasToRtf;

{$R *.DFM}

procedure TfrmScriptDemo.FormCreate(Sender: TObject);
begin
  ProgPath := ExtractFilePath(Application.ExeName);
  ScriptPath := progpath + '..\scripts\';
  DocuPath := progpath + '..\docs\';

  ScriptChanged := True;
  ErrorLine := -1;

  DemosMenu.OnClick := nil;
  CreateDemosMenu;

  QueryPerformanceFrequency(CounterFrequency);
  if CounterFrequency = 0 then
    CounterFrequency := 1; // To avoid divbyzero's

  OpenScript('test.dws');
end;

procedure TfrmScriptDemo.FormDestroy(Sender: TObject);
begin
  Prg.Free;
end;

procedure TfrmScriptDemo.CreateDemosMenu;
var
  mi: TMenuItem;
  sr: TSearchRec;
  res: Integer;
begin
  res := FindFirst(ScriptPath + '*.dws', faAnyFile, sr);

  while res = 0 do
  begin
    mi := TMenuItem.Create(MainMenu);
    mi.Caption := sr.Name;
    mi.OnClick := DemosMenuClick;
    DemosMenu.Add(mi);
    res := FindNext(sr);
  end;

  FindClose(sr);
end;

procedure TfrmScriptDemo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  NewItemClick(Sender);
  CanClose := not memoSource.Modified;
end;

procedure TfrmScriptDemo.NewItemClick(Sender: TObject);
var
  res: Integer;
begin
  if memoSource.Modified then
  begin
    res := MessageDlg('There are unsaved changes! Do you want to save now?',
      mtInformation, [mbYes, mbNo, mbCancel], 0);
    if res = mrCancel then exit;
    if res = mrYes then SaveItemClick(self);
  end;
  ScrFile := '';
  memoSource.Clear;
  memoSource.Modified := false;
  ScriptChanged := True;
  Caption := 'DWS Demo';

  frmScriptDemo.ActiveControl := memoSource;
end;

procedure TfrmScriptDemo.OpenItemClick(Sender: TObject);
begin
  OpenDialog.InitialDir := scriptpath;
  if OpenDialog.Execute then
  begin
    NewItemClick(sender);
    if memoSource.Modified then exit;
    memoSource.Clear;
    ScrFile := OpenDialog.FileName;
    Caption := 'DWS Demo - ' + scrfile;
    memoSource.Lines.LoadFromFile(OpenDialog.FileName);
    ScriptChanged := true;
    memoSource.Modified := false;
  end;
end;

procedure TfrmScriptDemo.SaveItemClick(Sender: TObject);
begin
  if scrfile = '' then
    SaveAsItemClick(Sender)
  else
  begin
    memoSource.Lines.SaveToFile(scrfile);
    memoSource.Modified := false;
  end;
end;

procedure TfrmScriptDemo.SaveAsItemClick(Sender: TObject);
begin
  SaveDialog.InitialDir := scriptpath;
  if SaveDialog.Execute then
  begin
    scrfile := SaveDialog.FileName;
    Caption := 'DWS Demo - ' + scrfile;
    memoSource.Lines.SaveToFile(scrfile);
  end;
end;

procedure TfrmScriptDemo.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmScriptDemo.CompileItemClick(Sender: TObject);
var
  x: Integer;
  tStart, tStop: Int64;
begin
  // Assigns the script code in the memo to the script component
  ScriptChanged := False;
  ActiveMsg := nil;
  lbMsgs.Clear;
  lbLog.Clear;

  // Compiles the script
  try
    Prg.Free;
  finally
    Prg := nil;
  end;

  QueryPerformanceCounter(tStart);
  
  ErrorLine := -1;

  Script.Config.CompilerOptions := [];
  if OptionOptimizationItem.Checked then
    Script.Config.CompilerOptions := Script.Config.CompilerOptions + [coOptimize];

  Prg := Script.Compile(memoSource.Lines.Text);

  QueryPerformanceCounter(tStop);

  lbLog.Items.Add(Format('*** Compiled in %.3f ms', [1000 * (tStop - tStart) / (CounterFrequency)]));

  for x := 0 to Prg.Msgs.Count - 1 do
    lbMsgs.Items.AddObject(Prg.Msgs[x].AsInfo, Prg.Msgs[x]);
  lbMsgs.Visible := lbMsgs.Items.Count > 0;
  Splitter1.Visible := lbMsgs.Items.Count > 0;
  ShowFirstMsg;
end;


procedure TfrmScriptDemo.ExecuteItemClick(Sender: TObject);
var
  x: Integer;
  tStart, tStop: Int64;
begin
  if ScriptChanged then CompileItemClick(Sender);
  if not Assigned(Prg) then CompileItemClick(Sender);

  if not Assigned(Prg) then exit;

  // Set debugger
  if DebuggerSimpleItem.Checked then
    Prg.Debugger := SimpleDebugger
  else if DebuggerRemoteItem.Checked then
    Prg.Debugger := nil //RemoteDebugger
  else
    Prg.Debugger := nil;

  lbLog.Items.Add('*** Executing...  press [ESC] to stop');

  QueryPerformanceCounter(tStart);

  Prg.Execute;

  QueryPerformanceCounter(tStop);

  lbLog.Items.Add(Format('*** Executed. [%.3f s]', [(tStop - tStart) / CounterFrequency]));

  memoResult.Text := Prg.Result.AsString;

  // Display messages
  lbMsgs.Items.Clear;
  for x := 0 to Prg.Msgs.Count - 1 do
    lbMsgs.Items.AddObject(Prg.Msgs[x].AsInfo, Prg.Msgs[x]);

  lbMsgs.Visible := lbMsgs.Items.Count > 0;
  Splitter1.Visible := lbMsgs.Items.Count > 0;
end;

procedure TfrmScriptDemo.StopItemClick(Sender: TObject);
begin
  if Assigned(Prg) then
    Prg.Stop;
end;

procedure TfrmScriptDemo.StepItemClick(Sender: TObject);
begin
  NextStep := True;
end;

procedure TfrmScriptDemo.CompilerOptionClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  ScriptChanged := True;
end;

procedure TfrmScriptDemo.DebuggerNoneItemClick(Sender: TObject);
begin
  DebuggerNoneItem.Checked := True;
end;

procedure TfrmScriptDemo.DebuggerSimpleItemClick(Sender: TObject);
begin
  DebuggerSimpleItem.Checked := True;
end;

procedure TfrmScriptDemo.DebuggerRemoteItemClick(Sender: TObject);
begin
  DebuggerRemoteItem.Checked := True;
  ShowMessage('Download and install the remote debugger from the DWSC homepage first!');
end;

procedure TfrmScriptDemo.DemosMenuClick(Sender: TObject);
begin
  OpenScript(StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]));
end;

procedure OpenFile(const FileName: string);
begin
  if ShellExecute(Application.MainForm.Handle, 'open', PChar(FileName), nil, nil, SW_SHOW) <= 32 then
    ShowMessage('"' + Filename + '" not found');
end;

procedure TfrmScriptDemo.ManualItemClick(Sender: TObject);
begin
  OpenFile(DocuPath + 'dws2Manual.html');
end;

procedure TfrmScriptDemo.HomepageItemClick(Sender: TObject);
begin
  OpenFile('http://www.dwscript.com');
end;

procedure TfrmScriptDemo.AboutItemClick(Sender: TObject);
begin
  ShowMessage('Demonstration program for DelphiWebScript II ' + Script.Version);
end;

procedure TfrmScriptDemo.OpenScript;
begin
  NewItemClick(nil);
  memoSource.Lines.LoadFromFile(scriptpath + sname); // Since we don't want RTF..
  ScriptChanged := True;
  memoSource.Modified := false;
  scrfile := scriptpath + sname;
  Caption := 'DWS Demo - ' + scrfile;
end;

procedure TfrmScriptDemo.memoSourceChange(Sender: TObject);
begin
  ScriptChanged := True;
  UpdateSyntax;
end;

procedure TfrmScriptDemo.UpdateSyntax;
var
  TempMS: TMemoryStream;
  PasCon: TPasConversion;
  pos, top: Integer;
  OnChange: TNotifyEvent;
begin
  if (Length(memoSource.Text) <= 0) then
    exit;

  pos := memoSource.selstart;
  top := SendMessage(memoSource.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  OnChange := memoSource.OnChange;
  TempMS := TMemoryStream.Create;
  try
    memoSource.Lines.SaveToStream(TempMS);
    memoSource.OnChange := nil;
    PasCon := TPasConversion.Create;
    try
      try
        PasCon.UseDelphiHighlighting(progpath + 'ScriptDemo.ini');
        PasCon.LoadFromStream(TempMS);
        PasCon.ConvertReadStream;
        memoSource.PlainText := False;
        memoSource.Lines.BeginUpdate;
        memoSource.Lines.LoadFromStream(PasCon);
        SendMessage(memoSource.Handle, EM_LINESCROLL, 0, top);
        memoSource.Lines.EndUpdate;
      finally
        memoSource.PlainText := True;
        PasCon.Free;
      end;
    except
      // Remove highlighting
      TempMS.Position := 0;
      memoSource.SelAttributes := memoSource.DefAttributes;
      memoSource.Lines.LoadFromStream(TempMS);
    end;
  finally
    memoSource.SelStart := Pos;
    TempMS.Free;
    memoSource.OnChange := OnChange;
  end;
end;

procedure TfrmScriptDemo.lbMsgsDblClick(Sender: TObject);
begin
  if lbMsgs.ItemIndex > -1 then
    ShowMsg(Tdws2Msg(lbMsgs.Items.Objects[lbMsgs.ItemIndex]));
end;

procedure TfrmScriptDemo.ShowMsg;
var
  b: Boolean;
begin
  memoSource.OnChange := nil;
  b := memoSource.Modified;

  if (msg <> ActiveMsg) and (ActiveMsg is TScriptMsg) then
    UpdateSyntax;

  if Assigned(msg) and (msg is TScriptMsg) then
    with msg as TScriptMsg do
    begin
      memoSource.SelStart := Prg.Msgs.GetErrorLineStart(TScriptMsg(msg).Pos) - 1;
      memoSource.SelLength := Prg.Msgs.GetErrorLineEnd(TScriptMsg(msg).Pos) - memoSource.SelStart;
      memoSource.SelAttributes.Style := [fsBold];
      memoSource.SelAttributes.Color := clRed;
      memoSource.SelStart := TScriptMsg(msg).Pos.Pos - 1;
      memoSource.SelLength := 1;
    end;

  ActiveMsg := msg;
  memoSource.Modified := b;
  memoSource.OnChange := memoSourceChange;
end;

procedure TfrmScriptDemo.ShowFirstMsg;
var
  x: Integer;
begin
  for x := 0 to lbMsgs.Items.Count - 1 do
    if Assigned(lbMsgs.Items.Objects[x]) then
    begin
      ShowMsg(Tdws2Msg(lbMsgs.Items.Objects[x]));
      lbLog.ItemIndex := x;
      break;
    end;
  memoSource.Repaint;
end;

procedure TfrmScriptDemo.lbMsgsClick(Sender: TObject);
begin
  lbMsgs.OnDblClick(self);
end;

procedure TfrmScriptDemo.SimpleDebuggerDoDebug(Prog: TProgram; Expr: TExpr);
begin
  memoSource.SelStart := Expr.Pos.Pos - 1;
  memoSource.SelLength := 2;
  while not NextStep do
    Application.ProcessMessages;
  NextStep := False;
end;

end.

