inherited BisDesignDataConstsForm: TBisDesignDataConstsForm
  Left = 485
  Top = 245
  Caption = #1050#1086#1085#1089#1090#1072#1085#1090#1099
  ClientHeight = 415
  ClientWidth = 584
  ExplicitWidth = 600
  ExplicitHeight = 453
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 396
    Width = 584
    ExplicitTop = 396
    ExplicitWidth = 584
  end
  inherited PanelFrame: TPanel
    Width = 584
    Height = 264
    ExplicitWidth = 584
    ExplicitHeight = 264
  end
  inherited PanelButton: TPanel
    Top = 358
    Width = 584
    ExplicitTop = 358
    ExplicitWidth = 584
    inherited ButtonOk: TButton
      Left = 406
      ExplicitLeft = 406
    end
    inherited ButtonCancel: TButton
      Left = 501
      ExplicitLeft = 501
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 264
    Width = 584
    Height = 94
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    object GroupBoxValue: TGroupBox
      Left = 3
      Top = 3
      Width = 578
      Height = 88
      Align = alClient
      Caption = ' '#1047#1085#1072#1095#1077#1085#1080#1077' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 574
        Height = 71
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoValue: TDBMemo
          Left = 5
          Top = 5
          Width = 564
          Height = 61
          Align = alClient
          Color = clBtnFace
          DataField = 'VALUE'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
