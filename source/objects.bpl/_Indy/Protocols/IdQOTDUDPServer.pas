{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  11709: IdQOTDUDPServer.pas 
{
{   Rev 1.4    2004.02.03 5:44:14 PM  czhower
{ Name changes
}
{
{   Rev 1.3    1/21/2004 3:27:16 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.2    10/24/2003 02:54:56 PM  JPMugaas
{ These should now work with the new code.
}
{
{   Rev 1.1    2003.10.24 10:38:30 AM  czhower
{ UDP Server todos
}
{
{   Rev 1.0    11/13/2002 07:58:52 AM  JPMugaas
}
unit IdQOTDUDPServer;

interface

uses
  IdAssignedNumbers, IdGlobal, IdSocketHandle, IdUDPBase, IdUDPServer, Classes;

type
   TIdQotdUDPGetEvent = procedure (ABinding: TIdSocketHandle; var AQuote : String) of object;
   TIdQotdUDPServer = class(TIdUDPServer)
   protected
     FOnCommandQOTD : TIdQotdUDPGetEvent;
     procedure DoOnCommandQUOTD(ABinding: TIdSocketHandle; var AQuote : String); virtual;
     procedure DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle); override;
     procedure InitComponent; override;
   published
     property DefaultPort default IdPORT_QOTD;
     property OnCommandQOTD : TIdQotdUDPGetEvent read FOnCommandQOTD write FOnCommandQOTD;
   end;

implementation

{ TIdQotdUDPServer }

procedure TIdQotdUDPServer.InitComponent;
begin
  inherited;
  DefaultPort := IdPORT_QOTD;
end;

procedure TIdQotdUDPServer.DoOnCommandQUOTD(ABinding: TIdSocketHandle; var AQuote : String);
begin
  if Assigned(FOnCommandQOTD) then
  begin
    FOnCommandQOTD(ABinding, AQuote);
  end;
end;

procedure TIdQotdUDPServer.DoUDPRead(AData: TIdBytes; ABinding: TIdSocketHandle);
var s : String;
begin
  inherited DoUDPRead(AData, ABinding);
  s := '';    {Do not Localize}
  DoOnCommandQUOTD(ABinding,s);
  if (Length(s) > 0) then
  begin
    with ABinding do
    begin
      ABinding.SendTo(PeerIP, PeerPort, ToBytes(s) );
    end;
  end;
end;

end.

