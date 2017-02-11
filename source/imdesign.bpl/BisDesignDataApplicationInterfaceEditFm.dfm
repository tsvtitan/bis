inherited BisDesignDataApplicationInterfaceEditForm: TBisDesignDataApplicationInterfaceEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataApplicationInterfaceEditForm'
  ClientHeight = 181
  ClientWidth = 374
  ExplicitWidth = 382
  ExplicitHeight = 215
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 143
    Width = 374
    ExplicitTop = 143
    ExplicitWidth = 374
    inherited ButtonOk: TButton
      Left = 194
      ExplicitLeft = 194
    end
    inherited ButtonCancel: TButton
      Left = 291
      ExplicitLeft = 291
    end
  end
  inherited PanelControls: TPanel
    Width = 374
    Height = 143
    ExplicitWidth = 374
    ExplicitHeight = 143
    object LabelApplication: TLabel
      Left = 59
      Top = 13
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
      FocusControl = EditApplication
    end
    object LabelInterface: TLabel
      Left = 66
      Top = 67
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089':'
      FocusControl = EditInterface
    end
    object LabelPriority: TLabel
      Left = 78
      Top = 94
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelAccount: TLabel
      Left = 8
      Top = 40
      Width = 118
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1083#1100' ('#1091#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100'):'
      FocusControl = EditAccount
    end
    object EditApplication: TEdit
      Left = 132
      Top = 10
      Width = 207
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonApplication: TButton
      Left = 345
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object EditInterface: TEdit
      Left = 132
      Top = 64
      Width = 207
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonInterface: TButton
      Left = 345
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 5
    end
    object EditPriority: TEdit
      Left = 132
      Top = 91
      Width = 73
      Height = 21
      TabOrder = 6
    end
    object CheckBoxAutoRun: TCheckBox
      Left = 211
      Top = 93
      Width = 97
      Height = 17
      Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082
      TabOrder = 7
    end
    object EditAccount: TEdit
      Left = 132
      Top = 37
      Width = 207
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAccount: TButton
      Left = 345
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1086#1083#1100' ('#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100')'
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
    object CheckBoxRefresh: TCheckBox
      Left = 132
      Top = 118
      Width = 188
      Height = 17
      Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1099
      TabOrder = 8
    end
  end
end
