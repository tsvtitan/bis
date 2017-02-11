object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 192
  Top = 107
  Height = 480
  Width = 696
  object dws2Unit1: Tdws2Unit
    Arrays = <>
    Classes = <>
    Constants = <>
    Dependencies.Strings = (
      'Internal')
    Enumerations = <>
    Forwards = <>
    Functions = <
      item
        Name = 'Hello'
        Parameters = <>
        ResultType = 'string'
        OnEval = dws2Unit1FunctionsHelloEval
      end>
    Instances = <>
    Records = <>
    Synonyms = <>
    UnitName = 'PlugIn1'
    Variables = <>
    StaticSymbols = False
    Left = 152
    Top = 56
  end
end
