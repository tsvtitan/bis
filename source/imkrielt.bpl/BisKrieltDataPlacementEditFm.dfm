inherited BisKrieltDataPlacementEditForm: TBisKrieltDataPlacementEditForm
  Left = 495
  Top = 201
  Caption = 'BisKrieltDataPlacementEditForm'
  ClientHeight = 207
  ClientWidth = 513
  ExplicitWidth = 521
  ExplicitHeight = 241
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 169
    Width = 513
    ExplicitTop = 151
    ExplicitWidth = 513
    inherited ButtonOk: TButton
      Left = 334
      ExplicitLeft = 334
    end
    inherited ButtonCancel: TButton
      Left = 431
      ExplicitLeft = 431
    end
  end
  inherited PanelControls: TPanel
    Width = 513
    Height = 169
    ExplicitWidth = 513
    ExplicitHeight = 151
    object LabelPage: TLabel
      Left = 42
      Top = 42
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1090#1088#1072#1085#1080#1094#1072':'
      FocusControl = EditPage
    end
    object LabelBanner: TLabel
      Left = 55
      Top = 15
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Caption = #1041#1072#1085#1085#1077#1088':'
      FocusControl = EditBanner
    end
    object LabelAccount: TLabel
      Left = 11
      Top = 69
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelPlace: TLabel
      Left = 370
      Top = 15
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1052#1077#1089#1090#1086':'
      FocusControl = ComboBoxPlace
    end
    object LabelDateBegin: TLabel
      Left = 336
      Top = 42
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 318
      Top = 69
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object LabelWhoplaced: TLabel
      Left = 212
      Top = 96
      Width = 78
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1050#1090#1086' '#1088#1072#1079#1084#1077#1089#1090#1080#1083':'
      FocusControl = EditWhoplaced
    end
    object LabelDatePlaced: TLabel
      Left = 231
      Top = 123
      Width = 95
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = #1044#1072#1090#1072' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1103':'
      FocusControl = DateTimePickerDatePlacedDate
    end
    object LabelPriority: TLabel
      Left = 47
      Top = 96
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelCounter: TLabel
      Left = 48
      Top = 123
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1095#1077#1090#1095#1080#1082':'
      FocusControl = EditCounter
    end
    object EditPage: TEdit
      Left = 101
      Top = 39
      Width = 176
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonPage: TButton
      Left = 283
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1089#1090#1088#1072#1085#1080#1094#1091
      Caption = '...'
      TabOrder = 3
    end
    object EditBanner: TEdit
      Left = 101
      Top = 12
      Width = 176
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonBanner: TButton
      Left = 283
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1073#1072#1085#1085#1077#1088
      Caption = '...'
      TabOrder = 1
    end
    object EditAccount: TEdit
      Left = 101
      Top = 66
      Width = 176
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object ButtonAccount: TButton
      Left = 283
      Top = 66
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' ('#1088#1086#1083#1100')'
      Caption = '...'
      TabOrder = 5
    end
    object ComboBoxPlace: TComboBox
      Left = 411
      Top = 12
      Width = 88
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 6
      Items.Strings = (
        #1085#1077#1090
        'A1'
        'A2'
        'A3'
        'A4'
        'A5'
        'A6'
        'A7'
        'A8'
        'B1'
        'B2'
        'B3'
        'B4'
        'B5'
        'B6'
        'B7'
        'B8'
        'C1'
        'C2'
        'C3'
        'C4'
        'C5'
        'C6'
        'C7'
        'C8')
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 411
      Top = 39
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 7
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 411
      Top = 66
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 8
    end
    object EditWhoplaced: TEdit
      Left = 296
      Top = 93
      Width = 176
      Height = 21
      Anchors = [akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 11
    end
    object ButtonWhoplaced: TButton
      Left = 478
      Top = 93
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 12
    end
    object DateTimePickerDatePlacedDate: TDateTimePicker
      Left = 332
      Top = 120
      Width = 88
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Checked = False
      TabOrder = 13
    end
    object DateTimePickerDatePlacedTime: TDateTimePicker
      Left = 426
      Top = 120
      Width = 73
      Height = 21
      Anchors = [akTop, akRight]
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      Kind = dtkTime
      TabOrder = 14
    end
    object EditPriority: TEdit
      Left = 101
      Top = 93
      Width = 88
      Height = 21
      TabOrder = 9
    end
    object EditCounter: TEdit
      Left = 101
      Top = 120
      Width = 88
      Height = 21
      TabOrder = 10
    end
    object CheckBoxRestricted: TCheckBox
      Left = 101
      Top = 147
      Width = 176
      Height = 17
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1074#1083#1086#1078#1077#1085#1085#1086#1089#1090#1080
      TabOrder = 15
    end
  end
  inherited ImageList: TImageList
    Left = 160
    Top = 16
  end
end
