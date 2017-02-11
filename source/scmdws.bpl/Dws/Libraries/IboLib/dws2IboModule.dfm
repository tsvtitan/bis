object dws2IboLib: Tdws2IboLib
  OldCreateOrder = False
  Left = 250
  Top = 651
  Height = 200
  Width = 400
  object customIBOUnit: Tdws2Unit
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
            OnAssignExternalObject = customIBOUnitClassesTDatabaseConstructorscreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'connect'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatabaseMethodsconnectEval
            Kind = mkProcedure
          end
          item
            Name = 'disconnect'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatabaseMethodsdisconnectEval
            Kind = mkProcedure
          end
          item
            Name = 'getcharset'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBOUnitClassesTDatabaseMethodsgetcharsetEval
            Kind = mkFunction
          end
          item
            Name = 'getdialect'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBOUnitClassesTDatabaseMethodsgetdialectEval
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
            OnEval = customIBOUnitClassesTDatabaseMethodssetcharsetEval
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
            OnEval = customIBOUnitClassesTDatabaseMethodssetdialectEval
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
            OnEval = customIBOUnitClassesTDBFieldMethodsGetDateTimeEval
            Kind = mkFunction
          end
          item
            Name = 'GetFloat'
            Parameters = <>
            ResultType = 'Float'
            OnEval = customIBOUnitClassesTDBFieldMethodsGetFloatEval
            Kind = mkFunction
          end
          item
            Name = 'GetInteger'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBOUnitClassesTDBFieldMethodsGetIntegerEval
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
            OnEval = customIBOUnitClassesTDBFieldMethodsSetDateTimeEval
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
            OnEval = customIBOUnitClassesTDBFieldMethodsSetFloatEval
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
            OnEval = customIBOUnitClassesTDBFieldMethodsSetIntegerEval
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
            OnEval = customIBOUnitClassesTLUFieldMethodsGetValueEval
            Attributes = [maOverride]
            Kind = mkFunction
          end
          item
            Name = 'GetValueStr'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBOUnitClassesTLUFieldMethodsGetValueStrEval
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
            OnEval = customIBOUnitClassesTLUFieldMethodsSetValueEval
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
            OnEval = customIBOUnitClassesTLUFieldMethodsSetValueStrEval
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
            OnAssignExternalObject = customIBOUnitClassesTMLUFieldConstructorscreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'free'
            Parameters = <>
            OnEval = AFreeExtObject
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
            OnEval = customIBOUnitClassesTMLUFieldMethodsGetValueEval
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
            OnEval = customIBOUnitClassesTMLUFieldMethodsSetNameValueEval
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
            OnAssignExternalObject = customIBOUnitClassesTStatementConstructorsCreateAssignExternalObject
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
            OnAssignExternalObject = customIBOUnitClassesTStatementConstructorsCreateFromDBAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Execute'
            Parameters = <>
            OnEval = customIBOUnitClassesTStatementMethodsExecuteEval
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
            OnEval = customIBOUnitClassesTStatementMethodsFieldEval
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
            OnEval = customIBOUnitClassesTStatementMethodsFieldByNameEval
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
            OnEval = customIBOUnitClassesTStatementMethodsFieldIsNullEval
            Kind = mkFunction
          end
          item
            Name = 'Free'
            Parameters = <>
            OnEval = AFreeExtObject
            Kind = mkDestructor
          end
          item
            Name = 'GetSQL'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBOUnitClassesTStatementMethodsGetSQLEval
            Kind = mkFunction
          end
          item
            Name = 'Open'
            Parameters = <>
            OnEval = customIBOUnitClassesTStatementMethodsExecuteEval
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
            OnEval = customIBOUnitClassesTStatementMethodsParamByNameEval
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
            OnEval = customIBOUnitClassesTStatementMethodsSetParamEval
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
            OnEval = customIBOUnitClassesTStatementMethodsSetSQLEval
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
            OnAssignExternalObject = customIBOUnitClassesTDatasetConstructorsCreateAssignExternalObject
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
            OnAssignExternalObject = customIBOUnitClassesTDatasetConstructorsCreateFromDBAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Cancel'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsCancelEval
            Kind = mkProcedure
          end
          item
            Name = 'Close'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsCloseEval
            Kind = mkProcedure
          end
          item
            Name = 'Delete'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsDeleteEval
            Kind = mkProcedure
          end
          item
            Name = 'Edit'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsEditEval
            Kind = mkProcedure
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBOUnitClassesTDatasetMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'First'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBOUnitClassesTDatasetMethodsFirstEval
            Kind = mkFunction
          end
          item
            Name = 'Insert'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsInsertEval
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBOUnitClassesTDatasetMethodsNextEval
            Kind = mkFunction
          end
          item
            Name = 'Open'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsOpenEval
            Attributes = [maOverride]
            Kind = mkProcedure
          end
          item
            Name = 'Post'
            Parameters = <>
            OnEval = customIBOUnitClassesTDatasetMethodsPostEval
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
            OnAssignExternalObject = customIBOUnitClassesTQueryConstructorsCreateAssignExternalObject
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
            OnAssignExternalObject = customIBOUnitClassesTQueryConstructorsCreateFromDBAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'GetFilter'
            Parameters = <>
            ResultType = 'String'
            OnEval = customIBOUnitClassesTQueryMethodsGetFilterEval
            Kind = mkFunction
          end
          item
            Name = 'GetFiltered'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBOUnitClassesTQueryMethodsGetFilteredEval
            Kind = mkFunction
          end
          item
            Name = 'GetSortOrder'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBOUnitClassesTQueryMethodsGetSortOrderEval
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
            OnEval = customIBOUnitClassesTQueryMethodsLookUpEval
            Kind = mkFunction
          end
          item
            Name = 'Prior'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBOUnitClassesTQueryMethodsPriorEval
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
            OnEval = customIBOUnitClassesTQueryMethodsSetFilterEval
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
            OnEval = customIBOUnitClassesTQueryMethodsSetFilteredEval
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
            OnEval = customIBOUnitClassesTQueryMethodsSetLookUpFieldsEval
            Kind = mkProcedure
          end
          item
            Name = 'SetSortOrder'
            Parameters = <
              item
                Name = 'SortOrder'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = customIBOUnitClassesTQueryMethodsSetSortOrderEval
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
            OnAssignExternalObject = customIBOUnitClassesTDataSetGrpConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'AddRow'
            Parameters = <>
            OnEval = customIBOUnitClassesTDataSetGrpMethodsAddGroupRowEval
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
            OnEval = customIBOUnitClassesTDataSetGrpMethodsAddSumFieldEval
            Kind = mkProcedure
          end
          item
            Name = 'Changed'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = customIBOUnitClassesTDataSetGrpMethodsGroupEval
            Kind = mkFunction
          end
          item
            Name = 'Count'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = customIBOUnitClassesTDataSetGrpMethodsCountEval
            Kind = mkFunction
          end
          item
            Name = 'Free'
            Parameters = <>
            OnEval = AFreeExtObject
            Kind = mkDestructor
          end
          item
            Name = 'Reset'
            Parameters = <>
            OnEval = customIBOUnitClassesTDataSetGrpMethodsResetGroupEval
            Kind = mkProcedure
          end
          item
            Name = 'Restart'
            Parameters = <>
            OnEval = customIBOUnitClassesTDataSetGrpMethodsRestartGroupEval
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
            OnEval = customIBOUnitClassesTDataSetGrpMethodsSumOfFieldEval
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
    UnitName = 'Ibo'
    Variables = <>
    Left = 40
    Top = 8
  end
end
