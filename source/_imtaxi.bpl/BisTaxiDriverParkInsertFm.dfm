inherited BisTaxiDriverParkInsertForm: TBisTaxiDriverParkInsertForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDriverParkInsertForm'
  ClientHeight = 162
  ClientWidth = 392
  ExplicitWidth = 400
  ExplicitHeight = 196
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 124
    Width = 392
    ExplicitTop = 124
    ExplicitWidth = 392
    inherited ButtonOk: TButton
      Left = 213
      ExplicitLeft = 213
    end
    inherited ButtonCancel: TButton
      Left = 309
      ExplicitLeft = 309
    end
  end
  inherited PanelControls: TPanel
    Width = 392
    Height = 124
    ExplicitWidth = 392
    ExplicitHeight = 124
    object LabelDriver: TLabel
      Left = 27
      Top = 15
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditDriver
    end
    object LabelDateIn: TLabel
      Left = 110
      Top = 96
      Width = 96
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1042#1088#1077#1084#1103' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080':'
      FocusControl = DateTimePickerIn
      ExplicitLeft = 54
    end
    object LabelCar: TLabel
      Left = 15
      Top = 42
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100':'
      FocusControl = EditCar
    end
    object LabelPark: TLabel
      Left = 89
      Top = 69
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1090#1086#1103#1085#1082#1072':'
      FocusControl = ComboBoxPark
      ExplicitLeft = 33
    end
    object EditDriver: TEdit
      Left = 86
      Top = 12
      Width = 245
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object DateTimePickerIn: TDateTimePicker
      Left = 292
      Top = 93
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 5
    end
    object DateTimePickerInTime: TDateTimePicker
      Left = 212
      Top = 93
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 4
    end
    object ButtonDriver: TButton
      Left = 337
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1103
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object EditCar: TEdit
      Left = 86
      Top = 39
      Width = 294
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ComboBoxPark: TComboBox
      Left = 142
      Top = 66
      Width = 238
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 3
    end
  end
end
