inherited BisTaxiDataDriverInMessageFilterForm: TBisTaxiDataDriverInMessageFilterForm
  Caption = 'BisTaxiDataDriverInMessageFilterForm'
  ClientHeight = 282
  ClientWidth = 524
  ExplicitWidth = 532
  ExplicitHeight = 316
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 244
    Width = 524
    ExplicitTop = 244
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
    Height = 244
    ExplicitWidth = 524
    ExplicitHeight = 244
    inherited LabelSender: TLabel
      Left = 19
      Top = 41
      ExplicitLeft = 19
      ExplicitTop = 41
    end
    inherited LabelDateSend: TLabel
      Left = 30
      Top = 217
      ExplicitLeft = 30
      ExplicitTop = 217
    end
    inherited LabelDateIn: TLabel
      Left = 24
      Top = 190
      ExplicitLeft = 24
      ExplicitTop = 190
    end
    inherited LabelType: TLabel
      Left = 50
      Top = 14
      ExplicitLeft = 50
      ExplicitTop = 14
    end
    inherited LabelContact: TLabel
      Left = 270
      ExplicitLeft = 270
    end
    inherited LabelText: TLabel
      Left = 39
      ExplicitLeft = 39
    end
    object LabelDateInTo: TLabel [6]
      Left = 294
      Top = 190
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerInTo
    end
    object LabelDateSendTo: TLabel [7]
      Left = 294
      Top = 217
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerSendTo
    end
    inherited LabelCodeMessage: TLabel
      Left = 48
      ExplicitLeft = 48
    end
    inherited EditSender: TEdit
      Left = 78
      Top = 38
      Color = clWindow
      ReadOnly = False
      ExplicitLeft = 78
      ExplicitTop = 38
    end
    inherited DateTimePickerSend: TDateTimePicker
      Left = 117
      Top = 214
      TabOrder = 12
      ExplicitLeft = 117
      ExplicitTop = 214
    end
    inherited DateTimePickerSendTime: TDateTimePicker
      Left = 211
      Top = 214
      TabOrder = 13
      ExplicitLeft = 211
      ExplicitTop = 214
    end
    inherited ButtonSender: TButton
      Left = 241
      Top = 38
      ExplicitLeft = 241
      ExplicitTop = 38
    end
    inherited DateTimePickerIn: TDateTimePicker
      Left = 117
      Top = 187
      ExplicitLeft = 117
      ExplicitTop = 187
    end
    inherited DateTimePickerInTime: TDateTimePicker
      Left = 211
      Top = 187
      ExplicitLeft = 211
      ExplicitTop = 187
    end
    inherited ComboBoxType: TComboBox
      Left = 78
      Top = 11
      ExplicitLeft = 78
      ExplicitTop = 11
    end
    inherited EditContact: TEdit
      Left = 323
      Width = 149
      ExplicitLeft = 323
      ExplicitWidth = 149
    end
    inherited MemoText: TMemo
      Left = 78
      Width = 433
      ExplicitLeft = 78
      ExplicitWidth = 433
    end
    inherited EditCodeMessage: TEdit
      Left = 78
      Color = clWindow
      ReadOnly = False
      ExplicitLeft = 78
    end
    inherited ButtonCodeMessage: TButton
      Left = 241
      ExplicitLeft = 241
    end
    object DateTimePickerInTo: TDateTimePicker
      Left = 316
      Top = 187
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 9
    end
    object DateTimePickerInToTime: TDateTimePicker
      Left = 410
      Top = 187
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 10
    end
    object DateTimePickerSendTo: TDateTimePicker
      Left = 316
      Top = 214
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 14
    end
    object DateTimePickerSendToTime: TDateTimePicker
      Left = 410
      Top = 214
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 15
    end
    object ButtonSendTo: TButton
      Left = 490
      Top = 214
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 16
      OnClick = ButtonSendToClick
    end
    object ButtonDateIn: TButton
      Left = 490
      Top = 187
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 11
      OnClick = ButtonDateInClick
    end
  end
end
