inherited BisTaxiDataResultEditForm: TBisTaxiDataResultEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataResultEditForm'
  ClientHeight = 354
  ClientWidth = 326
  ExplicitWidth = 334
  ExplicitHeight = 388
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 316
    Width = 326
    ExplicitTop = 316
    ExplicitWidth = 326
    inherited ButtonOk: TButton
      Left = 147
      ExplicitLeft = 147
    end
    inherited ButtonCancel: TButton
      Left = 243
      ExplicitLeft = 243
    end
  end
  inherited PanelControls: TPanel
    Width = 326
    Height = 316
    ExplicitWidth = 326
    ExplicitHeight = 316
    object LabelAction: TLabel
      Left = 36
      Top = 14
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
      FocusControl = EditAction
    end
    object LabelNext: TLabel
      Left = 23
      Top = 152
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1057#1083#1077#1076#1091#1102#1097#1077#1077':'
      FocusControl = EditNext
    end
    object LabelName: TLabel
      Left = 12
      Top = 41
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 36
      Top = 68
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelFontColor: TLabel
      Left = 83
      Top = 233
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1062#1074#1077#1090' '#1096#1088#1080#1092#1090#1072':'
      FocusControl = ColorBoxFontColor
    end
    object LabelBrushColor: TLabel
      Left = 97
      Top = 261
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072':'
      FocusControl = ColorBoxBrushColor
    end
    object LabelProcDetect: TLabel
      Left = 26
      Top = 179
      Width = 130
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103':'
      FocusControl = EditProcDetect
    end
    object LabelPriority: TLabel
      Left = 108
      Top = 289
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelProcProcess: TLabel
      Left = 39
      Top = 206
      Width = 117
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072' '#1086#1073#1088#1072#1073#1086#1090#1082#1080':'
      FocusControl = EditProcProcess
    end
    object EditAction: TEdit
      Left = 95
      Top = 11
      Width = 219
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object EditNext: TEdit
      Left = 95
      Top = 149
      Width = 192
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
    end
    object ButtonNext: TButton
      Left = 293
      Top = 149
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1089#1083#1077#1076#1091#1102#1097#1077#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 4
    end
    object EditName: TEdit
      Left = 95
      Top = 38
      Width = 219
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 1
    end
    object ColorBoxFontColor: TColorBox
      Left = 162
      Top = 230
      Width = 152
      Height = 22
      DefaultColorColor = clWindowText
      NoneColorColor = clWindowText
      Selected = clWindowText
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akRight, akBottom]
      ItemHeight = 16
      TabOrder = 7
    end
    object MemoDescription: TMemo
      Left = 95
      Top = 65
      Width = 219
      Height = 78
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
    object ColorBoxBrushColor: TColorBox
      Left = 162
      Top = 258
      Width = 152
      Height = 22
      DefaultColorColor = clWindow
      NoneColorColor = clWindow
      Selected = clWindowText
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
      Anchors = [akRight, akBottom]
      ItemHeight = 16
      TabOrder = 8
    end
    object EditProcDetect: TEdit
      Left = 162
      Top = 176
      Width = 152
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 5
    end
    object EditPriority: TEdit
      Left = 162
      Top = 286
      Width = 54
      Height = 21
      Anchors = [akRight, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 9
    end
    object EditProcProcess: TEdit
      Left = 162
      Top = 203
      Width = 152
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 6
    end
    object CheckBoxVisible: TCheckBox
      Left = 225
      Top = 288
      Width = 75
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = #1042#1080#1076#1080#1084#1099#1081
      TabOrder = 10
    end
  end
end
