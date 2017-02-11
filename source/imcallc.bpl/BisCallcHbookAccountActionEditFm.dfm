inherited BisCallcHbookAccountActionEditForm: TBisCallcHbookAccountActionEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookAccountActionEditForm'
  ClientHeight = 129
  ClientWidth = 304
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 312
  ExplicitHeight = 156
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 91
    Width = 304
    ExplicitTop = 197
    ExplicitWidth = 495
    inherited ButtonOk: TButton
      Left = 127
      ExplicitLeft = 318
    end
    inherited ButtonCancel: TButton
      Left = 224
      ExplicitLeft = 415
    end
  end
  inherited PanelControls: TPanel
    Width = 304
    Height = 91
    ExplicitTop = 1
    ExplicitWidth = 424
    ExplicitHeight = 348
    object LabelAccount: TLabel
      Left = 8
      Top = 13
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelAction: TLabel
      Left = 39
      Top = 40
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelPriority: TLabel
      Left = 45
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditAccount: TEdit
      Left = 100
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonAccount: TButton
      Left = 274
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 1
    end
    object EditAction: TEdit
      Left = 100
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAction: TButton
      Left = 274
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 100
      Top = 64
      Width = 73
      Height = 21
      TabOrder = 4
    end
  end
end
