inherited BisSupportPasswordForm: TBisSupportPasswordForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1076#1086#1089#1090#1091#1087#1072
  ClientHeight = 82
  ClientWidth = 266
  ExplicitWidth = 272
  ExplicitHeight = 110
  PixelsPerInch = 96
  TextHeight = 13
  object LabelPassword: TLabel [0]
    Left = 16
    Top = 16
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  inherited PanelButton: TPanel
    Top = 47
    Width = 266
    TabOrder = 1
    ExplicitTop = 47
    ExplicitWidth = 266
    inherited ButtonOk: TButton
      Left = 99
      Enabled = False
      ModalResult = 1
      ExplicitLeft = 99
    end
    inherited ButtonCancel: TButton
      Left = 181
      ExplicitLeft = 181
    end
  end
  object EditPassword: TEdit
    Left = 63
    Top = 13
    Width = 186
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnChange = EditPasswordChange
  end
end