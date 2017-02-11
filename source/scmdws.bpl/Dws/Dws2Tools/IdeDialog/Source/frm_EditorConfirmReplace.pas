////////
///
//  dws2ide - An IDE to DWSII
//
//  frm_EditorConfirmReplace.pas
//
//  Confirmation dialog for a replace operation.
//
//  Copyright (c) 2002 Fabio Augusto Dal Castel
//
//  Code from
//    SynEdit suite SearchReplaceDemo project (by Michael Hieke)
//
/////

unit frm_EditorConfirmReplace;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmEditorConfirmReplace = class(TForm)
    btnReplace: TButton;
    lblConfirmation: TLabel;
    btnSkip: TButton;
    btnCancel: TButton;
    btnReplaceAll: TButton;
    ImageIcon: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  public
    procedure PrepareShow(AEditorRect: TRect; X, Y1, Y2: integer; AReplaceText: string);
  end;

var
  frmEditorConfirmReplace: TfrmEditorConfirmReplace;

implementation

{$R *.DFM}

// --- TfrmEditorConfirmReplace ------------------------------------------

procedure TfrmEditorConfirmReplace.PrepareShow(AEditorRect: TRect; X, Y1, Y2: integer; AReplaceText: string);
var
  nW, nH: integer;
begin
  lblConfirmation.Caption := Format('Replace this occurrence of "%s"?', [AReplaceText]);
  nW := AEditorRect.Right - AEditorRect.Left;
  nH := AEditorRect.Bottom - AEditorRect.Top;

  if nW <= Width then
    X := AEditorRect.Left - (Width - nW) div 2
  else begin
    if X + Width > AEditorRect.Right then
      X := AEditorRect.Right - Width;
  end;
  if Y2 > AEditorRect.Top + MulDiv(nH, 2, 3) then
    Y2 := Y1 - Height - 4
  else
    Inc(Y2, 4);
  SetBounds(X, Y2, Width, Height);
end;

// --- Events ------------------------------------------------------------

procedure TfrmEditorConfirmReplace.FormCreate(Sender: TObject);
begin
  ImageIcon.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
end;

procedure TfrmEditorConfirmReplace.FormDestroy(Sender: TObject);
begin
  frmEditorConfirmReplace := nil;
end;

end.

