inherited BisKrieltDataInputParamEditForm: TBisKrieltDataInputParamEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataInputParamEditForm'
  ClientHeight = 236
  ClientWidth = 297
  ExplicitWidth = 305
  ExplicitHeight = 270
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 198
    Width = 297
    ExplicitTop = 198
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 118
      ExplicitLeft = 118
    end
    inherited ButtonCancel: TButton
      Left = 215
      ExplicitLeft = 215
    end
  end
  inherited PanelControls: TPanel
    Width = 297
    Height = 198
    ExplicitTop = -1
    ExplicitWidth = 297
    ExplicitHeight = 198
    object LabelParam: TLabel
      Left = 29
      Top = 94
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
      FocusControl = EditParam
    end
    object LabelType: TLabel
      Left = 14
      Top = 40
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072':'
      FocusControl = EditType
    end
    object LabelOperation: TLabel
      Left = 28
      Top = 67
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      FocusControl = EditOperation
    end
    object LabelView: TLabel
      Left = 13
      Top = 13
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1072':'
      FocusControl = EditView
    end
    object LabelElementType: TLabel
      Left = 12
      Top = 121
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1101#1083#1077#1084#1077#1085#1090#1072':'
      FocusControl = ComboBoxElementType
    end
    object LabelPriority: TLabel
      Left = 36
      Top = 148
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelPosition: TLabel
      Left = 187
      Top = 148
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1079#1080#1094#1080#1103':'
      FocusControl = EditPosition
    end
    object EditParam: TEdit
      Left = 90
      Top = 91
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 6
    end
    object ButtonParam: TButton
      Left = 264
      Top = 91
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Caption = '...'
      TabOrder = 7
    end
    object EditType: TEdit
      Left = 90
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonType: TButton
      Left = 264
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087' '#1086#1073#1098#1077#1082#1090#1072
      Caption = '...'
      TabOrder = 3
    end
    object EditOperation: TEdit
      Left = 90
      Top = 64
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonOperation: TButton
      Left = 264
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 5
    end
    object CheckBoxRequired: TCheckBox
      Left = 90
      Top = 172
      Width = 97
      Height = 17
      Caption = #1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1081
      TabOrder = 12
    end
    object EditView: TEdit
      Left = 90
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonView: TButton
      Left = 264
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1086#1073#1098#1077#1082#1090#1072
      Caption = '...'
      TabOrder = 1
    end
    object ComboBoxElementType: TComboBox
      Left = 90
      Top = 118
      Width = 168
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
    object EditPriority: TEdit
      Left = 90
      Top = 145
      Width = 46
      Height = 21
      TabOrder = 10
    end
    object EditPosition: TEdit
      Left = 239
      Top = 145
      Width = 46
      Height = 21
      TabOrder = 11
    end
    object ButtonElementType: TButton
      Left = 264
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
    Left = 144
    Top = 48
  end
end
