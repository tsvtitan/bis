inherited BisFastReportEditorForm: TBisFastReportEditorForm
  Caption = 'BisFastReportEditorForm'
  ClientHeight = 373
  ClientWidth = 552
  Constraints.MinHeight = 400
  Constraints.MinWidth = 550
  ExplicitWidth = 560
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TStatusBar
    Top = 354
    Width = 552
    ExplicitTop = 354
    ExplicitWidth = 552
  end
  inherited PanelReport: TPanel
    Top = 24
    Width = 552
    Height = 330
    ParentShowHint = False
    ExplicitTop = 24
    ExplicitWidth = 552
    ExplicitHeight = 330
  end
  object ActionMainMenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 552
    Height = 24
    UseSystemFont = False
    ActionManager = ActionManager
    Caption = 'ActionMainMenuBar'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    PersistentHotKeys = True
    Spacing = 0
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        ActionBar = ActionMainMenuBar
      end>
    Left = 160
    Top = 96
    StyleName = 'XP Style'
  end
end