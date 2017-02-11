inherited BisRegForm: TBisRegForm
  Left = 0
  Top = 0
  ActiveControl = EditKey
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeable
  Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
  ClientHeight = 286
  ClientWidth = 436
  ExplicitWidth = 452
  ExplicitHeight = 324
  PixelsPerInch = 96
  TextHeight = 13
  object LabelProduct: TLabel [0]
    Left = 26
    Top = 11
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = #1055#1088#1086#1076#1091#1082#1090':'
  end
  object LabelWay: TLabel [1]
    Left = 301
    Top = 11
    Width = 40
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = #1057#1087#1086#1089#1086#1073':'
    FocusControl = ComboBoxWay
  end
  object LabelProductName: TLabel [2]
    Left = 80
    Top = 12
    Width = 215
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'SMS Server 1.0 Unlimited'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = LabelProductNameClick
    OnMouseEnter = LabelProductNameMouseEnter
    OnMouseLeave = LabelProductNameMouseLeave
  end
  inherited PanelButton: TPanel
    Top = 251
    Width = 436
    TabOrder = 2
    ExplicitTop = 251
    ExplicitWidth = 436
    inherited ButtonOk: TButton
      Left = 270
      OnClick = ButtonOkClick
      ExplicitLeft = 270
    end
    inherited ButtonCancel: TButton
      Left = 351
      ExplicitLeft = 351
    end
  end
  object GroupBoxData: TGroupBox
    Left = 8
    Top = 34
    Width = 420
    Height = 207
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' '#1044#1072#1085#1085#1099#1077' '
    TabOrder = 1
    DesignSize = (
      420
      207)
    object LabelEmail: TLabel
      Left = 234
      Top = 47
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Email:'
      FocusControl = EditEmail
    end
    object LabelSurname: TLabel
      Left = 18
      Top = 74
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
    end
    object LabelName: TLabel
      Left = 43
      Top = 47
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelPatronymic: TLabel
      Left = 209
      Top = 74
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
    end
    object LabelCompany: TLabel
      Left = 13
      Top = 101
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1084#1087#1072#1085#1080#1103':'
      FocusControl = EditCompany
    end
    object LabelAddress: TLabel
      Left = 31
      Top = 128
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1076#1088#1077#1089':'
      FocusControl = EditAddress
    end
    object LabelPhone: TLabel
      Left = 18
      Top = 155
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object LabelSite: TLabel
      Left = 221
      Top = 155
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1072#1081#1090':'
      FocusControl = EditSite
    end
    object LabelEmailNeed: TLabel
      Left = 400
      Top = 47
      Width = 6
      Height = 13
      Anchors = [akTop, akRight]
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelNameNeed: TLabel
      Left = 205
      Top = 47
      Width = 6
      Height = 13
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LabelKey: TLabel
      Left = 34
      Top = 20
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1083#1102#1095':'
      FocusControl = EditKey
    end
    object LabelKeyNeed: TLabel
      Left = 287
      Top = 20
      Width = 6
      Height = 13
      Anchors = [akTop, akRight]
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EditEmail: TEdit
      Left = 268
      Top = 44
      Width = 126
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 2
      Text = 'nextsoft@mail.ru'
    end
    object EditSurname: TEdit
      Left = 72
      Top = 71
      Width = 127
      Height = 21
      MaxLength = 100
      TabOrder = 3
      Text = #1058#1086#1084#1080#1083#1086#1074
    end
    object EditName: TEdit
      Left = 72
      Top = 44
      Width = 127
      Height = 21
      MaxLength = 100
      TabOrder = 1
      Text = #1057#1077#1088#1075#1077#1081
    end
    object EditPatronymic: TEdit
      Left = 268
      Top = 71
      Width = 138
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 4
      Text = #1042#1103#1095#1077#1089#1083#1072#1074#1086#1074#1080#1095
    end
    object EditCompany: TEdit
      Left = 72
      Top = 98
      Width = 334
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 5
      Text = 'NextSoft'
    end
    object EditAddress: TEdit
      Left = 72
      Top = 125
      Width = 334
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 250
      TabOrder = 6
      Text = #1056#1086#1089#1089#1080#1103', '#1075'.'#1050#1088#1072#1089#1085#1086#1103#1088#1089#1082', '#1091#1083'.'#1065#1086#1088#1089#1072' 15-40'
    end
    object EditPhone: TEdit
      Left = 72
      Top = 152
      Width = 139
      Height = 21
      MaxLength = 100
      TabOrder = 7
      Text = '+79029232332'
    end
    object EditSite: TEdit
      Left = 256
      Top = 152
      Width = 150
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 8
      Text = 'http://nextsoft.biz'
    end
    object CheckBoxInfo: TCheckBox
      Left = 72
      Top = 179
      Width = 249
      Height = 17
      Hint = 
        #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1085#1086#1084' '#1086#1073#1077#1089#1087#1077#1095#1077#1085#1080#1080' '#1080' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086 +
        #1084' '#1085#1072' '#1101#1090#1086#1084' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1077
      Caption = #1054#1090#1087#1088#1072#1074#1083#1103#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1091#1102' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1102
      TabOrder = 9
    end
    object EditKey: TEdit
      Left = 72
      Top = 17
      Width = 209
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 32
      TabOrder = 0
      Text = '90AAE45C3CE2993A4F6E461E25931E62'
    end
  end
  object ComboBoxWay: TComboBox
    Left = 347
    Top = 7
    Width = 72
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = #1087#1088#1103#1084#1086#1081
    Items.Strings = (
      #1087#1088#1103#1084#1086#1081
      #1087#1086#1095#1090#1072)
  end
end
