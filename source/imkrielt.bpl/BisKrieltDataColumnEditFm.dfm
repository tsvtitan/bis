inherited BisKrieltDataColumnEditForm: TBisKrieltDataColumnEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataColumnEditForm'
  ClientHeight = 336
  ClientWidth = 329
  ExplicitWidth = 337
  ExplicitHeight = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 298
    Width = 329
    ExplicitTop = 295
    ExplicitWidth = 320
    inherited ButtonOk: TButton
      Left = 150
      ExplicitLeft = 141
    end
    inherited ButtonCancel: TButton
      Left = 247
      ExplicitLeft = 238
    end
  end
  inherited PanelControls: TPanel
    Width = 329
    Height = 298
    ExplicitTop = -1
    ExplicitWidth = 320
    ExplicitHeight = 318
    object LabelName: TLabel
      Left = 21
      Top = 16
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 45
      Top = 70
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPresentation: TLabel
      Left = 15
      Top = 43
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077':'
      FocusControl = EditPresentation
    end
    object LabelPriority: TLabel
      Left = 19
      Top = 220
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082' '#1086#1090'-'#1080#1103':'
      FocusControl = EditPriority
      ExplicitTop = 250
    end
    object LabelDefault: TLabel
      Left = 21
      Top = 166
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102':'
      FocusControl = EditDefault
      ExplicitTop = 196
    end
    object LabelWidth: TLabel
      Left = 215
      Top = 193
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1064#1080#1088#1080#1085#1072':'
      FocusControl = EditWidth
      ExplicitTop = 223
    end
    object LabelAlign: TLabel
      Left = 20
      Top = 193
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1042#1099#1088#1072#1074#1085#1080#1074#1072#1085#1080#1077':'
      ExplicitTop = 223
    end
    object LabelSearchPriority: TLabel
      Left = 12
      Top = 247
      Width = 86
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082' '#1087#1086#1080#1089#1082#1072':'
      FocusControl = EditSearchPriority
      ExplicitTop = 277
    end
    object EditName: TEdit
      Left = 104
      Top = 13
      Width = 212
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 203
    end
    object MemoDescription: TMemo
      Left = 104
      Top = 67
      Width = 212
      Height = 90
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 3
      ExplicitWidth = 210
      ExplicitHeight = 120
    end
    object EditPresentation: TEdit
      Left = 104
      Top = 40
      Width = 185
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      ExplicitWidth = 176
    end
    object ButtonPresentation: TButton
      Left = 295
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 2
      ExplicitLeft = 286
    end
    object EditPriority: TEdit
      Left = 104
      Top = 217
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 7
      ExplicitTop = 247
    end
    object EditDefault: TEdit
      Left = 104
      Top = 163
      Width = 212
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 4
      ExplicitTop = 193
      ExplicitWidth = 210
    end
    object CheckBoxVisible: TCheckBox
      Left = 183
      Top = 217
      Width = 121
      Height = 17
      Hint = #1042#1080#1076#1080#1084#1086#1089#1090#1100' '#1082#1086#1083#1086#1085#1082#1080' '#1074' '#1101#1090#1086#1084' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1080
      Anchors = [akLeft, akBottom]
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100' '#1082#1086#1083#1086#1085#1082#1080
      TabOrder = 9
      ExplicitTop = 247
    end
    object CheckBoxUseDepend: TCheckBox
      Left = 183
      Top = 240
      Width = 135
      Height = 17
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1079#1072#1074#1080#1089#1080#1084#1086#1089#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1085#1072' '#1080#1084#1087#1086#1088#1090#1077
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1074#1080#1089#1080#1084#1086#1089#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1081
      TabOrder = 10
      ExplicitTop = 270
    end
    object CheckBoxNotEmpty: TCheckBox
      Left = 104
      Top = 271
      Width = 82
      Height = 17
      Hint = #1050#1086#1083#1086#1085#1082#1072' '#1073#1091#1076#1077#1090' '#1090#1088#1077#1073#1086#1074#1072#1090#1100' '#1085#1077' '#1087#1091#1089#1090#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Anchors = [akLeft, akBottom]
      Caption = #1053#1077' '#1087#1091#1089#1090#1072#1103
      TabOrder = 11
      ExplicitTop = 301
    end
    object EditWidth: TEdit
      Left = 265
      Top = 190
      Width = 49
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 6
      ExplicitTop = 220
    end
    object ComboBoxAlign: TComboBox
      Left = 104
      Top = 190
      Width = 92
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      ItemHeight = 13
      TabOrder = 5
      Items.Strings = (
        #1057#1083#1077#1074#1072
        #1057#1087#1088#1072#1074#1072
        #1055#1086' '#1094#1077#1085#1090#1088#1091)
      ExplicitTop = 220
    end
    object EditSearchPriority: TEdit
      Left = 104
      Top = 244
      Width = 73
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 8
      ExplicitTop = 274
    end
  end
  inherited ImageList: TImageList
    Left = 192
    Top = 80
  end
end