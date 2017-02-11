inherited BisKrieltDataTypeParamEditForm: TBisKrieltDataTypeParamEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataTypeParamEditForm'
  ClientHeight = 205
  ClientWidth = 286
  ExplicitWidth = 294
  ExplicitHeight = 239
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 167
    Width = 286
    ExplicitTop = 167
    ExplicitWidth = 286
    inherited ButtonOk: TButton
      Left = 107
      ExplicitLeft = 107
    end
    inherited ButtonCancel: TButton
      Left = 204
      ExplicitLeft = 204
    end
  end
  inherited PanelControls: TPanel
    Width = 286
    Height = 167
    ExplicitWidth = 286
    ExplicitHeight = 167
    object LabelParam: TLabel
      Left = 22
      Top = 13
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelType: TLabel
      Left = 9
      Top = 40
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072':'
      FocusControl = EditType
    end
    object LabelPriority: TLabel
      Left = 29
      Top = 94
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelOperation: TLabel
      Left = 23
      Top = 67
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      FocusControl = EditOperation
    end
    object EditParam: TEdit
      Left = 84
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonParam: TButton
      Left = 258
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 1
    end
    object EditType: TEdit
      Left = 84
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonType: TButton
      Left = 258
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087' '#1086#1073#1098#1077#1082#1090#1072
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 84
      Top = 91
      Width = 73
      Height = 21
      TabOrder = 6
    end
    object EditOperation: TEdit
      Left = 84
      Top = 64
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonOperation: TButton
      Left = 258
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 5
    end
    object CheckBoxMain: TCheckBox
      Left = 84
      Top = 116
      Width = 97
      Height = 17
      Caption = #1054#1089#1085#1086#1074#1085#1086#1081
      TabOrder = 7
    end
    object CheckBoxVisible: TCheckBox
      Left = 84
      Top = 135
      Width = 97
      Height = 17
      Caption = #1042#1080#1076#1080#1084#1099#1081
      TabOrder = 8
    end
  end
end
