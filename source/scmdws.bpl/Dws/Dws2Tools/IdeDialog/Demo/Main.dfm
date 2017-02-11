object DemoFrm: TDemoFrm
  Left = 301
  Top = 162
  Width = 562
  Height = 519
  Caption = 'ILFScriptEngine Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 192
    Width = 54
    Height = 13
    Caption = 'Load Script'
  end
  object SBLoadScript: TSpeedButton
    Left = 256
    Top = 208
    Width = 23
    Height = 22
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF008985
      9400C8A7AF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0087ADCA004979
      C700837CA400C8A7AF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF009DD6FF004FB4
      FE004B7AC700837CA400C8A7AF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0091D0
      FF0052B7FE004B7AC700837CA400C8A7AF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0091D0FF0053B7FE004A7DCB00837CA400D8C4CA00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF008FCEFF0053B7FE00568BD000A9ABB000D4B5AC00CB9D8700CA99
      8100CB9B8300D1A69100D5B2A900FFFFFE00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00A6D9FF00C9D0D400B98F8100D7AB8E00EDD6AF00FAF4
      CC00FAF5D400EDDCBD00D9B6A100CFA89A00FFFFFE00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00DCBDB400D8A98C00FFF5C400FFF6C300FFFF
      D900FFFFE900FFFFF800FFFFFF00D9B6A000CDAAA200FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00D3A59000EDD3AA00FFE5B300FFF9C600FFFF
      DC00FFFFEC00FFFFFB00FFFFF600EDDCBD00CA9F8A00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00CC9A8200FAEFC400FFDBA800FFF2BF00FFFF
      D600FFFFE400FFFFEB00FFFFE500FAF5D100C9998100FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00CC9A8200FAEFC400FFE7BC00FFF3C100FFFF
      CD00FFFFD400FFFFD600FFFFD500FAF3C900C9988000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00D2A79300EDD8B600FFF2DB00FFE1B900FFEF
      BD00FFF1BF00FFF5C300FFF4C100EDD5AC00CA9D8700FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00E0C3BB00D7B09700FFFFFF00FFF9EE00FFF1
      C800FFDAA700FFE6B400FFF5C600D6A88A00D5B6AE00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FFFFFE00D3AD9F00D6AF9B00EDD8BF00FAF1
      CC00FAEDC200EDD5AE00D6A68A00CDA39500FFFFFE00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FFFFFE00DEC4BB00CCA08D00C999
      8100CB9B8200D1A49100DDC1B800FFFFFE00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    OnClick = SBLoadScriptClick
  end
  object Label2: TLabel
    Left = 96
    Top = 296
    Width = 273
    Height = 65
    Caption = 
      'Open the IDE and debug your script'#13#10'For example, try to open the' +
      ' IDE (with DebugMode to ON)'#13#10'place a breakpoint and then launch ' +
      'a procedure from'#13#10'the EditBox provided. '#13#10'Then try to do the sam' +
      'e with DebugMode to OFF.'
  end
  object Label3: TLabel
    Left = 96
    Top = 384
    Width = 169
    Height = 39
    Caption = 
      'Try this to load a bugged script and '#13#10'let the IDE open automati' +
      'cally,'#13#10'showing the RunTime Error'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 8
    Top = 240
    Width = 96
    Height = 13
    Caption = 'Launch a procedure'
  end
  object Label5: TLabel
    Left = 328
    Top = 368
    Width = 217
    Height = 89
    AutoSize = False
    Caption = 
      'Use buttons below to add/remove the dws2Unit defined in the dmCl' +
      'asses module. Here are definitions of base classes like TStrings' +
      ', TWindows (simple wrapper to Delphi TForm), TField, ... These b' +
      'uttons shows an example on how to add and remove DWSII definitio' +
      'n runtime.'
    WordWrap = True
  end
  object CBDebugMode: TCheckBox
    Left = 216
    Top = 16
    Width = 97
    Height = 17
    Caption = 'DebugMode'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CBDebugModeClick
  end
  object Memo: TMemo
    Left = 376
    Top = 24
    Width = 169
    Height = 313
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 48
    Width = 241
    Height = 129
    Caption = 'dws2Unit functions'
    TabOrder = 2
    object BClearLines: TButton
      Left = 8
      Top = 88
      Width = 89
      Height = 25
      Caption = 'Clear Lines'
      TabOrder = 0
      OnClick = BClearLinesClick
    end
    object BAddLine: TButton
      Left = 8
      Top = 24
      Width = 89
      Height = 25
      Caption = 'Add Line'
      TabOrder = 1
      OnClick = BAddLineClick
    end
    object BGetLinesCount: TButton
      Left = 8
      Top = 56
      Width = 89
      Height = 25
      Caption = 'Get Lines Count'
      TabOrder = 2
      OnClick = BGetLinesCountClick
    end
    object ELine: TEdit
      Left = 104
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 3
    end
  end
  object EScriptFile: TEdit
    Left = 8
    Top = 208
    Width = 249
    Height = 21
    TabOrder = 3
  end
  object BOpenIDE: TButton
    Left = 8
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Open IDE'
    TabOrder = 4
    OnClick = BOpenIDEClick
  end
  object BTrapError: TButton
    Left = 8
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Trap Error'
    TabOrder = 5
    OnClick = BTrapErrorClick
  end
  object ELaunchProc: TEdit
    Left = 8
    Top = 256
    Width = 249
    Height = 21
    TabOrder = 6
    OnKeyPress = ELaunchProcKeyPress
  end
  object Button1: TButton
    Left = 328
    Top = 464
    Width = 91
    Height = 25
    Caption = 'add classes'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 448
    Top = 464
    Width = 97
    Height = 25
    Caption = 'remove classes'
    TabOrder = 8
    OnClick = Button2Click
  end
  object btnDebugSession: TButton
    Left = 256
    Top = 56
    Width = 113
    Height = 25
    Caption = 'InDebugSession?'
    TabOrder = 9
    OnClick = btnDebugSessionClick
  end
  object btnDebugPause: TButton
    Left = 256
    Top = 88
    Width = 113
    Height = 25
    Caption = 'InDebugPause?'
    TabOrder = 10
    OnClick = btnDebugPauseClick
  end
  object btnSoftReset: TButton
    Left = 256
    Top = 120
    Width = 113
    Height = 25
    Caption = 'Soft reset'
    TabOrder = 11
    OnClick = btnSoftResetClick
  end
  object btnHardReset: TButton
    Left = 256
    Top = 152
    Width = 113
    Height = 25
    Caption = 'Hard reset'
    TabOrder = 12
    OnClick = btnHardResetClick
  end
  object btnExecProgram: TButton
    Left = 256
    Top = 184
    Width = 113
    Height = 25
    Caption = 'Execute program'
    TabOrder = 13
    OnClick = btnExecProgramClick
  end
  object DelphiWebScriptII1: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 400
    Top = 352
  end
  object dws2Unit1: Tdws2Unit
    Script = DelphiWebScriptII1
    Arrays = <>
    Classes = <>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'AddLine'
        Parameters = <
          item
            Name = 'Line'
            DataType = 'String'
          end>
        OnEval = dws2Unit1FunctionsAddLineEval
      end
      item
        Name = 'GetLinesCount'
        Parameters = <>
        ResultType = 'Integer'
        OnEval = dws2Unit1FunctionsGetLinesCountEval
      end
      item
        Name = 'ClearLines'
        Parameters = <>
        OnEval = dws2Unit1FunctionsClearLinesEval
      end>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'GlobalFuncs'
    Variables = <>
    Left = 432
    Top = 352
  end
  object SynPasSyn1: TSynPasSyn
    CommentAttri.Foreground = clRed
    Left = 400
    Top = 384
  end
  object OpenDialog: TOpenDialog
    Filter = 'DWS Scripts|*.dws'
    InitialDir = 'Scripts'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Script Load'
    Left = 280
    Top = 208
  end
  object dws2GUIFunctions1: Tdws2GUIFunctions
    Left = 432
    Top = 384
  end
  object SaveDialog: TSaveDialog
    Filter = 'DWS Scripts|*.dws'
    InitialDir = 'Scripts'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Script Save'
    Left = 392
    Top = 288
  end
  object dws2IdeDialog: Tdws2IdeDialog
    DebugMode = True
    Script.Strings = (
      '{ Some default script }')
    ScriptEngine = DelphiWebScriptII1
    EditorHighLighter = SynPasSyn1
    Options = [eoAllowNew, eoAllowOpen, eoAllowSave, eoAllowSaveAs, eoShowCodeInsightIcons]
    EditorFont.Charset = DEFAULT_CHARSET
    EditorFont.Color = clWindowText
    EditorFont.Height = -12
    EditorFont.Name = 'Courier New'
    EditorFont.Style = []
    Title = 'Script Editor'
    OnLoadScript = dws2IdeDialogLoadScript
    OnSaveScript = dws2IdeDialogSaveScript
    OnSaveAsScript = dws2IdeDialogSaveAsScript
    OnError = dws2IdeDialogError
    OnCloseQuery = dws2IdeDialogEditorClose
    Left = 488
    Top = 352
  end
end
