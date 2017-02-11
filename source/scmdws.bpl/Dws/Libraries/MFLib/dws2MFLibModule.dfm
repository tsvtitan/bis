object dws2MFLib: Tdws2MFLib
  OldCreateOrder = False
  Left = 414
  Top = 186
  Height = 472
  Width = 733
  object dws2UnitBasic: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'Beep'
        Parameters = <>
        OnEval = dws2UnitBasicFunctionsBeepEval
      end
      item
        Name = 'Dec'
        Parameters = <
          item
            Name = 'I'
            DataType = 'Integer'
            IsVarParam = True
          end>
        OnEval = dws2UnitBasicFunctionsDecEval
      end
      item
        Name = 'Dec2'
        Parameters = <
          item
            Name = 'I'
            DataType = 'Integer'
            IsVarParam = True
          end
          item
            Name = 'N'
            DataType = 'Integer'
          end>
        OnEval = dws2UnitBasicFunctionsDec2Eval
      end
      item
        Name = 'Inc'
        Parameters = <
          item
            Name = 'I'
            DataType = 'Integer'
            IsVarParam = True
          end>
        OnEval = dws2UnitBasicFunctionsIncEval
      end
      item
        Name = 'Inc2'
        Parameters = <
          item
            Name = 'I'
            DataType = 'Integer'
            IsVarParam = True
          end
          item
            Name = 'N'
            DataType = 'Integer'
          end>
        OnEval = dws2UnitBasicFunctionsInc2Eval
      end
      item
        Name = 'GetTickCount'
        Parameters = <>
        ResultType = 'Integer'
        OnEval = dws2UnitBasicFunctionsGetTickCountEval
      end
      item
        Name = 'Sleep'
        Parameters = <
          item
            Name = 'mSecs'
            DataType = 'Integer'
          end>
        OnEval = dws2UnitBasicFunctionsSleepEval
      end
      item
        Name = 'WriteLn'
        Parameters = <
          item
            Name = 'Text'
            DataType = 'String'
          end>
        OnEval = dws2UnitBasicFunctionsWriteLnEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFBasic'
    Variables = <>
    Left = 50
    Top = 30
  end
  object dws2UnitConnection: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'Connected'
        Parameters = <>
        ResultType = 'Boolean'
        OnEval = dws2UnitConnFunctionsConnectedEval
      end
      item
        Name = 'IPAddress'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitConnFunctionsIPAddressEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFConnection'
    Variables = <>
    Left = 50
    Top = 80
  end
  object dws2UnitFile: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal'
      'Classes')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'DescCopy'
        Parameters = <
          item
            Name = 'Source'
            DataType = 'String'
          end
          item
            Name = 'Target'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsDescCopyEval
      end
      item
        Name = 'DescListCreate'
        Parameters = <
          item
            Name = 'Dir'
            DataType = 'String'
          end>
        ResultType = 'TStringList'
        OnEval = dws2UnitFileFunctionsDescListCreateEval
      end
      item
        Name = 'DescListRead'
        Parameters = <
          item
            Name = 'List'
            DataType = 'TStringList'
          end
          item
            Name = 'FileName'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsDescListReadEval
      end
      item
        Name = 'DescMove'
        Parameters = <
          item
            Name = 'Source'
            DataType = 'String'
          end
          item
            Name = 'Target'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsDescMoveEval
      end
      item
        Name = 'DescRead'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsDescReadEval
      end
      item
        Name = 'DescWrite'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end
          item
            Name = 'Desc'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsDescWriteEval
      end
      item
        Name = 'OpenDialog'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end
          item
            Name = 'InitialDir'
            DataType = 'String'
          end
          item
            Name = 'Title'
            DataType = 'String'
          end
          item
            Name = 'DefaultExt'
            DataType = 'String'
          end
          item
            Name = 'Filter'
            DataType = 'String'
          end
          item
            Name = 'FilterIndex'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsOpenDialogEval
      end
      item
        Name = 'OpenDialogMulti'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end
          item
            Name = 'InitialDir'
            DataType = 'String'
          end
          item
            Name = 'Title'
            DataType = 'String'
          end
          item
            Name = 'DefaultExt'
            DataType = 'String'
          end
          item
            Name = 'Filter'
            DataType = 'String'
          end
          item
            Name = 'FilterIndex'
            DataType = 'Integer'
          end>
        ResultType = 'TStringList'
        OnEval = dws2UnitFileFunctionsOpenDialogMultiEval
      end
      item
        Name = 'SaveDialog'
        Parameters = <
          item
            Name = 'Filename'
            DataType = 'String'
          end
          item
            Name = 'InitialDir'
            DataType = 'String'
          end
          item
            Name = 'Title'
            DataType = 'String'
          end
          item
            Name = 'DefaultExt'
            DataType = 'String'
          end
          item
            Name = 'Filter'
            DataType = 'String'
          end
          item
            Name = 'FilterIndex'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsSaveDialogEval
      end
      item
        Name = 'CDClose'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsCDCloseEval
      end
      item
        Name = 'CDOpen'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsCDOpenEval
      end
      item
        Name = 'GetCRC32FromFile'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitFileFunctionsGetCRC32FromFileEval
      end
      item
        Name = 'GetDriveName'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsGetDrivenameEval
      end
      item
        Name = 'GetDriveNum'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitFileFunctionsGetDriveNumEval
      end
      item
        Name = 'GetDriveReady'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsGetDriveReadyEval
      end
      item
        Name = 'GetDriveSerial'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsGetDriveSerialEval
      end
      item
        Name = 'GetDriveType'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitFileFunctionsGetDriveTypeEval
      end
      item
        Name = 'DirectoryExists'
        Parameters = <
          item
            Name = 'DirName'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsDirectoryExistsEval
      end
      item
        Name = 'DirectoryList'
        Parameters = <
          item
            Name = 'DirName'
            DataType = 'String'
          end
          item
            Name = 'Recurse'
            DataType = 'Boolean'
          end
          item
            Name = 'Hidden'
            DataType = 'Boolean'
          end>
        ResultType = 'TStringList'
        OnEval = dws2UnitFileFunctionsDirectoryListEval
      end
      item
        Name = 'CopyFile'
        Parameters = <
          item
            Name = 'Source'
            DataType = 'String'
          end
          item
            Name = 'Target'
            DataType = 'String'
          end
          item
            Name = 'Fail'
            DataType = 'Boolean'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsCopyFileEval
      end
      item
        Name = 'FileDate'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end
          item
            Name = 'Flag'
            DataType = 'Integer'
          end>
        ResultType = 'DateTime'
        OnEval = dws2UnitFileFunctionsFileDateEval
      end
      item
        Name = 'FileList'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end
          item
            Name = 'Recurse'
            DataType = 'Boolean'
          end
          item
            Name = 'Hidden'
            DataType = 'Boolean'
          end
          item
            Name = 'Dirs'
            DataType = 'Boolean'
          end>
        ResultType = 'TStringList'
        OnEval = dws2UnitFileFunctionsFileListEval
      end
      item
        Name = 'FileSize'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitFileFunctionsFileSizeEval
      end
      item
        Name = 'MakePath'
        Parameters = <
          item
            Name = 'Drive'
            DataType = 'String'
          end
          item
            Name = 'Dir'
            DataType = 'String'
          end
          item
            Name = 'Name'
            DataType = 'String'
          end
          item
            Name = 'Ext'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitFileFunctionsMakePathEval
      end
      item
        Name = 'MoveFile'
        Parameters = <
          item
            Name = 'Source'
            DataType = 'String'
          end
          item
            Name = 'Target'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsMoveFileEval
      end
      item
        Name = 'MoveFileEx'
        Parameters = <
          item
            Name = 'Source'
            DataType = 'String'
          end
          item
            Name = 'Target'
            DataType = 'String'
          end
          item
            Name = 'Flags'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsMoveFileExEval
      end
      item
        Name = 'ReadOnlyPath'
        Parameters = <
          item
            Name = 'Path'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsReadOnlyPathEval
      end
      item
        Name = 'SplitPath'
        Parameters = <
          item
            Name = 'Path'
            DataType = 'String'
          end
          item
            Name = 'Drive'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Dir'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Name'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Ext'
            DataType = 'String'
            IsVarParam = True
          end>
        OnEval = dws2UnitFileFunctionsSplitPathEval
      end
      item
        Name = 'SubdirectoryExists'
        Parameters = <
          item
            Name = 'Dir'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitFileFunctionsSubdirectoryExistsEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFFile'
    Variables = <>
    Left = 50
    Top = 180
  end
  object dws2UnitInfo: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'GetAllUsersDesktopDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetAllUsersDesktopDirectoryEval
      end
      item
        Name = 'GetAllUsersProgramsDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetAllUsersProgramsDirectoryEval
      end
      item
        Name = 'GetAllUsersStartmenuDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetAllUsersStartmenuDirectoryEval
      end
      item
        Name = 'GetAllUsersStartupDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetAllUsersStartupDirectoryEval
      end
      item
        Name = 'GetAppdataDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetAppdataDirectoryEval
      end
      item
        Name = 'GetCacheDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetCacheDirectoryEval
      end
      item
        Name = 'GetChannelFolderName'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetChannelFolderNameEval
      end
      item
        Name = 'GetCommonFilesDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetCommonFilesDirectoryEval
      end
      item
        Name = 'GetComputerName'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetComputerNameEval
      end
      item
        Name = 'GetConsoleTitle'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetConsoleTitleEval
      end
      item
        Name = 'GetCookiesDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetCookiesDirectoryEval
      end
      item
        Name = 'GetCPUSpeed'
        Parameters = <>
        ResultType = 'Float'
        OnEval = dws2UnitInfoFunctionsGetCPUSpeedEval
      end
      item
        Name = 'GetDesktopDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetDesktopDirectoryEval
      end
      item
        Name = 'GetDevicePath'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetDevicePathEval
      end
      item
        Name = 'GetEnvironmentVariable'
        Parameters = <
          item
            Name = 'Name'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetEnvironmentVariableEval
      end
      item
        Name = 'GetFavoritesDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetFavoritesDirectoryEval
      end
      item
        Name = 'GetFontsDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetFontsDirectoryEval
      end
      item
        Name = 'GetHistoryDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetHistoryDirectoryEval
      end
      item
        Name = 'GetLinkfolderName'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetLinkfolderNameEval
      end
      item
        Name = 'GetMediaPath'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetMediaPathEval
      end
      item
        Name = 'GetNethoodDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetNethoodDirectoryEval
      end
      item
        Name = 'GetPersonalDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetPersonalDirectoryEval
      end
      item
        Name = 'GetPFAccessoriesName'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetPFAccessoriesNameEval
      end
      item
        Name = 'GetPrinthoodDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetPrinthoodDirectoryEval
      end
      item
        Name = 'GetProgramfilesDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetProgramfilesDirectoryEval
      end
      item
        Name = 'GetProgramsDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetProgramsDirectoryEval
      end
      item
        Name = 'GetRecentDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetRecentDirectoryEval
      end
      item
        Name = 'GetSendtoDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetSendtoDirectoryEval
      end
      item
        Name = 'GetSMAccessoriesName'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetSMAccessoriesNameEval
      end
      item
        Name = 'GetStartmenuDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetStartmenuDirectoryEval
      end
      item
        Name = 'GetStartupDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetStartupDirectoryEval
      end
      item
        Name = 'GetSystemDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetSystemDirectoryEval
      end
      item
        Name = 'GetTempDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetTempDirectoryEval
      end
      item
        Name = 'GetTemplatesDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetTemplatesDirectoryEval
      end
      item
        Name = 'GetUserName'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetUserNameEval
      end
      item
        Name = 'GetVersion'
        Parameters = <>
        ResultType = 'Integer'
        OnEval = dws2UnitInfoFunctionsGetVersionEval
      end
      item
        Name = 'GetWallpaperDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetWallpaperDirectoryEval
      end
      item
        Name = 'GetWindowsDirectory'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitInfoFunctionsGetWindowsDirectoryEval
      end
      item
        Name = 'GetWindowsVersion'
        Parameters = <>
        ResultType = 'Integer'
        OnEval = dws2UnitInfoFunctionsGetWindowsVersionEval
      end
      item
        Name = 'IsWin2000'
        Parameters = <>
        ResultType = 'Boolean'
        OnEval = dws2UnitInfoFunctionsIsWin2000Eval
      end
      item
        Name = 'IsWin9x'
        Parameters = <>
        ResultType = 'Boolean'
        OnEval = dws2UnitInfoFunctionsIsWin9xEval
      end
      item
        Name = 'IsWinNT'
        Parameters = <>
        ResultType = 'Boolean'
        OnEval = dws2UnitInfoFunctionsIsWinNTEval
      end
      item
        Name = 'IsWinNT4'
        Parameters = <>
        ResultType = 'Boolean'
        OnEval = dws2UnitInfoFunctionsIsWinNT4Eval
      end
      item
        Name = 'SetComputerName'
        Parameters = <
          item
            Name = 'Name'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitInfoFunctionsSetComputerNameEval
      end
      item
        Name = 'SetConsoleTitle'
        Parameters = <
          item
            Name = 'Title'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitInfoFunctionsSetConsoleTitleEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFInfo'
    Variables = <>
    Left = 160
    Top = 30
  end
  object dws2UnitIniFiles: Tdws2Unit
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
            OnAssignExternalObject = dws2UnitIniFilesClassesTIniFileConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Destroy'
            Parameters = <>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsDestroyEval
            Kind = mkDestructor
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsDeleteKeyEval
            Kind = mkProcedure
          end
          item
            Name = 'EraseSection'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsEraseSectionEval
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadBoolEval
            Kind = mkFunction
          end
          item
            Name = 'ReadDate'
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
                DataType = 'DateTime'
              end>
            ResultType = 'DateTime'
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadDateEval
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
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'DateTime'
              end>
            ResultType = 'DateTime'
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadDateTimeEval
            Kind = mkFunction
          end
          item
            Name = 'ReadFileName'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadFileNameEval
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
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'Float'
              end>
            ResultType = 'Float'
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadFloatEval
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadIntegerEval
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadSectionEval
            Kind = mkProcedure
          end
          item
            Name = 'ReadSections'
            Parameters = <
              item
                Name = 'Strings'
                DataType = 'TStringList'
              end>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadSectionsEval
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadSectionValuesEval
            Kind = mkProcedure
          end
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadStringEval
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
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Default'
                DataType = 'DateTime'
              end>
            ResultType = 'DateTime'
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsReadTimeEval
            Kind = mkFunction
          end
          item
            Name = 'SectionExists'
            Parameters = <
              item
                Name = 'Section'
                DataType = 'String'
              end>
            ResultType = 'Boolean'
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsSectionExistsEval
            Kind = mkFunction
          end
          item
            Name = 'UpdateFile'
            Parameters = <>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsUpdateFileEval
            Kind = mkProcedure
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteBoolEval
            Kind = mkProcedure
          end
          item
            Name = 'WriteDate'
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
                DataType = 'DateTime'
              end>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteDateEval
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
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteDateTimeEval
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
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'Float'
              end>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteFloatEval
            Kind = mkProcedure
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteIntegerEval
            Kind = mkProcedure
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteStringEval
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
                Name = 'Ident'
                DataType = 'String'
              end
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsWriteTimeEval
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
            OnEval = dws2UnitIniFilesClassesTIniFileMethodsValueExistsEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'FileName'
            DataType = 'String'
            ReadAccess = 'ReadFileName'
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
    UnitName = 'MFIniFiles'
    Variables = <>
    Left = 160
    Top = 80
  end
  object dws2UnitRegistry: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'RegCreateKey'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end>
        OnEval = dws2UnitRegistryFunctionsRegCreateKeyEval
      end
      item
        Name = 'RegDeleteKey'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end>
        OnEval = dws2UnitRegistryFunctionsRegDeleteKeyEval
      end
      item
        Name = 'RegDeleteValue'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end>
        OnEval = dws2UnitRegistryFunctionsRegDeleteValueEval
      end
      item
        Name = 'RegReadInteger'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end
          item
            Name = 'ValDef'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitRegistryFunctionsRegReadIntegerEval
      end
      item
        Name = 'RegReadString'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end
          item
            Name = 'ValDef'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitRegistryFunctionsRegReadStringEval
      end
      item
        Name = 'RegGetType'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end
          item
            Name = 'Size'
            DataType = 'Integer'
            IsVarParam = True
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitRegistryFunctionsRegGetTypeEval
      end
      item
        Name = 'RegKeyExists'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitRegistryFunctionsRegKeyExistsEval
      end
      item
        Name = 'RegValueExists'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitRegistryFunctionsRegValueExistsEval
      end
      item
        Name = 'RegWriteInteger'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end
          item
            Name = 'Value'
            DataType = 'Integer'
          end>
        OnEval = dws2UnitRegistryFunctionsRegWriteIntegerEval
      end
      item
        Name = 'RegWriteString'
        Parameters = <
          item
            Name = 'MainKey'
            DataType = 'Integer'
          end
          item
            Name = 'SubKey'
            DataType = 'String'
          end
          item
            Name = 'ValName'
            DataType = 'String'
          end
          item
            Name = 'Value'
            DataType = 'String'
          end>
        OnEval = dws2UnitRegistryFunctionsRegWriteStringEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFRegistry'
    Variables = <>
    Left = 160
    Top = 130
  end
  object dws2UnitShell: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'DesktopRefresh'
        Parameters = <>
        OnEval = dws2UnitShellFunctionsDesktopRefreshEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFShell'
    Variables = <>
    Left = 160
    Top = 180
  end
  object dws2UnitString: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal'
      'Classes')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'ANSI2OEM'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsANSI2OEMEval
      end
      item
        Name = 'ChangeTokenValue'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'Name'
            DataType = 'String'
          end
          item
            Name = 'Value'
            DataType = 'String'
          end
          item
            Name = 'Delimiter'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsChangeTokenValueEval
      end
      item
        Name = 'Chr'
        Parameters = <
          item
            Name = 'Byte'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsChrEval
      end
      item
        Name = 'CmpRE'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'RE'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitStringFunctionsCmpREEval
      end
      item
        Name = 'CmpWC'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'WC'
            DataType = 'String'
          end
          item
            Name = 'Case'
            DataType = 'Boolean'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitStringFunctionsCmpWCEval
      end
      item
        Name = 'Crop'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'Len'
            DataType = 'Integer'
          end
          item
            Name = 'Dir'
            DataType = 'Integer'
          end
          item
            Name = 'Delimiter'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsCropEval
      end
      item
        Name = 'ForEach'
        Parameters = <
          item
            Name = 'List'
            DataType = 'TStringList'
          end
          item
            Name = 'Func'
            DataType = 'String'
          end
          item
            Name = 'Flag'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitStringFunctionsForEachEval
      end
      item
        Name = 'FormatColumns'
        Parameters = <
          item
            Name = 'List'
            DataType = 'TStringList'
          end
          item
            Name = 'Delimiter'
            DataType = 'String'
          end
          item
            Name = 'Space'
            DataType = 'String'
          end
          item
            Name = 'Adjustment'
            DataType = 'Integer'
          end>
        OnEval = dws2UnitStringFunctionsFormatColumnsEval
      end
      item
        Name = 'GetCRC32FromString'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitStringFunctionsGetCRC32FromStringEval
      end
      item
        Name = 'GetStringFromList'
        Parameters = <
          item
            Name = 'List'
            DataType = 'TStringList'
          end
          item
            Name = 'Delimiter'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsGetStringFromListEval
      end
      item
        Name = 'GetTokenList'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'Delimiter'
            DataType = 'String'
          end
          item
            Name = 'Repeater'
            DataType = 'Boolean'
          end
          item
            Name = 'IgnoreFirst'
            DataType = 'Boolean'
          end
          item
            Name = 'IgnoreLast'
            DataType = 'Boolean'
          end>
        ResultType = 'TStringList'
        OnEval = dws2UnitStringFunctionsGetTokenListEval
      end
      item
        Name = 'IncWC'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'WC'
            DataType = 'String'
          end
          item
            Name = 'Case'
            DataType = 'Boolean'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsIncWCEval
      end
      item
        Name = 'Num2Text'
        Parameters = <
          item
            Name = 'Num'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsNum2TextEval
      end
      item
        Name = 'OEM2ANSI'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsOEM2ANSIEval
      end
      item
        Name = 'Ord'
        Parameters = <
          item
            Name = 'Char'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitStringFunctionsOrdEval
      end
      item
        Name = 'PosX'
        Parameters = <
          item
            Name = 'SubStr'
            DataType = 'String'
          end
          item
            Name = 'S'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitStringFunctionsPosXEval
      end
      item
        Name = 'StringOfChar'
        Parameters = <
          item
            Name = 'Ch'
            DataType = 'String'
          end
          item
            Name = 'Count'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsStringOfCharEval
      end
      item
        Name = 'TestWC'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitStringFunctionsTestWCEval
      end
      item
        Name = 'Translate'
        Parameters = <
          item
            Name = 'S'
            DataType = 'String'
          end
          item
            Name = 'Out'
            DataType = 'String'
          end
          item
            Name = 'In'
            DataType = 'String'
          end
          item
            Name = 'Place'
            DataType = 'String'
          end
          item
            Name = 'Case'
            DataType = 'Boolean'
          end>
        ResultType = 'String'
        OnEval = dws2UnitStringFunctionsTranslateEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFString'
    Variables = <>
    Left = 270
    Top = 30
  end
  object dws2UnitSystem: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal'
      'Classes')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'ShellExecute'
        Parameters = <
          item
            Name = 'Operation'
            DataType = 'String'
          end
          item
            Name = 'Filename'
            DataType = 'String'
          end
          item
            Name = 'Parameters'
            DataType = 'String'
          end
          item
            Name = 'Directory'
            DataType = 'String'
          end
          item
            Name = 'ShowCmd'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsShellExecuteEval
      end
      item
        Name = 'ShellExecuteWait'
        Parameters = <
          item
            Name = 'Filename'
            DataType = 'String'
          end
          item
            Name = 'Parameters'
            DataType = 'String'
          end
          item
            Name = 'Directory'
            DataType = 'String'
          end
          item
            Name = 'ShowCmd'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitSystemFunctionsShellExecuteWaitEval
      end
      item
        Name = 'ExitWindowsEx'
        Parameters = <
          item
            Name = 'Flags'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitSystemFunctionsExitWindowsExEval
      end
      item
        Name = 'WriteMailslot'
        Parameters = <
          item
            Name = 'Machine'
            DataType = 'String'
          end
          item
            Name = 'Mailslot'
            DataType = 'String'
          end
          item
            Name = 'Text'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitSystemFunctionsWriteMailslotEval
      end
      item
        Name = 'GetProcessList'
        Parameters = <>
        ResultType = 'TStringList'
        OnEval = dws2UnitSystemFunctionsGetProcessListEval
      end
      item
        Name = 'HiWord'
        Parameters = <
          item
            Name = 'Value'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsHiWordEval
      end
      item
        Name = 'IsFileActive'
        Parameters = <
          item
            Name = 'FileName'
            DataType = 'String'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitSystemFunctionsIsFileActiveEval
      end
      item
        Name = 'KillProcess'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'FileName'
            DataType = 'String'
          end
          item
            Name = 'KillAll'
            DataType = 'Boolean'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitSystemFunctionsKillProcessEval
      end
      item
        Name = 'LoWord'
        Parameters = <
          item
            Name = 'Value'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsLoWordEval
      end
      item
        Name = 'MakeLong'
        Parameters = <
          item
            Name = 'Low'
            DataType = 'Integer'
          end
          item
            Name = 'High'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsMakeLongEval
      end
      item
        Name = 'PostMessage'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'Msg'
            DataType = 'Integer'
          end
          item
            Name = 'WParam'
            DataType = 'Integer'
          end
          item
            Name = 'LParam'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitSystemFunctionsPostMessageEval
      end
      item
        Name = 'SendKeys'
        Parameters = <
          item
            Name = 'Keys'
            DataType = 'String'
          end>
        OnEval = dws2UnitSystemFunctionsSendKeysEval
      end
      item
        Name = 'SendKeysEx'
        Parameters = <
          item
            Name = 'Keys'
            DataType = 'String'
          end
          item
            Name = 'Wait'
            DataType = 'Integer'
          end>
        OnEval = dws2UnitSystemFunctionsSendKeysExEval
      end
      item
        Name = 'SendKeysNamedWin'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'String'
          end
          item
            Name = 'Keys'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsSendKeysNamedWinEval
      end
      item
        Name = 'SendKeysNamedWinEx'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'String'
          end
          item
            Name = 'Keys'
            DataType = 'String'
          end
          item
            Name = 'Wait'
            DataType = 'Integer'
          end
          item
            Name = 'Back'
            DataType = 'Boolean'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsSendKeysNamedWinExEval
      end
      item
        Name = 'SendKeysWin'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'Keys'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsSendKeysWinEval
      end
      item
        Name = 'SendKeysWinEx'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'Keys'
            DataType = 'String'
          end
          item
            Name = 'Wait'
            DataType = 'Integer'
          end
          item
            Name = 'Back'
            DataType = 'Boolean'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsSendKeysWinExEval
      end
      item
        Name = 'SendMessage'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'Msg'
            DataType = 'Integer'
          end
          item
            Name = 'WParam'
            DataType = 'Integer'
          end
          item
            Name = 'LParam'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitSystemFunctionsSendMessageEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFSystem'
    Variables = <>
    Left = 270
    Top = 80
  end
  object dws2UnitWindow: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'FindWindow'
        Parameters = <
          item
            Name = 'Class'
            DataType = 'String'
          end
          item
            Name = 'Window'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitWindowFunctionsFindWindowEval
      end
      item
        Name = 'FindWindowEx'
        Parameters = <
          item
            Name = 'Parent'
            DataType = 'Integer'
          end
          item
            Name = 'ChildAfter'
            DataType = 'Integer'
          end
          item
            Name = 'Class'
            DataType = 'String'
          end
          item
            Name = 'Window'
            DataType = 'String'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitWindowFunctionsFindWindowExEval
      end
      item
        Name = 'GetClassName'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitWindowFunctionsGetClassNameEval
      end
      item
        Name = 'GetWindowText'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'String'
        OnEval = dws2UnitWindowFunctionsGetWindowTextEval
      end
      item
        Name = 'HideTaskbar'
        Parameters = <>
        OnEval = dws2UnitWindowFunctionsHideTaskbarEval
      end
      item
        Name = 'IsIconic'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsIsIconicEval
      end
      item
        Name = 'IsWindow'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsIsWindowEval
      end
      item
        Name = 'IsWindowEnabled'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsIsWindowEnabledEval
      end
      item
        Name = 'IsWindowVisible'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsIsWindowVisibleEval
      end
      item
        Name = 'IsZoomed'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsIsZoomedEval
      end
      item
        Name = 'SearchWindow'
        Parameters = <
          item
            Name = 'Class'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Window'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'ProcID'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitWindowFunctionsSearchWindowEval
      end
      item
        Name = 'SearchWindowEx'
        Parameters = <
          item
            Name = 'Parent'
            DataType = 'Integer'
          end
          item
            Name = 'ChildAfter'
            DataType = 'Integer'
          end
          item
            Name = 'Class'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Window'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Num'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitWindowFunctionsSearchWindowExEval
      end
      item
        Name = 'ShowTaskbar'
        Parameters = <>
        OnEval = dws2UnitWindowFunctionsShowTaskbarEval
      end
      item
        Name = 'WaitForWindow'
        Parameters = <
          item
            Name = 'Class'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Window'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Timeout'
            DataType = 'Integer'
          end
          item
            Name = 'ProcID'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitWindowFunctionsWaitForWindowEval
      end
      item
        Name = 'WaitForWindowClose'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'Timeout'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsWaitForWindowCloseEval
      end
      item
        Name = 'WaitForWindowCloseEx'
        Parameters = <
          item
            Name = 'Class'
            DataType = 'String'
          end
          item
            Name = 'Window'
            DataType = 'String'
          end
          item
            Name = 'Timeout'
            DataType = 'Integer'
          end
          item
            Name = 'ProcID'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsWaitForWindowCloseExEval
      end
      item
        Name = 'WaitForWindowEnabled'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'Timeout'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsWaitForWindowEnabledEval
      end
      item
        Name = 'WaitForWindowEnabledEx'
        Parameters = <
          item
            Name = 'Class'
            DataType = 'String'
          end
          item
            Name = 'Window'
            DataType = 'String'
          end
          item
            Name = 'Timeout'
            DataType = 'Integer'
          end
          item
            Name = 'ProcID'
            DataType = 'Integer'
          end>
        ResultType = 'Boolean'
        OnEval = dws2UnitWindowFunctionsWaitForWindowEnabledExEval
      end
      item
        Name = 'WaitForWindowEx'
        Parameters = <
          item
            Name = 'Parent'
            DataType = 'Integer'
          end
          item
            Name = 'Class'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Window'
            DataType = 'String'
            IsVarParam = True
          end
          item
            Name = 'Timeout'
            DataType = 'Integer'
          end
          item
            Name = 'Num'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitWindowFunctionsWaitForWindowExEval
      end
      item
        Name = 'WindowMove'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'X'
            DataType = 'Integer'
          end
          item
            Name = 'Y'
            DataType = 'Integer'
          end
          item
            Name = 'Abs'
            DataType = 'Boolean'
          end>
        OnEval = dws2UnitWindowFunctionsWindowMoveEval
      end
      item
        Name = 'WindowResize'
        Parameters = <
          item
            Name = 'Window'
            DataType = 'Integer'
          end
          item
            Name = 'X'
            DataType = 'Integer'
          end
          item
            Name = 'Y'
            DataType = 'Integer'
          end
          item
            Name = 'Abs'
            DataType = 'Boolean'
          end>
        OnEval = dws2UnitWindowFunctionsWindowResizeEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFWindow'
    Variables = <>
    Left = 270
    Top = 130
  end
  object dws2UnitDialog: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal'
      'Classes')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'SelectStringDialog'
        Parameters = <
          item
            Name = 'Title'
            DataType = 'String'
          end
          item
            Name = 'Strings'
            DataType = 'TStringList'
          end
          item
            Name = 'Selected'
            DataType = 'Integer'
          end>
        ResultType = 'Integer'
        OnEval = dws2UnitDialogFunctionsSelectStringDialogEval
      end>
    Instances = <>
    Records = <>
    UnitName = 'MFDialog'
    Variables = <>
    Left = 50
    Top = 130
  end
end
