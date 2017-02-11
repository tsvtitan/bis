object Form1: TForm1
  Left = 209
  Top = 186
  Width = 796
  Height = 434
  HorzScrollBar.Range = 112
  VertScrollBar.Range = 24
  ActiveControl = Button1
  Caption = 'Threaded Queries'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 11
  Font.Name = 'MS Sans Serif'
  Font.Pitch = fpVariable
  Font.Style = []
  OldCreateOrder = True
  DesignSize = (
    788
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 358
    Width = 79
    Height = 27
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Run Queries'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 753
    Height = 344
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
