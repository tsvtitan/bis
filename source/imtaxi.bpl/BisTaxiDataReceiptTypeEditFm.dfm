inherited BisTaxiDataReceiptTypeEditForm: TBisTaxiDataReceiptTypeEditForm
  Left = 513
  Top = 212
  Caption = 'BisTaxiDataReceiptTypeEditForm'
  ClientHeight = 207
  ClientWidth = 393
  ExplicitWidth = 401
  ExplicitHeight = 241
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 169
    Width = 393
    ExplicitTop = 169
    ExplicitWidth = 393
    inherited ButtonOk: TButton
      Left = 214
      ExplicitLeft = 214
    end
    inherited ButtonCancel: TButton
      Left = 310
      ExplicitLeft = 310
    end
  end
  inherited PanelControls: TPanel
    Width = 393
    Height = 169
    ExplicitWidth = 393
    ExplicitHeight = 169
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
    object LabelSum: TLabel
      Left = 56
      Top = 146
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = #1057#1091#1084#1084#1072':'
      FocusControl = EditSum
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 282
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 97
      Top = 39
      Width = 282
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
    object CheckBoxVisible: TCheckBox
      Left = 282
      Top = 145
      Width = 79
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      TabOrder = 4
    end
    object CheckBoxVirtual: TCheckBox
      Left = 178
      Top = 145
      Width = 98
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1099#1081
      TabOrder = 3
    end
  end
end
