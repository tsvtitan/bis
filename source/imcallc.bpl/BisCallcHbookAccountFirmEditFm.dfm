inherited BisCallcHbookAccountFirmEditForm: TBisCallcHbookAccountFirmEditForm
  Left = 513
  Top = 212
  Caption = 'BisCallcHbookAccountFirmEditForm'
  ClientHeight = 103
  ClientWidth = 304
  ExplicitLeft = 513
  ExplicitTop = 212
  ExplicitWidth = 312
  ExplicitHeight = 130
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 65
    Width = 304
    ExplicitTop = 197
    ExplicitWidth = 495
    inherited ButtonOk: TButton
      Left = 127
      ExplicitLeft = 318
    end
    inherited ButtonCancel: TButton
      Left = 224
      ExplicitLeft = 415
    end
  end
  inherited PanelControls: TPanel
    Width = 304
    Height = 65
    ExplicitTop = 1
    ExplicitWidth = 424
    ExplicitHeight = 348
    object LabelAccount: TLabel
      Left = 8
      Top = 13
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = #1059#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100':'
      FocusControl = EditAccount
    end
    object LabelFirm: TLabel
      Left = 22
      Top = 40
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
      FocusControl = EditFirm
    end
    object EditAccount: TEdit
      Left = 100
      Top = 10
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object ButtonAccount: TButton
      Left = 274
      Top = 10
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100
      Caption = '...'
      TabOrder = 1
    end
    object EditFirm: TEdit
      Left = 100
      Top = 37
      Width = 168
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonFirm: TButton
      Left = 274
      Top = 37
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1102
      Caption = '...'
      TabOrder = 3
    end
  end
end