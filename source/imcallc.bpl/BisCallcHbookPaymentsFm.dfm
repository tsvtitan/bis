inherited BiCallcHbookPaymentsForm: TBiCallcHbookPaymentsForm
  Left = 485
  Top = 245
  Caption = #1055#1083#1072#1090#1077#1078#1080
  ClientHeight = 323
  ClientWidth = 492
  Constraints.MinHeight = 350
  Constraints.MinWidth = 500
  ExplicitLeft = 485
  ExplicitTop = 245
  ExplicitWidth = 500
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 304
    Width = 492
    ExplicitTop = 304
    ExplicitWidth = 492
  end
  inherited PanelFrame: TPanel
    Width = 492
    Height = 168
    ExplicitWidth = 492
    ExplicitHeight = 168
  end
  inherited PanelButton: TPanel
    Top = 266
    Width = 492
    TabOrder = 2
    ExplicitTop = 266
    ExplicitWidth = 492
    inherited ButtonOk: TButton
      Left = 316
      ExplicitLeft = 316
    end
    inherited ButtonCancel: TButton
      Left = 412
      ExplicitLeft = 412
    end
  end
  object PanelControls: TPanel [3]
    Left = 0
    Top = 168
    Width = 492
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object GroupBoxControls: TGroupBox
      Left = 3
      Top = 3
      Width = 486
      Height = 92
      Align = alClient
      Caption = ' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '
      TabOrder = 0
      object PanelDescription: TPanel
        Left = 2
        Top = 15
        Width = 482
        Height = 75
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object DBMemoDescription: TDBMemo
          Left = 5
          Top = 5
          Width = 472
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
