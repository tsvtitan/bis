inherited BisDesignDataSessionsForm: TBisDesignDataSessionsForm
  Left = 500
  Top = 245
  Caption = #1057#1077#1089#1089#1080#1080
  ClientHeight = 416
  ClientWidth = 542
  Position = poDesigned
  ExplicitWidth = 550
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 397
    Width = 542
    ExplicitTop = 397
    ExplicitWidth = 542
  end
  inherited PanelFrame: TPanel
    Width = 542
    Height = 239
    ExplicitWidth = 542
    ExplicitHeight = 239
  end
  inherited PanelButton: TPanel
    Top = 359
    Width = 542
    TabOrder = 2
    ExplicitTop = 359
    ExplicitWidth = 542
    inherited ButtonOk: TButton
      Left = 364
      ExplicitLeft = 364
    end
    inherited ButtonCancel: TButton
      Left = 459
      ExplicitLeft = 459
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 239
    Width = 542
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 536
      Height = 114
      Align = alClient
      Caption = ' '#1047#1072#1087#1088#1086#1089' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 532
        Height = 97
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoQueryText: TDBMemo
          Left = 5
          Top = 5
          Width = 522
          Height = 87
          Align = alClient
          Color = clBtnFace
          DataField = 'QUERY_TEXT'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
