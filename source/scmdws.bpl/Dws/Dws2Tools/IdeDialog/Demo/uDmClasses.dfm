object dmClasses: TdmClasses
  OldCreateOrder = False
  Left = 590
  Top = 185
  Height = 175
  Width = 203
  object dwsTemp: TDelphiWebScriptII
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 80
    Top = 16
  end
  object dwsClasses: Tdws2Unit
    Script = dwsTemp
    Arrays = <
      item
        Name = 'TMyArray'
        DataType = 'Integer'
        LowBound = 0
        HighBound = 2
      end>
    Classes = <
      item
        Name = 'TList'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dwsClassesClassesTListConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dwsClassesClassesTListMethodsDestroyEval
            Kind = mkDestructor
          end
          item
            Name = 'Add'
            Parameters = <
              item
                Name = 'Obj'
                DataType = 'TObject'
              end>
            ResultType = 'Integer'
            OnEval = dwsClassesClassesTListMethodsAddEval
            Kind = mkFunction
          end
          item
            Name = 'Get'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'TObject'
            OnEval = dwsClassesClassesTListMethodsGetEval
            Kind = mkFunction
          end
          item
            Name = 'Clear'
            Parameters = <>
            OnEval = dwsClassesClassesTListMethodsClearEval
            Kind = mkProcedure
          end
          item
            Name = 'GetCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dwsClassesClassesTListMethodsGetCountEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Count'
            DataType = 'Integer'
            ReadAccess = 'GetCount'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TStrings'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dwsClassesClassesTStringsConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Add'
            Parameters = <
              item
                Name = 's'
                DataType = 'String'
              end>
            OnEval = dwsClassesClassesTStringsMethodsAddEval
            Kind = mkProcedure
          end
          item
            Name = 'Get'
            Parameters = <
              item
                Name = 'x'
                DataType = 'Integer'
              end>
            ResultType = 'string'
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TField'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'AsString'
            Parameters = <>
            ResultType = 'String'
            OnEval = dwsClassesClassesTFieldMethodsAsStringEval
            Kind = mkFunction
          end
          item
            Name = 'AsInteger'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dwsClassesClassesTFieldMethodsAsIntegerEval
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TWindow'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'Left'
                DataType = 'Integer'
              end
              item
                Name = 'Top'
                DataType = 'Integer'
              end
              item
                Name = 'Caption'
                DataType = 'String'
              end>
            OnEval = dwsClassesClassesTWindowConstructorsCreateEval
            OnAssignExternalObject = dwsClassesClassesTWindowConstructorsCreateAssignExternalObject
          end>
        Fields = <
          item
            Name = 'Left'
            DataType = 'Integer'
          end
          item
            Name = 'Top'
            DataType = 'Integer'
          end
          item
            Name = 'Width'
            DataType = 'Integer'
          end
          item
            Name = 'Height'
            DataType = 'Integer'
          end
          item
            Name = 'Caption'
            DataType = 'String'
          end>
        Methods = <
          item
            Name = 'SetCaption'
            Parameters = <
              item
                Name = 's'
                DataType = 'String'
              end>
            OnEval = dwsClassesClassesTWindowMethodsSetCaptionEval
            Kind = mkProcedure
          end
          item
            Name = 'SetPosition'
            Parameters = <
              item
                Name = 'Left'
                DataType = 'Integer'
              end
              item
                Name = 'Top'
                DataType = 'Integer'
              end>
            OnEval = dwsClassesClassesTWindowMethodsSetPositionEval
            Kind = mkProcedure
          end
          item
            Name = 'SetSize'
            Parameters = <
              item
                Name = 'Width'
                DataType = 'Integer'
              end
              item
                Name = 'Height'
                DataType = 'Integer'
              end>
            OnEval = dwsClassesClassesTWindowMethodsSetSizeEval
            Kind = mkProcedure
          end
          item
            Name = 'Update'
            Parameters = <>
            OnEval = dwsClassesClassesTWindowMethodsUpdateEval
            Kind = mkProcedure
          end
          item
            Name = 'SetParams'
            Parameters = <
              item
                Name = 'params'
                DataType = 'TWindowParams'
              end>
            OnEval = dwsClassesClassesTWindowMethodsSetParamsEval
            Kind = mkProcedure
          end
          item
            Name = 'VarParamTest'
            Parameters = <
              item
                Name = 'a'
                DataType = 'Integer'
                IsVarParam = True
              end
              item
                Name = 'b'
                DataType = 'Integer'
                IsVarParam = True
              end>
            OnEval = dwsClassesClassesTWindowMethodsVarParamTestEval
            Kind = mkProcedure
          end
          item
            Name = 'UseVarParamTest'
            Parameters = <>
            OnEval = dwsClassesClassesTWindowMethodsUseVarParamTestEval
            Kind = mkProcedure
          end
          item
            Name = 'NewInstance'
            Parameters = <>
            ResultType = 'TObject'
            OnEval = dwsClassesClassesTWindowMethodsNewInstanceEval
            Kind = mkFunction
          end
          item
            Name = 'free'
            Parameters = <>
            OnEval = dwsClassesClassesTWindowMethodsfreeEval
            Kind = mkDestructor
          end>
        Properties = <>
      end
      item
        Name = 'TFields'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnEval = dwsClassesClassesTFieldsConstructorsCreateEval
            OnAssignExternalObject = dwsClassesClassesTFieldsConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'GetField'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = dwsClassesClassesTFieldsMethodsGetFieldEval
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TQuery'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'Db'
                DataType = 'String'
              end
              item
                Name = 'Query'
                DataType = 'String'
              end>
            OnAssignExternalObject = dwsClassesClassesTQueryConstructorsCreateAssignExternalObject
          end>
        Fields = <
          item
            Name = 'FFields'
            DataType = 'TFields'
          end>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dwsClassesClassesTQueryMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'First'
            Parameters = <>
            OnEval = dwsClassesClassesTQueryMethodsFirstEval
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            OnEval = dwsClassesClassesTQueryMethodsNextEval
            Kind = mkProcedure
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dwsClassesClassesTQueryMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'FieldByName'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'TField'
            OnEval = dwsClassesClassesTQueryMethodsFieldByNameEval
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'Tpippo'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dwsClassesClassesTpippoConstructorsCreateAssignExternalObject
          end
          item
            Name = 'assignDelphiObject'
            Parameters = <>
          end>
        Fields = <>
        Methods = <
          item
            Name = 'ReadUno'
            Parameters = <>
            ResultType = 'String'
            OnEval = dwsClassesClassesTpippoMethodsReadUnoEval
            Kind = mkFunction
          end
          item
            Name = 'ReadDue'
            Parameters = <>
            ResultType = 'String'
            OnEval = dwsClassesClassesTpippoMethodsReadDueEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'uno'
            DataType = 'String'
            ReadAccess = 'ReadUno'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'due'
            DataType = 'String'
            ReadAccess = 'ReadDue'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <
      item
        Name = 'BirthDay'
        DataType = 'DateTime'
        Value = 27913.0020833333d
      end>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <
      item
        Name = 'TField'
      end>
    Functions = <
      item
        Name = 'Input'
        Parameters = <
          item
            Name = 'title'
            DataType = 'String'
          end
          item
            Name = 'prompt'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dwsClassesFunctionsInputEval
      end>
    Instances = <
      item
        Name = 'qPippo'
        DataType = 'TQuery'
      end>
    Records = <
      item
        Name = 'TPoint'
        Members = <
          item
            Name = 'x'
            DataType = 'Integer'
          end
          item
            Name = 'y'
            DataType = 'Integer'
          end>
      end
      item
        Name = 'TWindowParams'
        Members = <
          item
            Name = 'Left'
            DataType = 'Integer'
          end
          item
            Name = 'Top'
            DataType = 'Integer'
          end
          item
            Name = 'Height'
            DataType = 'Integer'
          end
          item
            Name = 'Width'
            DataType = 'Integer'
          end
          item
            Name = 'Caption'
            DataType = 'String'
          end>
      end
      item
        Name = 'TTestRec'
        Members = <
          item
            Name = 'a'
            DataType = 'TObject'
          end
          item
            Name = 'p'
            DataType = 'TPoint'
          end>
      end>
    Synonyms = <>
    UnitName = 'dwsClasses'
    Variables = <
      item
        Name = 'global'
        DataType = 'String'
      end
      item
        Name = 'Caption'
        DataType = 'String'
      end>
    Left = 20
    Top = 16
  end
end
