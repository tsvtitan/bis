inherited BisTaxiDriverParkDeleteForm: TBisTaxiDriverParkDeleteForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDriverParkDeleteForm'
  ClientHeight = 185
  ClientWidth = 392
  ExplicitWidth = 400
  ExplicitHeight = 219
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 147
    Width = 392
    ExplicitTop = 147
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
    Height = 147
    ExplicitWidth = 392
    ExplicitHeight = 147
    object LabelDriver: TLabel
      Left = 22
      Top = 13
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditDriver
    end
    object LabelDateIn: TLabel
      Left = 111
      Top = 94
      Width = 96
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1042#1088#1077#1084#1103' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080':'
      FocusControl = DateTimePickerIn
      ExplicitLeft = 47
    end
    object LabelCar: TLabel
      Left = 10
      Top = 40
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100':'
      FocusControl = EditCar
    end
    object LabelPark: TLabel
      Left = 92
      Top = 67
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1057#1090#1086#1103#1085#1082#1072':'
      FocusControl = EditPark
      ExplicitLeft = 28
    end
    object LabelDateOut: TLabel
      Left = 135
      Top = 121
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1042#1088#1077#1084#1103' '#1089#1085#1103#1090#1080#1103':'
      FocusControl = DateTimePickerOut
      ExplicitLeft = 71
    end
    object EditDriver: TEdit
      Left = 81
      Top = 10
      Width = 272
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object DateTimePickerIn: TDateTimePicker
      Left = 293
      Top = 91
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 4
    end
    object DateTimePickerInTime: TDateTimePicker
      Left = 213
      Top = 91
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 3
    end
    object EditCar: TEdit
      Left = 81
      Top = 37
      Width = 300
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
    end
    object EditPark: TEdit
      Left = 145
      Top = 64
      Width = 236
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object DateTimePickerOut: TDateTimePicker
      Left = 293
      Top = 118
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 6
    end
    object DateTimePickerOutTime: TDateTimePicker
      Left = 213
      Top = 118
      Width = 74
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 5
    end
  end
  inherited ImageList: TImageList
    Left = 48
    Top = 32
  end
end
