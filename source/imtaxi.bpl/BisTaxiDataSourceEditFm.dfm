inherited BisTaxiDataSourceEditForm: TBisTaxiDataSourceEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataSourceEditForm'
  ClientHeight = 194
  ClientWidth = 303
  ExplicitWidth = 311
  ExplicitHeight = 228
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 156
    Width = 303
    ExplicitTop = 156
    ExplicitWidth = 303
    inherited ButtonOk: TButton
      Left = 124
      ExplicitLeft = 124
    end
    inherited ButtonCancel: TButton
      Left = 220
      ExplicitLeft = 220
    end
  end
  inherited PanelControls: TPanel
    Width = 303
    Height = 156
    ExplicitWidth = 303
    ExplicitHeight = 156
    object LabelName: TLabel
      Left = 14
      Top = 15
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 38
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelPriority: TLabel
      Left = 43
      Top = 130
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 192
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 192
      Height = 82
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object EditPriority: TEdit
      Left = 97
      Top = 127
      Width = 54
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 2
    end
    object CheckBoxVisible: TCheckBox
      Left = 157
      Top = 129
      Width = 97
      Height = 17
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      TabOrder = 3
    end
  end
end
