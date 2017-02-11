inherited BisKrieltReportsForm: TBisKrieltReportsForm
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1081' '#1074' MS Excel'
  ClientHeight = 350
  ClientWidth = 428
  Position = poDefault
  OnClose = FormClose
  ExplicitWidth = 436
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 13
  object ReportParamsGroupBox: TGroupBox
    Left = 8
    Top = 2
    Width = 412
    Height = 128
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1103
    TabOrder = 0
    object ActionLabel: TLabel
      Left = 64
      Top = 47
      Width = 50
      Height = 13
      Caption = #1044#1077#1081#1089#1090#1074#1080#1077
    end
    object RealtyTypeLabel: TLabel
      Left = 17
      Top = 74
      Width = 97
      Height = 13
      Caption = #1058#1080#1087' '#1085#1077#1076#1074#1080#1078#1080#1084#1086#1089#1090#1080
    end
    object ReportLabel: TLabel
      Left = 51
      Top = 101
      Width = 63
      Height = 13
      Caption = #1054#1073#1098#1103#1074#1083#1077#1085#1080#1077
    end
    object LabelPublishing: TLabel
      Left = 67
      Top = 20
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1079#1076#1072#1085#1080#1077':'
      FocusControl = EditPublishing
    end
    object ActionComboBox: TComboBox
      Left = 120
      Top = 44
      Width = 273
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = ActionComboBoxChange
      Items.Strings = (
        #1055#1088#1086#1076#1072#1084
        #1050#1091#1087#1083#1102
        #1057#1076#1072#1084' '#1074' '#1072#1088#1077#1085#1076#1091
        #1057#1085#1080#1084#1091' '#1074' '#1072#1088#1077#1085#1076#1091
        #1054#1073#1084#1077#1085#1103#1102)
    end
    object RealtyTypeComboBox: TComboBox
      Left = 120
      Top = 71
      Width = 273
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = RealtyTypeComboBoxChange
    end
    object ReportComboBox: TComboBox
      Left = 120
      Top = 98
      Width = 273
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnChange = ReportComboBoxChange
    end
    object EditPublishing: TEdit
      Left = 120
      Top = 17
      Width = 153
      Height = 21
      Color = 15000804
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonPublishing: TButton
      Left = 279
      Top = 17
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
      Caption = '...'
      TabOrder = 1
      OnClick = ButtonPublishingClick
    end
  end
  object PeriodGroupBox: TGroupBox
    Left = 8
    Top = 264
    Width = 412
    Height = 50
    Caption = #1055#1077#1088#1080#1086#1076
    TabOrder = 1
    object PeriodBeginLabel: TLabel
      Left = 36
      Top = 25
      Width = 6
      Height = 13
      Caption = #1089
    end
    object PeriodEndLabel: TLabel
      Left = 190
      Top = 25
      Width = 12
      Height = 13
      Caption = #1087#1086
    end
    object BeginDateTimePicker: TDateTimePicker
      Left = 48
      Top = 21
      Width = 129
      Height = 21
      Date = 39548.630751226850000000
      Time = 39548.630751226850000000
      TabOrder = 0
    end
    object EndDateTimePicker: TDateTimePicker
      Left = 208
      Top = 21
      Width = 128
      Height = 21
      Date = 39548.630842546300000000
      Time = 39548.630842546300000000
      TabOrder = 1
    end
    object ButtonPeriod: TButton
      Left = 342
      Top = 21
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1099#1087#1091#1089#1082
      Caption = '...'
      TabOrder = 2
      OnClick = ButtonPeriodClick
    end
  end
  object ExportProgressGroupBox: TGroupBox
    Left = 8
    Top = 351
    Width = 412
    Height = 79
    Caption = #1055#1088#1086#1094#1077#1089#1089' '#1101#1082#1089#1087#1086#1088#1090#1072
    TabOrder = 2
    object AllRecordsLabel: TLabel
      Left = 17
      Top = 36
      Width = 78
      Height = 13
      Caption = #1042#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081':'
    end
    object ExportRecordsLabel: TLabel
      Left = 17
      Top = 21
      Width = 87
      Height = 13
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1085#1086':'
    end
    object ExportProgressBar: TProgressBar
      Left = 17
      Top = 56
      Width = 376
      Height = 12
      TabOrder = 0
    end
  end
  object StartExportButton: TButton
    Left = 96
    Top = 320
    Width = 114
    Height = 25
    Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
    Enabled = False
    TabOrder = 3
    OnClick = StartExportButtonClick
  end
  object CloseExportButtonButton: TButton
    Left = 216
    Top = 320
    Width = 114
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 4
    OnClick = CloseExportButtonButtonClick
  end
  object ListGroupBox: TGroupBox
    Left = 8
    Top = 135
    Width = 412
    Height = 114
    Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1086#1073#1098#1103#1074#1083#1077#1085#1080#1081
    TabOrder = 5
    object AddButton: TButton
      Left = 326
      Top = 16
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = AddButtonClick
    end
    object DeleteButton: TButton
      Left = 326
      Top = 47
      Width = 75
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 1
      OnClick = DeleteButtonClick
    end
    object ClearButton: TButton
      Left = 326
      Top = 78
      Width = 75
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 2
      OnClick = ClearButtonClick
    end
    object AllListBox: TListBox
      Left = 9
      Top = 17
      Width = 311
      Height = 88
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object ExportTimer: TTimer
    Interval = 1
    OnTimer = ExportTimerTimer
    Left = 392
    Top = 320
  end
end
