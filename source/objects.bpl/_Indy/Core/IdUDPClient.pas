{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  12018: IdUDPClient.pas 
{
{   Rev 1.10    11/11/2004 10:25:26 PM  JPMugaas
{ Added OpenProxy and CloseProxy so you can do RecvFrom and SendTo functions
{ from the UDP client with SOCKS.  You must call OpenProxy  before using
{ RecvFrom or SendTo.  When you are finished, you must use CloseProxy to close
{ any connection to the Proxy.  Connect and disconnect also call OpenProxy and
{ CloseProxy.
}
{
{   Rev 1.9    11/10/2004 9:40:42 PM  JPMugaas
{ Timeout error fix.  Thanks Bas.
}
{
{   Rev 1.8    11/9/2004 8:18:00 PM  JPMugaas
{ Attempt to add SOCKS support in UDP.
}
{
{   Rev 1.7    11/8/2004 5:03:00 PM  JPMugaas
{ Eliminated Socket property because we probably do not need it after all. 
{ Binding should work just as well.  I also made some minor refinements to
{ Disconnect and Connect.
}
{
{   Rev 1.6    11/7/2004 11:50:36 PM  JPMugaas
{ Fixed a Send method I broke.   If FSocket is not assigned, it will call the
{ inherited SendBuffer method.  That should prevent code breakage.  The connect
{ method should be OPTIONAL because UDP may be used for simple one-packet
{ query/response protocols.
}
{
{   Rev 1.5    11/7/2004 11:33:30 PM  JPMugaas
{ Now uses Connect, Disconnect, Send, and Receive similarly to the TCP Clients.
{  This should prevent unneeded DNS name to IP address conversions that SendTo
{ was doing.
}
{
{   Rev 1.4    2004.02.03 4:17:02 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.3    2004.01.21 2:35:40 PM  czhower
{ Removed illegal characters from file.
}
{
{   Rev 1.2    21.1.2004 �. 12:31:02  DBondzhev
{ Fix for Indy source. Workaround for dccil bug
{ now it can be compiled using Compile instead of build
}
{
{   Rev 1.1    10/22/2003 04:41:00 PM  JPMugaas
{ Should compile with some restored functionality.  Still not finished.
}
{
{   Rev 1.0    11/13/2002 09:02:16 AM  JPMugaas
}
unit IdUDPClient;

interface

uses
  Classes, IdUDPBase, IdGlobal, IdSocketHandle, IdCustomTransparentProxy;

type
  EIdMustUseOpenProxy = class(EIdUDPException);

  TIdUDPClient = class(TIdUDPBase)
  protected
    FProxyOpened : Boolean;
    FOnConnected : TNotifyEvent;
    FOnDisconnected: TNotifyEvent;
    FConnected : Boolean;
    FTransparentProxy: TIdCustomTransparentProxy;
    function UseProxy : Boolean;
    procedure RaiseUseProxyError;
    procedure DoOnConnected; virtual;
    procedure DoOnDisconnected; virtual;
    procedure InitComponent; override;
    //property methods
    procedure SetIPVersion(const AValue: TIdIPVersion); override;
    procedure SetHost(const AValue : String); override;
    procedure SetPort(const AValue : Integer); override;
    procedure SetTransparentProxy(AProxy : TIdCustomTransparentProxy);
    function GetTransparentProxy: TIdCustomTransparentProxy;
  public
    destructor Destroy; override;
    procedure OpenProxy;
    procedure CloseProxy;
    procedure Connect; virtual;
    procedure Disconnect; virtual;
    function Connected: Boolean;
    function ReceiveBuffer(var ABuffer : TIdBytes;
     const AMSec: Integer = IdTimeoutDefault): Integer; overload;  override;
    function ReceiveBuffer(var ABuffer : TIdBytes;
      var VPeerIP: string; var VPeerPort: integer;
      AMSec: Integer = IdTimeoutDefault): integer; overload; override;

    procedure Send(AData: string); overload;
    procedure SendBuffer(AHost: string; const APort: Integer; const ABuffer : TIdBytes); overload; override;
    procedure SendBuffer(const ABuffer: TIdBytes); reintroduce; overload;
  published
    property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected: TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property IPVersion;
    property Host;
    property Port;
    property ReceiveTimeout;
    property TransparentProxy: TIdCustomTransparentProxy
             read GetTransparentProxy write SetTransparentProxy;
  end;

implementation
uses IdComponent,IdResourceStringsCore, IdSocks, IdStack, IdStackConsts, SysUtils;

{ TIdUDPClient }

procedure TIdUDPClient.CloseProxy;
begin
  if UseProxy then
  begin
    if FProxyOpened then
    begin
       FTransparentProxy.CloseUDP(Binding);
       FProxyOpened := False;
    end;
  end;
end;

procedure TIdUDPClient.Connect;
var LIP : String;
begin
  if Connected then
  begin
    Disconnect;
  end;
  if Assigned(FTransparentProxy) then
  begin
    if FTransparentProxy.Enabled then
    begin
      //we don't use proxy open because we want to pass a peer's hostname and port
      //in case a proxy type in the future requires this.
      FTransparentProxy.OpenUDP(Binding,Host,Port);
      FProxyOpened := True;
      FConnected := True;
      Exit;  //we're done, the transparentProxy takes care of the work.
    end;
  end;


  if not GStack.IsIP(Host) then begin
    if Assigned(OnStatus) then begin
      DoStatus(hsResolving, [Host]);
    end;
    LIP := GStack.ResolveHost(Host, FIPVersion);
  end else begin
    LIP := Host;
  end;
  Binding.SetPeer(LIP,Port);
  Binding.Connect;

  DoStatus(hsConnected, [Host]);
  DoOnConnected;
  FConnected := True;
end;

function TIdUDPClient.Connected: Boolean;
begin
  Result := FConnected;
  if Result then begin
    if Assigned(FBinding) then
    begin
      Result := FBinding.HandleAllocated;
    end
    else
    begin
      Result := False;
    end;
  end;
end;

procedure TIdUDPClient.Disconnect;
begin
  if Connected then
  begin

    DoStatus(hsDisconnecting);
    if UseProxy then
    begin
      if FProxyOpened then
      begin
        CloseProxy;
      end;
    end;
    FBinding.CloseSocket;
    DoOnDisconnected;
    DoStatus(hsDisconnected);
    FConnected := False;
  end;
end;

procedure TIdUDPClient.DoOnConnected;
begin
  if Assigned(OnConnected) then begin
    OnConnected(Self);
  end;
end;

procedure TIdUDPClient.DoOnDisconnected;
begin
  if Assigned(OnDisconnected) then begin
    OnDisconnected(Self);
  end;
end;

function TIdUDPClient.GetTransparentProxy: TIdCustomTransparentProxy;
begin
  // Necessary at design time for Borland SOAP support
  if FTransparentProxy = nil then begin
    FTransparentProxy :=  TIdSocksInfo.Create(nil); //default
  end;
  Result := FTransparentProxy;
end;

procedure TIdUDPClient.InitComponent;
begin
  inherited;
  FProxyOpened := False;
  FConnected := False;
end;

procedure TIdUDPClient.OpenProxy;
begin
  if UseProxy then
  begin
    if not FProxyOpened then
    begin
       FTransparentProxy.OpenUDP(Binding);
       FProxyOpened := True;
    end;
  end;
end;

function TIdUDPClient.ReceiveBuffer(var ABuffer: TIdBytes;
  const AMSec: Integer): Integer;
var LMSec : Integer;
  LHost : String;
  LPort : Integer;
begin
  Result := 0;
  if AMSec = IdTimeoutDefault then begin
    if ReceiveTimeout = 0 then begin
      LMSec := IdTimeoutInfinite;
    end else begin
      LMSec := ReceiveTimeout;
    end;
  end else begin
    LMSec := AMSec;
  end;
  if UseProxy then
  begin
    if FProxyOpened then
    begin
      Result := FTransparentProxy.RecvFromUDP(Binding,ABuffer,LHost,LPort,LMSec );
      Exit;
    end
    else
    begin
      RaiseUseProxyError;
    end;
  end;
  if Connected then
  begin

    if FBinding.Readable(LMSec) then //Select(LMSec)  then
    begin
      Result := FBinding.Receive(ABuffer);
    end;
  end
  else
  begin
    Result := inherited ReceiveBuffer(ABuffer, LMSec);
  end;
end;

procedure TIdUDPClient.RaiseUseProxyError;
begin
   raise EIdMustUseOpenProxy.Create(RSUDPMustUseProxyOpen);
end;

function TIdUDPClient.ReceiveBuffer(var ABuffer: TIdBytes;
  var VPeerIP: string; var VPeerPort: integer; AMSec: Integer): integer;
var LMSec : Integer;
begin
  if AMSec = IdTimeoutDefault then begin
    if ReceiveTimeout = 0 then begin
      LMSec := IdTimeoutInfinite;
    end else begin
      LMSec := ReceiveTimeout;
    end;
  end else begin
    LMSec := AMSec;
  end;
  if UseProxy then
  begin
    if FProxyOpened then
    begin
      Result := FTransparentProxy.RecvFromUDP(Binding,ABuffer,VPeerIP,VPeerPort,LMSec );
      Exit;
    end
    else
    begin
      RaiseUseProxyError;
    end;
  end;
  Result := inherited ReceiveBuffer(ABuffer, VPeerIP, VPeerPort, LMSec);
end;

procedure TIdUDPClient.Send(AData: string);
begin
  Send(Host, Port, AData);
end;

procedure TIdUDPClient.SendBuffer(const ABuffer : TIdBytes);
begin
  if UseProxy then
  begin
    if FProxyOpened then
    begin
      FTransparentProxy.SendToUDP(Binding,Host,Port,ABuffer);
       Exit;
    end
    else
    begin
      RaiseUseProxyError;
    end;
  end;

  if Connected then
  begin
    FBinding.Send(ABuffer,0,-1);
  end
  else
  begin
    inherited SendBuffer(Host, Port, ABuffer);
  end;

end;

procedure TIdUDPClient.SendBuffer(AHost: string; const APort: Integer;
  const ABuffer: TIdBytes);
begin
  if UseProxy then
  begin
    if FProxyOpened then
    begin
      FTransparentProxy.SendToUDP(Binding,AHost,APort,ABuffer);
      Exit;
    end
    else
    begin
      RaiseUseProxyError;
    end;
  end;
  inherited SendBuffer(AHost, APort, ABuffer);
end;

procedure TIdUDPClient.SetHost(const AValue: String);
begin
  if FHost<>AValue then
  begin
    Disconnect;
  end;
  inherited SetHost(AValue);

end;

procedure TIdUDPClient.SetIPVersion(const AValue: TIdIPVersion);
begin
  if FIPVersion <> AValue then
  begin
    Disconnect;
  end;
  inherited SetIPVersion(AValue);

end;

procedure TIdUDPClient.SetPort(const AValue: Integer);
begin
  if FPort <> Avalue then
  begin
    Disconnect;
  end;
  inherited SetPort(AValue);

end;

procedure TIdUDPClient.SetTransparentProxy(
  AProxy: TIdCustomTransparentProxy);
var
  LClass: TIdCustomTransparentProxyClass;
begin
  // All this is to preserve the compatibility with old version
  // In the case when we have SocksInfo as object created in runtime without owner form it is treated as temporary object
  // In the case when the ASocks points to an object with owner it is treated as component on form.

  if Assigned(AProxy) then begin
    if NOT Assigned(AProxy.Owner) then begin
      if Assigned(FTransparentProxy) and Assigned(FTransparentProxy.Owner) then begin
        FTransparentProxy := nil;
      end;
      LClass := TIdCustomTransparentProxyClass(AProxy.ClassType);
      // SG: was:
      // LClass := Pointer(AProxy.ClassType);
      if Assigned(FTransparentProxy) then begin
        if FTransparentProxy.ClassType <> LClass then begin
          FreeAndNIL(FTransparentProxy);
          FTransparentProxy := LClass.Create(NIL);
        end;
      end else begin
        FTransparentProxy := LClass.Create(NIL);
      end;
      FTransparentProxy.Assign(AProxy);
    end else begin
      if Assigned(FTransparentProxy) then begin
        if NOT Assigned(FTransparentProxy.Owner) then begin
          FreeAndNIL(FTransparentProxy);//tmp obj
        end;
      end;
      FTransparentProxy := AProxy;
      FTransparentProxy.FreeNotification(SELF);
    end;
  end
  else begin
    if Assigned(FTransparentProxy) and NOT Assigned(FTransparentProxy.Owner) then begin
      FreeAndNIL(FTransparentProxy);//tmp obj
    end else begin
      FTransparentProxy := NIL; //remove link
    end;
  end;
end;

function TIdUDPClient.UseProxy: Boolean;
begin
  Result := False;
  if Assigned(FTransparentProxy) then
  begin
    Result := FTransparentProxy.Enabled;
  end;
end;

destructor TIdUDPClient.Destroy;
begin
  if UseProxy then
  begin
    if FProxyOpened then
    begin
      CloseProxy;
    end;
  end;
  if Connected then
  begin
    Disconnect;
  end;
  inherited Destroy;
end;

end.
