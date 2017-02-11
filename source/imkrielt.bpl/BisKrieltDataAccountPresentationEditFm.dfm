inherited BisKrieltDataAccountPresentationEditForm: TBisKrieltDataAccountPresentationEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataAccountPresentationEditForm'
  ClientHeight = 263
  ClientWidth = 339
  ExplicitWidth = 347
  ExplicitHeight = 297
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 225
    Width = 339
    ExplicitTop = 225
    ExplicitWidth = 339
    inherited ButtonOk: TButton
      Left = 160
      ExplicitLeft = 160
    end
    inherited ButtonCancel: TButton
      Left = 257
      ExplicitLeft = 257
    end
  end
  inherited PanelControls: TPanel
    Width = 339
    Height = 225
    ExplicitWidth = 339
    ExplicitHeight = 225
    object LabelAccount: TLabel
      Left = 10
      Top = 13
      Width = 119
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100'):'
      FocusControl = EditAccount
    end
    object LabelView: TLabel
      Left = 54
      Top = 67
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditView
    end
    object LabelType: TLabel
      Left = 55
      Top = 94
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074':'
      FocusControl = EditType
    end
    object LabelOperation: TLabel
      Left = 75
      Top = 121
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      FocusControl = EditOperation
    end
    object LabelPresentation: TLabel
      Left = 46
      Top = 148
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077':'
      FocusControl = EditPresentation
    end
    object LabelPublishing: TLabel
      Left = 82
      Top = 40
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1079#1076#1072#1085#1080#1077':'
      FocusControl = EditPublishing
    end
    object LabelWeekday: TLabel
      Left = 59
      Top = 175
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080':'
      FocusControl = ComboBoxWeekday
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
    object EditView: TEdit
      Left = 135
      Top = 64
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonView: TButton
      Left = 309
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076
      Caption = '...'
      TabOrder = 5
    end
    object EditType: TEdit
      Left = 135
      Top = 91
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonType: TButton
      Left = 309
      Top = 91
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087
      Caption = '...'
      TabOrder = 7
    end
    object EditOperation: TEdit
      Left = 135
      Top = 118
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 8
    end
    object ButtonOperation: TButton
      Left = 309
      Top = 118
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 9
    end
    object EditPresentation: TEdit
      Left = 135
      Top = 145
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 10
    end
    object ButtonPresentation: TButton
      Left = 309
      Top = 145
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      Caption = '...'
      TabOrder = 11
    end
    object CheckBoxRefresh: TCheckBox
      Left = 135
      Top = 199
      Width = 195
      Height = 17
      Caption = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1084#1077#1085#1102' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1081
      TabOrder = 13
    end
    object EditPublishing: TEdit
      Left = 135
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonPublishing: TButton
      Left = 309
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
      Caption = '...'
      TabOrder = 3
    end
    object ComboBoxWeekday: TComboBox
      Left = 135
      Top = 172
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 12
      Items.Strings = (
        #1087#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
        #1074#1090#1086#1088#1085#1080#1082
        #1089#1088#1077#1076#1072
        #1095#1077#1090#1074#1077#1088#1075
        #1087#1103#1090#1085#1080#1094#1072
        #1089#1091#1073#1073#1086#1090#1072
        #1074#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077)
    end
  end
end
