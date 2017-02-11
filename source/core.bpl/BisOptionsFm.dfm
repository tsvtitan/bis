inherited BisOptionsForm: TBisOptionsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeable
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
  ClientHeight = 142
  ClientWidth = 262
  Position = poOwnerFormCenter
  ExplicitWidth = 270
  ExplicitHeight = 176
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 107
    Width = 262
    TabOrder = 2
    ExplicitTop = 107
    ExplicitWidth = 262
    inherited ButtonOk: TButton
      Left = 98
      ModalResult = 1
      ExplicitLeft = 98
    end
    inherited ButtonCancel: TButton
      Left = 180
      ExplicitLeft = 180
    end
  end
  object PanelFrame: TPanel
    Left = 0
    Top = 0
    Width = 262
    Height = 66
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 66
    Width = 262
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
  end
end
