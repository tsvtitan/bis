inherited BisTaxiCallResultForm: TBisTaxiCallResultForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1074#1099#1079#1086#1074#1072
  ClientHeight = 98
  ClientWidth = 204
  ExplicitWidth = 210
  ExplicitHeight = 130
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 63
    Width = 204
    TabOrder = 1
    ExplicitTop = 63
    ExplicitWidth = 204
    inherited ButtonOk: TButton
      Left = 39
      ModalResult = 1
      ExplicitLeft = 39
    end
    inherited ButtonCancel: TButton
      Left = 121
      ExplicitLeft = 121
    end
  end
  object RadioGroupCallResults: TRadioGroup
    AlignWithMargins = True
    Left = 5
    Top = 3
    Width = 194
    Height = 55
    Margins.Left = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Caption = ' '#1056#1077#1079#1083#1100#1090#1072#1090#1099' '
    TabOrder = 0
    OnClick = RadioGroupCallResultsClick
  end
end
