object FEvents: TFEvents
  Left = 344
  Top = 131
  Caption = 'DelphiWebScript II - Events Emulation Demo Program'
  ClientHeight = 323
  ClientWidth = 548
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PALeft: TPanel
    Left = 0
    Top = 0
    Width = 337
    Height = 323
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object LBDescription: TLabel
      Left = 4
      Top = 8
      Width = 297
      Height = 65
      AutoSize = False
      Caption = 
        'Demonstrates how to create "event handlers" in DelphiWebScript 1' +
        '.2. The OnChange events of the text field and the listbox in the' +
        ' panel on the right are connected to the corresponding procedure' +
        's below... Have a look at the source code of this demo program!'
      WordWrap = True
    end
    object MSource: TMemo
      Left = 5
      Top = 84
      Width = 327
      Height = 234
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Lines.Strings = (
        'var counter: Integer;'
        ''
        'procedure OnEditChange(Caption: string);'
        'begin'
        
          '  SetTextOutput(Caption + '#39' ('#39' + IntToStr(counter) + '#39' events fi' +
          'red)'#39');'
        '  counter := counter + 1;'
        'end;'
        ''
        'procedure OnListboxChange(Item: string);'
        'begin'
        
          '  SetListboxOutput(Item + '#39' ('#39' + IntToStr(counter) + '#39' events fi' +
          'red)'#39');'
        '  counter := counter + 1;'
        'end;'
        ''
        'counter := 1;')
      TabOrder = 0
      WordWrap = False
    end
  end
  object PARight: TPanel
    Left = 337
    Top = 0
    Width = 211
    Height = 323
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object LBTextTitle: TLabel
      Left = 4
      Top = 8
      Width = 26
      Height = 13
      Caption = 'Text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LBTextOutputTitle: TLabel
      Left = 4
      Top = 60
      Width = 68
      Height = 13
      Caption = 'Text Output'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LBListboxOutputTitle: TLabel
      Left = 4
      Top = 268
      Width = 83
      Height = 13
      Caption = 'Listbox Output'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LBTextOutput: TLabel
      Left = 4
      Top = 76
      Width = 200
      Height = 26
      AutoSize = False
      WordWrap = True
    end
    object LBListboxTitle: TLabel
      Left = 4
      Top = 120
      Width = 41
      Height = 13
      Caption = 'Listbox'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LBListboxOutput: TLabel
      Left = 4
      Top = 284
      Width = 200
      Height = 26
      AutoSize = False
      WordWrap = True
    end
    object EDText: TEdit
      Left = 4
      Top = 24
      Width = 200
      Height = 21
      TabOrder = 0
      OnChange = EDTextChange
    end
    object LBItems: TListBox
      Left = 4
      Top = 136
      Width = 200
      Height = 125
      ItemHeight = 13
      Items.Strings = (
        'France'
        'Switzerland'
        'Italy'
        'Germany'
        'Austria')
      TabOrder = 1
      OnClick = LBItemsClick
    end
  end
  object Script: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 120
    Top = 236
  end
  object dws2Unit: Tdws2Unit
    Script = Script
    Arrays = <>
    Classes = <>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'SetTextOutput'
        Parameters = <
          item
            Name = 'NewCaption'
            DataType = 'String'
          end>
        OnEval = dws2UnitFunctionsSetTextOutputEval
      end
      item
        Name = 'SetListboxOutput'
        Parameters = <
          item
            Name = 'NewCaption'
            DataType = 'String'
          end>
        OnEval = dws2UnitFunctionsSetListboxOutputEval
      end>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'OutputFuncs'
    Variables = <>
    StaticSymbols = False
    Left = 192
    Top = 252
  end
end
