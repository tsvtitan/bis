inherited BisCallcDealFrameTasksFrame: TBisCallcDealFrameTasksFrame
  inherited PanelData: TPanel
    ExplicitHeight = 124
    object Splitter: TSplitter [0]
      Left = 0
      Top = 61
      Width = 450
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      MinSize = 60
      ExplicitTop = 0
      ExplicitWidth = 80
    end
    inherited GridPattern: TDBGrid
      Height = 61
    end
    object DBMemoDescription: TDBMemo
      Left = 0
      Top = 64
      Width = 450
      Height = 60
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alBottom
      Color = clBtnFace
      Constraints.MinHeight = 60
      DataField = 'DESCRIPTION'
      DataSource = DataSource
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
end
