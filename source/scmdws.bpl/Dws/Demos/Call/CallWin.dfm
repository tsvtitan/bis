object Form1: TForm1
  Left = 288
  Top = 104
  Caption = 'DelphiWebScript II Demoprogram - Calling functions '
  ClientHeight = 513
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 249
    Top = 0
    Width = 383
    Height = 513
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      ''
      'procedure Test1(Msg: string);'
      'begin'
      '  ShowMessage(Msg);'
      'end;'
      ''
      'function Test2(Msg: string): string;'
      'begin'
      '  Result := '#39'Hello '#39' + Msg;'
      'end;'
      ''
      'procedure Test3(var Msg: string);'
      'begin'
      '  Msg := '#39'Goodbye '#39' + Msg;'
      'end;'
      ''
      'type'
      '  TStruct = record'
      '    a: array[0..1] of Integer;'
      '    b: Integer;'
      '  end;'
      ''
      'function Test4(Struct: TStruct): TStruct;'
      'begin'
      '  // Swap first and second'
      '  Result.a[0] := Struct.a[1];'
      '  Result.a[1] := Struct.a[0];'
      '  Result.b := '
      '    Struct.a[0] * Struct.a[1] + Struct.b;'
      'end;')
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 249
    Height = 513
    Align = alLeft
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 245
      Top = 1
      Height = 511
      Align = alRight
    end
    object Label1: TLabel
      Left = 8
      Top = 128
      Width = 57
      Height = 13
      Caption = 'Enter a text:'
    end
    object Label2: TLabel
      Left = 8
      Top = 216
      Width = 80
      Height = 13
      Caption = 'Enter your name:'
    end
    object Label3: TLabel
      Left = 8
      Top = 256
      Width = 33
      Height = 13
      Caption = 'Result:'
    end
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 225
      Height = 105
      AutoSize = False
      Caption = 
        'This is a demo of a special feature of DWSII. Instead of running' +
        ' the main program you can also call a single function.'#13#10#13#10'These ' +
        'four examples show how to initialize a DWSII program and how to ' +
        'use the TProgramInfo object.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Button1: TButton
      Left = 8
      Top = 176
      Width = 185
      Height = 25
      Caption = 'Call Function "Test1"'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 144
      Width = 225
      Height = 21
      TabOrder = 1
      Text = 'Hello World!'
    end
    object Button2: TButton
      Left = 8
      Top = 304
      Width = 185
      Height = 25
      Caption = 'Call Function "Test2"'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Edit2: TEdit
      Left = 8
      Top = 232
      Width = 225
      Height = 21
      TabOrder = 3
      Text = 'Donald Duck'
    end
    object Button3: TButton
      Left = 8
      Top = 336
      Width = 185
      Height = 25
      Caption = 'Call Function "Test3"'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Edit3: TEdit
      Left = 8
      Top = 272
      Width = 225
      Height = 21
      TabOrder = 5
    end
    object Button4: TButton
      Left = 8
      Top = 464
      Width = 185
      Height = 25
      Caption = 'Call Function "Test4"'
      TabOrder = 6
      OnClick = Button4Click
    end
    object SpinEdit1: TSpinEdit
      Left = 8
      Top = 384
      Width = 100
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 7
      Value = 2
    end
    object SpinEdit2: TSpinEdit
      Left = 8
      Top = 408
      Width = 100
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 8
      Value = 3
    end
    object SpinEdit3: TSpinEdit
      Left = 8
      Top = 432
      Width = 100
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 9
      Value = 2
    end
    object SpinEdit4: TSpinEdit
      Left = 120
      Top = 384
      Width = 100
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 10
      Value = 0
    end
    object SpinEdit5: TSpinEdit
      Left = 120
      Top = 408
      Width = 100
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 11
      Value = 0
    end
    object SpinEdit6: TSpinEdit
      Left = 120
      Top = 432
      Width = 100
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 12
      Value = 0
    end
  end
  object DelphiWebScriptII: TDelphiWebScriptII
    Config.CompilerOptions = [coOptimize]
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 352
    Top = 32
  end
  object dws2GUIFunctions1: Tdws2GUIFunctions
    Left = 448
    Top = 8
  end
end
