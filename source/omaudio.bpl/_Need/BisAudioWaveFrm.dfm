inherited BisAudioWaveFrame: TBisAudioWaveFrame
  Width = 271
  Height = 94
  ExplicitWidth = 271
  ExplicitHeight = 94
  object LabelFormat: TLabel
    Left = 12
    Top = 42
    Width = 212
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object TrackBarPosition: TTrackBar
    Left = 1
    Top = 9
    Width = 232
    Height = 32
    Hint = #1055#1086#1079#1080#1094#1080#1103
    Max = 100
    PageSize = 10
    ShowSelRange = False
    TabOrder = 1
    TickMarks = tmTopLeft
    TickStyle = tsManual
    OnChange = TrackBarPositionChange
  end
  object BitBtnPlay: TBitBtn
    Left = 10
    Top = 59
    Width = 25
    Height = 25
    Hint = #1042#1086#1089#1087#1088#1086#1080#1079#1074#1077#1089#1090#1080
    TabOrder = 2
    OnClick = BitBtnPlayClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF00000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000FF000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000FF000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF000000FF
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000FF00000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000FF000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF000000000000FF000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    Margin = 2
  end
  object BitBtnPause: TBitBtn
    Left = 64
    Top = 59
    Width = 25
    Height = 25
    Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1085#1072' '#1087#1072#1091#1079#1091
    TabOrder = 4
    OnClick = BitBtnPauseClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000000000000000000000000000FF00FF00FF00FF000000
      0000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF000000
      000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000000000000000000000000000FF00FF00FF00FF000000
      0000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    Margin = 1
  end
  object BitBtnStop: TBitBtn
    Left = 91
    Top = 59
    Width = 25
    Height = 25
    Hint = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 5
    OnClick = BitBtnStopClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00FFFF00FFFF00FFFF00FF000000FFEDE4FFE5D8FFDCCBFFD8C5FF
      D4BEFFD4BEFFD4BEFFD8C5FFDCCBFFE5D8000000FF00FFFF00FFFF00FFFF00FF
      000000FFE5D8FFD8C5FFD4BEFFCCB2FFC7ABFFC7ABFFC7ABFFCCB2FFD4BEFFD8
      C5000000FF00FFFF00FFFF00FFFF00FF000000FFDCCBFFD4BEFFC7ABFFBF9FFF
      BA98FFBA98FFBA98FFBF9FFFC7ABFFD4BE000000FF00FFFF00FFFF00FFFF00FF
      000000FFD8C5FFCCB2FFBF9FFFB692FFAD85FFAD85FFAD85FFB692FFBF9FFFCC
      B2000000FF00FFFF00FFFF00FFFF00FF000000FFD4BEFFC7ABFFBA98FFAD85FF
      A579FFA172FFA579FFAD85FFBA98FFC7AB000000FF00FFFF00FFFF00FFFF00FF
      000000FFD4BEFFC7ABFFBA98FFAD85FFA172FF9966FFA172FFAD85FFBA98FFC7
      AB000000FF00FFFF00FFFF00FFFF00FF000000FFD4BEFFC7ABFFBA98FFAD85FF
      A579FFA172FFA579FFAD85FFBA98FFC7AB000000FF00FFFF00FFFF00FFFF00FF
      000000FFD8C5FFCCB2FFBF9FFFB692FFAD85FFAD85FFAD85FFB692FFBF9FFFCC
      B2000000FF00FFFF00FFFF00FFFF00FF000000FFDCCBFFD4BEFFC7ABFFBF9FFF
      BA98FFBA98FFBA98FFBF9FFFC7ABFFD4BE000000FF00FFFF00FFFF00FFFF00FF
      000000FFE5D8FFD8C5FFD4BEFFCCB2FFC7ABFFC7ABFFC7ABFFCCB2FFD4BEFFD8
      C5000000FF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
      0000000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Margin = 2
  end
  object BitBtnLoad: TBitBtn
    Left = 118
    Top = 59
    Width = 25
    Height = 25
    Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 6
    OnClick = BitBtnLoadClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000FF00FF00FF00FF00FF00FF00FF00FF000000
      000000FFFF000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000000000FF00FF00FF00FF00FF00FF000000
      0000FFFFFF0000FFFF0000000000008080000080800000808000008080000080
      80000080800000808000008080000080800000000000FF00FF00FF00FF000000
      000000FFFF00FFFFFF0000FFFF00000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000000000FF00FF000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF00FF000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      000000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000FF00FF00FF00FF00FF00FF0000000000FF00FF0000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    Margin = 1
  end
  object BitBtnSave: TBitBtn
    Left = 145
    Top = 59
    Width = 25
    Height = 25
    Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 7
    OnClick = BitBtnSaveClick
    Glyph.Data = {
      42010000424D4201000000000000760000002800000011000000110000000100
      040000000000CC00000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888800000008888888888888888800000008880000000000000800000008803
      3000000880308000000088033000000880308000000088033000000880308000
      0000880330000000003080000000880333333333333080000000880330000000
      0330800000008803088888888030800000008803088888888030800000008803
      0888888880308000000088030888888880308000000088030888888880008000
      0000880308888888808080000000880000000000000080000000888888888888
      888880000000}
    Margin = 1
  end
  object BitBtnClear: TBitBtn
    Left = 172
    Top = 59
    Width = 25
    Height = 25
    Hint = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 8
    OnClick = BitBtnClearClick
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00
      FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00
      FF000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000000000000000
      0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00
      FF000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    Margin = 1
  end
  object TrackBarVolume: TTrackBar
    Left = 234
    Top = 0
    Width = 34
    Height = 85
    Hint = #1043#1088#1086#1084#1082#1086#1089#1090#1100
    Max = 100
    Min = -100
    Orientation = trVertical
    ParentShowHint = False
    PageSize = 0
    Frequency = 25
    ShowHint = True
    ShowSelRange = False
    TabOrder = 10
    OnChange = TrackBarVolumeChange
  end
  object LabelTime: TStaticText
    Left = 16
    Top = 3
    Width = 203
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = '00:00:00.000'
    TabOrder = 0
  end
  object BitBtnRecord: TBitBtn
    Left = 37
    Top = 59
    Width = 25
    Height = 25
    Hint = #1047#1072#1087#1080#1089#1072#1090#1100
    TabOrder = 3
    OnClick = BitBtnRecordClick
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF000000000000000000000000000000000000FF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000002800FF0100FF00
      00FF0000FF0100FF2800FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF000000461DFF2A2AFF2A2AFE2A2AFE2A2AFE2A2AFE2A2AFF461DFF0000
      00FF00FFFF00FFFF00FFFF00FFFF00FF0000002800FF2A2AFF5555FF5555FF55
      55FF5555FF5555FF5555FF5555FF461DFF000000FF00FFFF00FFFF00FFFF00FF
      0000000100FF2A2AFE5555FF7F7FFF7F7FFF7F7FFF7F7FFF7F7FFF5555FF2A28
      FF000000FF00FFFF00FFFF00FFFF00FF0000000000FF2A2AFE5555FF7F7FFFAA
      AAFEAAAAFEAAAAFE7F7FFF5555FF2929FF000000FF00FFFF00FFFF00FFFF00FF
      0000000000FF2A2AFE5555FF7F7FFFAAAAFED4D4FEAAAAFE7F7FFF5555FF2929
      FF000000FF00FFFF00FFFF00FFFF00FF0000000100FF2A2AFE5555FF7F7FFFAA
      AAFEAAAAFEAAAAFE7F7FFF5555FF2A28FF000000FF00FFFF00FFFF00FFFF00FF
      0000002800FF2A2AFF5555FF7F7FFF7F7FFF7F7FFF7F7FFF7F7FFF5555FF461D
      FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000461DFF5555FF5555FF55
      55FF5555FF5555FF5555FF653CFF000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FF000000461DFF2A28FF2929FF2929FF2A28FF461DFF000000FF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
      0000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    Margin = 2
  end
  object BitBtnFormat: TBitBtn
    Left = 199
    Top = 59
    Width = 25
    Height = 25
    Hint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1092#1086#1088#1084#1072#1090
    Caption = 'F'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = BitBtnFormatClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'wav'
    Options = [ofEnableSizing]
    Left = 184
    Top = 8
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'wav'
    Options = [ofEnableSizing]
    Left = 112
    Top = 8
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerTimer
    Left = 152
    Top = 8
  end
  object PopupFormat: TPopupActionBar
    Left = 80
    Top = 8
    object MenuItemMono8Bit8000Hz: TMenuItem
      Caption = '8 Bit 8000 Hz'
      RadioItem = True
      OnClick = MenuItemMono16bit22050HzClick
    end
    object MenuItemMono8bit11025Hz: TMenuItem
      Caption = '8 bit 11025 Hz'
      RadioItem = True
      OnClick = MenuItemMono16bit22050HzClick
    end
    object MenuItemMono8bit22050Hz: TMenuItem
      Caption = '8 bit 22050 Hz'
      RadioItem = True
      OnClick = MenuItemMono16bit22050HzClick
    end
    object MenuItemMono16bit8000Hz: TMenuItem
      Caption = '16 bit 8000 Hz'
      RadioItem = True
      OnClick = MenuItemMono16bit22050HzClick
    end
    object MenuItemMono16bit11025Hz: TMenuItem
      Caption = '16 bit 11025 Hz'
      RadioItem = True
      OnClick = MenuItemMono16bit22050HzClick
    end
    object MenuItemMono16bit22050Hz: TMenuItem
      Caption = '16 bit 22050 Hz'
      Checked = True
      RadioItem = True
      OnClick = MenuItemMono16bit22050HzClick
    end
  end
end
