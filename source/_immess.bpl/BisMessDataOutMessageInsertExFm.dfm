inherited BisMessDataOutMessageInsertExForm: TBisMessDataOutMessageInsertExForm
  Left = 513
  Top = 212
  Caption = 'BisMessDataOutMessageInsertExForm'
  ClientHeight = 409
  ClientWidth = 359
  ExplicitWidth = 367
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 371
    Width = 359
    ExplicitTop = 371
    ExplicitWidth = 376
    DesignSize = (
      359
      38)
    inherited ButtonOk: TButton
      Left = 180
      ExplicitLeft = 197
    end
    inherited ButtonCancel: TButton
      Left = 276
      ExplicitLeft = 293
    end
  end
  inherited PanelControls: TPanel
    Width = 359
    Height = 371
    ExplicitWidth = 376
    ExplicitHeight = 371
    DesignSize = (
      359
      371)
    object LabelDateCreate: TLabel
      Left = 92
      Top = 342
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitLeft = 109
      ExplicitTop = 368
    end
    object LabelDateOut: TLabel
      Left = 91
      Top = 288
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerOut
      ExplicitLeft = 108
      ExplicitTop = 314
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
      Top = 315
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
      ExplicitLeft = 128
      ExplicitTop = 341
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
      Left = 13
      Top = 175
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelText: TLabel
      Left = 45
      Top = 123
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object LabelCounter: TLabel
      Left = 72
      Top = 147
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
      Top = 233
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
      ExplicitLeft = 120
      ExplicitTop = 259
    end
    object LabelDateEnd: TLabel
      Left = 85
      Top = 260
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
      ExplicitLeft = 102
      ExplicitTop = 286
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 178
      Top = 339
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 15
      ExplicitLeft = 195
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 272
      Top = 339
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 16
      ExplicitLeft = 289
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 178
      Top = 285
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
      ExplicitLeft = 195
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 272
      Top = 285
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 13
      ExplicitLeft = 289
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
      Top = 312
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 14
      ExplicitLeft = 195
    end
    object ComboBoxPriority: TComboBox
      Left = 84
      Top = 39
      Width = 125
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        #1074#1099#1089#1086#1082#1080#1081
        #1086#1073#1099#1095#1085#1099#1081
        #1085#1080#1079#1082#1080#1081)
    end
    object MemoDescription: TMemo
      Left = 84
      Top = 174
      Width = 262
      Height = 50
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 7
      ExplicitWidth = 279
    end
    object MemoText: TMemo
      Left = 84
      Top = 120
      Width = 262
      Height = 48
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 6
      OnChange = MemoTextChange
      ExplicitWidth = 279
    end
    object ListBoxRecipients: TListBox
      Left = 84
      Top = 66
      Width = 236
      Height = 48
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 2
      OnKeyDown = ListBoxRecipientsKeyDown
    end
    object ButtonRecipientsAdd: TButton
      Left = 326
      Top = 66
      Width = 21
      Height = 21
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      Caption = '<'
      TabOrder = 3
      OnClick = ButtonRecipientsAddClick
    end
    object ButtonRecipientsDel: TButton
      Left = 326
      Top = 93
      Width = 21
      Height = 21
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
      Caption = '>'
      TabOrder = 4
      OnClick = ButtonRecipientsDelClick
    end
    object ButtonPattern: TButton
      Left = 12
      Top = 120
      Width = 66
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1086#1074
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 5
      OnClick = ButtonPatternClick
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 178
      Top = 230
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 8
      ExplicitLeft = 195
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 272
      Top = 230
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
      ExplicitLeft = 289
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 178
      Top = 257
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
      ExplicitLeft = 195
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 272
      Top = 257
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
      ExplicitLeft = 289
    end
  end
  inherited ImageList: TImageList
    Left = 200
    Top = 120
  end
end
