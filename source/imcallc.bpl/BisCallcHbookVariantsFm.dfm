inherited BiCallcHbookVariantsForm: TBiCallcHbookVariantsForm
  Left = 485
  Top = 245
  Caption = #1042#1072#1088#1080#1072#1085#1090#1099' '#1088#1072#1089#1095#1077#1090#1086#1074
  ClientHeight = 323
  ClientWidth = 442
  Constraints.MinHeight = 350
  Constraints.MinWidth = 450
  ExplicitLeft = 485
  ExplicitTop = 245
  ExplicitWidth = 450
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 304
    Width = 442
    ExplicitTop = 304
    ExplicitWidth = 442
  end
  inherited PanelFrame: TPanel
    Width = 442
    Height = 168
    ExplicitWidth = 442
    ExplicitHeight = 168
  end
  inherited PanelButton: TPanel
    Top = 266
    Width = 442
    TabOrder = 2
    ExplicitTop = 266
    ExplicitWidth = 442
    inherited ButtonOk: TButton
      Left = 266
      ExplicitLeft = 266
    end
    inherited ButtonCancel: TButton
      Left = 362
      ExplicitLeft = 362
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 168
    Width = 442
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 436
      Height = 92
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 432
        Height = 75
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 422
          Height = 65
          Align = alClient
          Color = clBtnFace
          DataField = 'DESCRIPTION'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
