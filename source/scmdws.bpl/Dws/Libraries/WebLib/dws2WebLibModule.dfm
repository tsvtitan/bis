object dws2WebLib: Tdws2WebLib
  OldCreateOrder = False
  Left = 121
  Top = 536
  Height = 200
  Width = 400
  object customWebUnit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'Request'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'Param'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsParamEval
            Kind = mkClassFunction
          end
          item
            Name = 'Params'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsParamsEval
            Kind = mkClassFunction
          end
          item
            Name = 'ParamCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesRequestMethodsParamCountEval
            Kind = mkClassFunction
          end
          item
            Name = 'ParamName'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsParamNameEval
            Kind = mkClassFunction
          end
          item
            Name = 'ParamValue'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'string'
            OnEval = dws2WebUnitClassesRequestMethodsParamValueEval
            Kind = mkClassFunction
          end
          item
            Name = 'Authorization'
            Parameters = <>
            ResultType = 'string'
            OnEval = dws2WebUnitClassesRequestMethodsAuthorizationEval
            Kind = mkClassFunction
          end
          item
            Name = 'Content'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsContentEval
            Kind = mkClassFunction
          end
          item
            Name = 'ContentLength'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesRequestMethodsContentLengthEval
            Kind = mkClassFunction
          end
          item
            Name = 'ContentType'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsContentTypeEval
            Kind = mkClassFunction
          end
          item
            Name = 'CookieCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesRequestMethodsCookieCountEval
            Kind = mkClassFunction
          end
          item
            Name = 'Cookie'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsCookieEval
            Kind = mkClassFunction
          end
          item
            Name = 'CookieName'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsCookieNameEval
            Kind = mkClassFunction
          end
          item
            Name = 'CookieValue'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsCookieValueEval
            Kind = mkClassFunction
          end
          item
            Name = 'Date'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2WebUnitClassesRequestMethodsDateEval
            Kind = mkClassFunction
          end
          item
            Name = 'From'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsFromEval
            Kind = mkClassFunction
          end
          item
            Name = 'Host'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsHostEval
            Kind = mkClassFunction
          end
          item
            Name = 'PathInfo'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsPathInfoEval
            Kind = mkClassFunction
          end
          item
            Name = 'Referer'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsRefererEval
            Kind = mkClassFunction
          end
          item
            Name = 'RemoteAddr'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsRemoteAddrEval
            Kind = mkClassFunction
          end
          item
            Name = 'RemoteHost'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsRemoteHostEval
            Kind = mkClassFunction
          end
          item
            Name = 'ScriptName'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsScriptNameEval
            Kind = mkClassFunction
          end
          item
            Name = 'Title'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsTitleEval
            Kind = mkClassFunction
          end
          item
            Name = 'Url'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsUrlEval
            Kind = mkClassFunction
          end
          item
            Name = 'UserAgent'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsUserAgentEval
            Kind = mkClassFunction
          end
          item
            Name = 'Accept'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsAcceptEval
            Kind = mkClassFunction
          end
          item
            Name = 'Method'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsMethodEval
            Kind = mkClassFunction
          end
          item
            Name = 'LogContent'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesRequestMethodsLogContentEval
            Kind = mkClassFunction
          end>
        Properties = <>
      end
      item
        Name = 'Response'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'SetAllow'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetAllowEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetAllow'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetAllowEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetContent'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetContentEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetContent'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetContentEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetContentEncoding'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetContentEncodingEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetContentEncoding'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetContentEncodingEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetContentLength'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetContentLengthEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetContentLength'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesResponseMethodsGetContentLengthEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetContentType'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetContentTypeEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetContentType'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetContentTypeEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetContentVersion'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetContentVersionEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetContentVersion'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetContentVersionEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetDate'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetDateEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetDate'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2WebUnitClassesResponseMethodsGetDateEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetDerivedFrom'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetDerivedFromEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetDerivedFrom'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetDerivedFromEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetExpires'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetExpiresEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetExpires'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2WebUnitClassesResponseMethodsGetExpiresEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetLastModified'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetLastModifiedEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetLastModified'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2WebUnitClassesResponseMethodsGetLastModifiedEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetLocation'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetLocationEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetLocation'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetLocationEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetLogMessage'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetLogMessageEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetLogMessage'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetLogMessageEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetRealm'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetRealmEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetRealm'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetRealmEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetReasonString'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetReasonStringEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetReasonString'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetReasonStringEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetServer'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetServerEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetServer'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetServerEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetStatusCode'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Integer'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetStatusCodeEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetStatusCode'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesResponseMethodsGetStatusCodeEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetTitle'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetTitleEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetTitle'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetTitleEval
            Kind = mkClassFunction
          end
          item
            Name = 'SetVersion'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSetVersionEval
            Kind = mkClassProcedure
          end
          item
            Name = 'GetVersion'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesResponseMethodsGetVersionEval
            Kind = mkClassFunction
          end
          item
            Name = 'SendRedirect'
            Parameters = <
              item
                Name = 'Uri'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesResponseMethodsSendRedirectEval
            Kind = mkClassProcedure
          end
          item
            Name = 'CookieCount'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesResponseMethodsCookieCountEval
            Kind = mkClassFunction
          end
          item
            Name = 'Cookie'
            Parameters = <
              item
                Name = 'Index'
                DataType = 'Integer'
              end>
            ResultType = 'TCookie'
            OnEval = dws2WebUnitClassesResponseMethodsCookieEval
            Kind = mkClassFunction
          end
          item
            Name = 'CookieByName'
            Parameters = <
              item
                Name = 'Name'
                DataType = 'String'
              end>
            ResultType = 'TCookie'
            OnEval = dws2WebUnitClassesResponseMethodsCookieByNameEval
            Kind = mkClassFunction
          end
          item
            Name = 'NewCookie'
            Parameters = <>
            ResultType = 'TCookie'
            OnEval = dws2WebUnitClassesResponseMethodsNewCookieEval
            Kind = mkClassFunction
          end>
        Properties = <
          item
            Name = 'Allow'
            DataType = 'String'
            ReadAccess = 'GetAllow'
            WriteAccess = 'SetAllow'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Content'
            DataType = 'String'
            ReadAccess = 'GetContent'
            WriteAccess = 'SetContent'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ContentEncoding'
            DataType = 'String'
            ReadAccess = 'GetContentEncoding'
            WriteAccess = 'SetContentEncoding'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ContentLength'
            DataType = 'Integer'
            ReadAccess = 'GetContentLength'
            WriteAccess = 'SetContentLength'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ContentType'
            DataType = 'String'
            ReadAccess = 'GetContentType'
            WriteAccess = 'SetContentType'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ContentVersion'
            DataType = 'String'
            ReadAccess = 'GetContentVersion'
            WriteAccess = 'SetContentVersion'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Date'
            DataType = 'DateTime'
            ReadAccess = 'GetDate'
            WriteAccess = 'SetDate'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'DerivedFrom'
            DataType = 'String'
            ReadAccess = 'GetDerivedFrom'
            WriteAccess = 'SetDerivedFrom'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Expires'
            DataType = 'DateTime'
            ReadAccess = 'GetExpires'
            WriteAccess = 'SetExpires'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'LastModified'
            DataType = 'DateTime'
            ReadAccess = 'GetLastModified'
            WriteAccess = 'SetLastModified'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Location'
            DataType = 'String'
            ReadAccess = 'GetLocation'
            WriteAccess = 'SetLocation'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'LogMessage'
            DataType = 'String'
            ReadAccess = 'GetLogMessage'
            WriteAccess = 'SetLogMessage'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Realm'
            DataType = 'String'
            ReadAccess = 'GetRealm'
            WriteAccess = 'SetRealm'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'ReasonString'
            DataType = 'String'
            ReadAccess = 'GetReasonString'
            WriteAccess = 'SetReasonString'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Server'
            DataType = 'String'
            ReadAccess = 'GetServer'
            WriteAccess = 'SetServer'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'StatusCode'
            DataType = 'Integer'
            ReadAccess = 'GetStatusCode'
            WriteAccess = 'SetStatusCode'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Title'
            DataType = 'String'
            ReadAccess = 'GetTitle'
            WriteAccess = 'SetTitle'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Version'
            DataType = 'String'
            ReadAccess = 'GetVersion'
            WriteAccess = 'SetVersion'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'ScriptDoc'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'Date'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2WebUnitClassesScriptDocMethodsDateEval
            Kind = mkClassFunction
          end
          item
            Name = 'Size'
            Parameters = <>
            ResultType = 'Integer'
            OnEval = dws2WebUnitClassesScriptDocMethodsSizeEval
            Kind = mkClassFunction
          end
          item
            Name = 'FileName'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesScriptDocMethodsFileNameEval
            Kind = mkClassFunction
          end
          item
            Name = 'Path'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesScriptDocMethodsPathEval
            Kind = mkClassFunction
          end>
        Properties = <>
      end
      item
        Name = 'TCookie'
        Constructors = <>
        Fields = <>
        Methods = <
          item
            Name = 'SetDomain'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesTCookieMethodsSetDomainEval
            Kind = mkProcedure
          end
          item
            Name = 'GetDomain'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesTCookieMethodsGetDomainEval
            Kind = mkFunction
          end
          item
            Name = 'SetExpires'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'DateTime'
              end>
            OnEval = dws2WebUnitClassesTCookieMethodsSetExpiresEval
            Kind = mkProcedure
          end
          item
            Name = 'GetExpires'
            Parameters = <>
            ResultType = 'DateTime'
            OnEval = dws2WebUnitClassesTCookieMethodsGetExpiresEval
            Kind = mkFunction
          end
          item
            Name = 'GetHeaderValue'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesTCookieMethodsGetHeaderValueEval
            Kind = mkFunction
          end
          item
            Name = 'SetName'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesTCookieMethodsSetNameEval
            Kind = mkProcedure
          end
          item
            Name = 'GetName'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesTCookieMethodsGetNameEval
            Kind = mkFunction
          end
          item
            Name = 'SetPath'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesTCookieMethodsSetPathEval
            Kind = mkProcedure
          end
          item
            Name = 'GetPath'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesTCookieMethodsGetPathEval
            Kind = mkFunction
          end
          item
            Name = 'SetSecure'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'Boolean'
              end>
            OnEval = dws2WebUnitClassesTCookieMethodsSetSecureEval
            Kind = mkProcedure
          end
          item
            Name = 'GetSecure'
            Parameters = <>
            ResultType = 'Boolean'
            OnEval = dws2WebUnitClassesTCookieMethodsGetSecureEval
            Kind = mkFunction
          end
          item
            Name = 'SetValue'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = dws2WebUnitClassesTCookieMethodsSetValueEval
            Kind = mkProcedure
          end
          item
            Name = 'GetValue'
            Parameters = <>
            ResultType = 'String'
            OnEval = dws2WebUnitClassesTCookieMethodsGetValueEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Domain'
            DataType = 'String'
            ReadAccess = 'GetDomain'
            WriteAccess = 'SetDomain'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Expires'
            DataType = 'DateTime'
            ReadAccess = 'GetExpires'
            WriteAccess = 'SetExpires'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'HeaderValue'
            DataType = 'String'
            ReadAccess = 'GetHeaderValue'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Name'
            DataType = 'String'
            ReadAccess = 'GetName'
            WriteAccess = 'SetName'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Path'
            DataType = 'String'
            ReadAccess = 'GetPath'
            WriteAccess = 'SetPath'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Value'
            DataType = 'String'
            ReadAccess = 'GetValue'
            WriteAccess = 'SetValue'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Secure'
            DataType = 'Boolean'
            ReadAccess = 'GetSecure'
            WriteAccess = 'SetSecure'
            Parameters = <>
            IsDefault = False
          end>
      end
      item
        Name = 'TFormVarGroup'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <>
            OnAssignExternalObject = customWebUnitClassesTFormVarGroupConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'SetPrefix'
            Parameters = <
              item
                Name = 'Prefix'
                DataType = 'String'
              end>
            OnEval = customWebUnitClassesTFormVarGroupMethodsSetPrefixEval
            Kind = mkProcedure
          end
          item
            Name = 'GetPrefix'
            Parameters = <>
            ResultType = 'String'
            OnEval = customWebUnitClassesTFormVarGroupMethodsGetPrefixEval
            Kind = mkFunction
          end
          item
            Name = 'count'
            Parameters = <>
            ResultType = 'integer'
            OnEval = customWebUnitClassesTFormVarGroupMethodscountEval
            Kind = mkFunction
          end
          item
            Name = 'RecNr'
            Parameters = <>
            ResultType = 'integer'
            OnEval = customWebUnitClassesTFormVarGroupMethodsRecNrEval
            Kind = mkFunction
          end
          item
            Name = 'First'
            Parameters = <>
            OnEval = customWebUnitClassesTFormVarGroupMethodsFirstEval
            Kind = mkProcedure
          end
          item
            Name = 'Next'
            Parameters = <>
            OnEval = customWebUnitClassesTFormVarGroupMethodsNextEval
            Kind = mkProcedure
          end
          item
            Name = 'Eof'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customWebUnitClassesTFormVarGroupMethodsEofEval
            Kind = mkFunction
          end
          item
            Name = 'Ext'
            Parameters = <>
            ResultType = 'String'
            OnEval = customWebUnitClassesTFormVarGroupMethodsExtEval
            Kind = mkFunction
          end
          item
            Name = 'Value'
            Parameters = <>
            ResultType = 'String'
            OnEval = customWebUnitClassesTFormVarGroupMethodsValueEval
            Kind = mkFunction
          end
          item
            Name = 'SetAddNullFields'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'boolean'
              end>
            OnEval = customWebUnitClassesTFormVarGroupMethodsSetAddNullFieldsEval
            Kind = mkProcedure
          end
          item
            Name = 'GetAddNullFields'
            Parameters = <>
            ResultType = 'boolean'
            OnEval = customWebUnitClassesTFormVarGroupMethodsGetAddNullFieldsEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Prefix'
            DataType = 'String'
            ReadAccess = 'GetPrefix'
            WriteAccess = 'SetPrefix'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'AddNullFields'
            DataType = 'boolean'
            ReadAccess = 'GetAddNullFields'
            WriteAccess = 'SetAddNullFields'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Enumerations = <>
    Forwards = <
      item
        Name = 'TCookie'
      end>
    Functions = <
      item
        Name = 'FormVar'
        Parameters = <
          item
            Name = 'ParamName'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2WebUnitFunctionsFormVarEval
      end
      item
        Name = 'RtfToHtml'
        Parameters = <
          item
            Name = 'RtfStr'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2WebUnitFunctionsRtfToHtmlEval
      end
      item
        Name = 'TrimURL'
        Parameters = <
          item
            Name = 'sURL'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2WebUnitFunctionsTrimURLEval
      end
      item
        Name = 'AcceptWML'
        Parameters = <>
        ResultType = 'boolean'
        OnEval = dws2WebUnitFunctionsacceptWMLEval
      end
      item
        Name = 'URLencode'
        Parameters = <
          item
            Name = 'sURL'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2WebUnitFunctionsURLencodeEval
      end
      item
        Name = 'URLdecode'
        Parameters = <
          item
            Name = 'sURL'
            DataType = 'String'
          end>
        ResultType = 'String'
        OnEval = dws2WebUnitFunctionsURLdecodeEval
      end
      item
        Name = '_forward'
        Parameters = <
          item
            Name = 'NewFile'
            DataType = 'String'
          end>
        OnEval = dws2WebUnitFunctionsforwardEval
      end>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'WebUnit'
    Variables = <>
    Left = 52
    Top = 20
  end
end
