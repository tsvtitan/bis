inherited BisKrieltDataServiceEditForm: TBisKrieltDataServiceEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataServiceEditForm'
  ClientHeight = 197
  ClientWidth = 297
  ExplicitWidth = 305
  ExplicitHeight = 231
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 159
    Width = 297
    ExplicitTop = 159
    ExplicitWidth = 297
    inherited ButtonOk: TButton
      Left = 118
      ExplicitLeft = 118
    end
    inherited ButtonCancel: TButton
      Left = 215
      ExplicitLeft = 215
    end
  end
  inherited PanelControls: TPanel
    Width = 297
    Height = 159
    ExplicitWidth = 297
    ExplicitHeight = 159
    object LabelName: TLabel
      Left = 11
      Top = 16
      Width = 77
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
      Left = 40
      Top = 138
      Width = 48
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
