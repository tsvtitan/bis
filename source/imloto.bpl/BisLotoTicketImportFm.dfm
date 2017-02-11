inherited BisLotoTicketImportForm: TBisLotoTicketImportForm
  Left = 0
  Top = 0
  Caption = #1048#1084#1087#1086#1088#1090' '#1073#1080#1083#1077#1090#1086#1074
  ClientHeight = 373
  ClientWidth = 291
  Font.Name = 'Tahoma'
  ExplicitWidth = 299
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  object PanelControls: TPanel
    Left = 0
    Top = 0
    Width = 291
    Height = 373
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 316
    ExplicitHeight = 257
    DesignSize = (
      291
      373)
    object LabelFile: TLabel
      Left = 20
      Top = 43
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1081#1083':'
      FocusControl = EditFile
    end
    object LabelTirage: TLabel
      Left = 14
      Top = 16
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1088#1072#1078':'
      FocusControl = EditTirage
    end
    object LabelCounter: TLabel
      Left = 14
      Top = 319
      Width = 94
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1086' 0 '#1080#1079' 0'
      ExplicitTop = 203
    end
    object EditTirage: TEdit
      Left = 56
      Top = 13
      Width = 164
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonFile: TButton
      Left = 255
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083' '#1090#1080#1088#1072#1078#1072
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = ButtonFileClick
      ExplicitLeft = 280
    end
    object EditFile: TEdit
      Left = 56
      Top = 40
      Width = 193
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
      ExplicitWidth = 218
    end
    object GroupBoxAction: TGroupBox
      Left = 14
      Top = 67
      Width = 262
      Height = 126
      Anchors = [akLeft, akTop, akRight]
      Caption = ' '#1044#1077#1081#1089#1090#1074#1080#1077' '
      TabOrder = 3
      ExplicitWidth = 287
      object RadioButtonReplace: TRadioButton
        Left = 16
        Top = 24
        Width = 185
        Height = 17
        Caption = #1047#1072#1084#1077#1085#1072' '#1074#1089#1077#1093' '#1073#1080#1083#1077#1090#1086#1074' '#1074' '#1090#1080#1088#1072#1078#1077
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButtonAppend: TRadioButton
        Left = 16
        Top = 47
        Width = 193
        Height = 17
        Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1073#1080#1083#1077#1090#1086#1074' '#1082' '#1090#1080#1088#1072#1078#1091
        TabOrder = 1
      end
      object RadioButtonExclude: TRadioButton
        Left = 16
        Top = 70
        Width = 225
        Height = 17
        Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1073#1080#1083#1077#1090#1086#1074' '#1080#1079' '#1088#1086#1079#1099#1075#1088#1099#1096#1072
        TabOrder = 2
      end
      object RadioButtonInclude: TRadioButton
        Left = 16
        Top = 93
        Width = 233
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1077#1085#1080#1077' '#1073#1080#1083#1077#1090#1086#1074' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096
        TabOrder = 3
      end
    end
    object ButtonTirage: TButton
      Left = 226
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1088#1072#1078
      Caption = '...'
      TabOrder = 4
      OnClick = ButtonTirageClick
    end
    object ProgressBar: TProgressBar
      Left = 14
      Top = 337
      Width = 176
      Height = 18
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 5
      ExplicitTop = 221
      ExplicitWidth = 201
    end
    object ButtonImport: TButton
      Left = 201
      Top = 333
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1048#1084#1087#1086#1088#1090
      Default = True
      TabOrder = 6
      OnClick = ButtonImportClick
      ExplicitLeft = 226
      ExplicitTop = 217
    end
    object GroupBoxStatistics: TGroupBox
      Left = 14
      Top = 199
      Width = 262
      Height = 114
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = ' '#1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1086' '#1073#1080#1083#1077#1090#1072#1084' '
      TabOrder = 7
      ExplicitWidth = 505
      ExplicitHeight = 145
      object LabelTicketCount: TLabel
        Left = 88
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
        Left = 109
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
        Left = 43
        Top = 81
        Width = 146
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTicketNotUsedCount: TLabel
        Left = 28
        Top = 62
        Width = 161
        Height = 13
        Alignment = taRightJustify
        Caption = #1053#1077' '#1091#1095#1072#1089#1090#1074#1091#1102#1097#1080#1077' '#1074' '#1088#1086#1079#1099#1075#1088#1099#1096#1077':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelTicketCounter: TLabel
        Left = 195
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
        Left = 195
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
        Left = 195
        Top = 62
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
        Left = 195
        Top = 81
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
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'Xml '#1092#1072#1081#1083#1099' (*.xml)|*.xml|Txt '#1092#1072#1081#1083#1099' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|' +
      '*.*'
    Options = [ofEnableSizing]
    Left = 241
    Top = 88
  end
end
