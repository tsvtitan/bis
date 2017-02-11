inherited BisKrieltExportRtfForm: TBisKrieltExportRtfForm
  Left = 447
  Top = 271
  Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074' rtf'
  ClientHeight = 343
  ClientWidth = 369
  ExplicitWidth = 377
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 13
  object LabelPublishing: TLabel
    Left = 50
    Top = 11
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = #1048#1079#1076#1072#1085#1080#1077':'
    FocusControl = EditPublishing
  end
  object LabelView: TLabel
    Left = 22
    Top = 38
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = #1042#1080#1076' '#1086#1073#1098#1077#1082#1090#1086#1074':'
    FocusControl = EditView
  end
  object LabelType: TLabel
    Left = 23
    Top = 65
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1086#1074':'
    FocusControl = EditType
  end
  object LabelOperation: TLabel
    Left = 43
    Top = 92
    Width = 54
    Height = 13
    Alignment = taRightJustify
    Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
    FocusControl = EditOperation
  end
  object LabelDateBeginFrom: TLabel
    Left = 22
    Top = 279
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1089':'
    FocusControl = DateTimePickerBeginFrom
  end
  object LabelDateBeginTo: TLabel
    Left = 213
    Top = 279
    Width = 16
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = #1087#1086':'
    FocusControl = DateTimePickerBeginTo
  end
  object EditPublishing: TEdit
    Left = 103
    Top = 8
    Width = 153
    Height = 21
    Color = 15000804
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = EditPublishingKeyDown
  end
  object ButtonPublishing: TButton
    Left = 262
    Top = 8
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1080#1079#1076#1072#1085#1080#1077
    Caption = '...'
    TabOrder = 1
    OnClick = ButtonPublishingClick
  end
  object EditView: TEdit
    Left = 103
    Top = 35
    Width = 153
    Height = 21
    Color = 15000804
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnKeyDown = EditPublishingKeyDown
  end
  object ButtonView: TButton
    Left = 262
    Top = 35
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1086#1073#1098#1077#1082#1090#1072
    Caption = '...'
    TabOrder = 3
    OnClick = ButtonViewClick
  end
  object EditType: TEdit
    Left = 103
    Top = 62
    Width = 153
    Height = 21
    Color = 15000804
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnKeyDown = EditPublishingKeyDown
  end
  object ButtonType: TButton
    Left = 262
    Top = 62
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087
    Caption = '...'
    TabOrder = 5
    OnClick = ButtonTypeClick
  end
  object EditOperation: TEdit
    Left = 103
    Top = 89
    Width = 153
    Height = 21
    Color = 15000804
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnKeyDown = EditPublishingKeyDown
  end
  object ButtonOperation: TButton
    Left = 262
    Top = 89
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1087#1077#1088#1072#1094#1080#1102
    Caption = '...'
    TabOrder = 7
    OnClick = ButtonOperationClick
  end
  object DateTimePickerBeginFrom: TDateTimePicker
    Left = 105
    Top = 275
    Width = 96
    Height = 22
    Anchors = [akRight, akBottom]
    Date = 39467.616504444440000000
    Time = 39467.616504444440000000
    TabOrder = 9
  end
  object DateTimePickerBeginTo: TDateTimePicker
    Left = 235
    Top = 275
    Width = 96
    Height = 22
    Anchors = [akRight, akBottom]
    Date = 39467.616504444440000000
    Time = 39467.616504444440000000
    TabOrder = 10
  end
  object PanelPreviewBottom: TPanel
    Left = 0
    Top = 311
    Width = 369
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 12
    DesignSize = (
      369
      32)
    object ButtonExport: TButton
      Left = 183
      Top = 1
      Width = 100
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
      Enabled = False
      TabOrder = 1
      OnClick = ButtonExportClick
    end
    object ButtonCancel: TButton
      Left = 289
      Top = 1
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 2
      OnClick = ButtonCancelClick
    end
    object CheckBoxRefresh: TCheckBox
      Left = 10
      Top = 6
      Width = 167
      Height = 17
      Hint = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1103' '#1087#1077#1088#1077#1076' '#1101#1082#1089#1087#1086#1088#1090#1086#1084
      Caption = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1103
      TabOrder = 0
    end
  end
  object ButtonIssue: TButton
    Left = 337
    Top = 275
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1099#1087#1091#1089#1082
    Anchors = [akRight, akBottom]
    Caption = '...'
    TabOrder = 11
    OnClick = ButtonIssueClick
  end
  object GroupBoxPresentations: TGroupBox
    Left = 10
    Top = 116
    Width = 348
    Height = 153
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' '#1055#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1103' '
    TabOrder = 8
    object CheckListBoxPresentations: TCheckListBox
      AlignWithMargins = True
      Left = 7
      Top = 18
      Width = 334
      Height = 128
      Margins.Left = 5
      Margins.Right = 5
      Margins.Bottom = 5
      OnClickCheck = CheckListBoxPresentationsClickCheck
      Align = alClient
      ItemHeight = 16
      PopupMenu = PopupActionBar
      Style = lbOwnerDrawVariable
      TabOrder = 0
      OnDblClick = CheckListBoxPresentationsDblClick
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.rtf'
    Filter = #1060#1072#1081#1083#1099' Rtf (*.rtf)|*.rtf|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 304
    Top = 48
  end
  object PopupActionBar: TPopupActionBar
    OnPopup = PopupActionBarPopup
    Left = 154
    Top = 172
    object MenuItemCheckAll: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
      OnClick = MenuItemCheckAllClick
    end
    object MenuItemUncheckAll: TMenuItem
      Caption = #1059#1073#1088#1072#1090#1100' '#1074#1099#1073#1086#1088' '#1074#1089#1077#1093
      OnClick = MenuItemUncheckAllClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuItemChange: TMenuItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      OnClick = MenuItemChangeClick
    end
  end
end
