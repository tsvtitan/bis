inherited BisDesignDataTaskEditForm: TBisDesignDataTaskEditForm
  Left = 659
  Top = 255
  Caption = 'BisDesignDataTaskEditForm'
  ClientHeight = 485
  ClientWidth = 592
  ExplicitWidth = 600
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 447
    Width = 592
    ExplicitTop = 447
    ExplicitWidth = 592
    inherited ButtonOk: TButton
      Left = 413
      ExplicitLeft = 413
    end
    inherited ButtonCancel: TButton
      Left = 509
      ExplicitLeft = 509
    end
  end
  inherited PanelControls: TPanel
    Width = 592
    Height = 447
    ExplicitWidth = 592
    ExplicitHeight = 447
    object GroupBoxRepeat: TGroupBox
      Left = 8
      Top = 362
      Width = 191
      Height = 80
      Caption = '                                             '
      TabOrder = 3
      object LabelRepeatValue: TLabel
        Left = 10
        Top = 24
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1072#1078#1076'.:'
        FocusControl = EditRepeatValue
      end
      object LabelRepeatCount: TLabel
        Left = 10
        Top = 51
        Width = 127
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1074#1090#1086#1088#1077#1085#1080#1081':'
        FocusControl = EditRepeatCount
      end
      object CheckBoxRepeat: TCheckBox
        Left = 16
        Top = -1
        Width = 121
        Height = 17
        Caption = #1055#1086#1074#1090#1086#1088#1103#1090#1100' '#1079#1072#1076#1072#1085#1080#1077' '
        TabOrder = 0
      end
      object EditRepeatValue: TEdit
        Left = 52
        Top = 21
        Width = 37
        Height = 21
        TabOrder = 1
      end
      object ComboBoxRepeatType: TComboBox
        Left = 95
        Top = 21
        Width = 85
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          #1089#1077#1082#1091#1085#1076#1091
          #1084#1080#1085#1091#1090#1091
          #1095#1072#1089
          #1076#1077#1085#1100
          #1085#1077#1076#1077#1083#1102
          #1084#1077#1089#1103#1094)
      end
      object EditRepeatCount: TEdit
        Left = 143
        Top = 48
        Width = 37
        Height = 21
        TabOrder = 3
      end
    end
    object GroupBoxExecute: TGroupBox
      Left = 8
      Top = 114
      Width = 574
      Height = 81
      Anchors = [akLeft, akTop, akRight]
      Caption = '                             '
      TabOrder = 1
      DesignSize = (
        574
        81)
      object LabelInterface: TLabel
        Left = 305
        Top = 52
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089':'
        FocusControl = EditInterface
      end
      object LabelProcName: TLabel
        Left = 13
        Top = 51
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1086#1094#1077#1076#1091#1088#1072':'
        FocusControl = EditProcName
      end
      object LabelCommandString: TLabel
        Left = 267
        Top = 25
        Width = 98
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1086#1084#1072#1085#1076#1085#1072#1103' '#1089#1090#1088#1086#1082#1072':'
        FocusControl = EditCommandString
      end
      object LabelPriority: TLabel
        Left = 14
        Top = 24
        Width = 59
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
        FocusControl = ComboBoxPriority
      end
      object EditInterface: TEdit
        Left = 371
        Top = 49
        Width = 164
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 4
      end
      object ButtonInterface: TButton
        Left = 541
        Top = 49
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1085#1090#1077#1088#1092#1077#1081#1089
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 5
      end
      object EditProcName: TEdit
        Left = 79
        Top = 48
        Width = 210
        Height = 21
        TabOrder = 2
      end
      object EditCommandString: TEdit
        Left = 371
        Top = 22
        Width = 191
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
      end
      object ComboBoxPriority: TComboBox
        Left = 79
        Top = 21
        Width = 174
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          #1087#1088#1086#1089#1090#1072#1080#1074#1072#1102#1097#1080#1081
          #1085#1080#1079#1082#1080#1081
          #1085#1080#1078#1077' '#1089#1088#1077#1076#1085#1077#1075#1086
          #1089#1088#1077#1076#1085#1080#1081
          #1074#1099#1096#1077' '#1089#1088#1077#1076#1085#1077#1075#1086
          #1074#1099#1089#1086#1082#1080#1081)
      end
      object CheckBoxEnabled: TCheckBox
        Left = 16
        Top = 0
        Width = 74
        Height = 17
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' '#1080#1083#1080' '#1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
        Caption = #1042#1082#1083#1102#1095#1077#1085#1086
        TabOrder = 0
      end
    end
    object GroupBoxSchedule: TGroupBox
      Left = 8
      Top = 201
      Width = 574
      Height = 155
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1056#1072#1089#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 2
      DesignSize = (
        574
        155)
      object LabelDayFrequency: TLabel
        Left = 113
        Top = 50
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1050#1072#1078#1076#1099#1081':'
        FocusControl = EditDayFrequency
      end
      object LabelDayFrequency2: TLabel
        Left = 208
        Top = 50
        Width = 25
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1076#1077#1085#1100
        FocusControl = EditDayFrequency
      end
      object LabelWeekFrequency: TLabel
        Left = 112
        Top = 77
        Width = 47
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1050#1072#1078#1076#1091#1102':'
        FocusControl = EditWeekFrequency
      end
      object LabelWeekFrequency2: TLabel
        Left = 208
        Top = 77
        Width = 55
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1085#1077#1076#1077#1083#1102' '#1087#1086
        FocusControl = EditWeekFrequency
      end
      object LabelMotnDay: TLabel
        Left = 115
        Top = 104
        Width = 44
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1050#1072#1078#1076#1086#1077':'
        FocusControl = EditMotnDay
      end
      object LabelMotnDay2: TLabel
        Left = 208
        Top = 104
        Width = 67
        Height = 13
        Anchors = [akTop, akRight]
        Caption = #1095#1080#1089#1083#1086' '#1084#1077#1089#1103#1094#1072
        FocusControl = EditMotnDay
      end
      object LabelDateBegin: TLabel
        Left = 269
        Top = 23
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1053#1072#1095#1072#1083#1086':'
        FocusControl = DateTimePickerBegin
      end
      object LabelDateEnd: TLabel
        Left = 250
        Top = 50
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077':'
        FocusControl = DateTimePickerEnd
      end
      object LabelOffset: TLabel
        Left = 496
        Top = 23
        Width = 16
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = '+/-'
        FocusControl = EditOffset
        ExplicitLeft = 495
      end
      object EditDayFrequency: TEdit
        Left = 165
        Top = 47
        Width = 37
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 8
      end
      object EditWeekFrequency: TEdit
        Left = 165
        Top = 74
        Width = 37
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 11
      end
      object CheckBoxMonday: TCheckBox
        Left = 275
        Top = 76
        Width = 35
        Height = 17
        Hint = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
        Anchors = [akTop, akRight]
        Caption = #1055#1085
        TabOrder = 12
      end
      object CheckBoxTuesday: TCheckBox
        Left = 316
        Top = 76
        Width = 35
        Height = 17
        Hint = #1042#1090#1086#1088#1085#1080#1082
        Anchors = [akTop, akRight]
        Caption = #1042#1090
        TabOrder = 13
      end
      object CheckBoxWednesday: TCheckBox
        Left = 357
        Top = 76
        Width = 35
        Height = 17
        Hint = #1057#1088#1077#1076#1072
        Anchors = [akTop, akRight]
        Caption = #1057#1088
        TabOrder = 14
      end
      object CheckBoxThursday: TCheckBox
        Left = 398
        Top = 76
        Width = 35
        Height = 17
        Hint = #1063#1077#1090#1074#1077#1088#1075
        Anchors = [akTop, akRight]
        Caption = #1063#1090
        TabOrder = 15
      end
      object CheckBoxFriday: TCheckBox
        Left = 439
        Top = 76
        Width = 35
        Height = 17
        Hint = #1055#1103#1090#1085#1080#1094#1072
        Anchors = [akTop, akRight]
        Caption = #1055#1090
        TabOrder = 16
      end
      object CheckBoxSaturday: TCheckBox
        Left = 480
        Top = 76
        Width = 35
        Height = 17
        Hint = #1057#1091#1073#1073#1086#1090#1072
        Anchors = [akTop, akRight]
        Caption = #1057#1073
        TabOrder = 17
      end
      object CheckBoxSunday: TCheckBox
        Left = 521
        Top = 76
        Width = 35
        Height = 17
        Hint = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
        Anchors = [akTop, akRight]
        Caption = #1042#1089
        TabOrder = 18
      end
      object CheckBoxJanuary: TCheckBox
        Left = 287
        Top = 103
        Width = 41
        Height = 17
        Hint = #1071#1085#1074#1072#1088#1100
        Anchors = [akTop, akRight]
        Caption = #1071#1085#1074
        TabOrder = 20
      end
      object CheckBoxFebruary: TCheckBox
        Left = 333
        Top = 103
        Width = 41
        Height = 17
        Hint = #1060#1077#1074#1088#1072#1083#1100
        Anchors = [akTop, akRight]
        Caption = #1060#1077#1074
        TabOrder = 21
      end
      object CheckBoxMarch: TCheckBox
        Left = 380
        Top = 103
        Width = 41
        Height = 17
        Hint = #1052#1072#1088#1090
        Anchors = [akTop, akRight]
        Caption = #1052#1072#1088
        TabOrder = 22
      end
      object CheckBoxApril: TCheckBox
        Left = 427
        Top = 103
        Width = 41
        Height = 17
        Hint = #1040#1087#1088#1077#1083#1100
        Anchors = [akTop, akRight]
        Caption = #1040#1087#1088
        TabOrder = 23
      end
      object CheckBoxMay: TCheckBox
        Left = 474
        Top = 103
        Width = 41
        Height = 17
        Hint = #1052#1072#1081
        Anchors = [akTop, akRight]
        Caption = #1052#1072#1081
        TabOrder = 24
      end
      object CheckBoxJune: TCheckBox
        Left = 521
        Top = 103
        Width = 41
        Height = 17
        Hint = #1048#1102#1085#1100
        Anchors = [akTop, akRight]
        Caption = #1048#1102#1085
        TabOrder = 25
      end
      object CheckBoxJuly: TCheckBox
        Left = 287
        Top = 123
        Width = 41
        Height = 17
        Hint = #1048#1102#1083#1100
        Anchors = [akTop, akRight]
        Caption = #1048#1102#1083
        TabOrder = 26
      end
      object CheckBoxAugust: TCheckBox
        Left = 333
        Top = 123
        Width = 41
        Height = 17
        Hint = #1040#1074#1075#1091#1089#1090
        Anchors = [akTop, akRight]
        Caption = #1040#1074#1075
        TabOrder = 27
      end
      object CheckBoxSeptember: TCheckBox
        Left = 380
        Top = 123
        Width = 41
        Height = 17
        Hint = #1057#1077#1085#1090#1103#1073#1088#1100
        Anchors = [akTop, akRight]
        Caption = #1057#1077#1085
        TabOrder = 28
      end
      object CheckBoxOctober: TCheckBox
        Left = 427
        Top = 123
        Width = 41
        Height = 17
        Hint = #1054#1082#1090#1103#1073#1088#1100
        Anchors = [akTop, akRight]
        Caption = #1054#1082#1090
        TabOrder = 29
      end
      object CheckBoxNovember: TCheckBox
        Left = 474
        Top = 123
        Width = 41
        Height = 17
        Hint = #1053#1086#1103#1073#1088#1100
        Anchors = [akTop, akRight]
        Caption = #1053#1086#1103
        TabOrder = 30
      end
      object CheckBoxDecember: TCheckBox
        Left = 521
        Top = 123
        Width = 41
        Height = 17
        Hint = #1044#1077#1082#1072#1073#1088#1100
        Anchors = [akTop, akRight]
        Caption = #1044#1077#1082
        TabOrder = 31
      end
      object EditMotnDay: TEdit
        Left = 165
        Top = 101
        Width = 37
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 19
      end
      object DateTimePickerBegin: TDateTimePicker
        Left = 316
        Top = 20
        Width = 90
        Height = 21
        Anchors = [akTop, akRight]
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Checked = False
        TabOrder = 5
      end
      object DateTimePickerBeginTime: TDateTimePicker
        Left = 412
        Top = 20
        Width = 76
        Height = 21
        Anchors = [akTop, akRight]
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 6
      end
      object DateTimePickerEnd: TDateTimePicker
        Left = 316
        Top = 47
        Width = 90
        Height = 21
        Anchors = [akTop, akRight]
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Checked = False
        TabOrder = 9
      end
      object DateTimePickerEndTime: TDateTimePicker
        Left = 412
        Top = 47
        Width = 76
        Height = 21
        Anchors = [akTop, akRight]
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 10
      end
      object RadioButtonOnce: TRadioButton
        Left = 16
        Top = 21
        Width = 90
        Height = 17
        Caption = #1054#1076#1085#1086#1082#1088#1072#1090#1085#1086
        TabOrder = 0
        OnClick = RadioButtonOnceClick
      end
      object RadioButtonRun: TRadioButton
        Left = 16
        Top = 128
        Width = 152
        Height = 17
        Caption = #1055#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        TabOrder = 4
        OnClick = RadioButtonOnceClick
      end
      object RadioButtonEveryDay: TRadioButton
        Left = 16
        Top = 48
        Width = 90
        Height = 17
        Caption = #1045#1078#1077#1076#1085#1077#1074#1085#1086
        TabOrder = 1
        OnClick = RadioButtonOnceClick
      end
      object RadioButtonEveryWeek: TRadioButton
        Left = 16
        Top = 75
        Width = 90
        Height = 17
        Caption = #1045#1078#1077#1085#1077#1076#1077#1083#1100#1085#1086
        TabOrder = 2
        OnClick = RadioButtonOnceClick
      end
      object RadioButtonEveryMonth: TRadioButton
        Left = 16
        Top = 102
        Width = 90
        Height = 17
        Caption = #1045#1078#1077#1084#1077#1089#1103#1095#1085#1086
        TabOrder = 3
        OnClick = RadioButtonOnceClick
      end
      object EditOffset: TEdit
        Left = 517
        Top = 20
        Width = 44
        Height = 21
        Hint = #1057#1083#1091#1095#1072#1081#1085#1086#1077' '#1089#1084#1077#1097#1077#1085#1080#1077' '#1074' '#1089#1077#1082#1091#1085#1076#1072#1093
        Anchors = [akTop, akRight]
        TabOrder = 7
      end
    end
    object GroupBoxResult: TGroupBox
      Left = 209
      Top = 362
      Width = 373
      Height = 80
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1056#1077#1079#1091#1083#1100#1090#1072#1090' '
      TabOrder = 4
      DesignSize = (
        373
        80)
      object LabelDateExecute: TLabel
        Left = 44
        Top = 24
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072':'
        FocusControl = DateTimePickerExecute
      end
      object LabelResultString: TLabel
        Left = 12
        Top = 51
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077':'
        FocusControl = MemoResultString
      end
      object DateTimePickerExecute: TDateTimePicker
        Left = 80
        Top = 21
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Checked = False
        TabOrder = 0
      end
      object DateTimePickerExecuteTime: TDateTimePicker
        Left = 174
        Top = 21
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 1
      end
      object MemoResultString: TMemo
        Left = 80
        Top = 48
        Width = 281
        Height = 21
        Anchors = [akLeft, akTop, akRight, akBottom]
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
    object GroupBoxGeneral: TGroupBox
      Left = 8
      Top = 4
      Width = 575
      Height = 104
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1054#1073#1097#1080#1077' '
      TabOrder = 0
      DesignSize = (
        575
        104)
      object LabelDescription: TLabel
        Left = 307
        Top = 22
        Width = 53
        Height = 13
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
        FocusControl = MemoDescription
      end
      object LabelName: TLabel
        Left = 23
        Top = 21
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
        FocusControl = EditName
      end
      object LabelApplication: TLabel
        Left = 33
        Top = 48
        Width = 67
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
        FocusControl = EditApplication
      end
      object LabelAccount: TLabel
        Left = 16
        Top = 75
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
        FocusControl = EditAccount
      end
      object MemoDescription: TMemo
        Left = 305
        Top = 45
        Width = 257
        Height = 48
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object EditName: TEdit
        Left = 106
        Top = 18
        Width = 193
        Height = 21
        TabOrder = 0
      end
      object EditApplication: TEdit
        Left = 106
        Top = 45
        Width = 166
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 1
      end
      object ButtonApplication: TButton
        Left = 278
        Top = 45
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
        Caption = '...'
        TabOrder = 2
      end
      object EditAccount: TEdit
        Left = 106
        Top = 72
        Width = 166
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 3
      end
      object ButtonAccount: TButton
        Left = 278
        Top = 72
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1089#1087#1080#1100'/'#1088#1086#1083#1100
        Caption = '...'
        TabOrder = 4
      end
    end
  end
  inherited ImageList: TImageList
    Left = 200
    Top = 32
  end
end
