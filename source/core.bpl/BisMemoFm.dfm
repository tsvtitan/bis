inherited BisMemoForm: TBisMemoForm
  Left = 461
  Top = 264
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1058#1077#1082#1089#1090
  ClientHeight = 416
  ClientWidth = 542
  Constraints.MinHeight = 450
  Constraints.MinWidth = 550
  ExplicitWidth = 550
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 381
    Width = 542
    TabOrder = 1
    ExplicitTop = 338
    ExplicitWidth = 506
    inherited ButtonOk: TButton
      Left = 378
      ModalResult = 1
      TabOrder = 4
      ExplicitLeft = 342
    end
    inherited ButtonCancel: TButton
      Left = 459
      TabOrder = 5
      ExplicitLeft = 423
    end
    object ButtonLoad: TButton
      Left = 8
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 0
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 89
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 1
      OnClick = ButtonSaveClick
    end
    object ButtonFont: TButton
      Left = 170
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1064#1088#1080#1092#1090
      TabOrder = 2
      OnClick = ButtonFontClick
    end
    object ButtonSort: TButton
      Left = 251
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1088#1103#1076#1086#1082
      TabOrder = 3
      OnClick = ButtonSortClick
    end
  end
  object PanelMemo: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 381
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    ExplicitWidth = 506
    ExplicitHeight = 338
  end
  object OpenTextFileDialog: TOpenTextFileDialog
    Options = [ofEnableSizing]
    Left = 80
    Top = 16
  end
  object SaveTextFileDialog: TSaveTextFileDialog
    DefaultExt = 'txt'
    Options = [ofEnableSizing]
    Left = 208
    Top = 16
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 136
    Top = 80
  end
end
