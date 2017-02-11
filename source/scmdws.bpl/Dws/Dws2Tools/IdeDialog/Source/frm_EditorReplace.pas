////////
///
//  dws2ide - An IDE to DWSII
//
//  frm_EditorReplace.pas
//
//  Dialog for a replace operation.
//
//  Copyright (c) 2002 Fabio Augusto Dal Castel
//
//  Code from
//    SynEdit suite SearchReplaceDemo project (by Michael Hieke)
//
/////

unit frm_EditorReplace;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frm_EditorSearch, StdCtrls, ExtCtrls;

type
  TfrmEditorReplace = class(TfrmEditorSearch)
    LblReplaceText: TLabel;
    cbReplaceText: TComboBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function GetReplaceText: string;
    function GetReplaceTextHistory: string;
    procedure SetReplaceText(Value: string);
    procedure SetReplaceTextHistory(Value: string);
  public
    property ReplaceText: string read GetReplaceText write SetReplaceText;
    property ReplaceTextHistory: string read GetReplaceTextHistory write SetReplaceTextHistory;
  end;

implementation

{$R *.DFM}

// --- TfrmEditorReplace -------------------------------------------------

function TfrmEditorReplace.GetReplaceText: string;
begin
  Result := cbReplaceText.Text;
end;

function TfrmEditorReplace.GetReplaceTextHistory: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to cbReplaceText.Items.Count - 1 do begin
    if i >= 10 then
      break;
    if i > 0 then
      Result := Result + #13#10;
    Result := Result + cbReplaceText.Items[i];
  end;
end;

procedure TfrmEditorReplace.SetReplaceText(Value: string);
begin
  cbReplaceText.Text := Value;
end;

procedure TfrmEditorReplace.SetReplaceTextHistory(Value: string);
begin
  cbReplaceText.Items.Text := Value;
end;

// --- Events ------------------------------------------------------------

procedure TfrmEditorReplace.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  s: string;
  i: integer;
begin
  inherited;
  if ModalResult = mrOK then
  begin
    s := cbReplaceText.Text;
    if s <> '' then
    begin
      i := cbReplaceText.Items.IndexOf(s);
      if i > -1 then
      begin
        cbReplaceText.Items.Delete(i);
        cbReplaceText.Items.Insert(0, s);
        cbReplaceText.Text := s;
      end
      else
        cbReplaceText.Items.Insert(0, s);
    end;
  end;
end;

end.

 