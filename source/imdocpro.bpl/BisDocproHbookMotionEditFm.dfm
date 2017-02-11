inherited BisDocproHbookMotionEditForm: TBisDocproHbookMotionEditForm
  Left = 657
  Top = 294
  Caption = 'BisDocproHbookMotionEditForm'
  ClientHeight = 297
  ClientWidth = 368
  ExplicitLeft = 657
  ExplicitTop = 294
  ExplicitWidth = 376
  ExplicitHeight = 324
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 259
    Width = 368
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 191
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 288
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 368
    Height = 259
    ExplicitLeft = -24
    ExplicitTop = 1
    ExplicitWidth = 319
    ExplicitHeight = 259
    object LabelDescription: TLabel
      Left = 51
      Top = 150
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelDoc: TLabel
      Left = 50
      Top = 42
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090':'
      FocusControl = EditDoc
    end
    object LabelPosition: TLabel
      Left = 57
      Top = 15
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1079#1080#1094#1080#1103':'
      FocusControl = EditPosition
    end
    object LabelDateIssue: TLabel
      Left = 26
      Top = 70
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080':'
      FocusControl = DateTimePickerDateIssue
    end
    object LabelAccount: TLabel
      Left = 31
      Top = 96
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1090#1086' '#1074#1099#1087#1086#1083#1085#1080#1083':'
      FocusControl = EditAccount
    end
    object LabelDateProcess: TLabel
      Left = 11
      Top = 124
      Width = 94
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103':'
      FocusControl = DateTimePickerDateProcess
    end
    object MemoDescription: TMemo
      Left = 110
      Top = 147
      Width = 244
      Height = 102
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 10
      ExplicitWidth = 195
    end
    object EditDoc: TEdit
      Left = 110
      Top = 39
      Width = 217
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonDoc: TButton
      Left = 333
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Caption = '...'
      TabOrder = 3
    end
    object EditPosition: TEdit
      Left = 110
      Top = 12
      Width = 89
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonPosition: TButton
      Left = 205
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1079#1080#1094#1080#1102' '#1087#1083#1072#1085#1072
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerDateIssue: TDateTimePicker
      Left = 111
      Top = 66
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 4
    end
    object DateTimePickerTimeIssue: TDateTimePicker
      Left = 205
      Top = 66
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 5
    end
    object EditAccount: TEdit
      Left = 111
      Top = 93
      Width = 140
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonAccount: TButton
      Left = 257
      Top = 93
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 7
    end
    object DateTimePickerDateProcess: TDateTimePicker
      Left = 111
      Top = 120
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 8
    end
    object DateTimePickerTimeProcess: TDateTimePicker
      Left = 205
      Top = 120
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
    end
  end
end
