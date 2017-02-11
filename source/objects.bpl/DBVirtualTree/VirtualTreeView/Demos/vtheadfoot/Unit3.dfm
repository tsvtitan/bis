object Form3: TForm3
  Left = 369
  Top = 249
  Width = 453
  Height = 255
  Caption = 'DesignTime'
  Color = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object VirtualGHFStringTree1: TVirtualGHFStringTree
    Left = 0
    Top = 24
    Width = 433
    Height = 161
    BorderStyle = bsNone
    DefaultNodeHeight = 13
    Header.AutoSizeIndex = 0
    Header.Columns = <
      item
        Alignment = taLeftJustify
        ImageIndex = -1
        Layout = blGlyphLeft
        MaxWidth = 60
        Position = 0
        Width = 50
        WideText = 'Col1'
      end
      item
        Alignment = taLeftJustify
        ImageIndex = -1
        Layout = blGlyphLeft
        MaxWidth = 60
        Position = 1
        Width = 50
        WideText = 'Col2'
      end
      item
        Alignment = taLeftJustify
        ImageIndex = -1
        Layout = blGlyphLeft
        Position = 2
        Tag = 1
        Width = 50
        WideText = 'Col3'
      end
      item
        Alignment = taLeftJustify
        ImageIndex = -1
        Layout = blGlyphLeft
        Position = 3
        Tag = 1
        Width = 50
        WideText = 'Col4'
      end
      item
        Alignment = taLeftJustify
        ImageIndex = -1
        Layout = blGlyphLeft
        Position = 4
        Tag = 1
        Width = 50
        WideText = 'Col5'
      end>
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 34
    Header.Options = [hoColumnResize, hoVisible]
    Header.Style = hsThickButtons
    HintAnimation = hatNone
    HintMode = hmDefault
    IncrementalSearchDirection = sdForward
    RootNodeCount = 20
    TabOrder = 0
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Footer = VirtualGHFStringTree1_Footer
    GroupHeader = VirtualGHFStringTree1_GroupHeader
    WideDefaultText = 'Node'
  end
  object VirtualGHFStringTree1_Footer: THeaderControl
    Left = 0
    Top = 185
    Width = 433
    Height = 34
    Align = alNone
    DragReorder = False
    FullDrag = False
    Sections = <
      item
        ImageIndex = -1
        MaxWidth = 60
        MinWidth = 10
        Text = 'Avg1'
        Width = 50
      end
      item
        ImageIndex = -1
        MaxWidth = 60
        MinWidth = 10
        Text = 'Avg2'
        Width = 50
      end
      item
        ImageIndex = -1
        MinWidth = 10
        Text = 'Avg3'
        Width = 50
      end
      item
        ImageIndex = -1
        MinWidth = 10
        Text = 'Avg4'
        Width = 50
      end
      item
        ImageIndex = -1
        MinWidth = 10
        Text = 'Avg5'
        Width = 50
      end>
  end
  object VirtualGHFStringTree1_GroupHeader: THeaderControl
    Left = 0
    Top = 3
    Width = 433
    Height = 21
    Align = alNone
    DragReorder = False
    FullDrag = False
    Sections = <
      item
        ImageIndex = -1
        MaxWidth = 120
        MinWidth = 20
        Text = 'Group1'
        Width = 100
      end
      item
        ImageIndex = -1
        MinWidth = 30
        Text = 'Group2'
        Width = 150
      end
      item
        ImageIndex = -1
        MinWidth = 30
        Text = 'Group3'
        Width = 150
      end>
  end
end
