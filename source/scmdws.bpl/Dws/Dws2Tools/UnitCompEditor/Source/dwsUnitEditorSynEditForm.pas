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

unit dwsUnitEditorSynEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
{$IFDEF NEWVARIANTS}
  Variants,
{$ENDIF}
  Dialogs, dwsUnitEditorBaseForm, SynEditHighlighter, SynHighlighterPas,
  SynEdit, Menus, StdActns, ActnList, ImgList, StdCtrls, ComCtrls, ToolWin,
  ExtCtrls, SynEditMiscClasses, SynEditSearch;

type
  TfmDwsUnitEditorSynEdit = class(TfmDwsUnitEditorBase)
    synEditor: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    seSearch: TSynEditSearch;
    procedure UpdateEditActions(Sender: TObject);
    procedure ExecuteEditActions(Sender: TObject);
    procedure actEditRedoUpdate(Sender: TObject);
    procedure actEditRedoExecute(Sender: TObject);
    procedure actJumpImpDeclExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure synEditorStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure synEditorSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure synEditorChange(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFindNextExecute(Sender: TObject);
    procedure actFindPreviousExecute(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure synEditorReplaceText(Sender: TObject; const ASearch,
      AReplace: String; Line, Column: Integer;
      var Action: TSynReplaceAction);
  private
    { Private declarations }
  protected
    function GetEditorModified: Boolean; override;
    procedure SetEditorModified(AValue: Boolean); override;
    function GetEditorLines: TStrings; override;
    function GetEditorCaretXY: TPoint; override;
    procedure SetEditorCaretXY(AValue: TPoint); override;
    function GetEditorInsertMode: Boolean; override;
    procedure SetEditorTopLine(AValue: Integer); override;
    function GetEditor: TWinControl; override;
    procedure CenterEditorLine(ALine: Integer); override;
  public
    //
    // Taken from SynEdit SearchReplaceDemo
    procedure DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
    procedure ShowSearchReplaceDialog(AReplace: boolean);
  end;

//var
//  fmDwsUnitEditorSynEdit: TfmDwsUnitEditorSynEdit;

implementation

uses dlgConfirmReplace, dlgSearchText, dlgReplaceText, dws2IDEUtils,
  dws2SynEditUtils, SynEditTypes;

{$R *.dfm}

// options - to be saved to the registry
var
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCaret: boolean;
  gbSearchSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;

  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;

{ TfmDwsUnitEditorSyn }

procedure TfmDwsUnitEditorSynEdit.CenterEditorLine(ALine: Integer);
begin
  synEditor.TopLine := ALine - (synEditor.LinesInWindow div 2);
end;

function TfmDwsUnitEditorSynEdit.GetEditor: TWinControl;
begin
  Result := synEditor;
end;

function TfmDwsUnitEditorSynEdit.GetEditorCaretXY: TPoint;
begin
  Result := synEditor.CaretXY;
end;

function TfmDwsUnitEditorSynEdit.GetEditorInsertMode: Boolean;
begin
  Result := synEditor.InsertMode;
end;

function TfmDwsUnitEditorSynEdit.GetEditorLines: TStrings;
begin
  Result := synEditor.Lines;
end;

function TfmDwsUnitEditorSynEdit.GetEditorModified: Boolean;
begin
  Result := synEditor.Modified;
end;

procedure TfmDwsUnitEditorSynEdit.SetEditorCaretXY(AValue: TPoint);
begin
  synEditor.CaretXY := AValue;
end;

procedure TfmDwsUnitEditorSynEdit.SetEditorModified(AValue: Boolean);
begin
  synEditor.Modified := AValue;
end;

procedure TfmDwsUnitEditorSynEdit.SetEditorTopLine(AValue: Integer);
begin
  synEditor.TopLine := AValue;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmDws2UnitEditor.DoSearchReplaceText
  Author:    Michael Hieke (SynEdit demo)
  Arguments: AReplace: boolean; ABackwards: boolean
  Result:    None
  Purpose:   Perform the search and replace operation.
-----------------------------------------------------------------------------}
procedure TfmDwsUnitEditorSynEdit.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
{ TODO -oMark : Replace operation does not appear to use the Confirm dialog that is included. Does all. }
  sbStatus.Panels[idxTextPanel].Text := '';
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if SynEditor.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    sbStatus.Panels[idxTextPanel].Text := STextNotFound;
    if ssoBackwards in Options then
      SynEditor.BlockEnd := SynEditor.BlockBegin
    else
      SynEditor.BlockBegin := SynEditor.BlockEnd;
    SynEditor.CaretXY := SynEditor.BlockBegin;
  end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;
end;

{-----------------------------------------------------------------------------
  Procedure: TfmDws2UnitEditor.ShowSearchReplaceDialog
  Author:    Michael Hieke (SynEdit demo)
  Arguments: AReplace: boolean
  Result:    None
  Purpose:   Preparation for Search and Replace call. Show dialog, get information.
-----------------------------------------------------------------------------}
procedure TfmDwsUnitEditorSynEdit.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TTextSearchDialog;
begin
  sbStatus.Panels[idxTextPanel].Text := '';
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self)
  else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then begin
      // if something is selected search for that text
      if SynEditor.SelAvail and (SynEditor.BlockBegin.Y = SynEditor.BlockEnd.Y)
      then
        SearchText := SynEditor.SelText
      else
        SearchText := synEditor.WordAtCursor; //SynEditor.ge GetWordAtRowCol(SynEditor.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then with dlg as TTextReplaceDialog do begin
      ReplaceText := gsReplaceText;
      ReplaceTextHistory := gsReplaceTextHistory;
    end;
    SearchWholeWords := gbSearchWholeWords;
    if ShowModal = mrOK then begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then with dlg as TTextReplaceDialog do begin
        gsReplaceText := ReplaceText;
        gsReplaceTextHistory := ReplaceTextHistory;
      end;
      fSearchFromCaret := gbSearchFromCaret;
      if gsSearchText <> '' then begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

{ Editor action events }
procedure TfmDwsUnitEditorSynEdit.UpdateEditActions(Sender: TObject);
begin
  synEditor.UpdateAction(Sender as TBasicAction);
end;

procedure TfmDwsUnitEditorSynEdit.ExecuteEditActions(Sender: TObject);
begin
  synEditor.ExecuteAction(Sender as TBasicAction);
end;

procedure TfmDwsUnitEditorSynEdit.actEditRedoUpdate(Sender: TObject);
begin
  actEditRedo.Enabled := synEditor.CanRedo;
end;

procedure TfmDwsUnitEditorSynEdit.actEditRedoExecute(Sender: TObject);
begin
  synEditor.Redo;
end;
{ /Editor action events }

procedure TfmDwsUnitEditorSynEdit.actJumpImpDeclExecute(Sender: TObject);
begin
  inherited;
  ToggleFromDecl2Impl(synEditor, FProgram);
end;

procedure TfmDwsUnitEditorSynEdit.FormCreate(Sender: TObject);
begin
  inherited;
  gbSearchTextAtCaret := True; // default to search for text at cursor
end;

procedure TfmDwsUnitEditorSynEdit.synEditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  inherited;
  UpdateEditorStatus;
end;

procedure TfmDwsUnitEditorSynEdit.synEditorSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  inherited;
  if Line = FErrorRow then
  begin
    Special := True;
    FG := clWhite;
    BG := clRed;
  end;
end;

procedure TfmDwsUnitEditorSynEdit.synEditorChange(Sender: TObject);
begin
  inherited;
  FCompileNeeded := True;
end;

procedure TfmDwsUnitEditorSynEdit.actFindExecute(Sender: TObject);
begin
  inherited;
  ShowSearchReplaceDialog(False);
end;


procedure TfmDwsUnitEditorSynEdit.actFindNextExecute(Sender: TObject);
begin
  inherited;
  DoSearchReplaceText(False, False);
end;

procedure TfmDwsUnitEditorSynEdit.actFindPreviousExecute(Sender: TObject);
begin
  inherited;
  DoSearchReplaceText(False, True);
end;

procedure TfmDwsUnitEditorSynEdit.actReplaceExecute(Sender: TObject);
begin
  inherited;
  ShowSearchReplaceDialog(True);
end;

procedure TfmDwsUnitEditorSynEdit.synEditorReplaceText(Sender: TObject;
  const ASearch, AReplace: String; Line, Column: Integer;
  var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
begin
  inherited;
  if ASearch = AReplace then
    Action := raSkip
  else begin
    APos := Point(Column, Line);
    APos := SynEditor.ClientToScreen(SynEditor.RowColumnToPixels(APos));
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

    if ConfirmReplaceDialog = nil then
      ConfirmReplaceDialog := TConfirmReplaceDialog.Create(Application);
    ConfirmReplaceDialog.PrepareShow(EditRect, APos.X, APos.Y,
      APos.Y + SynEditor.LineHeight, ASearch);
    case ConfirmReplaceDialog.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
      else Action := raCancel;
    end;
  end;
end;

end.
