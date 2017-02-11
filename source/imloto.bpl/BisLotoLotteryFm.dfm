inherited BisLotoLotteryForm: TBisLotoLotteryForm
  Left = 0
  Top = 0
  Caption = #1056#1086#1079#1099#1075#1088#1099#1096
  ClientHeight = 416
  ClientWidth = 503
  Font.Name = 'Tahoma'
  ExplicitWidth = 511
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 416
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      503
      416)
    object GroupBoxOutput: TGroupBox
      Left = 10
      Top = 340
      Width = 482
      Height = 65
      Anchors = [akRight, akBottom]
      Caption = '                     '
      TabOrder = 2
      object CheckBoxOutput: TCheckBox
        Left = 13
        Top = -1
        Width = 60
        Height = 17
        Hint = #1042#1082#1083#1102#1095#1080#1090#1100' '#1080#1083#1080' '#1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1074#1086#1076' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
        Caption = #1042#1099#1074#1086#1076
        TabOrder = 0
        OnClick = CheckBoxOutputClick
      end
      object PanelOutput: TPanel
        Left = 2
        Top = 15
        Width = 478
        Height = 48
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelDir: TLabel
          Left = 104
          Top = 16
          Width = 66
          Height = 13
          Alignment = taRightJustify
          Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103':'
          FocusControl = EditDir
        end
        object EditDir: TEdit
          Left = 176
          Top = 13
          Width = 259
          Height = 21
          TabOrder = 0
        end
        object ButtonDir: TButton
          Left = 441
          Top = 13
          Width = 21
          Height = 21
          Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102
          Caption = '...'
          TabOrder = 1
          OnClick = ButtonDirClick
        end
        object ButtonOutputRefresh: TButton
          Left = 14
          Top = 13
          Width = 75
          Height = 21
          Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1074#1099#1074#1086#1076' '#1074' '#1088#1091#1095#1085#1091#1102
          Caption = #1086#1073#1085#1086#1074#1080#1090#1100
          TabOrder = 2
          OnClick = ButtonOutputRefreshClick
        end
      end
    end
    object GroupBoxGeneral: TGroupBox
      Left = 10
      Top = 6
      Width = 482
      Height = 88
      Caption = ' '#1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077' '
      TabOrder = 0
      object LabelUsedCount: TLabel
        Left = 272
        Top = 27
        Width = 109
        Height = 13
        Alignment = taRightJustify
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1080#1083#1077#1090#1086#1074':'
        FocusControl = EditUsedCount
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTirage: TLabel
        Left = 21
        Top = 27
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080#1088#1072#1078':'
        FocusControl = EditTirage
      end
      object LabelPrizeSum: TLabel
        Left = 272
        Top = 54
        Width = 82
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1079#1086#1074#1086#1081' '#1092#1086#1085#1076':'
        FocusControl = EditPrizeSum
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelJackpotSum: TLabel
        Left = 63
        Top = 54
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = #1057#1091#1084#1084#1072' '#1076#1078#1077#1082'-'#1087#1086#1090#1072':'
        FocusControl = EditJackpotSum
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object EditUsedCount: TEdit
        Left = 387
        Top = 24
        Width = 77
        Height = 21
        Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1080#1083#1077#1090#1086#1074', '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1093' '#1074' '#1090#1080#1088#1072#1078#1077
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object EditTirage: TEdit
        Left = 63
        Top = 24
        Width = 164
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonTirage: TButton
        Left = 233
        Top = 24
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1088#1072#1078
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonTirageClick
      end
      object EditPrizeSum: TEdit
        Left = 360
        Top = 51
        Width = 104
        Height = 21
        Hint = #1055#1088#1080#1079#1086#1074#1086#1081' '#1092#1086#1085#1076
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 4
      end
      object EditJackpotSum: TEdit
        Left = 162
        Top = 51
        Width = 92
        Height = 21
        Hint = #1057#1091#1084#1084#1072' '#1076#1078#1077#1082'-'#1087#1086#1090#1072
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
    object GroupBoxRounds: TGroupBox
      Left = 10
      Top = 100
      Width = 482
      Height = 233
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1058#1091#1088#1099' '
      TabOrder = 1
      object PanelRounds: TPanel
        AlignWithMargins = True
        Left = 7
        Top = 18
        Width = 468
        Height = 208
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        BevelOuter = bvNone
        Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1088#1072#1078'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object PageControl: TPageControl
          Left = 0
          Top = 0
          Width = 468
          Height = 208
          ActivePage = TabSheetRound1
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Style = tsFlatButtons
          TabOrder = 0
          OnChange = PageControlChange
          object TabSheetRound1: TTabSheet
            Caption = '1 '#1090#1091#1088
          end
          object TabSheetRound2: TTabSheet
            Caption = '2 '#1090#1091#1088
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
          object TabSheetRound3: TTabSheet
            Caption = '3 '#1090#1091#1088
            ImageIndex = 2
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
          object TabSheetRound4: TTabSheet
            Caption = '4 '#1090#1091#1088
            ImageIndex = 3
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
          end
        end
      end
    end
  end
end
