inherited BisTaxiDataDiscountTypeEditForm: TBisTaxiDataDiscountTypeEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataDiscountTypeEditForm'
  ClientHeight = 285
  ClientWidth = 311
  ExplicitWidth = 319
  ExplicitHeight = 319
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 247
    Width = 311
    ExplicitTop = 247
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
    Height = 247
    ExplicitWidth = 311
    ExplicitHeight = 247
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
    object LabelType: TLabel
      Left = 25
      Top = 137
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072':'
      FocusControl = ComboBoxType
    end
    object LabelPriority: TLabel
      Left = 43
      Top = 218
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelPercent: TLabel
      Left = 44
      Top = 191
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1086#1094#1077#1085#1090':'
      FocusControl = EditPercent
    end
    object LabelSum: TLabel
      Left = 181
      Top = 191
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1057#1091#1084#1084#1072':'
      FocusControl = EditSum
    end
    object LabelProc: TLabel
      Left = 31
      Top = 164
      Width = 60
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072':'
      FocusControl = EditProc
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
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object ComboBoxType: TComboBox
      Left = 97
      Top = 134
      Width = 200
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103
        #1089#1087#1077#1094#1080#1072#1083#1100#1085#1099#1081' '#1088#1072#1089#1095#1077#1090
        #1087#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1089#1090#1086#1080#1084#1086#1089#1090#1080
        #1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1091#1084#1084#1072)
    end
    object EditPriority: TEdit
      Left = 97
      Top = 215
      Width = 54
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 6
    end
    object EditPercent: TEdit
      Left = 97
      Top = 188
      Width = 54
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object EditSum: TEdit
      Left = 222
      Top = 188
      Width = 75
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 5
    end
    object EditProc: TEdit
      Left = 97
      Top = 161
      Width = 200
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 3
    end
  end
end
