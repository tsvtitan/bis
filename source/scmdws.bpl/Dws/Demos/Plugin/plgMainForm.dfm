object Form1: TForm1
  Left = 210
  Top = 152
  Width = 696
  Height = 480
  Caption = 'dws2Unit - bleeding edge plugin Demo for DWSII '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 197
    Width = 688
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Panel1: TPanel
    Left = 0
    Top = 200
    Width = 688
    Height = 253
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 688
      Height = 33
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Script'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object Splitter2: TSplitter
      Left = 0
      Top = 189
      Width = 688
      Height = 3
      Cursor = crVSplit
      Align = alBottom
    end
    object Memo1: TMemo
      Left = 0
      Top = 33
      Width = 688
      Height = 156
      Align = alClient
      Lines.Strings = (
        '{'
        
          ' Load the Plg1.bpl first! (Press "Load Plugin" and then select P' +
          'lg1.bpl)'
        '}'
        ''
        ''
        'showmessage(Hello);')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 0
      Top = 192
      Width = 688
      Height = 61
      Align = alBottom
      Lines.Strings = (
        '')
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 197
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 77
      Height = 13
      Caption = 'Loaded PlugIns:'
    end
    object Label3: TLabel
      Left = 488
      Top = 48
      Width = 185
      Height = 65
      AutoSize = False
      Caption = 
        'Press the "available Functions" Button to see all available func' +
        'tions in script. (Be sure to compare items before/after loading ' +
        'a plugin!)'
      WordWrap = True
    end
    object ListBox1: TListBox
      Left = 16
      Top = 32
      Width = 353
      Height = 129
      ItemHeight = 13
      TabOrder = 0
    end
    object Button1: TButton
      Left = 392
      Top = 32
      Width = 73
      Height = 25
      Caption = 'Load Plugin '
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 504
      Top = 128
      Width = 153
      Height = 25
      Caption = 'available Functions'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 392
      Top = 128
      Width = 75
      Height = 25
      Caption = 'Run Script'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object DelphiWebScriptII1: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 632
    Top = 32
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BorlandPackageFiles|*.bpl'
    Left = 600
    Top = 32
  end
  object dws2GUIFunctions1: Tdws2GUIFunctions
    Left = 632
    Top = 64
  end
end
