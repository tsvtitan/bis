inherited BisFotomSendForm: TBisFotomSendForm
  Left = 554
  Top = 428
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1081' '#1085#1072' '#1089#1077#1088#1074#1077#1088
  ClientHeight = 82
  ClientWidth = 329
  Font.Name = 'Tahoma'
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 335
  ExplicitHeight = 114
  PixelsPerInch = 96
  TextHeight = 13
  object LabelStatus: TLabel
    Left = 8
    Top = 6
    Width = 313
    Height = 13
    AutoSize = False
    EllipsisPosition = epEndEllipsis
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 25
    Width = 313
    Height = 16
    TabOrder = 0
  end
  object ButtonBreak: TButton
    Left = 128
    Top = 51
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1055#1088#1077#1088#1074#1072#1090#1100
    Default = True
    TabOrder = 1
    OnClick = ButtonBreakClick
  end
end
