inherited BisKrieltObjectParamEditForm: TBisKrieltObjectParamEditForm
  Left = 721
  Top = 256
  Caption = 'BisKrieltObjectParamEditForm'
  ClientHeight = 257
  ClientWidth = 302
  ExplicitWidth = 310
  ExplicitHeight = 291
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 219
    Width = 302
    ExplicitTop = 219
    ExplicitWidth = 302
    inherited ButtonOk: TButton
      Left = 123
      ExplicitLeft = 123
    end
    inherited ButtonCancel: TButton
      Left = 220
      ExplicitLeft = 220
    end
  end
  inherited PanelControls: TPanel
    Width = 302
    Height = 219
    ExplicitWidth = 302
    ExplicitHeight = 219
    object LabelParam: TLabel
      Left = 36
      Top = 16
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelAccount: TLabel
      Left = 28
      Top = 165
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditAccount
    end
    object LabelDateCreate: TLabel
      Left = 9
      Top = 192
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object LabelDescription: TLabel
      Left = 36
      Top = 70
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelValue: TLabel
      Left = 37
      Top = 43
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077':'
      FocusControl = EditValue
    end
    object EditParam: TEdit
      Left = 95
      Top = 13
      Width = 167
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParam: TButton
      Left = 268
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 1
    end
    object EditAccount: TEdit
      Left = 95
      Top = 162
      Width = 167
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonAccount: TButton
      Left = 268
      Top = 162
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100')'
      Caption = '...'
      TabOrder = 5
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 95
      Top = 189
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 6
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 189
      Top = 189
      Width = 73
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 7
    end
    object MemoDescription: TMemo
      Left = 95
      Top = 67
      Width = 192
      Height = 89
      TabOrder = 3
    end
    object EditValue: TEdit
      Left = 95
      Top = 40
      Width = 192
      Height = 21
      TabOrder = 2
    end
  end
end
