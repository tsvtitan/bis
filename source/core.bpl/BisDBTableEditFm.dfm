inherited BisDBTableEditForm: TBisDBTableEditForm
  Left = 424
  Top = 218
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1090#1072#1073#1083#1080#1094
  ClientHeight = 323
  ClientWidth = 602
  Constraints.MinHeight = 348
  Constraints.MinWidth = 310
  Position = poScreenCenter
  ExplicitWidth = 608
  ExplicitHeight = 348
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 286
    Width = 602
    Height = 37
    TabOrder = 1
    ExplicitTop = 286
    ExplicitWidth = 602
    ExplicitHeight = 37
    inherited ButtonOk: TButton
      Left = 440
      Top = 6
      OnClick = ButtonOkClick
      ExplicitLeft = 440
      ExplicitTop = 6
    end
    inherited ButtonCancel: TButton
      Left = 521
      Top = 6
      ExplicitLeft = 521
      ExplicitTop = 6
    end
    object ButtonLoad: TButton
      Left = 6
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      TabOrder = 2
      OnClick = ButtonLoadClick
    end
    object ButtonSave: TButton
      Left = 88
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 3
      OnClick = ButtonSaveClick
    end
    object ButtonClear: TButton
      Left = 170
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 4
      OnClick = ButtonClearClick
    end
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 286
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object DBGrid: TDBGrid
      Left = 3
      Top = 3
      Width = 596
      Height = 280
      Align = alClient
      DataSource = DataSource
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = DBGridDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'NAME'
          Title.Caption = #1048#1084#1103' '#1087#1086#1083#1103
          Width = 170
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'WIDTH'
          Title.Caption = #1064#1080#1088#1080#1085#1072
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DATA_TYPE'
          Title.Caption = #1058#1080#1087' '#1076#1072#1085#1085#1099#1093
          Width = 85
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SIZE'
          Title.Caption = #1056#1072#1079#1084#1077#1088
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRECISION'
          Title.Caption = #1058#1086#1095#1085#1086#1089#1090#1100
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPTION'
          Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
          Width = 150
          Visible = True
        end>
    end
  end
  object DataSource: TDataSource
    Left = 64
    Top = 80
  end
  object OpenDialog: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 72
    Top = 160
  end
  object SaveDialog: TSaveDialog
    Filter = 'All files (*.*)|*.*'
    Options = [ofEnableSizing]
    Left = 144
    Top = 160
  end
end
