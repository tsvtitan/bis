inherited BisCallcHbookActionResultEditForm: TBisCallcHbookActionResultEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookActionResultEditForm'
  ClientHeight = 126
  ClientWidth = 278
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 286
  ExplicitHeight = 153
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 88
    Width = 278
    ExplicitTop = 197
    ExplicitWidth = 495
    inherited ButtonOk: TButton
      Left = 101
      ExplicitLeft = 318
    end
    inherited ButtonCancel: TButton
      Left = 198
      ExplicitLeft = 415
    end
  end
  inherited PanelControls: TPanel
    Width = 278
    Height = 88
    ExplicitTop = 1
    ExplicitWidth = 424
    ExplicitHeight = 348
    object LabelAction: TLabel
      Left = 15
      Top = 13
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelResult: TLabel
      Left = 13
      Top = 40
      Width = 55
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
      FocusControl = EditResult
    end
    object LabelPriority: TLabel
      Left = 21
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditAction: TEdit
      Left = 76
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonAction: TButton
      Left = 250
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object EditResult: TEdit
      Left = 76
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonResult: TButton
      Left = 250
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 76
      Top = 64
      Width = 73
      Height = 21
      TabOrder = 4
    end
  end
end