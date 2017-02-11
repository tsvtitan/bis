inherited BisKrieltPresentationEditForm: TBisKrieltPresentationEditForm
  Left = 527
  Top = 191
  Caption = 'BisKrieltPresentationEditForm'
  ClientHeight = 373
  ClientWidth = 358
  ExplicitWidth = 366
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 335
    Width = 358
    ExplicitTop = 335
    ExplicitWidth = 358
    inherited ButtonOk: TButton
      Left = 179
      ExplicitLeft = 179
    end
    inherited ButtonCancel: TButton
      Left = 276
      ExplicitLeft = 276
    end
  end
  inherited PanelControls: TPanel
    Width = 358
    Height = 335
    ExplicitWidth = 358
    ExplicitHeight = 335
    object LabelDateBegin: TLabel
      Left = 27
      Top = 17
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1089':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 20
      Top = 44
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1086':'
      FocusControl = DateTimePickerEnd
    end
    object LabelAccount: TLabel
      Left = 20
      Top = 71
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelPhone: TLabel
      Left = 56
      Top = 98
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 110
      Top = 14
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 0
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 110
      Top = 41
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 3
    end
    object EditAccount: TEdit
      Left = 110
      Top = 68
      Width = 199
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
    object ButtonAccount: TButton
      Left = 315
      Top = 68
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100')'
      Caption = '...'
      TabOrder = 6
    end
    object DateTimePickerTimeBegin: TDateTimePicker
      Left = 204
      Top = 14
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 1
    end
    object DateTimePickerTimeEnd: TDateTimePicker
      Left = 204
      Top = 41
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 4
    end
    object ScrollBox: TScrollBox
      Left = 13
      Top = 122
      Width = 340
      Height = 207
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      TabOrder = 8
    end
    object EditPhone: TEdit
      Left = 110
      Top = 95
      Width = 226
      Height = 21
      TabOrder = 7
    end
    object ButtonIssue: TButton
      Left = 283
      Top = 14
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1099#1087#1091#1089#1082
      Caption = '...'
      TabOrder = 2
      OnClick = ButtonIssueClick
    end
  end
end
