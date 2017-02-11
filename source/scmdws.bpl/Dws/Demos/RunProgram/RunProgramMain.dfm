object Form1: TForm1
  Left = 310
  Top = 102
  Width = 577
  Height = 272
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    569
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 52
    Width = 99
    Height = 13
    Caption = '"X" before execution'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 99
    Height = 13
    Caption = '"Y" before execution'
  end
  object Label3: TLabel
    Left = 8
    Top = 196
    Width = 90
    Height = 13
    Caption = '"Z" after execution'
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 557
    Height = 33
    AutoSize = False
    Caption = 
      'This demo program shows how to initialize variables before the m' +
      'ain program starts and how to read the values of variables befor' +
      'e the main program ends.'
    WordWrap = True
  end
  object MSource: TMemo
    Left = 160
    Top = 48
    Width = 406
    Height = 193
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'var x, y, z: String;'
      ''
      'z := x + '#39' '#39' + y')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 156
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Donald'
  end
  object Edit2: TEdit
    Left = 8
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Duck'
  end
  object Edit3: TEdit
    Left = 8
    Top = 212
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Script: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 92
    Top = 156
  end
end
