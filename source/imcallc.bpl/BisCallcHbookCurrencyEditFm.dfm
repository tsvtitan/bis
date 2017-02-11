inherited BisCallcHbookCurrencyEditForm: TBisCallcHbookCurrencyEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookCurrencyEditForm'
  ClientHeight = 197
  ClientWidth = 297
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 305
  ExplicitHeight = 224
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 159
    Width = 297
    ExplicitTop = 130
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 120
      ExplicitLeft = 120
    end
    inherited ButtonCancel: TButton
      Left = 217
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 297
    Height = 159
    ExplicitWidth = 297
    ExplicitHeight = 130
    object LabelName: TLabel
      Left = 9
      Top = 16
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 35
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 41
      Top = 138
      Width = 47
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 192
      Height = 21
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 192
      Height = 89
      TabOrder = 1
    end
    object EditPriority: TEdit
      Left = 96
      Top = 135
      Width = 73
      Height = 21
      TabOrder = 2
    end
  end
end
