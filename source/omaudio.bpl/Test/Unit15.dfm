object Form15: TForm15
  Left = 0
  Top = 0
  Caption = 'Form15'
  ClientHeight = 341
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 344
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object WaveIn1: TWaveIn
    Loop = False
    EndSample = -1
    Left = 232
    Top = 88
  end
  object DSAudioOut1: TDSAudioOut
    Input = WaveIn1
    DeviceNumber = 0
    Calibrate = False
    Latency = 100
    SpeedFactor = 1.000000000000000000
    Left = 248
    Top = 168
  end
  object VoiceFilter1: TVoiceFilter
    OutSampleRate = 8000
    EnableAGC = False
    EnableNoiseReduction = False
    EnableVAD = False
    Left = 472
    Top = 176
  end
end
