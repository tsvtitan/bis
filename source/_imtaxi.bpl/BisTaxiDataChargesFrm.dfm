inherited BisTaxiDataChargesFrame: TBisTaxiDataChargesFrame
  Width = 520
  Height = 181
  ExplicitWidth = 520
  ExplicitHeight = 181
  inherited PanelData: TPanel
    Width = 520
    Height = 152
    ExplicitWidth = 520
    ExplicitHeight = 152
    inherited GridPattern: TDBGrid
      Width = 520
      Height = 129
    end
    object PanelBottom: TPanel
      Left = 0
      Top = 129
      Width = 520
      Height = 23
      Margins.Right = 100
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object LabelSum: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 507
        Height = 17
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
        ExplicitLeft = 503
        ExplicitWidth = 7
        ExplicitHeight = 13
      end
    end
  end
  inherited ControlBar: TControlBar
    Width = 520
    ExplicitWidth = 520
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
end
