inherited BisTaxiDataCostEditForm: TBisTaxiDataCostEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataCostEditForm'
  ClientHeight = 163
  ClientWidth = 316
  ExplicitWidth = 324
  ExplicitHeight = 197
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 125
    Width = 316
    ExplicitTop = 125
    ExplicitWidth = 316
    inherited ButtonOk: TButton
      Left = 137
      ExplicitLeft = 137
    end
    inherited ButtonCancel: TButton
      Left = 233
      ExplicitLeft = 233
    end
  end
  inherited PanelControls: TPanel
    Width = 316
    Height = 125
    ExplicitWidth = 316
    ExplicitHeight = 125
    object LabelZoneTo: TLabel
      Left = 61
      Top = 15
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = #1042' '#1079#1086#1085#1091':'
      FocusControl = EditZoneTo
    end
    object LabelPeriod: TLabel
      Left = 178
      Top = 69
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1088#1077#1084#1103' ('#1084#1080#1085'):'
      FocusControl = EditPeriod
    end
    object LabelDistance: TLabel
      Left = 11
      Top = 69
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077' ('#1082#1084'):'
      FocusControl = EditDistance
    end
    object LabelCost: TLabel
      Left = 143
      Top = 96
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100':'
      FocusControl = EditCost
    end
    object LabelZoneFrom: TLabel
      Left = 51
      Top = 42
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1079' '#1079#1086#1085#1099':'
      FocusControl = EditZoneFrom
    end
    object EditZoneTo: TEdit
      Left = 103
      Top = 12
      Width = 200
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object EditPeriod: TEdit
      Left = 249
      Top = 66
      Width = 54
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 3
    end
    object EditDistance: TEdit
      Left = 103
      Top = 66
      Width = 64
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 2
    end
    object EditCost: TEdit
      Left = 207
      Top = 93
      Width = 96
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object EditZoneFrom: TEdit
      Left = 103
      Top = 39
      Width = 200
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 1
    end
  end
end
