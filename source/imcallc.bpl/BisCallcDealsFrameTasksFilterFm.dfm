inherited BisCallcDealsFrameTasksFilterForm: TBisCallcDealsFrameTasksFilterForm
  Left = 453
  Top = 310
  Caption = 'BisCallcDealsFrameTasksFilterForm'
  ClientHeight = 212
  ClientWidth = 364
  Font.Name = 'Tahoma'
  ExplicitLeft = 453
  ExplicitTop = 310
  ExplicitWidth = 372
  ExplicitHeight = 239
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 174
    Width = 364
    ExplicitTop = 181
    ExplicitWidth = 286
    inherited ButtonOk: TButton
      Left = 187
      ExplicitLeft = 109
    end
    inherited ButtonCancel: TButton
      Left = 283
      ExplicitLeft = 205
    end
  end
  inherited PanelControls: TPanel
    Width = 364
    Height = 174
    ExplicitWidth = 286
    ExplicitHeight = 181
    object LabelDealNum: TLabel
      Left = 14
      Top = 15
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088' '#1076#1077#1083#1072':'
      FocusControl = EditDealNum
    end
    object LabelFirm: TLabel
      Left = 23
      Top = 42
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = #1050#1088#1077#1076#1080#1090#1086#1088':'
      FocusControl = EditFirm
    end
    object LabelSurname: TLabel
      Left = 29
      Top = 69
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = #1060#1072#1084#1080#1083#1080#1103':'
      FocusControl = EditSurname
    end
    object LabelName: TLabel
      Left = 214
      Top = 69
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = #1048#1084#1103':'
      FocusControl = EditName
    end
    object LabelPatronymic: TLabel
      Left = 24
      Top = 96
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = #1054#1090#1095#1077#1089#1090#1074#1086':'
      FocusControl = EditPatronymic
    end
    object LabelAccountNum: TLabel
      Left = 10
      Top = 123
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = #1053#1086#1084#1077#1088' '#1089#1095#1077#1090#1072':'
      FocusControl = EditAccountNum
    end
    object LabelLastResult: TLabel
      Left = 20
      Top = 150
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
      FocusControl = EditLastResult
    end
    object EditDealNum: TEdit
      Left = 83
      Top = 12
      Width = 72
      Height = 21
      TabOrder = 0
    end
    object EditFirm: TEdit
      Left = 83
      Top = 39
      Width = 270
      Height = 21
      TabOrder = 1
    end
    object EditSurname: TEdit
      Left = 83
      Top = 66
      Width = 120
      Height = 21
      TabOrder = 2
    end
    object EditName: TEdit
      Left = 243
      Top = 66
      Width = 110
      Height = 21
      TabOrder = 3
    end
    object EditPatronymic: TEdit
      Left = 83
      Top = 93
      Width = 270
      Height = 21
      TabOrder = 4
    end
    object EditAccountNum: TEdit
      Left = 83
      Top = 120
      Width = 222
      Height = 21
      TabOrder = 5
    end
    object EditLastResult: TEdit
      Left = 83
      Top = 147
      Width = 222
      Height = 21
      TabOrder = 6
    end
  end
end
