inherited BisBallDataTirageEditForm: TBisBallDataTirageEditForm
  Left = 513
  Top = 212
  Caption = 'BisBallDataTirageEditForm'
  ClientHeight = 390
  ClientWidth = 458
  ExplicitWidth = 466
  ExplicitHeight = 424
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 347
    Width = 458
    Height = 43
    ExplicitTop = 347
    ExplicitWidth = 458
    ExplicitHeight = 43
    inherited ButtonOk: TButton
      Left = 277
      Top = 9
      ExplicitLeft = 277
      ExplicitTop = 9
    end
    inherited ButtonCancel: TButton
      Left = 373
      Top = 9
      ExplicitLeft = 373
      ExplicitTop = 9
    end
  end
  inherited PanelControls: TPanel
    Width = 458
    Height = 347
    ExplicitWidth = 458
    ExplicitHeight = 347
    object PageControl: TPageControl
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 452
      Height = 341
      ActivePage = TabSheetGeneral
      Align = alClient
      TabOrder = 0
      OnChange = PageControlChange
      object TabSheetGeneral: TTabSheet
        Caption = #1054#1073#1097#1080#1077
        DesignSize = (
          444
          313)
        object LabelNum: TLabel
          Left = 32
          Top = 13
          Width = 76
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1086#1084#1077#1088' '#1090#1080#1088#1072#1078#1072':'
          FocusControl = EditNum
        end
        object LabelExecutionDate: TLabel
          Left = 14
          Top = 40
          Width = 94
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103':'
          FocusControl = DateTimePickerExecution
        end
        object LabelExecutionPlace: TLabel
          Left = 9
          Top = 67
          Width = 99
          Height = 13
          Alignment = taRightJustify
          Caption = #1052#1077#1089#1090#1086' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103':'
          FocusControl = EditExecutionPlace
        end
        object LabelTicketCost: TLabel
          Left = 11
          Top = 94
          Width = 97
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1073#1080#1083#1077#1090#1072':'
          FocusControl = EditTicketCost
        end
        object LabelJackpotPercent: TLabel
          Left = 35
          Top = 148
          Width = 73
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% '#1076#1078#1077#1082'-'#1087#1086#1090#1072':'
          FocusControl = EditJackpotPercent
        end
        object LabelPrizePercent: TLabel
          Left = 27
          Top = 121
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% '#1087#1088#1080#1079'. '#1092#1086#1085#1076#1072':'
          FocusControl = EditPrizePercent
        end
        object LabelFirstPercent: TLabel
          Left = 56
          Top = 175
          Width = 52
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% 1 '#1080#1075#1088#1099':'
          FocusControl = EditFirstPercent
        end
        object LabelTicketCount: TLabel
          Left = 162
          Top = 13
          Width = 96
          Height = 13
          Alignment = taRightJustify
          Caption = #1041#1080#1083#1077#1090#1086#1074' '#1074' '#1090#1080#1088#1072#1078#1077':'
          FocusControl = EditTicketCount
        end
        object LabelTicketUsedCount: TLabel
          Left = 210
          Top = 94
          Width = 116
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1041#1080#1083#1077#1090#1086#1074' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077':'
          FocusControl = EditTicketUsedCount
        end
        object LabelPrizeSum: TLabel
          Left = 225
          Top = 121
          Width = 101
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1079'. '#1092#1086#1085#1076#1072':'
          FocusControl = EditPrizeSum
        end
        object LabelFirstSum: TLabel
          Left = 254
          Top = 175
          Width = 72
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' 1 '#1080#1075#1088#1099':'
          FocusControl = EditFirstSum
        end
        object LabelJackpotSum: TLabel
          Left = 233
          Top = 148
          Width = 93
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' '#1076#1078#1077#1082'-'#1087#1086#1090#1072':'
          FocusControl = EditJackpotSum
        end
        object LabelSecond1RoundPercent: TLabel
          Left = 20
          Top = 202
          Width = 88
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% 2 '#1080#1075#1088#1099' 1 '#1090#1091#1088#1072':'
          FocusControl = EditSecond1RoundPercent
        end
        object LabelSecond1RoundSum: TLabel
          Left = 218
          Top = 202
          Width = 108
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' 2 '#1080#1075#1088#1099' 1 '#1090#1091#1088#1072':'
          FocusControl = EditSecond1RoundSum
        end
        object LabelSecond2RoundPercent: TLabel
          Left = 20
          Top = 229
          Width = 88
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% 2 '#1080#1075#1088#1099' 2 '#1090#1091#1088#1072':'
          FocusControl = EditSecond2RoundPercent
        end
        object LabelSecond2RoundSum: TLabel
          Left = 218
          Top = 229
          Width = 108
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' 2 '#1080#1075#1088#1099' 2 '#1090#1091#1088#1072':'
          FocusControl = EditSecond2RoundSum
        end
        object LabelSecond3RoundPercent: TLabel
          Left = 20
          Top = 256
          Width = 88
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% 2 '#1080#1075#1088#1099' 3 '#1090#1091#1088#1072':'
          FocusControl = EditSecond3RoundPercent
        end
        object LabelSecond3RoundSum: TLabel
          Left = 218
          Top = 256
          Width = 108
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' 2 '#1080#1075#1088#1099' 3 '#1090#1091#1088#1072':'
          FocusControl = EditSecond3RoundSum
        end
        object LabelSecond4RoundPercent: TLabel
          Left = 20
          Top = 283
          Width = 88
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = '% 2 '#1080#1075#1088#1099' 4 '#1090#1091#1088#1072':'
          FocusControl = EditSecond4RoundPercent
        end
        object LabelSecond4RoundSum: TLabel
          Left = 218
          Top = 283
          Width = 108
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1057#1091#1084#1084#1072' 2 '#1080#1075#1088#1099' 4 '#1090#1091#1088#1072':'
          FocusControl = EditSecond4RoundSum
        end
        object EditNum: TEdit
          Left = 114
          Top = 10
          Width = 40
          Height = 21
          TabOrder = 0
        end
        object DateTimePickerExecution: TDateTimePicker
          Left = 114
          Top = 37
          Width = 112
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          TabOrder = 2
        end
        object DateTimePickerExecutionTime: TDateTimePicker
          Left = 232
          Top = 37
          Width = 86
          Height = 21
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Kind = dtkTime
          TabOrder = 3
        end
        object EditExecutionPlace: TEdit
          Left = 114
          Top = 64
          Width = 318
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 5
        end
        object EditTicketCost: TEdit
          Left = 114
          Top = 91
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 6
          OnChange = EditTicketCostChange
        end
        object EditJackpotPercent: TEdit
          Left = 114
          Top = 145
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 10
          OnChange = EditTicketCostChange
        end
        object EditPrizePercent: TEdit
          Left = 114
          Top = 118
          Width = 71
          Height = 21
          Hint = #1055#1088#1086#1094#1077#1085#1090' '#1087#1088#1080#1079#1086#1074#1086#1075#1086' '#1092#1086#1085#1076#1072
          Anchors = [akTop, akRight]
          TabOrder = 8
          OnChange = EditTicketCostChange
        end
        object CheckBoxPreparationFlag: TCheckBox
          Left = 324
          Top = 39
          Width = 97
          Height = 17
          Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1083#1077#1085
          TabOrder = 4
          OnClick = CheckBoxPreparationFlagClick
        end
        object EditFirstPercent: TEdit
          Left = 114
          Top = 172
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 12
          OnChange = EditTicketCostChange
        end
        object EditTicketCount: TEdit
          Left = 264
          Top = 10
          Width = 54
          Height = 21
          Hint = #1054#1073#1097#1077#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1080#1083#1077#1090#1086#1074' '#1074' '#1090#1080#1088#1072#1078#1077
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object EditTicketUsedCount: TEdit
          Left = 332
          Top = 91
          Width = 100
          Height = 21
          Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1080#1083#1077#1090#1086#1074', '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1093' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 7
        end
        object EditPrizeSum: TEdit
          Left = 332
          Top = 118
          Width = 100
          Height = 21
          Hint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1079#1086#1074#1086#1075#1086' '#1092#1086#1085#1076#1072
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 9
        end
        object EditFirstSum: TEdit
          Left = 332
          Top = 172
          Width = 100
          Height = 21
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 13
        end
        object EditJackpotSum: TEdit
          Left = 332
          Top = 145
          Width = 100
          Height = 21
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 11
        end
        object EditSecond1RoundPercent: TEdit
          Left = 114
          Top = 199
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 14
          OnChange = EditTicketCostChange
        end
        object EditSecond1RoundSum: TEdit
          Left = 332
          Top = 199
          Width = 100
          Height = 21
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 15
        end
        object EditSecond2RoundPercent: TEdit
          Left = 114
          Top = 226
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 16
          OnChange = EditTicketCostChange
        end
        object EditSecond2RoundSum: TEdit
          Left = 332
          Top = 226
          Width = 100
          Height = 21
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 17
        end
        object EditSecond3RoundPercent: TEdit
          Left = 114
          Top = 253
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 18
          OnChange = EditTicketCostChange
        end
        object EditSecond3RoundSum: TEdit
          Left = 332
          Top = 253
          Width = 100
          Height = 21
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 19
        end
        object EditSecond4RoundPercent: TEdit
          Left = 114
          Top = 280
          Width = 71
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 20
          OnChange = EditTicketCostChange
        end
        object EditSecond4RoundSum: TEdit
          Left = 332
          Top = 280
          Width = 100
          Height = 21
          TabStop = False
          Anchors = [akTop, akRight]
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 21
        end
      end
      object TabSheetSubrounds: TTabSheet
        Caption = #1055#1086#1076#1090#1091#1088#1099' 2 '#1080#1075#1088#1099' 4 '#1090#1091#1088#1072
        ImageIndex = 1
        object PanelPrizes: TPanel
          Left = 0
          Top = 0
          Width = 444
          Height = 313
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
        end
      end
    end
  end
  inherited ImageList: TImageList
    Left = 168
    Top = 176
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 168
    Top = 128
  end
end
