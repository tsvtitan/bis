inherited BisKrieltDataArticlesForm: TBisKrieltDataArticlesForm
  Left = 485
  Top = 245
  Caption = #1057#1090#1072#1090#1100#1080
  ClientHeight = 376
  ClientWidth = 612
  ExplicitWidth = 620
  ExplicitHeight = 410
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 357
    Width = 612
    ExplicitTop = 357
    ExplicitWidth = 612
  end
  inherited PanelFrame: TPanel
    Width = 612
    Height = 199
    ExplicitWidth = 612
    ExplicitHeight = 199
  end
  inherited PanelButton: TPanel
    Top = 319
    Width = 612
    ExplicitTop = 319
    ExplicitWidth = 612
    inherited ButtonOk: TButton
      Left = 436
      ExplicitLeft = 436
    end
    inherited ButtonCancel: TButton
      Left = 532
      ExplicitLeft = 532
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 199
    Width = 612
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 3
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 606
      Height = 114
      Align = alClient
      Caption = ' '#1042#1099#1076#1077#1088#1078#1082#1072' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 602
        Height = 97
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoExcerpt: TDBMemo
          Left = 5
          Top = 5
          Width = 592
          Height = 87
          Align = alClient
          Color = clBtnFace
          DataField = 'EXCERPT'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
