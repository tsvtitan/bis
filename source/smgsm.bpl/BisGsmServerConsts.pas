unit BisGsmServerConsts;

interface

uses BisServerModules;

const
  DefaultTypeMessage=0;

resourcestring

  SParamComPort='ComPort';
  SParamMode='Mode';
  SParamInterval='Interval';
  SParamStorages='Storages';
  SParamMaxCount='MaxCount';
  SParamTimeout='Timeout';
  SParamImei='Imei';
  SParamImsi='Imsi';
  SParamBaudRate='BaudRate';
  SParamDataBits='DataBits';
  SParamStopBits='StopBits';
  SParamParityBits='ParityBits';
  SParamUnknownSender='UnknownSender';
  SParamUnknownCode='UnknownCode';
  SParamPeriod='Period';
  SParamDestPort='DestPort';
  SParamSourcePort='SParamSourcePort';
  SParamOperatorIds='ParamOperatorIds';

var
  ServerModule: TBisServerModule=nil;  

implementation

end.
