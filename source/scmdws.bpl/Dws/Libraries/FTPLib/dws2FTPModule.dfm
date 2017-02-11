object dws2FTPLib: Tdws2FTPLib
  OldCreateOrder = False
  Left = 283
  Top = 343
  Height = 200
  Width = 400
  object customFTPUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TFTPConnection'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = customFTPUnitClassesTFTPConnectionConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'Free'
            Parameters = <>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsFreeEval
            Kind = mkDestructor
          end
          item
            Name = 'Open'
            Parameters = <
              item
                Name = 'Host'
                DataType = 'string'
              end
              item
                Name = 'UserID'
                DataType = 'string'
              end
              item
                Name = 'PWD'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsOpenEval
            Kind = mkFunction
          end
          item
            Name = 'GetFile'
            Parameters = <
              item
                Name = 'Source'
                DataType = 'string'
              end
              item
                Name = 'Dest'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetFileEval
            Kind = mkFunction
          end
          item
            Name = 'PutFile'
            Parameters = <
              item
                Name = 'Source'
                DataType = 'string'
              end
              item
                Name = 'Dest'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsPutFileEval
            Kind = mkFunction
          end
          item
            Name = 'Execute'
            Parameters = <
              item
                Name = 'Command'
                DataType = 'string'
              end>
            ResultType = 'integer'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsExecuteEval
            Kind = mkFunction
          end
          item
            Name = 'CreateSAVF'
            Parameters = <
              item
                Name = 'Library'
                DataType = 'string'
              end
              item
                Name = 'File'
                DataType = 'string'
              end
              item
                Name = 'Description'
                DataType = 'string'
              end>
            ResultType = 'integer'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsCreateSAVFEval
            Kind = mkFunction
          end
          item
            Name = 'SetHost'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'string'
              end>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsSetHostEval
            Kind = mkProcedure
          end
          item
            Name = 'GetHost'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetHostEval
            Kind = mkFunction
          end
          item
            Name = 'SetUserID'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'string'
              end>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsSetUserIDEval
            Kind = mkProcedure
          end
          item
            Name = 'GetUserID'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetUserIDEval
            Kind = mkFunction
          end
          item
            Name = 'SetPwd'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'string'
              end>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsSetPwdEval
            Kind = mkProcedure
          end
          item
            Name = 'GetPWD'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetPWDEval
            Kind = mkFunction
          end
          item
            Name = 'SetDefaultDir'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'string'
              end>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsSetDefaultDirEval
            Kind = mkProcedure
          end
          item
            Name = 'GetDefaultDir'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetDefaultDirEval
            Kind = mkFunction
          end
          item
            Name = 'Status'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetStatusEval
            Kind = mkFunction
          end
          item
            Name = 'CurrentDir'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetCurrentDirEval
            Kind = mkFunction
          end
          item
            Name = 'DeleteFile'
            Parameters = <
              item
                Name = 'FileName'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsDeleteFileEval
            Kind = mkFunction
          end
          item
            Name = 'RemoveDir'
            Parameters = <
              item
                Name = 'Dirname'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsRemoveDirEval
            Kind = mkFunction
          end
          item
            Name = 'Close'
            Parameters = <>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsCloseEval
            Kind = mkProcedure
          end
          item
            Name = 'Connect'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsConnectEval
            Kind = mkFunction
          end
          item
            Name = 'Disconnect'
            Parameters = <>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsDisconnectEval
            Kind = mkProcedure
          end
          item
            Name = 'ChangeDir'
            Parameters = <
              item
                Name = 'Dirname'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsChangeDirEval
            Kind = mkFunction
          end
          item
            Name = 'MakeDir'
            Parameters = <
              item
                Name = 'Dirname'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsMakeDirEval
            Kind = mkFunction
          end
          item
            Name = 'Abort'
            Parameters = <>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsAbortEval
            Kind = mkProcedure
          end
          item
            Name = 'Filesize'
            Parameters = <
              item
                Name = 'Filename'
                DataType = 'string'
              end>
            ResultType = 'integer'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsFilesizeEval
            Kind = mkFunction
          end
          item
            Name = 'IsDirectory'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'string'
              end>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsIsDirectoryEval
            Kind = mkFunction
          end
          item
            Name = 'FindFirst'
            Parameters = <
              item
                Name = 'Specifier'
                DataType = 'string'
              end>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsFindFirstEval
            Kind = mkFunction
          end
          item
            Name = 'FindNext'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsFindNextEval
            Kind = mkFunction
          end
          item
            Name = 'FindClose'
            Parameters = <>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsFindCloseEval
            Kind = mkProcedure
          end
          item
            Name = 'LastError'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsLastErrorEval
            Kind = mkFunction
          end
          item
            Name = 'LastResponse'
            Parameters = <>
            ResultType = 'string'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsLastResponseEval
            Kind = mkFunction
          end
          item
            Name = 'SetLogFile'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'string'
              end>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsSetLogFileEval
            Kind = mkProcedure
          end
          item
            Name = 'GetLogFile'
            Parameters = <>
            ResultType = 'string'
            Kind = mkFunction
          end
          item
            Name = 'SetMaskPassword'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'boolean'
              end>
            OnEval = customFTPUnitClassesTFTPConnectionMethodsSetMaskPasswordEval
            Kind = mkProcedure
          end
          item
            Name = 'GetMaskPassword'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customFTPUnitClassesTFTPConnectionMethodsGetMaskPasswordEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Host'
            DataType = 'string'
            ReadAccess = 'GetHost'
            WriteAccess = 'SetHost'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Username'
            DataType = 'string'
            ReadAccess = 'GetUserID'
            WriteAccess = 'SetUserID'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Password'
            DataType = 'string'
            ReadAccess = 'GetPwd'
            WriteAccess = 'SetPwd'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'LogFile'
            DataType = 'string'
            ReadAccess = 'GetLogFile'
            WriteAccess = 'SetLogFile'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'DefaultDir'
            DataType = 'string'
            ReadAccess = 'GetDefaultDir'
            WriteAccess = 'SetDefaultDir'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'MaskPassword'
            DataType = 'boolean'
            ReadAccess = 'GetMaskPassword'
            WriteAccess = 'SetMaskPassword'
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
    Synonyms = <>
    UnitName = 'FTP'
    Variables = <>
    Left = 40
    Top = 16
  end
end
