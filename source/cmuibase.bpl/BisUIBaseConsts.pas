unit BisUIBaseConsts;

interface

const
  MaxValueSize=250;
  
resourcestring

  SFrom='FROM';
  SWhere='WHERE';
  SPrefix='/*PREFIX*/';
  SNull='NULL';
  STransactionParams='read_committed'+#13#10+'rec_version'+#13#10+'nowait';

  SDBParamDatabase='Database';
  SDBParamPrefix='Prefix';
  SDBParamTimeOut='TimeOut';
  SDBParamUserName='User_name';
  SDBParamPassword='Password';
  SDBParamCharacterSet='CharacterSet';
  SDBParamCheckVersion='CheckVersion';
  SDBParamMaxRecordCount='MaxRecordCount';
  SDBParamSweepTimeOut='SweepTimeOut';


implementation

end.
