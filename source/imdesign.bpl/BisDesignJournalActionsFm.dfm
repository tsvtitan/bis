inherited BisDesignJournalActionsForm: TBisDesignJournalActionsForm
  Left = 365
  Top = 201
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1077#1081#1089#1090#1074#1080#1081
  ClientHeight = 423
  ClientWidth = 632
  Constraints.MinHeight = 450
  Constraints.MinWidth = 640
  ExplicitWidth = 640
  ExplicitHeight = 457
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 404
    Width = 632
    ExplicitTop = 404
    ExplicitWidth = 632
  end
  inherited PanelFrame: TPanel
    Width = 632
    Height = 246
    ExplicitWidth = 632
    ExplicitHeight = 246
  end
  inherited PanelButton: TPanel
    Top = 366
    Width = 632
    TabOrder = 2
    ExplicitTop = 366
    ExplicitWidth = 632
    inherited ButtonOk: TButton
      Left = 454
      ExplicitLeft = 454
    end
    inherited ButtonCancel: TButton
      Left = 549
      ExplicitLeft = 549
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 246
    Width = 632
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 626
      Height = 114
      Align = alClient
      Caption = ' '#1047#1085#1072#1095#1077#1085#1080#1077' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 622
        Height = 97
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoValue: TDBMemo
          Left = 5
          Top = 5
          Width = 612
          Height = 87
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
