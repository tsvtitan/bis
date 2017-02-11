inherited BisMessDataInMessageEditForm: TBisMessDataInMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisMessDataInMessageEditForm'
  ClientHeight = 285
  ClientWidth = 502
  ExplicitWidth = 510
  ExplicitHeight = 319
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 247
    Width = 502
    ExplicitTop = 247
    ExplicitWidth = 510
    DesignSize = (
      502
      38)
    inherited ButtonOk: TButton
      Left = 323
      ExplicitLeft = 331
    end
    inherited ButtonCancel: TButton
      Left = 419
      ExplicitLeft = 427
    end
  end
  inherited PanelControls: TPanel
    Width = 502
    Height = 247
    ExplicitWidth = 510
    ExplicitHeight = 247
    DesignSize = (
      502
      247)
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
      Top = 216
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080':'
      FocusControl = DateTimePickerSend
    end
    object LabelDateIn: TLabel
      Left = 228
      Top = 189
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
      Top = 96
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
    object EditSender: TEdit
      Left = 92
      Top = 39
      Width = 157
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object DateTimePickerSend: TDateTimePicker
      Left = 321
      Top = 213
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 9
    end
    object DateTimePickerSendTime: TDateTimePicker
      Left = 415
      Top = 213
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 10
    end
    object ButtonSender: TButton
      Left = 255
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
      Caption = '...'
      TabOrder = 2
    end
    object DateTimePickerIn: TDateTimePicker
      Left = 321
      Top = 186
      Width = 88
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 7
    end
    object DateTimePickerInTime: TDateTimePicker
      Left = 415
      Top = 186
      Width = 74
      Height = 21
      Anchors = [akRight, akBottom]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 8
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
      Height = 87
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
  end
  inherited ImageList: TImageList
    Left = 128
    Top = 104
  end
end
