{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11625: IdIdentServer.pas 
{
{   Rev 1.7    2004.02.03 5:43:48 PM  czhower
{ Name changes
}
{
{   Rev 1.6    1/21/2004 3:10:38 PM  JPMugaas
{ InitComponent
}
{
    Rev 1.5    3/27/2003 3:42:02 PM  BGooijen
  Changed because some properties are moved to IOHandler
}
{
{   Rev 1.4    2/24/2003 09:00:38 PM  JPMugaas
}
{
{   Rev 1.3    1/17/2003 07:10:32 PM  JPMugaas
{ Now compiles under new framework.
}
{
{   Rev 1.2    1-1-2003 20:13:20  BGooijen
{ Changed to support the new TIdContext class
}
{
{   Rev 1.1    12/6/2002 04:35:16 PM  JPMugaas
{ Now compiles with new code.
}
{
{   Rev 1.0    11/13/2002 07:54:44 AM  JPMugaas
}
unit IdIdentServer;

{2001 - Feb 11 - J. Peter Mugaas
        Started this component.

        This is based on RFC 1413  - Identification Protocol

        Note that the default port is assigned to IdPORT_AUTH

        The reason for this is that the RFC specifies port 113 and the old protocol name was
        Authentication Server Protocol.  This was renamed Ident to better reflect what it does.
        }

interface
uses IdAssignedNumbers, IdContext, IdTCPServer, Classes;

const IdDefIdentQueryTimeOut = 60000; // 1 minute
type  TIdIdentQueryEvent = procedure (AContext:TIdContext; AServerPort, AClientPort : Integer) of object;
      TIdIdentErrorType = (ieInvalidPort, ieNoUser, ieHiddenUser, ieUnknownError);
      TIdIdentServer = class(TIdTCPServer)
      protected
        FOnIdentQuery : TIdIdentQueryEvent;
        FQueryTimeOut : Integer;
        function DoExecute(AContext:TIdContext): boolean; override;
        procedure InitComponent; override;
      public
        Procedure ReplyError(AContext:TIdContext; AServerPort, AClientPort : Integer; AErr : TIdIdentErrorType);
        Procedure ReplyIdent(AContext:TIdContext; AServerPort, AClientPort : Integer; AOS, AUserName : String; const ACharset : String = '');    {Do not Localize}
        Procedure ReplyOther(AContext:TIdContext; AServerPort, AClientPort : Integer; AOther : String);
      published
        property QueryTimeOut : Integer read FQueryTimeOut write FQueryTimeOut default IdDefIdentQueryTimeOut;
        Property OnIdentQuery : TIdIdentQueryEvent read FOnIdentQuery write FOnIdentQuery;
        Property DefaultPort default IdPORT_AUTH;
      end;

implementation

uses
  IdGlobal, SysUtils;

{ TIdIdentServer }

procedure TIdIdentServer.InitComponent;
begin
  inherited;
  DefaultPort := IdPORT_AUTH;
  FQueryTimeOut := IdDefIdentQueryTimeOut;
end;

function TIdIdentServer.DoExecute(AContext:TIdContext): boolean;
var s : String;
    ServerPort, ClientPort : Integer;
begin
  Result := True;
  s := AContext.Connection.IOHandler.ReadLn('',FQueryTimeOut);    {Do not Localize}
  if AContext.Connection.IOHandler.ReadLnTimedOut then
  begin
    AContext.Connection.Disconnect;
  end
  else
  begin
    ServerPort := StrToInt(Trim(Fetch(s,',')));    {Do not Localize}
    ClientPort := StrToInt(Trim(s));
    If Assigned(FOnIdentQuery) then
      FOnIdentQuery(AContext,ServerPort,ClientPort)
    else
    begin
      ReplyError(AContext,ServerPort,ClientPort,ieUnknownError);
      AContext.Connection.Disconnect;
    end;
  end;
end;

procedure TIdIdentServer.ReplyError(AContext:TIdContext; AServerPort,
  AClientPort: Integer;  AErr : TIdIdentErrorType);
var s : String;
begin
  s := IntToStr(AServerPort)+', '+IntToStr(AClientPort) + ' : ERROR : ';    {Do not Localize}
  case AErr of
    ieInvalidPort : s := s + 'INVALID-PORT';    {Do not Localize}
    ieNoUser : s := s + 'NO-USER';    {Do not Localize}
    ieHiddenUser : s := s + 'HIDDEN-USER';    {Do not Localize}
    ieUnknownError : s := s + 'UNKNOWN-ERROR';    {Do not Localize}
  end;
  AContext.Connection.IOHandler.WriteLn(s);
end;

procedure TIdIdentServer.ReplyIdent(AContext:TIdContext; AServerPort,
  AClientPort: Integer; AOS, AUserName: String; const ACharset: String);
var s : String;
begin
  s := IntToStr(AServerPort)+', '+IntToStr(AClientPort) + ' : USERID : ';    {Do not Localize}
  s := s + AOS;
  if Length(ACharset) > 0 then
    s := s + ','+ACharset;    {Do not Localize}
  s := s + ' : '+AUserName;    {Do not Localize}
  AContext.Connection.IOHandler.WriteLn(s);
end;

procedure TIdIdentServer.ReplyOther(AContext:TIdContext; AServerPort,
  AClientPort: Integer; AOther: String);
begin
  AContext.Connection.IOHandler.WriteLn(IntToStr(AServerPort)+', '+IntToStr(AClientPort) + ' : USERID : OTHER : '+AOther);    {Do not Localize}
end;

end.
