inherited BisDocproHbookPositionEditForm: TBisDocproHbookPositionEditForm
  Left = 514
  Top = 285
  Caption = 'BisDocproHbookPositionEditForm'
  ClientHeight = 157
  ClientWidth = 327
  ExplicitLeft = 514
  ExplicitTop = 285
  ExplicitWidth = 335
  ExplicitHeight = 184
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 119
    Width = 327
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 150
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 247
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 327
    Height = 119
    ExplicitTop = 1
    ExplicitWidth = 327
    ExplicitHeight = 189
    object LabelView: TLabel
      Left = 11
      Top = 43
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
      FocusControl = EditView
    end
    object LabelFirm: TLabel
      Left = 56
      Top = 70
      Width = 34
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1076#1077#1083':'
      FocusControl = EditFirm
    end
    object LabelPlan: TLabel
      Left = 61
      Top = 16
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1083#1072#1085':'
      FocusControl = EditPlan
    end
    object LabelPriority: TLabel
      Left = 43
      Top = 97
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditView: TEdit
      Left = 96
      Top = 40
      Width = 193
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonView: TButton
      Left = 295
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Caption = '...'
      TabOrder = 3
    end
    object EditFirm: TEdit
      Left = 96
      Top = 67
      Width = 193
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonFirm: TButton
      Left = 295
      Top = 67
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1090#1076#1077#1083
      Caption = '...'
      TabOrder = 5
    end
    object EditPlan: TEdit
      Left = 96
      Top = 13
      Width = 193
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonPlan: TButton
      Left = 295
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1083#1072#1085
      Caption = '...'
      TabOrder = 1
    end
    object EditPriority: TEdit
      Left = 96
      Top = 94
      Width = 73
      Height = 21
      TabOrder = 6
    end
  end
end
