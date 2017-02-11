object dws2MFZipLib: Tdws2MFZipLib
  OldCreateOrder = False
  Left = 823
  Top = 513
  Height = 200
  Width = 400
  object dws2UnitZip: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TZip'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'Create'
            Parameters = <>
            OnEval = dws2UnitZipClassesTZipMethodsCreateEval
            Kind = mkConstructor
          end
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitZipClassesTZipMethodsDestroyEval
            Kind = mkDestructor
          end
          item
            Name = 'Add'
            Parameters = <
              item
                Name = 'Action'
                DataType = 'Integer'
              end
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'FileName'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsAddEval
            Kind = mkFunction
          end
          item
            Name = 'AddList'
            Parameters = <
              item
                Name = 'Action'
                DataType = 'Integer'
              end
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'FileNames'
                DataType = 'TStringList'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsAddListEval
            Kind = mkFunction
          end
          item
            Name = 'Delete'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'FileName'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsDeleteEval
            Kind = mkFunction
          end
          item
            Name = 'DeleteList'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'FileNames'
                DataType = 'TStringList'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsDeleteListEval
            Kind = mkFunction
          end
          item
            Name = 'Extract'
            Parameters = <
              item
                Name = 'Action'
                DataType = 'Integer'
              end
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'FileName'
                DataType = 'String'
              end
              item
                Name = 'BaseDir'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsExtractEval
            Kind = mkFunction
          end
          item
            Name = 'ExtractList'
            Parameters = <
              item
                Name = 'Action'
                DataType = 'Integer'
              end
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'FileNames'
                DataType = 'TStringList'
              end
              item
                Name = 'BaseDir'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsExtractListEval
            Kind = mkFunction
          end
          item
            Name = 'List'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end>
            ResultType = 'TStringList'
            OnEval = dws2UnitZipClassesTZipMethodsListEval
            Kind = mkFunction
          end
          item
            Name = 'Message'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = dws2UnitZipClassesTZipMethodsMessageEval
            Kind = mkFunction
          end
          item
            Name = 'ReadSpan'
            Parameters = <
              item
                Name = 'SpanFile'
                DataType = 'String'
              end
              item
                Name = 'ZipFile'
                DataType = 'String'
                IsVarParam = True
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadSpanEval
            Kind = mkFunction
          end
          item
            Name = 'SFX2ZIP'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsSFX2ZIPEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSpan'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end
              item
                Name = 'SpanFile'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsWriteSpanEval
            Kind = mkFunction
          end
          item
            Name = 'ZIP2SFX'
            Parameters = <
              item
                Name = 'ZipFile'
                DataType = 'String'
              end>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsZIP2SFXEval
            Kind = mkFunction
          end
          item
            Name = 'ReadAddHiddenFiles'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddHiddenFilesEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddHiddenFiles'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddHiddenFilesEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddZipTime'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddZipTimeEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddZipTime'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddZipTimeEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddDirNames'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddDirNamesEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddDirNames'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddDirNamesEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddSeparateDirs'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddSeparateDirsEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddSeparateDirs'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddSeparateDirsEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddCompLevel'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddCompLevelEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddCompLevel'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddCompLevelEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddRecurseDirs'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddRecurseDirsEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddRecurseDirs'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddRecurseDirsEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddEncrypt'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddEncryptEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddEncrypt'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddEncryptEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadPassword'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitZipClassesTZipMethodsReadPasswordEval
            Kind = mkFunction
          end
          item
            Name = 'WritePassword'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWritePasswordEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadExtrDirNames'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadExtrDirNamesEval
            Kind = mkFunction
          end
          item
            Name = 'WriteExtrDirNames'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteExtrDirNamesEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadExtrOverwrite'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadExtrOverwriteEval
            Kind = mkFunction
          end
          item
            Name = 'WriteExtrOverwrite'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteExtrOverwriteEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadConfirmErase'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadConfirmEraseEval
            Kind = mkFunction
          end
          item
            Name = 'WriteConfirmErase'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteConfirmEraseEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadHowToDelete'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadHowToDeleteEval
            Kind = mkFunction
          end
          item
            Name = 'WriteHowToDelete'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteHowToDeleteEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddDiskSpan'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddDiskSpanEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddDiskSpan'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddDiskSpanEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadAddDiskSpanErase'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadAddDiskSpanEraseEval
            Kind = mkFunction
          end
          item
            Name = 'WriteAddDiskSpanErase'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteAddDiskSpanEraseEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadMaxVolumeSize'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadMaxVolumeSizeEval
            Kind = mkFunction
          end
          item
            Name = 'WriteMaxVolumeSize'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteMaxVolumeSizeEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadMinFreeVolumeSize'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadMinFreeVolumeSizeEval
            Kind = mkFunction
          end
          item
            Name = 'WriteMinFreeVolumeSize'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteMinFreeVolumeSizeEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadKeepFreeOnDisk1'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadKeepFreeOnDisk1Eval
            Kind = mkFunction
          end
          item
            Name = 'WriteKeepFreeOnDisk1'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteKeepFreeOnDisk1Eval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXCaption'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXCaptionEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXCaption'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXCaptionEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXCommandLine'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXCommandLineEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXCommandLine'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXCommandLineEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXDefaultDir'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXDefaultDirEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXDefaultDir'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXDefaultDirEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXAskCmdLine'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXAskCmdLineEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXAskCmdLine'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXAskCmdLineEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXAskFiles'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXAskFilesEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXAskFiles'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXAskFilesEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXHideOverwriteBox'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXHideOverwriteBoxEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXHideOverwriteBox'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXHideOverwriteBoxEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSFXOverwriteMode'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitZipClassesTZipMethodsReadSFXOverwriteModeEval
            Kind = mkFunction
          end
          item
            Name = 'WriteSFXOverwriteMode'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteSFXOverwriteModeEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadTemp'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitZipClassesTZipMethodsReadTempEval
            Kind = mkFunction
          end
          item
            Name = 'WriteTemp'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2UnitZipClassesTZipMethodsWriteTempEval
            Kind = mkProcedure
          end>
        Properties = <
          item
            Name = 'AddHiddenFiles'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddHiddenFiles'
            WriteAccess = 'WriteAddHiddenFiles'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddZipTime'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddZipTime'
            WriteAccess = 'WriteAddZipTime'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddDirNames'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddDirNames'
            WriteAccess = 'WriteAddDirNames'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddSeparateDirs'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddSeparateDirs'
            WriteAccess = 'WriteAddSeparateDirs'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddCompLevel'
            DataType = 'Integer'
            ReadAccess = 'ReadAddCompLevel'
            WriteAccess = 'WriteAddCompLevel'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddRecurseDirs'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddRecurseDirs'
            WriteAccess = 'WriteAddRecurseDirs'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddEncrypt'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddEncrypt'
            WriteAccess = 'WriteAddEncrypt'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Password'
            DataType = 'String'
            ReadAccess = 'ReadPassword'
            WriteAccess = 'WritePassword'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ExtrDirNames'
            DataType = 'Boolean'
            ReadAccess = 'ReadExtrDirNames'
            WriteAccess = 'WriteExtrDirNames'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ExtrOverwrite'
            DataType = 'Boolean'
            ReadAccess = 'ReadExtrOverwrite'
            WriteAccess = 'WriteExtrOverwrite'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ConfirmErase'
            DataType = 'Boolean'
            ReadAccess = 'ReadConfirmErase'
            WriteAccess = 'WriteConfirmErase'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'HowToDelete'
            DataType = 'Integer'
            ReadAccess = 'ReadHowToDelete'
            WriteAccess = 'WriteHowToDelete'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddDiskSpan'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddDiskSpan'
            WriteAccess = 'WriteAddDiskSpan'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddDiskSpanErase'
            DataType = 'Boolean'
            ReadAccess = 'ReadAddDiskSpanErase'
            WriteAccess = 'WriteAddDiskSpanErase'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'MaxVolumeSize'
            DataType = 'Integer'
            ReadAccess = 'ReadMaxVolumeSize'
            WriteAccess = 'WriteMaxVolumeSize'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'MinFreeVolumeSize'
            DataType = 'Integer'
            ReadAccess = 'ReadMinFreeVolumeSize'
            WriteAccess = 'WriteMinFreeVolumeSize'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'KeepFreeOnDisk1'
            DataType = 'Integer'
            ReadAccess = 'ReadKeepFreeOnDisk1'
            WriteAccess = 'WriteKeepFreeOnDisk1'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXCaption'
            DataType = 'String'
            ReadAccess = 'ReadSFXCaption'
            WriteAccess = 'WriteSFXCaption'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXCommandLine'
            DataType = 'String'
            ReadAccess = 'ReadSFXCommandLine'
            WriteAccess = 'WriteSFXCommandLine'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXDefaultDir'
            DataType = 'String'
            ReadAccess = 'ReadSFXDefaultDir'
            WriteAccess = 'WriteSFXDefaultDir'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXAskCmdLine'
            DataType = 'Boolean'
            ReadAccess = 'ReadSFXAskCmdLine'
            WriteAccess = 'WriteSFXAskCmdLine'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXAskFiles'
            DataType = 'Boolean'
            ReadAccess = 'ReadSFXAskFiles'
            WriteAccess = 'WriteSFXAskFiles'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXHideOverwriteBox'
            DataType = 'Boolean'
            ReadAccess = 'ReadSFXHideOverwriteBox'
            WriteAccess = 'WriteSFXHideOverwriteBox'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SFXOverwriteMode'
            DataType = 'Integer'
            ReadAccess = 'ReadSFXOverwriteMode'
            WriteAccess = 'WriteSFXOverwriteMode'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Temp'
            DataType = 'String'
            ReadAccess = 'ReadTemp'
            WriteAccess = 'WriteTemp'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Dependencies.Strings = (
      'Internal'
      'Classes')
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    UnitName = 'MFZip'
    Variables = <>
    Left = 32
    Top = 18
  end
end
