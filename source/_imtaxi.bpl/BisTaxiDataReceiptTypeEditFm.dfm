inherited BisTaxiDataReceiptTypeEditForm: TBisTaxiDataReceiptTypeEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataReceiptTypeEditForm'
  ClientHeight = 207
  ClientWidth = 311
  ExplicitWidth = 319
  ExplicitHeight = 241
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 169
    Width = 311
    ExplicitTop = 169
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
    Height = 169
    ExplicitWidth = 311
    ExplicitHeight = 169
    object LabelName: TLabel
      Left = 12
      Top = 15
      Width = 79
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
    object LabelSum: TLabel
      Left = 54
      Top = 146
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1057#1091#1084#1084#1072':'
      FocusControl = EditSum
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
      Height = 98
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
    object EditSum: TEdit
      Left = 97
      Top = 143
      Width = 75
      Height = 21
      Anchors = [akLeft, akBottom]
      Constraints.MaxWidth = 300
      TabOrder = 2
    end
  end
end
