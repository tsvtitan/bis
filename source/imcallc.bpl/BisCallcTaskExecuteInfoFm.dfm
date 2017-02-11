inherited BisTaskExecuteForm: TBisTaskExecuteForm
  Left = 501
  Top = 322
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1089#1083#1077#1076#1091#1102#1097#1080#1084' '#1079#1072#1076#1072#1085#1080#1103#1084
  ClientHeight = 171
  ClientWidth = 309
  Font.Name = 'Tahoma'
  OnCreate = FormCreate
  ExplicitLeft = 501
  ExplicitTop = 322
  ExplicitWidth = 317
  ExplicitHeight = 198
  PixelsPerInch = 96
  TextHeight = 13
  object LabelResult: TLabel [0]
    Left = 18
    Top = 19
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
    FocusControl = EditResult
  end
  object LabelAction: TLabel [1]
    Left = 22
    Top = 46
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
    FocusControl = EditAction
  end
  object LabelTaskCount: TLabel [2]
    Left = 85
    Top = 100
    Width = 109
    Height = 13
    Alignment = taRightJustify
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1076#1072#1085#1080#1081':'
    FocusControl = EditTaskCount
  end
  object LabelDate: TLabel [3]
    Left = 41
    Top = 73
    Width = 81
    Height = 13
    Alignment = taRightJustify
    Caption = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074#1080#1103':'
    FocusControl = EditDate
  end
  inherited PanelButton: TPanel
    Top = 136
    Width = 309
    TabOrder = 4
    ExplicitTop = 102
    ExplicitWidth = 309
    inherited ButtonOk: TButton
      Left = 147
      ModalResult = 1
      ExplicitLeft = 147
    end
    inherited ButtonCancel: TButton
      Left = 228
      ExplicitLeft = 228
    end
  end
  object EditResult: TEdit
    Left = 81
    Top = 16
    Width = 214
    Height = 21
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
  end
  object EditAction: TEdit
    Left = 81
    Top = 43
    Width = 214
    Height = 21
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object EditTaskCount: TEdit
    Left = 200
    Top = 97
    Width = 95
    Height = 21
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
  end
  object EditDate: TEdit
    Left = 128
    Top = 70
    Width = 167
    Height = 21
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
  end
end
