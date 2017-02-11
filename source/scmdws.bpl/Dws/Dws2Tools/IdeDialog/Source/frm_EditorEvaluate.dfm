object frmEditorEvaluate: TfrmEditorEvaluate
  Left = 340
  Top = 243
  Width = 401
  Height = 284
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Evaluate'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object LblExpression: TLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = '&Expression:'
    FocusControl = EditExpression
  end
  object LblResult: TLabel
    Left = 8
    Top = 48
    Width = 34
    Height = 13
    Caption = '&Result:'
    FocusControl = MemoResult
  end
  object EditExpression: TEdit
    Left = 8
    Top = 24
    Width = 377
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnKeyDown = EditExpressionKeyDown
  end
  object MemoResult: TMemo
    Left = 8
    Top = 64
    Width = 377
    Height = 185
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
