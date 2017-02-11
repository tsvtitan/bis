object Form1: TForm1
  Left = 389
  Top = 52
  Caption = 'Dynamic DBTreeView demo'
  ClientHeight = 775
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 310
    Top = 348
    Width = 67
    Height = 13
    Caption = 'Our webpage:'
  end
  object Label2: TLabel
    Left = 394
    Top = 348
    Width = 134
    Height = 13
    Caption = 'http://www.table-report.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label2Click
  end
  object DTTableTree1: TDTTableTree
    Left = 8
    Top = 13
    Width = 333
    Height = 309
    DragMode = dmAutomatic
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 18
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.PopupMenu = PopupActionBar1
    Images = ImageList1
    IncrementalSearch = isAll
    IncrementalSearchStart = ssAlwaysStartOver
    NodeDataSize = 4
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect, toCenterScrollIntoView]
    OnBeforeCellPaint = DTTableTree1BeforeCellPaint
    DataSource = DataSource1
    DBTreeFields.KeyFieldName = 'Key'
    DBTreeFields.ParentFieldName = 'Parent'
    DBTreeFields.ListFieldName = 'List'
    DBTreeFields.ParentOfRootValue = '0'
    DBTreeImages.HasChildrenImageIndex = 0
    DBTreeImages.HasChildrenSelectedIndex = 1
    DBTreeImages.NoChildrenImageIndex = 2
    DBTreeImages.NoChildrenSelectedIndex = 3
    UseFilter = False
    Columns = <
      item
        Alignment = taRightJustify
        ImageIndex = 0
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 100
        FieldName = 'KEY'
        WideText = 'asdfasdfasdf'
      end
      item
        Alignment = taRightJustify
        Position = 1
        Width = 100
        FieldName = 'PARENT'
        WideText = 'asdfasdf'
      end
      item
        ImageIndex = 3
        Position = 2
        Width = 100
        FieldName = 'LIST'
        WideText = '20'
      end>
  end
  object Button2: TButton
    Left = 20
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Add Child'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 108
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Add Sibling'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button1: TButton
    Left = 200
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 347
    Top = 13
    Width = 270
    Height = 309
    DataSource = DataSource1
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Key'
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Parent'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'List'
        Width = 114
        Visible = True
      end>
  end
  object Button4: TButton
    Left = 20
    Top = 356
    Width = 75
    Height = 25
    Caption = 'GoTop'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 108
    Top = 356
    Width = 75
    Height = 25
    Caption = 'GoDown'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 200
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Next'
    TabOrder = 7
    OnClick = Button6Click
  end
  object DTADOTree1: TDTADOTree
    Left = 8
    Top = 559
    Width = 333
    Height = 178
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    NodeDataSize = 4
    RootNodeCount = 2
    TabOrder = 8
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect, toCenterScrollIntoView]
    DataSource = DataSource2
    DBTreeFields.KeyFieldName = 'FIRM_ID'
    DBTreeFields.ParentFieldName = 'PARENT_ID'
    DBTreeFields.ListFieldName = 'SMALL_NAME'
    DBTreeImages.HasChildrenImageIndex = -1
    DBTreeImages.HasChildrenSelectedIndex = -1
    DBTreeImages.NoChildrenImageIndex = -1
    DBTreeImages.NoChildrenSelectedIndex = -1
    UseFilter = True
    Columns = <
      item
        Position = 0
        Width = 100
        FieldName = 'FIRM_ID'
        WideText = 'FIRM_ID'
      end
      item
        Position = 1
        Width = 100
        FieldName = 'PARENT_ID'
        WideText = 'PARENT_ID'
      end
      item
        Position = 2
        Width = 100
        FieldName = 'SMALL_NAME'
        WideText = 'SMALL_NAME'
      end>
  end
  object Table1: TTable
    TableName = 'TreeTbl.db'
    Left = 72
    Top = 112
    object Table1ID: TAutoIncField
      FieldName = 'Key'
      ReadOnly = True
    end
    object Table1PARENT: TIntegerField
      FieldName = 'Parent'
    end
    object Table1NAME: TStringField
      FieldName = 'List'
      Size = 10
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 112
    Top = 24
  end
  object ImageList1: TImageList
    BlendColor = clWindow
    Left = 144
    Top = 24
    Bitmap = {
      494C010104000600040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      000000000000C56A3100C56A3100C56A3100C56A3100C56A3100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000066FF000066FF000066FF000066FF000066FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C56A3100C56A3100C56A3100C56A3100C56A3100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000066FF000066FF000066FF000066FF000066FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A310000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000C56A31000000000000000000000000000000
      000000000000000000000000000000000000000000000066FF000066FF000066
      FF000066FF000066FF0000000000C56A31000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C56A3100C56A3100C56A
      3100C56A3100C56A310000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000066FF000066FF000066
      FF000066FF000066FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF83FF83FFFFFFFFFE83FE83FFFFFFFFFEFFFEFFFFFFFFFF
      FE83FE83FFFFFFFFFE83FE83F83FF83FFEFFFEFFF83FF83FFE83FE83FFFFFFFF
      FE83FE83FFFFFFFFFEFFFEFFFFFFFFFF82FF82FFFFFFFFFF83FF83FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PopupActionBar1: TPopupActionBar
    Left = 216
    Top = 168
    object gtiotuio1: TMenuItem
      Caption = 'gtiotuio'
    end
    object tuio1: TMenuItem
      Caption = 'tuio'
    end
    object tuio2: TMenuItem
      Caption = 'tuio'
    end
    object tuio3: TMenuItem
      Caption = 'tuio'
    end
  end
  object DataSource2: TDataSource
    DataSet = kbmMemTable1
    Left = 392
    Top = 416
  end
  object kbmMemTable1: TkbmMemTable
    Active = True
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'FIRM_ID'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'FIRM_TYPE_ID'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'PARENT_ID'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'SMALL_NAME'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'FULL_NAME'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'INN'
        DataType = ftString
        Size = 12
      end
      item
        Name = 'PAYMENT_ACCOUNT'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BANK'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'BIK'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'CORR_ACCOUNT'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'LEGAL_ADDRESS'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'POST_ADDRESS'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'PHONE'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'FAX'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'EMAIL'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SITE'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'OKONH'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'OKPO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'KPP'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DIRECTOR'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'ACCOUNTANT'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'CONTACT_FACE'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'FIRM_TYPE_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'PARENT_SMALL_NAME'
        DataType = ftString
        Size = 250
      end>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.51'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 400
    Top = 480
    object kbmMemTable1FIRM_ID: TStringField
      FieldName = 'FIRM_ID'
      Size = 32
    end
    object kbmMemTable1FIRM_TYPE_ID: TStringField
      FieldName = 'FIRM_TYPE_ID'
      Size = 32
    end
    object kbmMemTable1PARENT_ID: TStringField
      FieldName = 'PARENT_ID'
      Size = 32
    end
    object kbmMemTable1SMALL_NAME: TStringField
      FieldName = 'SMALL_NAME'
      Size = 250
    end
    object kbmMemTable1FULL_NAME: TStringField
      FieldName = 'FULL_NAME'
      Size = 250
    end
    object kbmMemTable1INN: TStringField
      FieldName = 'INN'
      Size = 12
    end
    object kbmMemTable1PAYMENT_ACCOUNT: TStringField
      FieldName = 'PAYMENT_ACCOUNT'
    end
    object kbmMemTable1BANK: TStringField
      FieldName = 'BANK'
      Size = 250
    end
    object kbmMemTable1BIK: TStringField
      FieldName = 'BIK'
    end
    object kbmMemTable1CORR_ACCOUNT: TStringField
      FieldName = 'CORR_ACCOUNT'
    end
    object kbmMemTable1LEGAL_ADDRESS: TStringField
      FieldName = 'LEGAL_ADDRESS'
      Size = 250
    end
    object kbmMemTable1POST_ADDRESS: TStringField
      FieldName = 'POST_ADDRESS'
      Size = 250
    end
    object kbmMemTable1PHONE: TStringField
      FieldName = 'PHONE'
      Size = 250
    end
    object kbmMemTable1FAX: TStringField
      FieldName = 'FAX'
      Size = 250
    end
    object kbmMemTable1EMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object kbmMemTable1SITE: TStringField
      FieldName = 'SITE'
      Size = 100
    end
    object kbmMemTable1OKONH: TStringField
      FieldName = 'OKONH'
    end
    object kbmMemTable1OKPO: TStringField
      FieldName = 'OKPO'
    end
    object kbmMemTable1KPP: TStringField
      FieldName = 'KPP'
    end
    object kbmMemTable1DIRECTOR: TStringField
      FieldName = 'DIRECTOR'
      Size = 250
    end
    object kbmMemTable1ACCOUNTANT: TStringField
      FieldName = 'ACCOUNTANT'
      Size = 250
    end
    object kbmMemTable1CONTACT_FACE: TStringField
      FieldName = 'CONTACT_FACE'
      Size = 250
    end
    object kbmMemTable1FIRM_TYPE_NAME: TStringField
      FieldName = 'FIRM_TYPE_NAME'
      Size = 100
    end
    object kbmMemTable1PARENT_SMALL_NAME: TStringField
      FieldName = 'PARENT_SMALL_NAME'
      Size = 250
    end
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initi' +
      'al Catalog=CALLCENTER;Data Source=2003s-callcent'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 400
    Top = 560
  end
  object ADOQuery1: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM S_FIRMS')
    Left = 480
    Top = 520
  end
  object kbmThreadDataSet1: TkbmThreadDataSet
    Left = 512
    Top = 432
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    TableName = 'FIRMS'
    Left = 408
    Top = 640
  end
end
