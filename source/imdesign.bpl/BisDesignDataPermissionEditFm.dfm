inherited BisDesignDataPermissionEditForm: TBisDesignDataPermissionEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataPermissionEditForm'
  ClientHeight = 185
  ClientWidth = 367
  ExplicitWidth = 375
  ExplicitHeight = 219
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 147
    Width = 367
    ExplicitTop = 147
    ExplicitWidth = 367
    inherited ButtonOk: TButton
      Left = 188
      ExplicitLeft = 188
    end
    inherited ButtonCancel: TButton
      Left = 284
      ExplicitLeft = 284
    end
  end
  inherited PanelControls: TPanel
    Width = 367
    Height = 147
    ExplicitWidth = 367
    ExplicitHeight = 147
    object LabelAccount: TLabel
      Left = 17
      Top = 15
      Width = 118
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1083#1100' ('#1091#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100'):'
      FocusControl = EditAccount
    end
    object LabelInterface: TLabel
      Left = 75
      Top = 42
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089':'
      FocusControl = EditInterface
    end
    object LabelRightAccess: TLabel
      Left = 100
      Top = 69
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1072#1074#1086':'
      FocusControl = ComboBoxRightAccess
    end
    object LabelValue: TLabel
      Left = 83
      Top = 96
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077':'
      FocusControl = ComboBoxValue
    end
    object EditAccount: TEdit
      Left = 141
      Top = 12
      Width = 188
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonAccount: TButton
      Left = 335
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1083#1100' ('#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100')'
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object EditInterface: TEdit
      Left = 141
      Top = 39
      Width = 188
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonInterface: TButton
      Left = 335
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
    object ComboBoxRightAccess: TComboBox
      Left = 141
      Top = 66
      Width = 215
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 4
    end
    object ComboBoxValue: TComboBox
      Left = 141
      Top = 93
      Width = 215
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 5
    end
    object CheckBoxRefresh: TCheckBox
      Left = 141
      Top = 120
      Width = 188
      Height = 17
      Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1099
      TabOrder = 6
    end
  end
  inherited ImageList: TImageList
    Left = 32
    Top = 72
  end
end
