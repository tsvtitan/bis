object Form21: TForm21
  Left = 431
  Top = 268
  Caption = 'Form21'
  ClientHeight = 344
  ClientWidth = 623
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 453
    Top = 26
    Width = 75
    Height = 24
    Caption = 'Begin Call'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 534
    Top = 25
    Width = 75
    Height = 25
    Caption = 'End Call'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 366
    Top = 29
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '932332'
  end
  object Memo1: TMemo
    Left = 16
    Top = 56
    Width = 593
    Height = 241
    ScrollBars = ssVertical
    TabOrder = 3
    WordWrap = False
  end
  object Button3: TButton
    Left = 16
    Top = 303
    Width = 75
    Height = 25
    Caption = 'Clear Log'
    TabOrder = 4
    OnClick = Button3Click
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 29
    Width = 344
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    OnChange = ComboBox1Change
  end
end
