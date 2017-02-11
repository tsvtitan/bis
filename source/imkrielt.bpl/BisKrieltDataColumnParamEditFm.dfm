inherited BisKrieltDataColumnParamEditForm: TBisKrieltDataColumnParamEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataColumnParamEditForm'
  ClientHeight = 279
  ClientWidth = 313
  ExplicitWidth = 321
  ExplicitHeight = 313
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 241
    Width = 313
    ExplicitTop = 241
    ExplicitWidth = 313
    inherited ButtonOk: TButton
      Left = 134
      ExplicitLeft = 134
    end
    inherited ButtonCancel: TButton
      Left = 231
      ExplicitLeft = 231
    end
  end
  inherited PanelControls: TPanel
    Width = 313
    Height = 241
    ExplicitWidth = 313
    ExplicitHeight = 241
    object LabelParam: TLabel
      Left = 36
      Top = 40
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelColumn: TLabel
      Left = 42
      Top = 13
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1083#1086#1085#1082#1072':'
      FocusControl = EditColumn
    end
    object LabelPriority: TLabel
      Left = 41
      Top = 148
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelStringBefore: TLabel
      Left = 32
      Top = 67
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1088#1086#1082#1072' '#1076#1086':'
      FocusControl = EditStringBefore
    end
    object LabelStringAfter: TLabel
      Left = 16
      Top = 94
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1088#1086#1082#1072' '#1087#1086#1089#1083#1077':'
      FocusControl = EditStringAfter
    end
    object LabelElementType: TLabel
      Left = 17
      Top = 121
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1101#1083#1077#1084#1077#1085#1090#1072':'
      FocusControl = ComboBoxElementType
    end
    object LabelPosition: TLabel
      Left = 43
      Top = 175
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1079#1080#1094#1080#1103':'
      FocusControl = ComboBoxPosition
    end
    object LabelPlacing: TLabel
      Left = 12
      Top = 202
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077':'
      FocusControl = EditPlacing
    end
    object EditParam: TEdit
      Left = 95
      Top = 37
      Width = 176
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonParam: TButton
      Left = 277
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 3
    end
    object EditColumn: TEdit
      Left = 95
      Top = 10
      Width = 176
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonColumn: TButton
      Left = 277
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1082#1086#1083#1086#1085#1082#1091
      Caption = '...'
      TabOrder = 1
    end
    object EditPriority: TEdit
      Left = 95
      Top = 145
      Width = 46
      Height = 21
      TabOrder = 10
    end
    object EditStringBefore: TEdit
      Left = 95
      Top = 64
      Width = 97
      Height = 21
      TabOrder = 4
    end
    object EditStringAfter: TEdit
      Left = 95
      Top = 91
      Width = 97
      Height = 21
      TabOrder = 6
    end
    object CheckBoxUseStringBefore: TCheckBox
      Left = 198
      Top = 66
      Width = 97
      Height = 17
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1080' '#1087#1091#1089#1090#1099#1093' '#1079#1085#1072#1095#1077#1085#1080#1103#1093' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object CheckBoxUseStringAfter: TCheckBox
      Left = 198
      Top = 93
      Width = 97
      Height = 17
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1080' '#1087#1091#1089#1090#1099#1093' '#1079#1085#1072#1095#1077#1085#1080#1103#1093' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object ComboBoxElementType: TComboBox
      Left = 95
      Top = 118
      Width = 176
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 8
      Items.Strings = (
        #1087#1086#1083#1077
        #1076#1080#1072#1087#1072#1079#1086#1085
        #1075#1072#1083#1086#1095#1082#1072
        #1089#1087#1080#1089#1086#1082
        #1084#1091#1083#1100#1090#1080#1089#1087#1080#1089#1086#1082
        #1074#1099#1087#1072#1076#1072#1102#1097#1080#1081' '#1089#1087#1080#1089#1086#1082
        #1074#1099#1087#1072#1076#1072#1102#1097#1080#1081' '#1072#1074#1090#1086#1082#1086#1084#1087#1083#1080#1090
        #1084#1085#1086#1075#1086#1089#1090#1088#1086#1095#1085#1086#1077' '#1087#1086#1083#1077
        #1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1100#1089#1103' 1'
        #1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1100#1089#1103' 2'
        #1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1100#1089#1103' 3')
    end
    object ComboBoxPosition: TComboBox
      Left = 95
      Top = 172
      Width = 203
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 12
      Items.Strings = (
        #1089' '#1085#1086#1074#1086#1081' '#1089#1090#1088#1086#1082#1080
        #1085#1086#1074#1072#1103' '#1082#1086#1083#1086#1085#1082#1072
        #1074' '#1090#1086#1081' '#1078#1077' '#1082#1086#1083#1086#1085#1082#1077)
    end
    object CheckBoxGeneral: TCheckBox
      Left = 147
      Top = 147
      Width = 124
      Height = 17
      Caption = #1054#1089#1085#1086#1074#1085#1086#1081' '#1087#1072#1088#1072#1084#1077#1090#1088
      TabOrder = 11
    end
    object EditPlacing: TEdit
      Left = 95
      Top = 199
      Width = 203
      Height = 21
      TabOrder = 13
    end
    object ButtonElementType: TButton
      Left = 277
      Top = 118
      Width = 21
      Height = 21
      Hint = #1059#1073#1088#1072#1090#1100' '#1090#1080#1087' '#1101#1083#1077#1084#1077#1085#1090#1072
      Caption = #1061
      TabOrder = 9
      OnClick = ButtonElementTypeClick
    end
  end
  inherited ImageList: TImageList
    Left = 152
    Top = 0
  end
end
