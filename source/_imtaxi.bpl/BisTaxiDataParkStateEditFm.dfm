inherited BisTaxiDataParkStateEditForm: TBisTaxiDataParkStateEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataParkStateEditForm'
  ClientHeight = 161
  ClientWidth = 322
  ExplicitWidth = 330
  ExplicitHeight = 195
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 123
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
    Height = 123
    ExplicitTop = -1
    ExplicitWidth = 322
    ExplicitHeight = 137
    object LabelDriver: TLabel
      Left = 52
      Top = 42
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditDriver
    end
    object LabelDateIn: TLabel
      Left = 13
      Top = 69
      Width = 92
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080':'
      FocusControl = DateTimePickerIn
    end
    object LabelDateOut: TLabel
      Left = 37
      Top = 96
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1089#1085#1103#1090#1080#1103':'
      FocusControl = DateTimePickerOut
    end
    object LabelPark: TLabel
      Left = 58
      Top = 15
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1086#1103#1085#1082#1072':'
      FocusControl = EditPark
    end
    object EditDriver: TEdit
      Left = 111
      Top = 39
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object DateTimePickerIn: TDateTimePicker
      Left = 111
      Top = 66
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 4
    end
    object DateTimePickerInTime: TDateTimePicker
      Left = 205
      Top = 66
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 5
    end
    object ButtonDriver: TButton
      Left = 285
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1103
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 111
      Top = 93
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 6
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 205
      Top = 93
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 7
    end
    object EditPark: TEdit
      Left = 111
      Top = 12
      Width = 168
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonPark: TButton
      Left = 285
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1089#1090#1086#1103#1085#1082#1091
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
  end
  inherited ImageList: TImageList
    Left = 224
    Top = 8
  end
end
