inherited BisDataForm: TBisDataForm
  Left = 603
  Top = 189
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
  ClientHeight = 282
  ClientWidth = 439
  KeyPreview = True
  ExplicitWidth = 455
  ExplicitHeight = 320
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 263
    Width = 439
    Height = 19
    Panels = <
      item
        Width = 120
      end
      item
        Width = 50
      end>
  end
  object PanelFrame: TPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 225
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PanelButton: TPanel
    Left = 0
    Top = 225
    Width = 439
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    DesignSize = (
      439
      38)
    object ButtonOk: TButton
      Left = 260
      Top = 5
      Width = 90
      Height = 25
      Action = ActionOk
      Anchors = [akRight, akBottom]
      Default = True
      TabOrder = 0
    end
    object ButtonCancel: TButton
      Left = 356
      Top = 5
      Width = 75
      Height = 25
      Action = ActionClose
      Anchors = [akRight, akBottom]
      Cancel = True
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Left = 48
    Top = 72
    object ActionOk: TAction
      Caption = #1042#1099#1073#1088#1072#1090#1100
      ShortCut = 13
      OnExecute = ActionOkExecute
      OnUpdate = ActionOkUpdate
    end
    object ActionClose: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      OnExecute = ActionCloseExecute
    end
  end
end
