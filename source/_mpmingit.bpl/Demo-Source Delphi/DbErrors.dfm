object DbErrForm: TDbErrForm
  Left = 192
  Top = 114
  Width = 239
  Height = 293
  BorderWidth = 6
  Caption = 'Not loaded records'
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
  object List: TListBox
    Left = 0
    Top = 0
    Width = 219
    Height = 213
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 213
    Width = 219
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 0
    end
  end
end
