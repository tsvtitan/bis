inherited BisTaxiRouteHistoryFrame: TBisTaxiRouteHistoryFrame
  AlignWithMargins = False
  Width = 474
  Height = 183
  ExplicitWidth = 474
  ExplicitHeight = 183
  inherited PanelData: TPanel
    AlignWithMargins = False
    Top = 26
    Width = 474
    Height = 157
    ExplicitTop = 26
    ExplicitWidth = 474
    ExplicitHeight = 154
    inherited GridPattern: TDBGrid
      Width = 474
      Height = 157
    end
  end
  inherited ControlBar: TControlBar
    Width = 474
    Visible = False
    ExplicitWidth = 474
    inherited LabelCounter: TLabel
      Visible = True
    end
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
    inherited ActionRefresh: TAction
      Visible = False
    end
    inherited ActionExport: TAction
      Visible = False
    end
    inherited ActionFilter: TAction
      Visible = False
    end
    inherited ActionView: TAction
      Visible = False
    end
    inherited ActionInsert: TAction
      Visible = False
    end
    inherited ActionDuplicate: TAction
      Visible = False
    end
    inherited ActionUpdate: TAction
      Visible = False
    end
    inherited ActionDelete: TAction
      Visible = False
    end
    object ActionAddress: TAction
      Caption = #1040#1076#1088#1077#1089' '#1087#1086#1076#1072#1095#1080
      OnExecute = ActionAddressExecute
      OnUpdate = ActionAddressUpdate
    end
    object ActionRoute: TAction
      Caption = #1052#1072#1088#1096#1088#1091#1090
      OnExecute = ActionRouteExecute
      OnUpdate = ActionRouteUpdate
    end
  end
  inherited Popup: TPopupActionBar
    object MenuItemAddress: TMenuItem [0]
      Action = ActionAddress
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1072#1076#1088#1077#1089' '#1087#1086#1076#1072#1095#1080
    end
    object MenuItemRoute: TMenuItem [1]
      Action = ActionRoute
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1084#1072#1088#1096#1088#1091#1090
    end
    object N1: TMenuItem [2]
      Caption = '-'
    end
  end
end
