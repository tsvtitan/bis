inherited BisDesignDataLocalityEditForm: TBisDesignDataLocalityEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataLocalityEditForm'
  ClientHeight = 101
  ClientWidth = 300
  ExplicitWidth = 308
  ExplicitHeight = 135
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 63
    Width = 300
    ExplicitTop = 63
    ExplicitWidth = 300
    inherited ButtonOk: TButton
      Left = 121
      ExplicitLeft = 121
    end
    inherited ButtonCancel: TButton
      Left = 217
      ExplicitLeft = 217
    end
  end
  inherited PanelControls: TPanel
    Width = 300
    Height = 63
    ExplicitWidth = 300
    ExplicitHeight = 63
    object LabelName: TLabel
      Left = 16
      Top = 40
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelPrefix: TLabel
      Left = 45
      Top = 13
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1077#1092#1080#1082#1089':'
      FocusControl = EditPrefix
    end
    object EditName: TEdit
      Left = 99
      Top = 37
      Width = 193
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Constraints.MaxWidth = 300
      TabOrder = 1
    end
    object EditPrefix: TEdit
      Left = 99
      Top = 10
      Width = 94
      Height = 21
      TabOrder = 0
    end
  end
end
