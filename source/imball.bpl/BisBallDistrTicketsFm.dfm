inherited BisBallDistrTicketsForm: TBisBallDistrTicketsForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1076#1072#1095#1072' '#1073#1080#1083#1077#1090#1086#1074
  ClientHeight = 314
  ClientWidth = 532
  ExplicitWidth = 540
  ExplicitHeight = 348
  PixelsPerInch = 96
  TextHeight = 13
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 314
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      532
      314)
    object LabelTirage: TLabel
      Left = 16
      Top = 16
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1088#1072#1078':'
      FocusControl = EditTirage
    end
    object LabelCounter: TLabel
      Left = 14
      Top = 260
      Width = 94
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1086' 0 '#1080#1079' 0'
      ExplicitTop = 203
    end
    object LabelDealer: TLabel
      Left = 16
      Top = 43
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1080#1083#1077#1088':'
      FocusControl = EditDealer
    end
    object LabelPaymentType: TLabel
      Left = 16
      Top = 70
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1080#1089#1090#1077#1084#1072' '#1086#1087#1083#1072#1090#1099':'
      FocusControl = EditPaymentType
    end
    object EditTirage: TEdit
      Left = 58
      Top = 13
      Width = 145
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object GroupBoxAction: TGroupBox
      Left = 265
      Top = 13
      Width = 135
      Height = 75
      Caption = ' '#1044#1077#1081#1089#1090#1074#1080#1077' '
      TabOrder = 6
      object RadioButtonDistr: TRadioButton
        Left = 15
        Top = 22
        Width = 110
        Height = 17
        Caption = #1042#1099#1076#1072#1090#1100' '#1073#1080#1083#1077#1090#1099
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RadioButtonDistrClick
      end
      object RadioButtonReturn: TRadioButton
        Left = 15
        Top = 44
        Width = 102
        Height = 17
        Caption = #1042#1077#1088#1085#1091#1090#1100' '#1073#1080#1083#1077#1090#1099
        TabOrder = 1
        OnClick = RadioButtonDistrClick
      end
    end
    object ButtonTirage: TButton
      Left = 209
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1088#1072#1078
      Caption = '...'
      TabOrder = 1
      OnClick = ButtonTirageClick
    end
    object ProgressBar: TProgressBar
      Left = 14
      Top = 278
      Width = 417
      Height = 18
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 8
    end
    object ButtonAction: TButton
      Left = 442
      Top = 274
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1042#1099#1076#1072#1090#1100
      Default = True
      TabOrder = 9
      OnClick = ButtonActionClick
    end
    object GroupBoxStatistics: TGroupBox
      Left = 265
      Top = 94
      Width = 258
      Height = 161
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1086' '#1073#1080#1083#1077#1090#1072#1084' '
      TabOrder = 7
      object LabelTicketCount: TLabel
        Left = 40
        Top = 20
        Width = 159
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1097#1077#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' ('#1074#1089#1077#1075#1086'):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelTicketManageCount: TLabel
        Left = 108
        Top = 134
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1085#1099#1077':'
        Color = clWindowText
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object LabelTicketUsedCount: TLabel
        Left = 84
        Top = 58
        Width = 115
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' ('#1074#1089#1077#1075#1086'):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTicketNotUsedCount: TLabel
        Left = 69
        Top = 39
        Width = 130
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1077' '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' ('#1074#1089#1077#1075#1086'):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTicketCounter: TLabel
        Left = 205
        Top = 20
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
        Left = 205
        Top = 134
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
        Left = 205
        Top = 39
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
      object LabelTicketUsedCounter: TLabel
        Left = 205
        Top = 58
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
      object LabelTicketUsedCountByDealer: TLabel
        Left = 60
        Top = 115
        Width = 139
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' ('#1087#1086' '#1076#1080#1083#1077#1088#1091'):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTicketNotUsedCountByDealer: TLabel
        Left = 45
        Top = 96
        Width = 154
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1077' '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' ('#1087#1086' '#1076#1080#1083#1077#1088#1091'):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTicketNotUsedCounterByDealer: TLabel
        Left = 205
        Top = 96
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
      object LabelTicketUsedCounterByDealer: TLabel
        Left = 205
        Top = 115
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
      object LabelTicketCountByDealer: TLabel
        Left = 13
        Top = 77
        Width = 186
        Height = 13
        Alignment = taRightJustify
        Caption = #1054#1073#1097#1077#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' ('#1087#1086' '#1076#1080#1083#1077#1088#1091'):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelTicketCounterByDealer: TLabel
        Left = 205
        Top = 77
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
    end
    object EditDealer: TEdit
      Left = 58
      Top = 40
      Width = 172
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonDealer: TButton
      Left = 236
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1076#1080#1083#1077#1088#1072
      Caption = '...'
      TabOrder = 3
      OnClick = ButtonDealerClick
    end
    object GroupBoxRanges: TGroupBox
      Left = 16
      Top = 94
      Width = 241
      Height = 161
      Anchors = [akLeft, akTop, akBottom]
      Caption = ' '#1044#1080#1072#1087#1072#1079#1086#1085#1099' '
      TabOrder = 5
      DesignSize = (
        241
        161)
      object LabelFrom: TLabel
        Left = 25
        Top = 24
        Width = 12
        Height = 13
        Alignment = taRightJustify
        Caption = #1086#1090
        FocusControl = MaskEditFrom
      end
      object MaskEditFrom: TMaskEdit
        Left = 43
        Top = 21
        Width = 51
        Height = 21
        EditMask = '!99999999;1;*'
        MaxLength = 8
        TabOrder = 0
        Text = '        '
      end
      object MaskEditTo: TMaskEdit
        Left = 148
        Top = 21
        Width = 55
        Height = 21
        Enabled = False
        EditMask = '!99999999;1;*'
        MaxLength = 8
        TabOrder = 2
        Text = '        '
      end
      object ListBoxRanges: TListBox
        Left = 13
        Top = 48
        Width = 190
        Height = 99
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        Items.Strings = (
          '001*****  -  002*****'
          '00300001  -  00300002'
          '00499912')
        PopupMenu = PopupActionBarRanges
        TabOrder = 6
        OnClick = ListBoxRangesClick
      end
      object ButtonAddRange: TButton
        Left = 209
        Top = 48
        Width = 21
        Height = 21
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1080#1072#1087#1072#1079#1086#1085
        Caption = '<'
        TabOrder = 3
        OnClick = ButtonAddRangeClick
      end
      object ButtonDelRange: TButton
        Left = 209
        Top = 75
        Width = 21
        Height = 21
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1080#1072#1087#1072#1079#1086#1085
        Caption = '>'
        TabOrder = 4
        OnClick = ButtonDelRangeClick
      end
      object ButtonClearRanges: TButton
        Left = 209
        Top = 102
        Width = 21
        Height = 21
        Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1080#1087#1072#1079#1086#1085#1099
        Caption = 'O'
        TabOrder = 5
        OnClick = ButtonClearRangesClick
      end
      object CheckBoxTo: TCheckBox
        Left = 110
        Top = 23
        Width = 32
        Height = 17
        Alignment = taLeftJustify
        Caption = #1076#1086
        TabOrder = 1
        OnClick = CheckBoxToClick
      end
    end
    object EditPaymentType: TEdit
      Left = 109
      Top = 67
      Width = 148
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
  end
  object PopupActionBarRanges: TPopupActionBar
    Left = 112
    Top = 184
    object MenuItemAddRange: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1080#1072#1087#1072#1079#1086#1085
      OnClick = ButtonAddRangeClick
    end
    object MenuItemDelRange: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1080#1072#1087#1072#1079#1086#1085
      OnClick = ButtonDelRangeClick
    end
    object MenuItemClearRanges: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1080#1072#1087#1072#1079#1086#1085#1099
      OnClick = ButtonClearRangesClick
    end
  end
end
