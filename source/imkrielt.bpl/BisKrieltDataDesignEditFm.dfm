inherited BisKrieltDataDesignEditForm: TBisKrieltDataDesignEditForm
  Left = 513
  Top = 212
  Caption = 'BisKrieltDataDesignEditForm'
  ClientHeight = 237
  ClientWidth = 304
  ExplicitWidth = 312
  ExplicitHeight = 271
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 199
    Width = 304
    ExplicitTop = 157
    ExplicitWidth = 304
    inherited ButtonOk: TButton
      Left = 125
      ExplicitLeft = 125
    end
    inherited ButtonCancel: TButton
      Left = 222
      ExplicitLeft = 222
    end
  end
  inherited PanelControls: TPanel
    Width = 304
    Height = 199
    ExplicitWidth = 304
    ExplicitHeight = 157
    object LabelName: TLabel
      Left = 15
      Top = 39
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelDescription: TLabel
      Left = 39
      Top = 66
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object LabelNum: TLabel
      Left = 57
      Top = 12
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088':'
      FocusControl = EditNum
    end
    object LabelCssClass: TLabel
      Left = 59
      Top = 178
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1050#1083#1072#1089#1089':'
      FocusControl = EditCssClass
    end
    object EditName: TEdit
      Left = 98
      Top = 36
      Width = 192
      Height = 21
      TabOrder = 1
    end
    object MemoDescription: TMemo
      Left = 98
      Top = 63
      Width = 192
      Height = 106
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 2
    end
    object EditNum: TEdit
      Left = 98
      Top = 9
      Width = 72
      Height = 21
      TabOrder = 0
    end
    object EditCssClass: TEdit
      Left = 98
      Top = 175
      Width = 192
      Height = 21
      Anchors = [akRight, akBottom]
      TabOrder = 3
    end
  end
end
