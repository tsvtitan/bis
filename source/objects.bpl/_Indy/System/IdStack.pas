{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  56388: IdStack.pas
{
{   Rev 1.6    10/26/2004 8:12:30 PM  JPMugaas
{ Now uses TIdStrings and TIdStringList for portability.
}
{
{   Rev 1.5    6/30/2004 12:41:14 PM  BGooijen
{ Added SetStackClass
}
{
    Rev 1.4    6/11/2004 8:28:50 AM  DSiders
  Added "Do not Localize" comments.
}
{
{   Rev 1.3    4/18/04 2:45:38 PM  RLebeau
{ Conversion support for Int64 values
}
{
{   Rev 1.2    2004.03.07 11:45:22 AM  czhower
{ Flushbuffer fix + other minor ones found
}
{
{   Rev 1.1    3/6/2004 5:16:20 PM  JPMugaas
{ Bug 67 fixes.  Do not write to const values.
}
{
{   Rev 1.0    2004.02.03 3:14:42 PM  czhower
{ Move and updates
}
{
{   Rev 1.39    2/1/2004 6:10:50 PM  JPMugaas
{ GetSockOpt.
}
{
{   Rev 1.38    2/1/2004 3:28:24 AM  JPMugaas
{ Changed WSGetLocalAddress to GetLocalAddress and moved into IdStack since
{ that will work the same in the DotNET as elsewhere.  This is required to
{ reenable IPWatch.
}
{
{   Rev 1.37    2/1/2004 1:54:56 AM  JPMugaas
{ Missapplied fix.  IP 0.0.0.0 should now be accepted.
}
{
{   Rev 1.36    1/31/2004 4:39:12 PM  JPMugaas
{ Removed empty methods.
}
{
{   Rev 1.35    1/31/2004 1:13:04 PM  JPMugaas
{ Minor stack changes required as DotNET does support getting all IP addresses
{ just like the other stacks.
}
{
{   Rev 1.34    2004.01.22 5:59:10 PM  czhower
{ IdCriticalSection
}
{
{   Rev 1.33    1/18/2004 11:15:52 AM  JPMugaas
{ IsIP was not handling "0" in an IP address.  This caused the address
{ "127.0.0.1" to be treated as a hostname.
}
{
{   Rev 1.32    12/4/2003 3:14:50 PM  BGooijen
{ Added HostByAddress
}
{
{   Rev 1.31    1/3/2004 12:21:44 AM  BGooijen
{ Added function SupportsIPv6
}
{
{   Rev 1.30    12/31/2003 9:54:16 PM  BGooijen
{ Added IPv6 support
}
{
{   Rev 1.29    2003.12.31 3:47:42 PM  czhower
{ Changed to use TextIsSame
}
{
{   Rev 1.28    10/21/2003 9:24:32 PM  BGooijen
{ Started on SendTo, ReceiveFrom
}
{
{   Rev 1.27    10/19/2003 5:21:28 PM  BGooijen
{ SetSocketOption
}
{
    Rev 1.26    10/15/2003 7:21:02 PM  DSiders
  Added resource strings in TIdStack.Make.
}
{
{   Rev 1.25    2003.10.11 5:51:02 PM  czhower
{ -VCL fixes for servers
{ -Chain suport for servers (Super core)
{ -Scheduler upgrades
{ -Full yarn support
}
{
{   Rev 1.24    10/5/2003 9:55:30 PM  BGooijen
{ TIdTCPServer works on D7 and DotNet now
}
{
{   Rev 1.23    04/10/2003 22:31:56  HHariri
{ moving of WSNXXX method to IdStack and renaming of the DotNet ones
}
{
{   Rev 1.22    10/2/2003 7:31:18 PM  BGooijen
{ .net
}
{
{   Rev 1.21    10/2/2003 6:05:16 PM  GGrieve
{ DontNet
}
{
{   Rev 1.20    2003.10.02 10:16:30 AM  czhower
{ .Net
}
{
{   Rev 1.19    2003.10.01 9:11:20 PM  czhower
{ .Net
}
{
{   Rev 1.18    2003.10.01 5:05:16 PM  czhower
{ .Net
}
{
{   Rev 1.17    2003.10.01 2:30:40 PM  czhower
{ .Net
}
{
{   Rev 1.16    2003.10.01 12:30:08 PM  czhower
{ .Net
}
{
{   Rev 1.14    2003.10.01 1:37:36 AM  czhower
{ .Net
}
{
{   Rev 1.12    9/30/2003 7:15:46 PM  BGooijen
{ IdCompilerDefines.inc is included now
}
{
{   Rev 1.11    2003.09.30 1:23:04 PM  czhower
{ Stack split for DotNet
}
unit IdStack;

{$I IdCompilerDefines.inc}

interface

uses
  Classes,
  IdException, IdStackConsts, IdTStrings, IdGlobal;

type
  EIdSocketError = class(EIdException)
  private
    FLastError: Integer;
  public
    // Params must be in this order to avoid conflict with CreateHelp
    // constructor in CBuilder
    constructor CreateError(const AErr: Integer; const AMsg: string); virtual;
    //
    property LastError: Integer read FLastError;
  end;

  TIdSocketListClass = class of TIdSocketList;

  // Descend from only TObject. This objects is created a lot and should be fast
  // and small
  TIdSocketList = class(TObject)
  protected
    FLock: TIdCriticalSection;
    //
    function GetItem(AIndex: Integer): TIdStackSocketHandle; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Add(AHandle: TIdStackSocketHandle); virtual; abstract;
    function Clone: TIdSocketList; virtual; abstract;
    function Count: Integer; virtual; abstract;
    class function CreateSocketList: TIdSocketList;
    property Items[AIndex: Integer]: TIdStackSocketHandle read GetItem; default;
    procedure Remove(AHandle: TIdStackSocketHandle); virtual; abstract;
    procedure Clear; virtual; abstract;
    function Contains(AHandle: TIdStackSocketHandle): boolean; virtual; abstract;
    procedure Lock;
    class function Select(AReadList: TIdSocketList; AWriteList: TIdSocketList;
     AExceptList: TIdSocketList; const ATimeout: Integer = IdTimeoutInfinite): Boolean; virtual;
    function SelectRead(const ATimeout: Integer = IdTimeoutInfinite): Boolean; virtual; abstract;
    function  SelectReadList(var VSocketList: TIdSocketList; const ATimeout: Integer = IdTimeoutInfinite): Boolean; virtual; abstract;
    procedure Unlock;
  end;

  TIdStack = class(TObject)
  protected
    FHostName: string;
    FLocalAddress: string;
    FLocalAddresses: TIdStrings;
    //
    function HostByName(const AHostName: string;
      const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION): string; virtual; abstract;

    function MakeCanonicalIPv6Address(const AAddr: string): string;
    function ReadHostName: string; virtual; abstract;
    procedure PopulateLocalAddresses; virtual; abstract;
    function GetLocalAddress: string; virtual; abstract;
    function GetLocalAddresses: TIdStrings; virtual; abstract;
  public
    function Accept(ASocket: TIdStackSocketHandle; var VIP: string;
             var VPort: Integer;
             const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION
             ): TIdStackSocketHandle; virtual; abstract;
    procedure Bind(ASocket: TIdStackSocketHandle; const AIP: string;
              const APort: Integer;
              const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION ); virtual; abstract;
    procedure Connect(const ASocket: TIdStackSocketHandle; const AIP: string;
              const APort: TIdPort;
              const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION); virtual; abstract;
    constructor Create; virtual;
    procedure Disconnect(ASocket: TIdStackSocketHandle); virtual; abstract;
    class procedure Make;
    procedure GetPeerName(ASocket: TIdStackSocketHandle; var VIP: string;
              var VPort: Integer); virtual; abstract;
    procedure GetSocketName(ASocket: TIdStackSocketHandle; var VIP: string;
              var VPort: TIdPort); virtual; abstract;
    function HostByAddress(const AAddress: string;
              const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION): string; virtual; abstract;
    function HostToNetwork(AValue: Word): Word; overload; virtual; abstract;
    function HostToNetwork(AValue: LongWord): LongWord; overload; virtual; abstract;
    function HostToNetwork(AValue: Int64): Int64; overload; virtual; abstract;
    function IsIP(AIP: string): Boolean;
    procedure Listen(ASocket: TIdStackSocketHandle; ABackLog: Integer); virtual;
              abstract;
    function NewSocketHandle(const ASocketType:TIdSocketType;
              const AProtocol: TIdSocketProtocol;
              const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION;
              const AOverlapped: Boolean = False)
              : TIdStackSocketHandle; virtual; abstract;
    function NetworkToHost(AValue: Word): Word; overload; virtual; abstract;
    function NetworkToHost(AValue: LongWord): LongWord; overload; virtual; abstract;
    function NetworkToHost(AValue: Int64): Int64; overload; virtual; abstract;
    procedure GetSocketOption(ASocket: TIdStackSocketHandle;
      ALevel: TIdSocketOptionLevel; AOptName: TIdSocketOption;
      out AOptVal: Integer); virtual; abstract;
    procedure SetSocketOption(ASocket: TIdStackSocketHandle; ALevel:TIdSocketOptionLevel;
             AOptName: TIdSocketOption; AOptVal: Integer); overload;virtual;abstract;
    function ResolveHost(const AHost: string;
             const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION): string;

    // Result:
    // > 0: Number of bytes received
    //   0: Connection closed gracefully
    // Will raise exceptions in other cases
    function Receive(ASocket: TIdStackSocketHandle; var VBuffer: TIdBytes)
             : Integer; virtual; abstract;
    function Send(
      ASocket: TIdStackSocketHandle;
      const ABuffer: TIdBytes;
      AOffset: Integer = 0;
      ASize: Integer = -1
      ): Integer; virtual; abstract;

    function ReceiveFrom(ASocket: TIdStackSocketHandle; var VBuffer: TIdBytes;
             var VIP: string; var VPort: Integer;
             const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION
             ): Integer; virtual; abstract;
    function SendTo(ASocket: TIdStackSocketHandle; const ABuffer: TIdBytes;
             const AOffset: Integer; const AIP: string; const APort: integer;
             const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION
             ): Integer; virtual; abstract;
    function SupportsIPv6:boolean; virtual; abstract;

    //
    // Properties
    //
    property HostName: string read FHostname;
    property LocalAddress: string read GetLocalAddress;
    property LocalAddresses: TIdStrings read GetLocalAddresses;
  end;

  TIdStackClass = class of TIdStack;

var
  GStack: TIdStack = nil;
  GSocketListClass: TIdSocketListClass;

// Procedures
  function IdStackFactory : TIdStack;
  procedure SetStackClass( AStackClass: TIdStackClass );

implementation

uses
  {$IFDEF LINUX}     IdStackLinux, {$ENDIF}
  {$IFDEF MSWINDOWS} IdStackWindows, {$ENDIF}
  {$IFDEF DOTNET}    IdStackDotNet, {$ENDIF}
  IdResourceStrings,
  SysUtils;

var
  GStackClass: TIdStackClass = nil;

procedure SetStackClass( AStackClass: TIdStackClass );
begin
  GStackClass := AStackClass;
end;

function IdStackFactory: TIdStack;
begin
  Result := GStackClass.Create;
  // GStackClass used to be public, but this factory has
  // replaced it so that the following line (which once
  // live in AfterConstruction, but this doesn't exist
  // in DotNet) will be run
  Result.FHostName := Result.ReadHostName;
end;

{ TIdSocketList }

constructor TIdSocketList.Create;
begin
  inherited Create;
  FLock := TIdCriticalSection.Create;
end;

class function TIdSocketList.CreateSocketList: TIdSocketList;
Begin
  Result := GSocketListClass.Create;
End;

destructor TIdSocketList.Destroy;
begin
  FreeAndNil(FLock);
  inherited;
end;

procedure TIdSocketList.Lock;
begin
  FLock.Acquire;
end;

class function TIdSocketList.Select(AReadList, AWriteList,
  AExceptList: TIdSocketList; const ATimeout: Integer): Boolean;
begin
  // C++ Builder cannot have abstract class functions thus we need this base
  Result := False;
end;

procedure TIdSocketList.Unlock;
begin
  FLock.Release;
end;

{ TIdStack }

constructor TIdStack.Create;
begin
  // Here for .net
  inherited;
end;

function TIdStack.IsIP(AIP: string): Boolean;
var
  i: Integer;
begin
//
//Result := Result and ((i > 0) and (i < 256));
//
  i := StrToIntDef(Fetch(AIP, '.'), -1);    {Do not Localize}
  Result := (i > -1) and (i < 256);
  i := StrToIntDef(Fetch(AIP, '.'), -1);    {Do not Localize}
  Result := Result and ((i > -1) and (i < 256));
  i := StrToIntDef(Fetch(AIP, '.'), -1);    {Do not Localize}
  Result := Result and ((i > -1) and (i < 256));
  i := StrToIntDef(Fetch(AIP, '.'), -1);    {Do not Localize}
  Result := Result and ((i > -1) and (i < 256)) and (AIP = '');
end;

function TIdStack.MakeCanonicalIPv6Address(const AAddr: string): string;
// return an empty string if the address is invalid,
// for easy checking if its an address or not.
var
  p, i: integer;
  dots, colons: integer;
  colonpos: array[1..8] of integer;
  dotpos: array[1..3] of integer;
  LAddr: string;
  num: integer;
  haddoublecolon: boolean;
  fillzeros: integer;
begin
  Result := ''; // error
  LAddr := AAddr;
  if Length(LAddr) = 0 then exit;

  if LAddr[1] = ':' then begin
    LAddr := '0'+LAddr;
  end;
  if LAddr[Length(LAddr)] = ':' then begin
    LAddr := LAddr + '0';
  end;
  dots := 0;
  colons := 0;
  for p := 1 to Length(LAddr) do begin
    case LAddr[p] of
      '.' : begin
              inc(dots);
              if dots < 4 then begin
                dotpos[dots] := p;
              end else begin
                exit; // error in address
              end;
            end;
      ':' : begin
              inc(colons);
              if colons < 8 then begin
                colonpos[colons] := p;
              end else begin
                exit; // error in address
              end;
            end;
      'a'..'f',
      'A'..'F': if dots>0 then exit;
        // allow only decimal stuff within dotted portion, ignore otherwise
      '0'..'9': ; // do nothing
      else exit; // error in address
    end; // case
  end; // for
  if not (dots in [0,3]) then begin
    exit; // you have to write 0 or 3 dots...
  end;
  if dots = 3 then begin
    if not (colons in [2..6]) then begin
      exit; // must not have 7 colons if we have dots
    end;
    if colonpos[colons] > dotpos[1] then begin
      exit; // x:x:x.x:x:x is not valid
    end;
  end else begin
    if not (colons in [2..7]) then begin
      exit; // must at least have two colons
    end;
  end;

  // now start :-)
  num := StrToIntDef('$'+Copy(LAddr, 1, colonpos[1]-1), -1);
  if (num<0) or (num>65535) then begin
    exit; // huh? odd number...
  end;
  Result := IntToHex(num,1)+':';

  haddoublecolon := false;
  for p := 2 to colons do begin
    if colonpos[p-1] = colonpos[p]-1 then begin
      if haddoublecolon then begin
        Result := '';
        exit; // only a single double-dot allowed!
      end;
      haddoublecolon := true;
      fillzeros := 8 - colons;
      if dots>0 then dec(fillzeros,2);
      for i := 1 to fillzeros do begin
        Result := Result + '0:'; {do not localize}
      end;
    end else begin
      num := StrToIntDef('$'+Copy(LAddr, colonpos[p-1]+1, colonpos[p]-colonpos[p-1]-1), -1);
      if (num<0) or (num>65535) then begin
        Result := '';
        exit; // huh? odd number...
      end;
      Result := Result + IntToHex(num,1)+':';
    end;
  end; // end of colon separated part

  if dots = 0 then begin
    num := StrToIntDef('$'+Copy(LAddr, colonpos[colons]+1, MaxInt), -1);
    if (num<0) or (num>65535) then begin
      Result := '';
      exit; // huh? odd number...
    end;
    Result := Result + IntToHex(num,1)+':';
  end;

  if dots > 0 then begin
    num := StrToIntDef(Copy(LAddr, colonpos[colons]+1, dotpos[1]-colonpos[colons]-1),-1);
    if (num < 0) or (num>255) then begin
      Result := '';
      exit;
    end;
    Result := Result + IntToHex(num, 2);
    num := StrToIntDef(Copy(LAddr, dotpos[1]+1, dotpos[2]-dotpos[1]-1),-1);
    if (num < 0) or (num>255) then begin
      Result := '';
      exit;
    end;
    Result := Result + IntToHex(num, 2)+':';

    num := StrToIntDef(Copy(LAddr, dotpos[2]+1, dotpos[3]-dotpos[2]-1),-1);
    if (num < 0) or (num>255) then begin
      Result := '';
      exit;
    end;
    Result := Result + IntToHex(num, 2);
    num := StrToIntDef(Copy(LAddr, dotpos[3]+1, 3), -1);
    if (num < 0) or (num>255) then begin
      Result := '';
      exit;
    end;
    Result := Result + IntToHex(num, 2)+':';
  end;
  SetLength(Result, Length(Result)-1);
end;

class procedure TIdStack.Make;
begin
  EIdException.IfTrue(GStackClass = nil, RSStackClassUndefined);
  EIdException.IfTrue(GStack <> nil, RSStackAlreadyCreated);
  GStack := IdStackFactory;
end;

function TIdStack.ResolveHost(const AHost: string;
  const AIPVersion: TIdIPVersion = ID_DEFAULT_IP_VERSION): string;
begin
  if AIPVersion = Id_IPv4 then begin
    // Sometimes 95 forgets who localhost is
  if TextIsSame(AHost, 'LOCALHOST') then begin    {Do not Localize}
      Result := '127.0.0.1';    {Do not Localize}
    end else if IsIP(AHost) then begin
      Result := AHost;
    end else begin
      Result := HostByName(AHost, Id_IPv4);
    end;
  end else if AIPVersion = Id_IPv6 then begin
    result := MakeCanonicalIPv6Address(AHost);
    if result='' then begin
      Result := HostByName(AHost, Id_IPv6);
    end;
  end //else IPVersionUnsupported; // IPVersionUnsupported is introduced in
                                   // a decendant class, so we can't use it here,
                                   // TODO: move it to this class
end;

constructor EIdSocketError.CreateError(const AErr: Integer; const AMsg: string);
begin
  inherited Create(AMsg);
  FLastError := AErr;
end;

initialization
  GStackClass :=
   {$IFDEF LINUX}     TIdStackLinux;   {$ENDIF}
   {$IFDEF MSWINDOWS} TIdStackWindows; {$ENDIF}
   {$IFDEF DOTNET}    TIdStackDotNet;  {$ENDIF}
end.
