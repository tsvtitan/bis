inherited BisCallcHbookResultEditForm: TBisCallcHbookResultEditForm
  Left = 533
  Top = 247
  Caption = 'BisCallcHbookResultEditForm'
  ClientHeight = 272
  ClientWidth = 306
  ExplicitLeft = 533
  ExplicitTop = 247
  ExplicitWidth = 314
  ExplicitHeight = 299
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 234
    Width = 306
    ExplicitTop = 197
    ExplicitWidth = 495
    inherited ButtonOk: TButton
      Left = 129
      ExplicitLeft = 318
    end
    inherited ButtonCancel: TButton
      Left = 226
      ExplicitLeft = 415
    end
  end
  inherited PanelControls: TPanel
    Width = 306
    Height = 234
    ExplicitTop = 1
    ExplicitWidth = 636
    ExplicitHeight = 344
    object LabelAction: TLabel
      Left = 46
      Top = 161
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelName: TLabel
      Left = 20
      Top = 12
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 46
      Top = 39
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPeriod: TLabel
      Left = 58
      Top = 188
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1077#1088#1080#1086#1076':'
      FocusControl = EditPeriod
    end
    object LabelType: TLabel
      Left = 17
      Top = 134
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072':'
      FocusControl = ComboBoxType
    end
    object EditAction: TEdit
      Left = 105
      Top = 158
      Width = 165
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
    end
    object ButtonAction: TButton
      Left = 276
      Top = 158
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      Caption = '...'
      TabOrder = 4
    end
    object EditName: TEdit
      Left = 105
      Top = 9
      Width = 192
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 105
      Top = 36
      Width = 192
      Height = 89
      TabOrder = 1
    end
    object CheckBoxChoiceDate: TCheckBox
      Left = 166
      Top = 187
      Width = 115
      Height = 17
      Caption = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099
      TabOrder = 6
    end
    object EditPeriod: TEdit
      Left = 105
      Top = 185
      Width = 55
      Height = 21
      TabOrder = 5
    end
    object ComboBoxType: TComboBox
      Left = 105
      Top = 131
      Width = 192
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        #1053#1077#1090' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1076#1077#1081#1089#1090#1074#1080#1103
        #1057#1083#1077#1076#1091#1097#1077#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
        #1047#1072#1082#1088#1099#1090#1080#1077' '#1076#1077#1083#1072
        #1055#1088#1080#1084#1077#1085#1077#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1087#1083#1072#1085#1072)
    end
    object CheckBoxChoicePerformer: TCheckBox
      Left = 105
      Top = 210
      Width = 136
      Height = 17
      Caption = #1042#1099#1073#1086#1088' '#1080#1089#1087#1086#1083#1085#1080#1090#1077#1083#1103
      TabOrder = 7
    end
  end
end
