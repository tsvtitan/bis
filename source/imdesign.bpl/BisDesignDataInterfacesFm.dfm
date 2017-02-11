inherited BisDesignDataInterfacesForm: TBisDesignDataInterfacesForm
  Left = 479
  Top = 247
  Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089#1099
  ClientHeight = 343
  ClientWidth = 472
  ExplicitWidth = 480
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 324
    Width = 472
    ExplicitTop = 324
    ExplicitWidth = 462
  end
  inherited PanelFrame: TPanel
    Width = 472
    Height = 188
    ExplicitWidth = 462
    ExplicitHeight = 188
  end
  inherited PanelButton: TPanel
    Top = 286
    Width = 472
    TabOrder = 2
    ExplicitTop = 286
    ExplicitWidth = 462
    inherited ButtonOk: TButton
      Left = 294
      ExplicitLeft = 284
    end
    inherited ButtonCancel: TButton
      Left = 389
      ExplicitLeft = 379
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 188
    Width = 472
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    ExplicitWidth = 462
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 466
      Height = 92
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      ExplicitWidth = 456
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 462
        Height = 75
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        ExplicitWidth = 452
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 452
          Height = 65
          Align = alClient
          Color = clBtnFace
          DataField = 'DESCRIPTION'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 442
        end
      end
    end
  end
end
