object FSimpleDemo: TFSimpleDemo
  Left = 261
  Top = 107
  Width = 367
  Height = 372
  Caption = 'FSimpleDemo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    359
    345)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 341
    Height = 26
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'This program demonstrates what you have to do at least to to exe' +
      'cute a DWSII script program'
    WordWrap = True
  end
  object MSource: TMemo
    Left = 5
    Top = 48
    Width = 349
    Height = 129
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'var x: Integer;'
      'for x := 0 to 5 do'
      '  PrintLn('#39'Hello World '#39' + IntToStr(x));')
    TabOrder = 0
  end
  object MResult: TMemo
    Left = 5
    Top = 184
    Width = 349
    Height = 121
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
  end
  object BNCompileAndExecute: TButton
    Left = 175
    Top = 314
    Width = 177
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Compile && Execute'
    TabOrder = 2
    OnClick = BNCompileAndExecuteClick
  end
  object DelphiWebScriptII1: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 28
    Top = 232
  end
end
