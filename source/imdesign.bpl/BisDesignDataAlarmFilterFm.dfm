inherited BisDesignDataAlarmFilterForm: TBisDesignDataAlarmFilterForm
  Caption = 'BisDesignDataAlarmFilterForm'
  ClientWidth = 509
  ExplicitWidth = 517
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Width = 509
    ExplicitWidth = 509
    inherited ButtonOk: TButton
      Left = 330
      ExplicitLeft = 330
    end
    inherited ButtonCancel: TButton
      Left = 426
      ExplicitLeft = 426
    end
  end
  inherited PanelControls: TPanel
    Width = 509
    ExplicitWidth = 509
    ExplicitHeight = 307
    inherited LabelRecipient: TLabel
      Left = 35
      ExplicitLeft = 35
    end
    inherited LabelDateBegin: TLabel
      Left = 30
      ExplicitLeft = 30
      ExplicitTop = 173
    end
    inherited LabelType: TLabel
      Left = 15
      ExplicitLeft = 15
    end
    inherited LabelCaption: TLabel
      Left = 40
      ExplicitLeft = 40
    end
    inherited LabelText: TLabel
      Left = 64
      ExplicitLeft = 64
    end
    inherited LabelDateEnd: TLabel
      Left = 12
      ExplicitLeft = 12
      ExplicitTop = 200
    end
    object LabelDateBeginTo: TLabel [6]
      Left = 282
      Top = 253
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerBeginTo
    end
    object LabelDateEndTo: TLabel [7]
      Left = 282
      Top = 280
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1087#1086':'
      FocusControl = DateTimePickerEndTo
    end
    inherited LabelSender: TLabel
      Left = 28
      ExplicitLeft = 28
    end
    inherited EditRecipient: TEdit
      Left = 103
      Color = clWindow
      ReadOnly = False
      ExplicitLeft = 103
    end
    inherited ButtonRecipient: TButton
      Left = 266
      ExplicitLeft = 266
    end
    inherited DateTimePickerBegin: TDateTimePicker
      Left = 103
      ExplicitLeft = 103
    end
    inherited DateTimePickerBeginTime: TDateTimePicker
      Left = 197
      ExplicitLeft = 197
    end
    inherited ComboBoxType: TComboBox
      Left = 103
      ExplicitLeft = 103
    end
    inherited EditCaption: TEdit
      Left = 103
      ExplicitLeft = 103
    end
    inherited MemoText: TMemo
      Left = 103
      Width = 396
      ExplicitLeft = 103
      ExplicitWidth = 396
    end
    inherited DateTimePickerEnd: TDateTimePicker
      Left = 103
      TabOrder = 11
      ExplicitLeft = 103
    end
    inherited DateTimePickerEndTime: TDateTimePicker
      Left = 197
      TabOrder = 12
      ExplicitLeft = 197
    end
    inherited EditSender: TEdit
      Left = 103
      Width = 396
      Color = clWindow
      ReadOnly = False
      ExplicitLeft = 103
      ExplicitWidth = 396
    end
    object DateTimePickerBeginTo: TDateTimePicker
      Left = 304
      Top = 250
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 8
    end
    object DateTimePickerBeginToTime: TDateTimePicker
      Left = 398
      Top = 250
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
    end
    object ButtonDateBegin: TButton
      Left = 478
      Top = 250
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 10
      OnClick = ButtonDateBeginClick
    end
    object DateTimePickerEndTo: TDateTimePicker
      Left = 304
      Top = 277
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 13
    end
    object DateTimePickerEndToTime: TDateTimePicker
      Left = 398
      Top = 277
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 14
    end
    object ButtonDateEnd: TButton
      Left = 478
      Top = 277
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Anchors = [akRight, akBottom]
      Caption = '...'
      TabOrder = 15
      OnClick = ButtonDateEndClick
    end
  end
end
