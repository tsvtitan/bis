inherited BisTaxiDataCarTypeEditForm: TBisTaxiDataCarTypeEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataCarTypeEditForm'
  ClientHeight = 302
  ClientWidth = 331
  ExplicitWidth = 339
  ExplicitHeight = 336
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 264
    Width = 331
    ExplicitTop = 264
    ExplicitWidth = 331
    inherited ButtonOk: TButton
      Left = 152
      ExplicitLeft = 152
    end
    inherited ButtonCancel: TButton
      Left = 248
      ExplicitLeft = 248
    end
  end
  inherited PanelControls: TPanel
    Width = 331
    Height = 264
    ExplicitWidth = 331
    ExplicitHeight = 264
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
    object LabelFontColor: TLabel
      Left = 46
      Top = 138
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1062#1074#1077#1090' '#1096#1088#1080#1092#1090#1072':'
      FocusControl = ColorBoxFontColor
      ExplicitLeft = 18
    end
    object LabelRatio: TLabel
      Left = 45
      Top = 194
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090':'
      FocusControl = EditRatio
      ExplicitLeft = 17
    end
    object LabelPriority: TLabel
      Left = 209
      Top = 194
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitLeft = 181
    end
    object LabelBrushColor: TLabel
      Left = 60
      Top = 166
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072':'
      FocusControl = ColorBoxBrushColor
      ExplicitLeft = 32
    end
    object LabelCostIdle: TLabel
      Left = 58
      Top = 221
      Width = 131
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1088#1086#1089#1090#1086#1103' ('#1084#1080#1085'):'
      FocusControl = EditCostIdle
      ExplicitLeft = 30
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 220
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object ColorBoxFontColor: TColorBox
      Left = 125
      Top = 135
      Width = 192
      Height = 22
      DefaultColorColor = clWindowText
      NoneColorColor = clWindowText
      Selected = clWindowText
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akRight, akBottom]
      ItemHeight = 16
      TabOrder = 2
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 220
      Height = 90
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object EditRatio: TEdit
      Left = 125
      Top = 191
      Width = 70
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object EditPriority: TEdit
      Left = 263
      Top = 191
      Width = 54
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 5
    end
    object ColorBoxBrushColor: TColorBox
      Left = 125
      Top = 163
      Width = 192
      Height = 22
      DefaultColorColor = clWindow
      NoneColorColor = clWindow
      Selected = clWindowText
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akRight, akBottom]
      ItemHeight = 16
      TabOrder = 3
    end
    object EditCostIdle: TEdit
      Left = 195
      Top = 218
      Width = 122
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 6
    end
    object CheckBoxVisible: TCheckBox
      Left = 195
      Top = 243
      Width = 97
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      TabOrder = 7
    end
  end
end
