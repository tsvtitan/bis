object Form1: TForm1
  Left = 244
  Top = 189
  Caption = 'Wave Player'
  ClientHeight = 222
  ClientWidth = 393
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
    Top = 203
    Width = 393
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
    Top = 189
    Width = 393
    Height = 14
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 97
    ExplicitWidth = 304
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 178
    Width = 393
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
    Left = 80
    Top = 96
  end
  object DXAudioOut1: TDXAudioOut
    OnDone = AudioOut1Done
    OnProgress = AudioOut1Progress
    DeviceNumber = 0
    Latency = 100
    PrefetchData = True
    PollingInterval = 100
    FramesInBuffer = 24576
    SpeedFactor = 1.000000000000000000
    Left = 48
    Top = 96
  end
  object ACMConverter1: TACMConverter
    OutBitsPerSample = 0
    OutChannels = 0
    OutSampleRate = 0
    Left = 248
    Top = 24
  end
  object DXAudioIn1: TDXAudioIn
    Latency = 100
    SamplesToRead = -1
    DeviceNumber = 0
    InBitsPerSample = 8
    InChannels = 1
    InSampleRate = 8000
    RecTime = -1
    EchoRecording = False
    FramesInBuffer = 24576
    PollingInterval = 100
    Left = 224
    Top = 96
  end
end
