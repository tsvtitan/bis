unit DwsDemoWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, Menus, ComCtrls, ExtCtrls, Db, DBTables,
  dws2Comp, dws2Exprs, dws2Symbols, dws2Errors,  dws2Debugger,
  dws2Compiler, dws2HtmlFilter, dws2ComConnector, dws2FileFunctions,
  dws2VCLGUIFunctions;

type
  TFDwsDemo = class(TForm)
    MainMenu1: TMainMenu;
    MIFile: TMenuItem;
    MIFileNew: TMenuItem;
    MIFileOpen: TMenuItem;
    MIFileSave: TMenuItem;
    MIFileExit: TMenuItem;
    MIFileN1: TMenuItem;
    MIScript: TMenuItem;
    MIScriptCompile: TMenuItem;
    MIScriptExecute: TMenuItem;
    MIDemos: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MIHelp: TMenuItem;
    MIFileSaveAs: TMenuItem;
    Panel2: TPanel;
    MIHelpN5: TMenuItem;
    MIHelpAbout: TMenuItem;
    MIHelpHomepage: TMenuItem;
    Panel3: TPanel;
    LBLog: TListBox;
    LBMsgs: TListBox;
    MResult: TRichEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Table1: TTable;
    Table1CustNo: TFloatField;
    Table1Company: TStringField;
    Table1Addr1: TStringField;
    Table1Addr2: TStringField;
    Table1City: TStringField;
    Table1State: TStringField;
    Table1Zip: TStringField;
    Table1Country: TStringField;
    Table1Phone: TStringField;
    Table1FAX: TStringField;
    Table1TaxRate: TFloatField;
    Table1Contact: TStringField;
    Table1LastInvoiceDate: TDateTimeField;
    MIFilter: TMenuItem;
    MIFilterStandard: TMenuItem;
    MIFilterHtml: TMenuItem;
    MIDebugger: TMenuItem;
    MIScriptStop: TMenuItem;
    MIDebuggerNone: TMenuItem;
    MIDebuggerSimple: TMenuItem;
    SimpleDebugger: Tdws2SimpleDebugger;
    MIDebuggerRemote: TMenuItem;
    script: TDelphiWebScriptII;
    dws2Unit: Tdws2Unit;
    MSource: TRichEdit;
    MIScriptN2: TMenuItem;
    MIScriptStep: TMenuItem;
    MIScriptN3: TMenuItem;
    MIScriptOptionOptimization: TMenuItem;
    MIHelpHtml: TMenuItem;
    dws2ComConnector1: Tdws2ComConnector;
    dws2GUIFunctions1: Tdws2GUIFunctions;
    dws2FileFunctions1: Tdws2FileFunctions;
    MIHelpDelphi5: TMenuItem;
    MIHelpDelphi6: TMenuItem;
    dws2HtmlUnit: Tdws2HtmlUnit;
    HtmlFilter: Tdws2HtmlFilter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MIFileNewClick(Sender: TObject);
    procedure MIScriptCompileClick(Sender: TObject);
    procedure MIScriptExecuteClick(Sender: TObject);
    procedure MIFileExitClick(Sender: TObject);
    procedure MIFileSaveClick(Sender: TObject);
    procedure MIFileOpenClick(Sender: TObject);
    procedure MIFileSaveAsClick(Sender: TObject);
    procedure MIHelpAboutClick(Sender: TObject);
    procedure MIDemosClick(Sender: TObject);
    procedure MIHelpHomepageClick(Sender: TObject);
    procedure MIFilterStandardClick(Sender: TObject);
    procedure MIFilterHtmlClick(Sender: TObject);
    procedure MIScriptStopClick(Sender: TObject);
    procedure MIDebuggerNoneClick(Sender: TObject);
    procedure MIDebuggerSimpleClick(Sender: TObject);
    procedure MIDebuggerRemoteClick(Sender: TObject);
    procedure MIHelpDelphi5Click(Sender: TObject);
    procedure MIHelpDelphi6Click(Sender: TObject);
    procedure MIHelpHtmlClick(Sender: TObject);
    procedure LBMsgsDblClick(Sender: TObject);
    procedure LBMsgsClick(Sender: TObject);
    procedure SimpleDebuggerDoDebug(Prog: TProgram; Expr: TExpr);
    procedure CompilerOptionClick(Sender: TObject);
    procedure MSourceChange(Sender: TObject);
    procedure dws2UnitFunctionsInputEval(Info: TProgramInfo);
    procedure dws2UnitClassesTQueryFirstEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTQueryNextEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTQueryEofEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTQueryFieldByNameEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTQueryDestroyEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTStringsAddEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowConstructorsCreateEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetPositionEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsUpdateEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetSizeEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetParamsEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsVarParamTestEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsUseVarParamTestEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsSetCaptionEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowConstructorsCreateAssignExternalObject(Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsNewInstanceEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTWindowCleanUp(obj: TScriptObj; ExternalObject: TObject);
    procedure dws2UnitClassesTFieldMethodsAsIntegerEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTFieldMethodsAsStringEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsDestroyEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsAddEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsGetEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsClearEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTListMethodsGetCountEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTFieldsConstructorsCreateEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTFieldsMethodsGetFieldEval(Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitVariablesscriptCodeInstantiate(var ExtObject: TObject);
    procedure dws2UnitVariablestestReadVar(var Value: Variant);
    procedure dws2UnitVariablestestWriteVar(Value: Variant);
    procedure dws2UnitFunctionsTestEval(Info: TProgramInfo); procedure MIScriptStepClick(Sender: TObject);
    procedure dws2UnitFunctionsShowGlobalEval(Info: TProgramInfo);
    procedure dws2UnitClassesTListConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTQueryConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTStringsConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
    procedure dws2UnitClassesTQueryConstructorsCreateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesTFieldsMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTStringsMethodsGetStringEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesTWindowMethodsDestroyEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitFunctionsPauseEval(Info: TProgramInfo);
    procedure dws2UnitFunctionsRedrawDwsDemoEval(Info: TProgramInfo);
  private
    FNextStep: Boolean;
    FErrorLine: Integer;
    FActiveMsg: Tdws2Msg;
    FPrg: TProgram;
    FScriptChanged: Boolean;
    FScrFile: string;
    procedure OpenScript(sname: string);
    procedure CreateDemosMenu;
    procedure ShowMsg(Msg: Tdws2Msg);
    procedure ShowFirstMsg;
    procedure UpdateSyntax;
  public
    FProgPath: string;
    FScriptPath: string;
    FDocuPath: string;
    FScriptFiles: TStringList;
    FCounterFrequency: Int64;
  end;

var
  FDwsDemo: TFDwsDemo;

implementation

uses
  ShellApi, DwsDemoTest, mwPasToRtf;

{$R *.DFM}

type
  TFieldsLookup = class
  private
    FFields: TFields;
    FDwsFields: TInterfaceList;
  public
    constructor Create(Fields: TFields);
    destructor Destroy; override;
    property Fields: TFields read FFields;
    property DwsFields: TInterfaceList read FDwsFields;
  end;

procedure TFDwsDemo.FormCreate(Sender: TObject);
begin
  FProgPath := ExtractFilePath(Application.ExeName);
  FScriptPath := FProgPath + 'Scripts\';
  FDocuPath := FProgPath + '..\..\Docs\';

  FScriptChanged := True;
  FErrorLine := -1;

  MIFilterStandard.Click;
  MIDemos.OnClick := nil;
  CreateDemosMenu;

  QueryPerformanceFrequency(FCounterFrequency);
  if FCounterFrequency = 0 then
    FCounterFrequency := 1; // To avoid divbyzero's

  OpenScript('test.dws');
end;

procedure TFDwsDemo.FormDestroy(Sender: TObject);
begin
  FPrg.Free;
  FScriptFiles.Free;
end;

procedure TFDwsDemo.CreateDemosMenu;
var
  x: Integer;
  sr: TSearchRec;
  s, topic, name : string;
  miTopic, mi: TMenuItem;
begin
  FScriptFiles := TStringList.Create;

  x := FindFirst(FScriptPath + '*.dws', faAnyFile, sr);
  try
    while x = 0 do
    begin
      FScriptFiles.Add(sr.Name);
      x := FindNext(sr);
    end;
  finally
  FindClose(sr);
  end;

  FScriptFiles.Sorted := True;
  miTopic := nil;

  for x := 0 to FScriptFiles.Count - 1 do
  begin
    s := FScriptFiles[x];
    if Pos('$', s) > 0 then
    begin
      topic := Copy(s, 1, Pos('$', s) - 1);
      name := Copy(s, Pos('$', s) + 1, Length(s));

      if topic = '' then
        miTopic := MIDemos
      else if not Assigned(miTopic) or not SameText(miTopic.Caption, topic) then
      begin
        miTopic := TMenuItem.Create(MainMenu1);
        miTopic.Caption := topic;
        MIDemos.Add(miTopic);
      end;

      mi := TMenuItem.Create(MainMenu1);
      mi.Caption := name;
      mi.OnClick := MIDemosClick;
      mi.Tag := x;
      miTopic.Add(mi);
    end;
  end;
end;

procedure TFDwsDemo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  MIFileNewClick(Sender);
  CanClose := not MSource.Modified;
end;

procedure TFDwsDemo.MIFileNewClick(Sender: TObject);
var
  res: Integer;
begin
  if MSource.Modified then
  begin
    res := MessageDlg('There are unsaved changes! Do you want to save now?',
      mtInformation, [mbYes, mbNo, mbCancel], 0);
    if res = mrCancel then exit;
    if res = mrYes then MIFileSaveClick(self);
  end;
  FScrFile := '';
  MSource.Clear;
  MSource.Modified := false;
  FScriptChanged := True;
  Caption := 'DWS Demo';

  ActiveControl := MSource;
end;

procedure TFDwsDemo.MIFileOpenClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := FScriptPath;
  if OpenDialog1.Execute then
  begin
    MIFileNewClick(sender);
    if MSource.Modified then
      Exit;
    MSource.Clear;
    FScrFile := OpenDialog1.FileName;
    Caption := 'DWS Demo - ' + FScrFile;
    MSource.Lines.LoadFromFile(OpenDialog1.FileName);
    FScriptChanged := True;
    MSource.Modified := False;
  end;
end;

procedure TFDwsDemo.MIFileSaveClick(Sender: TObject);
begin
  if FScrFile = '' then
    MIFileSaveAsClick(Sender)
  else
  begin
    MSource.Lines.SaveToFile(FScrFile);
    MSource.Modified := false;
  end;
end;

procedure TFDwsDemo.MIFileSaveAsClick(Sender: TObject);
begin
  SaveDialog1.InitialDir := FScriptPath;
  if SaveDialog1.Execute then
  begin
    FScrFile := SaveDialog1.FileName;
    Caption := 'DWS Demo - ' + FScrFile;
    MSource.Lines.SaveToFile(FScrFile);
  end;
end;

procedure TFDwsDemo.MIFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFDwsDemo.MIScriptCompileClick(Sender: TObject);
var
  x: Integer;
  tStart, tStop: Int64;
begin
  // Assigns the script code in the memo to the script component
  FScriptChanged := False;
  FActiveMsg := nil;
  LBMsgs.Clear;
  LBLog.Clear;

  // Compiles the script
  try
    FPrg.Free;
  finally
    FPrg := nil;
  end;

  QueryPerformanceCounter(tStart);
  
  FErrorLine := -1;

  Script.Config.CompilerOptions := [];
  if MIScriptOptionOptimization.Checked then
    Script.Config.CompilerOptions := Script.Config.CompilerOptions + [coOptimize];

  FPrg := Script.Compile(MSource.Lines.Text);

  QueryPerformanceCounter(tStop);

  LBLog.Items.Add(Format('*** Compiled in %.3f ms', [1000 * (tStop - tStart) / (FCounterFrequency)]));

  for x := 0 to FPrg.Msgs.Count - 1 do
    LBMsgs.Items.AddObject(FPrg.Msgs[x].AsInfo, FPrg.Msgs[x]);
  LBMsgs.Visible := LBMsgs.Items.Count > 0;
  Splitter1.Visible := LBMsgs.Items.Count > 0;
  ShowFirstMsg;
end;


procedure TFDwsDemo.MIScriptExecuteClick(Sender: TObject);
var
  x: Integer;
  tStart, tStop: Int64;
begin
  if FScriptChanged then MIScriptCompileClick(Sender);
  if not Assigned(FPrg) then MIScriptCompileClick(Sender);

  if not Assigned(FPrg) then Exit;

  // Set debugger
  if MIDebuggerSimple.Checked then
    FPrg.Debugger := SimpleDebugger
  else if MIDebuggerRemote.Checked then
    FPrg.Debugger := nil //RemoteDebugger
  else
    FPrg.Debugger := nil;

  LBLog.Items.Add('*** Executing...  press [ESC] to stop');

  QueryPerformanceCounter(tStart);

  FPrg.Execute;

  QueryPerformanceCounter(tStop);

  LBLog.Items.Add(Format('*** Executed. [%.3f s]', [(tStop - tStart) / FCounterFrequency]));

  if FPrg.Result is Tdws2DefaultResult then
    MResult.Text := Tdws2DefaultResult(FPrg.Result).Text;

  // Display messages
  LBMsgs.Items.Clear;
  for x := 0 to FPrg.Msgs.Count - 1 do
    LBMsgs.Items.AddObject(FPrg.Msgs[x].AsInfo, FPrg.Msgs[x]);

  LBMsgs.Visible := LBMsgs.Items.Count > 0;
  Splitter1.Visible := LBMsgs.Items.Count > 0;
end;

procedure TFDwsDemo.MIScriptStopClick(Sender: TObject);
begin
  if Assigned(FPrg) then
    FPrg.Stop;
end;

procedure TFDwsDemo.MIScriptStepClick(Sender: TObject);
begin
  FNextStep := True;
end;

procedure TFDwsDemo.CompilerOptionClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
  FScriptChanged := True;
end;

procedure TFDwsDemo.MIFilterStandardClick(Sender: TObject);
begin
  Script.Config.Filter := nil;
  MIFilterStandard.Checked := True;
  FScriptChanged := True;
end;

procedure TFDwsDemo.MIFilterHtmlClick(Sender: TObject);
begin
  Script.Config.Filter := HtmlFilter;
  MIFilterHtml.Checked := True;
  FScriptChanged := True;
end;

procedure TFDwsDemo.MIDebuggerNoneClick(Sender: TObject);
begin
  MIDebuggerNone.Checked := True;
end;

procedure TFDwsDemo.MIDebuggerSimpleClick(Sender: TObject);
begin
  MIDebuggerSimple.Checked := True;
end;

procedure TFDwsDemo.MIDebuggerRemoteClick(Sender: TObject);
begin
  MIDebuggerRemote.Checked := True;
  ShowMessage('Download and install the remote debugger from the DWSC homepage first!');
end;

procedure TFDwsDemo.MIDemosClick(Sender: TObject);
begin
  OpenScript(FScriptFiles[TMenuItem(Sender).Tag]);
end;

procedure OpenFile(const FileName: string);
begin
  if ShellExecute(Application.MainForm.Handle, 'open', PChar(FileName), nil, nil, SW_SHOW) <= 32 then
    ShowMessage('"' + Filename + '" not found');
end;

procedure TFDwsDemo.MIHelpDelphi5Click(Sender: TObject);
begin
  OpenFile(FDocuPath + 'dws210d5.hlp');
end;

procedure TFDwsDemo.MIHelpDelphi6Click(Sender: TObject);
begin
  OpenFile(FDocuPath + 'dws210d6.hlp');
end;

procedure TFDwsDemo.MIHelpHtmlClick(Sender: TObject);
begin
  OpenFile(FDocuPath + 'HtmlHelp\dws210__toc.html');
end;

procedure TFDwsDemo.MIHelpHomepageClick(Sender: TObject);
begin
  OpenFile('http://www.dwscript.com');
end;

procedure TFDwsDemo.MIHelpAboutClick(Sender: TObject);
begin
  ShowMessage('Demonstration program for DelphiWebScript II ' + Script.Version);
end;

procedure TFDwsDemo.OpenScript;
begin
  MIFileNewClick(nil);
  MSource.Lines.LoadFromFile(FScriptPath + sname); // Since we don't want RTF..
  FScriptChanged := True;
  MSource.Modified := False;
  FScrFile := FScriptPath + sname;
  Caption := 'DWS Demo - ' + FScrFile;
end;

procedure TFDwsDemo.MSourceChange(Sender: TObject);
begin
  FScriptChanged := True;
  UpdateSyntax;
end;

procedure TFDwsDemo.UpdateSyntax;
var
  tempMS: TMemoryStream;
  pasCon: TPasConversion;
  pos, top: Integer;
  onChange: TNotifyEvent;
begin
  if (Length(MSource.Text) <= 0) then
    Exit;

  pos := MSource.SelStart;
  top := SendMessage(MSource.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  onChange := MSource.OnChange;
  tempMS := TMemoryStream.Create;
  try
    MSource.Lines.SaveToStream(TempMS);
    MSource.OnChange := nil;
    pasCon := TPasConversion.Create;
    try
      try
        pasCon.UseDelphiHighlighting(FProgPath + 'DwsDemo.ini');
        pasCon.LoadFromStream(TempMS);
        pasCon.ConvertReadStream;
        MSource.PlainText := False;
        MSource.Lines.BeginUpdate;
        MSource.Lines.LoadFromStream(pasCon);
        SendMessage(MSource.Handle, EM_LINESCROLL, 0, top);
        MSource.Lines.EndUpdate;
      finally
        MSource.PlainText := True;
        PasCon.Free;
      end;
    except
      // Remove highlighting
      tempMS.Position := 0;
      MSource.SelAttributes := MSource.DefAttributes;
      MSource.Lines.LoadFromStream(tempMS);
    end;
  finally
    MSource.SelStart := pos;
    tempMS.Free;
    MSource.OnChange := onChange;
  end;
end;

procedure TFDwsDemo.LBMsgsDblClick(Sender: TObject);
begin
  if LBMsgs.ItemIndex > -1 then
    ShowMsg(Tdws2Msg(LBMsgs.Items.Objects[LBMsgs.ItemIndex]));
end;

procedure TFDwsDemo.ShowMsg(Msg: Tdws2Msg);
var
  b: Boolean;
begin
  MSource.OnChange := nil;
  b := MSource.Modified;

  if (Msg <> FActiveMsg) and (FActiveMsg is TScriptMsg) then
    UpdateSyntax;

  if Assigned(msg) and (msg is TScriptMsg) then
    with msg as TScriptMsg do
    begin
      MSource.SelStart := FPrg.Msgs.GetErrorLineStart(TScriptMsg(Msg).Pos) - 1;
      MSource.SelLength := FPrg.Msgs.GetErrorLineEnd(TScriptMsg(Msg).Pos) - MSource.SelStart;
      MSource.SelAttributes.Style := [fsBold];
      MSource.SelAttributes.Color := clRed;
      MSource.SelStart := TScriptMsg(Msg).Pos.Pos - 1;
      MSource.SelLength := 1;
    end;

  FActiveMsg := Msg;
  MSource.Modified := b;
  MSource.OnChange := MSourceChange;
end;

procedure TFDwsDemo.ShowFirstMsg;
var
  x: Integer;
begin
  for x := 0 to LBMsgs.Items.Count - 1 do
    if Assigned(LBMsgs.Items.Objects[x]) then
    begin
      ShowMsg(Tdws2Msg(LBMsgs.Items.Objects[x]));
      LBLog.ItemIndex := x;
      break;
    end;
  MSource.Repaint;
end;

procedure TFDwsDemo.LBMsgsClick(Sender: TObject);
begin
  LBMsgs.OnDblClick(self);
end;

procedure TFDwsDemo.SimpleDebuggerDoDebug(Prog: TProgram; Expr: TExpr);
begin
  MSource.SelStart := Expr.Pos.Pos - 1;
  MSource.SelLength := 2;
  while not FNextStep do
    Application.ProcessMessages;
  FNextStep := False;
end;

procedure TFDwsDemo.dws2UnitFunctionsInputEval(Info: TProgramInfo);
begin
  Info['Result'] := InputBox(Info['Title'], Info['Prompt'], '');
end;

procedure TFDwsDemo.dws2UnitVariablesscriptCodeInstantiate(
  var ExtObject: TObject);
begin
  ExtObject := MSource.Lines;
end;

procedure TFDwsDemo.dws2UnitVariablestestReadVar(var Value: Variant);
begin
  Value := Caption;
end;

procedure TFDwsDemo.dws2UnitVariablestestWriteVar(Value: Variant);
begin
  Caption := Value;
end;

procedure TFDwsDemo.dws2UnitFunctionsTestEval(Info: TProgramInfo);
begin
  Info.Vars['r'].Member['p'].Member['x'].Value := 12;
end;

procedure TFDwsDemo.dws2UnitFunctionsShowGlobalEval(Info: TProgramInfo);
begin
  ShowMessage(Info['Global']);
  Info['Global'] := 'Hello World';
end;

procedure TFDwsDemo.dws2UnitClassesTFieldMethodsAsIntegerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TField(ExtObject).AsInteger;
end;

procedure TFDwsDemo.dws2UnitClassesTFieldMethodsAsStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TField(ExtObject).AsString;
end;

procedure TFDwsDemo.dws2UnitClassesTFieldsConstructorsCreateEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  x: Integer;
  fieldsLookup: TFieldsLookup;
  dwsField: IUnknown;
begin
  fieldsLookup := (ExtObject as TFieldsLookup);

  // Create a DWS-TField object for every Delphi-TField
  for x := 0 to fieldsLookup.Fields.Count - 1 do
  begin
    dwsField := Info.Vars['TField'].GetConstructor('Create',
      fieldsLookup.Fields[x]).Call.Value;
    fieldsLookup.DwsFields.Add(dwsField);
  end;
end;

procedure TFDwsDemo.dws2UnitClassesTFieldsMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TFDwsDemo.dws2UnitClassesTFieldsMethodsGetFieldEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  fieldsLookup: TFieldsLookup;
  fieldIndex: Integer;
begin
  fieldsLookup := (ExtObject as TFieldsLookup);
  fieldIndex := fieldsLookup.Fields.FieldByName(Info['FieldName']).Index;
  Info['Result'] := fieldsLookup.DwsFields[fieldIndex];
end;

procedure TFDwsDemo.dws2UnitClassesTQueryConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TQuery.Create(nil);
end;

procedure TFDwsDemo.dws2UnitClassesTQueryConstructorsCreateEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  q: TQuery;
  fieldsLookup: TFieldsLookup;
begin
  q := TQuery(ExtObject);
  try
    q.DatabaseName := Info['db'];
    q.SQL.Text := Info['query'];
    q.Prepare;
    q.Open;

    fieldsLookup := TFieldsLookup.Create(q.Fields);
    Info['FFields'] := Info.Vars['TFields'].GetConstructor('Create', fieldsLookup).Call.Value;
  except
    q.Free;
    raise;
  end;
end;

procedure TFDwsDemo.dws2UnitClassesTQueryDestroyEval(Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TFDwsDemo.dws2UnitClassesTQueryFirstEval(Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).First;
end;

procedure TFDwsDemo.dws2UnitClassesTQueryNextEval(Info: TProgramInfo; ExtObject: TObject);
begin
  TQuery(ExtObject).Next;
end;

procedure TFDwsDemo.dws2UnitClassesTQueryEofEval(Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TQuery(ExtObject).Eof;
end;

procedure TFDwsDemo.dws2UnitClassesTQueryFieldByNameEval(Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['FFields'].Method['GetField'].Call([Info['FieldName']]).Value;
end;

procedure TFDwsDemo.dws2UnitClassesTStringsConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TStringList.Create;
end;

procedure TFDwsDemo.dws2UnitClassesTStringsMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TFDwsDemo.dws2UnitClassesTStringsAddEval(Info: TProgramInfo; ExtObject: TObject);
begin
  TStrings(ExtObject).Add(Info['s']);
end;

procedure TFDwsDemo.dws2UnitClassesTStringsMethodsGetStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Result := TStrings(ExtObject)[Info['x']];
end;

procedure TFDwsDemo.dws2UnitClassesTWindowConstructorsCreateAssignExternalObject(Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TFTest.Create(nil);
  TFTest(ExtObject).Show;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowConstructorsCreateEval(Info: TProgramInfo; ExtObject: TObject);
var
  frm: TForm;
begin
  frm := TForm(ExtObject);

  // Use default
  Info['Width'] := frm.Width;
  Info['Height'] := frm.Height;

  // Calls method SetPosition
  Info.Vars['Self'].Method['SetPosition'].Call([Info['Left'], Info['Top']]);

  // Another way to call a method
  Info.Func['SetCaption'].Call([Info['Caption']]);

  frm.Show;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsSetCaptionEval(Info: TProgramInfo; ExtObject: TObject);
begin
  TFTest(ExtObject).Caption := Info['s'];
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsSetPositionEval(Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Vars['Self'].Member['Left'].Value := Info['Left'];
  Info.Vars['Self'].Member['Top'].Value := Info['Top'];
  Info.Func['Update'].Call;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsSetSizeEval(Info: TProgramInfo; ExtObject: TObject);
begin
  Info.Vars['Self'].Member['Height'].Value := Info['Height'];
  Info.Vars['Self'].Member['Width'].Value := Info['Width'];
  Info.Func['Update'].Call;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsUpdateEval(Info: TProgramInfo; ExtObject: TObject);
begin
  TFTest(ExtObject).Left := Info['Left'];
  TFTest(ExtObject).Top := Info['Top'];
  TFTest(ExtObject).Width := Info['Width'];
  TFTest(ExtObject).Height := Info['Height'];
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsSetParamsEval(Info: TProgramInfo; ExtObject: TObject);
var
  params: IInfo;
begin
  Info['Left'] := Info.Vars['params'].Member['Left'].Value;
  Info['Top'] := Info.Vars['params'].Member['Top'].Value;
  Info['Width'] := Info.Vars['params'].Member['Width'].Value;
  Info['Height'] := Info.Vars['params'].Member['Height'].Value;
  Info['Caption'] := Info.Vars['params'].Member['Caption'].Value;

  // The same thing but optimized
  params := Info.Vars['params'];
  Info['Left'] := params.Member['Left'].Value;
  Info['Top'] := params.Member['Top'].Value;
  Info['Width'] := params.Member['Width'].Value;
  Info['Height'] := params.Member['Height'].Value;
  Info['Caption'] := params.Member['Caption'].Value;

  Info.Func['Update'].Call;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsVarParamTestEval(Info: TProgramInfo; ExtObject: TObject);
begin
  // Assign value to the var parameters
  Info['a'] := 12;
  Info['b'] := 21;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsUseVarParamTestEval(Info: TProgramInfo; ExtObject: TObject);
var
  meth: IInfo;
  s: string;
begin
  // Get the function
  meth := Info.Func['VarParamTest'];
  // Call the function
  meth.Call;
  // Display the output value of the var parameters
  s := Format('Var params: a = %s, b = %s', [meth.Parameter['a'].Value, meth.Parameter['b'].Value]);
  Info.Func['SetCaption'].Call([s]);

  // Another way to call a function with parameters
  // This is the prefered way if the method has arguments with complex types
  meth := Info.Func['SetSize'];
  meth.Parameter['Width'].Value := 300;
  meth.Parameter['Height'].Value := 50;
  meth.Call;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsNewInstanceEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := Info.Vars['TWindow'].Method['Create'].Call([50, 50, 'Hello']).Value;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowCleanUp(obj: TScriptObj;
  ExternalObject: TObject);
begin
  ShowMessage('TWindow.OnCleanUp');
end;

procedure TFDwsDemo.dws2UnitClassesTListConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TList.Create;
end;

procedure TFDwsDemo.dws2UnitClassesTListMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  ExtObject.Free;
end;

procedure TFDwsDemo.dws2UnitClassesTListMethodsAddEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TList(ExtObject).Add(Pointer(Integer(Info['Obj'])));
end;

procedure TFDwsDemo.dws2UnitClassesTListMethodsGetEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := Integer(TList(ExtObject).Items[Info['Index']]);
end;

procedure TFDwsDemo.dws2UnitClassesTListMethodsClearEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TList(ExtObject).Clear;
end;

procedure TFDwsDemo.dws2UnitClassesTListMethodsGetCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TList(ExtObject).Count;
end;

{ TFieldsLookup }

constructor TFieldsLookup.Create(Fields: TFields);
begin
  FFields := Fields;
  FDwsFields := TInterfaceList.Create;
end;

destructor TFieldsLookup.Destroy;
begin
  FDwsFields.Free;
  inherited;
end;

procedure TFDwsDemo.dws2UnitClassesTWindowMethodsDestroyEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if assigned(ExtObject) then
    ExtObject.Free;
end;

procedure TFDwsDemo.dws2UnitFunctionsPauseEval(Info: TProgramInfo);
begin
  sleep(Info['Duration']);
end;

procedure TFDwsDemo.dws2UnitFunctionsRedrawDwsDemoEval(Info: TProgramInfo);
begin
  self.Update;
end;

end.

