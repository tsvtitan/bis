inherited BisKrieltDataAccountParamEditForm: TBisKrieltDataAccountParamEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataAccountParamEditForm'
  ClientHeight = 129
  ClientWidth = 337
  ExplicitWidth = 345
  ExplicitHeight = 163
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 91
    Width = 337
    ExplicitTop = 91
    ExplicitWidth = 337
    inherited ButtonOk: TButton
      Left = 159
      ExplicitLeft = 159
    end
    inherited ButtonCancel: TButton
      Left = 255
      ExplicitLeft = 255
    end
  end
  inherited PanelControls: TPanel
    Width = 337
    Height = 91
    ExplicitWidth = 337
    ExplicitHeight = 91
    object LabelAccount: TLabel
      Left = 8
      Top = 13
      Width = 119
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100'):'
      FocusControl = EditAccount
    end
    object LabelParam: TLabel
      Left = 74
      Top = 40
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelPriority: TLabel
      Left = 79
      Top = 67
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditAccount: TEdit
      Left = 135
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonAccount: TButton
      Left = 309
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100')'
      Caption = '...'
      TabOrder = 1
    end
    object EditParam: TEdit
      Left = 135
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonParam: TButton
      Left = 309
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 135
      Top = 64
      Width = 73
      Height = 21
      TabOrder = 4
    end
  end
end