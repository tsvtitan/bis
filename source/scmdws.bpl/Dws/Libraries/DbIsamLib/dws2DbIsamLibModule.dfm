object dws2DbIsamLib: Tdws2DbIsamLib
  OldCreateOrder = False
  Left = 16
  Top = 603
  Height = 115
  Width = 138
  object DbIsamUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TDbIsamQuery'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'DatabaseName'
                DataType = 'String'
              end
              item
                Name = 'SQL'
                DataType = 'String'
              end>
            OnAssignExternalObject = QueryConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'First'
            Parameters = <>
            OnEval = FirstMethod
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            OnEval = NextMethod
            Kind = mkProcedure
          end
          item
            Name = 'Last'
            Parameters = <>
            OnEval = LastMethod
            Kind = mkProcedure
          end
          item
            Name = 'BOF'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = BOFFunction
            Kind = mkFunction
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = EofFunction
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
            OnEval = FieldByNameFunction
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
            OnEval = QueryExecute
            Kind = mkClassProcedure
          end
          item
            Name = 'Locate'
            Parameters = <
              item
                Name = 'KeyFields'
                DataType = 'String'
              end
              item
                Name = 'KeyValues'
                DataType = 'Variant'
              end>
            ResultType = 'Boolean'
            OnEval = LocateFunction
            Kind = mkFunction
          end
          item
            Name = 'Append'
            Parameters = <>
            OnEval = AppendMethod
            Kind = mkProcedure
          end
          item
            Name = 'Insert'
            Parameters = <>
            OnEval = InsertMethod
            Kind = mkProcedure
          end
          item
            Name = 'Edit'
            Parameters = <>
            OnEval = EditMethod
            Kind = mkProcedure
          end
          item
            Name = 'Delete'
            Parameters = <>
            OnEval = DeleteMethod
            Kind = mkProcedure
          end
          item
            Name = 'Cancel'
            Parameters = <>
            OnEval = CancelMethod
            Kind = mkProcedure
          end
          item
            Name = 'Post'
            Parameters = <>
            OnEval = PostMethod
            Kind = mkProcedure
          end
          item
            Name = 'IsEmpty'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = IsEmptyFunction
            Kind = mkFunction
          end
          item
            Name = 'RecNo'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = RecNoFunction
            Kind = mkFunction
          end
          item
            Name = 'RecordCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = RecordCountFunction
            Kind = mkFunction
          end
          item
            Name = 'AsString'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = AsStringMethod
            Kind = mkFunction
          end
          item
            Name = 'AsInteger'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = AsIntegerMethod
            Kind = mkFunction
          end
          item
            Name = 'AsFloat'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'Float'
            OnEval = AsFloatMethod
            Kind = mkFunction
          end
          item
            Name = 'AsBoolean'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            OnEval = AsBooleanMethod
            Kind = mkFunction
          end
          item
            Name = 'Store'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            OnEval = StoreMethod
            Kind = mkProcedure
          end
          item
            Name = 'AsDateTime'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'DateTime'
            OnEval = AsDateTimeMethod
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TDbIsamTable'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'DatabaseName'
                DataType = 'String'
              end
              item
                Name = 'TableName'
                DataType = 'String'
              end>
            OnAssignExternalObject = TableConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'First'
            Parameters = <>
            OnEval = FirstMethod
            Kind = mkProcedure
          end
          item
            Name = 'Last'
            Parameters = <>
            OnEval = LastMethod
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            OnEval = NextMethod
            Kind = mkProcedure
          end
          item
            Name = 'EOF'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = EofFunction
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
            OnEval = FieldByNameFunction
            Kind = mkFunction
          end
          item
            Name = 'GetIndexName'
            Parameters = <>
            ResultType = 'String'
            OnEval = TableGetIndexName
            Kind = mkFunction
          end
          item
            Name = 'SetIndexName'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = TableSetIndexName
            Kind = mkProcedure
          end
          item
            Name = 'GetFilter'
            Parameters = <>
            ResultType = 'String'
            OnEval = TableGetFilter
            Kind = mkFunction
          end
          item
            Name = 'SetFilter'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = TableSetFilter
            Kind = mkProcedure
          end
          item
            Name = 'Locate'
            Parameters = <
              item
                Name = 'KeyFields'
                DataType = 'String'
              end
              item
                Name = 'KeyValues'
                DataType = 'Variant'
              end>
            ResultType = 'Boolean'
            OnEval = LocateFunction
            Kind = mkFunction
          end
          item
            Name = 'Append'
            Parameters = <>
            OnEval = AppendMethod
            Kind = mkProcedure
          end
          item
            Name = 'Insert'
            Parameters = <>
            OnEval = InsertMethod
            Kind = mkProcedure
          end
          item
            Name = 'Edit'
            Parameters = <>
            OnEval = EditMethod
            Kind = mkProcedure
          end
          item
            Name = 'Delete'
            Parameters = <>
            OnEval = DeleteMethod
            Kind = mkProcedure
          end
          item
            Name = 'Cancel'
            Parameters = <>
            OnEval = CancelMethod
            Kind = mkProcedure
          end
          item
            Name = 'Post'
            Parameters = <>
            OnEval = PostMethod
            Kind = mkProcedure
          end
          item
            Name = 'IsEmpty'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = IsEmptyFunction
            Kind = mkFunction
          end
          item
            Name = 'RecNo'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = RecNoFunction
            Kind = mkFunction
          end
          item
            Name = 'RecordCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = RecordCountFunction
            Kind = mkFunction
          end
          item
            Name = 'Prior'
            Parameters = <>
            OnEval = PriorMethod
            Kind = mkProcedure
          end
          item
            Name = 'AsString'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = AsStringMethod
            Kind = mkFunction
          end
          item
            Name = 'AsInteger'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = AsIntegerMethod
            Kind = mkFunction
          end
          item
            Name = 'AsFloat'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'Float'
            OnEval = AsFloatMethod
            Kind = mkFunction
          end
          item
            Name = 'AsBoolean'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            OnEval = AsBooleanMethod
            Kind = mkFunction
          end
          item
            Name = 'BOF'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = BOFFunction
            Kind = mkFunction
          end
          item
            Name = 'Store'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            OnEval = StoreMethod
            Kind = mkProcedure
          end
          item
            Name = 'AsDateTime'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'DateTime'
            OnEval = AsDateTimeMethod
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'IndexName'
            DataType = 'String'
            ReadAccess = 'GetIndexName'
            WriteAccess = 'SetIndexName'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Filter'
            DataType = 'String'
            ReadAccess = 'GetFilter'
            WriteAccess = 'SetFilter'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    UnitName = 'DbIsam'
    Variables = <>
    Left = 20
    Top = 8
  end
end
