inherited BisTaxiDataDiscountEditForm: TBisTaxiDataDiscountEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataDiscountEditForm'
  ClientHeight = 220
  ClientWidth = 316
  ExplicitWidth = 324
  ExplicitHeight = 254
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 182
    Width = 316
    ExplicitTop = 182
    ExplicitWidth = 316
    inherited ButtonOk: TButton
      Left = 137
      ExplicitLeft = 137
    end
    inherited ButtonCancel: TButton
      Left = 233
      ExplicitLeft = 233
    end
  end
  inherited PanelControls: TPanel
    Width = 316
    Height = 182
    ExplicitWidth = 316
    ExplicitHeight = 182
    object LabelNum: TLabel
      Left = 64
      Top = 69
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditNum
    end
    object LabelPriority: TLabel
      Left = 51
      Top = 150
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object LabelDiscountType: TLabel
      Left = 26
      Top = 42
      Width = 73
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1080#1087' '#1076#1080#1089#1082#1086#1085#1090#1072':'
      FocusControl = EditDiscountType
    end
    object LabelClient: TLabel
      Left = 58
      Top = 15
      Width = 41
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1083#1080#1077#1085#1090':'
      FocusControl = EditClient
    end
    object LabelDateBegin: TLabel
      Left = 30
      Top = 96
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072':'
      FocusControl = DateTimePickerBegin
    end
    object LabelDateEnd: TLabel
      Left = 12
      Top = 123
      Width = 87
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
      FocusControl = DateTimePickerEnd
    end
    object EditNum: TEdit
      Left = 105
      Top = 66
      Width = 152
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 4
    end
    object EditPriority: TEdit
      Left = 105
      Top = 147
      Width = 64
      Height = 21
      Constraints.MaxWidth = 300
      TabOrder = 7
    end
    object EditDiscountType: TEdit
      Left = 105
      Top = 39
      Width = 170
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonDiscountType: TButton
      Left = 281
      Top = 39
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1090#1080#1087' '#1076#1080#1089#1082#1086#1085#1090#1072
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
    object EditClient: TEdit
      Left = 105
      Top = 12
      Width = 170
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonClient: TButton
      Left = 281
      Top = 12
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1082#1083#1080#1077#1085#1090#1072
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
    end
    object DateTimePickerBegin: TDateTimePicker
      Left = 105
      Top = 93
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 5
    end
    object DateTimePickerEnd: TDateTimePicker
      Left = 105
      Top = 120
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 6
    end
  end
  inherited ImageList: TImageList
    Left = 216
    Top = 96
  end
end