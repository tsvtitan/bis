object dws2WebModule: Tdws2WebModule
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'DefaultActionItem'
      PathInfo = '/'
      Producer = dws2PageProducer
    end>
  Left = 108
  Top = 187
  Height = 264
  Width = 468
  object dws2PageProducer: Tdws2PageProducer
    Debugging = False
    WebLib = dws2WebLib
    Left = 260
    Top = 44
  end
  object Script: TDelphiWebScriptII
    Config.Filter = dws2HtmlFilter1
    Config.CompilerOptions = []
    Config.MaxDataSize = 0
    Config.Timeout = 0
    Left = 48
    Top = 24
  end
  inline dws2WebLib: Tdws2WebLib
    OldCreateOrder = False
    Script = Script
    SessionManager = dws2SessionLib
    CustomCommand = 'action'
    DumpPatternOpen = '<!--%%'
    DumpPatternClose = '%%-->'
    Left = 368
    Top = 24
    Height = 0
    Width = 0
  end
  object dws2FileFunctions: Tdws2FileFunctions
    Left = 160
    Top = 24
  end
  inline dws2SessionLib: Tdws2SessionLib
    OldCreateOrder = False
    Script = Script
    SessionCookiePrefix = 'DWSC'
    SessionCookieExpireTime = 0.2
    SessionExpireTime = 0.001
    SessionTouchTime = 0.001
    SessionBrandLabel = 'TID'
    UseSessionCookie = False
    Left = 368
    Top = 72
    Height = 0
    Width = 0
  end
  object dws2Unit: Tdws2Unit
    Script = Script
    Arrays = <>
    Classes = <>
    Constants = <
      item
        Name = 'Version'
        DataType = 'String'
        Value = '1.3.2003.5.1'
      end>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'Module'
    Variables = <>
    Left = 48
    Top = 72
  end
  inline dws2ClassesLib: Tdws2ClassesLib
    OldCreateOrder = False
    Script = Script
    Left = 368
    Top = 168
    Height = 0
    Width = 0
  end
  object dws2HtmlFilter1: Tdws2HtmlFilter
    PatternClose = '%>'
    PatternEval = '='
    PatternOpen = '<%'
    Left = 168
    Top = 156
  end
  object dws2HtmlUnit1: Tdws2HtmlUnit
    Script = Script
    Left = 168
    Top = 112
  end
  object dws2SimpleDebugger1: Tdws2SimpleDebugger
    Left = 264
    Top = 132
  end
  inline dws2DbLib: Tdws2DbLib
    OldCreateOrder = False
    Script = Script
    Left = 368
    Top = 124
    Height = 0
    Width = 0
  end
end
