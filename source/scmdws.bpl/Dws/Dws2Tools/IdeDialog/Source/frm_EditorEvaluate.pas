////////
///
//  dws2ide - An IDE to DWSII
//
//  frm_EditorEvaluate.pas
//
//  Dialog for expression evaluation.
//
//  Copyright (c) 2002 Fabio Augusto Dal Castel
//
/////

unit frm_EditorEvaluate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, dws2ThreadedDebugger;

type
  TfrmEditorEvaluate = class(TForm)
    LblExpression: TLabel;
    EditExpression: TEdit;
    LblResult: TLabel;
    MemoResult: TMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditExpressionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FDebugger: Tdws2ThreadedDebugger;
    function GetExpression: string;
    procedure SetExpression(const Value: string);
  public
    procedure DoEvaluate;

    property Debugger: Tdws2ThreadedDebugger read FDebugger write FDebugger;
    property Expression: string read GetExpression write SetExpression;
  end;

var
  frmEditorEvaluate: TfrmEditorEvaluate;

implementation

{$R *.DFM}

// --- TfrmEditorEvaluate ------------------------------------------------

procedure TfrmEditorEvaluate.DoEvaluate;
begin
  MemoResult.Text := FDebugger.Evaluate(Expression);
  EditExpression.SetFocus;
  EditExpression.SelectAll;
end;

function TfrmEditorEvaluate.GetExpression: string;
begin
  Result := EditExpression.Text;
end;

procedure TfrmEditorEvaluate.SetExpression(const Value: string);
begin
  EditExpression.Text := Value;
  MemoResult.Clear;

  if EditExpression.Text <> '' then
    DoEvaluate;
end;

// --- Events ------------------------------------------------------------

procedure TfrmEditorEvaluate.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfrmEditorEvaluate.EditExpressionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    DoEvaluate;
end;

end.
