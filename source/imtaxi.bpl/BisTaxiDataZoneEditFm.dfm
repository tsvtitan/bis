inherited BisTaxiDataZoneEditForm: TBisTaxiDataZoneEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataZoneEditForm'
  ClientHeight = 224
  ClientWidth = 411
  ExplicitWidth = 419
  ExplicitHeight = 258
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 186
    Width = 411
    ExplicitTop = 186
    ExplicitWidth = 391
    inherited ButtonOk: TButton
      Left = 232
      ExplicitLeft = 212
    end
    inherited ButtonCancel: TButton
      Left = 328
      ExplicitLeft = 308
    end
  end
  inherited PanelControls: TPanel
    Width = 411
    Height = 186
    ExplicitTop = -1
    ExplicitWidth = 391
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
      Left = 289
      Top = 15
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitLeft = 269
    end
    object LabelCostIn: TLabel
      Left = 95
      Top = 154
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1074':'
      FocusControl = EditCostIn
      ExplicitLeft = 75
    end
    object LabelCostOut: TLabel
      Left = 247
      Top = 154
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1080#1079':'
      FocusControl = EditCostOut
      ExplicitLeft = 227
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 179
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
      ExplicitWidth = 159
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 300
      Height = 106
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
      ExplicitWidth = 280
    end
    object EditPriority: TEdit
      Left = 343
      Top = 12
      Width = 54
      Height = 21
      Anchors = [akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 1
      ExplicitLeft = 323
    end
    object EditCostIn: TEdit
      Left = 168
      Top = 151
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 3
      ExplicitLeft = 148
    end
    object EditCostOut: TEdit
      Left = 325
      Top = 151
      Width = 72
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
      ExplicitLeft = 305
    end
  end
end
