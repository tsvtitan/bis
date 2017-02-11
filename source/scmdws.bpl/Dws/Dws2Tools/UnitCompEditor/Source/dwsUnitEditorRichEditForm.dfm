inherited fmDwsUnitEditorRichEdit: TfmDwsUnitEditorRichEdit
  Caption = 'Rich Edit'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object reEditor: TRichEdit [6]
    Left = 148
    Top = 25
    Width = 484
    Height = 324
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    PlainText = True
    PopupMenu = pPopUp
    ScrollBars = ssVertical
    TabOrder = 4
    WantTabs = True
    WordWrap = False
    OnChange = reEditorChange
    OnSelectionChange = reEditorSelectionChange
  end
  inherited alActions: TActionList
    inherited actJumpImpDecl: TAction
      OnExecute = actJumpImpDeclExecute
    end
  end
end
