object Form1: TForm1
  Left = 526
  Top = 159
  Caption = 'Wave File Converter'
  ClientHeight = 286
  ClientWidth = 463
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
  object Label17: TLabel
    Left = 195
    Top = 224
    Width = 3
    Height = 13
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 55
    Width = 202
    Height = 154
    Caption = 'Input File Parameters'
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 42
      Width = 47
      Height = 13
      Caption = 'Channels:'
    end
    object Label2: TLabel
      Left = 7
      Top = 69
      Width = 64
      Height = 13
      Caption = 'Sample Rate:'
    end
    object Label3: TLabel
      Left = 7
      Top = 21
      Width = 47
      Height = 13
      Caption = 'File Name'
    end
    object Label4: TLabel
      Left = 7
      Top = 90
      Width = 77
      Height = 13
      Caption = 'Bits Per Sample:'
    end
    object Label5: TLabel
      Left = 91
      Top = 21
      Width = 104
      Height = 19
      AutoSize = False
    end
    object Label6: TLabel
      Left = 90
      Top = 42
      Width = 43
      Height = 19
      AutoSize = False
    end
    object Label7: TLabel
      Left = 91
      Top = 70
      Width = 42
      Height = 19
      AutoSize = False
    end
    object Label8: TLabel
      Left = 91
      Top = 91
      Width = 42
      Height = 19
      AutoSize = False
    end
    object Label14: TLabel
      Left = 7
      Top = 111
      Width = 45
      Height = 13
      Caption = 'Encoding'
    end
    object Label15: TLabel
      Left = 91
      Top = 111
      Width = 3
      Height = 13
    end
  end
  object Button1: TButton
    Left = 7
    Top = 21
    Width = 70
    Height = 21
    Caption = 'Input File...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 222
    Top = 21
    Width = 77
    Height = 21
    Caption = 'Output File...'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 7
    Top = 223
    Width = 65
    Height = 26
    Caption = 'Convert!'
    TabOrder = 3
    OnClick = Button3Click
  end
  object GroupBox2: TGroupBox
    Left = 216
    Top = 48
    Width = 233
    Height = 161
    Caption = ' Output File Parameters '
    TabOrder = 4
    object Label9: TLabel
      Left = 7
      Top = 21
      Width = 47
      Height = 13
      Caption = 'File Name'
    end
    object Label10: TLabel
      Left = 91
      Top = 21
      Width = 104
      Height = 19
      AutoSize = False
    end
    object Label11: TLabel
      Left = 7
      Top = 69
      Width = 64
      Height = 13
      Caption = 'Sample Rate:'
    end
    object Label12: TLabel
      Left = 7
      Top = 42
      Width = 47
      Height = 13
      Caption = 'Channels:'
    end
    object Label13: TLabel
      Left = 7
      Top = 92
      Width = 77
      Height = 13
      Caption = 'Bits Per Sample:'
    end
    object Label16: TLabel
      Left = 7
      Top = 125
      Width = 45
      Height = 13
      Caption = 'Encoding'
    end
    object SpinEdit1: TSpinEdit
      Left = 90
      Top = 42
      Width = 29
      Height = 22
      MaxValue = 2
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object SpinEdit3: TSpinEdit
      Left = 90
      Top = 90
      Width = 36
      Height = 22
      Increment = 8
      MaxValue = 24
      MinValue = 8
      TabOrder = 1
      Value = 8
    end
    object Edit1: TEdit
      Left = 90
      Top = 69
      Width = 50
      Height = 21
      TabOrder = 2
      Text = '22050'
    end
    object ComboBox1: TComboBox
      Left = 90
      Top = 118
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 3
      Text = 'RAW PCM'
      Items.Strings = (
        'RAW PCM'
        'DVI IMA ADPCM')
    end
  end
  object Button4: TButton
    Left = 80
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Abort'
    TabOrder = 5
    OnClick = Button4Click
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 269
    Width = 463
    Height = 17
    Align = alBottom
    Step = 1
    TabOrder = 6
    ExplicitTop = 262
  end
  object WaveIn1: TWaveIn
    Loop = False
    EndSample = -1
    Left = 136
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'wav'
    Filter = 'Wave Files|*.wav'
    FilterIndex = 0
    Title = 'Open'
    Left = 160
    Top = 176
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Wave Files|*.wav|Windows Media Files|*.wma'
    FilterIndex = 0
    Title = 'Save As'
    Left = 192
    Top = 208
  end
  object Resampler1: TResampler
    Input = WaveIn1
    Quality = rqBest
    OutSampleRate = 44100
    Left = 144
    Top = 128
  end
  object WaveOut1: TWaveOut
    Input = AudioConverter1
    OnDone = WaveOut1Done
    OnProgress = WaveOut1Progress
    WavType = wtPCM
    BlockSize = 512
    FileMode = foRewrite
    Left = 376
    Top = 72
  end
  object AudioConverter1: TAudioConverter
    Input = Resampler1
    Mode = msmMonoToBoth
    OutBitsPerSample = 0
    OutChannels = 0
    Left = 280
    Top = 200
  end
  object WMAOut1: TWMAOut
    Input = AudioConverter1
    OnDone = WaveOut1Done
    OnProgress = WaveOut1Progress
    DesiredBitrate = 0
    Lossless = False
    VBR = False
    VBRQuality = 0
    Left = 376
    Top = 208
  end
end
