inherited BisKrieltDataAnswerEditForm: TBisKrieltDataAnswerEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataAnswerEditForm'
  ClientHeight = 259
  ClientWidth = 431
  ExplicitWidth = 439
  ExplicitHeight = 293
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 221
    Width = 431
    ExplicitTop = 221
    ExplicitWidth = 431
    inherited ButtonOk: TButton
      Left = 252
      ExplicitLeft = 252
    end
    inherited ButtonCancel: TButton
      Left = 349
      ExplicitLeft = 349
    end
  end
  inherited PanelControls: TPanel
    Width = 431
    Height = 221
    ExplicitWidth = 431
    ExplicitHeight = 221
    object LabelConsultant: TLabel
      Left = 23
      Top = 66
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1086#1085#1089#1091#1083#1100#1090#1072#1085#1090':'
      FocusControl = ComboBoxConsultant
    end
    object LabelQuestion: TLabel
      Left = 54
      Top = 12
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1087#1088#1086#1089':'
    end
    object LabelDateCreate: TLabel
      Left = 13
      Top = 39
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
      FocusControl = DateTimePickerCreate
    end
    object LabelText: TLabel
      Left = 60
      Top = 93
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object EditQuestion: TEdit
      Left = 99
      Top = 9
      Width = 208
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonQuestion: TButton
      Left = 313
      Top = 9
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1087#1088#1086#1089
      Caption = '...'
      TabOrder = 1
    end
    object ComboBoxConsultant: TComboBox
      Left = 99
      Top = 63
      Width = 235
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 4
    end
    object DateTimePickerCreate: TDateTimePicker
      Left = 99
      Top = 36
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 2
    end
    object DateTimePickerCreateTime: TDateTimePicker
      Left = 193
      Top = 36
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 3
    end
    object MemoText: TMemo
      Left = 99
      Top = 90
      Width = 318
      Height = 125
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 5
    end
  end
  inherited ImageList: TImageList
    Left = 360
    Top = 16
  end
end
