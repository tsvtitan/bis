inherited BisLotoTicketManageForm: TBisLotoTicketManageForm
  Left = 0
  Top = 0
  ActiveControl = EditSearchNum
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1073#1080#1083#1077#1090#1086#1074
  ClientHeight = 517
  ClientWidth = 494
  Font.Name = 'Tahoma'
  ExplicitWidth = 502
  ExplicitHeight = 551
  PixelsPerInch = 96
  TextHeight = 13
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 494
    Height = 517
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      494
      517)
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
      object EditSearchNum: TEdit
        Left = 57
        Top = 51
        Width = 110
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        MaxLength = 8
        ParentFont = False
        TabOrder = 2
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
      Top = 121
      Width = 472
      Height = 307
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1058#1077#1082#1091#1097#1080#1081' '#1073#1080#1083#1077#1090' '
      TabOrder = 1
      object PanelTicket: TPanel
        Left = 2
        Top = 15
        Width = 468
        Height = 290
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object PageControlTicket: TPageControl
          Left = 0
          Top = 0
          Width = 468
          Height = 290
          ActivePage = TabSheetTicket
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 0
          object TabSheetNone: TTabSheet
            TabVisible = False
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 464
            ExplicitHeight = 295
            object LabelTicketNone: TLabel
              Left = 0
              Top = 0
              Width = 100
              Height = 13
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
            end
          end
          object TabSheetTicket: TTabSheet
            ImageIndex = 1
            TabVisible = False
            object ShapeString4: TShape
              Left = 49
              Top = 142
              Width = 388
              Height = 32
              Brush.Color = 8421631
              Shape = stRoundRect
            end
            object ShapeString3: TShape
              Left = 48
              Top = 105
              Width = 388
              Height = 32
              Brush.Color = clSkyBlue
              Shape = stRoundRect
            end
            object ShapeString2: TShape
              Left = 49
              Top = 68
              Width = 388
              Height = 32
              Brush.Color = clMoneyGreen
              Shape = stRoundRect
            end
            object ShapeString1: TShape
              Left = 49
              Top = 31
              Width = 388
              Height = 32
              Brush.Color = clSilver
              Shape = stRoundRect
            end
            object LabelSeries: TLabel
              Left = 146
              Top = 5
              Width = 35
              Height = 13
              Alignment = taRightJustify
              Caption = #1057#1077#1088#1080#1103':'
              FocusControl = EditSeries
            end
            object LabelString1: TLabel
              Left = 62
              Top = 39
              Width = 63
              Height = 13
              Alignment = taRightJustify
              Caption = #1057#1090#1088#1086#1082#1072' '#8470'1:'
              FocusControl = EditF1_01
            end
            object LabelString2: TLabel
              Left = 62
              Top = 76
              Width = 63
              Height = 13
              Alignment = taRightJustify
              Caption = #1057#1090#1088#1086#1082#1072' '#8470'2:'
              FocusControl = EditF2_01
            end
            object LabelString3: TLabel
              Left = 61
              Top = 113
              Width = 63
              Height = 13
              Alignment = taRightJustify
              Caption = #1057#1090#1088#1086#1082#1072' '#8470'3:'
              FocusControl = EditF3_01
            end
            object LabelString4: TLabel
              Left = 61
              Top = 150
              Width = 63
              Height = 13
              Alignment = taRightJustify
              Caption = #1057#1090#1088#1086#1082#1072' '#8470'4:'
              FocusControl = EditF4_01
            end
            object LabelSurname: TLabel
              Left = 7
              Top = 201
              Width = 48
              Height = 13
              Alignment = taRightJustify
              Caption = #1060#1072#1084#1080#1083#1080#1103':'
              FocusControl = EditSurname
            end
            object LabelName: TLabel
              Left = 172
              Top = 201
              Width = 23
              Height = 13
              Alignment = taRightJustify
              Caption = #1048#1084#1103':'
              FocusControl = EditName
            end
            object LabelPatronymic: TLabel
              Left = 288
              Top = 201
              Width = 53
              Height = 13
              Alignment = taRightJustify
              Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
              FocusControl = EditPatronymic
            end
            object LabelAddress: TLabel
              Left = 20
              Top = 228
              Width = 35
              Height = 13
              Alignment = taRightJustify
              Caption = #1040#1076#1088#1077#1089':'
              FocusControl = EditAddress
            end
            object LabelPhone: TLabel
              Left = 6
              Top = 255
              Width = 48
              Height = 13
              Alignment = taRightJustify
              Caption = #1058#1077#1083#1077#1092#1086#1085':'
              FocusControl = EditPhone
            end
            object LabelNum: TLabel
              Left = 22
              Top = 5
              Width = 35
              Height = 13
              Alignment = taRightJustify
              Caption = #1053#1086#1084#1077#1088':'
              FocusControl = EditNum
            end
            object LabelOwner: TLabel
              Left = 8
              Top = 177
              Width = 59
              Height = 13
              Caption = #1042#1083#1072#1076#1077#1083#1077#1094
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object BevelOwner: TBevel
              Left = 73
              Top = 183
              Width = 384
              Height = 10
              Shape = bsTopLine
            end
            object EditSeries: TEdit
              Left = 187
              Top = 2
              Width = 60
              Height = 21
              Color = clBtnFace
              MaxLength = 4
              ReadOnly = True
              TabOrder = 1
            end
            object EditF1_01: TEdit
              Left = 131
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 10
            end
            object EditF1_02: TEdit
              Left = 165
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 11
            end
            object EditF1_03: TEdit
              Left = 199
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 12
            end
            object EditF1_04: TEdit
              Left = 233
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 13
            end
            object EditF1_05: TEdit
              Left = 267
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 14
            end
            object EditF1_06: TEdit
              Left = 301
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 15
            end
            object EditF1_07: TEdit
              Left = 335
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 16
            end
            object EditF1_08: TEdit
              Left = 369
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 17
            end
            object EditF1_09: TEdit
              Left = 403
              Top = 36
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 18
            end
            object EditF2_01: TEdit
              Left = 131
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 19
            end
            object EditF2_02: TEdit
              Left = 165
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 20
            end
            object EditF2_03: TEdit
              Left = 199
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 21
            end
            object EditF2_04: TEdit
              Left = 233
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 22
            end
            object EditF2_05: TEdit
              Left = 267
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 23
            end
            object EditF2_06: TEdit
              Left = 301
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 24
            end
            object EditF2_07: TEdit
              Left = 335
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 25
            end
            object EditF2_08: TEdit
              Left = 369
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 26
            end
            object EditF2_09: TEdit
              Left = 403
              Top = 73
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 27
            end
            object EditF3_01: TEdit
              Left = 130
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 28
            end
            object EditF3_02: TEdit
              Left = 164
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 29
            end
            object EditF3_03: TEdit
              Left = 198
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 30
            end
            object EditF3_04: TEdit
              Left = 232
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 31
            end
            object EditF3_05: TEdit
              Left = 266
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 32
            end
            object EditF3_06: TEdit
              Left = 300
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 33
            end
            object EditF3_07: TEdit
              Left = 334
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 34
            end
            object EditF3_08: TEdit
              Left = 368
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 35
            end
            object EditF3_09: TEdit
              Left = 402
              Top = 110
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 36
            end
            object EditF4_01: TEdit
              Left = 130
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 37
            end
            object EditF4_02: TEdit
              Left = 164
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 38
            end
            object EditF4_03: TEdit
              Left = 198
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 39
            end
            object EditF4_04: TEdit
              Left = 232
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 40
            end
            object EditF4_05: TEdit
              Left = 266
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 41
            end
            object EditF4_06: TEdit
              Left = 300
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 42
            end
            object EditF4_07: TEdit
              Left = 334
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 43
            end
            object EditF4_08: TEdit
              Left = 368
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 44
            end
            object EditF4_09: TEdit
              Left = 402
              Top = 147
              Width = 28
              Height = 21
              MaxLength = 2
              ReadOnly = True
              TabOrder = 45
            end
            object CheckBoxInLottery: TCheckBox
              Left = 266
              Top = 4
              Width = 87
              Height = 17
              Hint = #1059#1095#1072#1089#1090#1074#1080#1077' '#1073#1080#1083#1077#1090#1072' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077
              Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090
              TabOrder = 2
              OnClick = CheckBoxInLotteryClick
            end
            object EditSurname: TEdit
              Left = 61
              Top = 198
              Width = 100
              Height = 21
              MaxLength = 100
              TabOrder = 4
            end
            object EditName: TEdit
              Left = 201
              Top = 198
              Width = 75
              Height = 21
              MaxLength = 100
              TabOrder = 5
            end
            object EditPatronymic: TEdit
              Left = 347
              Top = 198
              Width = 106
              Height = 21
              MaxLength = 100
              TabOrder = 6
            end
            object EditAddress: TEdit
              Left = 61
              Top = 225
              Width = 392
              Height = 21
              MaxLength = 250
              TabOrder = 7
            end
            object EditPhone: TEdit
              Left = 60
              Top = 252
              Width = 312
              Height = 21
              MaxLength = 100
              TabOrder = 8
            end
            object EditNum: TEdit
              Left = 63
              Top = 2
              Width = 72
              Height = 21
              Color = clBtnFace
              MaxLength = 8
              ReadOnly = True
              TabOrder = 0
            end
            object ButtonPrizes: TButton
              Left = 378
              Top = 0
              Width = 75
              Height = 25
              Caption = #1055#1088#1080#1079#1099
              TabOrder = 3
              Visible = False
            end
            object ButtonChange: TButton
              Left = 378
              Top = 250
              Width = 75
              Height = 25
              Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074#1083#1072#1076#1077#1083#1100#1094#1072
              Caption = #1048#1079#1084#1077#1085#1080#1090#1100
              TabOrder = 9
              OnClick = ButtonChangeClick
            end
          end
        end
      end
    end
    object GroupBoxAction: TGroupBox
      Left = 279
      Top = 25
      Width = 204
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
        Width = 200
        Height = 74
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object RadioButtonAutoExclude: TRadioButton
          Left = 12
          Top = 18
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
      Top = 434
      Width = 471
      Height = 71
      Anchors = [akLeft, akRight, akBottom]
      Caption = ' '#1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1086' '#1073#1080#1083#1077#1090#1072#1084' '
      TabOrder = 3
      DesignSize = (
        471
        71)
      object LabelTicketCount: TLabel
        Left = 28
        Top = 24
        Width = 101
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1097#1077#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
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
        Left = 237
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
        Left = 222
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
        Left = 389
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
        Left = 389
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
