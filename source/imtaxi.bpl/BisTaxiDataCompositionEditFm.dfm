inherited BisTaxiDataCompositionEditForm: TBisTaxiDataCompositionEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataCompositionEditForm'
  ClientHeight = 189
  ClientWidth = 371
  ExplicitWidth = 379
  ExplicitHeight = 223
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 151
    Width = 371
    ExplicitTop = 151
    ExplicitWidth = 371
    inherited ButtonOk: TButton
      Left = 192
      ExplicitLeft = 192
    end
    inherited ButtonCancel: TButton
      Left = 288
      ExplicitLeft = 288
    end
  end
  inherited PanelControls: TPanel
    Width = 371
    Height = 151
    ExplicitWidth = 371
    ExplicitHeight = 151
    object LabelZone: TLabel
      Left = 24
      Top = 15
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1086#1085#1072':'
      FocusControl = EditZone
    end
    object LabelHouses: TLabel
      Left = 73
      Top = 96
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088#1072' '#1076#1086#1084#1086#1074':'
      FocusControl = EditHouses
    end
    object LabelStreet: TLabel
      Left = 17
      Top = 42
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1083#1080#1094#1072':'
      FocusControl = EditStreet
    end
    object LabelType: TLabel
      Left = 83
      Top = 69
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1089#1086#1089#1090#1072#1074#1072':'
      FocusControl = ComboBoxType
    end
    object LabelExceptions: TLabel
      Left = 81
      Top = 123
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1103':'
      FocusControl = EditExceptions
    end
    object EditZone: TEdit
      Left = 58
      Top = 12
      Width = 207
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object EditHouses: TEdit
      Left = 154
      Top = 93
      Width = 204
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object EditStreet: TEdit
      Left = 58
      Top = 39
      Width = 273
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonStreet: TButton
      Left = 337
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1083#1080#1094#1091
      Caption = '...'
      TabOrder = 2
    end
    object ComboBoxType: TComboBox
      Left = 154
      Top = 66
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 3
    end
    object EditExceptions: TEdit
      Left = 154
      Top = 120
      Width = 204
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
    end
  end
end
