inherited BisCallcHbookActionEditForm: TBisCallcHbookActionEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookActionEditForm'
  ClientHeight = 201
  ClientWidth = 297
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 305
  ExplicitHeight = 228
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 163
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
    Height = 163
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
    object LabelPurpose: TLabel
      Left = 26
      Top = 138
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
      FocusControl = ComboBoxPurpose
    end
    object EditName: TEdit
      Left = 96
      Top = 13
      Width = 192
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 192
      Height = 89
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object ComboBoxPurpose: TComboBox
      Left = 96
      Top = 135
      Width = 192
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      ItemHeight = 13
      TabOrder = 2
    end
  end
end
