{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11978: IdServerIOHandlerStack.pas 
{
{   Rev 1.11    2004.02.03 4:16:50 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.10    2004.01.20 10:03:34 PM  czhower
{ InitComponent
}
{
{   Rev 1.9    2003.09.19 10:11:20 PM  czhower
{ Next stage of fiber support in servers.
}
{
{   Rev 1.8    2003.09.19 11:54:34 AM  czhower
{ -Completed more features necessary for servers
{ -Fixed some bugs
}
{
{   Rev 1.7    2003.09.18 4:10:28 PM  czhower
{ Preliminary changes for Yarn support.
}
{
    Rev 1.6    3/23/2003 11:27:48 PM  BGooijen
  Added MakeClientIOHandler
}
{
    Rev 1.5    3/13/2003 10:18:24 AM  BGooijen
  Server side fibers, bug fixes
}
{
{   Rev 1.4    1-17-2003 22:22:06  BGooijen
{ new design
}
{
{   Rev 1.3    1-1-2003 16:27:50  BGooijen
{ Changed TIdThread to TIdYarn
}
{
{   Rev 1.2    12-7-2002 17:04:02  BGooijen
{ Now descends from TIdServerIOHandlerSocket.
}
{
{   Rev 1.1    12-7-2002 12:34:40  BGooijen
{ Re-enabled IPv6 support
}
{
{   Rev 1.0    11/13/2002 08:58:34 AM  JPMugaas
}
unit IdServerIOHandlerStack;

interface

Uses
  IdSocketHandle, IdGlobal, IdThread, IdServerIOHandler, IdStackConsts, IdIOHandler, IdScheduler,
  IdIOHandlerStack, IdServerIOHandlerSocket, IdYarn, SysUtils, Classes;

type
  TIdServerIOHandlerStack = class(TIdServerIOHandlerSocket)
  protected
    procedure InitComponent; override;
  public
    function MakeClientIOHandler(ATheThread:TIdYarn ): TIdIOHandler; override;
  end;

implementation

{ TIdServerIOHandlerStack }

procedure TIdServerIOHandlerStack.InitComponent;
begin
  inherited;
  IOHandlerSocketClass := TIdIOHandlerStack;
end;

function TIdServerIOHandlerStack.MakeClientIOHandler(ATheThread:TIdYarn ): TIdIOHandler;
begin
  Result := IOHandlerSocketClass.Create(nil);
end;

end.
 
