inherited BisBallFourthRoundFrame: TBisBallFourthRoundFrame
  inherited GroupBoxBarrel: TGroupBox
    inherited PanelBurrel: TPanel
      inherited LabelSubround: TLabel
        Anchors = [akTop, akRight]
        Visible = True
      end
      inherited StringGrid: TStringGrid
        Height = 66
        ExplicitHeight = 66
      end
      inherited ComboBoxSubrounds: TComboBox
        Visible = True
      end
    end
  end
end
