unit IdSysVCLNET;

interface
uses IdSysVCL;

type
  TIdSysVCLNET = class(TIdSysVCL)
  public
    class function OffsetFromUTC: TIdDateTimeBase;// override;

  end;

implementation

{ TIdSysVCLNET }

class function TIdSysVCLNET.OffsetFromUTC: TIdDateTimeBase;
begin
  Result := System.Timezone.CurrentTimezone.GetUTCOffset(DateTime.FromOADate(Now)).TotalDays;
end;

end.
