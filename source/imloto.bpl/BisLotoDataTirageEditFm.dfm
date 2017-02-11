inherited BisLotoDataTirageEditForm: TBisLotoDataTirageEditForm
  Left = 513
  Top = 212
  ActiveControl = EditNum
  Caption = 'BisLotoDataTirageEditForm'
  ClientHeight = 327
  ClientWidth = 451
  ExplicitWidth = 459
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 284
    Width = 451
    Height = 43
    ExplicitTop = 284
    ExplicitWidth = 451
    ExplicitHeight = 43
    inherited ButtonOk: TButton
      Left = 270
      Top = 9
      ExplicitLeft = 270
      ExplicitTop = 9
    end
    inherited ButtonCancel: TButton
      Left = 366
      Top = 9
      ExplicitLeft = 366
      ExplicitTop = 9
    end
  end
  inherited PanelControls: TPanel
    Width = 451
    Height = 284
    ExplicitWidth = 451
    ExplicitHeight = 284
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 451
      Height = 284
      ActivePage = TabSheetGeneral
      Align = alClient
      TabOrder = 0
      OnChange = PageControlChange
      object TabSheetGeneral: TTabSheet
        Caption = #1054#1073#1097#1080#1077
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
          Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1073#1080#1083#1077#1090#1072':'
          FocusControl = EditTicketCost
        end
        object LabelJackpotPercent: TLabel
          Left = 35
          Top = 148
          Width = 73
          Height = 13
          Alignment = taRightJustify
          Caption = '% '#1076#1078#1077#1082'-'#1087#1086#1090#1072':'
          FocusControl = EditJackpotPercent
        end
        object LabelPrizePercent: TLabel
          Left = 27
          Top = 121
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = '% '#1087#1088#1080#1079'. '#1092#1086#1085#1076#1072':'
          FocusControl = EditPrizePercent
        end
        object LabelFirstRoundPercent: TLabel
          Left = 57
          Top = 175
          Width = 51
          Height = 13
          Alignment = taRightJustify
          Caption = '% 1 '#1090#1091#1088#1072':'
          FocusControl = EditFirstRoundPercent
        end
        object LabelThirdRoundSum: TLabel
          Left = 37
          Top = 202
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1091#1084#1084#1072' 3 '#1090#1091#1088#1072':'
          FocusControl = EditThirdRoundSum
        end
        object LabelFourthRoundSum: TLabel
          Left = 37
          Top = 229
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1091#1084#1084#1072' 4 '#1090#1091#1088#1072':'
          FocusControl = EditFourthRoundSum
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
          Caption = #1041#1080#1083#1077#1090#1086#1074' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077':'
          FocusControl = EditTicketUsedCount
        end
        object LabelPrizeSum: TLabel
          Left = 225
          Top = 121
          Width = 101
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1079'. '#1092#1086#1085#1076#1072':'
          FocusControl = EditPrizeSum
        end
        object LabelSecondRoundSum: TLabel
          Left = 255
          Top = 202
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1091#1084#1084#1072' 2 '#1090#1091#1088#1072':'
          FocusControl = EditSecondRoundSum
        end
        object LabelFirstRoundSum: TLabel
          Left = 255
          Top = 175
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1091#1084#1084#1072' 1 '#1090#1091#1088#1072':'
          FocusControl = EditFirstRoundSum
        end
        object LabelJackpotSum: TLabel
          Left = 233
          Top = 148
          Width = 93
          Height = 13
          Alignment = taRightJustify
          Caption = #1057#1091#1084#1084#1072' '#1076#1078#1077#1082'-'#1087#1086#1090#1072':'
          FocusControl = EditJackpotSum
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
          Width = 272
          Height = 21
          TabOrder = 4
        end
        object EditTicketCost: TEdit
          Left = 114
          Top = 91
          Width = 71
          Height = 21
          TabOrder = 5
          OnChange = EditTicketCostChange
        end
        object EditJackpotPercent: TEdit
          Left = 114
          Top = 145
          Width = 71
          Height = 21
          TabOrder = 9
          OnChange = EditTicketCostChange
        end
        object EditPrizePercent: TEdit
          Left = 114
          Top = 118
          Width = 71
          Height = 21
          Hint = #1055#1088#1086#1094#1077#1085#1090' '#1087#1088#1080#1079#1086#1074#1086#1075#1086' '#1092#1086#1085#1076#1072
          TabOrder = 7
          OnChange = EditTicketCostChange
        end
        object CheckBoxPreparationFlag: TCheckBox
          Left = 266
          Top = 228
          Width = 97
          Height = 17
          Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1083#1077#1085
          TabOrder = 16
          OnClick = CheckBoxPreparationFlagClick
        end
        object EditFirstRoundPercent: TEdit
          Left = 114
          Top = 172
          Width = 71
          Height = 21
          TabOrder = 11
          OnChange = EditTicketCostChange
        end
        object EditThirdRoundSum: TEdit
          Left = 114
          Top = 199
          Width = 100
          Height = 21
          TabOrder = 13
          OnChange = EditTicketCostChange
        end
        object EditFourthRoundSum: TEdit
          Left = 114
          Top = 226
          Width = 100
          Height = 21
          TabOrder = 15
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
          Width = 54
          Height = 21
          Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1080#1083#1077#1090#1086#1074', '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1093' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 6
        end
        object EditPrizeSum: TEdit
          Left = 332
          Top = 118
          Width = 100
          Height = 21
          Hint = #1057#1091#1084#1084#1072' '#1087#1088#1080#1079#1086#1074#1086#1075#1086' '#1092#1086#1085#1076#1072
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 8
        end
        object EditSecondRoundSum: TEdit
          Left = 332
          Top = 199
          Width = 100
          Height = 21
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 14
        end
        object EditFirstRoundSum: TEdit
          Left = 332
          Top = 172
          Width = 100
          Height = 21
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 12
        end
        object EditJackpotSum: TEdit
          Left = 332
          Top = 145
          Width = 100
          Height = 21
          TabStop = False
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 10
        end
      end
      object TabSheetPrizes: TTabSheet
        Caption = #1055#1088#1080#1079#1099
        ImageIndex = 1
        object PanelPrizes: TPanel
          Left = 0
          Top = 0
          Width = 443
          Height = 256
          Align = alClient
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
        end
      end
    end
  end
  inherited ImageList: TImageList
    Left = 24
    Top = 280
  end
  object Timer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerTimer
    Left = 72
    Top = 280
  end
end
