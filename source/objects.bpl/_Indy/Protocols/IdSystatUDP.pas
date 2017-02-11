{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11777: IdSystatUDP.pas 
{
{   Rev 1.3    10/26/2004 10:49:20 PM  JPMugaas
{ Updated ref.
}
{
{   Rev 1.2    2004.02.03 5:44:30 PM  czhower
{ Name changes
}
{
{   Rev 1.1    1/21/2004 4:04:06 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.0    11/13/2002 08:02:36 AM  JPMugaas
}
unit IdSystatUDP;
{*******************************************************}
{                                                       }
{       Indy Systat Client TIdSystatUDP                 }
{                                                       }
{       Copyright (C) 2002 Winshoes Working Group       }
{       Original author J. Peter Mugaas                 }
{       2002-August-13                                  }
{       Based on RFC 866                                }
{                                                       }
{*******************************************************}
{Note that this protocol is officially called Active User}
{2002-Aug-13  J. Peter Mugaas
  -Original version}

interface
uses Classes, IdAssignedNumbers, IdTStrings, IdUDPBase, IdUDPClient;

const DefIdSysUDPTimeout =  1000; //one second
type
  TIdSystatUDP = class(TIdUDPClient)
  protected
    procedure InitComponent; override;
  public
    procedure GetStat(ADest : TIdStrings);
  published
    property ReceiveTimeout default DefIdSysUDPTimeout;   //Infinite Timeout can not be used for UDP reads
    property Port default IdPORT_SYSTAT;
  end;

{
Note that no result parsing is done because RFC 866 does not specify a syntax for
a user list.

Quoted from RFC 866:

   There is no specific syntax for the user list.  It is recommended
   that it be limited to the ASCII printing characters, space, carriage
   return, and line feed.  Each user should be listed on a separate
   line.
}

implementation

uses
  IdGlobal, SysUtils;

{ TIdSystatUDP }

procedure TIdSystatUDP.InitComponent;
begin
  inherited;
  Port := IdPORT_SYSTAT;
  ReceiveTimeout := DefIdSysUDPTimeout;
end;

procedure TIdSystatUDP.GetStat(ADest: TIdStrings);
var s : String;
    LTimeout : Integer;
begin
  //we do things this way so that IdTimeoutInfinite can never be used.  Necessary
  //because that will hang the code.
  LTimeout := ReceiveTimeout;
  if LTimeout = IdTimeoutInfinite then
  begin
    LTimeout := ReceiveTimeout;
  end;
  ADest.Text := '';
  //The string can be anything - The RFC says the server should discard packets
  Send(' ');    {Do not Localize}
  {  We do things this way because RFC 866 says:

  If the list does not fit in one datagram then send a sequence of
   datagrams but don't break the information for a user (a line) across
   a datagram.
  }
  repeat
    s := ReceiveString(LTimeout);
    if s = '' then
    begin
      Break;
    end
    else
    begin
      ADest.Add(s);
    end;
  until False;
end;

end.
