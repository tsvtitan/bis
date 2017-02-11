inherited BisDesignDataAlarmEditForm: TBisDesignDataAlarmEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataAlarmEditForm'
  ClientHeight = 345
  ClientWidth = 376
  ExplicitWidth = 384
  ExplicitHeight = 379
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 307
    Width = 376
    ExplicitTop = 307
    ExplicitWidth = 376
    DesignSize = (
      376
      38)
    inherited ButtonOk: TButton
      Left = 197
      ExplicitLeft = 197
    end
    inherited ButtonCancel: TButton
      Left = 293
      ExplicitLeft = 293
    end
  end
  inherited PanelControls: TPanel
    Width = 376
    Height = 307
    ExplicitWidth = 376
    ExplicitHeight = 307
    DesignSize = (
      376
      307)
    object LabelRecipient: TLabel
      Left = 29
      Top = 42
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1083#1091#1095#1072#1090#1077#1083#1100':'
      FocusControl = EditRecipient
    end
    object LabelDateBegin: TLabel
      Left = 120
      Top = 253
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelType: TLabel
      Left = 13
      Top = 15
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1089#1086#1086#1073#1097#1077#1085#1080#1103':'
      FocusControl = ComboBoxType
      Transparent = True
    end
    object LabelCaption: TLabel
      Left = 37
      Top = 69
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082':'
      FocusControl = EditCaption
    end
    object LabelText: TLabel
      Left = 61
      Top = 96
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object LabelDateEnd: TLabel
      Left = 102
      Top = 280
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelSender: TLabel
      Left = 117
      Top = 226
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1077#1083#1100':'
      FocusControl = EditSender
    end
    object EditRecipient: TEdit
      Left = 100
      Top = 39
      Width = 157
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object ButtonRecipient: TButton
      Left = 263
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 2
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 195
      Top = 250
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 6
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 289
      Top = 250
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 7
    end
    object ComboBoxType: TComboBox
      Left = 100
      Top = 12
      Width = 157
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditCaption: TEdit
      Left = 100
      Top = 66
      Width = 263
      Height = 21
      MaxLength = 100
      TabOrder = 3
    end
    object MemoText: TMemo
      Left = 100
      Top = 93
      Width = 263
      Height = 124
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 195
      Top = 277
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 8
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 289
      Top = 277
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
    end
    object EditSender: TEdit
      Left = 195
      Top = 223
      Width = 168
      Height = 21
      Anchors = [akRight, akBottom]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 5
    end
  end
  inherited ImageList: TImageList
    Left = 24
    Top = 280
  end
end
