object MainFrm: TMainFrm
  Left = 364
  Top = 508
  Caption = 'ACMComponent demo by Dhalsim'
  ClientHeight = 86
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 137
    Height = 25
    Caption = 'Send stream...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 48
    Width = 137
    Height = 25
    Caption = 'Listen stream...'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 160
    Top = 8
    Width = 305
    Height = 65
    Caption = 'Exit'
    TabOrder = 2
    OnClick = Button3Click
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 40
  end
end