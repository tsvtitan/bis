object dws2SMTPlib: Tdws2SMTPlib
  OldCreateOrder = False
  Left = 161
  Top = 525
  Height = 214
  Width = 741
  object customSMTPunit: Tdws2Unit
    Arrays = <>
    Classes = <
      item
        Name = 'TSMTPMail'
        Constructors = <
          item
            Name = 'Create'
            Parameters = <
              item
                Name = 'Host'
                DataType = 'String'
              end
              item
                Name = 'From'
                DataType = 'String'
              end
              item
                Name = 'To'
                DataType = 'String'
              end>
            OnAssignExternalObject = customSMTPunitClassesTSMTPMailConstructorsCreateAssignExternalObject
          end>
        Fields = <>
        Methods = <
          item
            Name = 'GetBody'
            Parameters = <>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsGetBodyEval
            Kind = mkFunction
          end
          item
            Name = 'SetBody'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsSetBodyEval
            Kind = mkProcedure
          end
          item
            Name = 'AddLine'
            Parameters = <
              item
                Name = 'Line'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsAddLineEval
            Kind = mkProcedure
          end
          item
            Name = 'Clear'
            Parameters = <>
            OnEval = customSMTPunitClassesSMTPMsgMethodsClearEval
            Kind = mkProcedure
          end
          item
            Name = 'GetSubject'
            Parameters = <>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsGetSubjectEval
            Kind = mkFunction
          end
          item
            Name = 'SetSubject'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsSetSubjectEval
            Kind = mkProcedure
          end
          item
            Name = 'AddAddress'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsAddAddressEval
            Kind = mkProcedure
          end
          item
            Name = 'GetAddress'
            Parameters = <>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsGetAddressEval
            Kind = mkFunction
          end
          item
            Name = 'SetAddress'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsSetAddressEval
            Kind = mkProcedure
          end
          item
            Name = 'AddCC'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsAddCCEval
            Kind = mkProcedure
          end
          item
            Name = 'GetCC'
            Parameters = <>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsGetCCEval
            Kind = mkFunction
          end
          item
            Name = 'SetCC'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsSetCCEval
            Kind = mkProcedure
          end
          item
            Name = 'AddBCC'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsAddBCCEval
            Kind = mkProcedure
          end
          item
            Name = 'GetBCC'
            Parameters = <>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsGetBCCEval
            Kind = mkFunction
          end
          item
            Name = 'SetBCC'
            Parameters = <
              item
                Name = 'Value'
                DataType = 'String'
              end>
            OnEval = customSMTPunitClassesSMTPMsgMethodsSetBCCEval
            Kind = mkProcedure
          end
          item
            Name = 'SendMail'
            Parameters = <>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsSendMailEval
            Kind = mkFunction
          end
          item
            Name = 'QuickMail'
            Parameters = <
              item
                Name = 'From'
                DataType = 'String'
              end
              item
                Name = 'To'
                DataType = 'String'
              end
              item
                Name = 'Subject'
                DataType = 'String'
              end
              item
                Name = 'Body'
                DataType = 'String'
              end>
            ResultType = 'String'
            OnEval = customSMTPunitClassesSMTPMsgMethodsQuickMailEval
            Kind = mkFunction
          end>
        Properties = <
          item
            Name = 'Subject'
            DataType = 'String'
            ReadAccess = 'GetSubject'
            WriteAccess = 'SetSubject'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Body'
            DataType = 'String'
            ReadAccess = 'GetBody'
            WriteAccess = 'SetBody'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'Address'
            DataType = 'String'
            ReadAccess = 'GetAddress'
            WriteAccess = 'SetAddress'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'CC'
            DataType = 'String'
            ReadAccess = 'GetCC'
            WriteAccess = 'SetCC'
            Parameters = <>
            IsDefault = False
          end
          item
            Name = 'BCC'
            DataType = 'String'
            ReadAccess = 'GetBCC'
            WriteAccess = 'SetBCC'
            Parameters = <>
            IsDefault = False
          end>
      end>
    Constants = <>
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    UnitName = 'SMTPunit'
    Variables = <>
    Left = 40
    Top = 24
  end
  object NMSMTP1: TNMSMTP
    Port = 25
    TimeOut = 25
    ReportLevel = 0
    UserID = 'DWS webmail'
    EncodeType = uuMime
    ClearParams = True
    SubType = mtPlain
    Charset = 'ISO-8859-1'
    Left = 132
    Top = 24
  end
end
