inherited BisTaxiDataDriverWeekScheduleFrame: TBisTaxiDataDriverWeekScheduleFrame
  Height = 186
  ParentFont = False
  ExplicitHeight = 186
  inherited PanelData: TPanel
    Height = 157
    ExplicitHeight = 157
    inherited GridPattern: TDBGrid
      Height = 134
    end
    object PanelBottom: TPanel
      Left = 0
      Top = 134
      Width = 450
      Height = 23
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object LabelSum: TLabel
        AlignWithMargins = True
        Left = 433
        Top = 3
        Width = 7
        Height = 13
        Margins.Right = 10
        Align = alClient
        Alignment = taRightJustify
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
    end
  end
  inherited ControlBar: TControlBar
    inherited ToolBarRefresh: TToolBar
      inherited ToolButtonRefresh: TToolButton
        ExplicitWidth = 36
      end
      inherited ToolButtonFilter: TToolButton
        ExplicitWidth = 36
      end
      inherited ToolButtonReport: TToolButton
        ExplicitWidth = 36
      end
    end
    inherited ToolBarEdit: TToolBar
      Visible = False
      inherited ToolButtonInsert: TToolButton
        ExplicitWidth = 36
      end
    end
  end
  inherited ActionList: TActionList
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
  end
end
