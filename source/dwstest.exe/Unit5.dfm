object Form5: TForm5
  Left = 380
  Top = 133
  Caption = 'Form5'
  ClientHeight = 673
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    794
    673)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 24
    Top = 14
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 62
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GridPanel1: TGridPanel
    Left = 120
    Top = 8
    Width = 666
    Height = 449
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'GridPanel1'
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = MemoUnit1
        Row = 0
      end
      item
        Column = 1
        Control = MemoUnit2
        Row = 0
      end
      item
        Column = 0
        Control = Memo2
        Row = 1
      end
      item
        Column = 1
        Control = Memo3
        Row = 1
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 2
    object MemoUnit1: TMemo
      Left = 0
      Top = 0
      Width = 333
      Height = 224
      Align = alClient
      Lines.Strings = (
        'type'
        '  TNewForm2=class(TNewForm)'
        '  private'
        '    F2: TNotifyEvent;'
        '  public'
        '    constructor Create(AOwner: TComponent); override;'
        '    property OnClick2: TNotifyEvent read  F2 write F2;'
        '  end;'
        ''
        '{$INCLUDE '#39'Tdws2Func.dws'#39'}'
        ''
        '{ TNewForm2 } '
        ''
        'constructor TNewForm2.Create(AOwner: TComponent); '
        'begin'
        '  inherited Create(AOwner);'
        'end;'
        ''
        'procedure Show;'
        'var'
        '  Form: TNewForm2;'
        'begin'
        '  Form:=TNewForm2.Create(nil);'
        '  try'
        '    Form.OnClick:='#39'TestClick'#39';'
        '    Form.ShowModal;'
        '  finally'
        '    Form.Free;'
        '  end;'
        'end;'
        '')
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
      OnKeyDown = MemoUnit1KeyDown
      OnKeyUp = MemoUnit1KeyUp
    end
    object MemoUnit2: TMemo
      Left = 333
      Top = 0
      Width = 333
      Height = 224
      Align = alClient
      Lines.Strings = (
        'procedure TestClick(Sender: TObject);'
        'begin'
        'end;')
      ScrollBars = ssVertical
      TabOrder = 1
      WordWrap = False
    end
    object Memo2: TMemo
      Left = 0
      Top = 224
      Width = 333
      Height = 225
      Align = alClient
      Lines.Strings = (
        'Memo2')
      TabOrder = 2
    end
    object Memo3: TMemo
      Left = 333
      Top = 224
      Width = 333
      Height = 225
      Align = alClient
      Lines.Strings = (
        'Memo3')
      TabOrder = 3
    end
  end
  object lbSymNames: TListBox
    Left = 120
    Top = 463
    Width = 333
    Height = 194
    ItemHeight = 13
    TabOrder = 3
  end
  object lbSymPositions: TListBox
    Left = 453
    Top = 463
    Width = 333
    Height = 194
    ItemHeight = 13
    TabOrder = 4
    OnClick = lbSymPositionsClick
  end
  object Button3: TButton
    Left = 24
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Run2'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Script1: TDelphiWebScriptII
    Config.ResultType = Result
    Config.CompilerOptions = [coSymbolDictionary]
    Config.MaxDataSize = 0
    Config.Timeout = 0
    OnInclude = Script1Include
    Left = 16
    Top = 168
  end
  object Debugger1: Tdws2SimpleDebugger
    OnDebug = Debugger1Debug
    Left = 16
    Top = 224
  end
  object Result: Tdws2StringResultType
    Left = 16
    Top = 280
  end
  object Unit1: Tdws2Unit
    Script = Script1
    Arrays = <>
    Classes = <>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'GetTest2'
        Parameters = <>
        ResultType = 'String'
        OnEval = Unit1FunctionsGetTest2Eval
      end>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'Unit1'
    Variables = <>
    StaticSymbols = False
    Left = 16
    Top = 328
  end
  object Unit2: Tdws2Unit
    Script = Script1
    Arrays = <>
    Classes = <
      item
        Name = 'TComponent'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'AOwner'
                DataType = 'TComponent'
              end>
            Attributes = [maVirtual]
            OnAssignExternalObject = Unit2ClassesTComponentConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'ClassName'
            Parameters = <>
            ResultType = 'String'
            Kind = mkFunction
          end
          item
            Name = 'GetOwner'
            Parameters = <>
            ResultType = 'TComponent'
            Kind = mkFunction
          end
          item
            Name = 'Free'
            Parameters = <>
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'Owner'
            DataType = 'TComponent'
            ReadAccess = 'GetOwner'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TControl'
        Ancestor = 'TComponent'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'SetParent'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'TWinControl'
              end>
            Kind = mkProcedure
          end
          item
            Name = 'GetParent'
            Parameters = <>
            ResultType = 'TWinControl'
            Kind = mkFunction
          end
          item
            Name = 'SetOnClick'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'TNotifyEvent'
              end>
            OnEval = Unit2ClassesTControlMethodsSetOnClickEval
            Kind = mkProcedure
          end
          item
            Name = 'GetOnClick'
            Parameters = <>
            ResultType = 'TNotifyEvent'
            OnEval = Unit2ClassesTControlMethodsGetOnClickEval
            Kind = mkFunction
          end
          item
            Name = 'SetOnMouseEnter'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'TNotifyEvent'
              end>
            Kind = mkProcedure
          end
          item
            Name = 'GetOnMouseEnter'
            Parameters = <>
            ResultType = 'TNotifyEvent'
            Kind = mkFunction
          end
          item
            Name = 'SetOnMouseLeave'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'TNotifyEvent'
              end>
            Kind = mkProcedure
          end
          item
            Name = 'GetOnMouseLeave'
            Parameters = <>
            ResultType = 'TNotifyEvent'
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Parent'
            DataType = 'TWinControl'
            ReadAccess = 'GetParent'
            WriteAccess = 'SetParent'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'OnClick'
            DataType = 'TNotifyEvent'
            ReadAccess = 'GetOnClick'
            WriteAccess = 'SetOnClick'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'OnMouseEnter'
            DataType = 'TNotifyEvent'
            ReadAccess = 'GetOnMouseEnter'
            WriteAccess = 'SetOnMouseEnter'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'OnMouseLeave'
            DataType = 'TNotifyEvent'
            ReadAccess = 'GetOnMouseLeave'
            WriteAccess = 'SetOnMouseLeave'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TWinControl'
        Ancestor = 'TControl'
        Constructors = <>
        Fields = <>
        Methods = <>
        Properties = <>
      end
      item
        Name = 'TButton'
        Ancestor = 'TWinControl'
        Constructors = <>
        Fields = <>
        Methods = <>
        Properties = <>
      end
      item
        Name = 'TNewForm'
        Ancestor = 'TWinControl'
        Constructors = <>
        Fields = <
          item
            Name = 'FButton'
            DataType = 'TButton'
          end>
        Methods = <
          item
            Name = 'ShowModal'
            Parameters = <>
            OnEval = Unit2ClassesTNewFormMethodsShowModalEval
            Kind = mkProcedure
          end
          item
            Name = 'GetOnClick2'
            Parameters = <>
            ResultType = 'TNotifyEvent2'
            Kind = mkFunction
          end
          item
            Name = 'SetOnClick2'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'TNotifyEvent2'
              end>
            Kind = mkProcedure
          end
          item
            Name = 'GetButton1'
            Parameters = <>
            ResultType = 'TButton'
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Button1'
            DataType = 'TButton'
            ReadAccess = 'GetButton1'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Dependencies.Strings = (
      'Unit1')
    Enumerations = <>
    Forwards = <
      item
        Name = 'TComponent'
      end
      item
        Name = 'TWinControl'
      end>
    Functions = <
      item
        Name = 'GetTest2'
        Parameters = <>
        ResultType = 'String'
        OnEval = Unit2FunctionsGetTest2Eval
      end
      item
        Name = 'ShowMessage'
        Parameters = <
          item
            Name = 'Msg'
            DataType = 'String'
          end>
        OnEval = Unit2FunctionsShowMessageEval
      end
      item
        Name = 'Date'
        Parameters = <>
        ResultType = 'TDateTime'
        OnEval = Unit2FunctionsDateEval
      end>
    Instances = <
      item
        Name = 'SelfTest'
        DataType = 'TNewForm'
        OnInstantiate = Unit2InstancesSelfTestInstantiate
      end>
    Records = <>
    Synonyms = <>
    UnitName = 'Unit2'
    Variables = <>
    StaticSymbols = False
    Left = 16
    Top = 384
  end
end
