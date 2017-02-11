inherited BisDesignDataRoleEditForm: TBisDesignDataRoleEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataRoleEditForm'
  ClientHeight = 194
  ClientWidth = 328
  ExplicitWidth = 336
  ExplicitHeight = 228
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 156
    Width = 328
    ExplicitTop = 156
    ExplicitWidth = 299
    inherited ButtonOk: TButton
      Left = 148
      ExplicitLeft = 119
    end
    inherited ButtonCancel: TButton
      Left = 244
      ExplicitLeft = 215
    end
  end
  inherited PanelControls: TPanel
    Width = 328
    Height = 156
    ExplicitWidth = 299
    ExplicitHeight = 156
    object LabelUserName: TLabel
      Left = 13
      Top = 16
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditUserName
    end
    object LabelDescription: TLabel
      Left = 37
      Top = 43
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
      FocusControl = MemoDescription
    end
    object EditUserName: TEdit
      Left = 96
      Top = 13
      Width = 222
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 0
    end
    object MemoDescription: TMemo
      Left = 96
      Top = 40
      Width = 222
      Height = 110
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
  end
  inherited ImageList: TImageList
    Left = 160
  end
end
