inherited BisCallcHbookDebtorEditForm: TBisCallcHbookDebtorEditForm
  Left = 409
  Top = 153
  Caption = 'BisCallcHbookDebtorEditForm'
  ClientHeight = 467
  ClientWidth = 661
  ExplicitLeft = 409
  ExplicitTop = 153
  ExplicitWidth = 669
  ExplicitHeight = 494
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 429
    Width = 661
    ExplicitTop = 429
    ExplicitWidth = 661
    inherited ButtonOk: TButton
      Left = 484
      ExplicitLeft = 484
    end
    inherited ButtonCancel: TButton
      Left = 581
      ExplicitLeft = 581
    end
  end
  inherited PanelControls: TPanel
    Width = 661
    Height = 429
    ExplicitWidth = 661
    ExplicitHeight = 429
    object LabelSurname: TLabel
      Left = 62
      Top = 39
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
    end
    object LabelPassport: TLabel
      Left = 48
      Top = 66
      Width = 66
      Height = 26
      Alignment = taRightJustify
      Caption = #1055#1072#1089#1087#1086#1088#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077':'
      Color = clBtnFace
      FocusControl = MemoPassport
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      WordWrap = True
    end
    object LabelType: TLabel
      Left = 39
      Top = 12
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1076#1086#1083#1078#1085#1080#1082#1072':'
      FocusControl = ComboBoxType
    end
    object LabelName: TLabel
      Left = 280
      Top = 39
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelPatronymic: TLabel
      Left = 445
      Top = 39
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
    end
    object LabelSex: TLabel
      Left = 219
      Top = 121
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083':'
      FocusControl = ComboBoxSex
    end
    object LabelDateBirth: TLabel
      Left = 32
      Top = 121
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103':'
      FocusControl = DateTimePickerBirth
    end
    object LabelPlaceBirth: TLabel
      Left = 26
      Top = 148
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1077#1089#1090#1086' '#1088#1086#1078#1076#1077#1085#1080#1103':'
    end
    object LabelAddressResidence: TLabel
      Left = 29
      Top = 175
      Width = 85
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089' '#1087#1088#1086#1087#1080#1089#1082#1080':'
      FocusControl = EditAddressResidence
    end
    object LabelIndexResidence: TLabel
      Left = 510
      Top = 176
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1085#1076#1077#1082#1089':'
      FocusControl = EditIndexResidence
    end
    object LabelAddressActual: TLabel
      Left = 9
      Top = 202
      Width = 105
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089':'
      FocusControl = EditAddressActual
    end
    object LabelIndexActual: TLabel
      Left = 510
      Top = 203
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1085#1076#1077#1082#1089':'
      FocusControl = EditIndexActual
    end
    object LabelAddressAdditional: TLabel
      Left = 25
      Top = 229
      Width = 89
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090'. '#1072#1076#1088#1077#1089':'
      FocusControl = EditAddressAdditional
    end
    object LabelIndexAdditional: TLabel
      Left = 510
      Top = 230
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1085#1076#1077#1082#1089':'
      FocusControl = EditIndexAdditional
    end
    object LabelPlaceWork: TLabel
      Left = 39
      Top = 256
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099':'
      FocusControl = EditPlaceWork
    end
    object LabelJobTitle: TLabel
      Left = 378
      Top = 257
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
      FocusControl = EditJobTitle
    end
    object LabelAddressWork: TLabel
      Left = 40
      Top = 283
      Width = 74
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089' '#1088#1072#1073#1086#1090#1099':'
      FocusControl = EditAddressWork
    end
    object LabelIndexWork: TLabel
      Left = 510
      Top = 284
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1085#1076#1077#1082#1089':'
      FocusControl = EditIndexWork
    end
    object LabelPhoneHome: TLabel
      Left = 10
      Top = 310
      Width = 104
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1086#1084#1072#1096#1085#1080#1081' '#1090#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhoneHome
    end
    object LabelPhoneWork: TLabel
      Left = 262
      Top = 310
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1072#1073#1086#1095#1080#1081':'
      FocusControl = EditPhoneWork
    end
    object LabelPhoneMobile: TLabel
      Left = 453
      Top = 311
      Width = 62
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081':'
      FocusControl = EditPhoneMobile
    end
    object LabelPhoneOther1: TLabel
      Left = 65
      Top = 337
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1088#1091#1075#1086#1081' 1:'
      FocusControl = EditPhoneOther1
    end
    object LabelPhoneOther2: TLabel
      Left = 258
      Top = 337
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1088#1091#1075#1086#1081' 2:'
      FocusControl = EditPhoneOther2
    end
    object LabelFounders: TLabel
      Left = 51
      Top = 364
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1088#1077#1076#1080#1090#1077#1083#1080':'
      Enabled = False
      FocusControl = MemoFounders
    end
    object EditSurname: TEdit
      Left = 120
      Top = 36
      Width = 150
      Height = 21
      TabOrder = 1
    end
    object MemoPassport: TMemo
      Left = 120
      Top = 63
      Width = 531
      Height = 49
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object ComboBoxType: TComboBox
      Left = 120
      Top = 9
      Width = 150
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditName: TEdit
      Left = 311
      Top = 36
      Width = 120
      Height = 21
      TabOrder = 2
    end
    object EditPatronymic: TEdit
      Left = 501
      Top = 36
      Width = 150
      Height = 21
      TabOrder = 3
    end
    object ComboBoxSex: TComboBox
      Left = 248
      Top = 118
      Width = 88
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
    object DateTimePickerBirth: TDateTimePicker
      Left = 120
      Top = 118
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 5
    end
    object EditAddressResidence: TEdit
      Left = 120
      Top = 172
      Width = 375
      Height = 21
      TabOrder = 8
    end
    object EditIndexResidence: TEdit
      Left = 557
      Top = 173
      Width = 94
      Height = 21
      TabOrder = 9
    end
    object EditAddressActual: TEdit
      Left = 120
      Top = 199
      Width = 375
      Height = 21
      TabOrder = 10
    end
    object EditIndexActual: TEdit
      Left = 557
      Top = 200
      Width = 94
      Height = 21
      TabOrder = 11
    end
    object EditAddressAdditional: TEdit
      Left = 120
      Top = 226
      Width = 375
      Height = 21
      TabOrder = 12
    end
    object EditIndexAdditional: TEdit
      Left = 557
      Top = 227
      Width = 94
      Height = 21
      TabOrder = 13
    end
    object EditPlaceWork: TEdit
      Left = 120
      Top = 253
      Width = 243
      Height = 21
      TabOrder = 14
    end
    object EditJobTitle: TEdit
      Left = 445
      Top = 254
      Width = 206
      Height = 21
      TabOrder = 15
    end
    object EditAddressWork: TEdit
      Left = 120
      Top = 280
      Width = 375
      Height = 21
      TabOrder = 16
    end
    object EditIndexWork: TEdit
      Left = 557
      Top = 281
      Width = 94
      Height = 21
      TabOrder = 17
    end
    object EditPhoneHome: TEdit
      Left = 120
      Top = 307
      Width = 130
      Height = 21
      TabOrder = 18
    end
    object EditPhoneWork: TEdit
      Left = 313
      Top = 307
      Width = 130
      Height = 21
      TabOrder = 19
    end
    object EditPhoneMobile: TEdit
      Left = 521
      Top = 308
      Width = 130
      Height = 21
      TabOrder = 20
    end
    object EditPhoneOther1: TEdit
      Left = 120
      Top = 334
      Width = 130
      Height = 21
      TabOrder = 21
    end
    object EditPhoneOther2: TEdit
      Left = 313
      Top = 334
      Width = 130
      Height = 21
      TabOrder = 22
    end
    object MemoFounders: TMemo
      Left = 120
      Top = 361
      Width = 531
      Height = 62
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBtnFace
      Enabled = False
      ScrollBars = ssVertical
      TabOrder = 23
    end
    object EditPlaceBirth: TEdit
      Left = 120
      Top = 145
      Width = 531
      Height = 21
      TabOrder = 7
    end
  end
end
