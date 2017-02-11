////////
///
//  dws2ide - An IDE to DWSII
//
//  frm_EditorOutput.pas
//
//  Program output window.
//
//  Copyright (c) 2002 Fabio Augusto Dal Castel
//
/////

unit frm_EditorOutput;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SynMemo, SynEdit;

type
  TfrmEditorOutput = class(TForm)
    SynMemo: TSynMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FCaller: TForm;
    function GetText: string;
    procedure SetText(const Value: string);
  public
    property Caller: TForm read FCaller write FCaller;
    property Text: string read GetText write SetText;
  end;

var
  frmEditorOutput: TfrmEditorOutput;

implementation

uses frm_Editor;

{$R *.DFM}

// --- TfrmEditorOutput --------------------------------------------------

function TfrmEditorOutput.GetText: string;
begin
  Result := SynMemo.Text;
end;

procedure TfrmEditorOutput.SetText(const Value: string);
begin
  SynMemo.Text := Value;
end;

// --- Events ------------------------------------------------------------

procedure TfrmEditorOutput.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Redirect to editor (except Alt-F4)
  if not ((ssAlt in Shift) and (Key = VK_F4)) then
    PostMessage((FCaller as TfrmEditor).Handle, WM_KEYDOWN, Key, 0);
end;

end.
