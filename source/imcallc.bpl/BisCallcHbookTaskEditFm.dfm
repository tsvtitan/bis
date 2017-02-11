inherited BisCallcHbookTaskEditForm: TBisCallcHbookTaskEditForm
  Left = 440
  Top = 228
  Caption = 'BisCallcHbookTaskEditForm'
  ClientHeight = 363
  ClientWidth = 372
  ExplicitLeft = 440
  ExplicitTop = 228
  ExplicitWidth = 380
  ExplicitHeight = 390
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 325
    Width = 372
    ExplicitTop = 307
    ExplicitWidth = 580
    inherited ButtonOk: TButton
      Left = 195
      ExplicitLeft = 403
    end
    inherited ButtonCancel: TButton
      Left = 292
      ExplicitLeft = 500
    end
  end
  inherited PanelControls: TPanel
    Width = 372
    Height = 325
    ExplicitWidth = 580
    ExplicitHeight = 307
    object LabelResult: TLabel
      Left = 52
      Top = 300
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
      FocusControl = ComboBoxResult
    end
    object LabelDeal: TLabel
      Left = 23
      Top = 16
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1088#1077#1076#1080#1090#1085#1086#1077' '#1076#1077#1083#1086':'
      FocusControl = EditDeal
    end
    object LabelAction: TLabel
      Left = 54
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelAccount: TLabel
      Left = 33
      Top = 124
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1090#1086' '#1074#1099#1087#1086#1083#1085#1080#1083':'
      FocusControl = EditAccount
    end
    object LabelDateCreate: TLabel
      Left = 27
      Top = 70
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object LabelDateBegin: TLabel
      Left = 40
      Top = 97
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 22
      Top = 178
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelDescription: TLabel
      Left = 34
      Top = 205
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
      FocusControl = MemoDescription
    end
    object LabelPerformer: TLabel
      Left = 12
      Top = 151
      Width = 95
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1072' '#1082#1086#1075#1086' '#1074#1099#1087#1086#1083#1085#1080#1083':'
      FocusControl = EditPerformer
    end
    object ComboBoxResult: TComboBox
      Left = 113
      Top = 297
      Width = 221
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      Sorted = True
      TabOrder = 13
    end
    object ButtonResult: TButton
      Left = 340
      Top = 297
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 14
    end
    object EditDeal: TEdit
      Left = 113
      Top = 13
      Width = 113
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonDeal: TButton
      Left = 232
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1082#1088#1077#1076#1080#1090#1085#1086#1077' '#1076#1077#1083#1086
      Caption = '...'
      TabOrder = 1
    end
    object EditAction: TEdit
      Left = 113
      Top = 40
      Width = 140
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAction: TButton
      Left = 259
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Caption = '...'
      TabOrder = 3
    end
    object EditAccount: TEdit
      Left = 113
      Top = 121
      Width = 140
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 8
    end
    object ButtonAccount: TButton
      Left = 259
      Top = 121
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 9
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 113
      Top = 67
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 4
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 113
      Top = 94
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 6
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 113
      Top = 175
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 10
    end
    object MemoDescription: TMemo
      Left = 113
      Top = 202
      Width = 248
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 12
    end
    object DateTimePickerTimeCreate: TDateTimePicker
      Left = 207
      Top = 67
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 5
    end
    object DateTimePickerTimeBegin: TDateTimePicker
      Left = 207
      Top = 94
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 7
    end
    object DateTimePickerTimeEnd: TDateTimePicker
      Left = 207
      Top = 175
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object EditPerformer: TEdit
      Left = 113
      Top = 148
      Width = 140
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 15
    end
    object ButtonPerformer: TButton
      Left = 259
      Top = 148
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 16
    end
  end
end
