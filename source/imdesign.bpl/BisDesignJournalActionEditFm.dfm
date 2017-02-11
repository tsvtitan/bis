inherited BisDesignJournalActionEditForm: TBisDesignJournalActionEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignJournalActionEditForm'
  ClientHeight = 426
  ClientWidth = 407
  ExplicitWidth = 415
  ExplicitHeight = 460
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 388
    Width = 407
    ExplicitTop = 388
    ExplicitWidth = 407
    inherited ButtonOk: TButton
      Left = 227
      ExplicitLeft = 227
    end
    inherited ButtonCancel: TButton
      Left = 324
      ExplicitLeft = 324
    end
  end
  inherited PanelControls: TPanel
    Width = 407
    Height = 388
    ExplicitWidth = 407
    ExplicitHeight = 388
    object LabelAccount: TLabel
      Left = 13
      Top = 94
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelApplication: TLabel
      Left = 30
      Top = 67
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
      FocusControl = EditApplication
    end
    object LabelModule: TLabel
      Left = 54
      Top = 121
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1086#1076#1091#1083#1100':'
      FocusControl = EditModule
    end
    object LabelObject: TLabel
      Left = 54
      Top = 148
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1073#1098#1077#1082#1090':'
      FocusControl = EditObject
    end
    object LabelMethod: TLabel
      Left = 60
      Top = 175
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1077#1090#1086#1076':'
      FocusControl = EditMethod
    end
    object LabelParam: TLabel
      Left = 44
      Top = 202
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelValue: TLabel
      Left = 45
      Top = 226
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077':'
      FocusControl = MemoValue
    end
    object LabelType: TLabel
      Left = 24
      Top = 40
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1076#1077#1081#1089#1090#1074#1080#1103':'
      FocusControl = ComboBoxType
    end
    object LabelDate: TLabel
      Left = 16
      Top = 13
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074#1080#1103':'
      FocusControl = DateTimePicker
    end
    object EditAccount: TEdit
      Left = 103
      Top = 91
      Width = 167
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
    object ButtonAccount: TButton
      Left = 276
      Top = 91
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 6
    end
    object EditApplication: TEdit
      Left = 103
      Top = 64
      Width = 167
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object ButtonApplication: TButton
      Left = 276
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = '...'
      TabOrder = 4
    end
    object EditModule: TEdit
      Left = 103
      Top = 118
      Width = 240
      Height = 21
      TabOrder = 7
    end
    object EditObject: TEdit
      Left = 103
      Top = 145
      Width = 240
      Height = 21
      TabOrder = 8
    end
    object EditMethod: TEdit
      Left = 103
      Top = 172
      Width = 240
      Height = 21
      TabOrder = 9
    end
    object EditParam: TEdit
      Left = 103
      Top = 199
      Width = 240
      Height = 21
      TabOrder = 10
    end
    object MemoValue: TMemo
      Left = 103
      Top = 226
      Width = 292
      Height = 156
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 11
      WordWrap = False
    end
    object ComboBoxType: TComboBox
      Left = 103
      Top = 37
      Width = 167
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 2
    end
    object DateTimePicker: TDateTimePicker
      Left = 103
      Top = 10
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 0
    end
    object DateTimePickerTime: TDateTimePicker
      Left = 197
      Top = 10
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 1
    end
  end
end
