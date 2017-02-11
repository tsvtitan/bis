{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  12016: IdUDPBase.pas 
{
{   Rev 1.14    11/11/04 12:05:32 PM  RLebeau
{ Updated ReceiveBuffer() to set AMSec to IdTimeoutInfinite when the
{ ReceiveTimeout property is 0
}
{
{   Rev 1.13    11/7/2004 11:33:30 PM  JPMugaas
{ Now uses Connect, Disconnect, Send, and Receive similarly to the TCP Clients.
{  This should prevent unneeded DNS name to IP address conversions that SendTo
{ was doing.
}
{
{   Rev 1.12    7/21/04 3:33:10 PM  RLebeau
{ Updated TIdUDPBase.ReceiveString() to use new BytesToString() parameters
}
{
{   Rev 1.11    09/06/2004 00:29:56  CCostelloe
{ Kylix 3 patch
}
{
{   Rev 1.10    2004.02.03 4:17:00 PM  czhower
{ For unit name changes.
}
{
{   Rev 1.9    21.1.2004 �. 12:31:00  DBondzhev
{ Fix for Indy source. Workaround for dccil bug
{ now it can be compiled using Compile instead of build
}
{
{   Rev 1.7    10/26/2003 12:30:18 PM  BGooijen
{ DotNet
}
{
{   Rev 1.6    10/24/2003 5:18:36 PM  BGooijen
{ Removed boolean shortcutting from .GetActive
}
{
{   Rev 1.5    10/22/2003 04:40:58 PM  JPMugaas
{ Should compile with some restored functionality.  Still not finished.
}
{
{   Rev 1.4    10/19/2003 9:34:30 PM  BGooijen
{ SetSocketOption
}
{
{   Rev 1.3    2003.10.11 9:58:48 PM  czhower
{ Started on some todos
}
{
{   Rev 1.2    2003.10.11 5:52:10 PM  czhower
{ -VCL fixes for servers
{ -Chain suport for servers (Super core)
{ -Scheduler upgrades
{ -Full yarn support
}
{
{   Rev 1.1    2003.09.30 1:23:08 PM  czhower
{ Stack split for DotNet
}
{
{   Rev 1.0    11/13/2002 09:02:06 AM  JPMugaas
}
unit IdUDPBase;

interface

uses
  Classes,
  IdComponent, IdGlobal, IdException, IdSocketHandle;

const
  ID_UDP_BUFFERSIZE = 8192;

type
  TIdUDPBase = class(TIdComponent)
  protected
    FBinding: TIdSocketHandle;
    FBufferSize: Integer;
    FDsgnActive: Boolean;
    FHost: String;
    FPort: Integer;
    FReceiveTimeout: Integer;
    FIPVersion: TIdIPVersion;
    //
    FBroadcastEnabled: Boolean;
    procedure BroadcastEnabledChanged; dynamic;
    procedure CloseBinding; virtual;
    function GetActive: Boolean; virtual;
    procedure InitComponent; override;
    procedure SetActive(const Value: Boolean);
    procedure SetBroadcastFlag(
      AEnabled: Boolean;
      ABinding: TIdSocketHandle = nil
      );
    procedure SetBroadcastEnabled(AValue: Boolean);
    function GetBinding: TIdSocketHandle; virtual;
    procedure Loaded; override;

    function GetIPVersion: TIdIPVersion;  virtual;
    procedure SetIPVersion(const AValue: TIdIPVersion); virtual;

    function GetHost : String; virtual;
    procedure SetHost(const AValue : String); virtual;

    function GetPort : Integer; virtual;
    procedure SetPort(const AValue : Integer); virtual;

    property Host: string read GetHost write SetHost;
    property Port: Integer read GetPort write SetPort;
  public
    destructor Destroy; override;
    //
    property Binding: TIdSocketHandle read GetBinding;
    procedure Broadcast(const AData: string; const APort: integer);
    function ReceiveBuffer(var ABuffer : TIdBytes;
      var VPeerIP: string; var VPeerPort: integer;
      AMSec: Integer = IdTimeoutDefault): integer; overload; virtual;

    function ReceiveString(const AMSec: Integer = IdTimeoutDefault): string; overload;
    function ReceiveString(var VPeerIP: string; var VPeerPort: integer;
     const AMSec: Integer = IdTimeoutDefault): string;  overload;
    function ReceiveBuffer(var ABuffer : TIdBytes;
     const AMSec: Integer = IdTimeoutDefault): Integer; overload;  virtual;
    procedure Send(AHost: string; const APort: Integer; const AData: string);
    procedure SendBuffer(AHost: string; const APort: Integer; const ABuffer : TIdBytes); virtual;
    //
    property ReceiveTimeout: Integer read FReceiveTimeout write FReceiveTimeout default IdTimeoutInfinite;
  published
    property Active: Boolean read GetActive write SetActive Default False;
    property BufferSize: Integer read FBufferSize write FBufferSize default ID_UDP_BUFFERSIZE;
    property BroadcastEnabled: Boolean read FBroadcastEnabled
     write SetBroadcastEnabled Default False;
    property IPVersion: TIdIPVersion read GetIPVersion write SetIPVersion default ID_DEFAULT_IP_VERSION;
  end;
  EIdUDPException = Class(EIdException);
  EIdUDPReceiveErrorZeroBytes = class(EIdUDPException);

implementation

uses
  IdStackConsts, IdStack,
  SysUtils;

{ TIdUDPBase }

procedure TIdUDPBase.Broadcast(const AData: string; const APort: integer);
begin
  SetBroadcastFlag(True);
  Send('255.255.255.255', APort, AData);    {Do not Localize}
  BroadcastEnabledChanged;
end;

procedure TIdUDPBase.BroadcastEnabledChanged;
begin
  SetBroadcastFlag(BroadcastEnabled);
end;

procedure TIdUDPBase.CloseBinding;
begin
  FreeAndNil(FBinding);
end;

destructor TIdUDPBase.Destroy;
begin
  Active := False;
  inherited;
end;

function TIdUDPBase.GetActive: Boolean;
begin
  Result := FDsgnActive;
  if not Result then begin
    if Assigned(FBinding) then begin
      if FBinding.HandleAllocated then begin
        result:=true;
      end;
    end;
  end;
end;

function TIdUDPBase.GetBinding: TIdSocketHandle;
begin
  if FBinding = nil then begin
    FBinding := TIdSocketHandle.Create(nil);
  end;
  if not FBinding.HandleAllocated then begin
{$IFDEF LINUX}
    FBinding.AllocateSocket(Integer(Id_SOCK_DGRAM));
{$ELSE}
    FBinding.AllocateSocket(Id_SOCK_DGRAM);
{$ENDIF}
    BroadcastEnabledChanged;
  end;
  Result := FBinding;
end;

function TIdUDPBase.GetHost: String;
begin
  Result := FHost;
end;

function TIdUDPBase.GetIPVersion: TIdIPVersion;
begin
  Result := FIPVersion;
end;

function TIdUDPBase.GetPort: Integer;
begin
  Result := FPort;
end;

procedure TIdUDPBase.InitComponent;
begin
  inherited;
  BufferSize := ID_UDP_BUFFERSIZE;
  FReceiveTimeout := IdTimeoutInfinite;
  FIPVersion := ID_DEFAULT_IP_VERSION;
end;

procedure TIdUDPBase.Loaded;
var
  b: Boolean;
begin
  inherited;
  b := FDsgnActive;
  FDsgnActive := False;
  Active := b;
end;

function TIdUDPBase.ReceiveBuffer(var ABuffer : TIdBytes;
  const AMSec: Integer = IdTimeoutDefault): Integer;
var
  VoidIP: string;
  VoidPort: Integer;
begin
  Result := ReceiveBuffer(ABuffer,  VoidIP, VoidPort, AMSec);
end;

function TIdUDPBase.ReceiveBuffer(var ABuffer : TIdBytes;
  var VPeerIP: string; var VPeerPort: integer;
  AMSec: Integer = IdTimeoutDefault): integer;
begin
  if AMSec = IdTimeoutDefault then begin
    if ReceiveTimeOut = 0 then begin
      AMSec := IdTimeoutInfinite;
    end else begin
      AMSec := ReceiveTimeOut;
    end;
  end;
  if not Binding.Readable(AMSec) then begin
    Result := 0;
    VPeerIP := '';    {Do not Localize}
    VPeerPort := 0;
    Exit;
  end;
  Result := Binding.RecvFrom(ABuffer,VPeerIP, VPeerPort);
 // (GStack as TIdStackBSDBase).CheckForSocketError(Result);
end;

function TIdUDPBase.ReceiveString(var VPeerIP: string; var VPeerPort: integer;
  const AMSec: Integer = IdTimeoutDefault): string;
var
  i: Integer;
  LBuffer : TIdBytes;
begin
  SetLength(LBuffer, BufferSize);
  i := ReceiveBuffer(LBuffer, VPeerIP, VPeerPort, AMSec);
  Result := BytesToString(LBuffer, 0, i);
end;

function TIdUDPBase.ReceiveString(const AMSec: Integer): string;
var
  VoidIP: string;
  VoidPort: Integer;
begin
  Result := ReceiveString(VoidIP, VoidPort, AMSec);
end;

procedure TIdUDPBase.Send(AHost: string; const APort: Integer; const AData: string);
begin
  SendBuffer(AHost, APort, ToBytes(AData));
end;

procedure TIdUDPBase.SendBuffer(AHost: string; const APort: Integer; const ABuffer : TIdBytes);
begin
  AHost := GStack.ResolveHost(AHost);
  Binding.SendTo(AHost, APort, ABuffer);
end;

procedure TIdUDPBase.SetActive(const Value: Boolean);
begin
  if (Active <> Value) then begin
    if not ((csDesigning in ComponentState) or (csLoading in ComponentState)) then begin
      if Value then begin
        GetBinding;
      end
      else begin
        CloseBinding;
      end;
    end
    else begin  // don't activate at designtime (or during loading of properties)    {Do not Localize}
      FDsgnActive := Value;
    end;
  end;
end;

procedure TIdUDPBase.SetBroadcastEnabled(AValue: Boolean);
begin
  if FBroadCastEnabled <> AValue then begin
    FBroadcastEnabled := AValue;
    if Active then begin
      BroadcastEnabledChanged;
    end;
  end;
end;

procedure TIdUDPBase.SetBroadcastFlag(
  AEnabled: Boolean;
  ABinding: TIdSocketHandle = nil
  );
begin
  if ABinding = nil then begin
    ABinding := Binding;
  end;
  GStack.SetSocketOption(ABinding.Handle,Id_SOL_SOCKET, Id_SO_BROADCAST, iif(AEnabled,1,0));
end;

procedure TIdUDPBase.SetHost(const AValue: String);
begin
  FHost := Avalue;
end;

procedure TIdUDPBase.SetIPVersion(const AValue: TIdIPVersion);
begin
  FIPVersion := AValue;
end;

procedure TIdUDPBase.SetPort(const AValue: Integer);
begin
  FPort := AValue;
end;

end.
