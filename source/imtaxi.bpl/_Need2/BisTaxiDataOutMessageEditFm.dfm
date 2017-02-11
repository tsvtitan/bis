inherited BisTaxiDataOutMessageEditForm: TBisTaxiDataOutMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataOutMessageEditForm'
  ClientHeight = 433
  ClientWidth = 363
  ExplicitWidth = 371
  ExplicitHeight = 467
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 395
    Width = 363
    ExplicitTop = 395
    ExplicitWidth = 363
    DesignSize = (
      363
      38)
    inherited ButtonOk: TButton
      Left = 184
      ExplicitLeft = 184
    end
    inherited ButtonCancel: TButton
      Left = 280
      ExplicitLeft = 280
    end
  end
  inherited PanelControls: TPanel
    Width = 363
    Height = 395
    ExplicitWidth = 363
    ExplicitHeight = 395
    DesignSize = (
      363
      395)
    object LabelRecipient: TLabel
      Left = 15
      Top = 69
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100':'
      FocusControl = EditRecipient
    end
    object LabelDateCreate: TLabel
      Left = 96
      Top = 368
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitTop = 345
    end
    object LabelDateOut: TLabel
      Left = 95
      Top = 287
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerOut
    end
    object LabelType: TLabel
      Left = 58
      Top = 15
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxType
      Transparent = True
    end
    object LabelContact: TLabel
      Left = 33
      Top = 96
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1090#1072#1082#1090':'
      FocusControl = EditContact
    end
    object LabelCreator: TLabel
      Left = 115
      Top = 314
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
    end
    object LabelPriority: TLabel
      Left = 21
      Top = 42
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
      FocusControl = ComboBoxPriority
      Transparent = True
    end
    object LabelDescription: TLabel
      Left = 27
      Top = 174
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelCounter: TLabel
      Left = 74
      Top = 147
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object LabelDateBegin: TLabel
      Left = 107
      Top = 233
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 89
      Top = 260
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelFirm: TLabel
      Left = 106
      Top = 341
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object EditRecipient: TEdit
      Left = 86
      Top = 66
      Width = 237
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 182
      Top = 365
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 18
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 276
      Top = 365
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 19
    end
    object ButtonRecipient: TButton
      Left = 329
      Top = 66
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 5
      OnClick = ButtonRecipientClick
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 182
      Top = 284
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 14
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 276
      Top = 284
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 15
    end
    object ComboBoxType: TComboBox
      Left = 86
      Top = 12
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
    end
    object EditContact: TEdit
      Left = 86
      Top = 93
      Width = 264
      Height = 21
      MaxLength = 100
      TabOrder = 6
    end
    object EditCreator: TEdit
      Left = 182
      Top = 311
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 16
    end
    object ComboBoxPriority: TComboBox
      Left = 86
      Top = 39
      Width = 123
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        #1074#1099#1089#1086#1082#1080#1081
        #1085#1086#1088#1084#1072#1083#1100#1085#1099#1081
        #1085#1080#1079#1082#1080#1081)
    end
    object MemoDescription: TMemo
      Left = 86
      Top = 174
      Width = 264
      Height = 50
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 9
    end
    object MemoText: TMemo
      Left = 86
      Top = 120
      Width = 264
      Height = 48
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 8
      OnChange = MemoTextChange
    end
    object ButtonPattern: TButton
      Left = 14
      Top = 120
      Width = 66
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 7
      OnClick = ButtonPatternClick
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 182
      Top = 230
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 276
      Top = 230
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 182
      Top = 257
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 276
      Top = 257
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 13
    end
    object CheckBoxDelivery: TCheckBox
      Left = 189
      Top = 14
      Width = 73
      Height = 17
      Caption = #1044#1086#1089#1090#1072#1074#1082#1072
      TabOrder = 1
    end
    object CheckBoxFlash: TCheckBox
      Left = 267
      Top = 14
      Width = 61
      Height = 17
      Caption = #1060#1083#1077#1096
      TabOrder = 2
    end
    object ComboBoxFirm: TComboBox
      Left = 182
      Top = 338
      Width = 168
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 0
      TabOrder = 17
    end
  end
  inherited ImageList: TImageList
    Left = 32
    Top = 216
    Bitmap = {
      494C0101060009000C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B030000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B132000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B130000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E50066330000663300006633
      000066330000973A11000000000000000000A1250000FFFFFF00FFF9ED00FFF9
      ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9ED00FFF9
      ED00FFFFFF00B132000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900663300003366CC003366
      CC0066330000973A110000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFD
      E900FFFFFF00B132000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100663300003366CC003366
      CC0066330000973A11000000000000000000AC3C0000A53C00009F3000009F30
      00009F3000009F3000009F300000666666006666660066666600666666006666
      6600666666006666660066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00FF9C1B00663300003366CC003366
      CC0066330000973A11000000000000000000BA3B0000FFA72900FFA42300FFA7
      2900FFA72900FFA72900FFA7290066666600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE370066330000663300003366CC003366CC003366
      CC003366CC00663300006633000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F6AE3700F6AE3700F6AE370066666600FFFFFF009F3000009F3000009F30
      00009F300000FFFFFF0066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00663300003366CC003366CC003366CC003366
      CC003366CC003366CC006633000000000000DB390000FFFA8A00FFFD9300FFFA
      8A00FFFA8A00FFFA8A00FFFA8A0066666600FFFFFF009F3000009F3000009F30
      00009F300000FFFFFF0066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EFC28000973A1100973A1100973A
      1100973A1100973A1100973A1100663300003366CC003366CC003366CC003366
      CC003366CC003366CC006633000000000000EFC28000973A1100973A1100B132
      0000B1320000B1320000B132000066666600FFFFFF009F3000009F3000009F30
      00009F300000FFFFFF0066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000663300003366CC003366CC003366CC003366
      CC003366CC003366CC0066330000000000000000000000000000000000000000
      000000000000000000000000000066666600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000663300006633000066330000663300006633
      0000663300006633000066330000000000000000000000000000000000000000
      0000000000000000000000000000666666006666660066666600666666006666
      6600666666006666660066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000D3C6B500B1320000B1320000B132
      0000B1320000B1320000B1320000B1320000B1320000B1320000B1320000B132
      0000B1320000D5C9B7000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000E0BC8800A5200000A9250000A928
      0000AB280000AA2A0000AC2B0000B02F0000AF300000B1300000B1320000B131
      0000B12F0000E6C28F000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000B1320000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B13200000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000A21C0000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B02D00000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000B1320000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B13200000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000A4270000FFFFFF00FFE9D100FFE7
      CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE7CC00FFE6CC00FFE6CA00FFF3
      E200FFFFFF00B03000000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000B1320000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A2280000FFFFFF00FFF3E200FFEF
      DC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDC00FFEFDB00FFED
      D900FFFFFF00B13200000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000B1320000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13200000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000A3270000FFFFFF00FFF5E900FFF1
      E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFF1E100FFED
      D900FFFFFF00B13000000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4
      E500FFFFFF00973A11000000000000000000B1320000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4
      E500FFFFFF00B13200000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E5009FA5A000AEBC
      BA00FFFFFF00973A11000000000000000000A1250000FFFFFF00FFF9ED00FFF4
      E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4E500FFF4
      E500FFFFFF00973A110000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900973A1100973A1100973A
      1100973A1100973A11000000000000000000B1320000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFD
      E900FFFFFF00B132000000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900DAD8C7000E1314000C15
      1800D6E0E300973A110000000000000000009A1E0000FFFFFF00FFFDE900FFFD
      E900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFDE900FFFD
      E900FFFFFF00973A11000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100973A110033CC330033CC
      3300973A1100973A11000000000000000000AC3C0000B13200009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100973A1100973A1100973A
      1100973A1100B13200000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100943911001B0F090031657600207E
      9E001C1E1D00943912000000000000000000AC3C0000A53C00009F300000A031
      0000A0320000A03300008E390D00973A1100973A1100973A1100973A1100973A
      1100973A1100973A11000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00973A1100973A1100973A110033CC330033CC
      3300973A1100973A1100973A110000000000B1320000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C
      1B00FF9C1B00B13200000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00784A0E002F3B310033CCFF0033CC
      FF001D3F440046281B000000000000000000BA3B0000FFA72900FFA42300FFA1
      1F00FF9C1B00FC9A1900FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C1B00FF9C
      1B00FF9C1B00973A11000000000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700973A110033CC330033CC330033CC330033CC
      330033CC330033CC3300973A110000000000B1320000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700F6AE3700F6AE3700F6AE3700F6AE3700F6AE
      3700F6AE3700B13200000000000000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700B782290017130A004DB8CE0033CCFF0033CC
      FF002FBDEC000E1415009D9FA00000000000CD3C0000F6AE3700F6AE3700F6AE
      3700F5B13900F6AE3700F6AE3700973A1100973A1100973A1100973A1100973A
      1100973A1100973A1100973A110000000000DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00973A110033CC330033CC330033CC330033CC
      330033CC330033CC3300973A110000000000B1320000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00FEED7E00FEED7E00FEED7E00FEED7E006666
      660066666600666666006666660000000000DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00F0E077001E1E11005E9D940033CCFF0033CCFF0033CC
      FF0033CCFF002E8CAB00181E1F00C1C1C100DB390000FFFA8A00FFFD9300FFF4
      8800FFF18300FEED7E00FEED7E00973A11000000FF000000FF000000FF000000
      FF000000FF000000FF00973A110000000000EFC28000973A1100973A1100973A
      1100973A1100973A1100973A1100973A1100973A1100973A110033CC330033CC
      3300973A1100973A1100973A110000000000DBC8AB00B1320000B1320000B132
      0000B1320000B1320000B1320000B1320000B1320000B1320000B13200006666
      66000033FF000033FF006666660000000000EFC28000973A1100973A1100973A
      1100973A1100973A11003C180800332F2C0036C8F80033CCFF0033CCFF0033CC
      FF0033CCFF0033CCFF003464740043464800EFC28000973A1100973A1100973A
      1100973A1100973A1100973A1100973A11000000FF000000FF000000FF000000
      FF000000FF000000FF00973A1100000000000000000000000000000000000000
      00000000000000000000000000000000000000000000973A110033CC330033CC
      3300973A11000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006666
      66000033FF000033FF0066666600000000000000000000000000000000000000
      000000000000000000000F3D4D00264E5C001452660014526600145266001452
      66001452660014526600145064000F3D4D000000000000000000000000000000
      0000000000000000000000000000973A1100973A1100973A1100973A1100973A
      1100973A1100973A1100973A1100000000000000000000000000000000000000
      00000000000000000000000000000000000000000000973A1100973A1100973A
      1100973A11000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006666
      6600666666006666660066666600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF000000000003000300000000
      0003000300000000000300030000000000030003000000000003000300000000
      0003000300000000000300030000000000030001000000000003000100000000
      000100010000000000010001000000000001000100000000FE01FE0100000000
      FE01FE0100000000FFFFFFFF00000000FFFFFFFFFFFFFFFF0003000300030003
      0003000300030003000300030003000300030003000300030003000300030003
      0003000300030003000300030003000300030003000300030001000300030003
      000100030001000100010001000000010001000100000001FF87FFE1FC00FE01
      FF87FFE1FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupAccount: TPopupActionBar
    OnPopup = PopupAccountPopup
    Left = 40
    Top = 288
    object MenuItemAccounts: TMenuItem
      Caption = #1059#1095#1077#1090#1085#1099#1077' '#1079#1072#1087#1080#1089#1080
      OnClick = MenuItemAccountsClick
    end
    object MenuItemDrivers: TMenuItem
      Caption = #1042#1086#1076#1080#1090#1077#1083#1080
      OnClick = MenuItemDriversClick
    end
    object MenuItemClients: TMenuItem
      Caption = #1050#1083#1080#1077#1085#1090#1099
      OnClick = MenuItemClientsClick
    end
  end
end
