inherited BisCallcHbookPaymentEditForm: TBisCallcHbookPaymentEditForm
  Left = 381
  Top = 211
  Caption = 'BisCallcHbookPaymentEditForm'
  ClientHeight = 227
  ClientWidth = 494
  ExplicitLeft = 381
  ExplicitTop = 211
  ExplicitWidth = 502
  ExplicitHeight = 254
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 189
    Width = 494
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 317
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 414
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 494
    Height = 189
    ExplicitTop = 1
    ExplicitWidth = 445
    ExplicitHeight = 189
    object LabelDatePayment: TLabel
      Left = 265
      Top = 16
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1087#1083#1072#1090#1077#1078#1072':'
      FocusControl = DateTimePickerPayment
    end
    object LabelAmount: TLabel
      Left = 17
      Top = 43
      Width = 83
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1091#1084#1084#1072' '#1087#1083#1072#1090#1077#1078#1072':'
      FocusControl = EditAmount
    end
    object LabelDeal: TLabel
      Left = 16
      Top = 16
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1088#1077#1076#1080#1090#1085#1086#1077' '#1076#1077#1083#1086':'
      FocusControl = EditDeal
    end
    object LabelState: TLabel
      Left = 92
      Top = 165
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077':'
      FocusControl = ComboBoxState
      ExplicitLeft = 43
    end
    object LabelDescription: TLabel
      Left = 27
      Top = 70
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
      FocusControl = MemoDescription
    end
    object LabelAccount: TLabel
      Left = 267
      Top = 165
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1090#1086' '#1074#1074#1077#1083':'
      FocusControl = EditAccount
      ExplicitLeft = 218
    end
    object LabelCurrentDebt: TLabel
      Left = 349
      Top = 43
      Width = 136
      Height = 13
      AutoSize = False
      Caption = #1054#1089#1090#1072#1090#1086#1082':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelInitialDebt: TLabel
      Left = 220
      Top = 43
      Width = 123
      Height = 13
      AutoSize = False
      Caption = #1044#1086#1083#1075':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DateTimePickerPayment: TDateTimePicker
      Left = 346
      Top = 13
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 2
    end
    object EditAmount: TEdit
      Left = 106
      Top = 40
      Width = 103
      Height = 21
      TabOrder = 3
    end
    object EditDeal: TEdit
      Left = 106
      Top = 13
      Width = 103
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonDeal: TButton
      Left = 215
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1082#1088#1077#1076#1080#1090#1085#1086#1077' '#1076#1077#1083#1086
      Caption = '...'
      TabOrder = 1
    end
    object ComboBoxState: TComboBox
      Left = 155
      Top = 162
      Width = 103
      Height = 21
      Style = csDropDownList
      Anchors = [akRight, akBottom]
      ItemHeight = 13
      TabOrder = 5
      ExplicitLeft = 106
    end
    object MemoDescription: TMemo
      Left = 106
      Top = 67
      Width = 377
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 4
      ExplicitWidth = 328
    end
    object EditAccount: TEdit
      Left = 321
      Top = 162
      Width = 137
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 6
      ExplicitLeft = 272
    end
    object ButtonAccount: TButton
      Left = 464
      Top = 162
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 7
      ExplicitLeft = 415
    end
  end
end
