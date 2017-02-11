inherited BisTaxiOrderFilterForm: TBisTaxiOrderFilterForm
  Caption = 'BisTaxiOrderFilterForm'
  ClientHeight = 281
  ClientWidth = 612
  ExplicitWidth = 620
  ExplicitHeight = 315
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 243
    Width = 612
    ExplicitTop = 243
    ExplicitWidth = 612
    inherited ButtonOk: TButton
      Left = 433
      ExplicitLeft = 433
    end
    inherited ButtonCancel: TButton
      Left = 529
      ExplicitLeft = 529
    end
  end
  inherited PanelControls: TPanel
    Width = 612
    Height = 243
    ExplicitWidth = 612
    ExplicitHeight = 243
    object LabelPhone: TLabel
      Left = 17
      Top = 13
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
      FocusControl = EditPhone
    end
    object LabelOrderNum: TLabel
      Left = 184
      Top = 13
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditOrderNum
    end
    object LabelFirm: TLabel
      Left = 336
      Top = 13
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
    end
    object GroupBoxDateAccept: TGroupBox
      Left = 7
      Top = 37
      Width = 442
      Height = 60
      Caption = ' '#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1087#1088#1080#1085#1103#1090#1080#1103' '
      TabOrder = 3
      object PanelDateAccept: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 15
        Width = 432
        Height = 40
        Margins.Top = 0
        Align = alClient
        BevelOuter = bvNone
        Color = 11184895
        ParentBackground = False
        TabOrder = 0
        object LabelDateAcceptTo: TLabel
          Left = 204
          Top = 14
          Width = 16
          Height = 13
          Alignment = taRightJustify
          Caption = #1087#1086':'
          FocusControl = DateTimePickerAcceptTo
        end
        object LabelDateAcceptFrom: TLabel
          Left = 12
          Top = 14
          Width = 9
          Height = 13
          Alignment = taRightJustify
          Caption = #1089':'
          FocusControl = DateTimePickerAcceptFrom
        end
        object DateTimePickerTimeAcceptTo: TDateTimePicker
          Left = 320
          Top = 11
          Width = 74
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 3
        end
        object ButtonAccept: TButton
          Left = 400
          Top = 11
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
          Caption = '...'
          TabOrder = 4
          OnClick = ButtonAcceptClick
        end
        object DateTimePickerAcceptTo: TDateTimePicker
          Left = 226
          Top = 11
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 2
        end
        object DateTimePickerTimeAcceptFrom: TDateTimePicker
          Left = 121
          Top = 11
          Width = 74
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 1
        end
        object DateTimePickerAcceptFrom: TDateTimePicker
          Left = 27
          Top = 11
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 0
        end
      end
    end
    object EditPhone: TEdit
      Left = 71
      Top = 10
      Width = 100
      Height = 21
      TabOrder = 0
    end
    object GroupBoxDateArrival: TGroupBox
      Left = 163
      Top = 176
      Width = 442
      Height = 63
      Anchors = [akTop, akRight]
      Caption = ' '#1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1087#1086#1076#1072#1095#1080' '
      TabOrder = 5
      object PanelDateArrival: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 15
        Width = 432
        Height = 43
        Margins.Top = 0
        Align = alClient
        BevelOuter = bvNone
        Color = 11206570
        ParentBackground = False
        TabOrder = 0
        object LabelDateArrivalTo: TLabel
          Left = 204
          Top = 16
          Width = 16
          Height = 13
          Alignment = taRightJustify
          Caption = #1087#1086':'
          FocusControl = DateTimePickerArrivalTo
        end
        object LabelDateArrivalFrom: TLabel
          Left = 12
          Top = 16
          Width = 9
          Height = 13
          Alignment = taRightJustify
          Caption = #1089':'
          FocusControl = DateTimePickerArrivalFrom
        end
        object DateTimePickerTimeArrivalTo: TDateTimePicker
          Left = 320
          Top = 13
          Width = 74
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 3
        end
        object ButtonArrival: TButton
          Left = 400
          Top = 13
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
          Caption = '...'
          TabOrder = 4
          OnClick = ButtonArrivalClick
        end
        object DateTimePickerArrivalTo: TDateTimePicker
          Left = 226
          Top = 13
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 2
        end
        object DateTimePickerTimeArrivalFrom: TDateTimePicker
          Left = 121
          Top = 13
          Width = 74
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 1
        end
        object DateTimePickerArrivalFrom: TDateTimePicker
          Left = 27
          Top = 13
          Width = 88
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 0
        end
      end
    end
    object GroupBoxAddressArrival: TGroupBox
      Left = 7
      Top = 98
      Width = 598
      Height = 77
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1040#1076#1088#1077#1089' '#1087#1086#1076#1072#1095#1080' '
      TabOrder = 4
      object PanelAddressArrival: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 15
        Width = 588
        Height = 57
        Margins.Top = 0
        Align = alClient
        BevelOuter = bvNone
        Color = 16766378
        ParentBackground = False
        TabOrder = 0
      end
    end
    object EditOrderNum: TEdit
      Left = 225
      Top = 10
      Width = 101
      Height = 21
      TabOrder = 1
    end
    object ComboBoxFirm: TComboBox
      Left = 412
      Top = 10
      Width = 192
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
  end
  inherited ImageList: TImageList
    Left = 80
    Top = 192
  end
end