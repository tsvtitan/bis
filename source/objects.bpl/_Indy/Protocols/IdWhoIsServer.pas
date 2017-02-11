{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11821: IdWhoIsServer.pas 
{
{   Rev 1.4    1/21/2004 4:21:18 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.3    2/24/2003 10:39:58 PM  JPMugaas
}
{
{   Rev 1.2    1/17/2003 07:11:10 PM  JPMugaas
{ Now compiles under new framework.
}
{
{   Rev 1.1    1/9/2003 06:55:54 AM  JPMugaas
{ Changed OnQueryEvent so users do not have to bother with WriteLn's in their
{ events.
{ Now works with IdContext.
}
{
{   Rev 1.0    11/13/2002 08:04:48 AM  JPMugaas
}
unit IdWhoIsServer;

{
 2000-Apr-19 Hadi Hariri
  Converted to Indy

 13-JAN-2000 MTL: Moved to new Palette Scheme (Winshoes Servers)

 5.13.99 Final Version
       ?         [responds with the following]
    Please enter a name or a NIC handle, such as "Smith" or "SRI-NIC".
    Starting with a period forces a name-only search; starting with
    exclamation point forces handle-only.  Examples:
       Smith     [looks for name or handle SMITH]
       !SRI-NIC  [looks for handle SRI-NIC only]
       .Smith, John
                 [looks for name JOHN SMITH only]

    Adding "..." to the argument will match anything from that point,
    e.g. "ZU..." will match ZUL, ZUM, etc.

    To search for mailboxes, use one of these forms:

       Smith@    [looks for mailboxes with username SMITH]
       @Host     [looks for mailboxes on HOST]
       Smith@Host

 Orig Author: Ozz Nixon (RFC 954)
}
interface

uses
  Classes,
  IdAssignedNumbers,
  IdContext,
  IdTCPServer;

type
  TGetEvent = procedure(AContext:TIdContext; ALookup: string; var VResponse : String) of object;

  TIdWhoIsServer = class(TIdTCPserver)
  protected
    FOnCommandLookup: TGetEvent;
    //
    function DoExecute(AContext:TIdContext): boolean; override;
    procedure InitComponent; override;
  published
    property OnCommandLookup: TGetEvent read FOnCommandLookup write FOnCommandLookup;
    property DefaultPort default IdPORT_WHOIS;
  end;

implementation

{ TIdWhoIsServer }

procedure TIdWhoIsServer.InitComponent;
begin
  inherited;
  DefaultPort := IdPORT_WHOIS;
end;

function TIdWhoIsServer.DoExecute(AContext:TIdContext): boolean;
var
  LRequest, VResponse: string;
begin
  Result := True;
  with AContext.Connection do begin
    // Get the domain name the client is inquiring about
    LRequest := IOHandler.ReadLn;
    if Assigned(OnCommandLookup) then begin
      OnCommandLookup(AContext, LRequest, VResponse);
      IOHandler.Write(VResponse);
    end;
    Disconnect;
  end;
end;

end.
