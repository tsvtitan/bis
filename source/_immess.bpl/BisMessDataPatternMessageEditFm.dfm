inherited BisMessDataPatternMessageEditForm: TBisMessDataPatternMessageEditForm
  Left = 513
  Top = 212
  Caption = 'BisMessDataPatternMessageEditForm'
  ClientHeight = 189
  ClientWidth = 388
  ExplicitWidth = 396
  ExplicitHeight = 223
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 151
    Width = 388
    ExplicitTop = 156
    ExplicitWidth = 303
    inherited ButtonOk: TButton
      Left = 209
      ExplicitLeft = 124
    end
    inherited ButtonCancel: TButton
      Left = 305
      ExplicitLeft = 220
    end
  end
  inherited PanelControls: TPanel
    Width = 388
    Height = 151
    ExplicitWidth = 303
    ExplicitHeight = 156
    object LabelName: TLabel
      Left = 12
      Top = 15
      Width = 79
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelText: TLabel
      Left = 58
      Top = 43
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1077#1082#1089#1090':'
      FocusControl = MemoText
    end
    object EditName: TEdit
      Left = 97
      Top = 12
      Width = 277
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
      ExplicitWidth = 192
    end
    object MemoText: TMemo
      Left = 97
      Top = 39
      Width = 277
      Height = 101
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      ExplicitHeight = 106
    end
  end
  inherited ImageList: TImageList
    Left = 48
    Top = 88
  end
end
