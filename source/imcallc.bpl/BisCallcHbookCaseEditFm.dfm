inherited BisCallcHbookCaseEditForm: TBisCallcHbookCaseEditForm
  Left = 477
  Top = 209
  Caption = 'BisCallcHbookCaseEditForm'
  ClientHeight = 231
  ClientWidth = 585
  ExplicitWidth = 593
  ExplicitHeight = 265
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 193
    Width = 585
    ExplicitTop = 193
    ExplicitWidth = 585
    inherited ButtonOk: TButton
      Left = 408
      TabOrder = 1
      ExplicitLeft = 408
    end
    inherited ButtonCancel: TButton
      Left = 505
      TabOrder = 2
      ExplicitLeft = 505
    end
    object ButtonBias: TButton
      Left = 10
      Top = 7
      Width = 95
      Height = 25
      Caption = #1057#1082#1083#1086#1085#1103#1090#1100' '#1074#1089#1077
      TabOrder = 0
      OnClick = ButtonBiasClick
    end
  end
  inherited PanelControls: TPanel
    Width = 585
    Height = 193
    ExplicitWidth = 585
    ExplicitHeight = 193
    object LabelSurname: TLabel
      Left = 96
      Top = 10
      Width = 52
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
    end
    object LabelName: TLabel
      Left = 252
      Top = 10
      Width = 25
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
    end
    object LabelPatronymic: TLabel
      Left = 387
      Top = 10
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
    end
    object LabelIp: TLabel
      Left = 10
      Top = 32
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1077#1085#1080#1090#1077#1083#1100#1085#1099#1081':'
      FocusControl = EditSurnameIp
    end
    object LabelRp: TLabel
      Left = 19
      Top = 59
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1085#1099#1081':'
      FocusControl = EditSurnameRp
    end
    object LabelDp: TLabel
      Left = 29
      Top = 86
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1077#1083#1100#1085#1099#1081':'
      FocusControl = EditSurnameDp
    end
    object LabelVp: TLabel
      Left = 19
      Top = 113
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = #1042#1080#1085#1080#1090#1077#1083#1100#1085#1099#1081':'
      FocusControl = EditSurnameVp
    end
    object LabelTp: TLabel
      Left = 13
      Top = 140
      Width = 77
      Height = 13
      Alignment = taRightJustify
      Caption = #1058#1074#1086#1088#1080#1090#1077#1083#1100#1085#1099#1081':'
      FocusControl = EditSurnameTp
    end
    object LabelPp: TLabel
      Left = 21
      Top = 167
      Width = 69
      Height = 13
      Alignment = taRightJustify
      Caption = #1055#1088#1077#1076#1083#1086#1078#1085#1099#1081':'
      FocusControl = EditSurnamePp
    end
    object EditSurnameIp: TEdit
      Left = 96
      Top = 29
      Width = 150
      Height = 21
      TabOrder = 0
    end
    object EditNameIp: TEdit
      Left = 252
      Top = 29
      Width = 129
      Height = 21
      TabOrder = 1
    end
    object EditPatronymicIp: TEdit
      Left = 387
      Top = 29
      Width = 165
      Height = 21
      TabOrder = 2
    end
    object EditSurnameRp: TEdit
      Left = 96
      Top = 56
      Width = 150
      Height = 21
      TabOrder = 3
    end
    object EditNameRp: TEdit
      Left = 252
      Top = 56
      Width = 129
      Height = 21
      TabOrder = 4
    end
    object EditPatronymicRp: TEdit
      Left = 387
      Top = 56
      Width = 165
      Height = 21
      TabOrder = 5
    end
    object EditSurnameDp: TEdit
      Left = 96
      Top = 83
      Width = 150
      Height = 21
      TabOrder = 7
    end
    object EditNameDp: TEdit
      Left = 252
      Top = 83
      Width = 129
      Height = 21
      TabOrder = 8
    end
    object EditPatronymicDp: TEdit
      Left = 387
      Top = 83
      Width = 165
      Height = 21
      TabOrder = 9
    end
    object EditSurnameVp: TEdit
      Left = 96
      Top = 110
      Width = 150
      Height = 21
      TabOrder = 11
    end
    object EditNameVp: TEdit
      Left = 252
      Top = 110
      Width = 129
      Height = 21
      TabOrder = 12
    end
    object EditPatronymicVp: TEdit
      Left = 387
      Top = 110
      Width = 165
      Height = 21
      TabOrder = 13
    end
    object EditSurnameTp: TEdit
      Left = 96
      Top = 137
      Width = 150
      Height = 21
      TabOrder = 15
    end
    object EditNameTp: TEdit
      Left = 252
      Top = 137
      Width = 129
      Height = 21
      TabOrder = 16
    end
    object EditPatronymicTp: TEdit
      Left = 387
      Top = 137
      Width = 165
      Height = 21
      TabOrder = 17
    end
    object EditSurnamePp: TEdit
      Left = 96
      Top = 164
      Width = 150
      Height = 21
      TabOrder = 19
    end
    object EditNamePp: TEdit
      Left = 252
      Top = 164
      Width = 129
      Height = 21
      TabOrder = 20
    end
    object EditPatronymicPp: TEdit
      Left = 387
      Top = 164
      Width = 165
      Height = 21
      TabOrder = 21
    end
    object ButtonRp: TButton
      Left = 558
      Top = 56
      Width = 21
      Height = 21
      Caption = '<'
      TabOrder = 6
      OnClick = ButtonRpClick
    end
    object ButtonDp: TButton
      Left = 558
      Top = 83
      Width = 21
      Height = 21
      Caption = '<'
      TabOrder = 10
      OnClick = ButtonDpClick
    end
    object ButtonVp: TButton
      Left = 558
      Top = 110
      Width = 21
      Height = 21
      Caption = '<'
      TabOrder = 14
      OnClick = ButtonVpClick
    end
    object ButtonTp: TButton
      Left = 558
      Top = 137
      Width = 21
      Height = 21
      Caption = '<'
      TabOrder = 18
      OnClick = ButtonTpClick
    end
    object ButtonPp: TButton
      Left = 558
      Top = 164
      Width = 21
      Height = 21
      Caption = '<'
      TabOrder = 22
      OnClick = ButtonPpClick
    end
  end
end
