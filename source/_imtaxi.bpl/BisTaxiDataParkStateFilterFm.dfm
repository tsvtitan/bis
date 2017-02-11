inherited BisTaxiDataParkStateFilterForm: TBisTaxiDataParkStateFilterForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataParkStateFilterForm'
  ClientHeight = 295
  ClientWidth = 285
  ExplicitWidth = 293
  ExplicitHeight = 329
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 257
    Width = 285
    ExplicitTop = 232
    ExplicitWidth = 284
    inherited ButtonOk: TButton
      Left = 106
      ExplicitLeft = 105
    end
    inherited ButtonCancel: TButton
      Left = 202
      ExplicitLeft = 201
    end
  end
  inherited PanelControls: TPanel
    Width = 285
    Height = 257
    ExplicitWidth = 284
    ExplicitHeight = 232
    object LabelDriver: TLabel
      Left = 14
      Top = 42
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100':'
      FocusControl = EditDriver
    end
    object LabelPark: TLabel
      Left = 20
      Top = 15
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1086#1103#1085#1082#1072':'
      FocusControl = EditPark
    end
    object GroupBoxDateIn: TGroupBox
      Left = 20
      Top = 66
      Width = 252
      Height = 87
      Anchors = [akTop, akRight]
      Caption = ' '#1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1085#1086#1074#1082#1080' '
      TabOrder = 4
      object LabelDateInFrom: TLabel
        Left = 42
        Top = 27
        Width = 9
        Height = 13
        Alignment = taRightJustify
        Caption = 'c:'
        FocusControl = DateTimePickerInFrom
      end
      object LabelDateInTo: TLabel
        Left = 35
        Top = 54
        Width = 16
        Height = 13
        Alignment = taRightJustify
        Caption = #1087#1086':'
        FocusControl = DateTimePickerInTo
      end
      object DateTimePickerInFrom: TDateTimePicker
        Left = 57
        Top = 24
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 0
      end
      object DateTimePickerInFromTime: TDateTimePicker
        Left = 151
        Top = 24
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 1
      end
      object DateTimePickerInToTime: TDateTimePicker
        Left = 151
        Top = 51
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 3
      end
      object DateTimePickerInTo: TDateTimePicker
        Left = 57
        Top = 51
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 2
      end
    end
    object EditDriver: TEdit
      Left = 73
      Top = 39
      Width = 174
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 2
    end
    object ButtonDriver: TButton
      Left = 253
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1086#1076#1080#1090#1077#1083#1103
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
    object GroupBoxDateOut: TGroupBox
      Left = 20
      Top = 159
      Width = 252
      Height = 87
      Anchors = [akTop, akRight]
      Caption = ' '#1044#1072#1090#1072' '#1089#1085#1103#1090#1080#1103' '
      TabOrder = 5
      object LabelDateOutFrom: TLabel
        Left = 42
        Top = 27
        Width = 9
        Height = 13
        Alignment = taRightJustify
        Caption = 'c:'
        FocusControl = DateTimePickerOutFrom
      end
      object LabelDateOutTo: TLabel
        Left = 35
        Top = 54
        Width = 16
        Height = 13
        Alignment = taRightJustify
        Caption = #1087#1086':'
        FocusControl = DateTimePickerOutTo
      end
      object DateTimePickerOutFrom: TDateTimePicker
        Left = 57
        Top = 24
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 0
      end
      object DateTimePickerOutFromTime: TDateTimePicker
        Left = 151
        Top = 24
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 1
      end
      object DateTimePickerOutToTime: TDateTimePicker
        Left = 151
        Top = 51
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 3
      end
      object DateTimePickerOutTo: TDateTimePicker
        Left = 57
        Top = 51
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 2
      end
    end
    object EditPark: TEdit
      Left = 73
      Top = 12
      Width = 174
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 100
      TabOrder = 0
    end
    object ButtonPark: TButton
      Left = 253
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1089#1090#1086#1103#1085#1082#1091
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
  end
end