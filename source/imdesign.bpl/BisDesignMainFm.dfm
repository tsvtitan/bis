inherited BisDesignMainForm: TBisDesignMainForm
  Left = 403
  Top = 159
  Caption = #1055#1088#1086#1077#1082#1090#1080#1088#1086#1074#1097#1080#1082
  ClientHeight = 561
  ClientWidth = 787
  Constraints.MinHeight = 595
  Constraints.MinWidth = 795
  ExplicitWidth = 795
  ExplicitHeight = 595
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 542
    Width = 787
    ExplicitTop = 542
    ExplicitWidth = 787
  end
  inherited PanelLogo: TPanel
    Left = 315
    Top = 327
    ExplicitLeft = 315
    ExplicitTop = 327
  end
  inherited PanelContent: TPanel
    TabOrder = 3
    inherited WebBrowser: TWebBrowser
      ControlData = {
        4C000000B21E0000060A00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126200000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  inherited ActionMainMenuBar: TActionMainMenuBar
    Width = 787
    Height = 24
    UseSystemFont = False
    ActionManager = ActionManager
    ColorMap.HighlightColor = 15660791
    ColorMap.UnusedColor = 15660791
    Font.Color = clWindowText
    ExplicitWidth = 787
    ExplicitHeight = 24
  end
  object ControlBar: TControlBar [4]
    Left = 0
    Top = 24
    Width = 787
    Height = 26
    Align = alTop
    AutoSize = True
    BevelEdges = []
    Color = clBtnFace
    DrawingStyle = dsGradient
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        ActionBar = ActionMainMenuBar
      end>
    Images = ImageListMenu
    Left = 104
    Top = 152
    StyleName = 'XP Style'
    object ActionFileExit: TAction
      Caption = #1042#1099#1093#1086#1076
      Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnExecute = ActionFileExitExecute
    end
    object ActionWindowsCascade: TAction
      Caption = #1050#1072#1089#1082#1072#1076#1086#1084
      Hint = #1056#1072#1089#1087#1086#1083#1086#1078#1080#1090#1100' '#1086#1082#1085#1072' '#1082#1072#1089#1082#1072#1076#1086#1084
      OnExecute = ActionWindowsCascadeExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
    object ActionWindowsVertical: TAction
      Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086
      Hint = #1056#1072#1089#1087#1086#1083#1086#1078#1080#1090#1100' '#1086#1082#1085#1072' '#1074#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086
      OnExecute = ActionWindowsVerticalExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
    object ActionWindowsHorizontal: TAction
      Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086
      Hint = #1056#1072#1089#1087#1086#1083#1086#1078#1080#1090#1100' '#1086#1082#1085#1072' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086
      OnExecute = ActionWindowsHorizontalExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
    object ActionWindowsCloseAll: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077' '#1086#1082#1085#1072
      OnExecute = ActionWindowsCloseAllExecute
      OnUpdate = ActionWindowsCloseAllUpdate
    end
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 240
    Top = 280
  end
end
