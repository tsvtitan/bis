inherited BisDesignDataLockEditForm: TBisDesignDataLockEditForm
  Left = 659
  Top = 255
  Caption = 'BisDesignDataLockEditForm'
  ClientHeight = 274
  ClientWidth = 499
  ExplicitWidth = 507
  ExplicitHeight = 308
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 236
    Width = 499
    ExplicitTop = 236
    ExplicitWidth = 499
    inherited ButtonOk: TButton
      Left = 320
      ExplicitLeft = 320
    end
    inherited ButtonCancel: TButton
      Left = 416
      ExplicitLeft = 416
    end
  end
  inherited PanelControls: TPanel
    Width = 499
    Height = 236
    ExplicitWidth = 499
    ExplicitHeight = 236
    object LabelDescription: TLabel
      Left = 42
      Top = 178
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelMethod: TLabel
      Left = 58
      Top = 70
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = #1052#1077#1090#1086#1076':'
      FocusControl = ComboBoxMethod
    end
    object LabelObject: TLabel
      Left = 52
      Top = 97
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1073#1098#1077#1082#1090':'
      FocusControl = EditObject
    end
    object LabelAccount: TLabel
      Left = 11
      Top = 43
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelDateBegin: TLabel
      Left = 26
      Top = 124
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelApplication: TLabel
      Left = 28
      Top = 16
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077':'
      FocusControl = EditApplication
    end
    object LabelDateEnd: TLabel
      Left = 8
      Top = 151
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelIpList: TLabel
      Left = 279
      Top = 16
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1087#1080#1089#1086#1082' IP:'
      FocusControl = MemoIpList
    end
    object MemoDescription: TMemo
      Left = 101
      Top = 175
      Width = 388
      Height = 53
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 10
    end
    object EditObject: TEdit
      Left = 101
      Top = 94
      Width = 168
      Height = 21
      TabOrder = 5
    end
    object EditAccount: TEdit
      Left = 101
      Top = 40
      Width = 141
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonAccount: TButton
      Left = 248
      Top = 40
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1089#1087#1080#1100'/'#1088#1086#1083#1100
      Caption = '...'
      TabOrder = 3
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 101
      Top = 121
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 6
    end
    object DateTimePickerBeginTime: TDateTimePicker
      Left = 195
      Top = 121
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 7
    end
    object EditApplication: TEdit
      Left = 101
      Top = 13
      Width = 141
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonApplication: TButton
      Left = 248
      Top = 13
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 101
      Top = 148
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 8
    end
    object DateTimePickerEndTime: TDateTimePicker
      Left = 195
      Top = 148
      Width = 74
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 9
    end
    object MemoIpList: TMemo
      Left = 275
      Top = 35
      Width = 211
      Height = 134
      Anchors = [akLeft, akTop, akRight]
      ScrollBars = ssVertical
      TabOrder = 11
    end
    object ComboBoxMethod: TComboBox
      Left = 101
      Top = 67
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      Sorted = True
      TabOrder = 4
      Items.Strings = (
        'Execute'
        'GetRecords'
        'LoadAlarms'
        'LoadDocument'
        'LoadInterfaces'
        'LoadMenus'
        'LoadProfile'
        'LoadReport'
        'LoadScript'
        'LoadTasks'
        'Login'
        'Logout'
        'SaveProfile'
        'SaveTask')
    end
  end
  inherited ImageList: TImageList
    Left = 304
    Top = 48
  end
end