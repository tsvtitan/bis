inherited BisTaxiDataDriverInMessageFilterForm: TBisTaxiDataDriverInMessageFilterForm
  Caption = 'BisTaxiDataDriverInMessageFilterForm'
  ClientHeight = 327
  ClientWidth = 524
  ExplicitWidth = 532
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 289
    Width = 524
    ExplicitTop = 289
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
    Height = 289
    ExplicitWidth = 524
    ExplicitHeight = 289
    inherited LabelSender: TLabel
      Left = 18
      Top = 39
      ExplicitLeft = 18
      ExplicitTop = 39
    end
    inherited LabelDateSend: TLabel
      Left = 30
      Top = 261
      ExplicitLeft = 30
      ExplicitTop = 261
    end
    inherited LabelDateIn: TLabel
      Left = 24
      Top = 234
      ExplicitLeft = 24
      ExplicitTop = 234
    end
    inherited LabelType: TLabel
      Left = 68
      Top = 12
      ExplicitLeft = 68
      ExplicitTop = 12
    end
    inherited LabelContact: TLabel
      Left = 292
      Top = 66
      ExplicitLeft = 292
      ExplicitTop = 66
    end
    inherited LabelText: TLabel
      Left = 57
      Top = 90
      ExplicitLeft = 57
      ExplicitTop = 90
    end
    object LabelDateInTo: TLabel [6]
      Left = 294
      Top = 234
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerInTo
    end
    object LabelDateSendTo: TLabel [7]
      Left = 294
      Top = 261
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerSendTo
    end
    inherited LabelCodeMessage: TLabel
      Left = 66
      Top = 66
      ExplicitLeft = 66
      ExplicitTop = 66
    end
    inherited LabelDescription: TLabel
      Left = 37
      Top = 155
      ExplicitLeft = 37
      ExplicitTop = 155
    end
    inherited LabelFirm: TLabel
      Left = 41
      Top = 207
      ExplicitLeft = 41
      ExplicitTop = 207
    end
    inherited EditSender: TEdit
      Left = 96
      Top = 36
      ExplicitLeft = 96
      ExplicitTop = 36
    end
    inherited DateTimePickerSend: TDateTimePicker
      Left = 117
      Top = 258
      TabOrder = 14
      ExplicitLeft = 117
      ExplicitTop = 258
    end
    inherited DateTimePickerSendTime: TDateTimePicker
      Left = 211
      Top = 258
      TabOrder = 15
      ExplicitLeft = 211
      ExplicitTop = 258
    end
    inherited ButtonSender: TButton
      Left = 346
      Top = 37
      ExplicitLeft = 346
      ExplicitTop = 37
    end
    inherited DateTimePickerIn: TDateTimePicker
      Left = 117
      Top = 231
      ExplicitLeft = 117
      ExplicitTop = 231
    end
    inherited DateTimePickerInTime: TDateTimePicker
      Left = 211
      Top = 231
      ExplicitLeft = 211
      ExplicitTop = 231
    end
    inherited ComboBoxType: TComboBox
      Left = 96
      Top = 9
      ExplicitLeft = 96
      ExplicitTop = 9
    end
    inherited EditContact: TEdit
      Left = 345
      Top = 63
      Width = 149
      ExplicitLeft = 345
      ExplicitTop = 63
      ExplicitWidth = 149
    end
    inherited MemoText: TMemo
      Left = 96
      Top = 90
      Width = 415
      Height = 59
      ExplicitLeft = 96
      ExplicitTop = 90
      ExplicitWidth = 415
      ExplicitHeight = 59
    end
    inherited EditCodeMessage: TEdit
      Left = 96
      Top = 63
      Color = clWindow
      ReadOnly = False
      ExplicitLeft = 96
      ExplicitTop = 63
    end
    inherited ButtonCodeMessage: TButton
      Left = 259
      Top = 63
      ExplicitLeft = 259
      ExplicitTop = 63
    end
    inherited MemoDescription: TMemo
      Left = 96
      Top = 155
      Width = 415
      ExplicitLeft = 96
      ExplicitTop = 155
      ExplicitWidth = 415
    end
    inherited ComboBoxFirm: TComboBox
      Left = 117
      Top = 204
      Width = 394
      Anchors = [akRight, akBottom]
      ExplicitLeft = 117
      ExplicitTop = 204
      ExplicitWidth = 394
    end
    object DateTimePickerInTo: TDateTimePicker
      Left = 316
      Top = 231
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 11
    end
    object DateTimePickerInToTime: TDateTimePicker
      Left = 410
      Top = 231
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 12
    end
    object DateTimePickerSendTo: TDateTimePicker
      Left = 316
      Top = 258
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 16
    end
    object DateTimePickerSendToTime: TDateTimePicker
      Left = 410
      Top = 258
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 18
    end
    object ButtonSendTo: TButton
      Left = 490
      Top = 258
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 17
      OnClick = ButtonSendToClick
    end
    object ButtonDateIn: TButton
      Left = 490
      Top = 231
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
