object Form1: TForm1
  Left = 462
  Top = 240
  Caption = 'Wave Player'
  ClientHeight = 328
  ClientWidth = 531
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 104
    Top = 16
    Width = 46
    Height = 13
    Caption = 'Total time'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 163
    Top = 16
    Width = 3
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 48
    Width = 65
    Height = 25
    Caption = 'Play...'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn3: TBitBtn
    Left = 80
    Top = 48
    Width = 49
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = BitBtn3Click
    NumGlyphs = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 309
    Width = 531
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 111
    ExplicitWidth = 304
  end
  object Panel1: TPanel
    Left = 0
    Top = 295
    Width = 531
    Height = 14
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 97
    ExplicitWidth = 304
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 284
    Width = 531
    Height = 11
    Align = alBottom
    TabOrder = 4
    ExplicitTop = 86
    ExplicitWidth = 304
  end
  object ForwardButton: TButton
    Left = 144
    Top = 48
    Width = 33
    Height = 25
    Caption = '>>'
    TabOrder = 5
    OnClick = ForwardButtonClick
  end
  object BackwardButton: TButton
    Left = 184
    Top = 48
    Width = 33
    Height = 25
    Caption = '<<'
    TabOrder = 6
    OnClick = BackwardButtonClick
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 16
    Width = 81
    Height = 17
    Caption = 'Loop'
    TabOrder = 7
    OnClick = CheckBox1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Wave files|*.wav'
    Left = 240
    Top = 16
  end
  object DXAudioOut1: TDXAudioOut
    OnDone = AudioOut1Done
    OnProgress = AudioOut1Progress
    DeviceNumber = 0
    Left = 120
    Top = 128
  end
end
