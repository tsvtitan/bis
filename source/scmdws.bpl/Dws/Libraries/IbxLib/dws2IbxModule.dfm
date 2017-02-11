object dws2IBXLib: Tdws2IBXLib
  OldCreateOrder = False
  Left = 480
  Top = 259
  Height = 105
  Width = 238
  object customIBXUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TDatabase'
        Ancestor = 'TObject'
        Constructors = <
          item
            Name = 'create'
            Parameters = <
              item
                Name = 'database'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'user'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'pwd'
                DataType = 'String'
                IsWritable = False
              end>
            OnAssignExternalObject = customIBXUnitClassesTDatabaseConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'connect'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatabaseMethodsconnectEval
            Kind = mkProcedure
          end
          item
            Name = 'disconnect'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatabaseMethodsdisconnectEval
            Kind = mkProcedure
          end
          item
            Name = 'getcharset'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBXUnitClassesTDatabaseMethodsgetcharsetEval
            Kind = mkFunction
          end
          item
            Name = 'getdialect'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBXUnitClassesTDatabaseMethodsgetdialectEval
            Kind = mkFunction
          end
          item
            Name = 'setcharset'
            Parameters = <
              item
                Name = 'sCharset'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTDatabaseMethodssetcharsetEval
            Kind = mkProcedure
          end
          item
            Name = 'setdialect'
            Parameters = <
              item
                Name = 'iDialect'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTDatabaseMethodssetdialectEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'charset'
            DataType = 'String'
            ReadAccess = 'getcharset'
            WriteAccess = 'setcharset'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'dialect'
            DataType = 'Integer'
            ReadAccess = 'getdialect'
            WriteAccess = 'setdialect'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TCustomDBField'
        Ancestor = 'TObject'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'GetValue'
            Parameters = <>
            ResultType = 'Variant'
            Attributes = [maVirtual]
            Kind = mkFunction
          end
          item
            Name = 'GetValueStr'
            Parameters = <>
            ResultType = 'String'
            Attributes = [maVirtual]
            Kind = mkFunction
          end
          item
            Name = 'SetValue'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
                IsWritable = False
              end>
            Attributes = [maVirtual]
            Kind = mkProcedure
          end
          item
            Name = 'SetValueStr'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            Attributes = [maVirtual]
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'AsString'
            DataType = 'String'
            ReadAccess = 'GetValueStr'
            WriteAccess = 'SetValueStr'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TDBField'
        Ancestor = 'TCustomDBField'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'GetDateTime'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = customIBXUnitClassesTDBFieldMethodsGetDateTimeEval
            Kind = mkFunction
          end
          item
            Name = 'GetFloat'
            Parameters = <>
            ResultType = 'Float'
            OnEval = customIBXUnitClassesTDBFieldMethodsGetFloatEval
            Kind = mkFunction
          end
          item
            Name = 'GetInteger'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBXUnitClassesTDBFieldMethodsGetIntegerEval
            Kind = mkFunction
          end
          item
            Name = 'SetDateTime'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTDBFieldMethodsSetDateTimeEval
            Kind = mkProcedure
          end
          item
            Name = 'SetFloat'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Float'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTDBFieldMethodsSetFloatEval
            Kind = mkProcedure
          end
          item
            Name = 'SetInteger'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTDBFieldMethodsSetIntegerEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'AsDateTime'
            DataType = 'DateTime'
            ReadAccess = 'GetDateTime'
            WriteAccess = 'SetDateTime'
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
            Name = 'AsInteger'
            DataType = 'Integer'
            ReadAccess = 'GetInteger'
            WriteAccess = 'SetInteger'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AsString'
            DataType = 'String'
            ReadAccess = 'GetValueStr'
            WriteAccess = 'SetValueStr'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Value'
            DataType = 'Variant'
            ReadAccess = 'GetValue'
            WriteAccess = 'SetValue'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TLUField'
        Ancestor = 'TCustomDBField'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'GetDateTime'
            Parameters = <>
            ResultType = 'DateTime'
            Kind = mkFunction
          end
          item
            Name = 'GetFloat'
            Parameters = <>
            ResultType = 'Float'
            Kind = mkFunction
          end
          item
            Name = 'GetInteger'
            Parameters = <>
            ResultType = 'Integer'
            Kind = mkFunction
          end
          item
            Name = 'GetValue'
            Parameters = <>
            ResultType = 'Variant'
            OnEval = customIBXUnitClassesTLUFieldMethodsGetValueEval
            Attributes = [maOverride]
            Kind = mkFunction
          end
          item
            Name = 'GetValueStr'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBXUnitClassesTLUFieldMethodsGetValueStrEval
            Attributes = [maOverride]
            Kind = mkFunction
          end
          item
            Name = 'SetDateTime'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
                IsWritable = False
              end>
            Kind = mkProcedure
          end
          item
            Name = 'SetFloat'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Float'
                IsWritable = False
              end>
            Kind = mkProcedure
          end
          item
            Name = 'SetInteger'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
                IsWritable = False
              end>
            Kind = mkProcedure
          end
          item
            Name = 'SetValue'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Variant'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTLUFieldMethodsSetValueEval
            Attributes = [maOverride]
            Kind = mkProcedure
          end
          item
            Name = 'SetValueStr'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTLUFieldMethodsSetValueStrEval
            Attributes = [maOverride]
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'AsDateTime'
            DataType = 'DateTime'
            ReadAccess = 'GetDateTime'
            WriteAccess = 'SetDateTime'
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
            Name = 'AsInteger'
            DataType = 'Integer'
            ReadAccess = 'GetInteger'
            WriteAccess = 'SetInteger'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AsString'
            DataType = 'String'
            ReadAccess = 'GetValueStr'
            WriteAccess = 'SetValueStr'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Value'
            DataType = 'Variant'
            ReadAccess = 'GetValue'
            WriteAccess = 'SetValue'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TMLUField'
        Constructors = <
          item
            Name = 'create'
            Parameters = <
              item
                Name = 'DataSet'
                DataType = 'TDataset'
                IsWritable = False
              end
              item
                Name = 'MLUFieldName'
                DataType = 'String'
                IsWritable = False
              end>
          end>
        Fields = <>
        Methods = <
          item
            Name = 'free'
            Parameters = <>
            Kind = mkDestructor
          end
          item
            Name = 'GetValue'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'String'
            Kind = mkFunction
          end
          item
            Name = 'SetNameValue'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            Kind = mkProcedure
          end>
        Properties = <>
      end
      item
        Name = 'TStatement'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = customIBXUnitClassesTStatementConstructorsCreateAssignExternalObject
          end
          item
            Name = 'CreateFromDB'
            Parameters = <
              item
                Name = 'database'
                DataType = 'TDatabase'
                IsWritable = False
              end>
            Attributes = [maVirtual]
            OnAssignExternalObject = customIBXUnitClassesTStatementConstructorsCreateFromDBAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Execute'
            Parameters = <>
            OnEval = customIBXUnitClassesTStatementMethodsExecuteEval
            Kind = mkProcedure
          end
          item
            Name = 'Field'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Variant'
            OnEval = customIBXUnitClassesTStatementMethodsFieldEval
            Kind = mkFunction
          end
          item
            Name = 'FieldByName'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'TDBField'
            OnEval = customIBXUnitClassesTStatementMethodsFieldByNameEval
            Kind = mkFunction
          end
          item
            Name = 'FieldIsNull'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTStatementMethodsFieldIsNullEval
            Kind = mkFunction
          end
          item
            Name = 'Free'
            Parameters = <>
            Kind = mkDestructor
          end
          item
            Name = 'GetSQL'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBXUnitClassesTStatementMethodsGetSQLEval
            Kind = mkFunction
          end
          item
            Name = 'Open'
            Parameters = <>
            Attributes = [maVirtual]
            Kind = mkProcedure
          end
          item
            Name = 'ParamByName'
            Parameters = <
              item
                Name = 'ParamName'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'TDBField'
            OnEval = customIBXUnitClassesTStatementMethodsParamByNameEval
            Kind = mkFunction
          end
          item
            Name = 'SetParam'
            Parameters = <
              item
                Name = 'ParamName'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'Variant'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTStatementMethodsSetParamEval
            Kind = mkProcedure
          end
          item
            Name = 'SetSQL'
            Parameters = <
              item
                Name = 'sSQL'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTStatementMethodsSetSQLEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'SQL'
            DataType = 'String'
            ReadAccess = 'GetSQL'
            WriteAccess = 'SetSQL'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TDataset'
        Ancestor = 'TStatement'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = customIBXUnitClassesTDatasetConstructorsCreateAssignExternalObject
          end
          item
            Name = 'CreateFromDB'
            Parameters = <
              item
                Name = 'Database'
                DataType = 'TDatabase'
                IsWritable = False
              end>
            Attributes = [maOverride]
            OnAssignExternalObject = customIBXUnitClassesTDatasetConstructorsCreateFromDBAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Cancel'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsCancelEval
            Kind = mkProcedure
          end
          item
            Name = 'Close'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsCloseEval
            Kind = mkProcedure
          end
          item
            Name = 'Delete'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsDeleteEval
            Kind = mkProcedure
          end
          item
            Name = 'Edit'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsEditEval
            Kind = mkProcedure
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTDatasetMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'First'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTDatasetMethodsFirstEval
            Kind = mkFunction
          end
          item
            Name = 'Insert'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsInsertEval
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTDatasetMethodsNextEval
            Kind = mkFunction
          end
          item
            Name = 'Open'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsOpenEval
            Attributes = [maOverride]
            Kind = mkProcedure
          end
          item
            Name = 'Post'
            Parameters = <>
            OnEval = customIBXUnitClassesTDatasetMethodsPostEval
            Kind = mkProcedure
          end>
        Properties = <>
      end
      item
        Name = 'TQuery'
        Ancestor = 'TDataset'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = customIBXUnitClassesTQueryConstructorsCreateAssignExternalObject
          end
          item
            Name = 'CreateFromDB'
            Parameters = <
              item
                Name = 'DataBase'
                DataType = 'TDatabase'
                IsWritable = False
              end>
            Attributes = [maOverride]
            OnAssignExternalObject = customIBXUnitClassesTQueryConstructorsCreateFromDBAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'SetSortOrder'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTQueryMethodsSetSortOrderEval
            Kind = mkProcedure
          end
          item
            Name = 'GetFilter'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBXUnitClassesTQueryMethodsGetFilterEval
            Kind = mkFunction
          end
          item
            Name = 'GetFiltered'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTQueryMethodsGetFilteredEval
            Kind = mkFunction
          end
          item
            Name = 'GetSortOrder'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBXUnitClassesTQueryMethodsGetSortOrderEval
            Kind = mkFunction
          end
          item
            Name = 'LookUp'
            Parameters = <
              item
                Name = 'KeyFieldValue'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'TCustomDBField'
            OnEval = customIBXUnitClassesTQueryMethodsLookUpEval
            Kind = mkFunction
          end
          item
            Name = 'Prior'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTQueryMethodsPriorEval
            Kind = mkFunction
          end
          item
            Name = 'SetFilter'
            Parameters = <
              item
                Name = 'FilterStr'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTQueryMethodsSetFilterEval
            Kind = mkProcedure
          end
          item
            Name = 'SetFiltered'
            Parameters = <
              item
                Name = 'Filtered'
                DataType = 'Boolean'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTQueryMethodsSetFilteredEval
            Kind = mkProcedure
          end
          item
            Name = 'SetLookUpFields'
            Parameters = <
              item
                Name = 'KeyFieldName'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'LUfieldName'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTQueryMethodsSetLookUpFieldsEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'Filter'
            DataType = 'String'
            ReadAccess = 'GetFilter'
            WriteAccess = 'SetFilter'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Filtered'
            DataType = 'Boolean'
            ReadAccess = 'GetFiltered'
            WriteAccess = 'SetFiltered'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SortOrder'
            DataType = 'Integer'
            ReadAccess = 'GetSortOrder'
            WriteAccess = 'SetSortOrder'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TDataSetGrp'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'dataSet'
                DataType = 'TDataset'
                IsWritable = False
              end
              item
                Name = 'groupFieldName'
                DataType = 'String'
                IsWritable = False
              end>
            OnAssignExternalObject = customIBXUnitClassesTDataSetGrpConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'AddRow'
            Parameters = <>
            OnEval = customIBXUnitClassesTDataSetGrpMethodsAddGroupRowEval
            Kind = mkProcedure
          end
          item
            Name = 'AddSumField'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = customIBXUnitClassesTDataSetGrpMethodsAddSumFieldEval
            Kind = mkProcedure
          end
          item
            Name = 'Changed'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBXUnitClassesTDataSetGrpMethodsGroupEval
            Kind = mkFunction
          end
          item
            Name = 'Count'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBXUnitClassesTDataSetGrpMethodsCountEval
            Kind = mkFunction
          end
          item
            Name = 'Free'
            Parameters = <>
            Kind = mkDestructor
          end
          item
            Name = 'Reset'
            Parameters = <>
            OnEval = customIBXUnitClassesTDataSetGrpMethodsResetGroupEval
            Kind = mkProcedure
          end
          item
            Name = 'Restart'
            Parameters = <>
            OnEval = customIBXUnitClassesTDataSetGrpMethodsRestartGroupEval
            Kind = mkProcedure
          end
          item
            Name = 'SumOfField'
            Parameters = <
              item
                Name = 'FieldName'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Float'
            OnEval = customIBXUnitClassesTDataSetGrpMethodsSumOfFieldEval
            Kind = mkFunction
          end>
        Properties = <>
      end>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <
      item
        Name = 'TDataset'
      end>
    Functions = <>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'Ibx'
    Variables = <>
    Left = 40
    Top = 8
  end
end
