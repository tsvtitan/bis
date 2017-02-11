inherited BisTaxiDataDriverOutMessageFilterForm: TBisTaxiDataDriverOutMessageFilterForm
  Caption = 'BisTaxiDataDriverOutMessageFilterForm'
  ClientHeight = 430
  ClientWidth = 536
  ExplicitWidth = 544
  ExplicitHeight = 464
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 392
    Width = 536
    ExplicitTop = 392
    ExplicitWidth = 536
    DesignSize = (
      536
      38)
    inherited ButtonOk: TButton
      Left = 357
      ExplicitLeft = 357
    end
    inherited ButtonCancel: TButton
      Left = 453
      ExplicitLeft = 453
    end
  end
  inherited PanelControls: TPanel
    Width = 536
    Height = 392
    ExplicitWidth = 536
    ExplicitHeight = 392
    DesignSize = (
      536
      392)
    inherited LabelRecipient: TLabel
      Left = 33
      Top = 41
      ExplicitLeft = 33
      ExplicitTop = 41
    end
    inherited LabelDateCreate: TLabel
      Left = 41
      Top = 360
      ExplicitLeft = 18
      ExplicitTop = 369
    end
    inherited LabelDateOut: TLabel
      Left = 40
      Top = 279
      ExplicitLeft = 17
      ExplicitTop = 288
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
      Left = 60
      Top = 306
      ExplicitLeft = 37
      ExplicitTop = 315
    end
    inherited LabelPriority: TLabel
      Left = 202
      Top = 14
      ExplicitLeft = 202
      ExplicitTop = 14
    end
    inherited LabelDescription: TLabel
      Left = 45
      Top = 167
      ExplicitLeft = 45
      ExplicitTop = 176
    end
    inherited LabelCounter: TLabel
      Left = 92
      Top = 119
      ExplicitLeft = 92
      ExplicitTop = 119
    end
    object LabelDateOutTo: TLabel [9]
      Left = 306
      Top = 279
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerOutTo
      ExplicitLeft = 283
      ExplicitTop = 288
    end
    object LabelDateCreateTo: TLabel [10]
      Left = 306
      Top = 360
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerCreateTo
      ExplicitLeft = 283
      ExplicitTop = 369
    end
    inherited LabelDateBegin: TLabel
      Left = 52
      Top = 225
      ExplicitLeft = 29
      ExplicitTop = 234
    end
    inherited LabelDateEnd: TLabel
      Left = 34
      Top = 252
      ExplicitLeft = 11
      ExplicitTop = 261
    end
    object LabelDateEndTo: TLabel [13]
      Left = 306
      Top = 252
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerEndTo
      ExplicitLeft = 283
      ExplicitTop = 261
    end
    object LabelDateBeginTo: TLabel [14]
      Left = 306
      Top = 225
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerBeginTo
      ExplicitLeft = 283
      ExplicitTop = 234
    end
    inherited LabelFirm: TLabel
      Left = 51
      Top = 333
      ExplicitLeft = 28
      ExplicitTop = 333
    end
    inherited EditRecipient: TEdit
      Left = 104
      Top = 38
      Width = 261
      ExplicitLeft = 104
      ExplicitTop = 38
      ExplicitWidth = 261
    end
    inherited DateTimePickerCreate: TDateTimePicker
      Left = 127
      Top = 357
      TabOrder = 28
      ExplicitLeft = 127
      ExplicitTop = 357
    end
    inherited DateTimePickerCreateTime: TDateTimePicker
      Left = 221
      Top = 357
      TabOrder = 29
      ExplicitLeft = 221
      ExplicitTop = 357
    end
    inherited ButtonRecipient: TButton
      Left = 371
      Top = 38
      ExplicitLeft = 371
      ExplicitTop = 38
    end
    inherited DateTimePickerOut: TDateTimePicker
      Left = 127
      Top = 276
      TabOrder = 20
      ExplicitLeft = 127
      ExplicitTop = 276
    end
    inherited DateTimePickerOutTime: TDateTimePicker
      Left = 221
      Top = 276
      TabOrder = 21
      ExplicitLeft = 221
      ExplicitTop = 276
    end
    inherited ComboBoxType: TComboBox
      Left = 104
      Top = 11
      ExplicitLeft = 104
      ExplicitTop = 11
    end
    inherited EditContact: TEdit
      Left = 104
      Top = 65
      Width = 288
      ExplicitLeft = 104
      ExplicitTop = 65
      ExplicitWidth = 288
    end
    inherited EditCreator: TEdit
      Left = 127
      Top = 303
      Width = 369
      TabOrder = 25
      ExplicitLeft = 127
      ExplicitTop = 303
      ExplicitWidth = 369
    end
    inherited ComboBoxPriority: TComboBox
      Left = 267
      Top = 11
      Width = 125
      ExplicitLeft = 267
      ExplicitTop = 11
      ExplicitWidth = 125
    end
    inherited MemoDescription: TMemo
      Left = 104
      Top = 166
      Width = 419
      ExplicitLeft = 104
      ExplicitTop = 166
      ExplicitWidth = 419
    end
    inherited MemoText: TMemo
      Left = 104
      Top = 92
      Width = 419
      Height = 68
      ExplicitLeft = 104
      ExplicitTop = 92
      ExplicitWidth = 419
      ExplicitHeight = 68
    end
    inherited ButtonPattern: TButton
      Left = 32
      Top = 92
      ExplicitLeft = 32
      ExplicitTop = 92
    end
    inherited DateTimePickerBegin: TDateTimePicker
      Left = 127
      Top = 222
      ExplicitLeft = 127
      ExplicitTop = 222
    end
    inherited DateTimePickerBeginTime: TDateTimePicker
      Left = 221
      Top = 222
      ExplicitLeft = 221
      ExplicitTop = 222
    end
    inherited DateTimePickerEnd: TDateTimePicker
      Left = 127
      Top = 249
      TabOrder = 15
      ExplicitLeft = 127
      ExplicitTop = 249
    end
    inherited DateTimePickerEndTime: TDateTimePicker
      Left = 221
      Top = 249
      TabOrder = 16
      ExplicitLeft = 221
      ExplicitTop = 249
    end
    inherited CheckBoxDelivery: TCheckBox
      Left = 398
      Top = 13
      Visible = False
      ExplicitLeft = 398
      ExplicitTop = 13
    end
    inherited CheckBoxFlash: TCheckBox
      Left = 476
      Top = 13
      Visible = False
      ExplicitLeft = 476
      ExplicitTop = 13
    end
    inherited ComboBoxFirm: TComboBox
      Left = 127
      Top = 330
      Width = 396
      Anchors = [akRight, akBottom]
      TabOrder = 27
      ExplicitLeft = 127
      ExplicitTop = 330
      ExplicitWidth = 396
    end
    object ButtonCreator: TButton
      Left = 502
      Top = 303
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 26
    end
    object DateTimePickerOutTo: TDateTimePicker
      Left = 328
      Top = 276
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 22
    end
    object DateTimePickerOutToTime: TDateTimePicker
      Left = 422
      Top = 276
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 23
    end
    object DateTimePickerCreateTo: TDateTimePicker
      Left = 328
      Top = 357
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 30
    end
    object DateTimePickerCreateToTime: TDateTimePicker
      Left = 422
      Top = 357
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 32
    end
    object ButtonCreateTo: TButton
      Left = 502
      Top = 357
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 31
      OnClick = ButtonCreateToClick
    end
    object ButtonDateOut: TButton
      Left = 502
      Top = 276
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 24
      OnClick = ButtonDateOutClick
    end
    object DateTimePickerEndTo: TDateTimePicker
      Left = 328
      Top = 249
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 17
    end
    object DateTimePickerEndToTime: TDateTimePicker
      Left = 422
      Top = 249
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 18
    end
    object ButtonDateEnd: TButton
      Left = 502
      Top = 249
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 19
      OnClick = ButtonDateEndClick
    end
    object DateTimePickerBeginTo: TDateTimePicker
      Left = 328
      Top = 222
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
    end
    object DateTimePickerBeginToTime: TDateTimePicker
      Left = 422
      Top = 222
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 13
    end
    object ButtonDateBegin: TButton
      Left = 502
      Top = 222
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 14
      OnClick = ButtonDateBeginClick
    end
  end
  inherited ImageList: TImageList
    Left = 184
    Top = 64
  end
  inherited PopupAccount: TPopupActionBar
    Left = 128
    Top = 120
  end
end
