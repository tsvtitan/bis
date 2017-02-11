object Form1: TForm1
  Left = 189
  Top = 114
  Width = 690
  Height = 636
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Compile'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 665
    Height = 401
    TabOrder = 1
  end
  object Button2: TButton
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Add Script'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo2: TMemo
    Left = 8
    Top = 448
    Width = 665
    Height = 153
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Button3: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Run All'
    TabOrder = 4
    OnClick = Button3Click
  end
  object DelphiWebScriptII1: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 104
    Top = 56
  end
  object dws2Unit1: Tdws2Unit
    Script = DelphiWebScriptII1
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Forwards = <>
    Functions = <>
    Records = <>
    UnitName = 'helo'
    Variables = <>
    Left = 104
    Top = 104
  end
end
