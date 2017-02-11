inherited BisTaxiDataZoneEditForm: TBisTaxiDataZoneEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataZoneEditForm'
  ClientHeight = 224
  ClientWidth = 391
  ExplicitWidth = 399
  ExplicitHeight = 258
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 186
    Width = 391
    ExplicitTop = 156
    ExplicitWidth = 303
    inherited ButtonOk: TButton
      Left = 212
      ExplicitLeft = 124
    end
    inherited ButtonCancel: TButton
      Left = 308
      ExplicitLeft = 220
    end
  end
  inherited PanelControls: TPanel
    Width = 391
    Height = 186
    ExplicitTop = -1
    ExplicitWidth = 340
    ExplicitHeight = 186
    object LabelName: TLabel
      Left = 14
      Top = 15
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 38
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 269
      Top = 15
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelCostIn: TLabel
      Left = 75
      Top = 154
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1074':'
      FocusControl = EditCostIn
    end
    object LabelCostOut: TLabel
      Left = 227
      Top = 154
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1080#1079':'
      FocusControl = EditCostOut
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 159
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 280
      Height = 106
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
    object EditPriority: TEdit
      Left = 323
      Top = 12
      Width = 54
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 1
    end
    object EditCostIn: TEdit
      Left = 148
      Top = 151
      Width = 72
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 3
    end
    object EditCostOut: TEdit
      Left = 305
      Top = 151
      Width = 72
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
  end
end
