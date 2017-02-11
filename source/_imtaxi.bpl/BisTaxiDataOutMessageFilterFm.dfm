inherited BisTaxiDataOutMessageFilterForm: TBisTaxiDataOutMessageFilterForm
  Caption = 'BisTaxiDataOutMessageFilterForm'
  ClientHeight = 424
  ClientWidth = 524
  ExplicitWidth = 532
  ExplicitHeight = 458
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 386
    Width = 524
    ExplicitTop = 386
    ExplicitWidth = 524
    inherited ButtonOk: TButton
      Left = 345
      ExplicitLeft = 345
    end
    inherited ButtonCancel: TButton
      Left = 441
      ExplicitLeft = 441
    end
  end
  inherited PanelControls: TPanel
    Width = 524
    Height = 386
    ExplicitWidth = 524
    ExplicitHeight = 386
    inherited LabelRecipient: TLabel
      Left = 33
      Top = 41
      ExplicitLeft = 33
      ExplicitTop = 41
    end
    inherited LabelDateCreate: TLabel
      Left = 21
      Top = 349
      Width = 88
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1089':'
      ExplicitLeft = 10
      ExplicitTop = 349
      ExplicitWidth = 88
    end
    inherited LabelDateOut: TLabel
      Left = 20
      Top = 268
      Width = 89
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1089':'
      ExplicitLeft = 9
      ExplicitTop = 268
      ExplicitWidth = 89
    end
    inherited LabelType: TLabel
      Left = 76
      Top = 14
      ExplicitLeft = 76
      ExplicitTop = 14
    end
    inherited LabelContact: TLabel
      Left = 51
      Top = 68
      ExplicitLeft = 51
      ExplicitTop = 68
    end
    inherited LabelCreator: TLabel
      Left = 48
      Top = 295
      ExplicitLeft = 37
      ExplicitTop = 295
    end
    inherited LabelPriority: TLabel
      Left = 202
      Top = 14
      ExplicitLeft = 202
      ExplicitTop = 14
    end
    inherited LabelDescription: TLabel
      Left = 45
      Top = 155
      ExplicitLeft = 45
      ExplicitTop = 183
    end
    inherited LabelCounter: TLabel
      Left = 92
      Top = 119
      ExplicitLeft = 92
      ExplicitTop = 119
    end
    object LabelDateOutTo: TLabel [9]
      Left = 294
      Top = 268
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerOutTo
      ExplicitLeft = 283
      ExplicitTop = 296
    end
    object LabelDateCreateTo: TLabel [10]
      Left = 294
      Top = 349
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerCreateTo
      ExplicitLeft = 283
      ExplicitTop = 377
    end
    inherited LabelDateBegin: TLabel
      Left = 32
      Top = 214
      Width = 77
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1089':'
      ExplicitLeft = 21
      ExplicitTop = 214
      ExplicitWidth = 77
    end
    inherited LabelDateEnd: TLabel
      Left = 14
      Top = 241
      Width = 95
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089':'
      ExplicitLeft = 3
      ExplicitTop = 241
      ExplicitWidth = 95
    end
    object LabelDateEndTo: TLabel [13]
      Left = 294
      Top = 241
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerEndTo
      ExplicitLeft = 283
      ExplicitTop = 269
    end
    object LabelDateBeginTo: TLabel [14]
      Left = 294
      Top = 214
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerBeginTo
      ExplicitLeft = 283
      ExplicitTop = 242
    end
    inherited LabelFirm: TLabel
      Left = 39
      Top = 322
      ExplicitLeft = 28
      ExplicitTop = 350
    end
    inherited EditRecipient: TEdit
      Left = 104
      Top = 38
      ExplicitLeft = 104
      ExplicitTop = 38
    end
    inherited DateTimePickerCreate: TDateTimePicker
      Left = 115
      Top = 346
      TabOrder = 26
      ExplicitLeft = 115
      ExplicitTop = 346
    end
    inherited DateTimePickerCreateTime: TDateTimePicker
      Left = 209
      Top = 346
      TabOrder = 27
      ExplicitLeft = 209
      ExplicitTop = 346
    end
    inherited ButtonRecipient: TButton
      Left = 347
      Top = 38
      ExplicitLeft = 347
      ExplicitTop = 38
    end
    inherited DateTimePickerOut: TDateTimePicker
      Left = 115
      Top = 265
      TabOrder = 32
      ExplicitLeft = 115
      ExplicitTop = 265
    end
    inherited DateTimePickerOutTime: TDateTimePicker
      Left = 209
      Top = 265
      TabOrder = 19
      ExplicitLeft = 209
      ExplicitTop = 265
    end
    inherited ComboBoxType: TComboBox
      Left = 104
      Top = 11
      Width = 89
      ExplicitLeft = 104
      ExplicitTop = 11
      ExplicitWidth = 89
    end
    inherited EditContact: TEdit
      Left = 104
      Top = 65
      ExplicitLeft = 104
      ExplicitTop = 65
    end
    inherited EditCreator: TEdit
      Left = 115
      Top = 292
      Width = 369
      TabOrder = 23
      ExplicitLeft = 115
      ExplicitTop = 292
      ExplicitWidth = 369
    end
    inherited ComboBoxPriority: TComboBox
      Left = 267
      Top = 11
      Width = 102
      ExplicitLeft = 267
      ExplicitTop = 11
      ExplicitWidth = 102
    end
    inherited MemoDescription: TMemo
      Left = 104
      Top = 155
      Width = 407
      ExplicitLeft = 104
      ExplicitTop = 155
      ExplicitWidth = 407
    end
    inherited MemoText: TMemo
      Left = 104
      Top = 92
      Width = 407
      Height = 57
      ExplicitLeft = 104
      ExplicitTop = 92
      ExplicitWidth = 407
      ExplicitHeight = 57
    end
    inherited ButtonPattern: TButton
      Left = 32
      Top = 92
      ExplicitLeft = 32
      ExplicitTop = 92
    end
    inherited DateTimePickerBegin: TDateTimePicker
      Left = 115
      Top = 211
      ExplicitLeft = 115
      ExplicitTop = 211
    end
    inherited DateTimePickerBeginTime: TDateTimePicker
      Left = 209
      Top = 211
      ExplicitLeft = 209
      ExplicitTop = 211
    end
    inherited DateTimePickerEnd: TDateTimePicker
      Left = 115
      Top = 238
      TabOrder = 14
      ExplicitLeft = 115
      ExplicitTop = 238
    end
    inherited DateTimePickerEndTime: TDateTimePicker
      Left = 209
      Top = 238
      TabOrder = 15
      ExplicitLeft = 209
      ExplicitTop = 238
    end
    inherited CheckBoxDelivery: TCheckBox
      Left = 376
      Top = 13
      Width = 72
      TabOrder = 25
      Visible = False
      ExplicitLeft = 376
      ExplicitTop = 13
      ExplicitWidth = 72
    end
    inherited CheckBoxFlash: TCheckBox
      Left = 453
      Top = 13
      Width = 51
      Visible = False
      ExplicitLeft = 453
      ExplicitTop = 13
      ExplicitWidth = 51
    end
    inherited ComboBoxFirm: TComboBox
      Left = 115
      Top = 319
      Width = 396
      TabOrder = 31
      ExplicitLeft = 115
      ExplicitTop = 319
      ExplicitWidth = 396
    end
    object ButtonCreator: TButton
      Left = 490
      Top = 292
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 24
    end
    object DateTimePickerOutTo: TDateTimePicker
      Left = 316
      Top = 265
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 20
    end
    object DateTimePickerOutToTime: TDateTimePicker
      Left = 410
      Top = 265
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 21
    end
    object DateTimePickerCreateTo: TDateTimePicker
      Left = 316
      Top = 346
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 28
    end
    object DateTimePickerCreateToTime: TDateTimePicker
      Left = 410
      Top = 346
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 29
    end
    object ButtonCreateTo: TButton
      Left = 490
      Top = 346
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 30
      OnClick = ButtonCreateToClick
    end
    object ButtonDateOut: TButton
      Left = 490
      Top = 265
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 22
      OnClick = ButtonDateOutClick
    end
    object DateTimePickerEndTo: TDateTimePicker
      Left = 316
      Top = 238
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 16
    end
    object DateTimePickerEndToTime: TDateTimePicker
      Left = 410
      Top = 238
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 17
    end
    object ButtonDateEnd: TButton
      Left = 490
      Top = 238
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 18
      OnClick = ButtonDateEndClick
    end
    object DateTimePickerBeginTo: TDateTimePicker
      Left = 316
      Top = 211
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 1
    end
    object DateTimePickerBeginToTime: TDateTimePicker
      Left = 410
      Top = 211
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 12
    end
    object ButtonDateBegin: TButton
      Left = 490
      Top = 211
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 13
      OnClick = ButtonDateBeginClick
    end
  end
  inherited ImageList: TImageList
    Left = 184
    Top = 64
  end
  inherited PopupAccount: TPopupActionBar
    Left = 248
    Top = 48
  end
end
