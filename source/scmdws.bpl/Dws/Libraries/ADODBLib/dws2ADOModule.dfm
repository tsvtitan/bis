object dws2ADOLib: Tdws2ADOLib
  OldCreateOrder = False
  Left = 283
  Top = 347
  Height = 200
  Width = 400
  object customADOUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TADOConnection'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'ConnectionString'
                DataType = 'String'
              end>
            OnAssignExternalObject = customADOUnitClassesTADOConnectionConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Open'
            Parameters = <>
            OnEval = customADOUnitClassesTADOConnectionMethodsOpenEval
            Kind = mkProcedure
          end
          item
            Name = 'Close'
            Parameters = <>
            OnEval = customADOUnitClassesTADOConnectionMethodsCloseEval
            Kind = mkProcedure
          end
          item
            Name = 'Execute'
            Parameters = <
              item
                Name = 'sSQL'
                DataType = 'String'
              end>
            ResultType = 'TADODataset'
            OnEval = customADOUnitClassesTADOConnectionMethodsExecuteEval
            Kind = mkFunction
          end
          item
            Name = 'RollbackTrans'
            Parameters = <>
            OnEval = customADOUnitClassesTADOConnectionMethodsRollbackTransEval
            Kind = mkProcedure
          end
          item
            Name = 'BeginTrans'
            Parameters = <>
            OnEval = customADOUnitClassesTADOConnectionMethodsBeginTransEval
            Kind = mkProcedure
          end
          item
            Name = 'CommitTrans'
            Parameters = <>
            OnEval = customADOUnitClassesTADOConnectionMethodsCommitTransEval
            Kind = mkProcedure
          end
          item
            Name = 'Free'
            Parameters = <>
            OnEval = customADOUnitClassesTDatabaseMethodsFreeEval
            Kind = mkDestructor
          end
          item
            Name = 'ExecuteSQL'
            Parameters = <
              item
                Name = 'sSQL'
                DataType = 'String'
              end>
            OnEval = customADOUnitClassesTDatabaseMethodsExecuteEval
            Kind = mkProcedure
          end
          item
            Name = 'GetDataset'
            Parameters = <
              item
                Name = 'sSQL'
                DataType = 'String'
              end>
            ResultType = 'TADODataset'
            OnEval = customADOUnitClassesTADOConnectionMethodsGetRecordsetEval
            Kind = mkFunction
          end
          item
            Name = 'Version'
            Parameters = <>
            ResultType = 'String'
            OnEval = customADOUnitClassesTADOConnectionMethodsVersionEval
            Kind = mkFunction
          end
          item
            Name = 'State'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customADOUnitClassesTADOConnectionMethodsStateEval
            Kind = mkFunction
          end
          item
            Name = 'GetConnectionString'
            Parameters = <>
            ResultType = 'String'
            OnEval = customADOUnitClassesTADOConnectionMethodsGetProviderEval
            Kind = mkFunction
          end
          item
            Name = 'SetConnectionString'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customADOUnitClassesTADOConnectionMethodsSetProviderEval
            Kind = mkProcedure
          end
          item
            Name = 'DatasetCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customADOUnitClassesTADOConnectionMethodsDatasetCountEval
            Kind = mkFunction
          end
          item
            Name = 'SetCommandTimeout'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'integer'
              end>
            OnEval = customADOUnitClassesTADOConnectionMethodsSetCommandTimeoutEval
            Kind = mkProcedure
          end
          item
            Name = 'GetCommandTimeout'
            Parameters = <>
            ResultType = 'integer'
            OnEval = customADOUnitClassesTADOConnectionMethodsGetCommandTimeoutEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'ConnectionString'
            DataType = 'String'
            ReadAccess = 'GetConnectionString'
            WriteAccess = 'SetConnectionString'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'CommandTimeout'
            DataType = 'integer'
            ReadAccess = 'GetCommandTimeout'
            WriteAccess = 'SetCommandTimeout'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TADODataset'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = customADOUnitClassesTADODatasetConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Open'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsOpenEval
            Kind = mkProcedure
          end
          item
            Name = 'First'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customADOUnitClassesTADODatasetMethodsFirstEval
            Kind = mkFunction
          end
          item
            Name = 'Next'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customADOUnitClassesTADODatasetMethodsNextEval
            Kind = mkFunction
          end
          item
            Name = 'FieldByName'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
              end>
            ResultType = 'TDBField'
            OnEval = customADOUnitClassesTDatasetMethodsFieldByNameEval
            Kind = mkFunction
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customADOUnitClassesTADODatasetMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'Last'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customADOUnitClassesTDatasetMethodsLastEval
            Kind = mkFunction
          end
          item
            Name = 'Free'
            Parameters = <>
            OnEval = customADOUnitClassesTDatasetMethodsFreeEval
            Kind = mkDestructor
          end
          item
            Name = 'Close'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsCloseEval
            Kind = mkProcedure
          end
          item
            Name = 'Edit'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsEditEval
            Kind = mkProcedure
          end
          item
            Name = 'Insert'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsInsertEval
            Kind = mkProcedure
          end
          item
            Name = 'Post'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsPostEval
            Kind = mkProcedure
          end
          item
            Name = 'Cancel'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsCancelEval
            Kind = mkProcedure
          end
          item
            Name = 'Delete'
            Parameters = <>
            OnEval = customADOUnitClassesTADODatasetMethodsDeleteEval
            Kind = mkProcedure
          end
          item
            Name = 'SetSQL'
            Parameters = <
              item
                Name = 'sSQL'
                DataType = 'string'
              end>
            OnEval = customADOUnitClassesTDatasetMethodsSetSQLEval
            Kind = mkProcedure
          end
          item
            Name = 'GetSQL'
            Parameters = <>
            ResultType = 'string'
            OnEval = customADOUnitClassesTDatasetMethodsGetSQLEval
            Kind = mkFunction
          end
          item
            Name = 'SetConnection'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'TObject'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetConnectionEval
            Kind = mkProcedure
          end
          item
            Name = 'RecordCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customADOUnitClassesTADODatasetMethodsRecordCountEval
            Kind = mkFunction
          end
          item
            Name = 'SetField'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end
              item
                Name = 'Value'
                DataType = 'TDBField'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetFieldEval
            Kind = mkProcedure
          end
          item
            Name = 'GetField'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'TDBField'
            OnEval = customADOUnitClassesTADODatasetMethodsGetFieldEval
            Kind = mkFunction
          end
          item
            Name = 'FieldCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customADOUnitClassesTADODatasetMethodsFieldCountEval
            Kind = mkFunction
          end
          item
            Name = 'GetHTMLCombo'
            Parameters = <
              item
                Name = 'Selected'
                DataType = 'string'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsGetHTMLComboEval
            Kind = mkProcedure
          end
          item
            Name = 'GetFieldAsString'
            Parameters = <
              item
                Name = 'index'
                DataType = 'variant'
              end>
            ResultType = 'string'
            OnEval = customADOUnitClassesTADODatasetMethodsFieldAsStringEval
            Kind = mkFunction
          end
          item
            Name = 'GetFieldAsDateTime'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'variant'
              end>
            ResultType = 'DateTime'
            OnEval = customADOUnitClassesTADODatasetMethodsFieldAsDateTimeEval
            Kind = mkFunction
          end
          item
            Name = 'GetFieldAsInteger'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end>
            ResultType = 'integer'
            OnEval = customADOUnitClassesTADODatasetMethodsFieldAsIntegerEval
            Kind = mkFunction
          end
          item
            Name = 'GetFieldAsFloat'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end>
            ResultType = 'float'
            OnEval = customADOUnitClassesTADODatasetMethodsFieldAsFloatEval
            Kind = mkFunction
          end
          item
            Name = 'GetFieldAsVariant'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end>
            ResultType = 'variant'
            OnEval = customADOUnitClassesTADODatasetMethodsGetFieldAsVariantEval
            Kind = mkFunction
          end
          item
            Name = 'GetFieldIsNull'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'variant'
              end>
            ResultType = 'boolean'
            OnEval = customADOUnitClassesTADODatasetMethodsGetFieldIsNullEval
            Kind = mkFunction
          end
          item
            Name = 'SetFieldAsString'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end
              item
                Name = 'Value'
                DataType = 'string'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetFieldAsStringEval
            Kind = mkProcedure
          end
          item
            Name = 'SetFieldAsInteger'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetFieldAsIntegerEval
            Kind = mkProcedure
          end
          item
            Name = 'SetFieldAsDateTime'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetFieldAsDateTimeEval
            Kind = mkProcedure
          end
          item
            Name = 'SetFieldAsFloat'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end
              item
                Name = 'Value'
                DataType = 'Float'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetFieldAsFloatEval
            Kind = mkProcedure
          end
          item
            Name = 'SetFieldAsVariant'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetFieldAsVariantEval
            Kind = mkProcedure
          end
          item
            Name = 'SetCommandTimeout'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'integer'
              end>
            OnEval = customADOUnitClassesTADODatasetMethodsSetCommandTimeoutEval
            Kind = mkProcedure
          end
          item
            Name = 'GetCommandTimeout'
            Parameters = <>
            ResultType = 'integer'
            OnEval = customADOUnitClassesTADODatasetMethodsGetCommandTimeoutEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'sql'
            DataType = 'string'
            ReadAccess = 'GetSQL'
            WriteAccess = 'SetSQL'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Connection'
            DataType = 'TObject'
            WriteAccess = 'SetConnection'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Fields'
            DataType = 'TDBField'
            ReadAccess = 'GetField'
            WriteAccess = 'SetField'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'TDBField'
              end>
            IsDefault = False
          end
          item
            Name = 'FieldAsString'
            DataType = 'string'
            ReadAccess = 'GetFieldAsString'
            WriteAccess = 'SetFieldAsString'
            Parameters = <
              item
                Name = 'index'
                DataType = 'variant'
              end>
            IsDefault = False
          end
          item
            Name = 'FieldAsDateTime'
            DataType = 'DateTime'
            ReadAccess = 'GetFieldAsDateTime'
            WriteAccess = 'SetFieldAsDateTime'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'FieldAsInteger'
            DataType = 'Integer'
            ReadAccess = 'GetFieldAsInteger'
            WriteAccess = 'SetFieldAsInteger'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'variant'
              end>
            IsDefault = False
          end
          item
            Name = 'FieldAsFloat'
            DataType = 'Float'
            ReadAccess = 'GetFieldAsFloat'
            WriteAccess = 'SetFieldAsFloat'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end>
            IsDefault = False
          end
          item
            Name = 'FieldAsVariant'
            DataType = 'Variant'
            ReadAccess = 'GetFieldAsVariant'
            WriteAccess = 'SetFieldAsVariant'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Variant'
              end>
            IsDefault = False
          end
          item
            Name = 'FieldIsNull'
            DataType = 'boolean'
            ReadAccess = 'GetFieldIsNull'
            Parameters = <
              item
                Name = 'index'
                DataType = 'variant'
              end>
            IsDefault = False
          end
          item
            Name = 'CommandTimeout'
            DataType = 'integer'
            ReadAccess = 'GetCommandTimeout'
            WriteAccess = 'SetCommandTimeout'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TDBField'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'SetValue'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
              end>
            OnEval = customADOUnitClassesTFieldMethodsSetValueEval
            Kind = mkProcedure
          end
          item
            Name = 'GetValue'
            Parameters = <>
            ResultType = 'variant'
            OnEval = customADOUnitClassesTFieldMethodsGetValueEval
            Kind = mkFunction
          end
          item
            Name = 'SetValueStr'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customADOUnitClassesTFieldMethodsSetValueStrEval
            Kind = mkProcedure
          end
          item
            Name = 'GetValueStr'
            Parameters = <>
            ResultType = 'string'
            OnEval = customADOUnitClassesTFieldMethodsGetValueStrEval
            Kind = mkFunction
          end
          item
            Name = 'SetInteger'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'integer'
              end>
            OnEval = customADOUnitClassesTDBFieldMethodsSetIntegerEval
            Kind = mkProcedure
          end
          item
            Name = 'GetInteger'
            Parameters = <>
            ResultType = 'integer'
            OnEval = customADOUnitClassesTDBFieldMethodsGetIntegerEval
            Kind = mkFunction
          end
          item
            Name = 'SetFloat'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'float'
              end>
            OnEval = customADOUnitClassesTDBFieldMethodsSetFloatEval
            Kind = mkProcedure
          end
          item
            Name = 'GetFloat'
            Parameters = <>
            ResultType = 'Float'
            OnEval = customADOUnitClassesTDBFieldMethodsGetFloatEval
            Kind = mkFunction
          end
          item
            Name = 'SetDateTime'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = customADOUnitClassesTDBFieldMethodsSetDateTimeEval
            Kind = mkProcedure
          end
          item
            Name = 'GetDateTime'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = customADOUnitClassesTDBFieldMethodsGetDateTimeEval
            Kind = mkFunction
          end
          item
            Name = 'IsNull'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customADOUnitClassesTDBFieldMethodsIsNullEval
            Kind = mkFunction
          end
          item
            Name = 'DataType'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customADOUnitClassesTDBFieldMethodsDataTypeEval
            Kind = mkFunction
          end
          item
            Name = 'DataSize'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customADOUnitClassesTDBFieldMethodsDataSizeEval
            Kind = mkFunction
          end
          item
            Name = 'FieldName'
            Parameters = <>
            ResultType = 'String'
            OnEval = customADOUnitClassesTDBFieldMethodsNameEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Value'
            DataType = 'Variant'
            ReadAccess = 'GetValue'
            WriteAccess = 'SetValue'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AsString'
            DataType = 'string'
            ReadAccess = 'GetValueStr'
            WriteAccess = 'SetValueStr'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AsInteger'
            DataType = 'Integer'
            ReadAccess = 'GetInteger'
            WriteAccess = 'SetInteger'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AsFloat'
            DataType = 'Float'
            ReadAccess = 'GetFloat'
            WriteAccess = 'SetFloat'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AsDateTime'
            DataType = 'DateTime'
            ReadAccess = 'GetDateTime'
            WriteAccess = 'SetDateTime'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    UnitName = 'ADO'
    Variables = <>
    Left = 40
    Top = 16
  end
end
