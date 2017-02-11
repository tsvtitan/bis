inherited BisTaxiDataOutMessageInsertExForm: TBisTaxiDataOutMessageInsertExForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataOutMessageInsertExForm'
  ClientHeight = 465
  ClientWidth = 359
  ExplicitWidth = 367
  ExplicitHeight = 499
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 427
    Width = 359
    ExplicitTop = 427
    ExplicitWidth = 359
    DesignSize = (
      359
      38)
    inherited ButtonOk: TButton
      Left = 180
      ExplicitLeft = 180
    end
    inherited ButtonCancel: TButton
      Left = 276
      ExplicitLeft = 276
    end
  end
  inherited PanelControls: TPanel
    Width = 359
    Height = 427
    ExplicitWidth = 359
    ExplicitHeight = 427
    DesignSize = (
      359
      427)
    object LabelDateCreate: TLabel
      Left = 92
      Top = 399
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitTop = 370
    end
    object LabelDateOut: TLabel
      Left = 91
      Top = 318
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerOut
      ExplicitTop = 329
    end
    object LabelType: TLabel
      Left = 56
      Top = 15
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxType
      Transparent = True
    end
    object LabelCreator: TLabel
      Left = 111
      Top = 345
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
      ExplicitTop = 356
    end
    object LabelPriority: TLabel
      Left = 19
      Top = 42
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
      FocusControl = ComboBoxPriority
      Transparent = True
    end
    object LabelDescription: TLabel
      Left = 25
      Top = 186
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
      ExplicitTop = 197
    end
    object LabelText: TLabel
      Left = 45
      Top = 134
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object LabelCounter: TLabel
      Left = 72
      Top = 158
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object LabelRecipients: TLabel
      Left = 13
      Top = 69
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1080':'
      FocusControl = ListBoxRecipients
    end
    object LabelDateBegin: TLabel
      Left = 103
      Top = 234
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
      ExplicitTop = 245
    end
    object LabelDateEnd: TLabel
      Left = 85
      Top = 290
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
      ExplicitTop = 301
    end
    object LabelFirm: TLabel
      Left = 102
      Top = 372
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      ExplicitTop = 383
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 178
      Top = 396
      Width = 88
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 21
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 272
      Top = 396
      Width = 74
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 22
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 178
      Top = 315
      Width = 88
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 17
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 272
      Top = 315
      Width = 74
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 18
    end
    object ComboBoxType: TComboBox
      Left = 84
      Top = 12
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditCreator: TEdit
      Left = 178
      Top = 342
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 19
    end
    object ComboBoxPriority: TComboBox
      Left = 84
      Top = 39
      Width = 125
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        #1074#1099#1089#1086#1082#1080#1081
        #1086#1073#1099#1095#1085#1099#1081
        #1085#1080#1079#1082#1080#1081)
    end
    object MemoDescription: TMemo
      Left = 84
      Top = 186
      Width = 262
      Height = 40
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 9
    end
    object MemoText: TMemo
      Left = 84
      Top = 131
      Width = 262
      Height = 49
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 8
      OnChange = MemoTextChange
    end
    object ListBoxRecipients: TListBox
      Left = 84
      Top = 66
      Width = 236
      Height = 59
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 4
      OnKeyDown = ListBoxRecipientsKeyDown
    end
    object ButtonRecipientsAdd: TButton
      Left = 326
      Top = 66
      Width = 21
      Height = 21
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      Anchors = [akTop, akRight]
      Caption = '<'
      TabOrder = 5
      OnClick = ButtonRecipientsAddClick
    end
    object ButtonRecipientsDel: TButton
      Left = 326
      Top = 93
      Width = 21
      Height = 21
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      Anchors = [akTop, akRight]
      Caption = '>'
      TabOrder = 6
      OnClick = ButtonRecipientsDelClick
    end
    object ButtonPattern: TButton
      Left = 12
      Top = 131
      Width = 66
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1086#1074
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 7
      OnClick = ButtonPatternClick
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 178
      Top = 231
      Width = 88
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 272
      Top = 231
      Width = 74
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 178
      Top = 287
      Width = 88
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 15
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 272
      Top = 287
      Width = 74
      Height = 22
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 16
    end
    object CheckBoxFlash: TCheckBox
      Left = 263
      Top = 14
      Width = 61
      Height = 17
      Caption = #1060#1083#1077#1096
      TabOrder = 1
    end
    object CheckBoxDelivery: TCheckBox
      Left = 185
      Top = 14
      Width = 73
      Height = 17
      Caption = #1044#1086#1089#1090#1072#1074#1082#1072
      TabOrder = 2
    end
    object CheckBoxOffset: TCheckBox
      Left = 178
      Top = 261
      Width = 76
      Height = 18
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1084#1077#1097#1077#1085#1080#1077' '#1074' '#1089#1077#1082#1091#1085#1076#1072#1093' '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
      Anchors = [akRight, akBottom]
      Caption = #1057#1084#1077#1097#1077#1085#1080#1077':'
      TabOrder = 12
      OnClick = CheckBoxOffsetClick
    end
    object EditOffset: TEdit
      Left = 272
      Top = 259
      Width = 29
      Height = 21
      Anchors = [akRight, akBottom]
      ReadOnly = True
      TabOrder = 13
      Text = '10'
    end
    object UpDownOffset: TUpDown
      Left = 301
      Top = 259
      Width = 16
      Height = 21
      Anchors = [akRight, akBottom]
      Associate = EditOffset
      Min = 1
      Position = 10
      TabOrder = 14
    end
    object ComboBoxFirm: TComboBox
      Left = 178
      Top = 369
      Width = 168
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 20
    end
  end
  inherited ImageList: TImageList
    Left = 200
    Top = 120
  end
end
