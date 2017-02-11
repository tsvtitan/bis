inherited BisDocproHbookDocsFrame: TBisDocproHbookDocsFrame
  Height = 152
  ExplicitHeight = 152
  inherited PanelData: TPanel
    Height = 123
    ExplicitHeight = 123
    inherited GridPattern: TDBGrid
      Height = 123
    end
  end
  inherited ActionList: TActionList
    object ActionPlan: TAction
      Caption = #1055#1083#1072#1085
      Hint = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1087#1083#1072#1085
      OnExecute = ActionPlanExecute
      OnUpdate = ActionPlanUpdate
    end
  end
  inherited Popup: TPopupActionBar
    object N13: TMenuItem
      Caption = '-'
    end
    object N15: TMenuItem
      Action = ActionPlan
    end
  end
end
