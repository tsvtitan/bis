inherited BisCallcHbookPlanActionEditForm: TBisCallcHbookPlanActionEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookPlanActionEditForm'
  ClientHeight = 130
  ClientWidth = 280
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 288
  ExplicitHeight = 157
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 92
    Width = 280
    ExplicitTop = 197
    ExplicitWidth = 495
    inherited ButtonOk: TButton
      Left = 103
      ExplicitLeft = 318
    end
    inherited ButtonCancel: TButton
      Left = 200
      ExplicitLeft = 415
    end
  end
  inherited PanelControls: TPanel
    Width = 280
    Height = 92
    ExplicitTop = 1
    ExplicitWidth = 424
    ExplicitHeight = 348
    object LabelPlan: TLabel
      Left = 41
      Top = 13
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1083#1072#1085':'
      FocusControl = EditPlan
    end
    object LabelAction: TLabel
      Left = 17
      Top = 40
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelPriority: TLabel
      Left = 155
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelPeriod: TLabel
      Left = 29
      Top = 67
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1077#1088#1080#1086#1076':'
      FocusControl = EditPeriod
    end
    object EditPlan: TEdit
      Left = 76
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonPlan: TButton
      Left = 250
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1083#1072#1085
      Caption = '...'
      TabOrder = 1
    end
    object EditAction: TEdit
      Left = 76
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAction: TButton
      Left = 250
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 208
      Top = 64
      Width = 63
      Height = 21
      TabOrder = 5
    end
    object EditPeriod: TEdit
      Left = 76
      Top = 64
      Width = 61
      Height = 21
      TabOrder = 4
    end
  end
end
