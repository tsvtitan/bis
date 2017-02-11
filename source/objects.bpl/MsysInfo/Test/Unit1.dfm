object Form1: TForm1
  Left = 555
  Top = 384
  Width = 398
  Height = 233
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 304
    Top = 16
    Width = 75
    Height = 25
    Caption = 'SystemInfo'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 281
    Height = 177
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object od: TOpenDialog
    DefaultExt = '*.bpl'
    Filter = '*.bpl|*.bpl'
    Left = 304
    Top = 88
  end
end
