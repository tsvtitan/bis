object BisOrdersForm: TBisOrdersForm
  Left = 560
  Top = 338
  BorderStyle = bsDialog
  Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
  ClientHeight = 243
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButton: TPanel
    Left = 0
    Top = 204
    Width = 342
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      342
      39)
    object ButtonCancel: TButton
      Left = 259
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = ButtonCancelClick
    end
    object ButtonOk: TButton
      Left = 177
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1054#1050
      Default = True
      TabOrder = 0
      OnClick = ButtonOkClick
    end
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 0
    Width = 342
    Height = 204
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object Bevel: TBevel
      Left = 3
      Top = 171
      Width = 336
      Height = 5
      Align = alBottom
      Shape = bsSpacer
      ExplicitTop = 156
    end
    object Grid: TDBGrid
      Left = 3
      Top = 3
      Width = 336
      Height = 168
      Align = alClient
      DataSource = DataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'NAME'
          Title.Caption = #1048#1084#1103' '#1087#1086#1083#1103
          Width = 190
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TYPE'
          Title.Caption = #1058#1080#1087' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080
          Width = 100
          Visible = True
        end>
    end
    object DBNavigator: TDBNavigator
      Left = 3
      Top = 176
      Width = 336
      Height = 25
      DataSource = DataSource
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
      Align = alBottom
      Flat = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object DataSource: TDataSource
    Left = 90
    Top = 67
  end
end
