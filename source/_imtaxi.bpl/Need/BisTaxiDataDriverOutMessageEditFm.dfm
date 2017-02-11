inherited BisTaxiDataDriverOutMessageEditForm: TBisTaxiDataDriverOutMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataDriverOutMessageEditForm'
  ClientHeight = 414
  ClientWidth = 359
  ExplicitWidth = 367
  ExplicitHeight = 448
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 376
    Width = 359
    ExplicitTop = 376
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
    Height = 376
    ExplicitWidth = 359
    ExplicitHeight = 376
    DesignSize = (
      359
      376)
    object LabelRecipient: TLabel
      Left = 26
      Top = 69
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditRecipient
    end
    object LabelDateCreate: TLabel
      Left = 94
      Top = 345
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitLeft = 91
    end
    object LabelDateOut: TLabel
      Left = 93
      Top = 291
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerOut
      ExplicitLeft = 90
    end
    object LabelType: TLabel
      Left = 57
      Top = 15
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxType
      Transparent = True
    end
    object LabelContact: TLabel
      Left = 32
      Top = 96
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1090#1072#1082#1090':'
      FocusControl = EditContact
    end
    object LabelCreator: TLabel
      Left = 113
      Top = 318
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
      ExplicitLeft = 110
    end
    object LabelPriority: TLabel
      Left = 20
      Top = 42
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
      FocusControl = ComboBoxPriority
      Transparent = True
    end
    object LabelDescription: TLabel
      Left = 14
      Top = 181
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelCounter: TLabel
      Left = 73
      Top = 147
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object LabelDateBegin: TLabel
      Left = 105
      Top = 237
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
      ExplicitLeft = 102
    end
    object LabelDateEnd: TLabel
      Left = 87
      Top = 264
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
      ExplicitLeft = 84
    end
    object EditRecipient: TEdit
      Left = 85
      Top = 66
      Width = 157
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 180
      Top = 342
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 17
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 274
      Top = 342
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 18
    end
    object ButtonRecipient: TButton
      Left = 248
      Top = 66
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 5
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 180
      Top = 288
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 14
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 274
      Top = 288
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 15
    end
    object ComboBoxType: TComboBox
      Left = 85
      Top = 12
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditContact: TEdit
      Left = 85
      Top = 93
      Width = 184
      Height = 21
      MaxLength = 100
      TabOrder = 6
    end
    object EditCreator: TEdit
      Left = 180
      Top = 315
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 16
    end
    object ComboBoxPriority: TComboBox
      Left = 85
      Top = 39
      Width = 125
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
      Left = 85
      Top = 178
      Width = 263
      Height = 50
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 9
    end
    object MemoText: TMemo
      Left = 85
      Top = 120
      Width = 263
      Height = 52
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 8
      OnChange = MemoTextChange
    end
    object ButtonPattern: TButton
      Left = 13
      Top = 120
      Width = 66
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 7
      OnClick = ButtonPatternClick
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 180
      Top = 234
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 274
      Top = 234
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 180
      Top = 261
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 274
      Top = 261
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
  end
  inherited ImageList: TImageList
    Left = 40
    Top = 248
  end
end
