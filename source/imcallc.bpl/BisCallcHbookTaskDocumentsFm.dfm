inherited BiCallcHbookTaskDocumentsForm: TBiCallcHbookTaskDocumentsForm
  Left = 485
  Top = 245
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1076#1072#1085#1080#1081
  ClientHeight = 373
  ClientWidth = 592
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  ExplicitLeft = 485
  ExplicitTop = 245
  ExplicitWidth = 600
  ExplicitHeight = 400
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 354
    Width = 592
    ExplicitTop = 354
    ExplicitWidth = 592
  end
  inherited PanelFrame: TPanel
    Width = 592
    Height = 218
    ExplicitWidth = 592
    ExplicitHeight = 218
  end
  inherited PanelButton: TPanel
    Top = 316
    Width = 592
    TabOrder = 2
    ExplicitTop = 316
    ExplicitWidth = 592
    inherited ButtonOk: TButton
      Left = 416
      ExplicitLeft = 416
    end
    inherited ButtonCancel: TButton
      Left = 512
      ExplicitLeft = 512
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 218
    Width = 592
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 586
      Height = 92
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 582
        Height = 75
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 572
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
