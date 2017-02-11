{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13770: IdConnectThroughHttpProxy.pas
{
{   Rev 1.5    2004.02.03 5:45:00 PM  czhower
{ Name changes
}
{
    Rev 1.4    10/19/2003 11:48:12 AM  DSiders
  Added localization comments.
}
{
    Rev 1.3    4/5/2003 7:27:48 PM  BGooijen
  Checks for errors, added authorisation
}
{
    Rev 1.2    4/1/2003 4:14:22 PM  BGooijen
  Fixed + cleaned up
}
{
{   Rev 1.1    2/24/2003 08:20:46 PM  JPMugaas
{ Now should compile with new code.
}
{
{   Rev 1.0    11/14/2002 02:16:10 PM  JPMugaas
}
unit IdConnectThroughHttpProxy;

{
implements:
http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt
}

interface

uses
  IdCustomTransparentProxy, IdIOHandler;

type
  // TODO: [APR] Please, complete this class and put it in other unit...
  TIdConnectThroughHttpProxy = class(TIdCustomTransparentProxy)
  protected
    FEnabled: Boolean;
    function  GetEnabled: Boolean; override;
    procedure SetEnabled(AValue: Boolean); override;
    procedure MakeConnection(AIOHandler: TIdIOHandler; const AHost: string; const APort: Integer); override;
    procedure DoMakeConnection(AIOHandler: TIdIOHandler; const AHost: string;
      const APort: Integer; const ALogin:boolean);virtual;
  public
  published
    property  Enabled;
    property  Host;
    property  Port;
    property  ChainedProxy;
    property Username;
    property Password;
  End;//TIdConnectThroughHttpProxy

implementation

uses
  SysUtils, IdCoderMIME, IdGlobal, IdExceptionCore;

{ TIdConnectThroughHttpProxy }

function TIdConnectThroughHttpProxy.GetEnabled: Boolean;
Begin
  Result := FEnabled;
End;

procedure TIdConnectThroughHttpProxy.DoMakeConnection(AIOHandler: TIdIOHandler;
  const AHost: string; const APort: Integer; const ALogin:boolean);
var
  LStatus:string;
  LResponseCode:integer;
Begin
  AIOHandler.WriteLn(Format('CONNECT %s:%d HTTP/1.0', [AHost,APort])); {do not localize}
  if ALogin then begin
    AIOHandler.WriteLn(Format('Proxy-authorization: basic %s', [TIdEncoderMIME.EncodeString(Username + ':' + Password)]));  {do not localize}
  end;
  AIOHandler.WriteLn;
  LStatus:=AIOHandler.ReadLn;
  if LStatus<>'' then begin // if empty response then we assume it succeeded
    Fetch(LStatus);// to remove the http/1.0 or http/1.1
    LResponseCode:=StrToIntDef(Fetch(LStatus,' ',false),200); // if invalid response then we assume it succeeded
    if (LResponseCode=407) and (length(Username)>0) and not ALogin then begin // authorisation required
      repeat until AIOHandler.ReadLn = '';//flush connection
      DoMakeConnection(AIOHandler, AHost, APort, True);// try again, but with login
    end else begin
      if not (LResponseCode in [200]) then begin // maybe more responsecodes to add
        raise EIdHttpProxyError.Create(LStatus);//BGO: TODO: maybe split into more exceptions?
      end;
      repeat until AIOHandler.ReadLn = '';
    end;
  end;
end;

procedure TIdConnectThroughHttpProxy.MakeConnection(AIOHandler: TIdIOHandler;
  const AHost: string; const APort: Integer);
Begin
  DoMakeConnection(AIOHandler,AHost,APort,false);
End;


procedure TIdConnectThroughHttpProxy.SetEnabled(AValue: Boolean);
Begin
  FEnabled := AValue;
End;

end.
