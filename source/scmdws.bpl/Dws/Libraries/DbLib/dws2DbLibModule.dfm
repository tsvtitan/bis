object dws2DbLib: Tdws2DbLib
  OldCreateOrder = False
  Left = 386
  Top = 240
  Height = 135
  Width = 150
  object dws2Unit1: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TQuery'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'Alias'
                DataType = 'String'
              end
              item
                Name = 'Sql'
                DataType = 'String'
              end>
            OnAssignExternalObject = dws2Unit1ClassesTQueryConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2Unit1ClassesTQueryMethodsDestroyEval
            Kind = mkDestructor
          end
          item
            Name = 'First'
            Parameters = <>
            OnEval = dws2Unit1ClassesTQueryMethodsFirstEval
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            OnEval = dws2Unit1ClassesTQueryMethodsNextEval
            Kind = mkProcedure
          end
          item
            Name = 'Last'
            Parameters = <>
            OnEval = dws2Unit1ClassesTQueryMethodsLastEval
            Kind = mkProcedure
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2Unit1ClassesTQueryMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'FieldByName'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            ResultType = 'Variant'
            OnEval = dws2Unit1ClassesTQueryMethodsFieldByNameEval
            Kind = mkFunction
          end
          item
            Name = 'Execute'
            Parameters = <
              item
                Name = 'Alias'
                DataType = 'String'
              end
              item
                Name = 'Sql'
                DataType = 'String'
              end>
            OnEval = dws2Unit1ClassesTQueryMethodsExecuteEval
            Kind = mkClassProcedure
          end
          item
            Name = 'FieldCount'
            Parameters = <>
            ResultType = 'Variant'
            OnEval = dws2Unit1ClassesTQueryMethodsFieldCountEval
            Kind = mkFunction
          end
          item
            Name = 'DisplayName'
            Parameters = <
              item
                Name = 'i'
                DataType = 'Integer'
              end>
            ResultType = 'Variant'
            OnEval = dws2Unit1ClassesTQueryMethodsDisplayNameEval
            Kind = mkFunction
          end
          item
            Name = 'FieldValue'
            Parameters = <
              item
                Name = 'i'
                DataType = 'Integer'
              end>
            ResultType = 'Variant'
            OnEval = dws2Unit1ClassesTQueryMethodsFieldValueEval
            Kind = mkFunction
          end>
        Properties = <>
      end>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    UnitName = 'Db'
    Variables = <>
    Left = 44
    Top = 8
  end
end
