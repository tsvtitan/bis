{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}
{
{   Rev 1.12    2004.02.03 4:17:06 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.11    2003.10.24 12:59:20 PM  czhower
{ Name change
}
{
{   Rev 1.10    2003.10.21 12:19:00 AM  czhower
{ TIdTask support and fiber bug fixes.
}
{
{   Rev 1.9    2003.10.11 5:49:40 PM  czhower
{ -VCL fixes for servers
{ -Chain suport for servers (Super core)
{ -Scheduler upgrades
{ -Full yarn support
}
{
{   Rev 1.8    2003.09.19 10:11:18 PM  czhower
{ Next stage of fiber support in servers.
}
{
{   Rev 1.7    2003.09.19 11:54:30 AM  czhower
{ -Completed more features necessary for servers
{ -Fixed some bugs
}
{
{   Rev 1.6    2003.09.18 4:10:26 PM  czhower
{ Preliminary changes for Yarn support.
}
{
    Rev 1.5    7/6/2003 8:04:06 PM  BGooijen
  Renamed IdScheduler* to IdSchedulerOf*
}
{
    Rev 1.4    7/5/2003 11:49:06 PM  BGooijen
  Cleaned up and fixed av in threadpool
}
{
{   Rev 1.3    2003.06.25 4:26:40 PM  czhower
{ Removed unecessary code in RemoveThread
}
{
    Rev 1.2    3/13/2003 10:18:32 AM  BGooijen
  Server side fibers, bug fixes
}
{
    Rev 1.1    1/23/2003 11:06:02 AM  BGooijen
}
{
{   Rev 1.0    1/17/2003 03:29:54 PM  JPMugaas
{ Renamed from ThreadMgr for new design.
}
{
{   Rev 1.0    11/13/2002 09:01:40 AM  JPMugaas
}
unit IdSchedulerOfThreadDefault;

interface

uses
  IdThread, IdSchedulerOfThread, IdScheduler, IdYarn, IdContext;

type
  TIdSchedulerOfThreadDefault = class(TIdSchedulerOfThread)
  public
    function AcquireYarn
      : TIdYarn;
      override;
    function NewThread
      : TIdThreadWithTask;
      override;
  end;

implementation

uses
  IdGlobal;

{ TIdSchedulerOfThreadDefault }

function TIdSchedulerOfThreadDefault.AcquireYarn: TIdYarn;
begin
  Result := NewYarn(NewThread);
  ActiveYarns.Add(Result);
end;

function TIdSchedulerOfThreadDefault.NewThread: TIdThreadWithTask;
begin
  Result := inherited NewThread;
  Result.FreeOnTerminate := True;
end;

end.

