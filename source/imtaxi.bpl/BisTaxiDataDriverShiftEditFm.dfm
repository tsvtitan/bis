inherited BisTaxiDataDriverShiftEditForm: TBisTaxiDataDriverShiftEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataDriverShiftEditForm'
  ClientHeight = 136
  ClientWidth = 322
  ExplicitWidth = 330
  ExplicitHeight = 170
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 98
    Width = 322
    ExplicitTop = 98
    ExplicitWidth = 322
    inherited ButtonOk: TButton
      Left = 143
      ExplicitLeft = 143
    end
    inherited ButtonCancel: TButton
      Left = 239
      ExplicitLeft = 239
    end
  end
  inherited PanelControls: TPanel
    Width = 322
    Height = 98
    ExplicitWidth = 322
    ExplicitHeight = 98
    object LabelDriver: TLabel
      Left = 52
      Top = 18
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditDriver
    end
    object LabelDateBegin: TLabel
      Left = 36
      Top = 45
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 18
      Top = 72
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object EditDriver: TEdit
      Left = 111
      Top = 15
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 111
      Top = 42
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 2
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 205
      Top = 42
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 3
    end
    object ButtonDriver: TButton
      Left = 285
      Top = 15
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1103
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 111
      Top = 69
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 4
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 205
      Top = 69
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 5
    end
  end
end