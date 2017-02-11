inherited BisTaxiDataInMessageFilterForm: TBisTaxiDataInMessageFilterForm
  Caption = 'BisTaxiDataInMessageFilterForm'
  ClientHeight = 344
  ClientWidth = 524
  ExplicitWidth = 532
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 306
    Width = 524
    ExplicitTop = 306
    ExplicitWidth = 524
    inherited ButtonOk: TButton
      Left = 345
      ExplicitLeft = 345
    end
    inherited ButtonCancel: TButton
      Left = 441
      ExplicitLeft = 441
    end
  end
  inherited PanelControls: TPanel
    Width = 524
    Height = 306
    ExplicitWidth = 524
    ExplicitHeight = 306
    inherited LabelSender: TLabel
      Left = 18
      ExplicitLeft = 18
    end
    inherited LabelDateSend: TLabel
      Left = 23
      Top = 275
      Width = 89
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1089':'
      ExplicitLeft = 23
      ExplicitTop = 275
      ExplicitWidth = 89
    end
    inherited LabelDateIn: TLabel
      Left = 17
      Top = 248
      Width = 95
      Caption = #1044#1072#1090#1072' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1089':'
      ExplicitLeft = 17
      ExplicitTop = 248
      ExplicitWidth = 95
    end
    inherited LabelType: TLabel
      Left = 65
      ExplicitLeft = 65
    end
    inherited LabelContact: TLabel
      Left = 285
      ExplicitLeft = 285
    end
    inherited LabelText: TLabel
      Left = 54
      Top = 94
      ExplicitLeft = 54
      ExplicitTop = 94
    end
    object LabelDateInTo: TLabel [6]
      Left = 295
      Top = 248
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerInTo
    end
    object LabelDateSendTo: TLabel [7]
      Left = 295
      Top = 275
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerSendTo
    end
    inherited LabelCodeMessage: TLabel
      Left = 63
      ExplicitLeft = 63
    end
    inherited LabelDescription: TLabel
      Left = 34
      ExplicitLeft = 34
    end
    inherited LabelFirm: TLabel
      Left = 42
      Top = 221
      ExplicitLeft = 42
      ExplicitTop = 221
    end
    inherited EditSender: TEdit
      Left = 93
      ExplicitLeft = 93
    end
    inherited DateTimePickerSend: TDateTimePicker
      Left = 118
      Top = 272
      TabOrder = 14
      ExplicitLeft = 118
      ExplicitTop = 272
    end
    inherited DateTimePickerSendTime: TDateTimePicker
      Left = 212
      Top = 272
      TabOrder = 15
      ExplicitLeft = 212
      ExplicitTop = 272
    end
    inherited ButtonSender: TButton
      Left = 343
      ExplicitLeft = 343
    end
    inherited DateTimePickerIn: TDateTimePicker
      Left = 118
      Top = 245
      ExplicitLeft = 118
      ExplicitTop = 245
    end
    inherited DateTimePickerInTime: TDateTimePicker
      Left = 212
      Top = 245
      ExplicitLeft = 212
      ExplicitTop = 245
    end
    inherited ComboBoxType: TComboBox
      Left = 93
      ExplicitLeft = 93
    end
    inherited EditContact: TEdit
      Left = 338
      Width = 149
      ExplicitLeft = 338
      ExplicitWidth = 149
    end
    inherited MemoText: TMemo
      Left = 93
      Top = 94
      Width = 418
      Height = 67
      ExplicitLeft = 93
      ExplicitTop = 94
      ExplicitWidth = 418
      ExplicitHeight = 67
    end
    inherited EditCodeMessage: TEdit
      Left = 93
      Color = clWindow
      ReadOnly = False
      ExplicitLeft = 93
    end
    inherited ButtonCodeMessage: TButton
      Left = 256
      ExplicitLeft = 256
    end
    inherited MemoDescription: TMemo
      Left = 93
      Width = 419
      Height = 45
      ExplicitLeft = 93
      ExplicitWidth = 419
      ExplicitHeight = 45
    end
    inherited ComboBoxFirm: TComboBox
      Left = 118
      Top = 218
      Width = 394
      ExplicitLeft = 118
      ExplicitTop = 218
      ExplicitWidth = 394
    end
    object DateTimePickerInTo: TDateTimePicker
      Left = 317
      Top = 245
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 11
    end
    object DateTimePickerInToTime: TDateTimePicker
      Left = 411
      Top = 245
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 12
    end
    object DateTimePickerSendTo: TDateTimePicker
      Left = 317
      Top = 272
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 16
    end
    object DateTimePickerSendToTime: TDateTimePicker
      Left = 411
      Top = 272
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 18
    end
    object ButtonSendTo: TButton
      Left = 491
      Top = 272
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 17
      OnClick = ButtonSendToClick
    end
    object ButtonDateIn: TButton
      Left = 491
      Top = 245
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 13
      OnClick = ButtonDateInClick
    end
  end
end