object frmScriptDemo: TfrmScriptDemo
  Left = 272
  Top = 170
  Width = 733
  Height = 566
  Caption = 'DWS Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = True
  Position = poDefaultPosOnly
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 448
    Top = 0
    Width = 3
    Height = 520
    Cursor = crHSplit
    Align = alRight
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 448
    Height = 520
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 0
      Top = 436
      Width = 448
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Visible = False
    end
    object lbMsgs: TListBox
      Left = 0
      Top = 439
      Width = 448
      Height = 81
      Align = alBottom
      ItemHeight = 13
      TabOrder = 0
      Visible = False
      OnClick = lbMsgsClick
      OnDblClick = lbMsgsDblClick
    end
    object memoSource: TRichEdit
      Left = 0
      Top = 0
      Width = 448
      Height = 436
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      HideSelection = False
      ParentFont = False
      PlainText = True
      ScrollBars = ssVertical
      TabOrder = 1
      WantTabs = True
      WordWrap = False
      OnChange = memoSourceChange
    end
  end
  object Panel3: TPanel
    Left = 451
    Top = 0
    Width = 274
    Height = 520
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter3: TSplitter
      Left = 0
      Top = 310
      Width = 274
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object lbLog: TListBox
      Left = 0
      Top = 313
      Width = 274
      Height = 207
      Align = alBottom
      ItemHeight = 13
      Items.Strings = (
        'Log')
      TabOrder = 0
    end
    object memoResult: TRichEdit
      Left = 0
      Top = 0
      Width = 274
      Height = 310
      Align = alClient
      Lines.Strings = (
        'This memo displays the value of '
        'TDelphiWebScript.Result ')
      TabOrder = 1
      WantTabs = True
      WordWrap = False
    end
  end
  object MainMenu: TMainMenu
    Left = 30
    Top = 370
    object FileMenu: TMenuItem
      Caption = 'File'
      object NewItem: TMenuItem
        Caption = '&New'
        ShortCut = 16462
        OnClick = NewItemClick
      end
      object OpenItem: TMenuItem
        Caption = '&Open'
        ShortCut = 16463
        OnClick = OpenItemClick
      end
      object SaveItem: TMenuItem
        Caption = '&Save'
        ShortCut = 16467
        OnClick = SaveItemClick
      end
      object SaveAsItem: TMenuItem
        Caption = 'Save As...'
        OnClick = SaveAsItemClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object ExitItem: TMenuItem
        Caption = '&Exit'
        OnClick = ExitItemClick
      end
    end
    object ScriptMenu: TMenuItem
      Caption = 'Script'
      object CompileItem: TMenuItem
        Caption = '&Compile'
        ShortCut = 16504
        OnClick = CompileItemClick
      end
      object ExecuteItem: TMenuItem
        Caption = '&Execute'
        ShortCut = 120
        OnClick = ExecuteItemClick
      end
      object StopItem: TMenuItem
        Caption = '&Stop'
        ShortCut = 27
        OnClick = StopItemClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object StepItem: TMenuItem
        Caption = 'Step'
        ShortCut = 119
        OnClick = StepItemClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object OptionOptimizationItem: TMenuItem
        Caption = 'Optimization (ON/OFF)'
        OnClick = CompilerOptionClick
      end
    end
    object DemosMenu: TMenuItem
      Caption = 'Demos'
      OnClick = DemosMenuClick
    end
    object DebuggerMenu: TMenuItem
      Caption = 'Debugger'
      object DebuggerNoneItem: TMenuItem
        Caption = 'None'
        Checked = True
        RadioItem = True
        OnClick = DebuggerNoneItemClick
      end
      object DebuggerSimpleItem: TMenuItem
        Caption = 'SimpleDebugger'
        RadioItem = True
        OnClick = DebuggerSimpleItemClick
      end
      object DebuggerRemoteItem: TMenuItem
        Caption = 'RemoteDebugger'
        RadioItem = True
        OnClick = DebuggerRemoteItemClick
      end
    end
    object HelpMenu: TMenuItem
      Caption = 'Help'
      object ManualItem: TMenuItem
        Caption = 'Manual'
        OnClick = ManualItemClick
      end
      object HomepageItem: TMenuItem
        Caption = 'DWS Homepage'
        OnClick = HomepageItemClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object AboutItem: TMenuItem
        Caption = 'About'
        OnClick = AboutItemClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'dws'
    Filter = 'DWS files|*.dws|TScript files|*.sct|All files|*.*'
    Options = [ofExtensionDifferent, ofPathMustExist, ofFileMustExist]
    Left = 90
    Top = 370
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'dws'
    Filter = 'DWS files|*.dws|TScript files|*.sct|All files|*.*'
    FilterIndex = 0
    Options = [ofExtensionDifferent, ofPathMustExist]
    Left = 150
    Top = 370
  end
  object SimpleDebugger: Tdws2SimpleDebugger
    OnDebug = SimpleDebuggerDoDebug
    Left = 60
    Top = 250
  end
  object Script: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.MemoryleakWarning = False
    Config.ScriptPaths.Strings = (
      '..\scripts\')
    Config.Timeout = 0
    Left = 60
    Top = 20
  end
  object dws2GUIFunctions: Tdws2GUIFunctions
    Left = 60
    Top = 70
  end
  object dws2FileFunctions: Tdws2FileFunctions
    Left = 60
    Top = 120
  end
  object dws2GlobalVarsFunctions: Tdws2GlobalVarsFunctions
    Left = 60
    Top = 170
  end
  inline dws2ClassesLib: Tdws2ClassesLib
    OldCreateOrder = False
    Script = Script
    Left = 180
    Top = 70
    Height = 0
    Width = 0
  end
  inline dws2MFLib: Tdws2MFLib
    OldCreateOrder = False
    Script = Script
    Left = 180
    Top = 120
    Height = 0
    Width = 0
  end
  inline dws2MFZipLib: Tdws2MFZipLib
    OldCreateOrder = False
    Script = Script
    Left = 180
    Top = 170
    Height = 0
    Width = 0
  end
end
