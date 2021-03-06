inherited BisTaxiDataReceiptEditForm: TBisTaxiDataReceiptEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataReceiptEditForm'
  ClientHeight = 282
  ClientWidth = 493
  ExplicitWidth = 501
  ExplicitHeight = 316
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 244
    Width = 493
    ExplicitTop = 244
    ExplicitWidth = 493
    DesignSize = (
      493
      38)
    inherited ButtonOk: TButton
      Left = 314
      ExplicitLeft = 314
    end
    inherited ButtonCancel: TButton
      Left = 410
      ExplicitLeft = 410
    end
  end
  inherited PanelControls: TPanel
    Width = 493
    Height = 244
    ExplicitWidth = 493
    ExplicitHeight = 244
    DesignSize = (
      493
      244)
    object LabelDescription: TLabel
      Left = 31
      Top = 123
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelSum: TLabel
      Left = 304
      Top = 69
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1091#1084#1084#1072':'
      FocusControl = EditSum
    end
    object LabelAccount: TLabel
      Left = 55
      Top = 42
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1095#1077#1090':'
      FocusControl = EditAccount
    end
    object LabelDateReceipt: TLabel
      Left = 54
      Top = 96
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072':'
      FocusControl = DateTimePickerReceipt
    end
    object LabelType: TLabel
      Left = 61
      Top = 15
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076':'
      FocusControl = ComboBoxType
    end
    object LabelWho: TLabel
      Left = 23
      Top = 215
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1050#1090#1086' '#1089#1086#1079#1076#1072#1083':'
      FocusControl = EditWho
      ExplicitTop = 236
    end
    object LabelDateCreate: TLabel
      Left = 272
      Top = 215
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1086#1075#1076#1072':'
      FocusControl = DateTimePickerCreate
      ExplicitTop = 236
    end
    object LabelFirm: TLabel
      Left = 14
      Top = 69
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object MemoDescription: TMemo
      Left = 90
      Top = 120
      Width = 391
      Height = 86
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 7
    end
    object EditSum: TEdit
      Left = 345
      Top = 66
      Width = 75
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object DateTimePickerReceipt: TDateTimePicker
      Left = 90
      Top = 93
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 5
    end
    object DateTimePickerReceiptTime: TDateTimePicker
      Left = 184
      Top = 93
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 6
    end
    object EditAccount: TEdit
      Left = 90
      Top = 39
      Width = 303
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonAccount: TButton
      Left = 399
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 2
      OnClick = ButtonAccountClick
    end
    object ComboBoxType: TComboBox
      Left = 90
      Top = 12
      Width = 263
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
    end
    object EditWho: TEdit
      Left = 90
      Top = 212
      Width = 140
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 8
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 313
      Top = 212
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 10
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 407
      Top = 212
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 11
    end
    object ButtonWho: TButton
      Left = 236
      Top = 212
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 9
    end
    object ComboBoxFirm: TComboBox
      Left = 90
      Top = 66
      Width = 201
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 3
    end
  end
  inherited ImageList: TImageList
    Left = 160
    Top = 120
  end
  object PopupAccount: TPopupActionBar
    OnPopup = PopupAccountPopup
    Left = 280
    Top = 128
    object MenuItemAccounts: TMenuItem
      Caption = #1059#1095#1077#1090#1085#1099#1077' '#1079#1072#1087#1080#1089#1080
      OnClick = MenuItemAccountsClick
    end
    object MenuItemDrivers: TMenuItem
      Caption = #1042#1086#1076#1080#1090#1077#1083#1080
      OnClick = MenuItemDriversClick
    end
    object MenuItemClients: TMenuItem
      Caption = #1050#1083#1080#1077#1085#1090#1099
      OnClick = MenuItemClientsClick
    end
  end
end
