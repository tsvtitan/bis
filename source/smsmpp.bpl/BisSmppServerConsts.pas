unit BisSmppServerConsts;

interface

uses BisServerModules;

const
  DefaultTypeMessage=0;

resourcestring

  SParamHost='Host';
  SParamPort='Port';
  SParamSystemId='SystemId';
  SParamPassword='Password';
  SParamSystemType='SystemType';
  SParamRange='Range';
  SParamTypeOfNumber='TypeOfNumber';
  SParamPlanIndicator='PlanIndicator';
  SParamMode='Mode';
  SParamReadTimeout='ReadTimeout';
  SParamCheckTimeout='CheckTimeout';
  SParamSourceTypeOfNumber='SourceTypeOfNumber';
  SParamSourcePlanIndicator='SourcePlanIndicator';
  SParamSourceAddress='SourceAddress';
  SParamSourcePort='SourcePort';
  SParamDestTypeOfNumber='DestTypeOfNumber';
  SParamDestPlanIndicator='DestPlanIndicator';
  SParamDestPort='DestPort';
  SParamInterval='Interval';
  SParamMaxCount='MaxCount';
  SParamPeriod='Period';
  SParamOperatorIds='OperatorIds';
  SParamUnknownSender='UnknownSender';
  SParamUnknownCode='UnknownCode';

var
  ServerModule: TBisServerModule=nil;  

implementation

end.
