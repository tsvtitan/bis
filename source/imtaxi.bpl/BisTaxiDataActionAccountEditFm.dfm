inherited BisTaxiDataActionAccountEditForm: TBisTaxiDataActionAccountEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataActionAccountEditForm'
  ClientHeight = 138
  ClientWidth = 336
  ExplicitWidth = 344
  ExplicitHeight = 172
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 100
    Width = 336
    ExplicitTop = 100
    ExplicitWidth = 336
    inherited ButtonOk: TButton
      Left = 157
      ExplicitLeft = 157
    end
    inherited ButtonCancel: TButton
      Left = 253
      ExplicitLeft = 253
    end
  end
  inherited PanelControls: TPanel
    Width = 336
    Height = 100
    ExplicitWidth = 336
    ExplicitHeight = 100
    object LabelAction: TLabel
      Left = 42
      Top = 18
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelAccount: TLabel
      Left = 11
      Top = 45
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelPriority: TLabel
      Left = 177
      Top = 72
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditAction: TEdit
      Left = 101
      Top = 15
      Width = 197
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonAction: TButton
      Left = 304
      Top = 15
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object EditAccount: TEdit
      Left = 101
      Top = 42
      Width = 197
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAccount: TButton
      Left = 304
      Top = 42
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 3
    end
    object EditPriority: TEdit
      Left = 230
      Top = 69
      Width = 68
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
  end
end
