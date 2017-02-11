inherited BisTaxiDataInMessageEditForm: TBisTaxiDataInMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataInMessageEditForm'
  ClientHeight = 346
  ClientWidth = 502
  ExplicitWidth = 510
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 308
    Width = 502
    ExplicitTop = 308
    ExplicitWidth = 502
    DesignSize = (
      502
      38)
    inherited ButtonOk: TButton
      Left = 323
      ExplicitLeft = 323
    end
    inherited ButtonCancel: TButton
      Left = 419
      ExplicitLeft = 419
    end
  end
  inherited PanelControls: TPanel
    Width = 502
    Height = 308
    ExplicitWidth = 502
    ExplicitHeight = 308
    DesignSize = (
      502
      308)
    object LabelSender: TLabel
      Left = 14
      Top = 42
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100':'
      FocusControl = EditSender
    end
    object LabelDateSend: TLabel
      Left = 234
      Top = 273
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerSend
    end
    object LabelDateIn: TLabel
      Left = 228
      Top = 246
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103':'
      FocusControl = DateTimePickerIn
    end
    object LabelType: TLabel
      Left = 64
      Top = 15
      Width = 22
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087':'
      FocusControl = ComboBoxType
      Transparent = True
    end
    object LabelContact: TLabel
      Left = 289
      Top = 69
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1090#1072#1082#1090':'
      FocusControl = EditContact
    end
    object LabelText: TLabel
      Left = 53
      Top = 93
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object LabelCodeMessage: TLabel
      Left = 62
      Top = 69
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1076':'
      FocusControl = EditCodeMessage
    end
    object LabelDescription: TLabel
      Left = 33
      Top = 167
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelFirm: TLabel
      Left = 245
      Top = 219
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object EditSender: TEdit
      Left = 92
      Top = 39
      Width = 244
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object DateTimePickerSend: TDateTimePicker
      Left = 321
      Top = 270
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 11
    end
    object DateTimePickerSendTime: TDateTimePicker
      Left = 415
      Top = 270
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 12
    end
    object ButtonSender: TButton
      Left = 342
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 2
      OnClick = ButtonSenderClick
    end
    object DateTimePickerIn: TDateTimePicker
      Left = 321
      Top = 243
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 9
    end
    object DateTimePickerInTime: TDateTimePicker
      Left = 415
      Top = 243
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 10
    end
    object ComboBoxType: TComboBox
      Left = 92
      Top = 12
      Width = 91
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditContact: TEdit
      Left = 342
      Top = 66
      Width = 147
      Height = 21
      MaxLength = 100
      TabOrder = 5
    end
    object MemoText: TMemo
      Left = 92
      Top = 93
      Width = 397
      Height = 68
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 6
    end
    object EditCodeMessage: TEdit
      Left = 92
      Top = 66
      Width = 157
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
    end
    object ButtonCodeMessage: TButton
      Left = 255
      Top = 66
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1082#1086#1076' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
      Caption = '...'
      TabOrder = 4
    end
    object MemoDescription: TMemo
      Left = 92
      Top = 167
      Width = 397
      Height = 43
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 7
    end
    object ComboBoxFirm: TComboBox
      Left = 321
      Top = 216
      Width = 168
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 8
    end
  end
  inherited ImageList: TImageList
    Left = 224
    Top = 104
  end
  object PopupAccount: TPopupActionBar
    OnPopup = PopupAccountPopup
    Left = 120
    Top = 120
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
