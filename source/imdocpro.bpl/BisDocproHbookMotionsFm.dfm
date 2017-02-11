inherited BisDocproHbookMotionsForm: TBisDocproHbookMotionsForm
  Left = 485
  Top = 245
  Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
  ClientHeight = 373
  ClientWidth = 622
  ExplicitLeft = 485
  ExplicitTop = 245
  ExplicitWidth = 630
  ExplicitHeight = 400
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 354
    Width = 622
    ExplicitTop = 304
    ExplicitWidth = 442
  end
  inherited PanelFrame: TPanel
    Width = 622
    Height = 234
    ExplicitWidth = 442
    ExplicitHeight = 168
  end
  inherited PanelButton: TPanel
    Top = 316
    Width = 622
    TabOrder = 2
    ExplicitTop = 266
    ExplicitWidth = 442
    inherited ButtonOk: TButton
      Left = 446
      ExplicitLeft = 266
    end
    inherited ButtonCancel: TButton
      Left = 542
      ExplicitLeft = 362
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 234
    Width = 622
    Height = 82
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    ExplicitTop = 184
    ExplicitWidth = 527
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 616
      Height = 76
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      ExplicitWidth = 521
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 612
        Height = 59
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        ExplicitWidth = 517
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 602
          Height = 49
          Align = alClient
          Color = clBtnFace
          DataField = 'DESCRIPTION'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 507
        end
      end
    end
  end
end
