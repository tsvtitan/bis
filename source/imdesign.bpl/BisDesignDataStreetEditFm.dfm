inherited BisDesignDataStreetEditForm: TBisDesignDataStreetEditForm
  Left = 513
  Top = 212
  Caption = 'BisDesignDataStreetEditForm'
  ClientHeight = 128
  ClientWidth = 393
  ExplicitWidth = 401
  ExplicitHeight = 162
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 90
    Width = 393
    ExplicitTop = 90
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
    Height = 90
    ExplicitWidth = 393
    ExplicitHeight = 90
    object LabelName: TLabel
      Left = 35
      Top = 40
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      FocusControl = EditName
    end
    object LabelPrefix: TLabel
      Left = 64
      Top = 13
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1077#1092#1080#1082#1089':'
      FocusControl = EditPrefix
    end
    object LabelLocality: TLabel
      Left = 13
      Top = 67
      Width = 99
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090':'
      FocusControl = EditLocality
    end
    object EditName: TEdit
      Left = 118
      Top = 37
      Width = 263
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object EditPrefix: TEdit
      Left = 118
      Top = 10
      Width = 94
      Height = 21
      TabOrder = 0
    end
    object EditLocality: TEdit
      Left = 118
      Top = 64
      Width = 236
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonLocality: TButton
      Left = 360
      Top = 64
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1085#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 3
    end
  end
end