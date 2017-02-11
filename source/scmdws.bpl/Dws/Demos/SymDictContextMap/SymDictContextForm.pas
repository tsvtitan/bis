{**********************************************************************}
{                                                                      }
{    This file is a demo for using the SymbolDictionary, ContextMap,   }
{    and SourceList features of a DWS program.                         }
{                                                                      }
{    The demo makes use of the SynEdit editor.                         }
{    It can be found here (http://synedit.sourceforge.net)             }
{                                                                      }
{    The Initial Developer of the Original Code is Mark Ericksen.      }
{**********************************************************************}

{$I dws2.inc}

unit SymDictContextForm;

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  SynEditHighlighter, SynHighlighterPas, SynEdit,
  dws2Comp, dws2Exprs, dws2Errors;

type
  TfmDictContxt = class(TForm)
    DelphiWebScriptII1: TDelphiWebScriptII;
    Editor: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    sbStatus: TStatusBar;
    Splitter1: TSplitter;
    pFooter: TPanel;
    pDictionary: TPanel;
    lbSymNames: TListBox;
    Splitter2: TSplitter;
    Panel1: TPanel;
    lbSymPositions: TListBox;
    mMessages: TMemo;
    Splitter3: TSplitter;
    pContext: TPanel;
    pContextHdr: TPanel;
    tvContextMap: TTreeView;
    grpListControl: TGroupBox;
    chkAutoUpdate: TCheckBox;
    btnForceUpdate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure btnForceUpdateClick(Sender: TObject);
    procedure lbSymNamesClick(Sender: TObject);
    procedure lbSymPositionsClick(Sender: TObject);
    procedure tvContextMapClick(Sender: TObject);
  private
    FProgram: TProgram;      // need to have a compiled script for browsing SymbolDictionary
    FScriptChanged: Boolean; // flag it as dirty
    function GetScriptName(ScriptPos: TScriptPos): string;
    procedure ValidateInMain(ScriptPos: TScriptPos);  // Aborts if not in Main script
  public
    procedure BuildLists;
    procedure BuildDictionaryList;
    procedure BuildContextList;
    procedure CompileScriptIfNeeded;
  end;

var
  fmDictContxt: TfmDictContxt;

implementation

{$R *.dfm}

uses dws2Compiler, dws2Symbols;

procedure TfmDictContxt.FormCreate(Sender: TObject);
begin
  FScriptChanged := True;
  { These two compiler options MUST be on for the demo to work. }
//  DelphiWebScriptII1.Config.CompilerOptions := [coSymbolDictionary, coContextMap];
end;

procedure TfmDictContxt.EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
  Context: TContext;
begin
  sbStatus.SimpleText := Format('%d : %d', [Editor.CaretY, Editor.CaretX]);
  { Select the context that corresponds to current position }

  if Assigned(FProgram) then
  begin
    // only look for contexts within the main source
    Context := FProgram.ContextMap.FindContext(Editor.CaretX, Editor.CaretY,
                                               FProgram.SourceList.MainScript.SourceFile);
    if Assigned(Context) then
      tvContextMap.Selected := TTreeNode(Context.Data)   // stuffed pointer to node in 'Data' property
    else
      tvContextMap.Selected := nil;
  end;
end;

procedure TfmDictContxt.btnForceUpdateClick(Sender: TObject);
begin
  BuildLists;
end;

procedure TfmDictContxt.lbSymNamesClick(Sender: TObject);
var
  i: Integer;
  SymList: TSymbolPositionList;
  Sym: TSymbolPosition;
  TypeDisplay: string;
  Usages: TStringList;
begin
  { User selected a symbol. Show list of positions in script. }
  lbSymPositions.Items.Clear;

  Usages := TStringList.Create;
  try
    if lbSymNames.ItemIndex > -1 then begin
      SymList := TSymbolPositionList(lbSymNames.Items.Objects[lbSymNames.ItemIndex]);
      if Assigned(SymList) then
        for i := 0 to SymList.Count - 1 do begin
          Sym := SymList[i];
          Usages.Clear;
          if suForward in Sym.SymbolUsages then
            Usages.Add('Forward');
          if suDeclaration in Sym.SymbolUsages then
            Usages.Add('Declared');
          if suImplementation in Sym.SymbolUsages then
            Usages.Add('Implemented');
          if suReference in Sym.SymbolUsages then
            Usages.Add('Referenced');

          TypeDisplay := '';
          if Usages.Count > 0 then
            TypeDisplay := '('+Usages.CommaText+')';

          lbSymPositions.Items.AddObject(Format('Line %d : Col %d %s - [%s]',
                                                [Sym.ScriptPos.Line,
                                                 Sym.ScriptPos.Col,
                                                 TypeDisplay,
                                                 GetScriptName(Sym.ScriptPos)]),
                                         Sym);   // add pointer to symbol position
        end;
    end;
  finally
    Usages.Free;
  end;
end;

procedure TfmDictContxt.CompileScriptIfNeeded;
var
  i: Integer;
begin
  // if script hasn't been changed, leave it.
  if not FScriptChanged then EXIT;

  // if changed, rebuild
  if Assigned(FProgram) then
    FreeAndNil(FProgram);

  FProgram := DelphiWebScriptII1.Compile(Editor.Lines.Text);
  FScriptChanged := False;

  { Write out compiler messages }
  mMessages.Lines.Clear;
  for i := 0 to FProgram.Msgs.Count - 1 do
    mMessages.Lines.Add(FProgram.Msgs[i].AsInfo);
  if mMessages.Lines.Count = 0 then
    mMessages.Lines.Add('**Compiled**');
end;

procedure TfmDictContxt.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FProgram);  // Make sure to free it
end;

procedure TfmDictContxt.EditorChange(Sender: TObject);
begin
  FScriptChanged := True;
  if chkAutoUpdate.Checked then
    BuildLists;
end;

procedure TfmDictContxt.lbSymPositionsClick(Sender: TObject);
var
  SymPos: TSymbolPosition;
begin
  { On double-click of a Symbol position, put cursor at the script postion }
  if lbSymPositions.ItemIndex > -1 then
  begin
    // get object in the list
    SymPos := TSymbolPosition(lbSymPositions.Items.Objects[lbSymPositions.ItemIndex]);
    if Assigned(SymPos) then
    begin
      // validate position is in the main script
      ValidateInMain(SymPos.ScriptPos);

      // place cursor at the symbol's position
      Editor.CaretX := SymPos.ScriptPos.Col;
      Editor.CaretY := SymPos.ScriptPos.Line;
      ActiveControl := Editor;
    end;
  end;
end;

procedure TfmDictContxt.tvContextMapClick(Sender: TObject);
var
  Context: TContext;
  StartPoint, EndPoint: TPoint;
begin
  { When context is double-clicked, select the context block in the editor }
  if tvContextMap.Selected <> nil then
    if Assigned(tvContextMap.Selected.Data) then
    begin
      Context := TContext(tvContextMap.Selected.Data);

      // Validate that the script position is in the main script
      ValidateInMain(Context.StartPos);

      // find start of selection
      StartPoint.X := Context.StartPos.Col;
      StartPoint.Y := Context.StartPos.Line;
      // find end of selection
      EndPoint.X   := Context.EndPos.Col;
      EndPoint.Y   := Context.EndPos.Line;

      // put the cursor at the beginning of the block
      Editor.CaretX := StartPoint.X;
      Editor.CaretY := StartPoint.Y;

      // Set selection blocks
    {  Editor.BlockBegin := StartPoint;
      Editor.BlockEnd   := EndPoint; }

      ActiveControl := Editor;
    end;
end;

procedure TfmDictContxt.BuildLists;
begin
  CompileScriptIfNeeded;

  BuildDictionaryList;
  BuildContextList;
end;

procedure TfmDictContxt.BuildContextList;

    procedure AddContextToTree(Context: TContext; ParentNode: TTreeNode);
    var
      NewNode: TTreeNode;
      i: Integer;
    begin
      { Add that context }
      NewNode := tvContextMap.Items.AddChildObject(ParentNode,
                                                   Format('Start %d:%d; End %d:%d [%s]',
                                                          [Context.StartPos.Line,
                                                           Context.StartPos.Col,
                                                           Context.EndPos.Line,
                                                           Context.EndPos.Col,
                                                           GetScriptName(Context.StartPos)]),
                                                   Context);
      Context.Data := NewNode;   // have context link to node for easy dereference later
      { Cycle for any sub-contexts }
      for i := 0 to Context.SubContexts.Count - 1 do
        { Recusively call to add them - added as children of tree node}
        AddContextToTree(TContext(Context.SubContexts[i]), NewNode);
    end;

var
  i: Integer;
  Context: TContext;
begin
  tvContextMap.Items.Clear;

  { Call for a compile. Will create Program. }
  CompileScriptIfNeeded;

  { Add all context map entries to the tree view }
  for i := 0 to FProgram.ContextMap.Contexts.Count - 1 do
  begin
    { Add top level contexts. They will recusively add any sub-contexts. }
    Context := TContext(FProgram.ContextMap.Contexts.Items[i]);
    AddContextToTree(Context, nil);
  end;
  tvContextMap.FullExpand;
end;

procedure TfmDictContxt.BuildDictionaryList;
var
  i: Integer;
  SymList: TSymbolPositionList;
begin
  lbSymNames.Clear;
  lbSymPositions.Items.Clear;

  { Call for a compile. Will create Program. }
  CompileScriptIfNeeded;

  for i := 0 to FProgram.SymbolDictionary.Count - 1 do begin
    SymList := FProgram.SymbolDictionary[i];
    lbSymNames.Items.AddObject(Format('%s = %s', [SymList.Symbol.Name,
                                                  SymList.Symbol.ClassName]),
                               SymList);
  end;
  lbSymNames.ItemIndex := 0;   // set to the first one
  lbSymNamesClick(nil);   // trigger event to select first one and display info
end;

function TfmDictContxt.GetScriptName(ScriptPos: TScriptPos): string;
var
  x: Integer;
begin
  // find index of script file
  x := FProgram.SourceList.IndexOf(ScriptPos);
  if (x > -1) then
  begin
    Result := FProgram.SourceList[x].NameReference;
    if Result = '' then
      Result := '(main module)';
  end
  else
    Result := '(unknown)';
end;

procedure TfmDictContxt.ValidateInMain(ScriptPos: TScriptPos);
begin
  // if position is not in the main script, show message and raise an Abort
  if FProgram.SourceList.MainScript <> FProgram.SourceList.FindScriptSourceItem(ScriptPos) then
  begin
    MessageDlg('The specified position is in a different script file.', mtInformation, [mbOK], 0);
    Abort;
  end
end;

end.
