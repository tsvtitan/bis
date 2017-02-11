inherited BisTaxiDataDriverTypeEditForm: TBisTaxiDataDriverTypeEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataDriverTypeEditForm'
  ClientHeight = 192
  ClientWidth = 311
  ExplicitWidth = 319
  ExplicitHeight = 226
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 154
    Width = 311
    ExplicitTop = 247
    ExplicitWidth = 311
    inherited ButtonOk: TButton
      Left = 132
      ExplicitLeft = 132
    end
    inherited ButtonCancel: TButton
      Left = 228
      ExplicitLeft = 228
    end
  end
  inherited PanelControls: TPanel
    Width = 311
    Height = 154
    ExplicitTop = -1
    ExplicitWidth = 311
    ExplicitHeight = 247
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
      Top = 124
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082':'
      FocusControl = EditPriority
      ExplicitTop = 217
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 200
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 200
      Height = 76
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      ExplicitHeight = 169
    end
    object EditPriority: TEdit
      Left = 97
      Top = 121
      Width = 54
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 2
      ExplicitTop = 214
    end
    object CheckBoxVisible: TCheckBox
      Left = 157
      Top = 123
      Width = 97
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      TabOrder = 3
      ExplicitTop = 216
    end
  end
end
