inherited BisTaxiDataRateEditForm: TBisTaxiDataRateEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataRateEditForm'
  ClientHeight = 303
  ClientWidth = 311
  ExplicitWidth = 319
  ExplicitHeight = 337
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 265
    Width = 311
    ExplicitTop = 265
    ExplicitWidth = 311
    inherited ButtonOk: TButton
      Left = 132
      ExplicitLeft = 132
    end
    inherited ButtonCancel: TButton
      Left = 228
      ExplicitLeft = 228
    end
  end
  inherited PanelControls: TPanel
    Width = 311
    Height = 265
    ExplicitWidth = 311
    ExplicitHeight = 265
    object LabelName: TLabel
      Left = 12
      Top = 15
      Width = 79
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
    object LabelType: TLabel
      Left = 29
      Top = 129
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1058#1080#1087' '#1090#1072#1088#1080#1092#1072':'
      FocusControl = ComboBoxType
      ExplicitTop = 282
    end
    object LabelPriority: TLabel
      Left = 190
      Top = 237
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitTop = 390
    end
    object LabelSum: TLabel
      Left = 76
      Top = 183
      Width = 140
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1079#1072' ('#1082#1084' '#1080#1083#1080' '#1084#1080#1085'):'
      FocusControl = EditSum
    end
    object LabelProc: TLabel
      Left = 33
      Top = 156
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072':'
      FocusControl = EditProc
      ExplicitTop = 309
    end
    object LabelPeriod: TLabel
      Left = 99
      Top = 210
      Width = 138
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1074#1088#1077#1084#1103' ('#1084#1080#1085'):'
      FocusControl = EditPeriod
      ExplicitTop = 363
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 200
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 200
      Height = 81
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object ComboBoxType: TComboBox
      Left = 97
      Top = 126
      Width = 200
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103
        #1089#1087#1077#1094#1080#1072#1083#1100#1085#1099#1081' '#1088#1072#1089#1095#1077#1090
        #1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1086' '#1079#1086#1085#1077
        #1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1086' '#1079#1086#1085#1077' '#1079#1072' 1 '#1082#1084
        #1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1086' '#1079#1086#1085#1077' '#1079#1072' 1 '#1084#1080#1085
        #1089#1090#1086#1080#1084#1086#1089#1090#1100' '#1087#1086' '#1082#1072#1088#1090#1077' '#1079#1072' 1 '#1082#1084)
    end
    object EditPriority: TEdit
      Left = 243
      Top = 234
      Width = 54
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 5
    end
    object EditSum: TEdit
      Left = 222
      Top = 180
      Width = 75
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object EditProc: TEdit
      Left = 97
      Top = 153
      Width = 200
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 3
    end
    object EditPeriod: TEdit
      Left = 243
      Top = 207
      Width = 54
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 6
    end
  end
end
