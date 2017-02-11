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
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 28, 2003                                                  }
{                                                                      }
{    The Initial Developer of the Original Code is Mark Ericksen.      }
{    Portions created by Mark Ericksen Copyright (C) 2002, 2003        }
{    Mark Ericksen, United States of America.                          }
{    Rights Reserved.                                                  }
{                                                                      }
{    Contributor(s):                                                   }
{                                                                      }
{**********************************************************************}

{$I dws2.inc}

unit dwsUnitEditorBaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ExtCtrls, Buttons, ActnList, Menus,
  StdActns, ToolWin, dws2Comp, dws2Exprs, dws2Symbols, dws2Errors;

const
  idxTextPanel = 3;
  UM_AfterShow = WM_USER + 1;

resourcestring
  STextNotFound = 'Text not found';

type
  TfmDwsUnitEditorBase = class(TForm)
    sbStatus: TStatusBar;
    ilTreeView: TImageList;
    tvBrowser: TTreeView;
    sSplitBrowser: TSplitter;
    sSplitFooter: TSplitter;
    pButtons: TPanel;
    alActions: TActionList;
    actReload: TAction;
    actSyntax: TAction;
    actApply: TAction;
    lbMessages: TListBox;
    actViewBrowser: TAction;
    actCompleteAllClasses: TAction;
    pPopUp: TPopupMenu;
    CompleteClasses1: TMenuItem;
    actCompleteCursorClass: TAction;
    Completeclassatcursor1: TMenuItem;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    N2: TMenuItem;
    ApplyChanges1: TMenuItem;
    Close1: TMenuItem;
    Reloadunit1: TMenuItem;
    SyntaxCheck1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    tbButtons: TToolBar;
    tbtnReload: TToolButton;
    tbtnSyntax: TToolButton;
    tbtnApply: TToolButton;
    tbtnClose: TToolButton;
    ilMenu: TImageList;
    ToolButton4: TToolButton;
    tbtnUndo: TToolButton;
    actEditRedo: TAction;
    tbtnRedo: TToolButton;
    actEditCut: TEditCut;
    actEditCopy: TEditCopy;
    actEditPaste: TEditPaste;
    actEditSelectAll: TEditSelectAll;
    actEditUndo: TEditUndo;
    Redo1: TMenuItem;
    actFind: TAction;
    actFindNext: TAction;
    actFindPrevious: TAction;
    actReplace: TAction;
    actJumpImpDecl: TAction;
    JumptoDeclarationImplement1: TMenuItem;
    actClose: TAction;
    ToolButton8: TToolButton;
    mmMenu: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Search1: TMenuItem;
    Code1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Find1: TMenuItem;
    Undo2: TMenuItem;
    Redo2: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    SelectAll2: TMenuItem;
    FindNext1: TMenuItem;
    FindPrevious1: TMenuItem;
    Replace1: TMenuItem;
    N7: TMenuItem;
    Reloadunit2: TMenuItem;
    SyntaxCheck2: TMenuItem;
    ApplyChanges2: TMenuItem;
    N8: TMenuItem;
    Close2: TMenuItem;
    Completeallclasses1: TMenuItem;
    Completeclassatcursor2: TMenuItem;
    actCodeGen: TAction;
    GenerateCode1: TMenuItem;
    N9: TMenuItem;
    tbtnGenerateCode: TToolButton;
    ToolButton2: TToolButton;
    actSetUnitName: TAction;
    N10: TMenuItem;
    ChangeUnitName1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actApplyExecute(Sender: TObject);
    procedure actSyntaxExecute(Sender: TObject);
    procedure actReloadExecute(Sender: TObject);
    procedure tvBrowserDblClick(Sender: TObject);
    procedure tvBrowserKeyPress(Sender: TObject; var Key: Char);
    procedure actViewBrowserExecute(Sender: TObject);
    procedure actCompleteAllClassesExecute(Sender: TObject);
    procedure actCompleteCursorClassExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actFindPreviousExecute(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure lbMessagesDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actCodeGenExecute(Sender: TObject);
    procedure actSetUnitNameExecute(Sender: TObject);
  private
    procedure UMAfterShow(var Message: TMessage); message UM_AfterShow;
    procedure DisplayUnitName;
  protected
    FUnit: Tdws2Unit;             // unit that is being edited
    FErrorRow : Integer;          // row with error
    FCompileNeeded: Boolean;      // script has changed since the last compile
    FProgramWithUnit: TProgram;   // program with reference to unit being edited
    FProgram: TProgram;           // compiled program (re-used if unchanged), may be nil
    FScript: TDelphiWebScriptII;  // script used to compile unit for tests
    FComponentModified: Boolean;  // flag to note if the edited component has changed
    FDependentUnits: TList;       // units that depend on the unit being edited

    FSearchFromCaret: boolean;
    procedure ShowFirstMessage; virtual;
    procedure ZoomToMessage(Msg: Tdws2Msg); virtual;
    procedure CompileIfNeeded; dynamic;
    procedure AfterShow; virtual;

    { Methods for managing other units that depend on the unit being edited. }

    { UnHook all units in UnitList from the program before editing the component. }
    procedure UnHookDependents;
    { ReHook all units in UnitList after the editing the component. }
    procedure ReHookDependents;
    { Cycle the units in the program and add any that have the edited Unit
      as a dependency to 'UnitList'. }
    procedure FindDependents;
    { Used for recursive searching to add all dependent units to the list }
    procedure AddUnitDependents(AUnit: IUnit; List: TList);

    { Methods to abstract out the Editor interaction. Makes it easier to support
      alternate types. }
    function GetEditorModified: Boolean; virtual; abstract;
    procedure SetEditorModified(AValue: Boolean); virtual; abstract;
    function GetEditorLines: TStrings; virtual; abstract;  // return pointer to the TStrings
    function GetEditorCaretXY: TPoint; virtual; abstract;
    procedure SetEditorCaretXY(AValue: TPoint); virtual; abstract;
    function GetEditorInsertMode: Boolean; virtual; abstract;
    procedure SetEditorTopLine(AValue: Integer); virtual; abstract;
    procedure CenterEditorLine(ALine: Integer); virtual; abstract;
    function GetEditor: TWinControl; virtual; abstract;
    function GetValidatedEditor: TWinControl; virtual;
    procedure UpdateEditorStatus; virtual;
    // make some available as properties
    property EditorModified: Boolean read GetEditorModified write SetEditorModified;
    property EditorCaretXY: TPoint read GetEditorCaretXY write SetEditorCaretXY;
  public
    class function EditUnitAsScript(AUnit: Tdws2Unit): Boolean;
    procedure SyntaxCheck(Silent: Boolean); virtual;   // return if all okay
    procedure DisplayMessages(AProgram: TProgram); virtual;
    procedure ReadUnitToScript; virtual;
    procedure WriteScriptToUnit; virtual;
    property CompileWithScript: TDelphiWebScriptII read FScript write FScript;
    property ComponentModified: Boolean read FComponentModified;
  end;

implementation

{$R *.dfm}

uses
//  SynEditTypes,
{$IFDEF DELPHI6up}
  Variants,
{$ENDIF}
  dws2UnitUtils, dws2Compiler, dws2VCLIDEUtils, dws2IDEUtils,
  dws2VCLSymbolsToTree, GenDelphiCodeForm;

{ TfmDws2UnitEditor - Begin events/methods }

procedure TfmDwsUnitEditorBase.FormCreate(Sender: TObject);
begin
  FSearchFromCaret := False;   // default to search entire scope
  FComponentModified := False;
  FDependentUnits := TList.Create;
end;

procedure TfmDwsUnitEditorBase.actApplyExecute(Sender: TObject);
begin
  SyntaxCheck(False);     // perform syntax check before writing script out
  WriteScriptToUnit;
end;

procedure TfmDwsUnitEditorBase.actSyntaxExecute(Sender: TObject);
begin
  { Force it to recompile if user specified to. }
  FCompileNeeded := True;
  SyntaxCheck(False);
end;

procedure TfmDwsUnitEditorBase.actReloadExecute(Sender: TObject);
begin
  if EditorModified then
  begin
    case MessageDlg('The script has been modified. Are you sure you want to re-load the unit?',
                    mtConfirmation,
                    [mbYes,mbNo],
                    0) of
     mrYes    : ReadUnitToScript;      // re-load the current FUnit
     mrNo     : ;    // do nothing.
     else
       Assert(False);   // something is wrong, options changed
     end;
  end
  // if not modified, reload (may just be reformatting)
  else
    ReadUnitToScript;
end;

procedure TfmDwsUnitEditorBase.ReadUnitToScript;
begin
  FCompileNeeded := True;

  if Assigned(FUnit) then
  begin
    DisplayUnitName;
    try
      DisplayMessages(FProgramWithUnit);   // display any error messages with the needed program
      // if has errors, stop execution and abort here.
      if FProgramWithUnit.Msgs.HasErrors or FProgramWithUnit.Msgs.HasCompilerErrors then
        Abort; 
      UnitToScript(FUnit, FProgramWithUnit, GetEditorLines, True);
    finally
      EditorModified := False;
    end;
    { Run an initial syntax check }
    SyntaxCheck(False);
  end;
end;

procedure TfmDwsUnitEditorBase.SyntaxCheck(Silent: Boolean);
begin
  if (not FCompileNeeded) then EXIT;

  FErrorRow := -1;

  { don't affect messages if silent }
  if not Silent then
    lbMessages.Items.Clear;

  { Compile script to local program for validation }
  CompileIfNeeded;

  FCompileNeeded := False;

  { Do check for supported types. Add warnings if unsupported for units. }
  AddWarningsForUnsupportedTypes(FProgram);

  { Really bad compiles can leave the program being uncreated }
  if Assigned(FProgram) then
  begin
    { If not silent, write out errors or successful compile message }
    if not Silent then
    begin
      DisplayMessages(FProgram);
      { If compile was without error }
      if lbMessages.Items.Count = 0 then
        lbMessages.Items.Add('**Compiled**');

      GetValidatedEditor.Invalidate;     // update the painting (error messages appear/disappear)
      ShowFirstMessage;                  // focus the first error message
    end; {silent}

    { Update code explorer window if no errors }
    //SymbolsToDefaultDelphiTree(FProgram, tvBrowser);
    SymbolsToUnitTree(FProgram, tvBrowser);
  end;

  // Update status (display compile status)
  UpdateEditorStatus;
end;

procedure TfmDwsUnitEditorBase.WriteScriptToUnit;
begin
  if not Assigned(FUnit) then
    Exit;

  CompileIfNeeded;

  if FProgram.Msgs.HasCompilerErrors or FProgram.Msgs.HasErrors then
  begin
    SyntaxCheck(False);    // re-run the syntax check to display errors.
    raise Exception.Create('There are errors in the script.');
  end;

  ScriptToUnit(FUnit, FProgram);    // only write back if no errors
  EditorModified := False;          // no longer modifed. (wrote back to component)
  FComponentModified := True;       // the component has changed
end;

procedure TfmDwsUnitEditorBase.actCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmDwsUnitEditorBase.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if EditorModified then
    case MessageDlg('The script has been modified. Do you want to save your changes?',
                    mtConfirmation,
                    [mbYes,mbNo,mbCancel],
                    0) of
     mrYes    :
       begin
         actApply.Execute;           // save changes
         CanClose := True;           // okay to close
       end;
     mrNo     : CanClose := True;    // just close
     mrCancel : CanClose := False;   // user aborted close
     else
       Assert(False);   // something is wrong, options changed
     end;
end;

procedure TfmDwsUnitEditorBase.ShowFirstMessage;
var
  x: Integer;
begin
  for x := 0 to lbMessages.Items.Count - 1 do
    if Assigned(lbMessages.Items.Objects[x]) then
    begin
      ZoomToMessage(Tdws2Msg(lbMessages.Items.Objects[x]));
      Break;
    end;
end;

procedure TfmDwsUnitEditorBase.ZoomToMessage(Msg: Tdws2Msg);
var
  NewPoint: TPoint;
begin
  if Assigned(msg) and (msg is TScriptMsg) then
  begin
    ActiveControl := GetValidatedEditor;  // set the editor to be the active control

    with msg as TScriptMsg do
    begin
      NewPoint.X := TScriptMsg(Msg).Pos.Col;
      NewPoint.Y := TScriptMsg(Msg).Pos.Line;
      EditorCaretXY := NewPoint;
      FErrorRow := TScriptMsg(Msg).Pos.Line;

      { Try to roughly center the error position in the window }
      CenterEditorLine(FErrorRow);
    end;
  end;
  // repaint to update for the new ErrorRow
  GetValidatedEditor.Repaint;
end;

procedure TfmDwsUnitEditorBase.tvBrowserDblClick(Sender: TObject);
var
  Node: TTreeNode;
  UsePos: TSymbolPosition;
  NewPoint: TPoint;
begin
  { Jump to that symbol location stored in data node. }
  Node := tvBrowser.Selected;
  if Assigned(Node) then
  begin
    UsePos := TSymbolPosition(Node.Data);
    { Focus the desired position }
    if Assigned(UsePos) then
    begin
      NewPoint.X := UsePos.ScriptPos.Col;
      NewPoint.Y := UsePos.ScriptPos.Line;
      EditorCaretXY := NewPoint;
      // set the SynEdit to the active control
      ActiveControl := GetValidatedEditor;

      { Try to roughly center the new position in the window }
      CenterEditorLine(NewPoint.Y);
    end;
  end;
end;

procedure TfmDwsUnitEditorBase.CompileIfNeeded;
var
  storedFilter: Tdws2Filter;
begin
  // if the script is dirty, re-compile it
  if FCompileNeeded then begin
    // free the previously compiled program
    FreeAndNil(FProgram);
    // Cannot compile generated script if a filter is attached, store it and rehook it afterward
    storedFilter := FScript.Config.Filter;
    try
      FScript.Config.Filter := nil;
      // re-compile the script (store original options, turn on needed options)
      FProgram := CompileWithSymbolsAndMap(FScript, GetEditorLines.Text);
    finally
      FScript.Config.Filter := storedFilter;
    end;
  end;
end;

procedure TfmDwsUnitEditorBase.tvBrowserKeyPress(Sender: TObject; var Key: Char);
begin
  { Treat user hitting 'return' as a double-click }
  if Key = #13 then
  begin
    tvBrowserDblClick(nil);
    Key := #0;      // set it as handled
  end;
end;

procedure TfmDwsUnitEditorBase.actViewBrowserExecute(Sender: TObject);
begin
  // If browser is visible but not focused, focus it.
  if tvBrowser.Visible and (not tvBrowser.Focused) then
    tvBrowser.SetFocus
  // if browser visible and focused, hide it.
  else if tvBrowser.Visible and tvBrowser.Focused then
  begin
    sSplitBrowser.Hide;
    tvBrowser.Hide;
    GetValidatedEditor.SetFocus;
  end
  // if not visible, show it.
  else if not tvBrowser.Visible then
  begin
    sSplitBrowser.Show;
    tvBrowser.Show;
    tvBrowser.SetFocus;
  end;
end;

procedure TfmDwsUnitEditorBase.actCompleteAllClassesExecute(Sender: TObject);
begin
  { Compile the script and complete classes where there is a declaration without
    an implementation. Ignore errors about missing implementations. }
  CompileIfNeeded;
  try
    if CompleteAllClasses(FScript, GetEditorLines, True) then
      FCompileNeeded := True;
  finally
    SyntaxCheck(False);
  end;
end;

procedure TfmDwsUnitEditorBase.actCompleteCursorClassExecute(Sender: TObject);
begin
  { Compile the script and complete the class at the cursor. }
  CompileIfNeeded;
  try
    if CompleteClassAtCursor(FScript, FProgram, EditorCaretXY.Y, EditorCaretXY.X, GetEditorLines, True) then
      FCompileNeeded := True;
  finally
    SyntaxCheck(False);
  end;
end;

procedure TfmDwsUnitEditorBase.FormDestroy(Sender: TObject);
begin
  FDependentUnits.Free;
  FreeAndNil(FProgram);
end;

procedure TfmDwsUnitEditorBase.actFindExecute(Sender: TObject);
begin
//  ShowSearchReplaceDialog(False);
end;

procedure TfmDwsUnitEditorBase.actFindNextExecute(Sender: TObject);
begin
//  DoSearchReplaceText(False, False);
end;

procedure TfmDwsUnitEditorBase.actFindPreviousExecute(Sender: TObject);
begin
//  DoSearchReplaceText(False, True);
end;

procedure TfmDwsUnitEditorBase.actReplaceExecute(Sender: TObject);
begin
//  ShowSearchReplaceDialog(True);
end;

procedure TfmDwsUnitEditorBase.lbMessagesDblClick(Sender: TObject);
begin
  { Goto the location in the message. Highlight that line. }
  if lbMessages.ItemIndex > -1 then
    ZoomToMessage(Tdws2Msg(lbMessages.Items.Objects[lbMessages.ItemIndex]));
end;
{ TfmDws2UnitEditor - End events/methods }

class function TfmDwsUnitEditorBase.EditUnitAsScript(AUnit: Tdws2Unit): Boolean;
var
  StoreScript: TDelphiWebScriptII;
  unitProg: TProgram;
begin
  { +Use available script for internal compiles. Want all the other things
    declared and available that the editing unit may rely upon.
    +Un-hook unit from script so 'old' declares don't conflict locally. }
  if AUnit.Script = nil then
    raise Exception.Create('The unit must be attached to a TDelphiWebScriptII component.');

  AUnit.ReleaseStaticSymbols; // force new table

  unitProg := AUnit.Script.Compile('');
  try
    // dependency problems?
    if unitProg.Msgs.HasErrors or unitProg.Msgs.HasCompilerErrors then
      raise Exception.Create(unitProg.Msgs.AsInfo);

    StoreScript := AUnit.Script;
    AUnit.Script := nil;
    try
      { Fire up to edit the unit }
      with Self.Create(nil) do
        try
          CompileWithScript := StoreScript;
          FUnit := AUnit;
          FProgramWithUnit := unitProg;

          FindDependents;                  // find units depending of the edited one
          UnHookDependents;                // unhook them so they don't prevent successful compiles
          try
            ShowModal;
          finally
            ReHookDependents;              // re-hook them so they still work after
            Result := ComponentModified;   // return if the component was modified at all
          end;
        finally
          Free;
        end;
    finally
      AUnit.Script := StoreScript;
    end;
  finally
    unitProg.Free;
  end;
end;

function TfmDwsUnitEditorBase.GetValidatedEditor: TWinControl;
begin
  Result := GetEditor;
  Assert(Assigned(Result), 'The GetEditor method must return a control.');
end;

procedure TfmDwsUnitEditorBase.UpdateEditorStatus;
begin
  // Cursor position
  sbStatus.Panels[0].Text := Format(' %d : %d', [EditorCaretXY.Y, EditorCaretXY.X]);
  // Modified or not
  if EditorModified then
    sbStatus.Panels[1].Text := 'Modified'
  else
    sbStatus.Panels[1].Text := '';
  // Insert/Overwrite mode
  if GetEditorInsertMode then
    sbStatus.Panels[2].Text := 'Insert'
  else
    sbStatus.Panels[2].Text := 'Overwrite';
  // Status text
  if Assigned(FProgram) then
  begin
    if FProgram.Msgs.Count > 0 then
      sbStatus.Panels[idxTextPanel].Text := 'Errors in script'
    else
      sbStatus.Panels[idxTextPanel].Text := 'No errors detected';
  end;
end;

procedure TfmDwsUnitEditorBase.AfterShow;
begin
  { Setup initial display }
  UpdateEditorStatus;

  { Focus the editor by default }
  ActiveControl := GetValidatedEditor;

  { Load the unit, perform initial syntax check }
  ReadUnitToScript;
end;

procedure TfmDwsUnitEditorBase.UMAfterShow(var Message: TMessage);
begin
  { After the form is visible. Call AfterShow method. }
  AfterShow;
end;

procedure TfmDwsUnitEditorBase.FormShow(Sender: TObject);
begin
  { Post message that gets processed after the form is visible. This addresses
    issues where the editor might not be fully initialized for display. }
  PostMessage(Handle, UM_AfterShow, 0, 0);
end;

procedure TfmDwsUnitEditorBase.actCodeGenExecute(Sender: TObject);
begin
  if actApply.Execute then   // just returns if the action was executed
    TfmGenDelphiCode.ShowForm(FProgram, FUnit);
end;

procedure TfmDwsUnitEditorBase.FindDependents;
begin
  FDependentUnits.Clear;
  AddUnitDependents(FUnit, FDependentUnits);
end;

procedure TfmDwsUnitEditorBase.ReHookDependents;
var
  i: Integer;
begin
  Assert(Assigned(CompileWithScript));

  // cycle units in list, add unit from list to build with component
  for i := 0 to FDependentUnits.Count - 1 do
    CompileWithScript.AddUnit( IUnit(FDependentUnits[i]) );
end;

procedure TfmDwsUnitEditorBase.UnHookDependents;
var
  i: Integer;
begin
  Assert(Assigned(CompileWithScript));

  // cycle units in list, remove unit from list to build with component
  for i := 0 to FDependentUnits.Count - 1 do
    CompileWithScript.RemoveUnit( IUnit(FDependentUnits[i]) );
end;

procedure TfmDwsUnitEditorBase.actSetUnitNameExecute(Sender: TObject);
var
  unitName: string;
begin
  unitName := FUnit.UnitName;
  if InputQuery('Edit UnitName property', 'Change the component''s "UnitName" property:', unitName) then
  begin
    FUnit.UnitName := unitName;
    DisplayUnitName;            // update form caption for new name
    FComponentModified := True;
  end;
end;

procedure TfmDwsUnitEditorBase.DisplayUnitName;
var
  DispName: string;
begin
  DispName := FUnit.UnitName;
  if DispName = '' then
    DispName := '<no name>';

  Self.Caption := Format('Editing "%s" (%s) as script', [DispName, FUnit.Name]);
end;

procedure TfmDwsUnitEditorBase.AddUnitDependents(AUnit: IUnit; List: TList);
var
  i: Integer;
  Un: IUnit;
begin
  for i := 0 to CompileWithScript.Config.Units.Count - 1 do
  begin
    Un := IUnit(Pointer(CompileWithScript.Config.Units.Objects[i]));  // get pointer to IUnit interface
    if Un.GetDependencies.IndexOf(AUnit.GetUnitName) > -1 then  // if other units have the provided unit as a dependency
    begin
      List.Add(Pointer(Un));               // add pointer to unit that is dependent
      AddUnitDependents(Un, List);         // Cycle for units that are dependent on dependent unit. (Add units with indirect dependencies to list)
    end;
  end;
end;

procedure TfmDwsUnitEditorBase.DisplayMessages(AProgram: TProgram);
var
  i: Integer;
begin
  for i := 0 to AProgram.Msgs.Count - 1 do
    lbMessages.Items.AddObject(AProgram.Msgs[i].AsInfo, AProgram.Msgs[i]);

  lbMessages.Visible   := lbMessages.Items.Count > 0;
  sSplitFooter.Visible := lbMessages.Items.Count > 0;
end;

end.
