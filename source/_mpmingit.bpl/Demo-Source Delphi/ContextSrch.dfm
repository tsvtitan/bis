object ContextSearchForm: TContextSearchForm
  Left = 296
  Top = 224
  BorderStyle = bsDialog
  Caption = 'Search'
  ClientHeight = 73
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 113
    Height = 13
    Caption = 'Enter context to search:'
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 241
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 264
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 264
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Button2Click
  end
end
