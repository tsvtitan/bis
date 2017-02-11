{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11793: IdTimeUDP.pas 
{
{   Rev 1.6    2004.02.03 5:44:36 PM  czhower
{ Name changes
}
{
{   Rev 1.5    1/21/2004 4:21:00 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.4    1/3/2004 1:00:06 PM  JPMugaas
{ These should now compile with Kudzu's change in IdCoreGlobal.
}
{
{   Rev 1.3    10/26/2003 5:16:52 PM  BGooijen
{ Works now, times in GetTickDiff were in wrong order
}
{
{   Rev 1.2    10/22/2003 04:54:26 PM  JPMugaas
{ Attempted to get these to work.
}
{
{   Rev 1.1    2003.10.12 6:36:46 PM  czhower
{ Now compiles.
}
{
{   Rev 1.0    11/13/2002 08:03:24 AM  JPMugaas
}
unit IdTimeUDP;

interface

uses Classes, IdAssignedNumbers, IdUDPBase, IdUDPClient;

const
  {This indicates that the default date is Jan 1, 1900 which was specified
    by RFC 868.}
  TIMEUDP_BASEDATE = 2;

type
  TIdTimeUDP = class(TIdUDPClient)
  protected
    FBaseDate: TDateTime;
    FRoundTripDelay: Cardinal;
    //
    function GetDateTimeCard: Cardinal;
    function GetDateTime: TDateTime;
    procedure InitComponent; override;
  public
    {This synchronizes the local clock with the Time Server}
    function SyncTime: Boolean;
    {This is the number of seconds since 12:00 AM, 1900 - Jan-1}
    property DateTimeCard: Cardinal read GetDateTimeCard;
    {This is the current time according to the server.  TimeZone and Time used
    to receive the data are accounted for}
    property DateTime: TDateTime read GetDateTime;
    {This is the time it took to receive the Time from the server.  There is no
    need to use this to calculate the current time when using DateTime property
    as we have done that here}
    property RoundTripDelay: Cardinal read FRoundTripDelay;
  published
    {This property is used to set the Date that the Time server bases its
     calculations from.  If both the server and client are based from the same
     date which is higher than the original date, you can extend it beyond the
     year 2035}
    property BaseDate: TDateTime read FBaseDate write FBaseDate;
    property Port default IdPORT_TIME;
  end;

implementation

uses
  IdGlobal, IdGlobalProtocols, IdStack;

{ TIdTimeUDP }

procedure TIdTimeUDP.InitComponent;
begin
  inherited;
  Port := IdPORT_TIME;
  {This indicates that the default date is Jan 1, 1900 which was specified
    by RFC 868.}
  FBaseDate := TIMEUDP_BASEDATE;
end;

function TIdTimeUDP.GetDateTime: TDateTime;
var
  BufCard: Cardinal;
begin
  BufCard := GetDateTimeCard;
  if BufCard <> 0 then begin
    {The formula is The Time cardinal we receive divided by (24 * 60*60 for days + RoundTrip divided by one-thousand since this is based on seconds
    - the Time Zone difference}
    Result := ( ((BufCard + (FRoundTripDelay div 1000))/ (24 * 60 * 60) ) + Int(fBaseDate))
                - TimeZoneBias;
  end else begin
    { Somehow, I really doubt we are ever going to really get a time such as
    12/30/1899 12:00 am so use that as a failure test}
    Result := 0;
  end;
end;

function TIdTimeUDP.GetDateTimeCard: Cardinal;
var
  LTimeBeforeRetrieve: Cardinal;
  LBuffer : TIdBytes;
begin
  //Important - This must send an empty UDP Datagram
  Send('');    {Do not Localize}
  LTimeBeforeRetrieve := Ticks;
  SetLength(LBuffer,4);

  ReceiveBuffer(LBuffer);
  Result := BytesToCardinal(LBuffer);
  Result := GStack.NetworkToHost(Result);
  {Theoritically, it should take about 1/2 of the time to receive the data
   but in practice, it could be any portion depending upon network conditions. This is also
   as per RFC standard}
  {This is just in case the TickCount rolled back to zero}
  FRoundTripDelay := GetTickDiff(LTimeBeforeRetrieve, Ticks) div 2;
end;

function TIdTimeUDP.SyncTime: Boolean;
var
  LBufTime: TDateTime;
begin
  LBufTime := DateTime;
  Result := LBufTime <> 0;
  if Result then begin
    Result := SetLocalTime(LBufTime);
  end;
end;

end.
