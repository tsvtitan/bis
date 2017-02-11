object dws2SessionLib: Tdws2SessionLib
  OldCreateOrder = False
  Left = 275
  Top = 161
  Height = 479
  Width = 741
  object customSessionUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'Session'
        Fields = <>
        Methods = <
          item
            Name = 'GetActiveUsers'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesUserMethodsGetActiveUsersEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'SetIpAddr'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
                IsVarParam = False
              end>
            OnEval = dws2UnitClassesUserMethodsSetIpAddrEval
            Attributes = []
            Kind = mkClassProcedure
          end
          item
            Name = 'GetIpAddr'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitClassesUserMethodsGetIpAddrEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'SetCState'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
                IsVarParam = False
              end>
            OnEval = dws2UnitClassesUserMethodsSetSstateEval
            Attributes = []
            Kind = mkClassProcedure
          end
          item
            Name = 'GetCState'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2UnitClassesUserMethodsGetSstateEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'SetSBrand'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
                IsVarParam = False
              end>
            OnEval = dws2UnitClassesUserMethodsSetSBrandEval
            Attributes = []
            Kind = mkClassProcedure
          end
          item
            Name = 'GetSBrand'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2UnitClassesUserMethodsGetSBrandEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'SetTLogin'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
                IsVarParam = False
              end>
            OnEval = dws2UnitClassesUserMethodsSetTLoginEval
            Attributes = []
            Kind = mkClassProcedure
          end
          item
            Name = 'GetTLogin'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2UnitClassesUserMethodsGetTLoginEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'SetTLastAction'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
                IsVarParam = False
              end>
            OnEval = dws2UnitClassesUserMethodsSetTLastActionEval
            Attributes = []
            Kind = mkClassProcedure
          end
          item
            Name = 'GetTLastAction'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2UnitClassesUserMethodsGetTLastActionEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'Param'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'string'
                IsVarParam = False
              end>
            ResultType = 'variant'
            OnEval = dws2UnitClassesUserMethodsGetUserdataEval
            Attributes = []
            Kind = mkClassFunction
          end
          item
            Name = 'Store'
            Parameters = <
              item
                Name = 'name'
                DataType = 'string'
                IsVarParam = False
              end
              item
                Name = 'value'
                DataType = 'variant'
                IsVarParam = False
              end>
            OnEval = customSessionUnitClassesUserMethodsSetUserDataEval
            Attributes = []
            Kind = mkClassProcedure
          end>
        Properties = <
          item
            Name = 'ActiveUsers'
            DataType = 'Integer'
            ReadAccess = 'GetActiveUsers'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'IpAddr'
            DataType = 'String'
            ReadAccess = 'GetIpAddr'
            WriteAccess = 'SetIpAddr'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ClientState'
            DataType = 'Integer'
            ReadAccess = 'GetCState'
            WriteAccess = 'SetCState'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'SBrand'
            DataType = 'String'
            ReadAccess = 'GetSbrand'
            WriteAccess = 'SetSbrand'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'TLogin'
            DataType = 'DateTime'
            ReadAccess = 'GetTlogin'
            WriteAccess = 'SetTlogin'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'TLastAction'
            DataType = 'DateTime'
            ReadAccess = 'GetTLastAction'
            WriteAccess = 'SetTLastAction'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <
      item
        Name = 'dwstateTOUT'
        DataType = 'integer'
        Value = '-2'
      end
      item
        Name = 'dwstateLOFF'
        DataType = 'Integer'
        Value = '-1'
      end
      item
        Name = 'dwstateNLI'
        DataType = 'Integer'
        Value = 0
      end
      item
        Name = 'dwstateGLI'
        DataType = 'Integer'
        Value = 1
      end
      item
        Name = 'dwstatePRF'
        DataType = 'Integer'
        Value = 9
      end
      item
        Name = 'dwstateULI'
        DataType = 'Integer'
        Value = 10
      end
      item
        Name = 'dwstateNAT'
        DataType = 'Integer'
        Value = 12
      end
      item
        Name = 'dwstateVIP'
        DataType = 'Integer'
        Value = 20
      end
      item
        Name = 'dwstateSU'
        DataType = 'Integer'
        Value = 100
      end
      item
        Name = 'Version'
        DataType = 'String'
        Value = '2.1.2001.6.20'
      end>
    Forwards = <>
    Functions = <
      item
        Name = 'TIDfunc'
        Parameters = <>
        ResultType = 'String'
        OnEval = dws2UnitFunctionsTIDEval
      end
      item
        Name = 'ActiveSession'
        Parameters = <>
        ResultType = 'boolean'
        OnEval = customSessionUnitFunctionsActivSessionEval
      end
      item
        Name = 'URL'
        Parameters = <
          item
            Name = 'AnURL'
            DataType = 'String'
            IsVarParam = False
          end>
        ResultType = 'String'
        OnEval = customSessionUnitFunctionsURLEval
      end>
    Records = <>
    UnitName = 'SessionManager'
    Variables = <>
    Left = 36
    Top = 12
  end
end
