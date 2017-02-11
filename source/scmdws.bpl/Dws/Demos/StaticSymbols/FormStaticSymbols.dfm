object Form1: TForm1
  Left = 572
  Top = 195
  Caption = 'Static Symbols Demo'
  ClientHeight = 253
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LabelMemory: TLabel
    Left = 13
    Top = 169
    Width = 37
    Height = 13
    Caption = 'Memory'
  end
  object LabelTime: TLabel
    Left = 13
    Top = 189
    Width = 23
    Height = 13
    Caption = 'Time'
  end
  object LabelProgramCount: TLabel
    Left = 13
    Top = 150
    Width = 44
    Height = 13
    Caption = 'Programs'
  end
  object LabelProgramCountValue: TLabel
    Left = 78
    Top = 150
    Width = 3
    Height = 13
  end
  object LabelMemoryValue: TLabel
    Left = 78
    Top = 169
    Width = 3
    Height = 13
  end
  object LabelTimeValue: TLabel
    Left = 78
    Top = 189
    Width = 3
    Height = 13
  end
  object LabelRunTimeValue: TLabel
    Left = 161
    Top = 189
    Width = 3
    Height = 13
  end
  object ButtonCompile: TButton
    Left = 85
    Top = 117
    Width = 60
    Height = 20
    Caption = 'Compile'
    TabOrder = 0
    OnClick = ButtonCompileClick
  end
  object ButtonRelease: TButton
    Left = 13
    Top = 117
    Width = 61
    Height = 20
    Caption = 'Release'
    TabOrder = 1
    OnClick = ButtonReleaseClick
  end
  object CheckBoxStatic: TCheckBox
    Left = 13
    Top = 98
    Width = 118
    Height = 13
    Caption = 'Static Unit Symbols'
    TabOrder = 2
    OnClick = CheckBoxStaticClick
  end
  object RadioGroupProgramCount: TRadioGroup
    Left = 13
    Top = 52
    Width = 209
    Height = 40
    Caption = ' Programs '
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      '1'
      '10'
      '100'
      '1000')
    TabOrder = 3
  end
  object RadioGroupStackChunkSize: TRadioGroup
    Left = 13
    Top = 7
    Width = 209
    Height = 39
    Caption = 'StackChunkSize'
    Columns = 3
    ItemIndex = 2
    Items.Strings = (
      '1'
      '1024'
      '4096')
    TabOrder = 4
    OnClick = RadioGroupStackChunkSizeClick
  end
  object ButtonRun: TButton
    Left = 156
    Top = 117
    Width = 61
    Height = 20
    Caption = 'Run'
    TabOrder = 5
    OnClick = ButtonRunClick
  end
  object DelphiWebScriptII1: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 112
    Top = 56
  end
  object dws2FileFunctions1: Tdws2FileFunctions
    Left = 208
    Top = 64
  end
  object dws2GUIFunctions1: Tdws2GUIFunctions
    Left = 176
    Top = 24
  end
  object dws2GlobalVarsFunctions1: Tdws2GlobalVarsFunctions
    Left = 200
    Top = 160
  end
  object dws2Unit1: Tdws2Unit
    Script = DelphiWebScriptII1
    Arrays = <>
    Classes = <
      item
        Name = 'A'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'SetA'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetA'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetB'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetB'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetC'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetC'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetD'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetD'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetE'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetE'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetF'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetF'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetG'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetG'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetH'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetH'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetI'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetI'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetJ'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetJ'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetK'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetK'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetL'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetL'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetM'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetM'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetN'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetN'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetO'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetO'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetP'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetP'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetQ'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetQ'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetR'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetR'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetS'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetS'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetT'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetT'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetU'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetU'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetV'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetV'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetW'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetW'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetX'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetX'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetY'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetY'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end
          item
            Name = 'SetZ'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            Kind = mkClassProcedure
          end
          item
            Name = 'GetZ'
            Parameters = <>
            ResultType = 'Variant'
            Kind = mkClassFunction
          end>
        Properties = <
          item
            Name = 'A'
            DataType = 'Variant'
            ReadAccess = 'GetA'
            WriteAccess = 'SetA'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'B'
            DataType = 'Variant'
            ReadAccess = 'GetB'
            WriteAccess = 'SetB'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'C'
            DataType = 'Variant'
            ReadAccess = 'GetC'
            WriteAccess = 'SetC'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'D'
            DataType = 'Variant'
            ReadAccess = 'GetD'
            WriteAccess = 'SetD'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'E'
            DataType = 'Variant'
            ReadAccess = 'GetE'
            WriteAccess = 'SetE'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'F'
            DataType = 'Variant'
            ReadAccess = 'GetF'
            WriteAccess = 'SetF'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'G'
            DataType = 'Variant'
            ReadAccess = 'GetG'
            WriteAccess = 'SetG'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'H'
            DataType = 'Variant'
            ReadAccess = 'GetH'
            WriteAccess = 'SetH'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'I'
            DataType = 'Variant'
            ReadAccess = 'GetI'
            WriteAccess = 'SetI'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'J'
            DataType = 'Variant'
            ReadAccess = 'GetJ'
            WriteAccess = 'SetJ'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'K'
            DataType = 'Variant'
            ReadAccess = 'GetK'
            WriteAccess = 'SetK'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'L'
            DataType = 'Variant'
            ReadAccess = 'GetL'
            WriteAccess = 'SetL'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'M'
            DataType = 'Variant'
            ReadAccess = 'GetM'
            WriteAccess = 'SetM'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'N'
            DataType = 'Variant'
            ReadAccess = 'GetN'
            WriteAccess = 'SetN'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'O'
            DataType = 'Variant'
            ReadAccess = 'GetO'
            WriteAccess = 'SetO'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'P'
            DataType = 'Variant'
            ReadAccess = 'GetP'
            WriteAccess = 'SetP'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Q'
            DataType = 'Variant'
            ReadAccess = 'GetQ'
            WriteAccess = 'SetQ'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'R'
            DataType = 'Variant'
            ReadAccess = 'GetR'
            WriteAccess = 'SetR'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'S'
            DataType = 'Variant'
            ReadAccess = 'GetS'
            WriteAccess = 'SetS'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'T'
            DataType = 'Variant'
            ReadAccess = 'GetT'
            WriteAccess = 'SetT'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'U'
            DataType = 'Variant'
            ReadAccess = 'GetU'
            WriteAccess = 'SetU'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'V'
            DataType = 'Variant'
            ReadAccess = 'GetV'
            WriteAccess = 'SetV'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'W'
            DataType = 'Variant'
            ReadAccess = 'GetW'
            WriteAccess = 'SetW'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'X'
            DataType = 'Variant'
            ReadAccess = 'GetX'
            WriteAccess = 'SetX'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Y'
            DataType = 'Variant'
            ReadAccess = 'GetY'
            WriteAccess = 'SetY'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Z'
            DataType = 'Variant'
            ReadAccess = 'GetZ'
            WriteAccess = 'SetZ'
            Parameters = <>
            IsDefault = False
          end>
        Events = <>
      end>
    Constants = <>
    Dependencies.Strings = (
      'YourUnit')
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'MyUnit'
    Variables = <>
    StaticSymbols = False
    Left = 72
    Top = 112
  end
  object dws2ComConnector1: Tdws2ComConnector
    Script = DelphiWebScriptII1
    StaticSymbols = False
    Left = 176
    Top = 112
  end
  object dws2Unit2: Tdws2Unit
    Script = DelphiWebScriptII1
    Arrays = <>
    Classes = <>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'YourUnit'
    Variables = <>
    StaticSymbols = False
    Left = 32
    Top = 48
  end
  object dws2SimpleDebugger1: Tdws2SimpleDebugger
    Left = 88
    Top = 200
  end
end
