inherited BisDocproHbookDocEditForm: TBisDocproHbookDocEditForm
  Left = 514
  Top = 285
  Caption = 'BisDocproHbookDocEditForm'
  ClientHeight = 227
  ClientWidth = 327
  ExplicitLeft = 514
  ExplicitTop = 285
  ExplicitWidth = 335
  ExplicitHeight = 254
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 189
    Width = 327
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 150
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 247
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 327
    Height = 189
    ExplicitWidth = 297
    ExplicitHeight = 130
    object LabelName: TLabel
      Left = 11
      Top = 40
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 37
      Top = 94
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelView: TLabel
      Left = 11
      Top = 67
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
      FocusControl = EditView
    end
    object LabelNum: TLabel
      Left = 53
      Top = 13
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditNum
    end
    object LabelDateDoc: TLabel
      Left = 193
      Top = 13
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072':'
      FocusControl = DateTimePickerDateDoc
    end
    object EditName: TEdit
      Left = 96
      Top = 37
      Width = 220
      Height = 21
      TabOrder = 2
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 91
      Width = 220
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 5
    end
    object EditView: TEdit
      Left = 96
      Top = 64
      Width = 193
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
    end
    object ButtonView: TButton
      Left = 295
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Caption = '...'
      TabOrder = 4
    end
    object EditNum: TEdit
      Left = 96
      Top = 10
      Width = 88
      Height = 21
      MaxLength = 100
      TabOrder = 0
    end
    object DateTimePickerDateDoc: TDateTimePicker
      Left = 228
      Top = 10
      Width = 88
      Height = 21
      Date = 39507.457070671300000000
      Time = 39507.457070671300000000
      TabOrder = 1
    end
  end
end
