inherited BisBallManageTicketForm: TBisBallManageTicketForm
  Left = 0
  Top = 0
  ActiveControl = EditSearchNum
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1073#1080#1083#1077#1090#1086#1074
  ClientHeight = 555
  ClientWidth = 497
  ExplicitWidth = 505
  ExplicitHeight = 589
  PixelsPerInch = 96
  TextHeight = 13
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 497
    Height = 555
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      497
      555)
    object GroupBoxSearch: TGroupBox
      Left = 11
      Top = 8
      Width = 259
      Height = 108
      Caption = ' '#1055#1086#1080#1089#1082' '#1073#1080#1083#1077#1090#1072' '
      TabOrder = 0
      object LabelSearchNum: TLabel
        Left = 11
        Top = 57
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1086#1084#1077#1088':'
        FocusControl = EditSearchNum
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelTirage: TLabel
        Left = 15
        Top = 27
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = #1058#1080#1088#1072#1078':'
        FocusControl = EditTirage
      end
      object EditSearchNum: TMaskEdit
        Left = 57
        Top = 51
        Width = 109
        Height = 26
        EditMask = '!99999999;1;*'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxLength = 8
        ParentFont = False
        TabOrder = 2
        Text = '        '
      end
      object ButtonSearch: TButton
        Left = 173
        Top = 52
        Width = 75
        Height = 25
        Caption = #1055#1086#1080#1089#1082
        Default = True
        TabOrder = 3
        OnClick = ButtonSearchClick
      end
      object EditTirage: TEdit
        Left = 57
        Top = 24
        Width = 164
        Height = 21
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonTirage: TButton
        Left = 227
        Top = 24
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1088#1072#1078
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonTirageClick
      end
      object CheckBoxScanner: TCheckBox
        Left = 57
        Top = 83
        Width = 138
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1082#1072#1085#1077#1088
        TabOrder = 4
        OnClick = CheckBoxScannerClick
      end
    end
    object GroupBoxTicket: TGroupBox
      Left = 11
      Top = 120
      Width = 475
      Height = 345
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1058#1077#1082#1091#1097#1080#1081' '#1073#1080#1083#1077#1090' '
      TabOrder = 1
      object PanelTicket: TPanel
        Left = 2
        Top = 15
        Width = 471
        Height = 328
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object PageControlTicket: TPageControl
          Left = 0
          Top = 0
          Width = 471
          Height = 328
          ActivePage = TabSheetTicket
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 0
          object TabSheetNone: TTabSheet
            TabVisible = False
            object LabelTicketNone: TLabel
              Left = 0
              Top = 0
              Width = 463
              Height = 318
              Align = alClient
              Alignment = taCenter
              Caption = #1041#1080#1083#1077#1090' '#1085#1077' '#1085#1072#1081#1076#1077#1085'.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              Layout = tlCenter
              ExplicitWidth = 100
              ExplicitHeight = 13
            end
          end
          object TabSheetTicket: TTabSheet
            ImageIndex = 1
            TabVisible = False
            ExplicitTop = 12
            DesignSize = (
              463
              318)
            object LabelSeries: TLabel
              Left = 131
              Top = 3
              Width = 35
              Height = 13
              Alignment = taRightJustify
              Caption = #1057#1077#1088#1080#1103':'
              FocusControl = EditSeries
            end
            object LabelSurname: TLabel
              Left = 9
              Top = 267
              Width = 48
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1060#1072#1084#1080#1083#1080#1103':'
              FocusControl = EditSurname
            end
            object LabelName: TLabel
              Left = 174
              Top = 267
              Width = 23
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1048#1084#1103':'
              FocusControl = EditName
            end
            object LabelPatronymic: TLabel
              Left = 290
              Top = 267
              Width = 53
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
              FocusControl = EditPatronymic
            end
            object LabelAddress: TLabel
              Left = 162
              Top = 294
              Width = 35
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1040#1076#1088#1077#1089':'
              FocusControl = EditAddress
            end
            object LabelPhone: TLabel
              Left = 9
              Top = 294
              Width = 48
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1058#1077#1083#1077#1092#1086#1085':'
              FocusControl = EditPhone
            end
            object LabelNum: TLabel
              Left = 7
              Top = 3
              Width = 35
              Height = 13
              Alignment = taRightJustify
              Caption = #1053#1086#1084#1077#1088':'
              FocusControl = EditNum
            end
            object LabelOwner: TLabel
              Left = 10
              Top = 245
              Width = 59
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1042#1083#1072#1076#1077#1083#1077#1094
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BevelOwner: TBevel
              Left = 75
              Top = 251
              Width = 382
              Height = 10
              Anchors = [akTop, akRight]
              Shape = bsTopLine
            end
            object LabelFirst: TLabel
              Left = 6
              Top = 27
              Width = 36
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = '1 '#1080#1075#1088#1072
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BevelFirst: TBevel
              Left = 48
              Top = 34
              Width = 96
              Height = 10
              Anchors = [akTop, akRight]
              Shape = bsTopLine
            end
            object BevelSecond: TBevel
              Left = 195
              Top = 34
              Width = 262
              Height = 10
              Anchors = [akTop, akRight]
              Shape = bsTopLine
            end
            object LabelSecond: TLabel
              Left = 153
              Top = 27
              Width = 36
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = '2 '#1080#1075#1088#1072
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object ShapeFirst: TShape
              Left = 10
              Top = 46
              Width = 134
              Height = 165
              Anchors = [akTop, akRight]
              Brush.Color = clMoneyGreen
              Shape = stRoundRect
            end
            object ShapeSecond: TShape
              Left = 153
              Top = 46
              Width = 304
              Height = 165
              Anchors = [akTop, akRight]
              Brush.Color = clMoneyGreen
              Shape = stRoundRect
            end
            object LabelDealer: TLabel
              Left = 225
              Top = 3
              Width = 36
              Height = 13
              Alignment = taRightJustify
              Caption = #1044#1080#1083#1077#1088':'
              FocusControl = EditDealer
            end
            object LabelFirstPrize1: TLabel
              Left = 20
              Top = 66
              Width = 37
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1055#1088#1080#1079' 1:'
              FocusControl = EditFirstPrize1
            end
            object LabelFirstMoney1: TLabel
              Left = 20
              Top = 120
              Width = 50
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1044#1077#1085#1100#1075#1080' 1:'
              FocusControl = EditFirstMoney1
            end
            object LabelFirstCode: TLabel
              Left = 24
              Top = 174
              Width = 46
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1055#1080#1085'-'#1082#1086#1076':'
              FocusControl = EditFirstCode
            end
            object ShapeSecond1: TShape
              Left = 165
              Top = 56
              Width = 39
              Height = 144
              Anchors = [akTop, akRight]
              Brush.Color = 2154377
              Shape = stRoundRect
            end
            object ShapeSecond2: TShape
              Left = 213
              Top = 56
              Width = 39
              Height = 144
              Anchors = [akTop, akRight]
              Brush.Color = 32819
              Shape = stRoundRect
            end
            object ShapeSecond3: TShape
              Left = 261
              Top = 56
              Width = 39
              Height = 144
              Anchors = [akTop, akRight]
              Brush.Color = 2154377
              Shape = stRoundRect
            end
            object ShapeSecond4: TShape
              Left = 309
              Top = 56
              Width = 39
              Height = 144
              Anchors = [akTop, akRight]
              Brush.Color = 32819
              Shape = stRoundRect
            end
            object ShapeSecond5: TShape
              Left = 357
              Top = 56
              Width = 39
              Height = 144
              Anchors = [akTop, akRight]
              Brush.Color = 2154377
              Shape = stRoundRect
            end
            object ShapeSecond6: TShape
              Left = 405
              Top = 56
              Width = 39
              Height = 144
              Anchors = [akTop, akRight]
              Brush.Color = 32819
              Shape = stRoundRect
            end
            object LabelFirstPrize2: TLabel
              Left = 20
              Top = 93
              Width = 37
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1055#1088#1080#1079' 2:'
              FocusControl = EditFirstPrize2
            end
            object LabelFirstMoney2: TLabel
              Left = 20
              Top = 147
              Width = 50
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = #1044#1077#1085#1100#1075#1080' 2:'
              FocusControl = EditFirstMoney2
            end
            object EditSeries: TEdit
              Left = 172
              Top = 0
              Width = 43
              Height = 21
              Color = clBtnFace
              MaxLength = 4
              ReadOnly = True
              TabOrder = 1
            end
            object CheckBoxInLottery: TCheckBox
              Left = 386
              Top = 2
              Width = 76
              Height = 17
              Hint = #1059#1095#1072#1089#1090#1080#1077' '#1073#1080#1083#1077#1090#1072' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077
              Anchors = [akTop, akRight]
              Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090
              TabOrder = 3
              OnClick = CheckBoxInLotteryClick
            end
            object EditSurname: TEdit
              Left = 63
              Top = 264
              Width = 100
              Height = 21
              Anchors = [akTop, akRight]
              MaxLength = 100
              TabOrder = 43
            end
            object EditName: TEdit
              Left = 203
              Top = 264
              Width = 75
              Height = 21
              Anchors = [akTop, akRight]
              MaxLength = 100
              TabOrder = 44
            end
            object EditPatronymic: TEdit
              Left = 349
              Top = 264
              Width = 106
              Height = 21
              Anchors = [akTop, akRight]
              MaxLength = 100
              TabOrder = 45
            end
            object EditAddress: TEdit
              Left = 203
              Top = 291
              Width = 171
              Height = 21
              Anchors = [akTop, akRight]
              MaxLength = 250
              TabOrder = 47
            end
            object EditPhone: TEdit
              Left = 63
              Top = 291
              Width = 84
              Height = 21
              Anchors = [akTop, akRight]
              MaxLength = 100
              TabOrder = 46
            end
            object EditNum: TEdit
              Left = 48
              Top = 0
              Width = 72
              Height = 21
              Color = clBtnFace
              MaxLength = 8
              ReadOnly = True
              TabOrder = 0
            end
            object ButtonChange: TButton
              Left = 380
              Top = 291
              Width = 75
              Height = 21
              Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074#1083#1072#1076#1077#1083#1100#1094#1072
              Anchors = [akTop, akRight]
              Caption = #1048#1079#1084#1077#1085#1080#1090#1100
              TabOrder = 48
              OnClick = ButtonChangeClick
            end
            object EditDealer: TEdit
              Left = 267
              Top = 0
              Width = 113
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Color = clBtnFace
              ReadOnly = True
              TabOrder = 2
            end
            object EditFirstPrize1: TEdit
              Left = 63
              Top = 63
              Width = 69
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 4
            end
            object EditFirstMoney1: TEdit
              Left = 76
              Top = 117
              Width = 56
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 6
            end
            object EditFirstCode: TEdit
              Left = 76
              Top = 171
              Width = 56
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 8
            end
            object EditSecond11: TEdit
              Left = 172
              Top = 63
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 9
            end
            object EditSecond12: TEdit
              Left = 172
              Top = 90
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 10
            end
            object EditSecond13: TEdit
              Left = 172
              Top = 117
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 11
            end
            object EditSecond14: TEdit
              Left = 172
              Top = 144
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 12
            end
            object EditSecond15: TEdit
              Left = 172
              Top = 171
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 13
            end
            object EditSecond21: TEdit
              Left = 220
              Top = 63
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 14
            end
            object EditSecond22: TEdit
              Left = 220
              Top = 90
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 15
            end
            object EditSecond23: TEdit
              Left = 220
              Top = 117
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 16
            end
            object EditSecond24: TEdit
              Left = 220
              Top = 144
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 17
            end
            object EditSecond25: TEdit
              Left = 220
              Top = 171
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 18
            end
            object EditSecond31: TEdit
              Left = 268
              Top = 63
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 19
            end
            object EditSecond32: TEdit
              Left = 268
              Top = 90
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 20
            end
            object EditSecond33: TEdit
              Left = 268
              Top = 117
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 21
            end
            object EditSecond34: TEdit
              Left = 268
              Top = 144
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 22
            end
            object EditSecond35: TEdit
              Left = 268
              Top = 171
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 23
            end
            object EditSecond41: TEdit
              Left = 316
              Top = 63
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 24
            end
            object EditSecond42: TEdit
              Left = 316
              Top = 90
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 25
            end
            object EditSecond43: TEdit
              Left = 316
              Top = 117
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 26
            end
            object EditSecond44: TEdit
              Left = 316
              Top = 144
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 27
            end
            object EditSecond45: TEdit
              Left = 316
              Top = 171
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 28
            end
            object EditSecond51: TEdit
              Left = 364
              Top = 63
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 29
            end
            object EditSecond52: TEdit
              Left = 364
              Top = 90
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 30
            end
            object EditSecond53: TEdit
              Left = 364
              Top = 117
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 31
            end
            object EditSecond54: TEdit
              Left = 364
              Top = 144
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 32
            end
            object EditSecond55: TEdit
              Left = 364
              Top = 171
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 33
            end
            object EditSecond61: TEdit
              Left = 412
              Top = 63
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 34
            end
            object EditSecond62: TEdit
              Left = 412
              Top = 90
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 35
            end
            object EditSecond63: TEdit
              Left = 412
              Top = 117
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 36
            end
            object EditSecond64: TEdit
              Left = 412
              Top = 144
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 37
            end
            object EditSecond65: TEdit
              Left = 412
              Top = 171
              Width = 25
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 38
            end
            object EditFirstPrize2: TEdit
              Left = 63
              Top = 90
              Width = 69
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 5
            end
            object EditFirstMoney2: TEdit
              Left = 76
              Top = 144
              Width = 56
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              Enabled = False
              TabOrder = 7
            end
            object PanelSecondWinning: TPanel
              Left = 163
              Top = 219
              Width = 90
              Height = 21
              Anchors = [akTop, akRight]
              Caption = #1053#1077' '#1080#1075#1088#1072#1083
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentBackground = False
              ParentFont = False
              TabOrder = 40
            end
            object PanelFirstWinning: TPanel
              Left = 30
              Top = 219
              Width = 90
              Height = 21
              Anchors = [akTop, akRight]
              Caption = #1053#1077' '#1080#1075#1088#1072#1083
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentBackground = False
              ParentFont = False
              TabOrder = 39
            end
            object EditSecondPrizeCost: TEdit
              Left = 380
              Top = 219
              Width = 75
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              ReadOnly = True
              TabOrder = 42
            end
            object EditSecondPrizeName: TEdit
              Left = 259
              Top = 219
              Width = 115
              Height = 21
              Anchors = [akTop, akRight]
              Color = clBtnFace
              ReadOnly = True
              TabOrder = 41
            end
          end
        end
      end
    end
    object GroupBoxAction: TGroupBox
      Left = 279
      Top = 25
      Width = 207
      Height = 91
      Caption = '                         '
      TabOrder = 2
      object CheckBoxAction: TCheckBox
        Left = 13
        Top = -1
        Width = 76
        Height = 17
        Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077' '#1074' '#1089#1083#1091#1095#1072#1077' '#1091#1089#1087#1077#1096#1085#1086#1075#1086' '#1087#1086#1080#1089#1082#1072' '#1073#1080#1083#1077#1090#1072
        Caption = #1044#1077#1081#1089#1090#1074#1080#1077
        TabOrder = 0
        OnClick = CheckBoxActionClick
      end
      object PanelAction: TPanel
        Left = 2
        Top = 15
        Width = 203
        Height = 74
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object RadioButtonAutoExclude: TRadioButton
          Left = 12
          Top = 14
          Width = 169
          Height = 17
          Hint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1080#1089#1082#1083#1102#1095#1072#1090#1100' '#1080#1079' '#1088#1086#1079#1099#1075#1088#1099#1096#1072
          Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RadioButtonAutoInclude: TRadioButton
          Left = 12
          Top = 41
          Width = 169
          Height = 17
          Hint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1074#1082#1083#1102#1095#1072#1090#1100' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096
          Caption = #1042#1082#1083#1102#1095#1072#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
          TabOrder = 1
        end
      end
    end
    object GroupBoxStatistics: TGroupBox
      Left = 11
      Top = 471
      Width = 475
      Height = 71
      Anchors = [akRight, akBottom]
      Caption = ' '#1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1086' '#1073#1080#1083#1077#1090#1072#1084' '
      TabOrder = 3
      DesignSize = (
        475
        71)
      object LabelTicketCount: TLabel
        Left = 16
        Top = 24
        Width = 113
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1097#1077#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelTicketManageCount: TLabel
        Left = 49
        Top = 43
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1085#1099#1077':'
        Color = clWindowText
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object LabelTicketUsedCount: TLabel
        Left = 241
        Top = 43
        Width = 146
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight, akBottom]
        Caption = #1059#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 242
      end
      object LabelTicketNotUsedCount: TLabel
        Left = 226
        Top = 24
        Width = 161
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight, akBottom]
        Caption = #1053#1077' '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 227
      end
      object LabelTicketCounter: TLabel
        Left = 135
        Top = 24
        Width = 7
        Height = 13
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelTicketManageCounter: TLabel
        Left = 135
        Top = 43
        Width = 7
        Height = 13
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelTicketNotUsedCounter: TLabel
        Left = 393
        Top = 24
        Width = 7
        Height = 13
        Anchors = [akTop, akRight, akBottom]
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 394
      end
      object LabelTicketUsedCounter: TLabel
        Left = 393
        Top = 43
        Width = 7
        Height = 13
        Anchors = [akTop, akRight, akBottom]
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitLeft = 394
      end
    end
  end
end
