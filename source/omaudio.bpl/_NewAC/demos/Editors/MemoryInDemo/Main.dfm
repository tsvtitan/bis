object Form1: TForm1
  Left = 428
  Top = 166
  Caption = 'Sine Wave Generator'
  ClientHeight = 145
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 50
    Height = 13
    Caption = 'Frequency'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 40
    Height = 13
    Caption = 'Duration'
  end
  object SpinEdit1: TSpinEdit
    Left = 80
    Top = 24
    Width = 57
    Height = 22
    Increment = 50
    MaxValue = 4000
    MinValue = 50
    TabOrder = 0
    Value = 400
  end
  object SpinEdit2: TSpinEdit
    Left = 80
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 10000
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object Button1: TButton
    Left = 16
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Play'
    TabOrder = 2
    OnClick = Button1Click
  end
  object DXAudioOut1: TDXAudioOut
    Input = MemoryIn1
    OnDone = DXAudioOut1Done
    DeviceNumber = 0
    Left = 232
    Top = 88
  end
  object MemoryIn1: TMemoryIn
    InBitsPerSample = 16
    InChannels = 1
    InSampleRate = 8000
    RepeatCount = 1
    Left = 112
    Top = 96
  end
end
