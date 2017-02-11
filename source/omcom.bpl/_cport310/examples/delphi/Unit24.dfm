object Form24: TForm24
  Left = 487
  Top = 163
  Caption = 'Form24'
  ClientHeight = 216
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 56
    Top = 40
    Width = 281
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 352
    Top = 38
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 433
    Top = 38
    Width = 75
    Height = 25
    Caption = 'Disconnect'
    Enabled = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 56
    Top = 80
    Width = 457
    Height = 113
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 56
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'COM2'
  end
  object Edit3: TEdit
    Left = 183
    Top = 8
    Width = 58
    Height = 21
    TabOrder = 5
    Text = '13'
  end
  object Edit4: TEdit
    Left = 247
    Top = 8
    Width = 58
    Height = 21
    TabOrder = 6
    Text = '13'
  end
end
