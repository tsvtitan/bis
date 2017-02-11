inherited BisTaxiDataRatingEditForm: TBisTaxiDataRatingEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataRatingEditForm'
  ClientHeight = 244
  ClientWidth = 311
  ExplicitWidth = 319
  ExplicitHeight = 278
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 206
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
    Height = 206
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
      Left = 30
      Top = 133
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1058#1080#1087' '#1086#1094#1077#1085#1082#1080':'
      FocusControl = ComboBoxType
      ExplicitTop = 162
    end
    object LabelPriority: TLabel
      Left = 186
      Top = 160
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelScore: TLabel
      Left = 55
      Top = 160
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1041#1072#1083#1083#1099':'
      FocusControl = EditScore
      ExplicitTop = 189
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
      Height = 85
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      ExplicitHeight = 114
    end
    object ComboBoxType: TComboBox
      Left = 97
      Top = 130
      Width = 200
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1086#1090#1088#1080#1094#1072#1090#1077#1083#1100#1085#1072#1103
        #1087#1086#1083#1086#1078#1080#1090#1077#1083#1100#1085#1072#1103)
      ExplicitTop = 159
    end
    object EditPriority: TEdit
      Left = 240
      Top = 157
      Width = 57
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object CheckBoxVisible: TCheckBox
      Left = 97
      Top = 184
      Width = 97
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      TabOrder = 5
      ExplicitTop = 213
    end
    object EditScore: TEdit
      Left = 97
      Top = 157
      Width = 72
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 3
    end
  end
end
