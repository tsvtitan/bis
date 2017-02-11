{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  56379: IdAntiFreezeBase.pas 
{
{   Rev 1.5    8/17/2004 2:54:38 PM  JPMugaas
{ Made ShouldUse vritual again.
}
{
{   Rev 1.4    2004.06.16 8:08:52 PM  czhower
{ Temp workaround for D.NET
}
{
{   Rev 1.3    2004.03.01 11:27:54 AM  czhower
{ Bug fix for checking of more than one AF
}
{
{   Rev 1.2    2004.02.29 9:38:36 PM  czhower
{ Bug fix for design mode.
}
{
{   Rev 1.1    2004.02.03 3:15:50 PM  czhower
{ Updates to move to System.
}
{
{   Rev 1.0    2004.02.03 2:40:34 PM  czhower
{ Move
}
{
{   Rev 1.3    2004.01.20 10:03:20 PM  czhower
{ InitComponent
}
{
{   Rev 1.2    2003.10.01 12:30:02 PM  czhower
{ .Net
}
{
{   Rev 1.1    2003.10.01 1:12:32 AM  czhower
{ .Net
}
{
{   Rev 1.0    11/13/2002 08:37:44 AM  JPMugaas
}
unit IdAntiFreezeBase;

// TODO: Remove this when D.NET problem is resolved
{$I IdCompilerDefines.inc}

interface

uses
  Classes,
  IdBaseComponent;

const
  ID_Default_TIdAntiFreezeBase_Active = True;
  ID_Default_TIdAntiFreezeBase_ApplicationHasPriority = True;
  ID_Default_TIdAntiFreezeBase_IdleTimeOut = 250;
  ID_Default_TIdAntiFreezeBase_OnlyWhenIdle = True;

type
  TIdAntiFreezeBase = class(TIdBaseComponent)
  protected
    FActive: Boolean;
    FApplicationHasPriority: Boolean;
    FIdleTimeOut: Integer;
    FOnlyWhenIdle: Boolean;
    //
    procedure InitComponent; override;
  public
    class procedure DoProcess(const AIdle: Boolean = true;
     const AOverride: Boolean = false);
    destructor Destroy; override;
    procedure Process; virtual; abstract;
    class function ShouldUse: Boolean; virtual;
    class procedure Sleep(ATimeout: Integer);
  published
    property Active: boolean read FActive write FActive
     default ID_Default_TIdAntiFreezeBase_Active;
    property ApplicationHasPriority: Boolean read FApplicationHasPriority
     write FApplicationHasPriority
     default ID_Default_TIdAntiFreezeBase_ApplicationHasPriority;
    property IdleTimeOut: integer read FIdleTimeOut write FIdleTimeOut
     default ID_Default_TIdAntiFreezeBase_IdleTimeOut;
    property OnlyWhenIdle: Boolean read FOnlyWhenIdle write FOnlyWhenIdle
     default ID_Default_TIdAntiFreezeBase_OnlyWhenIdle;
  end;

var
  GAntiFreeze: TIdAntiFreezeBase = nil;

implementation

uses
  IdGlobal,
  IdResourceStrings,
  IdException,
  SysUtils;

{ TIdAntiFreezeBase }

destructor TIdAntiFreezeBase.Destroy;
begin
  GAntiFreeze := nil;
  inherited;
end;

class procedure TIdAntiFreezeBase.DoProcess(const AIdle: boolean = True;
 const AOverride: boolean = False);
begin
  if ShouldUse then begin
    if ((GAntiFreeze.OnlyWhenIdle = False) or AIdle or AOverride) and GAntiFreeze.Active then begin
      GAntiFreeze.Process;
    end;
  end;
end;

procedure TIdAntiFreezeBase.InitComponent;
begin
  inherited;
  if not (csDesigning in ComponentState) then begin
    EIdException.IfAssigned(GAntiFreeze, RSAntiFreezeOnlyOne);
    GAntiFreeze := Self;
  end;
  FActive := ID_Default_TIdAntiFreezeBase_Active;
  FApplicationHasPriority := ID_Default_TIdAntiFreezeBase_ApplicationHasPriority;
  IdleTimeOut := ID_Default_TIdAntiFreezeBase_IdleTimeOut;
  FOnlyWhenIdle := ID_Default_TIdAntiFreezeBase_OnlyWhenIdle;
end;

class function TIdAntiFreezeBase.ShouldUse: Boolean;
begin
  Result := False;
end;

class procedure TIdAntiFreezeBase.Sleep(ATimeout: Integer);
begin
  if ShouldUse then begin
    while ATimeout > GAntiFreeze.IdleTimeOut do begin
      IdGlobal.Sleep(GAntiFreeze.IdleTimeOut);
      ATimeout := ATimeout - GAntiFreeze.IdleTimeOut;
      DoProcess;
    end;
    IdGlobal.Sleep(ATimeout);
    DoProcess;
  end else begin
    IdGlobal.Sleep(ATimeout);
  end;
end;

end.
