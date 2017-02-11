inherited BisKrieltDataCreditProgramEditForm: TBisKrieltDataCreditProgramEditForm
  Left = 649
  Top = 187
  Caption = 'BisKrieltDataCreditProgramEditForm'
  ClientHeight = 370
  ClientWidth = 361
  ExplicitWidth = 369
  ExplicitHeight = 404
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 332
    Width = 361
    ExplicitTop = 332
    ExplicitWidth = 361
    inherited ButtonOk: TButton
      Left = 182
      ExplicitLeft = 182
    end
    inherited ButtonCancel: TButton
      Left = 279
      ExplicitLeft = 279
    end
  end
  inherited PanelControls: TPanel
    Width = 361
    Height = 332
    ExplicitWidth = 361
    ExplicitHeight = 332
    object LabelFirm: TLabel
      Left = 29
      Top = 15
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      FocusControl = EditFirm
    end
    object LabelName: TLabel
      Left = 22
      Top = 42
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 46
      Top = 96
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelType: TLabel
      Left = 19
      Top = 69
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
      FocusControl = ComboBoxType
    end
    object LabelPeriodMin: TLabel
      Left = 33
      Top = 191
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1080#1085#1080#1084'. '#1089#1088#1086#1082':'
      FocusControl = EditPeriodMin
    end
    object LabelPeriodMax: TLabel
      Left = 206
      Top = 191
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1072#1082#1089'. '#1089#1088#1086#1082':'
      FocusControl = EditPeriodMax
    end
    object LabelRateFrom: TLabel
      Left = 43
      Top = 218
      Width = 56
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1072#1074#1082#1072' '#1086#1090':'
      FocusControl = EditRateFrom
    end
    object LabelRateBefore: TLabel
      Left = 208
      Top = 218
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1072#1074#1082#1072' '#1076#1086':'
      FocusControl = EditRateBefore
    end
    object LabelAmountMin: TLabel
      Left = 27
      Top = 245
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1080#1085#1080#1084'. '#1089#1091#1084#1084#1072':'
      FocusControl = EditAmountMin
    end
    object LabelAmountMax: TLabel
      Left = 200
      Top = 245
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1072#1082#1089'. '#1089#1091#1084#1084#1072':'
      FocusControl = EditAmountMax
    end
    object LabelAgeFrom: TLabel
      Left = 34
      Top = 272
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1079#1074#1088#1072#1089#1090' '#1086#1090':'
      FocusControl = EditAgeFrom
    end
    object LabelAgeBefore: TLabel
      Left = 199
      Top = 272
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1079#1074#1088#1072#1089#1090' '#1076#1086':'
      FocusControl = EditAgeBefore
    end
    object LabelCurrency: TLabel
      Left = 176
      Top = 299
      Width = 89
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1072#1083#1102#1090#1072' '#1082#1088#1077#1076#1080#1090#1072':'
      FocusControl = ComboBoxCurrency
    end
    object EditFirm: TEdit
      Left = 105
      Top = 12
      Width = 215
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonFirm: TButton
      Left = 326
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 1
    end
    object EditName: TEdit
      Left = 105
      Top = 39
      Width = 242
      Height = 21
      TabOrder = 2
    end
    object MemoDescription: TMemo
      Left = 105
      Top = 93
      Width = 242
      Height = 89
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object ComboBoxType: TComboBox
      Left = 105
      Top = 66
      Width = 165
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 3
    end
    object EditPeriodMin: TEdit
      Left = 105
      Top = 188
      Width = 76
      Height = 21
      TabOrder = 5
    end
    object EditPeriodMax: TEdit
      Left = 271
      Top = 188
      Width = 76
      Height = 21
      TabOrder = 6
    end
    object EditRateFrom: TEdit
      Left = 105
      Top = 215
      Width = 76
      Height = 21
      TabOrder = 7
    end
    object EditRateBefore: TEdit
      Left = 271
      Top = 215
      Width = 76
      Height = 21
      TabOrder = 8
    end
    object EditAmountMin: TEdit
      Left = 105
      Top = 242
      Width = 76
      Height = 21
      TabOrder = 9
    end
    object EditAmountMax: TEdit
      Left = 271
      Top = 242
      Width = 76
      Height = 21
      TabOrder = 10
    end
    object EditAgeFrom: TEdit
      Left = 105
      Top = 269
      Width = 76
      Height = 21
      TabOrder = 11
    end
    object EditAgeBefore: TEdit
      Left = 271
      Top = 269
      Width = 76
      Height = 21
      TabOrder = 12
    end
    object ComboBoxCurrency: TComboBox
      Left = 271
      Top = 296
      Width = 76
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 13
      Items.Strings = (
        #1088#1091#1073#1083#1100
        #1076#1086#1083#1083#1072#1088
        #1077#1074#1088#1086)
    end
  end
end