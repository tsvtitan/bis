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

unit dwsUnitEditorRichEditForm;

interface

uses
  Windows, Messages, SysUtils,
{$IFDEF DELPHI6up}
  Variants,
{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, dwsUnitEditorBaseForm, StdCtrls, ComCtrls, Menus, StdActns,
  ActnList, ImgList, ToolWin, ExtCtrls, dws2Errors;

type
  TfmDwsUnitEditorRichEdit = class(TfmDwsUnitEditorBase)
    reEditor: TRichEdit;
    procedure reEditorChange(Sender: TObject);
    procedure reEditorSelectionChange(Sender: TObject);
    procedure actJumpImpDeclExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ZoomToMessage(Msg: Tdws2Msg); override;
    //
    function GetEditorModified: Boolean; override;
    procedure SetEditorModified(AValue: Boolean); override;
    function GetEditorLines: TStrings; override;
    function GetEditorCaretXY: TPoint; override;
    procedure SetEditorCaretXY(AValue: TPoint); override;
    function GetEditorInsertMode: Boolean; override;
    procedure SetEditorTopLine(AValue: Integer); override;
    procedure CenterEditorLine(ALine: Integer); override;
    function GetEditor: TWinControl; override;
  public
    procedure UpdateSyntax;
    procedure ReadUnitToScript; override;
  end;

var
  fmDwsUnitEditorRichEdit: TfmDwsUnitEditorRichEdit;

implementation

uses dws_VCLmwPasToRtf, dws2IDEUtils;

{$R *.dfm}

{ TfmDwsUnitEditorRichEdit }

procedure TfmDwsUnitEditorRichEdit.ReadUnitToScript;
var
  onChange: TNotifyEvent;
begin
  { Unhook the OnChange event so it doesn't slow down the read in by updating
    syntax with every change. }
  onChange := reEditor.OnChange;
  try
    reEditor.OnChange := nil;

    inherited;

    UpdateSyntax;
    SetEditorCaretXY(Point(1, 1));    // scroll to top of text (at bottom by default)
  finally
    reEditor.OnChange := onChange;

    EditorModified := False;         // syntax change can trigger modified
    UpdateEditorStatus;
  end;
end;

procedure TfmDwsUnitEditorRichEdit.ZoomToMessage(Msg: Tdws2Msg);
var
  onChange: TNotifyEvent;
  b: Boolean;
begin
  onChange := reEditor.OnChange;
  b := reEditor.Modified;
  try
    reEditor.OnChange := nil;

    if Assigned(msg) and (msg is TScriptMsg) then
      with msg as TScriptMsg do
      begin
        reEditor.SelStart := FProgram.Msgs.GetErrorLineStart(TScriptMsg(Msg).Pos) - 1;
        reEditor.SelLength := FProgram.Msgs.GetErrorLineEnd(TScriptMsg(Msg).Pos) - reEditor.SelStart;
        reEditor.SelAttributes.Style := [fsBold];
        reEditor.SelAttributes.Color := clRed;
        reEditor.SelStart := TScriptMsg(Msg).Pos.Pos - 1;
        reEditor.SelLength := 1;
      end;
  finally
    reEditor.Modified := b;
    reEditor.OnChange := onChange;
  end;
end;

procedure TfmDwsUnitEditorRichEdit.CenterEditorLine(ALine: Integer);
begin
  { TODO -oMark : Find how to get information needed (need # of lines shown in editor, top + #Lines / 2 then focus the line) }
end;

function TfmDwsUnitEditorRichEdit.GetEditor: TWinControl;
begin
  Result := reEditor;
end;

function TfmDwsUnitEditorRichEdit.GetEditorCaretXY: TPoint;
begin
{$IFDEF DELPHI6up}
  Result := reEditor.CaretPos;
{$ELSE}
  { Taken from StdCtrls.pas "function TCustomMemo.GetCaretPos: TPoint;" in D7 }
  Result.X := LongRec(SendMessage(Handle, EM_GETSEL, 0, 0)).Hi;
  Result.Y := SendMessage(Handle, EM_LINEFROMCHAR, Result.X, 0);
  Result.X := Result.X - SendMessage(Handle, EM_LINEINDEX, -1, 0);
{$ENDIF}
  Result.X := Result.X + 1;
  Result.Y := Result.Y + 1;
end;

function TfmDwsUnitEditorRichEdit.GetEditorInsertMode: Boolean;
begin
  { TODO -oMark : How to determine in if Insert or Overwrite mode? }
  Result := True;   // default to 'insert' mode.
end;

function TfmDwsUnitEditorRichEdit.GetEditorLines: TStrings;
begin
  Result := reEditor.Lines;
end;

function TfmDwsUnitEditorRichEdit.GetEditorModified: Boolean;
begin
  Result := reEditor.Modified;
end;

procedure TfmDwsUnitEditorRichEdit.SetEditorCaretXY(AValue: TPoint);
{$IFNDEF DELPHI6up}
var
  CharIdx: Integer;
{$ENDIF}
begin
  AValue.X := AValue.X - 1;
  AValue.Y := AValue.Y - 1;
{$IFDEF DELPHI6up}
  reEditor.CaretPos := AValue;
{$ELSE}
  { Taken from StdCtrls.pas "procedure TCustomMemo.SetCaretPos(const Value: TPoint);" in D7 }
  CharIdx := SendMessage(Handle, EM_LINEINDEX, AValue.y, 0) + AValue.x;
  SendMessage(Handle, EM_SETSEL, CharIdx, CharIdx);
{$ENDIF}
end;

procedure TfmDwsUnitEditorRichEdit.SetEditorModified(AValue: Boolean);
begin
  reEditor.Modified := AValue;
end;

procedure TfmDwsUnitEditorRichEdit.SetEditorTopLine(AValue: Integer);
begin
  SendMessage(reEditor.Handle, EM_LINESCROLL, 0, AValue);
end;

procedure TfmDwsUnitEditorRichEdit.reEditorChange(Sender: TObject);
begin
  inherited;
  FCompileNeeded := True;
  UpdateEditorStatus;
  UpdateSyntax;
end;

procedure TfmDwsUnitEditorRichEdit.UpdateSyntax;
var
  tempMS: TMemoryStream;
  pasCon: TPasConversion;
  pos, top: Integer;
  onChange: TNotifyEvent;
begin
  if (Length(reEditor.Text) <= 0) then
    Exit;

  pos := reEditor.SelStart;
  top := SendMessage(reEditor.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  onChange := reEditor.OnChange;
  tempMS := TMemoryStream.Create;
  try
    reEditor.Lines.SaveToStream(TempMS);
    reEditor.OnChange := nil;
    pasCon := TPasConversion.Create;
    try
      try
        pasCon.UseDelphiHighlighting(ExtractFilePath(ParamStr(0))+{FProgPath + }'DwsDemo.ini');
        pasCon.LoadFromStream(TempMS);
        pasCon.ConvertReadStream;
        reEditor.PlainText := False;
        reEditor.Lines.BeginUpdate;
        reEditor.Lines.LoadFromStream(pasCon);
        SendMessage(reEditor.Handle, EM_LINESCROLL, 0, top);
        reEditor.Lines.EndUpdate;
      finally
        reEditor.PlainText := True;
        PasCon.Free;
      end;
    except
      // Remove highlighting
      tempMS.Position := 0;
      reEditor.SelAttributes := reEditor.DefAttributes;
      reEditor.Lines.LoadFromStream(tempMS);
    end;
  finally
    reEditor.SelStart := pos;
    tempMS.Free;
    reEditor.OnChange := onChange;
  end;
end;

procedure TfmDwsUnitEditorRichEdit.reEditorSelectionChange(Sender: TObject);
begin
  inherited;
  // update cursor postion changes
  UpdateEditorStatus;
end;

procedure TfmDwsUnitEditorRichEdit.actJumpImpDeclExecute(Sender: TObject);
var
  NewPos: TScriptPos;
  CaretPoint: TPoint;
begin
  inherited;
  CaretPoint := GetEditorCaretXY;
  NewPos := FindToggledFuncDeclImplPos(CaretPoint.X, CaretPoint.Y, FProgram);
  if NewPos.Pos <> -1 then
  begin
    CaretPoint.X := NewPos.Col;
    CaretPoint.Y := NewPos.Line;

    // place cursor at new position
    SetEditorCaretXY(CaretPoint);
    CenterEditorLine(CaretPoint.Y);    // center on new line
  end;
end;

end.
