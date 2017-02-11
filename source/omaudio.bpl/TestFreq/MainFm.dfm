object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Test frequency'
  ClientHeight = 324
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelFreq1: TLabel
    Left = 326
    Top = 81
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Freq 1: '
  end
  object LabelFreq2: TLabel
    Left = 326
    Top = 108
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Freq 2: '
  end
  object LabelThreshold: TLabel
    Left = 324
    Top = 135
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = 'Threshold: '
  end
  object ButtonStart: TButton
    Left = 326
    Top = 16
    Width = 85
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 326
    Top = 47
    Width = 85
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object EditFreq1: TEdit
    Left = 370
    Top = 78
    Width = 41
    Height = 21
    TabOrder = 2
    Text = '410'
  end
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 297
    Height = 305
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object EditFreq2: TEdit
    Left = 370
    Top = 105
    Width = 41
    Height = 21
    TabOrder = 4
    Text = '440'
  end
  object ButtonClear: TButton
    Left = 326
    Top = 288
    Width = 85
    Height = 25
    Caption = 'Clear'
    TabOrder = 5
    OnClick = ButtonClearClick
  end
  object EditThreshold: TEdit
    Left = 384
    Top = 132
    Width = 27
    Height = 21
    TabOrder = 6
    Text = '100'
  end
end
