inherited BisTaxiDataDriversFrame: TBisTaxiDataDriversFrame
  Width = 540
  Height = 224
  ExplicitWidth = 540
  ExplicitHeight = 224
  inherited PanelData: TPanel
    Width = 540
    Height = 195
    ExplicitWidth = 540
    ExplicitHeight = 195
    inherited GridPattern: TDBGrid
      Width = 540
      Height = 195
    end
  end
  inherited ControlBar: TControlBar
    Width = 540
    ExplicitWidth = 540
    inherited ToolBarRefresh: TToolBar
      inherited ToolButtonExport: TToolButton
        ExplicitWidth = 36
      end
      inherited ToolButtonFilter: TToolButton
        ExplicitWidth = 36
      end
    end
    inherited ToolBarEdit: TToolBar
      inherited ToolButtonInsert: TToolButton
        ExplicitWidth = 36
      end
    end
  end
  inherited ActionList: TActionList
    object ActionMessages: TAction
      Caption = #1056#1072#1089#1089#1099#1083#1082#1072
      Hint = #1056#1072#1089#1089#1099#1083#1082#1072' '#1089#1086#1086#1073#1097#1077#1085#1080#1081
      OnExecute = ActionMessagesExecute
      OnUpdate = ActionMessagesUpdate
    end
  end
  inherited Popup: TPopupActionBar
    object MenuItemMessages: TMenuItem [10]
      Action = ActionMessages
    end
    object N1: TMenuItem [11]
      Caption = '-'
    end
  end
end
