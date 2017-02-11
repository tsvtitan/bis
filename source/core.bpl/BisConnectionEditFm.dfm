inherited BisConnectionEditForm: TBisConnectionEditForm
  Left = 400
  Top = 290
  ActiveControl = DBGrid
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1081
  ClientHeight = 337
  ClientWidth = 422
  KeyPreview = True
  OnKeyDown = FormKeyDown
  ExplicitWidth = 430
  ExplicitHeight = 371
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButton: TPanel
    Top = 300
    Width = 422
    Height = 37
    TabOrder = 3
    ExplicitTop = 300
    ExplicitWidth = 422
    ExplicitHeight = 37
    inherited ButtonOk: TButton
      Left = 259
      Top = 5
      TabOrder = 1
      OnClick = ButtonOkClick
      ExplicitLeft = 259
      ExplicitTop = 5
    end
    inherited ButtonCancel: TButton
      Left = 340
      Top = 5
      TabOrder = 2
      ExplicitLeft = 340
      ExplicitTop = 5
    end
    object ButtonSave: TButton
      Left = 8
      Top = 5
      Width = 75
      Height = 25
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 0
      Visible = False
      OnClick = ButtonSaveClick
    end
  end
  object DBGrid: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 35
    Width = 416
    Height = 151
    Align = alClient
    DataSource = DataSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGridDrawColumnCell
    OnKeyDown = DBGridKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        ReadOnly = True
        Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRIPTION'
        ReadOnly = True
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 220
        Visible = True
      end>
  end
  object GroupBoxValue: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 192
    Width = 416
    Height = 105
    Align = alBottom
    Caption = ' '#1047#1085#1072#1095#1077#1085#1080#1077' '
    TabOrder = 2
    object DBMemoValue: TDBMemo
      AlignWithMargins = True
      Left = 7
      Top = 20
      Width = 402
      Height = 78
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      DataField = 'VALUE'
      DataSource = DataSource
      TabOrder = 0
    end
  end
  object PanelConnections: TPanel
    Left = 0
    Top = 0
    Width = 422
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      422
      32)
    object LabelConnection: TLabel
      Left = 17
      Top = 10
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077':'
      FocusControl = ComboBoxConnections
    end
    object ComboBoxConnections: TComboBox
      Left = 89
      Top = 7
      Width = 203
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 0
      TabOrder = 0
      OnChange = ComboBoxConnectionsChange
    end
  end
  object DataSource: TDataSource
    Left = 56
    Top = 56
  end
end
