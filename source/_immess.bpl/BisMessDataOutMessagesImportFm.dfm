inherited BisMessDataOutMessagesImportForm: TBisMessDataOutMessagesImportForm
  Caption = #1048#1084#1087#1086#1088#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
  ClientHeight = 371
  ClientWidth = 508
  OnResize = FormResize
  ExplicitWidth = 516
  ExplicitHeight = 405
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButtons: TPanel
    Top = 333
    Width = 508
    ExplicitTop = 333
    ExplicitWidth = 502
    inherited ButtonCancel: TButton
      Left = 425
      TabOrder = 4
      ExplicitLeft = 419
    end
    inherited BitBtnStart: TBitBtn
      Left = 243
      TabOrder = 2
      ExplicitLeft = 237
    end
    inherited BitBtnStop: TBitBtn
      Left = 344
      TabOrder = 3
      ExplicitLeft = 338
    end
    inherited ButtonOptions: TButton
      Left = 90
      TabOrder = 1
      Visible = False
      ExplicitLeft = 90
    end
    object ButtonLoad: TButton
      Left = 9
      Top = 5
      Width = 75
      Height = 25
      Action = ActionLoad
      Anchors = [akLeft, akBottom]
      TabOrder = 0
    end
  end
  inherited PanelControls: TPanel
    Width = 508
    Height = 333
    ExplicitWidth = 502
    ExplicitHeight = 333
    object PanelControlsTop: TPanel
      Left = 0
      Top = 0
      Width = 508
      Height = 122
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = -3
      ExplicitWidth = 502
      DesignSize = (
        508
        122)
      object LabelAccount: TLabel
        Left = 19
        Top = 13
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
        FocusControl = EditAccount
      end
      object LabelDateBegin: TLabel
        Left = 33
        Top = 40
        Width = 69
        Height = 13
        Alignment = taRightJustify
        Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
        FocusControl = DateTimePickerBegin
      end
      object Bevel: TBevel
        Left = 9
        Top = 94
        Width = 487
        Height = 3
        Anchors = [akLeft, akTop, akRight]
        Shape = bsTopLine
        ExplicitWidth = 418
      end
      object LabelPreview: TLabel
        Left = 14
        Top = 100
        Width = 148
        Height = 13
        Caption = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088':'
        Transparent = False
      end
      object LabelFile: TLabel
        Left = 168
        Top = 100
        Width = 259
        Height = 13
        AutoSize = False
        Caption = 'LabelFile'
        EllipsisPosition = epPathEllipsis
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelPriority: TLabel
        Left = 43
        Top = 67
        Width = 59
        Height = 13
        Alignment = taRightJustify
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090':'
        FocusControl = ComboBoxPriority
        Transparent = True
      end
      object EditAccount: TEdit
        Left = 109
        Top = 10
        Width = 140
        Height = 21
        Color = clBtnFace
        MaxLength = 100
        ReadOnly = True
        TabOrder = 0
      end
      object ButtonAccount: TButton
        Left = 255
        Top = 10
        Width = 21
        Height = 21
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
        Caption = '...'
        TabOrder = 1
        OnClick = ButtonAccountClick
      end
      object DateTimePickerBegin: TDateTimePicker
        Left = 108
        Top = 37
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 2
      end
      object DateTimePickerBeginTime: TDateTimePicker
        Left = 202
        Top = 37
        Width = 74
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 3
      end
      object DateTimePickerEnd: TDateTimePicker
        Left = 322
        Top = 64
        Width = 88
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        TabOrder = 10
      end
      object DateTimePickerEndTime: TDateTimePicker
        Left = 416
        Top = 64
        Width = 80
        Height = 21
        Date = 39507.457070671300000000
        Time = 39507.457070671300000000
        Kind = dtkTime
        TabOrder = 11
      end
      object CheckBoxOffset: TCheckBox
        Left = 285
        Top = 39
        Width = 76
        Height = 17
        Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1084#1077#1097#1077#1085#1080#1077' '#1074' '#1089#1077#1082#1091#1085#1076#1072#1093' '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1077#1075#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
        Caption = #1057#1084#1077#1097#1077#1085#1080#1077':'
        TabOrder = 4
        OnClick = CheckBoxOffsetClick
      end
      object EditOffset: TEdit
        Left = 365
        Top = 37
        Width = 29
        Height = 21
        ReadOnly = True
        TabOrder = 5
        Text = '5'
      end
      object UpDownOffset: TUpDown
        Left = 394
        Top = 37
        Width = 16
        Height = 21
        Associate = EditOffset
        Min = 1
        Position = 5
        TabOrder = 6
      end
      object CheckBoxDateEnd: TCheckBox
        Left = 211
        Top = 66
        Width = 107
        Height = 17
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
        TabOrder = 9
        OnClick = CheckBoxDateEndClick
      end
      object ComboBoxPriority: TComboBox
        Left = 108
        Top = 64
        Width = 88
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 8
        Text = #1085#1086#1088#1084#1072#1083#1100#1085#1099#1081
        Items.Strings = (
          #1074#1099#1089#1086#1082#1080#1081
          #1085#1086#1088#1084#1072#1083#1100#1085#1099#1081
          #1085#1080#1079#1082#1080#1081)
      end
      object ButtonRecount: TButton
        Left = 416
        Top = 37
        Width = 80
        Height = 21
        Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1072#1090#1091' '#1085#1072#1095#1072#1083#1072
        Caption = #1087#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100
        TabOrder = 7
        OnClick = ButtonRecountClick
      end
    end
    object PanelControlsBottom: TPanel
      Left = 0
      Top = 304
      Width = 508
      Height = 29
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitWidth = 502
      DesignSize = (
        508
        29)
      object LabelCountCaption: TLabel
        Left = 12
        Top = 7
        Width = 94
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = #1042#1089#1077#1075#1086' '#1089#1086#1086#1073#1097#1077#1085#1080#1081': '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelCount: TLabel
        Left = 108
        Top = 7
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
      object ProgressBar: TProgressBar
        Left = 170
        Top = 6
        Width = 330
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 0
        Visible = False
        ExplicitWidth = 324
      end
    end
    object PanelGrid: TPanel
      Left = 0
      Top = 122
      Width = 508
      Height = 182
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 502
      object Grid: TDBGrid
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 498
        Height = 182
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alClient
        DataSource = DataSource
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'NUM'
            Title.Caption = '#'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CONTACT'
            Title.Caption = #1050#1086#1085#1090#1072#1082#1090
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TEXT'
            Title.Caption = #1058#1077#1082#1089#1090
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SYMBOL_COUNT'
            Title.Caption = #1057#1080#1084#1074#1086#1083#1086#1074
            Width = 27
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MESSAGE_COUNT'
            Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1081
            Width = 25
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATE_BEGIN'
            Title.Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072
            Width = 75
            Visible = True
          end>
      end
    end
  end
  inherited Timer: TTimer
    Left = 184
    Top = 176
  end
  inherited ImageList: TImageList
    Left = 232
    Top = 176
  end
  inherited ActionList: TActionList
    Left = 72
    Top = 176
    object ActionLoad: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1087#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088
      OnExecute = ActionLoadExecute
      OnUpdate = ActionLoadUpdate
    end
  end
  object DataSource: TDataSource
    AutoEdit = False
    Left = 128
    Top = 176
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'Excel '#1092#1072#1081#1083#1099' (*.xls)|*.xls|Txt '#1092#1072#1081#1083#1099' (*.txt)|*.txt|Csv '#1092#1072#1081#1083#1099' (*.c' +
      'sv)|*.csv|Xml '#1092#1072#1081#1083#1099' (*.xml)|*.xml'
    Options = [ofEnableSizing]
    Left = 296
    Top = 168
  end
end
