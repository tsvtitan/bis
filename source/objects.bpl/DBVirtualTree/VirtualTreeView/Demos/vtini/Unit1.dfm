object Form1: TForm1
  Left = 77
  Top = 174
  Width = 478
  Height = 572
  Caption = 'Simple VT Descendants'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 508
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Open System.ini'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 508
    Width = 121
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Close System.ini'
    TabOrder = 1
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 470
    Height = 501
    ActivePage = TabSheet6
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'VT IniTree'
      object VirtualIniTree1: TVirtualIniTree
        Left = 0
        Top = 0
        Width = 462
        Height = 272
        Align = alClient
        BorderStyle = bsSingle
        DefaultNodeHeight = 13
        Header.AutoSizeIndex = 1
        Header.Columns = <
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 0
            Width = 100
            WideText = 'Name'
          end
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 1
            Width = 362
            WideText = 'Value'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        ParentColor = True
        TabOrder = 0
        TextMargin = 0
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        WideDefaultText = 'Node'
      end
      object Memo5: TMemo
        Left = 0
        Top = 272
        Width = 462
        Height = 201
        Align = alBottom
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'VT List'
      ImageIndex = 1
      object VirtualList1: TVirtualList
        Left = 0
        Top = 0
        Width = 462
        Height = 272
        Align = alClient
        BorderStyle = bsSingle
        DefaultNodeHeight = 13
        Header.AutoSizeIndex = -1
        Header.Columns = <
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 0
            Width = 100
            WideText = 'Name'
          end
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 1
            Width = 362
            WideText = 'Value'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        ParentColor = True
        TabOrder = 0
        TextMargin = 0
        TreeOptions.PaintOptions = [toHideFocusRect, toShowDropmark, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        WideDefaultText = 'Node'
      end
      object Memo4: TMemo
        Left = 0
        Top = 272
        Width = 462
        Height = 201
        Align = alBottom
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'VT Memo'
      ImageIndex = 2
      object VirtualMemo1: TVirtualMemo
        Left = 0
        Top = 0
        Width = 462
        Height = 272
        Align = alClient
        BorderStyle = bsSingle
        DefaultNodeHeight = 13
        Header.AutoSizeIndex = 0
        Header.Columns = <>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        ParentColor = True
        TabOrder = 0
        TextMargin = 0
        TreeOptions.PaintOptions = [toHideFocusRect, toShowDropmark, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        WideDefaultText = 'Node'
      end
      object Memo3: TMemo
        Left = 0
        Top = 272
        Width = 462
        Height = 201
        Align = alBottom
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'VT Numbered Memo'
      ImageIndex = 3
      object VirtualNumberedMemo1: TVirtualNumberedMemo
        Left = 0
        Top = 0
        Width = 462
        Height = 272
        Align = alClient
        BorderStyle = bsSingle
        DefaultNodeHeight = 13
        Header.AutoSizeIndex = -1
        Header.Columns = <
          item
            Alignment = taRightJustify
            Color = clWindow
            ImageIndex = -1
            Layout = blGlyphLeft
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 50
            WideText = 'No'
          end
          item
            Alignment = taLeftJustify
            Color = clWindow
            ImageIndex = -1
            Layout = blGlyphLeft
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
            Position = 1
            Width = 10
          end
          item
            Alignment = taLeftJustify
            Color = clWindow
            ImageIndex = -1
            Layout = blGlyphLeft
            Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
            Position = 2
            Width = 402
            WideText = 'Text'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        ParentColor = True
        TabOrder = 0
        TextMargin = 0
        TreeOptions.PaintOptions = [toHideFocusRect, toShowDropmark, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        WideDefaultText = 'Node'
      end
      object Memo2: TMemo
        Left = 0
        Top = 272
        Width = 462
        Height = 201
        Align = alBottom
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'VT Data'
      ImageIndex = 4
      object VirtualStringTreeData1: TVirtualStringTreeData
        Left = 0
        Top = 0
        Width = 462
        Height = 272
        Align = alClient
        BorderStyle = bsSingle
        Header.AutoSizeIndex = 1
        Header.Columns = <
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 0
            Width = 100
            WideText = 'Name'
          end
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 1
            Width = 362
            WideText = 'Value'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        NodeDataSize = 4
        TabOrder = 0
        OnCompareNodes = VirtualStringTreeData1CompareNodes
        OnHeaderClick = VirtualStringTreeData1HeaderClick
        Data = <>
        Items = <>
        Nodes = <>
        WideDefaultText = 'Node'
      end
      object Memo1: TMemo
        Left = 0
        Top = 272
        Width = 462
        Height = 201
        Align = alBottom
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'RttiGrid'
      ImageIndex = 5
      object RttiGrid1: TRttiGrid
        Left = 0
        Top = 0
        Width = 462
        Height = 272
        Align = alClient
        BorderStyle = bsSingle
        Header.AutoSizeIndex = -1
        Header.Columns = <
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 0
            Width = 150
            WideText = 'Name'
          end
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 1
            Width = 100
            WideText = 'Value'
          end
          item
            Alignment = taLeftJustify
            ImageIndex = -1
            Layout = blGlyphLeft
            Position = 2
            Width = 100
            WideText = 'Type'
          end>
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        Header.Style = hsThickButtons
        HintAnimation = hatNone
        HintMode = hmDefault
        IncrementalSearchDirection = sdForward
        NodeDataSize = 4
        TabOrder = 0
        Data = <>
        Items = <>
        Nodes = <>
        WideDefaultText = 'Node'
      end
      object Memo6: TMemo
        Left = 0
        Top = 272
        Width = 462
        Height = 201
        Align = alBottom
        Lines.Strings = (
          
            'This VT (VirtualStringTreeData) descendant uses the RTTI info of' +
            ' a TPersistent '
          'Descendant to show properties and their types and values.'
          ''
          'Code used:'
          
            '----------------------------------------------------------------' +
            '---------------------------------------'
          'begin'
          '  RttiGrid1.SetObject(Memo6);'
          'end;'
          ''
          
            '----------------------------------------------------------------' +
            '---------------------------------------')
        ParentColor = True
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
  object Button3: TButton
    Left = 264
    Top = 508
    Width = 121
    Height = 25
    Caption = 'Update Rtti'
    TabOrder = 3
    OnClick = Button3Click
  end
end
