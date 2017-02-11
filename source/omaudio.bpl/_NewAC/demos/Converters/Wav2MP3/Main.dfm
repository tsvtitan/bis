object Form1: TForm1
  Left = 382
  Top = 314
  Caption = 'Wav2MP3 Converter'
  ClientHeight = 241
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    284
    241)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 200
    Top = 8
    Width = 56
    Height = 13
    Caption = 'CPU Usage'
  end
  object Label2: TLabel
    Left = 192
    Top = 48
    Width = 22
    Height = 13
    Caption = 'Less'
  end
  object Label3: TLabel
    Left = 240
    Top = 48
    Width = 24
    Height = 13
    Caption = 'More'
  end
  object Label4: TLabel
    Left = 8
    Top = 48
    Width = 30
    Height = 13
    Caption = 'Bitrate'
  end
  object Label5: TLabel
    Left = 16
    Top = 88
    Width = 20
    Height = 13
    Caption = 'Title'
  end
  object Label6: TLabel
    Left = 16
    Top = 112
    Width = 23
    Height = 13
    Caption = 'Artist'
  end
  object Label7: TLabel
    Left = 16
    Top = 136
    Width = 29
    Height = 13
    Caption = 'Album'
  end
  object Label8: TLabel
    Left = 16
    Top = 160
    Width = 29
    Height = 13
    Caption = 'Genre'
  end
  object Label9: TLabel
    Left = 16
    Top = 184
    Width = 22
    Height = 13
    Caption = 'Year'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Select...'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 72
    Width = 268
    Height = 9
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object TrackBar1: TTrackBar
    Left = 192
    Top = 24
    Width = 70
    Height = 20
    Max = 3
    Min = 1
    Position = 3
    TabOrder = 2
    ThumbLength = 15
    OnChange = TrackBar1Change
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 222
    Width = 284
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object ComboBox1: TComboBox
    Left = 48
    Top = 40
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 5
    TabOrder = 4
    Text = '128'
    Items.Strings = (
      '48'
      '56'
      '64'
      '80'
      '96'
      '128'
      '192'
      '256'
      '320')
  end
  object Button2: TButton
    Left = 96
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Convert...'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 56
    Top = 88
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
  end
  object Edit2: TEdit
    Left = 56
    Top = 112
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
  end
  object Edit3: TEdit
    Left = 56
    Top = 136
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
  end
  object Edit4: TEdit
    Left = 56
    Top = 160
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 9
  end
  object Edit5: TEdit
    Left = 56
    Top = 184
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 10
  end
  object WaveIn1: TWaveIn
    Loop = False
    EndSample = -1
    Left = 96
    Top = 160
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Wav files|*.wav'
    Left = 24
    Top = 168
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'mp3'
    Left = 32
    Top = 104
  end
  object MP3Out1: TMP3Out
    Input = WaveIn1
    OnDone = MP3Out1Done
    OnProgress = MP3Out1Progress
    BitRate = br128
    Id3v1Tags.GenreId = 0
    Left = 176
    Top = 176
  end
  object ACMConverter1: TACMConverter
    OutBitsPerSample = 0
    OutChannels = 0
    OutSampleRate = 0
    Left = 176
    Top = 104
  end
end
