object fmSimple: TfmSimple
  Left = 203
  Top = 110
  Width = 821
  Height = 630
  Caption = 'Simple Example'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SynEdit1: TSynEdit
    Left = 0
    Top = 0
    Width = 813
    Height = 603
    Cursor = crIBeam
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnMouseMove = SynEdit1MouseMove
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Terminal'
    Gutter.Font.Style = []
    Highlighter = SynPasSyn1
    Keystrokes = <
      item
        Command = ecUp
        ShortCut = 38
      end
      item
        Command = ecSelUp
        ShortCut = 8230
      end
      item
        Command = ecScrollUp
        ShortCut = 16422
      end
      item
        Command = ecDown
        ShortCut = 40
      end
      item
        Command = ecSelDown
        ShortCut = 8232
      end
      item
        Command = ecScrollDown
        ShortCut = 16424
      end
      item
        Command = ecLeft
        ShortCut = 37
      end
      item
        Command = ecSelLeft
        ShortCut = 8229
      end
      item
        Command = ecWordLeft
        ShortCut = 16421
      end
      item
        Command = ecSelWordLeft
        ShortCut = 24613
      end
      item
        Command = ecRight
        ShortCut = 39
      end
      item
        Command = ecSelRight
        ShortCut = 8231
      end
      item
        Command = ecWordRight
        ShortCut = 16423
      end
      item
        Command = ecSelWordRight
        ShortCut = 24615
      end
      item
        Command = ecPageDown
        ShortCut = 34
      end
      item
        Command = ecSelPageDown
        ShortCut = 8226
      end
      item
        Command = ecPageBottom
        ShortCut = 16418
      end
      item
        Command = ecSelPageBottom
        ShortCut = 24610
      end
      item
        Command = ecPageUp
        ShortCut = 33
      end
      item
        Command = ecSelPageUp
        ShortCut = 8225
      end
      item
        Command = ecPageTop
        ShortCut = 16417
      end
      item
        Command = ecSelPageTop
        ShortCut = 24609
      end
      item
        Command = ecLineStart
        ShortCut = 36
      end
      item
        Command = ecSelLineStart
        ShortCut = 8228
      end
      item
        Command = ecEditorTop
        ShortCut = 16420
      end
      item
        Command = ecSelEditorTop
        ShortCut = 24612
      end
      item
        Command = ecLineEnd
        ShortCut = 35
      end
      item
        Command = ecSelLineEnd
        ShortCut = 8227
      end
      item
        Command = ecEditorBottom
        ShortCut = 16419
      end
      item
        Command = ecSelEditorBottom
        ShortCut = 24611
      end
      item
        Command = ecToggleMode
        ShortCut = 45
      end
      item
        Command = ecCopy
        ShortCut = 16429
      end
      item
        Command = ecCut
        ShortCut = 8238
      end
      item
        Command = ecPaste
        ShortCut = 8237
      end
      item
        Command = ecDeleteChar
        ShortCut = 46
      end
      item
        Command = ecDeleteLastChar
        ShortCut = 8
      end
      item
        Command = ecDeleteLastChar
        ShortCut = 8200
      end
      item
        Command = ecDeleteLastWord
        ShortCut = 16392
      end
      item
        Command = ecUndo
        ShortCut = 32776
      end
      item
        Command = ecRedo
        ShortCut = 40968
      end
      item
        Command = ecLineBreak
        ShortCut = 13
      end
      item
        Command = ecLineBreak
        ShortCut = 8205
      end
      item
        Command = ecTab
        ShortCut = 9
      end
      item
        Command = ecShiftTab
        ShortCut = 8201
      end
      item
        Command = ecContextHelp
        ShortCut = 16496
      end
      item
        Command = ecSelectAll
        ShortCut = 16449
      end
      item
        Command = ecCopy
        ShortCut = 16451
      end
      item
        Command = ecPaste
        ShortCut = 16470
      end
      item
        Command = ecCut
        ShortCut = 16472
      end
      item
        Command = ecBlockIndent
        ShortCut = 24649
      end
      item
        Command = ecBlockUnindent
        ShortCut = 24661
      end
      item
        Command = ecLineBreak
        ShortCut = 16461
      end
      item
        Command = ecInsertLine
        ShortCut = 16462
      end
      item
        Command = ecDeleteWord
        ShortCut = 16468
      end
      item
        Command = ecDeleteLine
        ShortCut = 16473
      end
      item
        Command = ecDeleteEOL
        ShortCut = 24665
      end
      item
        Command = ecUndo
        ShortCut = 16474
      end
      item
        Command = ecRedo
        ShortCut = 24666
      end
      item
        Command = ecGotoMarker0
        ShortCut = 16432
      end
      item
        Command = ecGotoMarker1
        ShortCut = 16433
      end
      item
        Command = ecGotoMarker2
        ShortCut = 16434
      end
      item
        Command = ecGotoMarker3
        ShortCut = 16435
      end
      item
        Command = ecGotoMarker4
        ShortCut = 16436
      end
      item
        Command = ecGotoMarker5
        ShortCut = 16437
      end
      item
        Command = ecGotoMarker6
        ShortCut = 16438
      end
      item
        Command = ecGotoMarker7
        ShortCut = 16439
      end
      item
        Command = ecGotoMarker8
        ShortCut = 16440
      end
      item
        Command = ecGotoMarker9
        ShortCut = 16441
      end
      item
        Command = ecSetMarker0
        ShortCut = 24624
      end
      item
        Command = ecSetMarker1
        ShortCut = 24625
      end
      item
        Command = ecSetMarker2
        ShortCut = 24626
      end
      item
        Command = ecSetMarker3
        ShortCut = 24627
      end
      item
        Command = ecSetMarker4
        ShortCut = 24628
      end
      item
        Command = ecSetMarker5
        ShortCut = 24629
      end
      item
        Command = ecSetMarker6
        ShortCut = 24630
      end
      item
        Command = ecSetMarker7
        ShortCut = 24631
      end
      item
        Command = ecSetMarker8
        ShortCut = 24632
      end
      item
        Command = ecSetMarker9
        ShortCut = 24633
      end
      item
        Command = ecNormalSelect
        ShortCut = 24654
      end
      item
        Command = ecColumnSelect
        ShortCut = 24643
      end
      item
        Command = ecLineSelect
        ShortCut = 24652
      end
      item
        Command = ecMatchBracket
        ShortCut = 24642
      end>
    Lines.Strings = (
      '{ CTRL+SPACE for code completion '
      '  CTRL+SHIFT+SPACE for parameter completion'
      '  Hover moust over a symbol for a pop-up hint. }'
      ''
      'var littleVar: Integer; '
      ''
      
        'ShowMessage('#39'Hello. '#39'+ IntToStr(littleVar)+ '#39' Did you see the pa' +
        'ram complete adjust?'#39');'
      ''
      ''
      'var BiggerVar: Boolean;'
      'var Rec: TMyRec;'
      'var MyClass: TMyClass;'
      'var MyClass2: TMyClass2;'
      ''
      'type TMyClassThing = class of TMyClass;'
      ''
      '// Test things for code completion'
      '// custom unit "MyTestUnit"'
      '// Rec, MyClass'
      ''
      'type'
      '  TSimpleClass = class'
      '    FField: string;'
      '    function GetField: string;'
      '    property Field: string read GetField;'
      '  end;'
      ''
      '// simple procedure'
      'procedure DoThing(a, b: String; c: Integer);'
      'begin'
      '  // hit CTRL+SPACE to see how params are scoped.'
      '  var i : Integer;'
      '  for i := 0 to 4 do begin'
      '    a := b + IntToStr(c);'
      '  end;'
      'end;'
      ''
      '// method implementation'
      'function TSimpleClass.GetField: string;'
      'begin'
      '  // hit CTRL+SPACE to see how class members are scoped'
      '  Result := FField;'
      'end;')
  end
  object CodeProposal: TSynCompletionProposal
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion]
    NbLinesInWindow = 16
    Width = 262
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        BiggestWord = 'constructor'
      end>
    ItemHeight = 16
    OnExecute = ProposalExecute
    ShortCut = 16416
    Editor = SynEdit1
    Left = 304
    Top = 64
  end
  object SynPasSyn1: TSynPasSyn
    CommentAttri.Foreground = clGreen
    KeyAttri.Foreground = clPurple
    StringAttri.Foreground = clRed
    Left = 72
    Top = 64
  end
  object DelphiWebScriptII1: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 96
    Top = 192
  end
  object dws2Unit1: Tdws2Unit
    Script = DelphiWebScriptII1
    Arrays = <
      item
        Name = 'MyArray'
        DataType = 'Boolean'
        LowBound = 0
        HighBound = 2
      end>
    Classes = <
      item
        Name = 'TMyClass'
        Constructors = <>
        Fields = <
          item
            Name = 'FSnuffy'
            DataType = 'Boolean'
          end>
        Methods = <
          item
            Name = 'GetMyValue'
            Parameters = <>
            ResultType = 'Integer'
            Kind = mkFunction
          end
          item
            Name = 'SetSomeThing'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
                IsWritable = False
              end>
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'Value'
            DataType = 'Integer'
            ReadAccess = 'GetMyValue'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TMyClass2'
        Ancestor = 'TMyClass'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'GetThatSpecialNumber'
            Parameters = <>
            ResultType = 'Integer'
            Kind = mkFunction
          end>
        Properties = <>
      end>
    Constants = <
      item
        Name = 'Lovely'
        DataType = 'String'
        Value = 'Lady'
      end>
    Enumerations = <>
    Forwards = <
      item
        Name = 'TMyClass'
      end>
    Functions = <
      item
        Name = 'ShowMessageA'
        Parameters = <
          item
            Name = 'AMsg'
            DataType = 'String'
            IsVarParam = True
            IsWritable = False
          end>
      end
      item
        Name = 'Money'
        Parameters = <>
        ResultType = 'Float'
      end>
    Instances = <>
    Records = <
      item
        Name = 'TMyRec'
        Members = <
          item
            Name = 'Name'
            DataType = 'String'
          end
          item
            Name = 'Value'
            DataType = 'Variant'
          end>
      end>
    UnitName = 'MyTestUnit'
    Variables = <
      item
        Name = 'MyBDay'
        DataType = 'DateTime'
      end>
    Left = 176
    Top = 192
  end
  object dws2FileFunctions1: Tdws2FileFunctions
    Left = 96
    Top = 248
  end
  object dws2GUIFunctions1: Tdws2GUIFunctions
    Left = 96
    Top = 312
  end
  object ParamProposal: TSynCompletionProposal
    DefaultType = ctParams
    Options = [scoLimitToMatchedText, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion]
    ClBackground = clInfoBk
    Width = 262
    EndOfTokenChr = '()[]. '
    TriggerChars = '('
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    OnExecute = ProposalExecute
    ShortCut = 24608
    Editor = SynEdit1
    TimerInterval = 500
    Left = 384
    Top = 64
  end
  object ScriptHint: TSynCompletionProposal
    DefaultType = ctHint
    Options = [scoAnsiStrings, scoLimitToMatchedText, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion, scoConsiderWordBreakChars]
    Width = 262
    EndOfTokenChr = '()[]. '
    TriggerChars = ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        BiggestWord = 'CONSTRUCTOR'
      end>
    OnExecute = ProposalExecute
    ShortCut = 0
    Editor = SynEdit1
    TimerInterval = 500
    Left = 464
    Top = 64
  end
end
