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
{   Rev 1.0    2004.02.03 3:14:52 PM  czhower
{ Move and updates
}
{
    Rev 1.2    10/15/2003 9:43:20 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.1    1-10-2003 19:44:28  BGooijen
{ fixed leak in CloseLibrary()
}
{
{   Rev 1.0    11/13/2002 09:03:24 AM  JPMugaas
}
unit IdWship6;

interface

{$I IdCompilerDefines.inc}

uses IdWinSock2;

const
  Wship6_dll =   'Wship6.dll';    {do not localize}
  iphlpapi_dll = 'iphlpapi.dll';  {do not localize}

//
// Flags used in "hints" argument to getaddrinfo().
//
const
 {$EXTERNALSYM AI_PASSIVE     }
 AI_PASSIVE     = $1 ; // Socket address will be used in bind() call.
 {$EXTERNALSYM AI_CANONNAME   }
 AI_CANONNAME   = $2 ; // Return canonical name in first ai_canonname.
 {$EXTERNALSYM AI_NUMERICHOST }
 AI_NUMERICHOST = $4 ; // Nodename must be a numeric address string.

//
// Error codes from getaddrinfo().
//
const
  {$EXTERNALSYM EAI_ADDRFAMILY}
  EAI_ADDRFAMILY = 1  ; // Address family for nodename not supported.
  {$EXTERNALSYM EAI_AGAIN}
  EAI_AGAIN      = 2  ; // Temporary failure in name resolution.
  {$EXTERNALSYM EAI_BADFLAGS}
  EAI_BADFLAGS   = 3  ; // Invalid value for ai_flags.
  {$EXTERNALSYM EAI_FAIL}
  EAI_FAIL       = 4  ; // Non-recoverable failure in name resolution.
  {$EXTERNALSYM EAI_FAMILY}
  EAI_FAMILY     = 5  ; // Address family ai_family not supported.
  {$EXTERNALSYM EAI_MEMORY}
  EAI_MEMORY     = 6  ; // Memory allocation failure.
  {$EXTERNALSYM EAI_NODATA}
  EAI_NODATA     = 7  ; // No address associated with nodename.
  {$EXTERNALSYM EAI_NONAME}
  EAI_NONAME     = 8  ; // Nodename nor servname provided, or not known.
  {$EXTERNALSYM EAI_SERVICE}
  EAI_SERVICE    = 9  ; // Servname not supported for ai_socktype.
  {$EXTERNALSYM EAI_SOCKTYPE}
  EAI_SOCKTYPE   = 10 ; // Socket type ai_socktype not supported.
  {$EXTERNALSYM EAI_SYSTEM}
  EAI_SYSTEM     = 11 ; // System error returned in errno.

const
  {$EXTERNALSYM NI_MAXHOST}
  NI_MAXHOST  = 1025;      // Max size of a fully-qualified domain name.
  {$EXTERNALSYM NI_MAXSERV}
  NI_MAXSERV  =   32;      // Max size of a service name.

//
// Flags for getnameinfo().
//
const
  {$EXTERNALSYM NI_NOFQDN}
  NI_NOFQDN       =   $1  ;  // Only return nodename portion for local hosts.
  {$EXTERNALSYM NI_NUMERICHOST}
  NI_NUMERICHOST  =   $2  ;  // Return numeric form of the host's address.
  {$EXTERNALSYM NI_NAMEREQD}
  NI_NAMEREQD     =   $4  ;  // Error if the host's name not in DNS.
  {$EXTERNALSYM NI_NUMERICSERV}
  NI_NUMERICSERV  =   $8  ;  // Return numeric form of the service (port #).
  {$EXTERNALSYM NI_DGRAM}
  NI_DGRAM        =   $10 ;  // Service is a datagram service.

//
// Flag values for getipnodebyname().
//
const
  {$EXTERNALSYM AI_V4MAPPED}
  AI_V4MAPPED    = 1 ;
  {$EXTERNALSYM AI_ALL}
  AI_ALL         = 2 ;
  {$EXTERNALSYM AI_ADDRCONFIG}
  AI_ADDRCONFIG  = 4 ;
  {$EXTERNALSYM AI_DEFAULT}
  AI_DEFAULT     = AI_V4MAPPED or AI_ADDRCONFIG ;

//
// Socket options at the IPPROTO_IPV6 level.
//
const
  {$EXTERNALSYM IPV6_HDRINCL          }
  IPV6_HDRINCL           = 2 ;  // int; header is included with data

  {$EXTERNALSYM IPV6_UNICAST_HOPS     }
  IPV6_UNICAST_HOPS      = 4 ; // Set/get IP unicast hop limit.
  {$EXTERNALSYM IPV6_MULTICAST_IF     }
  IPV6_MULTICAST_IF      = 9 ;  // Set/get IP multicast interface.
  {$EXTERNALSYM IPV6_MULTICAST_HOPS   }
  IPV6_MULTICAST_HOPS    = 10 ; // Set/get IP multicast ttl.
  {$EXTERNALSYM IPV6_MULTICAST_LOOP   }
  IPV6_MULTICAST_LOOP    = 11 ; // Set/get IP multicast loopback.
  {$EXTERNALSYM IPV6_ADD_MEMBERSHIP   }
  IPV6_ADD_MEMBERSHIP    = 12 ; // Add an IP group membership.
  {$EXTERNALSYM IPV6_DROP_MEMBERSHIP  }
  IPV6_DROP_MEMBERSHIP   = 13 ; // Drop an IP group membership.
  {$EXTERNALSYM IPV6_JOIN_GROUP       }
  IPV6_JOIN_GROUP        = IPV6_ADD_MEMBERSHIP;
  {$EXTERNALSYM IPV6_LEAVE_GROUP      }
  IPV6_LEAVE_GROUP       = IPV6_DROP_MEMBERSHIP;
  {$EXTERNALSYM IPV6_PKTINFO          }
  IPV6_PKTINFO           = 19; /// Receive packet information for ipv6
  {$EXTERNALSYM IPV6_HOPLIMIT         }  ///
  IPV6_HOPLIMIT          = 21; // Receive packet hop limit
  {$EXTERNALSYM IPV6_PROTECTION_LEVEL }
  IPV6_PROTECTION_LEVEL  = 23; // Set/get IPv6 protection level
//
// Socket options at the IPPROTO_UDP level.
//
const
  {$EXTERNALSYM UDP_CHECKSUM_COVERAGE }
  UDP_CHECKSUM_COVERAGE  = 20 ; // Set/get UDP-Lite checksum coverage.

const
  {$EXTERNALSYM PROTECTION_LEVEL_RESTRICTED}
  PROTECTION_LEVEL_RESTRICTED   = 10;  //* for Intranet apps      /*
  {$EXTERNALSYM PROTECTION_LEVEL_DEFAULT}
  PROTECTION_LEVEL_DEFAULT      = 20;  //* default level          /*
  {$EXTERNALSYM PROTECTION_LEVEL_UNRESTRICTED}
  PROTECTION_LEVEL_UNRESTRICTED = 30;  //* for peer-to-peer apps  /*

function gaiErrorToWsaError(const gaiError:integer):integer;

type
  Paddrinfo = ^Taddrinfo;
  PPaddrinfo = ^Paddrinfo;
  Taddrinfo = packed record
    ai_flags: integer;
    ai_family: integer;
    ai_socktype: integer;
    ai_protocol: integer;
    ai_addrlen: cardinal;
    ai_canonname: pchar;
    ai_addr: psockaddr;
    ai_next: paddrinfo;
  end;
///* Argument structure for IPV6_JOIN_GROUP and IPV6_LEAVE_GROUP */
  Pipv6_mreq = ^Tipv6_mreq;
  Tipv6_mreq = packed record
     ipv6mr_multiaddr : in6_addr; // IPv6 multicast address.
     ipv6mr_interface : Cardinal;  //// Interface index.
  end;

//function getaddrinfo( NodeName: pchar; ServName: pchar; Hints: Paddrinfo; addrinfo: PPaddrinfo ) : integer; stdcall; external Wship6_dll;
//function getnameinfo( sa: psockaddr; salen: cardinal; host: pchar; hostlen: cardinal; serv: pchar; servlen: cardinal;flags:integer ) : integer; stdcall; external Wship6_dll;
//procedure freeaddrinfo(ai: Paddrinfo); stdcall; external Wship6_dll;

//function GetAdaptersAddresses( Family:cardinal; Flags:cardinal; Reserved:pointer; pAdapterAddresses: PIP_ADAPTER_ADDRESSES; pOutBufLen:pcardinal):cardinal;stdcall;  external iphlpapi_dll;

{ the following are not used, nor tested}
//function getipnodebyaddr(const src:pointer;  len:integer; af:integer;var error_num:integer) :phostent;stdcall; external Wship6_dll;
//procedure freehostent(ptr:phostent);stdcall; external Wship6_dll;
//function inet_pton(af:integer; const src:pchar; dst:pointer):integer;stdcall; external Wship6_dll;
//function inet_ntop(af:integer; const src:pointer; dst:pchar;size:integer):pchar;stdcall; external Wship6_dll;
{ end the following are not used, nor tested}


Type
 Tgetaddrinfo=function( NodeName: pchar; ServName: pchar; Hints: Paddrinfo; addrinfo: PPaddrinfo ) : integer; stdcall;
 Tgetnameinfo=function( sa: psockaddr; salen: cardinal; host: pchar; hostlen: cardinal; serv: pchar; servlen: cardinal;flags:integer ) : integer; stdcall;
 Tfreeaddrinfo=procedure(ai: Paddrinfo); stdcall;


{type
  WSAMSG = packed record
    name: LPSOCKADDR;
    namelen: integer;
    lpBuffers: LPWSABUF;
    dwBufferCount: Cardinal;
    Control: WSABUF;
    dwFlags: Cardinal;
  end;
  PWSAMSG  = ^WSAMSG;
  LPWSAMSG = ^WSAMSG;    }


var
  getaddrinfo:Tgetaddrinfo=nil;
  getnameinfo:Tgetnameinfo=nil;
  freeaddrinfo:Tfreeaddrinfo=nil;

var
  IdIPv6Available:boolean=false;

implementation

uses Windows,SysUtils;

var
  hWship6Dll : THandle = 0; // Wship6.dll handle

function gaiErrorToWsaError(const gaiError:integer):integer;
begin
  case gaiError of
    EAI_ADDRFAMILY: result:= 0; // TODO: find a decent error for here
    EAI_AGAIN:    result:= WSATRY_AGAIN ;
    EAI_BADFLAGS: result:= WSAEINVAL ;
    EAI_FAIL:     result:= WSANO_RECOVERY ;
    EAI_FAMILY:   result:= WSAEAFNOSUPPORT ;
    EAI_MEMORY:   result:= WSA_NOT_ENOUGH_MEMORY ;
    EAI_NODATA:   result:= WSANO_DATA ;
    EAI_NONAME:   result:= WSAHOST_NOT_FOUND ;
    EAI_SERVICE:  result:= WSATYPE_NOT_FOUND ;
    EAI_SOCKTYPE: result:= WSAESOCKTNOSUPPORT ;
    EAI_SYSTEM:   begin
    	result:=0; // avoid warning
    	{$ifndef VCL6ORABOVE}
    	RaiseLastWin32Error;
    	{$else}
    	RaiseLastOSError;
    	{$endif}
    	end;
    else          result:= gaiError;
  end;
end;

Procedure CloseLibrary;
var h : THandle;
begin
  h := InterlockedExchange(Integer(hWship6Dll),0);
  if h<>0 then begin
    IdIPv6Available:=false;
    FreeLibrary(h);
    getaddrinfo:=nil;
    getnameinfo:=nil;
    freeaddrinfo:=nil;
  end;
end;

Procedure InitLibrary;
begin
  IdIPv6Available:=false;
  hWship6Dll := LoadLibrary( Wship6_dll );
  if hWship6Dll<>0 then begin
    getaddrinfo:=GetProcAddress(hWship6Dll,'getaddrinfo');  {do not localize}
    if assigned(getaddrinfo) then begin
      getnameinfo:=GetProcAddress(hWship6Dll,'getnameinfo');  {do not localize}
      if assigned(getnameinfo) then begin
        freeaddrinfo:=GetProcAddress(hWship6Dll,'freeaddrinfo');  {do not localize}
        if assigned(freeaddrinfo) then begin
          IdIPv6Available:=true;
        end;
      end;
    end;
    if not IdIPv6Available then CloseLibrary;
  end;
end;

initialization
  InitLibrary;
finalization
  CloseLibrary;
end.

