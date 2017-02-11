object dws2IniLib: Tdws2IniLib
  OldCreateOrder = False
  Left = 526
  Top = 344
  Height = 101
  Width = 119
  object IniUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TIniFile'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'FileName'
                DataType = 'String'
              end>
            OnAssignExternalObject = ConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'ReadString'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = ReadStringEval
            Kind = mkFunction
          end
          item
            Name = 'WriteString'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = WriteStringEval
            Kind = mkProcedure
          end
          item
            Name = 'EraseSection'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end>
            OnEval = EraseSectionEval
            Kind = mkProcedure
          end
          item
            Name = 'DeleteKey'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end>
            OnEval = DeleteKeyEval
            Kind = mkProcedure
          end
          item
            Name = 'UpdateFile'
            Parameters = <>
            OnEval = UpdateFileEval
            Kind = mkProcedure
          end
          item
            Name = 'SectionExists'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            OnEval = SectionExistsEval
            Kind = mkFunction
          end
          item
            Name = 'ReadInteger'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'Integer'
              end>
            ResultType = 'Integer'
            OnEval = ReadIntegerEval
            Kind = mkFunction
          end
          item
            Name = 'WriteInteger'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = WriteIntegerEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadBool'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'Boolean'
              end>
            ResultType = 'Boolean'
            OnEval = ReadBoolEval
            Kind = mkFunction
          end
          item
            Name = 'WriteBool'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = WriteBoolEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadDate'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'DateTime'
              end>
            ResultType = 'DateTime'
            OnEval = ReadDateEval
            Kind = mkFunction
          end
          item
            Name = 'ReadDateTime'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'DateTime'
              end>
            ResultType = 'DateTime'
            OnEval = ReadDateTimeEval
            Kind = mkFunction
          end
          item
            Name = 'ReadFloat'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'Float'
              end>
            ResultType = 'Float'
            OnEval = ReadFloatEval
            Kind = mkFunction
          end
          item
            Name = 'ReadTime'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'DateTime'
              end>
            ResultType = 'DateTime'
            OnEval = ReadTimeEval
            Kind = mkFunction
          end
          item
            Name = 'WriteDate'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = WriteDateEval
            Kind = mkProcedure
          end
          item
            Name = 'WriteDateTime'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = WriteDateTimeEval
            Kind = mkProcedure
          end
          item
            Name = 'WriteFloat'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'Float'
              end>
            OnEval = WriteFloatEval
            Kind = mkProcedure
          end
          item
            Name = 'WriteTime'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Name'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = WriteTimeEval
            Kind = mkProcedure
          end
          item
            Name = 'ValueExists'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Ident'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            OnEval = ValueExistsEval
            Kind = mkFunction
          end
          item
            Name = 'ReadSection'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Strings'
                DataType = 'TStringList'
              end>
            OnEval = ReadSectionEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSections'
            Parameters = <
              item
                Name = 'Strings'
                DataType = 'TStringList'
              end>
            OnEval = ReadSectionsEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSectionValues'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end
              item
                Name = 'Strings'
                DataType = 'TStringList'
              end>
            OnEval = ReadSectionValuesEval
            Kind = mkProcedure
          end
          item
            Name = 'GetFilename'
            Parameters = <>
            ResultType = 'String'
            OnEval = GetFileNameEval
            Kind = mkFunction
          end
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = DestructEval
            Attributes = [maOverride]
            Kind = mkDestructor
          end>
        Properties = <
          item
            Name = 'Filename'
            DataType = 'String'
            ReadAccess = 'GetFilename'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Dependencies.Strings = (
      'Classes')
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'IniFiles'
    Variables = <>
    Left = 12
    Top = 8
  end
end
