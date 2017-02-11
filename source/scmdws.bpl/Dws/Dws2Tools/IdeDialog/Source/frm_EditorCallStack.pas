////////
///
//  dws2ide - An IDE to DWSII
//
//  frm_EditorCallStack.pas
//
//  Call stack window.
//
//  Copyright (c) 2002 Fabio Augusto Dal Castel
//
/////

unit frm_EditorCallStack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, dws2ThreadedDebugger;

type
  TfrmEditorCallStack = class(TForm)
    ListBox: TListBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBoxDblClick(Sender: TObject);
  private
    FCaller: TForm;
    function GetItems: TStrings;
    procedure SetItems(const Value: TStrings);

    procedure HighlightCurrentCall;
  public
    property Caller: TForm read FCaller write FCaller;
    property Items: TStrings read GetItems write SetItems;
  end;

var
  frmEditorCallStack: TfrmEditorCallStack;

implementation

{$R *.DFM}

uses dws2Exprs, frm_Editor;

// --- TfrmEditorCallStack -----------------------------------------------

function TfrmEditorCallStack.GetItems: TStrings;
begin
  Result := ListBox.Items;
end;

procedure TfrmEditorCallStack.SetItems(const Value: TStrings);
begin
  ListBox.Items.Assign(Value);
end;

procedure TfrmEditorCallStack.HighlightCurrentCall;
begin
  if ListBox.ItemIndex <> -1 then
    with ListBox.Items.Objects[ListBox.ItemIndex] as TExpr do
      (FCaller as TfrmEditor).HighlightLine(Pos.Col, Pos.Line);
end;

// --- Events ------------------------------------------------------------

procedure TfrmEditorCallStack.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Close;

    VK_RETURN:
      HighlightCurrentCall;

    VK_UP, VK_DOWN:
      ;        // Nada
  else
    // Another key, redirect to editor (except Alt-F4)
    if not ((ssAlt in Shift) and (Key = VK_F4)) then
      PostMessage((FCaller as TfrmEditor).Handle, WM_KEYDOWN, Key, 0);
  end;
end;

procedure TfrmEditorCallStack.ListBoxDblClick(Sender: TObject);
begin
  HighlightCurrentCall;
end;

end.
