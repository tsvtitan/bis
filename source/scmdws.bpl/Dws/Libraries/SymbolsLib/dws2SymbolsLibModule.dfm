object dws2SymbolsLib: Tdws2SymbolsLib
  OldCreateOrder = False
  Left = 285
  Top = 161
  Height = 479
  Width = 741
  object dws2Unit1: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TSymbols'
        Constructors = <
          item
            Name = 'CreateMain'
            Parameters = <>
            OnAssignExternalObject = dws2Unit1ClassesTSymbolsConstructorsCreateMainAssignExternalObject
          end
          item
            Name = 'CreateUnit'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            OnAssignExternalObject = dws2Unit1ClassesTSymbolsConstructorsCreateUnitAssignExternalObject
          end
          item
            Name = 'CreateUid'
            Parameters = <
              item
                Name = 'Uid'
                DataType = 'String'
              end>
            OnAssignExternalObject = dws2Unit1ClassesTSymbolsConstructorsCreateUidAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2Unit1ClassesTSymbolsMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'First'
            Parameters = <>
            OnEval = dws2Unit1ClassesTSymbolsMethodsFirstEval
            Kind = mkProcedure
          end
          item
            Name = 'Last'
            Parameters = <>
            OnEval = dws2Unit1ClassesTSymbolsMethodsLastEval
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            OnEval = dws2Unit1ClassesTSymbolsMethodsNextEval
            Kind = mkProcedure
          end
          item
            Name = 'Previous'
            Parameters = <>
            OnEval = dws2Unit1ClassesTSymbolsMethodsPreviousEval
            Kind = mkProcedure
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2Unit1ClassesTSymbolsMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'Name'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2Unit1ClassesTSymbolsMethodsNameEval
            Kind = mkFunction
          end
          item
            Name = 'Caption'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2Unit1ClassesTSymbolsMethodsCaptionEval
            Kind = mkFunction
          end
          item
            Name = 'Description'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2Unit1ClassesTSymbolsMethodsDescriptionEval
            Kind = mkFunction
          end
          item
            Name = 'SymbolType'
            Parameters = <>
            ResultType = 'TSymbolType'
            OnEval = dws2Unit1ClassesTSymbolsMethodsSymbolTypeEval
            Kind = mkFunction
          end
          item
            Name = 'GetMembers'
            Parameters = <>
            ResultType = 'TSymbols'
            OnEval = dws2Unit1ClassesTSymbolsMethodsGetMembersEval
            Kind = mkFunction
          end
          item
            Name = 'GetParameters'
            Parameters = <>
            ResultType = 'TSymbols'
            OnEval = dws2Unit1ClassesTSymbolsMethodsGetParametersEval
            Kind = mkFunction
          end
          item
            Name = 'GetSuperClass'
            Parameters = <>
            ResultType = 'TSymbols'
            OnEval = dws2Unit1ClassesTSymbolsMethodsGetSuperClassEval
            Kind = mkFunction
          end
          item
            Name = 'Locate'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            OnEval = dws2Unit1ClassesTSymbolsMethodsLocateEval
            Kind = mkFunction
          end>
        Properties = <>
      end>
    Constants = <>
    Dependencies.Strings = (
      'Classes')
    Enumerations = <
      item
        Name = 'TSymbolType'
        Elements = <
          item
            Name = 'stUnknown'
            UserDefValue = -1
            IsUserDef = True
          end
          item
            Name = 'stArray'
            UserDefValue = 0
            IsUserDef = True
          end
          item
            Name = 'stAlias'
            UserDefValue = 1
            IsUserDef = True
          end
          item
            Name = 'stClass'
            UserDefValue = 2
            IsUserDef = True
          end
          item
            Name = 'stConstant'
            UserDefValue = 3
            IsUserDef = True
          end
          item
            Name = 'stField'
            UserDefValue = 4
            IsUserDef = True
          end
          item
            Name = 'stFunction'
            UserDefValue = 5
            IsUserDef = True
          end
          item
            Name = 'stMember'
            UserDefValue = 6
            IsUserDef = True
          end
          item
            Name = 'stParam'
            UserDefValue = 7
            IsUserDef = True
          end
          item
            Name = 'stProperty'
            UserDefValue = 8
            IsUserDef = True
          end
          item
            Name = 'stRecord'
            UserDefValue = 9
            IsUserDef = True
          end
          item
            Name = 'stUnit'
            UserDefValue = 10
            IsUserDef = True
          end
          item
            Name = 'stVariable'
            UserDefValue = 11
            IsUserDef = True
          end>
      end>
    Forwards = <
      item
        Name = 'TSymbols'
      end>
    Functions = <>
    Instances = <>
    Records = <>
    UnitName = 'Symbols'
    Variables = <>
    Left = 12
    Top = 8
  end
end
