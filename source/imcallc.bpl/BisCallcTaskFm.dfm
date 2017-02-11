inherited BisCallcTaskForm: TBisCallcTaskForm
  Left = 467
  Top = 177
  Caption = #1047#1072#1076#1072#1085#1080#1077
  ClientHeight = 448
  ClientWidth = 627
  Constraints.MinHeight = 475
  Constraints.MinWidth = 635
  OnClose = FormClose
  ExplicitLeft = 467
  ExplicitTop = 177
  ExplicitWidth = 635
  ExplicitHeight = 475
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 429
    Width = 627
    Height = 19
    Panels = <>
  end
  object PanelTask: TPanel
    Left = 0
    Top = 0
    Width = 627
    Height = 134
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBoxTask: TGroupBox
      AlignWithMargins = True
      Left = 5
      Top = 3
      Width = 617
      Height = 131
      Margins.Left = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alClient
      Caption = ' '#1047#1072#1076#1072#1085#1080#1077' '
      TabOrder = 0
      object LabelNoTask: TLabel
        Left = 67
        Top = 1
        Width = 139
        Height = 13
        Alignment = taCenter
        Caption = #1053#1077#1090' '#1085#1080' '#1086#1076#1085#1086#1075#1086' '#1079#1072#1076#1072#1085#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        Visible = False
      end
      object PanelControls: TPanel
        Left = 2
        Top = 15
        Width = 613
        Height = 114
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          613
          114)
        object LabelAction: TLabel
          Left = 11
          Top = 8
          Width = 79
          Height = 13
          Alignment = taRightJustify
          Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
          FocusControl = EditAction
        end
        object LabelDateBegin: TLabel
          Left = 279
          Top = 8
          Width = 67
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
          FocusControl = EditDateBegin
        end
        object LabelTime: TLabel
          Left = 486
          Top = 8
          Width = 36
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = #1042#1088#1077#1084#1103':'
          FocusControl = EditTime
        end
        object LabelDescription: TLabel
          Left = 17
          Top = 35
          Width = 73
          Height = 13
          Alignment = taRightJustify
          Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
          FocusControl = MemoDescription
        end
        object LabelResult: TLabel
          Left = 35
          Top = 87
          Width = 55
          Height = 13
          Alignment = taRightJustify
          Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
          FocusControl = ComboBoxResult
        end
        object LabelNextDate: TLabel
          Left = 283
          Top = 87
          Width = 62
          Height = 13
          Anchors = [akTop, akRight]
          Caption = #1057#1083#1077#1076#1091#1102#1097#1077#1077':'
          Enabled = False
          FocusControl = DateTimePickerNext
        end
        object EditAction: TEdit
          Left = 96
          Top = 5
          Width = 169
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = 15000804
          ReadOnly = True
          TabOrder = 0
        end
        object EditDateBegin: TEdit
          Left = 352
          Top = 5
          Width = 121
          Height = 21
          Anchors = [akTop, akRight]
          Color = 15000804
          ReadOnly = True
          TabOrder = 1
        end
        object EditTime: TEdit
          Left = 528
          Top = 5
          Width = 77
          Height = 21
          Anchors = [akTop, akRight]
          Color = 15000804
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
        end
        object MemoDescription: TMemo
          Left = 96
          Top = 32
          Width = 481
          Height = 46
          Anchors = [akLeft, akTop, akRight]
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object ComboBoxResult: TComboBox
          Left = 96
          Top = 84
          Width = 169
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 16
          ItemHeight = 13
          Sorted = True
          TabOrder = 5
          OnChange = ComboBoxResultChange
        end
        object ButtonExecute: TBitBtn
          Left = 524
          Top = 84
          Width = 81
          Height = 21
          Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
          Anchors = [akTop, akRight]
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
          Default = True
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
          OnClick = ButtonExecuteClick
        end
        object DateTimePickerNext: TDateTimePicker
          Left = 351
          Top = 84
          Width = 88
          Height = 21
          Anchors = [akTop, akRight]
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Enabled = False
          TabOrder = 6
        end
        object DateTimePickerNextTime: TDateTimePicker
          Left = 445
          Top = 84
          Width = 73
          Height = 21
          Anchors = [akTop, akRight]
          Date = 39507.457070671300000000
          Time = 39507.457070671300000000
          Enabled = False
          Kind = dtkTime
          TabOrder = 7
        end
        object ButtonDescription: TButton
          Left = 583
          Top = 32
          Width = 21
          Height = 46
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 4
          OnClick = ButtonDescriptionClick
        end
      end
    end
  end
  object PanelFrame: TPanel
    Left = 0
    Top = 134
    Width = 627
    Height = 295
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object TimerRefresh: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerRefreshTimer
    Left = 157
    Top = 29
  end
  object TimerTime: TTimer
    Enabled = False
    OnTimer = TimerTimeTimer
    Left = 237
    Top = 21
  end
end