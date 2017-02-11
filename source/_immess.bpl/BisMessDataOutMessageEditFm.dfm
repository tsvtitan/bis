inherited BisMessDataOutMessageEditForm: TBisMessDataOutMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisMessDataOutMessageEditForm'
  ClientHeight = 414
  ClientWidth = 363
  ExplicitWidth = 371
  ExplicitHeight = 448
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 376
    Width = 363
    ExplicitTop = 376
    ExplicitWidth = 357
    DesignSize = (
      363
      38)
    inherited ButtonOk: TButton
      Left = 184
      ExplicitLeft = 178
    end
    inherited ButtonCancel: TButton
      Left = 280
      ExplicitLeft = 274
    end
  end
  inherited PanelControls: TPanel
    Width = 363
    Height = 376
    ExplicitWidth = 357
    ExplicitHeight = 376
    DesignSize = (
      363
      376)
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
      Top = 345
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
      ExplicitLeft = 79
    end
    object LabelDateOut: TLabel
      Left = 95
      Top = 291
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerOut
      ExplicitLeft = 78
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
      Top = 318
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditCreator
      ExplicitLeft = 98
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
      Left = 15
      Top = 181
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077':'
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
      Top = 237
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
      ExplicitLeft = 90
    end
    object LabelDateEnd: TLabel
      Left = 89
      Top = 264
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
      ExplicitLeft = 72
    end
    object EditRecipient: TEdit
      Left = 86
      Top = 66
      Width = 157
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 182
      Top = 342
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 15
      ExplicitLeft = 176
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 276
      Top = 342
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 16
      ExplicitLeft = 270
    end
    object ButtonRecipient: TButton
      Left = 249
      Top = 66
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 3
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 182
      Top = 288
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 12
      ExplicitLeft = 176
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 276
      Top = 288
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 13
      ExplicitLeft = 270
    end
    object ComboBoxType: TComboBox
      Left = 86
      Top = 12
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditContact: TEdit
      Left = 86
      Top = 93
      Width = 184
      Height = 21
      MaxLength = 100
      TabOrder = 4
    end
    object EditCreator: TEdit
      Left = 182
      Top = 315
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      MaxLength = 100
      TabOrder = 14
      ExplicitLeft = 176
    end
    object ComboBoxPriority: TComboBox
      Left = 86
      Top = 39
      Width = 125
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        #1074#1099#1089#1086#1082#1080#1081
        #1085#1086#1088#1084#1072#1083#1100#1085#1099#1081
        #1085#1080#1079#1082#1080#1081)
    end
    object MemoDescription: TMemo
      Left = 86
      Top = 178
      Width = 264
      Height = 50
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 7
    end
    object MemoText: TMemo
      Left = 86
      Top = 120
      Width = 264
      Height = 52
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 6
      OnChange = MemoTextChange
    end
    object ButtonPattern: TButton
      Left = 14
      Top = 120
      Width = 66
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1096#1072#1073#1083#1086#1085
      Caption = #1058#1077#1082#1089#1090
      TabOrder = 5
      OnClick = ButtonPatternClick
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 182
      Top = 234
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 8
      ExplicitLeft = 176
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 276
      Top = 234
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
      ExplicitLeft = 270
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 182
      Top = 261
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
      ExplicitLeft = 176
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 276
      Top = 261
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
      ExplicitLeft = 270
    end
  end
  inherited ImageList: TImageList
    Left = 40
    Top = 248
  end
end