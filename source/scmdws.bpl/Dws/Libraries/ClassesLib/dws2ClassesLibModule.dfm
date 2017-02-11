object dws2ClassesLib: Tdws2ClassesLib
  OldCreateOrder = False
  Left = 464
  Top = 260
  Height = 135
  Width = 258
  object dws2Unit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TList'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dws2UnitClassesTListConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitClassesTListMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'Add'
            Parameters = <
              item
                Name = 'Obj'
                DataType = 'TObject'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTListMethodsAddEval
            Kind = mkFunction
          end
          item
            Name = 'Clear'
            Parameters = <>
            OnEval = dws2UnitClassesTListMethodsClearEval
            Kind = mkProcedure
          end
          item
            Name = 'Count'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTListMethodsCountEval
            Kind = mkFunction
          end
          item
            Name = 'Delete'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTListMethodsDeleteEval
            Kind = mkProcedure
          end
          item
            Name = 'GetItems'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTListMethodsGetItemsEval
            Kind = mkFunction
          end
          item
            Name = 'IndexOf'
            Parameters = <
              item
                Name = 'Obj'
                DataType = 'TObject'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTListMethodsIndexOfEval
            Kind = mkFunction
          end
          item
            Name = 'Insert'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Obj'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTListMethodsInsertEval
            Kind = mkProcedure
          end
          item
            Name = 'Remove'
            Parameters = <
              item
                Name = 'Obj'
                DataType = 'TObject'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTListMethodsRemoveEval
            Kind = mkFunction
          end
          item
            Name = 'SetItems'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTListMethodsSetItemsEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'Items'
            DataType = 'TObject'
            ReadAccess = 'GetItems'
            WriteAccess = 'SetItems'
            Parameters = <
              item
                Name = 'x'
                DataType = 'Integer'
                IsWritable = False
              end>
            IsDefault = True
          end>
      end
      item
        Name = 'TStrings'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dws2UnitClassesTStringsConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitClassesTStringsMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'Add'
            Parameters = <
              item
                Name = 'Str'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringsMethodsAddEval
            Kind = mkFunction
          end
          item
            Name = 'AddObject'
            Parameters = <
              item
                Name = 'S'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'AObject'
                DataType = 'TObject'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringsMethodsAddObjectEval
            Kind = mkFunction
          end
          item
            Name = 'AddStrings'
            Parameters = <
              item
                Name = 'Strings'
                DataType = 'TStringList'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsAddStringsEval
            Kind = mkProcedure
          end
          item
            Name = 'Clear'
            Parameters = <>
            OnEval = dws2UnitClassesTStringsMethodsClearEval
            Kind = mkProcedure
          end
          item
            Name = 'Delete'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsDeleteEval
            Kind = mkProcedure
          end
          item
            Name = 'Exchange'
            Parameters = <
              item
                Name = 'Index1'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Index2'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsExchangeEval
            Kind = mkProcedure
          end
          item
            Name = 'Get'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'String'
            OnEval = dws2UnitClassesTStringsMethodsGetEval
            Kind = mkFunction
          end
          item
            Name = 'GetCommaText'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitClassesTStringsMethodsGetCommaTextEval
            Kind = mkFunction
          end
          item
            Name = 'GetCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringsMethodsGetCountEval
            Kind = mkFunction
          end
          item
            Name = 'GetNames'
            Parameters = <
              item
                Name = 's'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'String'
            OnEval = dws2UnitClassesTStringsMethodsGetNamesEval
            Kind = mkFunction
          end
          item
            Name = 'GetObjects'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTStringsMethodsGetObjectsEval
            Kind = mkFunction
          end
          item
            Name = 'GetStrings'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'String'
            OnEval = dws2UnitClassesTStringsMethodsGetStringsEval
            Kind = mkFunction
          end
          item
            Name = 'GetText'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitClassesTStringsMethodsGetTextEval
            Kind = mkFunction
          end
          item
            Name = 'GetValues'
            Parameters = <
              item
                Name = 'Str'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'String'
            OnEval = dws2UnitClassesTStringsMethodsGetValuesEval
            Kind = mkFunction
          end
          item
            Name = 'InsertObject'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'S'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'AObject'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsInsertObjectEval
            Kind = mkProcedure
          end
          item
            Name = 'IndexOf'
            Parameters = <
              item
                Name = 'Str'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringsMethodsIndexOfEval
            Kind = mkFunction
          end
          item
            Name = 'IndexOfName'
            Parameters = <
              item
                Name = 'Str'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringsMethodsIndexOfNameEval
            Kind = mkFunction
          end
          item
            Name = 'IndexOfObject'
            Parameters = <
              item
                Name = 'AObject'
                DataType = 'TObject'
                IsWritable = False
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringsMethodsIndexOfObjectEval
            Kind = mkFunction
          end
          item
            Name = 'Insert'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Str'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsInsertEval
            Kind = mkProcedure
          end
          item
            Name = 'LoadFromFile'
            Parameters = <
              item
                Name = 'FileName'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsLoadFromFileEval
            Kind = mkProcedure
          end
          item
            Name = 'Move'
            Parameters = <
              item
                Name = 'CurIndex'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'NewIndex'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsMoveEval
            Kind = mkProcedure
          end
          item
            Name = 'SaveToFile'
            Parameters = <
              item
                Name = 'FileName'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsSaveToFileEval
            Kind = mkProcedure
          end
          item
            Name = 'SetCommaText'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsSetCommaTextEval
            Kind = mkProcedure
          end
          item
            Name = 'SetObjects'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsSetObjectsEval
            Kind = mkProcedure
          end
          item
            Name = 'SetStrings'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsSetStringsEval
            Kind = mkProcedure
          end
          item
            Name = 'SetText'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsSetTextEval
            Kind = mkProcedure
          end
          item
            Name = 'SetValues'
            Parameters = <
              item
                Name = 'Str'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'String'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringsMethodsSetValuesEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'Text'
            DataType = 'String'
            ReadAccess = 'GetText'
            WriteAccess = 'SetText'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Count'
            DataType = 'Integer'
            ReadAccess = 'GetCount'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'CommaText'
            DataType = 'String'
            ReadAccess = 'GetCommaText'
            WriteAccess = 'SetCommaText'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Strings'
            DataType = 'String'
            ReadAccess = 'GetStrings'
            WriteAccess = 'SetStrings'
            Parameters = <
              item
                Name = 'x'
                DataType = 'Integer'
                IsWritable = False
              end>
            IsDefault = True
          end
          item
            Name = 'Objects'
            DataType = 'TObject'
            ReadAccess = 'GetObjects'
            WriteAccess = 'SetObjects'
            Parameters = <
              item
                Name = 'x'
                DataType = 'Integer'
                IsWritable = False
              end>
            IsDefault = False
          end
          item
            Name = 'Names'
            DataType = 'String'
            ReadAccess = 'GetNames'
            Parameters = <
              item
                Name = 's'
                DataType = 'String'
                IsWritable = False
              end>
            IsDefault = False
          end
          item
            Name = 'Values'
            DataType = 'String'
            ReadAccess = 'GetValues'
            WriteAccess = 'SetValues'
            Parameters = <
              item
                Name = 's'
                DataType = 'String'
                IsWritable = False
              end>
            IsDefault = False
          end>
      end
      item
        Name = 'TStringList'
        Ancestor = 'TStrings'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'Sort'
            Parameters = <>
            OnEval = dws2UnitClassesTStringListMethodsSortEval
            Kind = mkProcedure
          end
          item
            Name = 'Find'
            Parameters = <
              item
                Name = 'S'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'Index'
                DataType = 'Integer'
                IsVarParam = True
              end>
            ResultType = 'Boolean'
            OnEval = dws2UnitClassesTStringListMethodsFindEval
            Kind = mkFunction
          end
          item
            Name = 'GetDuplicates'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStringListMethodsGetDuplicatesEval
            Kind = mkFunction
          end
          item
            Name = 'SetDuplicates'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringListMethodsSetDuplicatesEval
            Kind = mkProcedure
          end
          item
            Name = 'GetSorted'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitClassesTStringListMethodsGetSortedEval
            Kind = mkFunction
          end
          item
            Name = 'SetSorted'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringListMethodsSetSortedEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'Duplicates'
            DataType = 'Integer'
            ReadAccess = 'GetDuplicates'
            WriteAccess = 'SetDuplicates'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Sorted'
            DataType = 'Boolean'
            ReadAccess = 'GetSorted'
            WriteAccess = 'SetSorted'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'THashtable'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'Size'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTHashtableMethodsSizeEval
            Kind = mkFunction
          end
          item
            Name = 'Capacity'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTHashtableMethodsCapacityEval
            Kind = mkFunction
          end
          item
            Name = 'Clear'
            Parameters = <>
            OnEval = dws2UnitClassesTHashtableMethodsClearEval
            Kind = mkProcedure
          end>
        Properties = <>
      end
      item
        Name = 'TIntegerHashtable'
        Ancestor = 'THashtable'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dws2UnitClassesTIntegerHashtableConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitClassesTIntegerHashtableMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'Put'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'Integer'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTIntegerHashtableMethodsPutEval
            Kind = mkProcedure
          end
          item
            Name = 'Get'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTIntegerHashtableMethodsGetEval
            Kind = mkFunction
          end
          item
            Name = 'HasKey'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'Boolean'
            OnEval = dws2UnitClassesTIntegerHashtableMethodsHasKeyEval
            Kind = mkFunction
          end
          item
            Name = 'RemoveKey'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'Integer'
                IsWritable = False
              end>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTIntegerHashtableMethodsRemoveKeyEval
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TStringHashtable'
        Ancestor = 'THashtable'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dws2UnitClassesTStringHashtableConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitClassesTStringHashtableMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'Put'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'String'
                IsWritable = False
              end
              item
                Name = 'Value'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStringHashtableMethodsPutEval
            Kind = mkProcedure
          end
          item
            Name = 'Get'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTStringHashtableMethodsGetEval
            Kind = mkFunction
          end
          item
            Name = 'HasKey'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'Boolean'
            OnEval = dws2UnitClassesTStringHashtableMethodsHasKeyEval
            Kind = mkFunction
          end
          item
            Name = 'RemoveKey'
            Parameters = <
              item
                Name = 'Key'
                DataType = 'String'
                IsWritable = False
              end>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTStringHashtableMethodsRemoveKeyEval
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TStack'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dws2UnitClassesTStackConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitClassesTStackMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'Push'
            Parameters = <
              item
                Name = 'Obj'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTStackMethodsPushEval
            Kind = mkProcedure
          end
          item
            Name = 'Pop'
            Parameters = <>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTStackMethodsPopEval
            Kind = mkFunction
          end
          item
            Name = 'Peek'
            Parameters = <>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTStackMethodsPeekEval
            Kind = mkFunction
          end
          item
            Name = 'Count'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTStackMethodsCountEval
            Kind = mkFunction
          end>
        Properties = <>
      end
      item
        Name = 'TQueue'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = dws2UnitClassesTQueueConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitClassesTQueueMethodsDestroyEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end
          item
            Name = 'Push'
            Parameters = <
              item
                Name = 'Obj'
                DataType = 'TObject'
                IsWritable = False
              end>
            OnEval = dws2UnitClassesTQueueMethodsPushEval
            Kind = mkProcedure
          end
          item
            Name = 'Pop'
            Parameters = <>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTQueueMethodsPopEval
            Kind = mkFunction
          end
          item
            Name = 'Peek'
            Parameters = <>
            ResultType = 'TObject'
            OnEval = dws2UnitClassesTQueueMethodsPeekEval
            Kind = mkFunction
          end
          item
            Name = 'Count'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesTQueueMethodsCountEval
            Kind = mkFunction
          end>
        Properties = <>
      end>
    Constants = <
      item
        Name = 'dupIgnore'
        DataType = 'Integer'
        Value = 0
      end
      item
        Name = 'dupError'
        DataType = 'Integer'
        Value = 1
      end
      item
        Name = 'dupAccept'
        DataType = 'Integer'
        Value = 2
      end>
    Enumerations = <>
    Forwards = <
      item
        Name = 'TStringList'
      end>
    Functions = <>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'Classes'
    Variables = <>
    Left = 20
    Top = 8
  end
end
