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
{   Rev 1.0    2004.02.03 3:14:50 PM  czhower
{ Move and updates
}
{
{   Rev 1.15    1/3/2004 12:41:48 AM  BGooijen
{ Fixed WSAEnumProtocols
}
{
    Rev 1.14    10/15/2003 1:20:48 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.13    2003.10.01 11:16:38 AM  czhower
{ .Net
}
{
{   Rev 1.12    9/24/2003 09:18:24 AM  JPMugaas
{ Fixed an AV that happened when a stack call was made.
}
{
{   Rev 1.11    24/9/2003 3:11:34 PM  SGrobety
{ First wave of fixes for compiling in dotnet. Still not functional, needed to
{ unlock to fix critical failure in Delphi code
}
{
{   Rev 1.10    9/22/2003 11:20:14 PM  EHill
{ Removed assembly code and replaced with defined API stubs.
}
{
    Rev 1.9    7/7/2003 12:55:10 PM  BGooijen
  Fixed ServiceQueryTransmitFile, and made it public
}
{
{   Rev 1.8    2003.05.09 10:59:30 PM  czhower
}
{
    Rev 1.7    4/19/2003 10:28:24 PM  BGooijen
  some functions were linked to the wrong dll
}
{
{   Rev 1.6    4/19/2003 11:14:40 AM  JPMugaas
{ Made some tentitive wrapper functions for some things that should be called
{ from the Service Provider.  Fixed WSARecvMsg.
}
{
{   Rev 1.5    4/19/2003 02:29:26 AM  JPMugaas
{ Added TransmitPackets API function call.  Note that this is only supported in
{ Windows XP or later.
}
{
    Rev 1.4    4/19/2003 12:22:58 AM  BGooijen
  fixed: ConnectEx DisconnectEx WSARecvMsg
}
{
{   Rev 1.3    4/18/2003 12:00:58 AM  JPMugaas
{ added
{ ConnectEx
{ DisconnectEx
{ WSARecvMsg
{
{ Changed header procedure type names to be consistant with the old
{ IdWinsock.pas in Indy 8.0 and with the rest of the unit.
}
{
{   Rev 1.2    3/22/2003 10:01:26 PM  JPMugaas
{ WSACreateEvent couldn't load because of a space.
}
{
{   Rev 1.1    3/22/2003 09:46:54 PM  JPMugaas
{ It turns out that we really do not need the TGUID defination in the header at
{ all.  It's defined in D4, D5, D6, and D7.
}
{
{   Rev 1.0    11/13/2002 09:02:54 AM  JPMugaas
}
//-------------------------------------------------------------
//
//       Borland Delphi Runtime Library
//       <API> interface unit
//
// Portions created by Microsoft are
// Copyright (C) 1995-1999 Microsoft Corporation.
// All Rights Reserved.
//
// The original file is: Winsock2.h from CBuilder5 distribution.
// The original Pascal code is: winsock2.pas, released 03 Mar 2001.
// The initial developer of the Pascal code is Alex Konshin
// (alexk@mtgroup.ru).
//-------------------------------------------------------------


{ Winsock2.h -- definitions to be used with the WinSock 2 DLL and WinSock 2 applications.
  This header file corresponds to version 2.2.x of the WinSock API specification.
  This file includes parts which are Copyright (c) 1982-1986 Regents
  of the University of California. All rights reserved.
  The Berkeley Software License Agreement specifies the terms and
  conditions for redistribution. }

// Note that the original unit is copyrighted by the original author and I did obtain his
// permission to port and use this as part of Indy - J. Peter Mugaas

// 2002-01-28 - Hadi Hariri. Fixes for C++ Builder. Thanks to Chuck Smith.
// 2001 - Oct -25  J. Peter Mugaas
//    Made adjustments for Indy usage by
//    1) including removing Trace logging
//    2) renaming and consolidating some .INC files as appropriate
//    3) modifying the unit to follow Indy conventions
//    4) Adding TransmitFile support for the HTTP Server
//    5) Removing all static loading code that was IFDEF'ed.    {Do not Localize}
// 2001 - Mar - 1  Alex Konshin
// Revision 3
// converted by Alex Konshin, mailto:alexk@mtgroup.ru
// revision 3, March,1 2001


unit IdWinSock2;

interface

{$ALIGN OFF}
{$RANGECHECKS OFF}
{$WRITEABLECONST OFF}

uses SysUtils, Windows, IdException, IdSys;

type
  EIdWinsockStubError = class(EIdException)
  protected
    FWin32Error : DWORD;
    FWin32ErrorMessage : String;
    FTitle : String;
  public
    constructor Build(const ATitle : String; AWin32Error : DWORD );
    property Win32Error : DWORD read FWin32Error;
    property Win32ErrorMessage : String read FWin32ErrorMessage;
    property Title : String read FTitle;
  end;


{$DEFINE WS2_DLL_FUNC_VARS}
{$DEFINE INCL_WINSOCK_API_PROTOTYPES}



//  Define the current Winsock version. To build an earlier Winsock version
//  application redefine this value prior to including Winsock2.h
const
  winsock_version = $0202;
  winsock2_dll = 'WS2_32.DLL';    {Do not Localize}

type
  u_char  = Byte;
  u_short = Word;
  //u_int   = DWORD;
  u_int   = Integer;
  u_long  = DWORD;
// The new type to be used in all instances which refer to sockets.
  TSocket = u_int;
 {$EXTERNALSYM WSAEVENT}
  wsaevent = THandle;
  Pwsaevent = ^wsaevent;
  {$EXTERNALSYM LPWSAEVENT}
  LPwsaevent = Pwsaevent;
{$IFDEF UNICODE}
  PMBChar = PWideChar;
{$ELSE}
  PMBChar = PChar;
{$ENDIF}

const
  {$EXTERNALSYM FD_SETSIZE}
  fd_setsize     =   64;

// the following emits are a workaround to the name conflicts
// with the winsock2 header files
(*$HPPEMIT '#include <winsock2.h>'*)
(*$HPPEMIT '#include <ws2tcpip.h>'*)
(*$HPPEMIT '#include <wsipx.h>'*)
(*$HPPEMIT '#include <wsnwlink.h>'*)
(*$HPPEMIT '#include <wsnetbs.h>'*)
(*$HPPEMIT '#include <ws2atm.h>'*)
(*$HPPEMIT '#include <mswsock.h>'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'namespace Idwinsock2'*)
(*$HPPEMIT '{'*)
(*$HPPEMIT '    typedef fd_set *PFDSet;'*) // due to name conflict with procedure FD_SET
(*$HPPEMIT '    typedef fd_set TFDSet;'*)  // due to name conflict with procedure FD_SET
(*$HPPEMIT '}'*)
(*$HPPEMIT ''*)

// the following emits are to ensure all supported versions
// of C++Builder know about the latest winsock2 structures
(*$HPPEMIT '#ifdef __BORLANDC__'*)
(*$HPPEMIT '#if (__BORLANDC__ < 0x560)    // prior to BCB6'*)
(*$HPPEMIT 'typedef struct in_pktinfo {'*)
(*$HPPEMIT '    IN_ADDR ipi_addr;    // destination IPv4 address'*)
(*$HPPEMIT '    UINT    ipi_ifindex; // received interface index'*)
(*$HPPEMIT '} IN_PKTINFO;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'typedef struct in6_pktinfo {'*)
(*$HPPEMIT '    IN6_ADDR ipi6_addr;    // destination IPv6 address'*)
(*$HPPEMIT '    UINT     ipi6_ifindex; // received interface index'*)
(*$HPPEMIT '} IN6_PKTINFO;'*)
(*$HPPEMIT ''*)
(*$HPPEMIT 'typedef struct addrinfo {'*)
(*$HPPEMIT '    int ai_flags;              /* AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST */'*)
(*$HPPEMIT '    int ai_family;             /* PF_xxx */'*)
(*$HPPEMIT '    int ai_socktype;           /* SOCK_xxx */'*)
(*$HPPEMIT '    int ai_protocol;           /* 0 or IPPROTO_xxx for IPv4 and IPv6 */'*)
(*$HPPEMIT '    size_t ai_addrlen;         /* Length of ai_addr */'*)
(*$HPPEMIT '    char *ai_canonname;        /* Canonical name for nodename */'*)
(*$HPPEMIT '    struct sockaddr *ai_addr;  /* Binary address */'*)
(*$HPPEMIT '    struct addrinfo *ai_next;  /* Next structure in linked list */'*)
(*$HPPEMIT '} ADDRINFO, FAR * LPADDRINFO;'*)
(*$HPPEMIT '#endif'*)
(*$HPPEMIT '#if (__BORLANDC__ < 0x550)    // prior to BCB5'*)
(*$HPPEMIT 'typedef struct _INTERFACE_INFO_EX'*)
(*$HPPEMIT '{'*)
(*$HPPEMIT '    u_long          iiFlags;            /* Interface flags */'*)
(*$HPPEMIT '    SOCKET_ADDRESS  iiAddress;          /* Interface address */'*)
(*$HPPEMIT '    SOCKET_ADDRESS  iiBroadcastAddress; /* Broadcast address */'*)
(*$HPPEMIT '    SOCKET_ADDRESS  iiNetmask;          /* Network mask */'*)
(*$HPPEMIT '} INTERFACE_INFO_EX, FAR * LPINTERFACE_INFO_EX;'*)
(*$HPPEMIT '#endif'*)
(*$HPPEMIT '#endif'*)

type
  {$NODEFINE PFDSet}
  PFDSet = ^TFDSet;
  {$NODEFINE TFDSet}
  TFDSet = packed record
    fd_count: u_int;
    fd_array: array[0..fd_setsizE-1] of TSocket;
  end;

  {$EXTERNALSYM TTimeval}
  {$EXTERNALSYM PTimeVal}
  PTimeVal = ^TTimeVal;
  TTimeVal = packed record
    tv_sec: Longint;
    tv_usec: Longint;
  end;

const
  {$EXTERNALSYM IOCPARM_MASK}
  iocparm_mask = $7f;
  {$EXTERNALSYM IOC_VOID}
  ioc_void     = $20000000;
  {$EXTERNALSYM IOC_OUT}
  ioc_out      = $40000000;
  {$EXTERNALSYM IOC_IN}
  ioc_in       = $80000000;
  {$EXTERNALSYM IOC_INOUT}
  ioc_inout    = (IOC_IN or IOC_OUT);

// get # bytes to read
  {$EXTERNALSYM FIONREAD}
  fionread     = ioc_out or (SizeOf(Longint) shl 16) or (Ord('f') shl 8) or 127;    {Do not Localize}
// set/clear non-blocking i/o
  {$EXTERNALSYM FIONBIO}
  fionbio      = ioc_in  or (SizeOf(Longint) shl 16) or (Ord('f') shl 8) or 126;    {Do not Localize}
// set/clear async i/o
  {$EXTERNALSYM FIOASYNC}
  fioasync     = ioc_in  or (SizeOf(Longint) shl 16) or (Ord('f') shl 8) or 125;    {Do not Localize}

//  Socket I/O Controls

// set high watermark
  {$EXTERNALSYM SIOCSHIWAT}
  siocshiwat   = ioc_in  or (SizeOf(Longint) shl 16) or (Ord('s') shl 8);    {Do not Localize}
// get high watermark
  {$EXTERNALSYM SIOCGHIWAT}
  siocghiwat   = ioc_out or (SizeOf(Longint) shl 16) or (Ord('s') shl 8) or 1;    {Do not Localize}
// set low watermark
  {$EXTERNALSYM SIOCSLOWAT}
  siocslowat   = ioc_in  or (SizeOf(Longint) shl 16) or (Ord('s') shl 8) or 2;    {Do not Localize}
// get low watermark
  {$EXTERNALSYM SIOCGLOWAT}
  siocglowat   = ioc_out or (SizeOf(Longint) shl 16) or (Ord('s') shl 8) or 3;    {Do not Localize}
// at oob mark?
  {$EXTERNALSYM SIOCATMARK}
  siocatmark   = ioc_out or (SizeOf(Longint) shl 16) or (Ord('s') shl 8) or 7;    {Do not Localize}


//  Structures returned by network data base library, taken from the
//  BSD file netdb.h.  All addresses are supplied in host order, and
//  returned in network order (suitable for use in system calls).
type
  {$EXTERNALSYM PHostent}
  PHostEnt = ^THostEnt;
  {$EXTERNALSYM Thostent}
  THostEnt = packed record
    h_name: PChar;                 // official name of host
    h_aliases: ^PChar;             // alias list
    h_addrtype: Smallint;          // host address type
    h_length: Smallint;            // length of address
    case Byte of
      0: (h_address_list: ^PChar);
      1: (h_addr: ^PChar);         // address, for backward compat
  end;

//  It is assumed here that a network number
//  fits in 32 bits.
  {$EXTERNALSYM PNetEnt}
  PNetEnt = ^TNetEnt;
  {$EXTERNALSYM Tnetent}
  TNetEnt = packed record
    n_name: PChar;                 // official name of net
    n_aliases: ^PChar;             // alias list
    n_addrtype: Smallint;          // net address type
    n_net: u_long;                 // network #
  end;

  {$EXTERNALSYM PSerVent}
  PServEnt = ^TServEnt;
  {$EXTERNALSYM TSerVent}
  TServEnt = packed record
    s_name: PChar;                 // official service name
    s_aliases: ^PChar;             // alias list
    s_port: Smallint;              // protocol to use
    s_proto: PChar;                // port #
  end;

  {$EXTERNALSYM PProtoent}
  PProtoEnt = ^TProtoEnt;
  {$EXTERNALSYM TProtoEnt}
  TProtoEnt = packed record
    p_name: PChar;                 // official protocol name
    p_aliases: ^Pchar;             // alias list
    p_proto: Smallint;             // protocol #
  end;

// Constants and structures defined by the internet system,
// Per RFC 790, September 1981, taken from the BSD file netinet/in.h.
const

// Protocols
  {$EXTERNALSYM IPPROTO_IP}
  ipproto_ip       =   0;             // dummy for IP
  ipproto_hopopts  = 0;             // IPv6 Hop-by-Hop options - RFC 2292
//RFC 2292 notes:
//   Berkeley-derived IPv4 implementations also define IPPROTO_IP to be 0.
//   This should not be a problem since IPPROTO_IP is used only with IPv4
//   sockets and IPPROTO_HOPOPTS only with IPv6 sockets.
  {$EXTERNALSYM IPPROTO_ICMP}
  ipproto_icmp     =   1;             // control message protocol
  {$EXTERNALSYM IPPROTO_IGMP}
  ipproto_igmp     =   2;             // group management protocol
  {$EXTERNALSYM IPPROTO_GGP}
  ipproto_ggp      =   3;             // gateway^2 (deprecated)
  {$EXTERNALSYM IPPROTO_TCP}
  ipproto_tcp      =   6;             // TCP
  {$EXTERNALSYM IPPROTO_PUP}
  ipproto_pup      =  12;             // pup
  {$EXTERNALSYM IPPROTO_UDP}
  ipproto_udp      =  17;             // UDP - user datagram protocol
  {$EXTERNALSYM IPPROTO_IDP}
  ipproto_idp      =  22;             // xns idp
  {$EXTERNALSYM IPPROTO_IPV6}
  ipproto_ipv6     =  41;             // IPv6
  {$EXTERNALSYM ipproto_routing }
  ipproto_routing  =  43;             // IPv6 Routing header - RFC 2292
  {$EXTERNALSYM ipproto_fragment}
  ipproto_fragment =  44;             // IPv6 fragmentation header - RFC 2292
  {$EXTERNALSYM ipproto_esp}
  ipproto_esp      =  50;             // encapsulating security payload - RFC 2292
  {$EXTERNALSYM ipproto_ah}
  ipproto_ah       =  51;             // authentication header - RFC 2292
  {$EXTERNALSYM ipproto_icmpv6}
  ipproto_icmpv6   =  58;             // ICMPv6 - RFC 2292
  {$EXTERNALSYM ipproto_none}
  ipproto_none     =  59;             // IPv6 no next header - RFC 2292
  {$EXTERNALSYM  ipproto_dstopts}
  ipproto_dstopts  =  60;             // IPv6 Destination options - RFC 2292
  {$EXTERNALSYM  ipproto_nd}
  ipproto_nd       =  77;             // UNOFFICIAL net disk proto
  {$EXTERNALSYM  ipproto_iclfxbm}
  ipproto_iclfxbm  =  78;

  {$EXTERNALSYM IPPROTO_RAW}
  ipproto_raw      = 255;             // raw IP packet
  {$EXTERNALSYM IPPROTO_MAX}
  ipproto_max      = 256;

const
// Port/socket numbers: network standard functions
  {$EXTERNALSYM IPPORT_ECHO}
  ipport_echo        =   7;
  {$EXTERNALSYM IPPORT_DISCARD}
  ipport_discard     =   9;
  {$EXTERNALSYM IPPORT_SYSTAT}
  ipport_systat      =  11;
  {$EXTERNALSYM IPPORT_DAYTIME}
  ipport_daytime     =  13;
  {$EXTERNALSYM IPPORT_NETSTAT}
  ipport_netstat     =  15;
  {$EXTERNALSYM IPPORT_FTP}
  ipport_ftp         =  21;
  {$EXTERNALSYM IPPORT_TELNET}
  ipport_telnet      =  23;
  {$EXTERNALSYM IPPORT_SMTP}
  ipport_smtp        =  25;
  {$EXTERNALSYM IPPORT_TIMESERVER}
  ipport_timeserver  =  37;
  {$EXTERNALSYM IPPORT_NAMESERVER}
  ipport_nameserver  =  42;
  {$EXTERNALSYM IPPORT_WHOIS}
  ipport_whois       =  43;
  {$EXTERNALSYM IPPORT_MTP}
  ipport_mtp         =  57;

// Port/socket numbers: host specific functions
  {$EXTERNALSYM IPPORT_TFTP}
  ipport_tftp        =  69;
  {$EXTERNALSYM IPPORT_RJE}
  ipport_rje         =  77;
  {$EXTERNALSYM IPPORT_FINGER}
  ipport_finger      =  79;
  {$EXTERNALSYM ipport_ttylink}
  ipport_ttylink     =  87;
  {$EXTERNALSYM IPPORT_SUPDUP}
  ipport_supdup      =  95;

// UNIX TCP sockets
 {$EXTERNALSYM IPPORT_EXECSERVER}
  ipport_execserver  = 512;
 {$EXTERNALSYM IPPORT_LOGINSERVER}
   ipport_loginserver = 513;
  {$EXTERNALSYM IPPORT_CMDSERVER}
  ipport_cmdserver   = 514;
  {$EXTERNALSYM IPPORT_EFSSERVER}
  ipport_efsserver   = 520;

// UNIX UDP sockets
  {$EXTERNALSYM IPPORT_BIFFUDP}
  ipport_biffudp     = 512;
  {$EXTERNALSYM IPPORT_WHOSERVER}
  ipport_whoserver   = 513;
  {$EXTERNALSYM IPPORT_ROUTESERVER}
  ipport_routeserver = 520;

// Ports < IPPORT_RESERVED are reserved for  privileged processes (e.g. root).
  {$EXTERNALSYM ipport_reserved}
  ipport_reserved    =1024;

// Link numbers
  {$EXTERNALSYM IMPLINK_IP}
  implink_ip         = 155;
  {$EXTERNALSYM IMPLINK_LOWEXPER}
  implink_lowexper   = 156;
  {$EXTERNALSYM IMPLINK_HIGHEXPER}
  implink_highexper  = 158;

  //transmit file flag values
  {$EXTERNALSYM TF_DISCONNECT}
  tf_disconnect      = $01;
  {$EXTERNALSYM TF_REUSE_SOCKET}
  tf_reuse_socket    = $02;
  {$EXTERNALSYM TF_WRITE_BEHIND}
  tf_write_behind    = $04;
  {$EXTERNALSYM TF_USE_DEFAULT_WORKER}
  tf_use_default_worker = $00;
  {$EXTERNALSYM TF_USE_SYSTEM_THREAD}
  tf_use_system_thread = $10;
  {$EXTERNALSYM TF_USE_KERNEL_APC}
  tf_use_kernel_apc   = $20;

// This is used instead of -1, since the TSocket type is unsigned.
  {$EXTERNALSYM INVALID_SOCKET}
  invalid_socket     = TSocket(not(0));
  {$EXTERNALSYM SOCKET_ERROR}
  socket_error       = -1;

//  The  following  may  be used in place of the address family, socket type, or
//  protocol  in  a  call  to WSASocket to indicate that the corresponding value
//  should  be taken from the supplied WSAPROTOCOL_INFO structure instead of the
//  parameter itself.
  {$EXTERNALSYM FROM_PROTOCOL_INFO}
  from_protocol_info = -1;


// Types
  {$EXTERNALSYM SOCK_STREAM}
  sock_stream     = 1;               { stream socket }
  {$EXTERNALSYM SOCK_DGRAM}
  sock_dgram      = 2;               { datagram socket }
  {$EXTERNALSYM SOCK_RAW}
  sock_raw        = 3;               { raw-protocol interface }
  {$EXTERNALSYM SOCK_RDM}
  sock_rdm        = 4;               { reliably-delivered message }
  {$EXTERNALSYM SOCK_SEQPACKET}
  sock_seqpacket  = 5;               { sequenced packet stream }

// option flags per-socket.
  {$EXTERNALSYM SO_DEBUG}
  so_debug            = $0001;            // turn on debugging info recording
  {$EXTERNALSYM SO_ACCEPTCONN}
  so_acceptconn       = $0002;            // socket has had listen()
  {$EXTERNALSYM SO_REUSEADDR}
  so_reuseaddr        = $0004;            // allow local address reuse
  {$EXTERNALSYM SO_KEEPALIVE}
  so_keepalive        = $0008;            // keep connections alive
  {$EXTERNALSYM SO_DONTROUTE}
  so_dontroute        = $0010;            // just use interface addresses
  {$EXTERNALSYM SO_BROADCAST}
  so_broadcast        = $0020;            // permit sending of broadcast msgs
  {$EXTERNALSYM SO_USELOOPBACK}
  so_useloopback      = $0040;            // bypass hardware when possible
  {$EXTERNALSYM SO_LINGER}
  so_linger           = $0080;            // linger on close if data present
  {$EXTERNALSYM SO_OOBINLINE}
  so_oobinline        = $0100;            // leave received OOB data in line

  {$EXTERNALSYM SO_DONTLINGER}
  so_dontlinger       = not SO_LINGER;
  {$EXTERNALSYM SO_EXCLUSIVEADDRUSE}
  so_exclusiveaddruse = not SO_REUSEADDR; // disallow local address reuse

// additional options.

  {$EXTERNALSYM SO_SNDBUF}
  so_sndbuf           = $1001;      // send buffer size
  {$EXTERNALSYM SO_RCVBUF}
  so_rcvbuf           = $1002;      // receive buffer size
  {$EXTERNALSYM SO_SNDLOWAT}
  so_sndlowat         = $1003;      // send low-water mark
  {$EXTERNALSYM SO_RCVLOWAT}
  so_rcvlowat         = $1004;      // receive low-water mark
  {$EXTERNALSYM SO_SNDTIMEO}
  so_sndtimeo         = $1005;      // send timeout
  {$EXTERNALSYM SO_RCVTIMEO}
  so_rcvtimeo         = $1006;      // receive timeout
  {$EXTERNALSYM SO_ERROR}
  so_error            = $1007;      // get error status and clear
  {$EXTERNALSYM SO_TYPE}
  so_type             = $1008;      // get socket type

// options for connect and disconnect data and options.
// used only by non-tcp/ip transports such as DECNet, OSI TP4, etc.
  {$EXTERNALSYM SO_CONNDATA}
  so_conndata         = $7000;
  {$EXTERNALSYM SO_CONNOPT}
  so_connopt          = $7001;
  {$EXTERNALSYM SO_DISCDATA}
  so_discdata         = $7002;
  {$EXTERNALSYM SO_DISCOPT}
  so_discopt          = $7003;
  {$EXTERNALSYM SO_CONNDATALEN}
  so_conndatalen      = $7004;
  {$EXTERNALSYM SO_CONNOPTLEN}
  so_connoptlen       = $7005;
  {$EXTERNALSYM SO_DISCDATALEN}
  so_discdatalen      = $7006;
  {$EXTERNALSYM SO_DISCOPTLEN}
  so_discoptlen       = $7007;

// option for opening sockets for synchronous access.
  {$EXTERNALSYM SO_OPENTYPE}
  so_opentype         = $7008;
  {$EXTERNALSYM SO_SYNCHRONOUS_ALERT}
  so_synchronous_alert    = $10;
  {$EXTERNALSYM SO_SYNCHRONOUS_NONALERT}
  so_synchronous_nonalert = $20;

// other nt-specific options.
  {$EXTERNALSYM SO_MAXDG}
  so_maxdg                 = $7009;
  {$EXTERNALSYM SO_MAXPATHDG}
  so_maxpathdg             = $700A;
  {$EXTERNALSYM SO_UPDATE_ACCEPT_CONTEXT}
  so_update_accept_context = $700B;
  {$EXTERNALSYM SO_CONNECT_TIME}
  so_connect_time          = $700C;

// tcp options.
  {$EXTERNALSYM TCP_NODELAY}
  tcp_nodelay              = $0001;
  {$EXTERNALSYM TCP_BSDURGENT}
  tcp_bsdurgent            = $7000;

// winsock 2 extension -- new options
  {$EXTERNALSYM SO_GROUP_ID}
  so_group_id              = $2001; // ID of a socket group
  {$EXTERNALSYM SO_GROUP_PRIORITY}
  so_group_priority        = $2002; // the relative priority within a group
  {$EXTERNALSYM SO_MAX_MSG_SIZE}
  so_max_msg_size          = $2003; // maximum message size
  {$EXTERNALSYM SO_PROTOCOL_INFOA}
  SO_Protocol_InfoA        = $2004; // WSAPROTOCOL_INFOA structure
  {$EXTERNALSYM SO_PROTOCOL_INFOW}
  SO_Protocol_InfoW        = $2005; // WSAPROTOCOL_INFOW structure
  {$EXTERNALSYM SO_PROTOCOL_INFO}
{$IFDEF UNICODE}
  SO_Protocol_Info         = SO_Protocol_InfoW;
{$ELSE}
  SO_Protocol_Info         = SO_Protocol_InfoA;
{$ENDIF}
  {$EXTERNALSYM PVD_CONFIG}
  pvd_config               = $3001; // configuration info for service provider
  {$EXTERNALSYM SO_CONDITIONAL_ACCEPT}
  so_conditional_accept    = $3002; // enable true conditional accept:
                                    // connection is not ack-ed to the
                                    // other side until conditional
                                    // function returns CF_ACCEPT

// Address families.
  {$EXTERNALSYM AF_UNSPEC}
  af_unspec       = 0;               // unspecified
  {$EXTERNALSYM AF_UNIX}
  af_unix         = 1;               // local to host (pipes, portals)
  {$EXTERNALSYM AF_INET}
  af_inet         = 2;               // internetwork: UDP, TCP, etc.
  {$EXTERNALSYM AF_IMPLINK}
  af_implink      = 3;               // arpanet imp addresses
  {$EXTERNALSYM AF_PUP}
  af_pup          = 4;               // pup protocols: e.g. BSP
  {$EXTERNALSYM AF_CHAOS}
  af_chaos        = 5;               // mit CHAOS protocols
  {$EXTERNALSYM AF_IPX}
  af_ipx          = 6;               // ipx and SPX
  {$EXTERNALSYM AF_NS}
  af_ns           = af_ipx;          // xerOX NS protocols
  {$EXTERNALSYM AF_ISO}
  af_iso          = 7;               // iso protocols
  {$EXTERNALSYM AF_OSI}
  af_osi          = af_iso;          // osi is ISO
  {$EXTERNALSYM AF_ECMA}
  af_ecma         = 8;               // european computer manufacturers
  {$EXTERNALSYM AF_DATAKIT}
  af_datakit      = 9;               // datakit protocols
  {$EXTERNALSYM AF_CCITT}
  af_ccitt        = 10;              // cciTT protocols, X.25 etc
  {$EXTERNALSYM AF_SNA}
  af_sna          = 11;              // ibm SNA
  {$EXTERNALSYM AF_DECNET}
  af_decnet       = 12;              // decnet
  {$EXTERNALSYM AF_DLI}
  af_dli          = 13;              // direct data link interface
  {$EXTERNALSYM AF_LAT}
  af_lat          = 14;              // lat
  {$EXTERNALSYM AF_HYLINK}
  af_hylink       = 15;              // nsc Hyperchannel
  {$EXTERNALSYM AF_APPLETALK}
  af_appletalk    = 16;              // appleTalk
  {$EXTERNALSYM AF_NETBIOS}
  af_netbios      = 17;              // netBios-style addresses
  {$EXTERNALSYM AF_VOICEVIEW}
  af_voiceview    = 18;              // voiceView
  {$EXTERNALSYM AF_FIREFOX}
  af_firefox      = 19;              // fireFox
  {$EXTERNALSYM AF_UNKNOWN1}
  af_unknown1     = 20;              // somebody is using this!
  {$EXTERNALSYM AF_BAN}
  af_ban          = 21;              // banyan
  {$EXTERNALSYM AF_ATM}
  af_atm          = 22;              // native ATM Services
  {$EXTERNALSYM AF_INET6}
  af_inet6        = 23;              // internetwork Version 6
  {$EXTERNALSYM AF_CLUSTER}
  af_cluster      = 24;              // microsoft Wolfpack
  {$EXTERNALSYM AF_12844}
  af_12844        = 25;              // ieeE 1284.4 WG AF
  {$EXTERNALSYM AF_IRDA}
  af_irda         = 26;              // irdA
  {$EXTERNALSYM AF_NETDES}
  af_netdes       = 28;              // network Designers OSI & gateway enabled protocols
  {$EXTERNALSYM AF_TCNPROCESS}
  af_tcnprocess   = 29;
  {$EXTERNALSYM AF_TCNMESSAGE}
  af_tcnmessage   = 30;
  {$EXTERNALSYM AF_ICLFXBM}
  af_iclfxbm      = 31;

  {$EXTERNALSYM AF_MAX}
  af_max          = 32;


// protocol families, same as address families for now.

  {$EXTERNALSYM PF_UNSPEC}
  pf_unspec       = af_unspec;
  {$EXTERNALSYM PF_UNIX}
  pf_unix         = af_unix;
  {$EXTERNALSYM PF_INET}
  pf_inet         = af_inet;
  pf_implink      = af_implink;
  pf_pup          = af_pup;
  pf_chaos        = af_chaos;
  pf_ns           = af_ns;
  pf_ipx          = af_ipx;
  pf_iso          = af_iso;
  pf_osi          = af_osi;
  pf_ecma         = af_ecma;
  pf_datakit      = af_datakit;
  pf_ccitt        = af_ccitt;
  pf_sna          = af_sna;
  pf_decnet       = af_decnet;
  pf_dli          = af_dli;
  pf_lat          = af_lat;
  pf_hylink       = af_hylink;
  pf_appletalk    = af_appletalk;
  pf_voiceview    = af_voiceview;
  pf_firefox      = af_firefox;
  pf_unknown1     = af_unknown1;
  pf_ban          = af_ban;
  pf_atm          = af_atm;
  pf_inet6        = af_inet6;

  pf_max          = af_max;

type

  SunB = packed record
    s_b1, s_b2, s_b3, s_b4: u_char;
  end;

  SunW = packed record
    s_w1, s_w2: u_short;
  end;

  TInAddr = packed record
    case integer of
      0: (S_un_b: SunB);
      1: (S_un_w: SunW);
      2: (S_addr: u_long);
  end;
  PInAddr = ^TInAddr;

  // Structure used by kernel to store most addresses.

  TSockAddrIn = packed record
    case Integer of
      0: (sin_family : u_short;
          sin_port   : u_short;
          sin_addr   : TInAddr;
          sin_zero   : array[0..7] of Char);
      1: (sa_family  : u_short;
          sa_data    : array[0..13] of Char)
  end;
  PSockAddrIn = ^TSockAddrIn;
  TSockAddr   = TSockAddrIn;
  PSockAddr   = ^TSockAddr;
  LPSOCKADDR  = PSockAddr;
  SOCKADDR    = TSockAddr;
  SOCKADDR_IN = TSockAddrIn;

  // Structure used by kernel to pass protocol information in raw sockets.
  PSockProto = ^TSockProto;
  TSockProto = packed record
    sp_family   : u_short;
    sp_protocol : u_short;
  end;

// Structure used for manipulating linger option.
  PLinger = ^TLinger;
  TLinger = packed record
    l_onoff: u_short;
    l_linger: u_short;
  end;

const
  inaddr_any       = $00000000;
  inaddr_loopback  = $7F000001;
  inaddr_broadcast = $FFFFFFFF;
  inaddr_none      = $FFFFFFFF;

  addr_any         = INADDR_ANY;

  sol_socket       = $ffff;          // options for socket level

  msg_oob          = $1;             // process out-of-band data
  msg_peek         = $2;             // peek at incoming message
  msg_dontroute    = $4;             // send without using routing tables

  msg_partial      = $8000;          // partial send or recv for message xport

// WinSock 2 extension -- new flags for WSASend(), WSASendTo(), WSARecv() and WSARecvFrom()
  msg_interrupt    = $10;    // send/recv in the interrupt context
  msg_maxiovlen    = 16;


// Define constant based on rfc883, used by gethostbyxxxx() calls.

  maxgethoststruct = 1024;

// Maximum queue length specifiable by listen.
  somaxconn        = $7fffffff;

// WinSock 2 extension -- bit values and indices for FD_XXX network events
  fd_read_bit                     = 0;
  fd_write_bit                    = 1;
  fd_oob_bit                      = 2;
  fd_accept_bit                   = 3;
  fd_connect_bit                  = 4;
  fd_close_bit                    = 5;
  fd_qos_bit                      = 6;
  fd_group_qos_bit                = 7;
  fd_routing_interface_change_bit = 8;
  fd_address_list_change_bit      = 9;

  fd_max_events    = 10;

  fd_read       = (1 shl fd_read_bit);
  fd_write      = (1 shl fd_write_bit);
  fd_oob        = (1 shl fd_oob_bit);
  fd_accept     = (1 shl fd_accept_bit);
  fd_connect    = (1 shl fd_connect_bit);
  fd_close      = (1 shl fd_close_bit);
  fd_qos        = (1 shl fd_qos_bit);
  fd_group_qos  = (1 shl fd_group_qos_bit);
  fd_routing_interface_change = (1 shl fd_routing_interface_change_bit);
  fd_address_list_change      = (1 shl fd_address_list_change_bit);

  fd_all_events = (1 shl fd_max_events) - 1;

// All Windows Sockets error constants are biased by WSABASEERR from the "normal"

  wsabaseerr              = 10000;

// Windows Sockets definitions of regular Microsoft C error constants

  wsaeintr                = wsabaseerr+  4;
  wsaebadf                = wsabaseerr+  9;
  wsaeacces               = wsabaseerr+ 13;
  wsaefault               = wsabaseerr+ 14;
  wsaeinval               = wsabaseerr+ 22;
  wsaemfile               = wsabaseerr+ 24;

// Windows Sockets definitions of regular Berkeley error constants

  wsaewouldblock          = wsabaseerr+ 35;
  wsaeinprogress          = wsabaseerr+ 36;
  wsaealready             = wsabaseerr+ 37;
  wsaenotsock             = wsabaseerr+ 38;
  wsaedestaddrreq         = wsabaseerr+ 39;
  wsaemsgsize             = wsabaseerr+ 40;
  wsaeprototype           = wsabaseerr+ 41;
  wsaenoprotoopt          = wsabaseerr+ 42;
  wsaeprotonosupport      = wsabaseerr+ 43;
  wsaesocktnosupport      = wsabaseerr+ 44;
  wsaeopnotsupp           = wsabaseerr+ 45;
  wsaepfnosupport         = wsabaseerr+ 46;
  wsaeafnosupport         = wsabaseerr+ 47;
  wsaeaddrinuse           = wsabaseerr+ 48;
  wsaeaddrnotavail        = wsabaseerr+ 49;
  wsaenetdown             = wsabaseerr+ 50;
  wsaenetunreach          = wsabaseerr+ 51;
  wsaenetreset            = wsabaseerr+ 52;
  wsaeconnaborted         = wsabaseerr+ 53;
  wsaeconnreset           = wsabaseerr+ 54;
  wsaenobufs              = wsabaseerr+ 55;
  wsaeisconn              = wsabaseerr+ 56;
  wsaenotconn             = wsabaseerr+ 57;
  wsaeshutdown            = wsabaseerr+ 58;
  wsaetoomanyrefs         = wsabaseerr+ 59;
  wsaetimedout            = wsabaseerr+ 60;
  wsaeconnrefused         = wsabaseerr+ 61;
  wsaeloop                = wsabaseerr+ 62;
  wsaenametoolong         = wsabaseerr+ 63;
  wsaehostdown            = wsabaseerr+ 64;
  wsaehostunreach         = wsabaseerr+ 65;
  wsaenotempty            = wsabaseerr+ 66;
  wsaeproclim             = wsabaseerr+ 67;
  wsaeusers               = wsabaseerr+ 68;
  wsaedquot               = wsabaseerr+ 69;
  wsaestale               = wsabaseerr+ 70;
  wsaeremote              = wsabaseerr+ 71;

// Extended Windows Sockets error constant definitions

  wsasysnotready          = wsabaseerr+ 91;
  wsavernotsupported      = wsabaseerr+ 92;
  wsanotinitialised       = wsabaseerr+ 93;
  wsaediscon              = wsabaseerr+101;
  wsaenomore              = wsabaseerr+102;
  wsaecancelled           = wsabaseerr+103;
  wsaeinvalidproctable    = wsabaseerr+104;
  wsaeinvalidprovider     = wsabaseerr+105;
  wsaeproviderfailedinit  = wsabaseerr+106;
  wsasyscallfailure       = wsabaseerr+107;
  wsaservice_not_found    = wsabaseerr+108;
  wsatype_not_found       = wsabaseerr+109;
  wsa_e_no_more           = wsabaseerr+110;
  wsa_e_cancelled         = wsabaseerr+111;
  wsaerefused             = wsabaseerr+112;


{ Error return codes from gethostbyname() and gethostbyaddr()
  (when using the resolver). Note that these errors are
  retrieved via WSAGetLastError() and must therefore follow
  the rules for avoiding clashes with error numbers from
  specific implementations or language run-time systems.
  For this reason the codes are based at WSABASEERR+1001.
  Note also that [WSA]NO_ADDRESS is defined only for
  compatibility purposes. }

// Authoritative Answer: Host not found
  wsahost_not_found        = wsabaseerr+1001;
  host_not_found           = wsahost_not_found;

// Non-Authoritative: Host not found, or SERVERFAIL
  wsatry_again             = wsabaseerr+1002;
  try_again                = wsatry_again;

// Non recoverable errors, FORMERR, REFUSED, NOTIMP
  wsano_recovery           = wsabaseerr+1003;
  no_recovery              = wsano_recovery;

// Valid name, no data record of requested type
  wsano_data               = wsabaseerr+1004;
  no_data                  = wsano_data;

// no address, look for MX record
  wsano_address            = wsano_data;
  no_address               = wsano_address;

// Define QOS related error return codes

  wsa_qos_receivers          = wsabaseerr+1005; // at least one reserve has arrived
  wsa_qos_senders            = wsabaseerr+1006; // at least one path has arrived
  wsa_qos_no_senders         = wsabaseerr+1007; // there are no senders
  wsa_qos_no_receivers       = wsabaseerr+1008; // there are no receivers
  wsa_qos_request_confirmed  = wsabaseerr+1009; // reserve has been confirmed
  wsa_qos_admission_failure  = wsabaseerr+1010; // error due to lack of resources
  wsa_qos_policy_failure     = wsabaseerr+1011; // rejected for administrative reasons - bad credentials
  wsa_qos_bad_style          = wsabaseerr+1012; // unknown or conflicting style
  wsa_qos_bad_object         = wsabaseerr+1013; // problem with some part of the filterspec or providerspecific buffer in general
  wsa_qos_traffic_ctrl_error = wsabaseerr+1014; // problem with some part of the flowspec
  wsa_qos_generic_error      = wsabaseerr+1015; // general error
  wsa_qos_eservicetype       = wsabaseerr+1016; // invalid service type in flowspec
  wsa_qos_eflowspec          = wsabaseerr+1017; // invalid flowspec
  wsa_qos_eprovspecbuf       = wsabaseerr+1018; // invalid provider specific buffer
  wsa_qos_efilterstyle       = wsabaseerr+1019; // invalid filter style
  wsa_qos_efiltertype        = wsabaseerr+1020; // invalid filter type
  wsa_qos_efiltercount       = wsabaseerr+1021; // incorrect number of filters
  wsa_qos_eobjlength         = wsabaseerr+1022; // invalid object length
  wsa_qos_eflowcount         = wsabaseerr+1023; // incorrect number of flows
  wsa_qos_eunkownpsobj       = wsabaseerr+1024; // unknown object in provider specific buffer
  wsa_qos_epolicyobj         = wsabaseerr+1025; // invalid policy object in provider specific buffer
  wsa_qos_eflowdesc          = wsabaseerr+1026; // invalid flow descriptor in the list
  wsa_qos_epsflowspec        = wsabaseerr+1027; // inconsistent flow spec in provider specific buffer
  wsa_qos_epsfilterspec      = wsabaseerr+1028; // invalid filter spec in provider specific buffer
  wsa_qos_esdmodeobj         = wsabaseerr+1029; // invalid shape discard mode object in provider specific buffer
  wsa_qos_eshaperateobj      = wsabaseerr+1030; // invalid shaping rate object in provider specific buffer
  wsa_qos_reserved_petype    = wsabaseerr+1031; // reserved policy element in provider specific buffer


{ WinSock 2 extension -- new error codes and type definition }
  wsa_io_pending          = error_io_pending;
  wsa_io_incomplete       = error_io_incomplete;
  wsa_invalid_handle      = error_invalid_handle;
  wsa_invalid_parameter   = error_invalid_parameter;
  wsa_not_enough_memory   = error_not_enough_memory;
  wsa_operation_aborted   = error_operation_aborted;
  {$IFDEF CIL}
  wsa_invalid_event       = wsaevent(0);
  {$ELSE}
  wsa_invalid_event       = wsaevent(nil);
  {$ENDIF}
  wsa_maximum_wait_events = maximum_wait_objects;
  wsa_wait_failed         = $ffffffff;
  wsa_wait_event_0        = wait_object_0;
  wsa_wait_io_completion  = wait_io_completion;
  wsa_wait_timeout        = wait_timeout;
  wsa_infinite            = infinite;

{ Windows Sockets errors redefined as regular Berkeley error constants.
  These are commented out in Windows NT to avoid conflicts with errno.h.
  Use the WSA constants instead. }

  ewouldblock        =  wsaewouldblock;
  einprogress        =  wsaeinprogress;
  ealready           =  wsaealready;
  enotsock           =  wsaenotsock;
  edestaddrreq       =  wsaedestaddrreq;
  emsgsize           =  wsaemsgsize;
  eprototype         =  wsaeprototype;
  enoprotoopt        =  wsaenoprotoopt;
  eprotonosupport    =  wsaeprotonosupport;
  esocktnosupport    =  wsaesocktnosupport;
  eopnotsupp         =  wsaeopnotsupp;
  epfnosupport       =  wsaepfnosupport;
  eafnosupport       =  wsaeafnosupport;
  eaddrinuse         =  wsaeaddrinuse;
  eaddrnotavail      =  wsaeaddrnotavail;
  enetdown           =  wsaenetdown;
  enetunreach        =  wsaenetunreach;
  enetreset          =  wsaenetreset;
  econnaborted       =  wsaeconnaborted;
  econnreset         =  wsaeconnreset;
  enobufs            =  wsaenobufs;
  eisconn            =  wsaeisconn;
  enotconn           =  wsaenotconn;
  eshutdown          =  wsaeshutdown;
  etoomanyrefs       =  wsaetoomanyrefs;
  etimedout          =  wsaetimedout;
  econnrefused       =  wsaeconnrefused;
  eloop              =  wsaeloop;
  enametoolong       =  wsaenametoolong;
  ehostdown          =  wsaehostdown;
  ehostunreach       =  wsaehostunreach;
  enotempty          =  wsaenotempty;
  eproclim           =  wsaeproclim;
  eusers             =  wsaeusers;
  edquot             =  wsaedquot;
  estale             =  wsaestale;
  eremote            =  wsaeremote;


  wsadescription_len     =   256;
  wsasys_status_len      =   128;

type
  PWSAData = ^TWSAData;
  TWSAData = packed record
    wVersion       : Word;
    wHighVersion   : Word;
    szDescription  : Array[0..wsadescription_len] of Char;
    szSystemStatus : Array[0..wsasys_status_len] of Char;
    iMaxSockets    : Word;
    iMaxUdpDg      : Word;
    lpVendorInfo   : PChar;
  end;

{ wsaoverlapped = Record
    Internal: LongInt;
    InternalHigh: LongInt;
    Offset: LongInt;
    OffsetHigh: LongInt;
    hEvent: wsaevent;
  end;}
  {$EXTERNALSYM WSAOVERLAPPED}
  wsaoverlapped   = TOverlapped;
  {$EXTERNALSYM TWSAOverlapped }
  TWSAOverlapped  = WSAOverlapped;
  {$EXTERNALSYM PWSAOverlapped  }
  PWSAOverlapped  = ^WSAOverlapped;
  {$EXTERNALSYM LPWSAOVERLAPPED}
  LPwsaoverlapped = PWSAOverlapped;

{ WinSock 2 extension -- WSABUF and QOS struct, include qos.h }
{ to pull in FLOWSPEC and related definitions }


  {$EXTERNALSYM WSABUF}
  WSABUF = packed record
    len: U_LONG;  { the length of the buffer }
    buf: PChar; { the pointer to the buffer }
  end {WSABUF};
  {$EXTERNALSYM TWSABUF }
  TWSABUF =  WSABUF;
  {$EXTERNALSYM PWSABUF }
  PWSABUF = ^WSABUF;
  {$EXTERNALSYM LPWSABUF}
  LPWSABUF = PWSABUF;

  TServiceType = LongInt;

  TFlowSpec = packed record
    TokenRate,               // In Bytes/sec
    TokenBucketSize,         // In Bytes
    PeakBandwidth,           // In Bytes/sec
    Latency,                 // In microseconds
    DelayVariation : LongInt;// In microseconds
    ServiceType : TServiceType;
    MaxSduSize, MinimumPolicedSize : LongInt;// In Bytes
  end;
  PFlowSpec = ^TFLOWSPEC;

  QOS = packed record
    SendingFlowspec: TFlowSpec; { the flow spec for data sending }
    ReceivingFlowspec: TFlowSpec; { the flow spec for data receiving }
    ProviderSpecific: WSABUF; { additional provider specific stuff }
  end;
  TQualityOfService = QOS;
  PQOS = ^QOS;
  LPQOS = PQOS;

const
  servicetype_notraffic             =  $00000000;  // No data in this direction
  servicetype_besteffort            =  $00000001;  // Best Effort
  servicetype_controlledload        =  $00000002;  // Controlled Load
  servicetype_guaranteed            =  $00000003;  // Guaranteed
  servicetype_network_unavailable   =  $00000004;  // Used to notify change to user
  servicetype_general_information   =  $00000005;  // corresponds to "General Parameters" defined by IntServ
  servicetype_nochange              =  $00000006;  // used to indicate that the flow spec contains no change from any previous one
// to turn on immediate traffic control, OR this flag with the ServiceType field in teh FLOWSPEC
  service_immediate_traffic_control =  $80000000;

//  WinSock 2 extension -- manifest constants for return values of the condition function
  cf_accept = $0000;
  cf_reject = $0001;
  cf_defer  = $0002;

//  WinSock 2 extension -- manifest constants for shutdown()
  sd_receive = $00;
  sd_send    = $01;
  sd_both    = $02;

//  WinSock 2 extension -- data type and manifest constants for socket groups
  sg_unconstrained_group = $01;
  sg_constrained_group   = $02;

type
  GROUP = DWORD;

//  WinSock 2 extension -- data type for WSAEnumNetworkEvents()
  TWSANetworkEvents = record
    lNetworkEvents: LongInt;
    iErrorCode: Array[0..fd_max_eventS-1] of Integer;
  end;
  PWSANetworkEvents = ^TWSANetworkEvents;
  LPWSANetworkEvents = PWSANetworkEvents;

//TransmitFile types used for the TransmitFile API function in WinNT/2000/XP

  {$NODEFINE PTransmitFileBuffers}
  PTransmitFileBuffers = ^TTransmitFileBuffers;
  {$NODEFINE _TRANSMIT_FILE_BUFFERS}
  _TRANSMIT_FILE_BUFFERS = record
      Head: Pointer;
      HeadLength: DWORD;
      Tail: Pointer;
      TailLength: DWORD;
  end;
  {$NODEFINE TTransmitFileBuffers}
  TTransmitFileBuffers = _TRANSMIT_FILE_BUFFERS;
  {$NODEFINE TRANSMIT_FILE_BUFFERS}
  TRANSMIT_FILE_BUFFERS = _TRANSMIT_FILE_BUFFERS;

const
  {$NODEFINE TP_ELEMENT_MEMORY}
  TP_ELEMENT_MEMORY   = 1;
  {$NODEFINE TP_ELEMENT_FILE}
  TP_ELEMENT_FILE     = 2;
  {$NODEFINE TP_ELEMENT_EOP}
  TP_ELEMENT_EOP      = 4;

  {$NODEFINE TP_DISCONNECT}
  TP_DISCONNECT       = TF_DISCONNECT;
  {$NODEFINE TP_REUSE_SOCKET}
  TP_REUSE_SOCKET     = TF_REUSE_SOCKET;
  {$NODEFINE TP_USE_DEFAULT_WORKER}
  TP_USE_DEFAULT_WORKER = TF_USE_DEFAULT_WORKER;
  {$NODEFINE TP_USE_SYSTEM_THREAD}
   TP_USE_SYSTEM_THREAD = TF_USE_SYSTEM_THREAD;
  {$NODEFINE TP_USE_KERNEL_APC}
  TP_USE_KERNEL_APC     = TF_USE_KERNEL_APC;

type
  {$NODEFINE PTransmitPacketsElement}
  PTransmitPacketsElement = ^TTransmitPacketsElement;
  {$NODEFINE _TRANSMIT_PACKETS_ELEMENT}
  _TRANSMIT_PACKETS_ELEMENT = record
    dwElFlags: ULONG;
    cLength: ULONG;
    case Integer of
      1: (nFileOffset: TLargeInteger;
          hFile: THandle);
      2: (pBuffer: Pointer);
  end;
  {$NODEFINE TTransmitPacketsElement}
  TTransmitPacketsElement = _TRANSMIT_PACKETS_ELEMENT;
  {$NODEFINE LPTransmitPacketsElement}
  LPTransmitPacketsElement = PTransmitPacketsElement;
  {$NODEFINE TRANSMIT_PACKETS_ELEMENT}
  TRANSMIT_PACKETS_ELEMENT = _TRANSMIT_PACKETS_ELEMENT;
  {$EXTERNALSYM PTRANSMIT_PACKETS_ELEMENT}
  PTRANSMIT_PACKETS_ELEMENT = ^_TRANSMIT_PACKETS_ELEMENT;
  {$EXTERNALSYM LPTRANSMIT_PACKETS_ELEMENT}
  LPTRANSMIT_PACKETS_ELEMENT = ^_TRANSMIT_PACKETS_ELEMENT;

//  WinSock 2 extension -- WSAPROTOCOL_INFO structure

{$ifndef ver130}
{  TGUID = packed record
    D1: LongInt;
    D2: Word;
    D3: Word;
    D4: Array[0..7] of Byte;
  end; }
  {$NODEFINE PGUID}
  PGUID = ^TGUID;
{$endif}
  {$EXTERNALSYM LPGUID}
  LPGUID = PGUID;

//  WinSock 2 extension -- WSAPROTOCOL_INFO manifest constants
const
  {$EXTERNALSYM MAX_PROTOCOL_CHAIN}
  max_protocol_chain = 7;
{$EXTERNALSYM BASE_PROTOCOL}
    base_protocol      = 1;
  {$EXTERNALSYM LAYERED_PROTOCOL}
  layered_protocol   = 0;
  {$EXTERNALSYM WSAPROTOCOL_LEN}
  wsaprotocol_len    = 255;

type
  {$EXTERNALSYM TWSAProtocolChain}
  TWSAProtocolChain = record
    ChainLen: Integer;  // the length of the chain,
    // length = 0 means layered protocol,
    // length = 1 means base protocol,
    // length > 1 means protocol chain
    ChainEntries: Array[0..MAX_PROTOCOL_CHAIN-1] of LongInt; // a list of dwCatalogEntryIds
  end;

type
  {$EXTERNALSYM TWSAProtocol_InfoA}
  TWSAProtocol_InfoA = record
    dwServiceFlags1: LongInt;
    dwServiceFlags2: LongInt;
    dwServiceFlags3: LongInt;
    dwServiceFlags4: LongInt;
    dwProviderFlags: LongInt;
    ProviderId: TGUID;
    dwCatalogEntryId: LongInt;
    ProtocolChain: TWSAProtocolChain;
    iVersion: Integer;
    iAddressFamily: Integer;
    iMaxSockAddr: Integer;
    iMinSockAddr: Integer;
    iSocketType: Integer;
    iProtocol: Integer;
    iProtocolMaxOffset: Integer;
    iNetworkByteOrder: Integer;
    iSecurityScheme: Integer;
    dwMessageSize: LongInt;
    dwProviderReserved: LongInt;
    szProtocol: Array[0..WSAPROTOCOL_LEN+1-1] of Char;
  end {TWSAProtocol_InfoA};
  {$NODEFINE PWSAProtocol_InfoA}
  PWSAProtocol_InfoA = ^TWSAProtocol_InfoA;
  {$EXTERNALSYM LPWSAProtocol_InfoA}
  LPWSAProtocol_InfoA = PWSAProtocol_InfoA;

  {$EXTERNALSYM TWSAProtocol_InfoW}
  TWSAProtocol_InfoW = record
    dwServiceFlags1: LongInt;
    dwServiceFlags2: LongInt;
    dwServiceFlags3: LongInt;
    dwServiceFlags4: LongInt;
    dwProviderFlags: LongInt;
    ProviderId: TGUID;
    dwCatalogEntryId: LongInt;
    ProtocolChain: TWSAProtocolChain;
    iVersion: Integer;
    iAddressFamily: Integer;
    iMaxSockAddr: Integer;
    iMinSockAddr: Integer;
    iSocketType: Integer;
    iProtocol: Integer;
    iProtocolMaxOffset: Integer;
    iNetworkByteOrder: Integer;
    iSecurityScheme: Integer;
    dwMessageSize: LongInt;
    dwProviderReserved: LongInt;
    szProtocol: Array[0..WSAPROTOCOL_LEN+1-1] of WideChar;
  end {TWSAProtocol_InfoW};
  {$NODEFINE PWSAProtocol_InfoW}
  PWSAProtocol_InfoW = ^TWSAProtocol_InfoW;
  {$EXTERNALSYM LPWSAProtocol_InfoW}
  LPWSAProtocol_InfoW = PWSAProtocol_InfoW;


{$IFDEF UNICODE}
  {$EXTERNALSYM WSAProtocol_Info}
  WSAProtocol_Info = TWSAProtocol_InfoW;
  {$NODEFINE TWSAProtocol_Info}
  TWSAProtocol_Info = TWSAProtocol_InfoW;
  {$NODEFINE PWSAProtocol_Info}
  PWSAProtocol_Info = PWSAProtocol_InfoW;
  {$NODEFINE LPWSAProtocol_Info}
  LPWSAProtocol_Info = PWSAProtocol_InfoW;
{$ELSE}
  {$NODEFINE WSAProtocol_Info}
  WSAProtocol_Info = TWSAProtocol_InfoA;
  {$NODEFINE TWSAProtocol_Info}
  TWSAProtocol_Info = TWSAProtocol_InfoA;
  {$NODEFINE PWSAProtocol_Info}
  PWSAProtocol_Info = PWSAProtocol_InfoA;
  {$NODEFINE LPWSAProtocol_Info}
  LPWSAProtocol_Info = PWSAProtocol_InfoA;
{$ENDIF}

const
//  flag bit definitions for dwProviderFlags
  pfl_multiple_proto_entries   = $00000001;
  pfl_recommended_proto_entry  = $00000002;
  pfl_hidden                   = $00000004;
  pfl_matches_protocol_zero    = $00000008;

//  flag bit definitions for dwServiceFlags1
  xp1_connectionless           = $00000001;
  xp1_guaranteed_delivery      = $00000002;
  xp1_guaranteed_order         = $00000004;
  xp1_message_oriented         = $00000008;
  xp1_pseudo_stream            = $00000010;
  xp1_graceful_close           = $00000020;
  xp1_expedited_data           = $00000040;
  xp1_connect_data             = $00000080;
  xp1_disconnect_data          = $00000100;
  xp1_support_broadcast        = $00000200;
  xp1_support_multipoint       = $00000400;
  xp1_multipoint_control_plane = $00000800;
  xp1_multipoint_data_plane    = $00001000;
  xp1_qos_supported            = $00002000;
  xp1_interrupt                = $00004000;
  xp1_uni_send                 = $00008000;
  xp1_uni_recv                 = $00010000;
  xp1_ifs_handles              = $00020000;
  xp1_partial_message          = $00040000;

  bigendian    = $0000;
  littleendian = $0001;

  security_protocol_none = $0000;

//  WinSock 2 extension -- manifest constants for WSAJoinLeaf()
  jl_sender_only   = $01;
  jl_receiver_only = $02;
  jl_both          = $04;

//  WinSock 2 extension -- manifest constants for WSASocket()
  wsa_flag_overlapped        = $01;
  wsa_flag_multipoint_c_root = $02;
  wsa_flag_multipoint_c_leaf = $04;
  wsa_flag_multipoint_d_root = $08;
  wsa_flag_multipoint_d_leaf = $10;

//  WinSock 2 extension -- manifest constants for WSAIoctl()
  ioc_unix      = $00000000;
  ioc_ws2       = $08000000;
  ioc_protocol  = $10000000;
  ioc_vendor    = $18000000;

  sio_associate_handle                =  1 or ioc_ws2 or ioc_in;
  sio_enable_circular_queueing        =  2 or ioc_ws2 or ioc_void;
  sio_find_route                      =  3 or ioc_ws2 or ioc_out;
  sio_flush                           =  4 or ioc_ws2 or ioc_void;
  sio_get_broadcast_address           =  5 or ioc_ws2 or ioc_out;
  sio_get_extension_function_pointer  =  6 or ioc_ws2 or ioc_inout;
  sio_get_qos                         =  7 or ioc_ws2 or ioc_inout;
  sio_get_group_qos                   =  8 or ioc_ws2 or ioc_inout;
  sio_multipoint_loopback             =  9 or ioc_ws2 or ioc_in;
  sio_multicast_scope                 = 10 or ioc_ws2 or ioc_in;
  sio_set_qos                         = 11 or ioc_ws2 or ioc_in;
  sio_set_group_qos                   = 12 or ioc_ws2 or ioc_in;
  sio_translate_handle                = 13 or ioc_ws2 or ioc_inout;
  sio_routing_interface_query         = 20 or ioc_ws2 or ioc_inout;
  sio_routing_interface_change        = 21 or ioc_ws2 or ioc_in;
  sio_address_list_query              = 22 or ioc_ws2 or ioc_out; // see below SOCKET_ADDRESS_LIST
  sio_address_list_change             = 23 or ioc_ws2 or ioc_void;
  sio_query_target_pnp_handle         = 24 or ioc_ws2 or ioc_out;
  sio_address_list_sort               = 25 or ioc_ws2 or ioc_inout;

//  WinSock 2 extension -- manifest constants for SIO_TRANSLATE_HANDLE ioctl
  th_netdev = $00000001;
  th_tapi   = $00000002;

type


//  Manifest constants and type definitions related to name resolution and
//  registration (RNR) API

  {$IFDEF CIL}
  TBLOB = packed record
    cbSize : U_LONG;
    pBlobData : ^BYTE;
  end;
  PBLOB = ^TBLOB;
  {$ELSE}
  TBLOB = packed record
    cbSize : U_LONG;
    pBlobData : PBYTE;
  end;
  PBLOB = ^TBLOB;
  {$ENDIF}

//  Service Install Flags

const
  service_multiple = $00000001;

// & name spaces
  ns_all         =  0;

  ns_sap         =  1;
  ns_nds         =  2;
  ns_peer_browse =  3;

  ns_tcpip_local = 10;
  ns_tcpip_hosts = 11;
  ns_dns         = 12;
  ns_netbt       = 13;
  ns_wins        = 14;

  ns_nbp         = 20;

  ns_ms          = 30;
  ns_stda        = 31;
  ns_ntds        = 32;

  ns_x500        = 40;
  ns_nis         = 41;
  ns_nisplus     = 42;

  ns_wrq         = 50;

  ns_netdes      = 60;

{ Resolution flags for WSAGetAddressByName().
  Note these are also used by the 1.1 API GetAddressByName, so leave them around. }
  res_unused_1    = $00000001;
  res_flush_cache = $00000002;
  res_service     = $00000004;

{ Well known value names for Service Types }
  service_type_value_ipxporta              = 'IpxSocket';    {Do not Localize}
  service_type_value_sapida                = 'SapId';    {Do not Localize}
  service_type_value_tcpporta              = 'TcpPort';    {Do not Localize}
  service_type_value_udpporta              = 'UdpPort';    {Do not Localize}
  service_type_value_objectida             = 'ObjectId';    {Do not Localize}
  {$IFDEF CIL}
  service_type_value_ipxportw : WideString  = 'IpxSocket';    {Do not Localize}
  service_type_value_sapidw : WideString    = 'SapId';    {Do not Localize}
  service_type_value_tcpportw : WideString  = 'TcpPort';    {Do not Localize}
  service_type_value_udpportw : WideString  = 'UdpPort';    {Do not Localize}
  service_type_value_objectidw : WideString = 'ObjectId';    {Do not Localize}
  {$ELSE}
  service_type_value_ipxportw : PWideChar  = 'IpxSocket';    {Do not Localize}
  service_type_value_sapidw : PWideChar    = 'SapId';    {Do not Localize}
  service_type_value_tcpportw : PWideChar  = 'TcpPort';    {Do not Localize}
  service_type_value_udpportw : PWideChar  = 'UdpPort';    {Do not Localize}
  service_type_value_objectidw : PWideChar = 'ObjectId';    {Do not Localize}
  {$ENDIF}
  {service_type_value_sapid    = service_type_value_sapidw;}
  {service_type_value_tcpport  = service_type_value_tcpportw;}
  {service_type_value_udpport  = service_type_value_udpportw;}
  {service_type_value_objectid = service_type_value_objectidw;}


{$IFDEF UNICODE}
  service_type_value_sapid : PWideChar = 'SapId';         {Do not Localize}
  service_type_value_tcpport : PWideChar = 'TcpPort';     {Do not Localize}
  service_type_value_udpport : PWideChar = 'UdpPort';     {Do not Localize}
  service_type_value_objectid : PWideChar = 'ObjectId';   {Do not Localize}
{$ELSE}
  service_type_value_sapid    = service_type_value_sapida;
  service_type_value_tcpport  = service_type_value_tcpporta;
  service_type_value_udpport  = service_type_value_udpporta;
  service_type_value_objectid = service_type_value_objectida;
{$ENDIF}

// SockAddr Information
type
  {$EXTERNALSYM SOCKET_ADDRESS}
  SOCKET_ADDRESS = packed record
    lpSockaddr : PSockAddr;
    iSockaddrLength : Integer;
  end;
  {$EXTERNALSYM PSOCKET_ADDRESS }
  PSOCKET_ADDRESS = ^SOCKET_ADDRESS;

// CSAddr Information
  CSADDR_INFO = packed record
    LocalAddr, RemoteAddr  : SOCKET_ADDRESS;
    iSocketType, iProtocol : LongInt;
  end;
  PCSADDR_INFO = ^CSADDR_INFO;
  LPCSADDR_INFO = ^CSADDR_INFO;

// Address list returned via WSAIoctl( SIO_ADDRESS_LIST_QUERY )
  SOCKET_ADDRESS_LIST = packed record
    iAddressCount : Integer;
    Address       : Array [0..0] of SOCKET_ADDRESS;
  end;
  lpsocket_ADDRESS_LIST = ^SOCKET_ADDRESS_LIST;

// Address Family/Protocol Tuples
  AFProtocols = record
    iAddressFamily : Integer;
    iProtocol      : Integer;
  end;
  TAFProtocols = AFProtocols;
  PAFProtocols = ^TAFProtocols;


//  Client Query API Typedefs

// The comparators
  TWSAEComparator = (COMP_EQUAL {= 0}, COMP_NOTLESS );

  TWSAVersion = record
    dwVersion : DWORD;
    ecHow     : TWSAEComparator;
  end;
  PWSAVersion = ^TWSAVersion;

  TWSAQuerySetA = packed record
    dwSize                  : DWORD;
    lpszServiceInstanceName : PChar;
    lpServiceClassId        : PGUID;
    lpVersion               : PWSAVERSION;
    lpszComment             : PChar;
    dwNameSpace             : DWORD;
    lpNSProviderId          : PGUID;
    lpszContext             : PChar;
    dwNumberOfProtocols     : DWORD;
    lpafpProtocols          : PAFProtocols;
    lpszQueryString         : PChar;
    dwNumberOfCsAddrs       : DWORD;
    lpcsaBuffer             : PCSADDR_INFO;
    dwOutputFlags           : DWORD;
    lpBlob                  : PBLOB;
  end;
  PWSAQuerySetA = ^TWSAQuerySetA;
  LPWSAQuerySetA = PWSAQuerySetA;

  TWSAQuerySetW = packed record
    dwSize                  : DWORD;
    lpszServiceInstanceName : PWideChar;
    lpServiceClassId        : PGUID;
    lpVersion               : PWSAVERSION;
    lpszComment             : PWideChar;
    dwNameSpace             : DWORD;
    lpNSProviderId          : PGUID;
    lpszContext             : PWideChar;
    dwNumberOfProtocols     : DWORD;
    lpafpProtocols          : PAFProtocols;
    lpszQueryString         : PWideChar;
    dwNumberOfCsAddrs       : DWORD;
    lpcsaBuffer             : PCSADDR_INFO;
    dwOutputFlags           : DWORD;
    lpBlob                  : PBLOB;
  end;
  PWSAQuerySetW = ^TWSAQuerySetW;
  LPWSAQuerySetW = PWSAQuerySetW;

{$IFDEF UNICODE}
  TWSAQuerySet  = TWSAQuerySetA;
  PWSAQuerySet  = PWSAQuerySetW;
  LPWSAQuerySet = PWSAQuerySetW;
{$ELSE}
  TWSAQuerySet  = TWSAQuerySetA;
  PWSAQuerySet  = PWSAQuerySetA;
  LPWSAQuerySet = PWSAQuerySetA;
{$ENDIF}

const
  lup_deep                = $0001;
  lup_containers          = $0002;
  lup_nocontainers        = $0004;
  lup_nearest             = $0008;
  lup_return_name         = $0010;
  lup_return_type         = $0020;
  lup_return_version      = $0040;
  lup_return_comment      = $0080;
  lup_return_addr         = $0100;
  lup_return_blob         = $0200;
  lup_return_aliases      = $0400;
  lup_return_query_string = $0800;
  lup_return_all          = $0FF0;
  lup_res_service         = $8000;

  lup_flushcache          = $1000;
  lup_flushprevious       = $2000;

// Return flags
  result_is_alias = $0001;

// WSARecvMsg flags
  {$NODEFINE MSG_TRUNC}
  MSG_TRUNC     =  $0100;
  {$NODEFINE MSG_CTRUNC}
  MSG_CTRUNC    =  $0200;
  {$NODEFINE MSG_BCAST}
  MSG_BCAST     =  $0400;
  {$NODEFINE MSG_MCAST}
  MSG_MCAST     =  $0800;

type
// Service Address Registration and Deregistration Data Types.
  TWSAeSetServiceOp = ( RNRSERVICE_REGISTER{=0}, RNRSERVICE_DEREGISTER, RNRSERVICE_DELETE );

{ Service Installation/Removal Data Types. }
  TWSANSClassInfoA = packed record
    lpszName    : PChar;
    dwNameSpace : DWORD;
    dwValueType : DWORD;
    dwValueSize : DWORD;
    lpValue     : Pointer;
  end;
  PWSANSClassInfoA = ^TWSANSClassInfoA;

  TWSANSClassInfoW = packed record
    lpszName    : PWideChar;
    dwNameSpace : DWORD;
    dwValueType : DWORD;
    dwValueSize : DWORD;
    lpValue     : Pointer;
  end {TWSANSClassInfoW};
  PWSANSClassInfoW = ^TWSANSClassInfoW;

{$IFDEF UNICODE}
  WSANSClassInfo   = TWSANSClassInfoW;
  TWSANSClassInfo  = TWSANSClassInfoW;
  PWSANSClassInfo  = PWSANSClassInfoW;
  LPWSANSClassInfo = PWSANSClassInfoW;
{$ELSE}
  WSANSClassInfo   = TWSANSClassInfoA;
  TWSANSClassInfo  = TWSANSClassInfoA;
  PWSANSClassInfo  = PWSANSClassInfoA;
  LPWSANSClassInfo = PWSANSClassInfoA;
{$ENDIF // UNICODE}

  TWSAServiceClassInfoA = packed record
    lpServiceClassId     : PGUID;
    lpszServiceClassName : PChar;
    dwCount              : DWORD;
    lpClassInfos         : PWSANSClassInfoA;
  end;
  PWSAServiceClassInfoA  = ^TWSAServiceClassInfoA;
  LPWSAServiceClassInfoA = PWSAServiceClassInfoA;

  TWSAServiceClassInfoW = packed record
    lpServiceClassId     : PGUID;
    lpszServiceClassName : PWideChar;
    dwCount              : DWORD;
    lpClassInfos         : PWSANSClassInfoW;
  end;
  PWSAServiceClassInfoW  = ^TWSAServiceClassInfoW;
  LPWSAServiceClassInfoW = PWSAServiceClassInfoW;

{$IFDEF UNICODE}
  WSAServiceClassInfo   = TWSAServiceClassInfoW;
  TWSAServiceClassInfo  = TWSAServiceClassInfoW;
  PWSAServiceClassInfo  = PWSAServiceClassInfoW;
  LPWSAServiceClassInfo = PWSAServiceClassInfoW;
{$ELSE}
  WSAServiceClassInfo   = TWSAServiceClassInfoA;
  TWSAServiceClassInfo  = TWSAServiceClassInfoA;
  PWSAServiceClassInfo  = PWSAServiceClassInfoA;
  LPWSAServiceClassInfo = PWSAServiceClassInfoA;
{$ENDIF}

  TWSANameSpace_InfoA = packed record
    NSProviderId   : TGUID;
    dwNameSpace    : DWORD;
    fActive        : DWORD{Bool};
    dwVersion      : DWORD;
    lpszIdentifier : PChar;
  end;
  PWSANameSpace_InfoA = ^TWSANameSpace_InfoA;
  LPWSANameSpace_InfoA = PWSANameSpace_InfoA;

  TWSANameSpace_InfoW = packed record
    NSProviderId   : TGUID;
    dwNameSpace    : DWORD;
    fActive        : DWORD{Bool};
    dwVersion      : DWORD;
    lpszIdentifier : PWideChar;
  end {TWSANameSpace_InfoW};
  PWSANameSpace_InfoW = ^TWSANameSpace_InfoW;
  LPWSANameSpace_InfoW = PWSANameSpace_InfoW;

  {$EXTERNALSYM _WSAMSG}
  _WSAMSG = packed record
    name : LPSOCKADDR;  ///* Remote address */
    namelen : Integer; ///* Remote address length *
    lpBuffers : LPWSABUF;  //  /* Data buffer array */
    dwBufferCount : DWord; //  /* Number of elements in the array */
    Control : WSABUF;  //  /* Control buffer */
    dwFlags : DWord; //  /* Flags */
  end;
  TWSAMSG = _WSAMSG;
  {$EXTERNALSYM PWSAMSG}
  PWSAMSG = ^TWSAMSG;
  {$EXTERNALSYM LPWSAMSG}
  LPWSAMSG = PWSAMSG;

  {$EXTERNALSYM _WSACMSGHDR}
  _WSACMSGHDR = packed record
     cmsg_len : Cardinal;//SIZE_T;
     cmsg_level : Integer;
     cmsg_type : Integer;
  end;
  WSACMSGHDR = _WSACMSGHDR;
  TWSACMSGHDR = _WSACMSGHDR;
  {$EXTERNALSYM PWSACMSGHDR}
  PWSACMSGHDR = ^TWSACMSGHDR;
  {$EXTERNALSYM LPWSACMSGHDR}
  LPWSACMSGHDR = PWSACMSGHDR;

const
//from winnt.h
//For 64 bit, these values will have to change

  {$EXTERNALSYM MAX_NATURAL_ALIGNMENT}
  MAX_NATURAL_ALIGNMENT = sizeof(Cardinal);
  {$EXTERNALSYM MEMORY_ALLOCATION_ALIGNMENT}
  MEMORY_ALLOCATION_ALIGNMENT =8;

function TYPE_ALIGNMENT(const AInt : Cardinal): Cardinal;

//*
// * Alignment macros for header and data members of
// * the control buffer.
// */
{$EXTERNALSYM WSA_CMSGHDR_ALIGN}
function WSA_CMSGHDR_ALIGN(length : Cardinal) : Cardinal;

{$EXTERNALSYM WSA_CMSGDATA_ALIGN}
function WSA_CMSGDATA_ALIGN(length : Cardinal) : Cardinal;
//*
// *  WSA_CMSG_FIRSTHDR
// *
// *  Returns a pointer to the first ancillary data object,
// *  or a null pointer if there is no ancillary data in the
// *  control buffer of the WSAMSG structure.
// *
// *  LPCMSGHDR
// *  WSA_CMSG_FIRSTHDR (
// *      LPWSAMSG    msg
// *      );
// */
{$EXTERNALSYM WSA_CMSG_FIRSTHDR}
function WSA_CMSG_FIRSTHDR(msg : LPWSAMSG):LPWSACMSGHDR;
{/*
 *  WSA_CMSG_NXTHDR
 *
 *  Returns a pointer to the next ancillary data object,
 *  or a null if there are no more data objects.
 *
 *  LPCMSGHDR
 *  WSA_CMSG_NEXTHDR (
 *      LPWSAMSG        msg,
 *      LPWSACMSGHDR    cmsg
 *      );
 */  }
{$EXTERNALSYM WSA_CMSG_NXTHDR}
function WSA_CMSG_NXTHDR(msg : LPWSAMSG; cmsg : LPWSACMSGHDR) : LPWSACMSGHDR;
{/*
 *  WSA_CMSG_DATA
 *
 *  Returns a pointer to the first byte of data (what is referred
 *  to as the cmsg_data member though it is not defined in
 *  the structure).
 *
 *  u_char *
 *  WSA_CMSG_DATA (
 *      LPWSACMSGHDR   pcmsg
 *      );
 */               }

{$EXTERNALSYM WSA_CMSG_DATA}
function WSA_CMSG_DATA(cmsg : LPWSACMSGHDR) : Pointer;
{/*
 *  WSA_CMSG_SPACE
 *
 *  Returns total size of an ancillary data object given
 *  the amount of data. Used to allocate the correct amount
 *  of space.
 *
 *  SIZE_T
 *  WSA_CMSG_SPACE (
 *      SIZE_T length
 *      );
 */ }
{$EXTERNALSYM WSA_CMSG_SPACE}
function WSA_CMSG_SPACE(length : Cardinal) : Cardinal;
{
/*
 *  WSA_CMSG_LEN
 *
 *  Returns the value to store in cmsg_len given the amount of data.
 *
 *  SIZE_T
 *  WSA_CMSG_LEN (
 *      SIZE_T length
 *  );
 */  }
{$EXTERNALSYM WSA_CMSG_LEN}
function WSA_CMSG_LEN(length : Cardinal) : Cardinal;


type
{$IFDEF UNICODE}
  WSANameSpace_Info   = TWSANameSpace_InfoW;
  TWSANameSpace_Info  = TWSANameSpace_InfoW;
  PWSANameSpace_Info  = PWSANameSpace_InfoW;
  LPWSANameSpace_Info = PWSANameSpace_InfoW;
{$ELSE}
  WSANameSpace_Info   = TWSANameSpace_InfoA;
  TWSANameSpace_Info  = TWSANameSpace_InfoA;
  PWSANameSpace_Info  = PWSANameSpace_InfoA;
  LPWSANameSpace_Info = PWSANameSpace_InfoA;
{$ENDIF}

{ WinSock 2 extensions -- data types for the condition function in }
{ WSAAccept() and overlapped I/O completion routine. }
type
  {$EXTERNALSYM LPCONDITIONPROC}
  LPCONDITIONPROC = function (lpCallerId: LPWSABUF; lpCallerData : LPWSABUF; lpSQOS,lpGQOS : LPQOS; lpCalleeId,lpCalleeData : LPWSABUF;
    g : GROUP; dwCallbackData : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM LPwsaoverlapped_COMPLETION_ROUTINE}
  LPwsaoverlapped_COMPLETION_ROUTINE = procedure ( const dwError, cbTransferred : DWORD; const AOverlapped: Pointer; const dwFlags : DWORD ); stdcall;

  {$EXTERNALSYM WSAStartup}
function WSAStartup( const wVersionRequired: word; var WSData: TWSAData ): Integer; stdcall;

type
  {$EXTERNALSYM TWSAStartupProc}
  TWSAStartupProc = function ( const wVersionRequired: word; var WSData: TWSAData ): Integer; stdcall;
  {$EXTERNALSYM TWSACleanupProc}
  TWSACleanupProc = function : Integer; stdcall;
  {$IFDEF CIL}
  {$EXTERNALSYM TacceptProc}
  TacceptProc = function ( const s: TSocket; addr: PSockAddr; var addrlen: Integer ): TSocket; stdcall;
  {$EXTERNALSYM TrecvfromProc}
  TrecvfromProc = function ( const s: TSocket; var Buf; len, flags: Integer; from: PSockAddr; var fromlen: Integer ): Integer; stdcall;
  {$ELSE}
  {$EXTERNALSYM TacceptProc}
  TacceptProc = function ( const s: TSocket; addr: PSockAddr; addrlen: PInteger ): TSocket; stdcall;
  {$EXTERNALSYM TrecvfromProc}
  TrecvfromProc = function ( const s: TSocket; var Buf; len, flags: Integer; from: PSockAddr; fromlen: PInteger ): Integer; stdcall;
  {$ENDIF}
  {$EXTERNALSYM TbindProc}
  TbindProc = function ( const s: TSocket; const name: PSockAddr; const namelen: Integer ): Integer; stdcall;
  {$EXTERNALSYM TclosesocketProc}
  TclosesocketProc = function ( const s: TSocket ): Integer; stdcall;
  {$EXTERNALSYM TconnectProc}
  TconnectProc = function ( const s: TSocket; const name: PSockAddr; const namelen: Integer): Integer; stdcall;
  {$EXTERNALSYM TioctlsocketProc}
  TioctlsocketProc = function ( const s: TSocket; const cmd: DWORD; var arg: u_long ): Integer; stdcall;
  {$EXTERNALSYM TgetpeernameProc}
  TgetpeernameProc = function ( const s: TSocket; const name: PSockAddr; var namelen: Integer ): Integer; stdcall;
  {$EXTERNALSYM TgetsocknameProc}
  TgetsocknameProc = function ( const s: TSocket; const name: PSockAddr; var namelen: Integer ): Integer; stdcall;
  {$EXTERNALSYM TgetsockoptProc}
  TgetsockoptProc = function ( const s: TSocket; const level, optname: Integer; optval: PChar; var optlen: Integer ): Integer; stdcall;
  {$EXTERNALSYM ThtonlProc}
  ThtonlProc = function (hostlong: u_long): u_long; stdcall;
  {$EXTERNALSYM ThtonsProc}
  ThtonsProc = function (hostshort: u_short): u_short; stdcall;
  {$EXTERNALSYM Tinet_addrProc}
  Tinet_addrProc = function (cp: PChar): u_long; stdcall;
  {$EXTERNALSYM Tinet_ntoaProc}
  Tinet_ntoaProc = function (inaddr: TInAddr): PChar; stdcall;
  {$EXTERNALSYM TlistenProc}
  TlistenProc = function ( const s: TSocket; backlog: Integer ): Integer; stdcall;
  {$EXTERNALSYM TntohlProc}
  TntohlProc = function (netlong: u_long): u_long; stdcall;
  {$EXTERNALSYM TntohsProc}
  TntohsProc = function (netshort: u_short): u_short; stdcall;
  {$EXTERNALSYM TrecvProc}
  TrecvProc = function ( const s: TSocket; var Buf; len, flags: Integer ): Integer; stdcall;
  {$EXTERNALSYM TselectProc}
  TselectProc = function (nfds: Integer; readfds, writefds, exceptfds: PFDSet; timeout: PTimeVal ): Integer; stdcall;
  {$EXTERNALSYM TsendProc}
  TsendProc = function ( const s: TSocket; const Buf; len, flags: Integer ): Integer; stdcall;
  {$EXTERNALSYM TsendtoProc}
  TsendtoProc = function ( const s: TSocket; const Buf; const len, flags: Integer; const addrto: PSockAddr; const tolen: Integer ): Integer; stdcall;
  {$EXTERNALSYM TsetsockoptProc}
  TsetsockoptProc = function ( const s: TSocket; const level, optname: Integer; optval: PChar; const optlen: Integer ): Integer; stdcall;
  {$EXTERNALSYM TshutdownProc}
  TshutdownProc = function ( const s: TSocket; const how: Integer ): Integer; stdcall;
  {$EXTERNALSYM TsocketProc}
  TsocketProc = function ( const af, istruct, protocol: Integer ): TSocket; stdcall;
  {$EXTERNALSYM TgethostbyaddrProc}
  TgethostbyaddrProc = function ( addr: Pointer; const len, addrtype: Integer ): PHostEnt; stdcall;
  {$EXTERNALSYM TgethostbynameProc}
  TgethostbynameProc = function ( name: PChar ): PHostEnt; stdcall;
  {$EXTERNALSYM TgethostnameProc}
  TgethostnameProc = function ( name: PChar; len: Integer ): Integer; stdcall;
  {$EXTERNALSYM TgetservbyportProc}
  TgetservbyportProc = function ( const port: Integer; const proto: PChar ): PServEnt; stdcall;
  {$EXTERNALSYM TgetservbynameProc}
  TgetservbynameProc = function ( const name, proto: PChar ): PServEnt; stdcall;
  {$EXTERNALSYM TgetprotobynumberProc}
  TgetprotobynumberProc = function ( const proto: Integer ): PProtoEnt; stdcall;
  {$EXTERNALSYM TgetprotobynameProc}
  TgetprotobynameProc = function ( const name: PChar ): PProtoEnt; stdcall;
  {$EXTERNALSYM TWSASetLastErrorProc}
  TWSASetLastErrorProc = procedure ( const iError: Integer ); stdcall;
  {$EXTERNALSYM TWSAGetLastErrorProc}
  TWSAGetLastErrorProc = function : Integer; stdcall;
  {$EXTERNALSYM TWSAIsBlockingProc}
  TWSAIsBlockingProc = function : BOOL; stdcall;
  {$EXTERNALSYM TWSAUnhookBlockingHookProc}
  TWSAUnhookBlockingHookProc = function : Integer; stdcall;
  {$EXTERNALSYM TWSASetBlockingHookProc}
  TWSASetBlockingHookProc = function ( lpBlockFunc: TFarProc ): TFarProc; stdcall;
  {$EXTERNALSYM TWSACancelBlockingCallProc}
  TWSACancelBlockingCallProc = function : Integer; stdcall;
  {$EXTERNALSYM TWSAAsyncGetServByNameProc}
  TWSAAsyncGetServByNameProc = function ( HWindow: HWND; wMsg: u_int; name, proto, buf: PChar; buflen: Integer ): THandle; stdcall;
  {$EXTERNALSYM TWSAAsyncGetServByPortProc}
  TWSAAsyncGetServByPortProc = function ( HWindow: HWND; wMsg, port: u_int; proto, buf: PChar; buflen: Integer ): THandle; stdcall;
  {$EXTERNALSYM TWSAAsyncGetProtoByNameProc}
  TWSAAsyncGetProtoByNameProc = function ( HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer ): THandle; stdcall;
  {$EXTERNALSYM TWSAAsyncGetProtoByNumberProc}
  TWSAAsyncGetProtoByNumberProc = function ( HWindow: HWND; wMsg: u_int; number: Integer; buf: PChar; buflen: Integer ): THandle; stdcall;
  {$EXTERNALSYM TWSAAsyncGetHostByNameProc}
  TWSAAsyncGetHostByNameProc = function ( HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer ): THandle; stdcall;
  {$EXTERNALSYM TWSAAsyncGetHostByAddrProc}
  TWSAAsyncGetHostByAddrProc = function ( HWindow: HWND; wMsg: u_int; addr: PChar; len, istruct: Integer; buf: PChar; buflen: Integer ): THandle; stdcall;
  {$EXTERNALSYM TWSACancelAsyncRequestProc}
  TWSACancelAsyncRequestProc = function ( hAsyncTaskHandle: THandle ): Integer; stdcall;
  {$EXTERNALSYM TWSAAsyncSelectProc}
  TWSAAsyncSelectProc = function ( const s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint ): Integer; stdcall;
  {$EXTERNALSYM T__WSAFDIsSetProc}
  T__WSAFDIsSetProc = function ( const s: TSocket; var FDSet: TFDSet ): Bool; stdcall;

// WinSock 2 API new function prototypes
  {$IFDEF CIL}
  {$EXTERNALSYM TWSAAcceptProc}
  TWSAAcceptProc = function ( const s : TSocket; addr : PSockAddr; var addrlen : Integer; lpfnCondition : LPCONDITIONPROC; const dwCallbackData : DWORD ): TSocket; stdcall;
  {$EXTERNALSYM TWSAEnumProtocolsAProc}
  TWSAEnumProtocolsAProc = function ( var lpiProtocols : Integer; lpProtocolBuffer : LPWSAProtocol_InfoA; var lpdwBufferLength : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM TWSAEnumProtocolsWProc}
  TWSAEnumProtocolsWProc = function ( var lpiProtocols : Integer; lpProtocolBuffer : LPWSAProtocol_InfoW; var lpdwBufferLength : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM TWSAEnumProtocolsProc}
  TWSAEnumProtocolsProc = function ( var lpiProtocols : Integer; lpProtocolBuffer : LPWSAProtocol_Info; var lpdwBufferLength : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM TWSAGetOverlappedResultProc}
  TWSAGetOverlappedResultProc = function ( const s : TSocket; var AOverlapped: TOverlapped; var lpcbTransfer : DWORD; fWait : BOOL; var lpdwFlags : DWORD ) : WordBool; stdcall;
  // IOCTL under CIL ???
//  TWSAIoctlProc = function ( const s : TSocket; dwIoControlCode : DWORD; lpvInBuffer : Pointer; cbInBuffer : DWORD; lpvOutBuffer : Pointer; cbOutBuffer : DWORD;
//    lpcbBytesReturned : LPDWORD; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ) : Integer; stdcall;
  {$EXTERNALSYM TWSARecvFromProc}
  TWSARecvFromProc = function ( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
    lpFrom : PSockAddr; var lpFromlen : Integer; var AOverlapped: Overlapped; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer; stdcall;
  {$EXTERNALSYM TTransmitFileProc}
  TTransmitFileProc = function (hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD;
    nNumberOfBytesPerSend: DWORD; var lpOverlapped: Overlapped;
    lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM TAcceptExProc}
  TAcceptExProc = function (sListenSocket, sAcceptSocket: TSocket;
    lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength,
    dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD;
    var lpOverlapped: Overlapped): BOOL; stdcall;
  {$ELSE}
  {$EXTERNALSYM TWSAAcceptProc}
  TWSAAcceptProc = function ( const s : TSocket; addr : PSockAddr; addrlen : PInteger; lpfnCondition : LPCONDITIONPROC; const dwCallbackData : DWORD ): TSocket; stdcall;
  {$EXTERNALSYM TWSAEnumProtocolsAProc}
  TWSAEnumProtocolsAProc = function ( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_InfoA; var lpdwBufferLength : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM TWSAEnumProtocolsWProc}
  TWSAEnumProtocolsWProc = function ( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_InfoW; var lpdwBufferLength : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM TWSAEnumProtocolsProc}
  TWSAEnumProtocolsProc = function ( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_Info; var lpdwBufferLength : DWORD ) : Integer; stdcall;
  {$EXTERNALSYM TWSAGetOverlappedResultProc}
  TWSAGetOverlappedResultProc = function ( const s : TSocket; AOverlapped: Pointer; lpcbTransfer : LPDWORD; fWait : BOOL; var lpdwFlags : DWORD ) : WordBool; stdcall;
  {$EXTERNALSYM TWSAIoctlProc}
  TWSAIoctlProc = function ( const s : TSocket; dwIoControlCode : DWORD; lpvInBuffer : Pointer; cbInBuffer : DWORD; lpvOutBuffer : Pointer; cbOutBuffer : DWORD;
    lpcbBytesReturned : LPDWORD; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ) : Integer; stdcall;
  {$EXTERNALSYM TWSARecvFromProc}
  TWSARecvFromProc = function ( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
    lpFrom : PSockAddr; lpFromlen : PInteger; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer; stdcall;
  {$EXTERNALSYM TTransmitFileProc}
  TTransmitFileProc = function (hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD;
    nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped;
    lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM TAcceptExProc}
  TAcceptExProc = function (sListenSocket, sAcceptSocket: TSocket;
    lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength,
    dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD;
    lpOverlapped: POverlapped): BOOL; stdcall;
  {$ENDIF}
  {$EXTERNALSYM TWSACloseEventProc}
  TWSACloseEventProc = function ( const hEvent : wsaevent ) : WordBool; stdcall;
  {$EXTERNALSYM TWSAConnectProc}
  TWSAConnectProc = function ( const s : TSocket; const name : PSockAddr; const namelen : Integer; lpCallerData,lpCalleeData : LPWSABUF; lpSQOS,lpGQOS : LPQOS ) : Integer; stdcall;
  {$EXTERNALSYM TWSACreateEventProc }
  TWSACreateEventProc  = function : wsaevent; stdcall;

  {$EXTERNALSYM TWSADuplicateSocketAProc}
  TWSADuplicateSocketAProc = function ( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_InfoA ) : Integer; stdcall;
  {$EXTERNALSYM TWSADuplicateSocketWProc}
  TWSADuplicateSocketWProc = function ( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_InfoW ) : Integer; stdcall;
  {$EXTERNALSYM TWSADuplicateSocketProc}
  TWSADuplicateSocketProc = function ( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_Info ) : Integer; stdcall;

  {$EXTERNALSYM TWSAEnumNetworkEventsProc}
  TWSAEnumNetworkEventsProc = function ( const s : TSocket; const hEventObject : wsaevent; lpNetworkEvents : LPWSANETWORKEVENTS ) :Integer; stdcall;

  {$EXTERNALSYM TWSAEventSelectProc}
  TWSAEventSelectProc = function ( const s : TSocket; const hEventObject : wsaevent; lNetworkEvents : LongInt ): Integer; stdcall;


  {$EXTERNALSYM TWSAGetQOSByNameProc}
  TWSAGetQOSByNameProc = function ( const s : TSocket; lpQOSName : LPWSABUF; lpQOS : LPQOS ): WordBool; stdcall;
  {$EXTERNALSYM TWSAHtonlProc}
  TWSAHtonlProc = function ( const s : TSocket; hostlong : u_long; var lpnetlong : DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSAHtonsProc}
  TWSAHtonsProc = function ( const s : TSocket; hostshort : u_short; var lpnetshort : WORD ): Integer; stdcall;


  {$EXTERNALSYM TWSAJoinLeafProc}
  TWSAJoinLeafProc = function ( const s : TSocket; name : PSockAddr; namelen : Integer; lpCallerData,lpCalleeData : LPWSABUF;
	  lpSQOS,lpGQOS : LPQOS; dwFlags : DWORD ) : TSocket; stdcall;

    {$EXTERNALSYM TWSANtohlProc}
  TWSANtohlProc = function ( const s : TSocket; netlong : u_long; var lphostlong : DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSANtohsProc}
  TWSANtohsProc = function ( const s : TSocket; netshort : u_short; var lphostshort : WORD ): Integer; stdcall;

  {$EXTERNALSYM TWSARecvProc}
  TWSARecvProc = function ( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
    AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer; stdcall;
  {$EXTERNALSYM TWSARecvDisconnectProc}
  TWSARecvDisconnectProc = function ( const s : TSocket; lpInboundDisconnectData : LPWSABUF ): Integer; stdcall;

  {$EXTERNALSYM TWSAResetEventProc}
  TWSAResetEventProc = function ( hEvent : wsaevent ): WordBool; stdcall;

  {$EXTERNALSYM TWSASendProc}
  TWSASendProc = function ( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesSent : DWORD; dwFlags : DWORD;
    AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer; stdcall;
  {$EXTERNALSYM TWSASendDisconnectProc}
  TWSASendDisconnectProc = function ( const s : TSocket; lpOutboundDisconnectData : LPWSABUF ): Integer; stdcall;
  {$EXTERNALSYM TWSASendToProc}
  TWSASendToProc = function ( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesSent : DWORD; dwFlags : DWORD;
    lpTo : PSockAddr; iTolen : Integer; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer; stdcall;

  {$EXTERNALSYM TWSASetEventProc}
  TWSASetEventProc = function ( hEvent : wsaevent ): WordBool; stdcall;

  {$EXTERNALSYM TWSASocketAProc}
  TWSASocketAProc = function ( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_InfoA; g : GROUP; dwFlags : DWORD ): TSocket; stdcall;
  {$EXTERNALSYM TWSASocketWProc}
  TWSASocketWProc = function ( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_InfoW; g : GROUP; dwFlags : DWORD ): TSocket; stdcall;
  {$EXTERNALSYM TWSASocketProc}
  TWSASocketProc = function ( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_Info; g : GROUP; dwFlags : DWORD ): TSocket; stdcall;

  {$EXTERNALSYM TWSAWaitForMultipleEventsProc}
  TWSAWaitForMultipleEventsProc = function ( cEvents : DWORD; lphEvents : Pwsaevent; fWaitAll : LongBool;
	  dwTimeout : DWORD; fAlertable : LongBool ): DWORD; stdcall;

  {$EXTERNALSYM TWSAAddressToStringAProc}
  TWSAAddressToStringAProc = function ( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_InfoA;
	  const lpszAddressString : PChar; var lpdwAddressStringLength : DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSAAddressToStringWProc}
  TWSAAddressToStringWProc = function ( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_InfoW;
	  const lpszAddressString : PWideChar; var lpdwAddressStringLength : DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSAAddressToStringProc}
  TWSAAddressToStringProc = function ( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_Info;
	  const lpszAddressString : PMBChar; var lpdwAddressStringLength : DWORD ): Integer; stdcall;

  {$EXTERNALSYM TWSAStringToAddressAProc}
  TWSAStringToAddressAProc = function ( const AddressString : PChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_InfoA;
	  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; stdcall;
  {$EXTERNALSYM TWSAStringToAddressWProc}
  TWSAStringToAddressWProc = function ( const AddressString : PWideChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_InfoW;
	  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; stdcall;
  {$EXTERNALSYM TWSAStringToAddressProc}
  TWSAStringToAddressProc = function ( const AddressString : PMBChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_Info;
	  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; stdcall;

// Registration and Name Resolution API functions
  {$EXTERNALSYM TWSALookupServiceBeginAProc}
  TWSALookupServiceBeginAProc = function ( var qsRestrictions : TWSAQuerySetA; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; stdcall;
  {$EXTERNALSYM TWSALookupServiceBeginWProc}
  TWSALookupServiceBeginWProc = function ( var qsRestrictions : TWSAQuerySetW; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; stdcall;
  {$EXTERNALSYM TWSALookupServiceBeginProc}
  TWSALookupServiceBeginProc = function ( var qsRestrictions : TWSAQuerySet; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; stdcall;

  {$EXTERNALSYM TWSALookupServiceNextAProc}
  TWSALookupServiceNextAProc = function ( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySetA ): Integer; stdcall;
  {$EXTERNALSYM TWSALookupServiceNextWProc}
  TWSALookupServiceNextWProc = function ( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySetW ): Integer; stdcall;
  {$EXTERNALSYM TWSALookupServiceNextProc}
  TWSALookupServiceNextProc = function ( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySet ): Integer; stdcall;

  {$EXTERNALSYM TWSALookupServiceEndProc}
  TWSALookupServiceEndProc = function ( const hLookup : THandle ): Integer; stdcall;

  {$EXTERNALSYM TWSAInstallServiceClassAProc}
  TWSAInstallServiceClassAProc = function ( const lpServiceClassInfo : LPWSAServiceClassInfoA ) : Integer; stdcall;
  {$EXTERNALSYM TWSAInstallServiceClassWProc}
  TWSAInstallServiceClassWProc = function ( const lpServiceClassInfo : LPWSAServiceClassInfoW ) : Integer; stdcall;
  {$EXTERNALSYM TWSAInstallServiceClassProc}
  TWSAInstallServiceClassProc = function ( const lpServiceClassInfo : LPWSAServiceClassInfo ) : Integer; stdcall;

  {$EXTERNALSYM TWSARemoveServiceClassProc}
  TWSARemoveServiceClassProc = function ( const lpServiceClassId : PGUID ) : Integer; stdcall;

  {$EXTERNALSYM TWSAGetServiceClassInfoAProc}
  TWSAGetServiceClassInfoAProc = function ( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
	  lpServiceClassInfo : LPWSAServiceClassInfoA ): Integer; stdcall;
  {$EXTERNALSYM TWSAGetServiceClassInfoWProc}
  TWSAGetServiceClassInfoWProc = function ( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
	  lpServiceClassInfo : LPWSAServiceClassInfoW ): Integer; stdcall;
  {$EXTERNALSYM TWSAGetServiceClassInfoProc}
  TWSAGetServiceClassInfoProc = function ( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
	  lpServiceClassInfo : LPWSAServiceClassInfo ): Integer; stdcall;

  {$EXTERNALSYM TWSAEnumNameSpaceProvidersAProc}
  TWSAEnumNameSpaceProvidersAProc = function ( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoA ): Integer; stdcall;
  {$EXTERNALSYM TWSAEnumNameSpaceProvidersWProc}
  TWSAEnumNameSpaceProvidersWProc = function ( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoW ): Integer; stdcall;
  {$EXTERNALSYM TWSAEnumNameSpaceProvidersProc}
  TWSAEnumNameSpaceProvidersProc = function ( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_Info ): Integer; stdcall;

  {$EXTERNALSYM TWSAGetServiceClassNameByClassIdAProc}
  TWSAGetServiceClassNameByClassIdAProc = function ( const lpServiceClassId: PGUID; lpszServiceClassName: PChar; var lpdwBufferLength: DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSAGetServiceClassNameByClassIdWProc}
  TWSAGetServiceClassNameByClassIdWProc = function ( const lpServiceClassId: PGUID; lpszServiceClassName: PWideChar; var lpdwBufferLength: DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSAGetServiceClassNameByClassIdProc}
  TWSAGetServiceClassNameByClassIdProc = function ( const lpServiceClassId: PGUID; lpszServiceClassName: PMBChar; var lpdwBufferLength: DWORD ): Integer; stdcall;

  {$EXTERNALSYM TWSASetServiceAProc}
  TWSASetServiceAProc = function ( const lpqsRegInfo: LPWSAQuerySetA; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSASetServiceWProc}
  TWSASetServiceWProc = function ( const lpqsRegInfo: LPWSAQuerySetW; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; stdcall;
  {$EXTERNALSYM TWSASetServiceProc}
  TWSASetServiceProc = function ( const lpqsRegInfo: LPWSAQuerySet; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; stdcall;

  {$EXTERNALSYM TWSAProviderConfigChangeProc}
  TWSAProviderConfigChangeProc = function ( var lpNotificationHandle : THandle; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ) : Integer; stdcall;
       //microsoft specific extension
  {$EXTERNALSYM TGetAcceptExSockaddrsProc}
  TGetAcceptExSockaddrsProc = procedure (lpOutputBuffer: Pointer;
    dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD;
    var LocalSockaddr: TSockAddr; var LocalSockaddrLength: Integer;
    var RemoteSockaddr: TSockAddr; var RemoteSockaddrLength: Integer); stdcall;
  {$EXTERNALSYM TWSARecvExProc}
  TWSARecvExProc = function (s: TSocket; var buf; len: Integer; var flags: Integer): Integer; stdcall;
  {$EXTERNALSYM TConnectExProc}
  TConnectExProc = function (const s : TSocket; const name: PSockAddr; const namelen: Integer; lpSendBuffer : Pointer; dwSendDataLength : DWord; var lpdwBytesSent : DWord; lpOverlapped : LPwsaoverlapped ) : BOOL; stdcall;
  {$EXTERNALSYM TDisconnectExProc}
  TDisconnectExProc = function (const hSocket : TSocket; AOverlapped: Pointer; const dwFlags : DWord; const dwReserved : DWord) : BOOL; stdcall;
  //XP and Server 2003 only
  {$EXTERNALSYM TWSARecvMsgProc}
  TWSARecvMsgProc = function ( const s : TSocket; lpMsg : PWSAMSG; var lpNumberOfBytesRecvd : DWORD; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer; stdcall;
  {$EXTERNALSYM TTransmitPacketsProc}
  TTransmitPacketsProc = function(hSocket: TSocket;
    lpPacketArray: LPTRANSMIT_PACKETS_ELEMENT;
    nElementCount: DWORD;
    nSendSize: DWORD;
    lpOverlapped: LPwsaoverlapped;
    dwFlags: DWORD): BOOL; stdcall;

{$IFDEF WS2_DLL_FUNC_VARS}
var
  {$NODEFINE WSACleanup}
  WSACleanup : TWSACleanupProc;
  {$NODEFINE accept}
  accept : TacceptProc;
  {$NODEFINE bind}
  bind : TbindProc;
  {$NODEFINE closesocket}
  closesocket : TclosesocketProc;
  {$NODEFINE connect}
  connect : TconnectProc;
  {$NODEFINE ioctlsocket}
  ioctlsocket : TioctlsocketProc;
  {$NODEFINE getpeername}
  getpeername : TgetpeernameProc;
  {$NODEFINE getsockname}
  getsockname : TgetsocknameProc;
  {$NODEFINE getsockopt}
  getsockopt : TgetsockoptProc;
  {$NODEFINE htonl}
  htonl : ThtonlProc;
  {$NODEFINE htons}
  htons : ThtonsProc;
  {$NODEFINE inet_addr}
  inet_addr : Tinet_addrProc;
  {$NODEFINE inet_ntoa}
  inet_ntoa : Tinet_ntoaProc;
  {$NODEFINE listen}
  listen : TlistenProc;
  {$NODEFINE ntohl}
  ntohl : TntohlProc;
  {$NODEFINE ntohs}
  ntohs : TntohsProc;
  {$NODEFINE recv}
  recv : TrecvProc;
  {$NODEFINE recvfrom}
  recvfrom : TrecvfromProc;
  {$NODEFINE select}
  select : TselectProc;
  {$NODEFINE send}
  send : TsendProc;
  {$NODEFINE sendto}
  sendto : TsendtoProc;
  {$NODEFINE setsockopt}
  setsockopt : TsetsockoptProc;
  {$NODEFINE shutdown}
  shutdown : TshutdownProc;
  {$NODEFINE socket}
  socket : TsocketProc;
  {$NODEFINE gethostbyaddr}
  gethostbyaddr : TgethostbyaddrProc;
  {$NODEFINE gethostbyname}
  gethostbyname : TgethostbynameProc;
  {$NODEFINE gethostname}
  gethostname : TgethostnameProc;
  {$NODEFINE getservbyport}
  getservbyport : TgetservbyportProc;
  {$NODEFINE getservbyname}
  getservbyname : TgetservbynameProc;
  {$NODEFINE getprotobynumber}
  getprotobynumber : TgetprotobynumberProc;
  {$NODEFINE getprotobyname}
  getprotobyname : TgetprotobynameProc;
  {$NODEFINE WSASetLastError}
  WSASetLastError : TWSASetLastErrorProc;
  {$NODEFINE WSAGetLastError}
  WSAGetLastError : TWSAGetLastErrorProc;
  {$NODEFINE WSAIsBlocking}
  WSAIsBlocking : TWSAIsBlockingProc;
  {$NODEFINE WSAUnhookBlockingHook}
  WSAUnhookBlockingHook : TWSAUnhookBlockingHookProc;
  {$NODEFINE WSASetBlockingHook}
  WSASetBlockingHook : TWSASetBlockingHookProc;
  {$NODEFINE WSACancelBlockingCall}
  WSACancelBlockingCall : TWSACancelBlockingCallProc;
  {$NODEFINE WSAAsyncGetServByName}
  WSAAsyncGetServByName : TWSAAsyncGetServByNameProc;
  {$NODEFINE WSAAsyncGetServByPort}
  WSAAsyncGetServByPort : TWSAAsyncGetServByPortProc;
  {$NODEFINE WSAAsyncGetProtoByName}
  WSAAsyncGetProtoByName : TWSAAsyncGetHostByNameProc;
  {$NODEFINE WSAAsyncGetProtoByNumber}
  WSAAsyncGetProtoByNumber : TWSAAsyncGetProtoByNumberProc;
  {$NODEFINE WSAAsyncGetHostByName}
  WSAAsyncGetHostByName : TWSAAsyncGetHostByNameProc;
  {$NODEFINE WSAAsyncGetHostByAddr}
  WSAAsyncGetHostByAddr : TWSAAsyncGetHostByAddrProc;
  {$NODEFINE WSACancelAsyncRequest}
  WSACancelAsyncRequest : TWSACancelAsyncRequestProc;
  {$NODEFINE WSAAsyncSelect}
  WSAAsyncSelect : TWSAAsyncSelectProc;
  {$NODEFINE __WSAFDIsSet}
  __WSAFDIsSet : T__WSAFDIsSetProc;
  {$NODEFINE WSAAccept}
  WSAAccept : TWSAAcceptProc;
  {$NODEFINE WSACloseEvent}
  WSACloseEvent : TWSACloseEventProc;
  {$NODEFINE WSAConnect}
  WSAConnect : TWSAConnectProc;
  {$NODEFINE WSACreateEvent}
  WSACreateEvent  : TWSACreateEventProc;
  {$NODEFINE WSADuplicateSocketA}
  WSADuplicateSocketA : TWSADuplicateSocketAProc;
  {$NODEFINE WSADuplicateSocketW}
  WSADuplicateSocketW : TWSADuplicateSocketWProc;
  {$NODEFINE WSADuplicateSocket}
  WSADuplicateSocket : TWSADuplicateSocketProc;
  {$NODEFINE WSAEnumNetworkEvents}
  WSAEnumNetworkEvents : TWSAEnumNetworkEventsProc;
  {$NODEFINE WSAEnumProtocolsA}
  WSAEnumProtocolsA : TWSAEnumProtocolsAProc;
  {$NODEFINE WSAEnumProtocolsW}
  WSAEnumProtocolsW : TWSAEnumProtocolsWProc;
  {$NODEFINE WSAEnumProtocols}
  WSAEnumProtocols : TWSAEnumProtocolsProc;
  {$NODEFINE WSAEventSelect}
  WSAEventSelect : TWSAEventSelectProc;
  {$NODEFINE WSAGetOverlappedResult}
  WSAGetOverlappedResult : TWSAGetOverlappedResultProc;
  {$NODEFINE WSAGetQOSByName}
  WSAGetQosByName : TWSAGetQOSByNameProc;
  {$NODEFINE WSAHtonl}
  WSAHtonl : TWSAHtonlProc;
  {$NODEFINE WSAHtons}
  WSAHtons : TWSAHtonsProc;
  {$IFDEF CIL}
  {$ELSE}
  {$NODEFINE WSAIoctl}
  WSAIoctl : TWSAIoctlProc;
  {$ENDIF}
  {$NODEFINE WSAJoinLeaf}
  WSAJoinLeaf : TWSAJoinLeafProc;
  {$NODEFINE WSANtohl}
  WSANtohl : TWSANtohlProc;
  {$NODEFINE WSANtohs}
  WSANtohs : TWSANtohsProc;
  {$NODEFINE WSARecv}
  WSARecv : TWSARecvProc;
  {$NODEFINE WSARecvDisconnect}
  WSARecvDisconnect : TWSARecvDisconnectProc;
  {$NODEFINE WSARecvFrom}
  WSARecvFrom : TWSARecvFromProc;
  {$NODEFINE WSAResetEvent}
  WSAResetEvent : TWSAResetEventProc;
  {$NODEFINE WSASend}
  WSASend : TWSASendProc;
  {$NODEFINE WSASendDisconnect}
  WSASendDisconnect : TWSASendDisconnectProc;
  {$NODEFINE WSASendTo}
  WSASendTo : TWSASendToProc;
  {$NODEFINE WSASetEvent}
  WSASetEvent : TWSASetEventProc;
  {$NODEFINE WSASocketA}
  WSASocketA : TWSASocketAProc;
  {$NODEFINE WSASocketW}
  WSASocketW : TWSASocketWProc;
  {$NODEFINE WSASocket}
  WSASocket : TWSASocketProc;
  {$NODEFINE WSAWaitForMultipleEvents}
  WSAWaitForMultipleEvents : TWSAWaitForMultipleEventsProc;
  {$NODEFINE WSAAddressToStringA}
  WSAAddressToStringA : TWSAAddressToStringAProc;
  {$NODEFINE WSAAddressToStringW}
  WSAAddressToStringW : TWSAAddressToStringWProc;
  {$NODEFINE WSAAddressToString}
  WSAAddressToString : TWSAAddressToStringProc;
  {$NODEFINE WSAStringToAddressA}
  WSAStringToAddressA : TWSAStringToAddressAProc;
  {$NODEFINE WSAStringToAddressW}
  WSAStringToAddressW : TWSAStringToAddressWProc;
  {$NODEFINE WSAStringToAddress}
  WSAStringToAddress : TWSAStringToAddressProc;
  {$NODEFINE WSALookupServiceBeginA}
  WSALookupServiceBeginA : TWSALookupServiceBeginAProc;
  {$NODEFINE WSALookupServiceBeginW}
  WSALookupServiceBeginW : TWSALookupServiceBeginWProc;
  {$NODEFINE WSALookupServiceBegin}
  WSALookupServiceBegin : TWSALookupServiceBeginProc;
  {$NODEFINE WSALookupServiceNextA}
  WSALookupServiceNextA : TWSALookupServiceNextAProc;
  {$NODEFINE WSALookupServiceNextW}
  WSALookupServiceNextW : TWSALookupServiceNextWProc;
  {$NODEFINE WSALookupServiceNext}
  WSALookupServiceNext : TWSALookupServiceNextProc;
  {$NODEFINE WSALookupServiceEnd}
  WSALookupServiceEnd : TWSALookupServiceEndProc;
  {$NODEFINE WSAInstallServiceClassA}
  WSAInstallServiceClassA : TWSAInstallServiceClassAProc;
  {$NODEFINE WSAInstallServiceClassW}
  WSAInstallServiceClassW : TWSAInstallServiceClassWProc;
  {$NODEFINE WSAInstallServiceClass}
  WSAInstallServiceClass : TWSAInstallServiceClassProc;
  {$NODEFINE WSARemoveServiceClass}
  WSARemoveServiceClass : TWSARemoveServiceClassProc;
  {$NODEFINE WSAGetServiceClassInfoA}
  WSAGetServiceClassInfoA : TWSAGetServiceClassInfoAProc;
  {$NODEFINE WSAGetServiceClassInfoW}
  WSAGetServiceClassInfoW : TWSAGetServiceClassInfoWProc;
  {$NODEFINE WSAGetServiceClassInfo}
  WSAGetServiceClassInfo : TWSAGetServiceClassInfoProc;
  {$NODEFINE WSAEnumNameSpaceProvidersA}
  WSAEnumNameSpaceProvidersA : TWSAEnumNameSpaceProvidersAProc;
  {$NODEFINE WSAEnumNameSpaceProvidersW}
  WSAEnumNameSpaceProvidersW : TWSAEnumNameSpaceProvidersWProc;
  {$NODEFINE WSAEnumNameSpaceProviders}
  WSAEnumNameSpaceProviders : TWSAEnumNameSpaceProvidersProc;
  {$NODEFINE WSAGetServiceClassNameByClassIdA}
  WSAGetServiceClassNameByClassIdA : TWSAGetServiceClassNameByClassIdAProc;
  {$NODEFINE WSAGetServiceClassNameByClassIdW}
  WSAGetServiceClassNameByClassIdW : TWSAGetServiceClassNameByClassIdWProc;
  {$NODEFINE WSAGetServiceClassNameByClassId}
  WSAGetServiceClassNameByClassId : TWSAGetServiceClassNameByClassIdProc;
  {$NODEFINE WSASetServiceA}
  WSASetServiceA : TWSASetServiceAProc;
  {$NODEFINE WSASetServiceW}
  WSASetServiceW : TWSASetServiceWProc;
  {$NODEFINE WSASetService}
  WSASetService : TWSASetServiceProc;
  {$NODEFINE WSAProviderConfigChange}
  WSAProviderConfigChange : TWSAProviderConfigChangeProc;

  {$NODEFINE TransmitFile}
  TransmitFile :  TTransmitFileProc;
//  {$NODEFINE AcceptEx}
//  AcceptEx : TAcceptExProc;           // not yet functional
//  {$NODEFINE GetAcceptExSockaddrs}
//  GetAcceptExSockaddrs : TGetAcceptExSockaddrsProc;  // not yet functional
//  {$NODEFINE WSARecvEx}
//  WSARecvEx  : TWSARecvExProc;        // not yet functional


  {$NODEFINE ConnectEx}
//  ConnectEx : TConnectExProc;
  {$NODEFINE DisconnectEx}
//  DisconnectEx : TDisconnectExProc;
  {$NODEFINE WSARecvMsg}
//  WSARecvMsg : TWSARecvMsgProc;
  {$NODEFINE TransmitPackets}
  // TransmitPackets = TTransmitPacketsProc;
{$ENDIF} // $IFDEF WS2_DLL_FUNC_VARS


{ Macros }
{$EXTERNALSYM WSAMakeSyncReply}
function WSAMakeSyncReply(Buflen, Error: Word): Longint;
{$EXTERNALSYM WSAMakeSelectReply}
function WSAMakeSelectReply(Event, Error: Word): Longint;
{$EXTERNALSYM WSAGetAsyncBuflen}
function WSAGetAsyncBuflen(Param: Longint): Word;
{$EXTERNALSYM WSAGetAsyncError}
function WSAGetAsyncError(Param: Longint): Word;
{$EXTERNALSYM WSAGetSelectEvent}
function WSAGetSelectEvent(Param: Longint): Word;
{$EXTERNALSYM WSAGetSelectError}
function WSAGetSelectError(Param: Longint): Word;

{$EXTERNALSYM fd_clr}
procedure fd_clr(Socket: TSocket; var FDSet: TFDSet);
{$EXTERNALSYM fd_isset}
function fd_isset(Socket: TSocket; var FDSet: TFDSet): Boolean;
{$EXTERNALSYM fd_set}
procedure fd_set(Socket: TSocket; var FDSet: TFDSet);
{$EXTERNALSYM fd_zero}
procedure fd_zero(var FDSet: TFDSet);

//=============================================================

{
	WS2TCPIP.H - WinSock2 Extension for TCP/IP protocols

	This file contains TCP/IP specific information for use
	by WinSock2 compatible applications.

	Copyright (c) 1995-1999  Microsoft Corporation

	To provide the backward compatibility, all the TCP/IP
	specific definitions that were included in the WINSOCK.H
	file are now included in WINSOCK2.H file. WS2TCPIP.H
	file includes only the definitions  introduced in the
	"WinSock 2 Protocol-Specific Annex" document.

	Rev 0.3	Nov 13, 1995
	Rev 0.4	Dec 15, 1996
}

// Argument structure for IP_ADD_MEMBERSHIP and IP_DROP_MEMBERSHIP
type
	ip_mreq = packed record
		imr_multiaddr : TInAddr; // IP multicast address of group
		imr_interface : TInAddr; // local IP address of interface
  end;

// TCP/IP specific Ioctl codes
const

  {$EXTERNALSYM SIO_GET_INTERFACE_LIST}
	SIO_GET_INTERFACE_LIST    = IOC_OUT or (SizeOf(Longint) shl 16) or (Ord('t') shl 8) or 127;    {Do not Localize}
// New IOCTL with address size independent address array
  {$EXTERNALSYM SIO_GET_INTERFACE_LIST_EX}
	SIO_GET_INTERFACE_LIST_EX = IOC_OUT or (SizeOf(Longint) shl 16) or (Ord('t') shl 8) or 126;    {Do not Localize}

// Options for use with [gs]etsockopt at the IP level.
  ip_options         =  1; // set/get IP options
  ip_hdrincl         =  2; // header is included with data
  ip_tos             =  3; // IP type of service and preced
  ip_ttl             =  4; // IP time to live
  ip_multicast_if    =  9; // set/get IP multicast i/f
  ip_multicast_ttl   = 10; // set/get IP multicast ttl
  ip_multicast_loop  = 11; // set/get IP multicast loopback
  ip_add_membership  = 12; // add an IP group membership
  ip_drop_membership = 13; // drop an IP group membership
  ip_dontfragment    = 14; // don't fragment IP datagrams    {Do not Localize}
  ip_add_source_membership = 15; // join IP group/source
  ip_drop_source_membership = 16; // leave IP group/source
  ip_block_source           = 17; // block IP group/source
  ip_unblock_source         = 18; // unblock IP group/source 
  ip_pktinfo                = 19; // receive packet information for ipv4
  ip_receive_broadcast      = 22; // allow/block broadcast reception

  ip_default_multicast_ttl   = 1;    // normally limit m'casts to 1 hop    {Do not Localize}
  ip_default_multicast_loop  = 1;    // normally hear sends if a member
  ip_max_memberships         = 20;   // per socket; must fit in one mbuf

// Option to use with [gs]etsockopt at the IPPROTO_UDP level
  {$EXTERNALSYM UDP_NOCHECKSUM}
	UDP_NOCHECKSUM     = 1;

// Option to use with [gs]etsockopt at the IPPROTO_TCP level
  {$EXTERNALSYM TCP_EXPEDITED_1122}
  TCP_EXPEDITED_1122 = $0002;


// IPv6 definitions
type
  {$EXTERNALSYM IN_ADDR6}
  {$HPPEMIT 'typedef IN6_ADDR IN_ADDR6;'}
	IN_ADDR6 = packed record
		s6_addr : array[0..15] of u_char; // IPv6 address
	end;
  {$EXTERNALSYM TIn6Addr  }
  TIn6Addr   = IN_ADDR6;
  {$EXTERNALSYM PIn6Addr   }
  PIn6Addr   = ^IN_ADDR6;
  {$EXTERNALSYM IN6_ADDR  }
  IN6_ADDR   = IN_ADDR6;
  {$EXTERNALSYM PIN6_ADDR}
  PIN6_ADDR  = ^IN_ADDR6;
  {$EXTERNALSYM LPIN6_ADDR}
  LPIN6_ADDR = ^IN_ADDR6;

// Old IPv6 socket address structure (retained for sockaddr_gen definition below)
  {$EXTERNALSYM sockaddr_in6_old}
	SOCKADDR_IN6_OLD = packed record
		sin6_family   : Smallint;         // AF_INET6
		sin6_port     : u_short;          // Transport level port number
		sin6_flowinfo : u_long;           // IPv6 flow information
		sin6_addr     : IN_ADDR6;         // IPv6 address
	end;

// IPv6 socket address structure, RFC 2553
  {$EXTERNALSYM SOCKADDR_IN6}
	SOCKADDR_IN6 = packed record
		sin6_family   : Smallint;         // AF_INET6
		sin6_port     : u_short;          // Transport level port number
		sin6_flowinfo : u_long;           // IPv6 flow information
		sin6_addr     : IN_ADDR6;         // IPv6 address
		sin6_scope_id : u_long;           // set of interfaces for a scope
	end;
  TSockAddrIn6   = SOCKADDR_IN6;
  PSockAddrIn6   = ^SOCKADDR_IN6;
  {$EXTERNALSYM PSOCKADDR_IN6}
  PSOCKADDR_IN6  = ^SOCKADDR_IN6;
  {$EXTERNALSYM LPSOCKADDR_IN6}
  LPSOCKADDR_IN6 = ^SOCKADDR_IN6;

////*
// * Portable socket structure (RFC 2553).
// */

///*
// * Desired design of maximum size and alignment.
// * These are implementation specific.
// */
const
  {$EXTERNALSYM _SS_MAXSIZE}
  _SS_MAXSIZE       = 128;   // Maximum size
  {$EXTERNALSYM _SS_ALIGNSIZE}
  _SS_ALIGNSIZE    = (sizeof(int64));  // Desired alignment.
///*
// * Definitions used for sockaddr_storage structure paddings design.
// */
  {$EXTERNALSYM _SS_PAD1SIZE}
  _SS_PAD1SIZE     = (_SS_ALIGNSIZE - sizeof (short));
  {$EXTERNALSYM _SS_PAD2SIZE}
 _SS_PAD2SIZE      = (_SS_MAXSIZE - (sizeof (short) + _SS_PAD1SIZE 
                                                    + _SS_ALIGNSIZE));



type
  sockaddr_storage = packed record
    ss_family : Word;               // Address family.
    __ss_pad1 : array[0.._SS_PAD1SIZE-1] of byte;  // 6 byte pad, this is to make
                                   // implementation specific pad up to
                                   // alignment field that follows explicit
                                   // in the data structure.
    __ss_align : Int64;            // Field to force desired structure.
    __ss_pad2 : array[00.._SS_PAD2SIZE-1] of byte;  // 112 byte pad to achieve desired size;
                                   // _SS_MAXSIZE value minus size of
                                   // ss_family, __ss_pad1, and
                                   // __ss_align fields is 112.
  end;
  Tsockaddr_storage = sockaddr_storage;
  Psockaddr_storage = ^Tsockaddr_storage;
  LPWsockaddr_storage = Psockaddr_storage;

  {$EXTERNALSYM sockaddr_gen}
	sockaddr_gen = packed record
		case Integer of
		1 : ( Address : SOCKADDR; );
		2 : ( AddressIn : SOCKADDR_IN; );
		3 : ( AddressIn6 : SOCKADDR_IN6_OLD; );
	end;
  //The ipv6_mreq structure provides multicast group information for IPv6 addresses.
  {$EXTERNALSYM ipv6_mreq}
  ipv6_mreq = packed record
    ipv6mr_multiaddr : TIn6Addr;  //IPv6 multicast addr
    ipv6mr_interface : Cardinal;  //interface index
  end;

// Structure to keep interface specific information
  {$EXTERNALSYM INTERFACE_INFO}
	INTERFACE_INFO = packed record
		iiFlags            : u_long;       // Interface flags
		iiAddress          : sockaddr_gen; // Interface address
		iiBroadcastAddress : sockaddr_gen; // Broadcast address
		iiNetmask          : sockaddr_gen; // Network mask
	end;
  {$EXTERNALSYM TINTERFACE_INFO }
	TINTERFACE_INFO  = INTERFACE_INFO;
  {$EXTERNALSYM LPINTERFACE_INFO }
	LPINTERFACE_INFO = ^INTERFACE_INFO;

// New structure that does not have dependency on the address size
  {$EXTERNALSYM INTERFACE_INFO_EX}
	INTERFACE_INFO_EX = packed record
		iiFlags            : u_long;         // Interface flags
		iiAddress          : SOCKET_ADDRESS; // Interface address
		iiBroadcastAddress : SOCKET_ADDRESS; // Broadcast address
		iiNetmask : SOCKET_ADDRESS;          // Network mask
	end;
  {$EXTERNALSYM TINTERFACE_INFO_EX }
	TINTERFACE_INFO_EX  = INTERFACE_INFO_EX;
  {$EXTERNALSYM LPINTERFACE_INFO_EX }
	LPINTERFACE_INFO_EX = ^INTERFACE_INFO_EX;

//RFC 3542 definitions
//IPv6 Extension Headers
   uint32_t = Cardinal;
   uint16_t = word;
   uint8_t = byte;
  //* Hop-by-Hop options header */
   ip6_hbh = packed record
       ip6h_nxt : Byte;        //* next header */
       ip6h_len : Byte;        //* length in units of 8 octets */
          //* followed by options /
    end;

   //* Destination options header */
   ip6_dest = packed record
     ip6d_nxt : Byte;        //* next header */
     ip6d_len : Byte;        //* length in units of 8 octets */
         //* followed by options */
   end;

   //* Routing header */
   ip6_rthdr = packed record
        ip6r_nxt : Byte;        //* next header */
        ip6r_len : Byte;        //* length in units of 8 octets */
        ip6r_type : Byte;       //* routing type */
        ip6r_segleft : Byte;    //* segments left */
          //* followed by routing type specific data */
   end;

   //* Type 0 Routing header */
   ip6_rthdr0 = packed record
     ip6r0_nxt      : Byte;   //* next header */
     ip6r0_len      : Byte;   //* length in units of 8 octets */
     ip6r0_type     : Byte;   //* always zero */
     ip6r0_segleft  : Byte;   //* segments left */
     ip6r0_reserved : Cardinal;  //* reserved field */
          //* followed by up to 127 struct in6_addr */
   end;

   //* Fragment header */
   ip6_frag = packed record
     ip6f_nxt : Byte;       //* next header */
     ip6f_reserved : Byte;  //* reserved field */
     ip6f_offlg : Word;     // *offset, reserved, and flag */
     ip6f_ident : Cardinal; //* identification */
   end;

const
  IP6F_OFF_MASK        = $f8ff;  //* mask out offset from ip6f_offlg */
  IP6F_RESERVED_MASK   = $0600;  //* reserved bits in ip6f_offlg */
  IP6F_MORE_FRAG       = $0100;  //* more-fragments flag */

//IPv6 options - RFC3542
type
   //* IPv6 options */
    ip6_opt = packed record
        ip6o_type : uint8_t;
        ip6o_len : uint8_t;
    end;

const
      IP6_ALERT_MLD     = $0000;
      IP6_ALERT_RSVP    = $0100;
      IP6_ALERT_AN      = $0200;





      //*
      // * The high-order 3 bits of the option type define the behavior
      // * when processing an unknown option and whether or not the option
      // * content changes in flight.
      // */

//Macro translation of IP6OPT_TYPE
function  IP6OPT_TYPE(const o : Byte) : byte;

const
      IP6OPT_TYPE_SKIP      = $00;
      IP6OPT_TYPE_DISCARD   = $40;
      IP6OPT_TYPE_FORCEICMP = $80;
      IP6OPT_TYPE_ICMP      = $c0;
      IP6OPT_MUTABLE        = $20;

      IP6OPT_PAD1           = $00; //* 00 0 00000 */
      IP6OPT_PADN           = $01; //* 00 0 00001 */

      IP6OPT_JUMBO          = $c2 ;//* 11 0 00010 */
      IP6OPT_NSAP_ADDR      = $c3;//* 11 0 00011 */
      IP6OPT_TUNNEL_LIMIT   = $04;//* 00 0 00100 */
      IP6OPT_ROUTER_ALERT   = $05;//* 00 0 00101 */

type
      //* Jumbo Payload Option */
     ip6_opt_jumbo = packed record
        ip6oj_type : uint8_t;
        ip6oj_len : uint8_t;

        ip6oj_jumbo_len: array[0..3] of uint8_t;
      end;
      
const
      IP6OPT_JUMBO_LEN   = 6;

type
      //* NSAP Address Option */
       ip6_opt_nsap = packed record
          ip6on_type : uint8_t;
          ip6on_len : uint8_t;
          ip6on_src_nsap_len : uint8_t;
          ip6on_dst_nsap_len : uint8_t;
          //* followed by source NSAP */
          //* followed by destination NSAP */
      end;

      //* Tunnel Limit Option */
      ip6_opt_tunnel = packed record
        ip6ot_type : uint8_t;
        ip6ot_len : uint8_t;
        ip6ot_encap_limit : uint8_t;
      end;

      //* Router Alert Option */
      ip6_opt_router = packed record
        ip6or_type : uint8_t;
        ip6or_len : uint8_t;
        ip6or_value: array[0..1] of uint8_t
      end;

type

  {$EXTERNALSYM ip6_hdrctl}
  ip6_hdrctl = packed record
    ip6_un1_flow:uint32_t; { 4 bits version, 8 bits TC, 20 bits flow-ID }
    ip6_un1_plen:uint16_t; { payload length }
    ip6_un1_nxt:uint8_t;  { next header }
    ip6_un1_hlim:uint8_t; { hop limit }
  end;


  {$EXTERNALSYM ip6_hdr}
  ip6_hdr = packed record
  case integer of
    0: (
      ip6_un1:ip6_hdrctl;
      ip6_src:in6_addr;   { source address }
      ip6_dst:in6_addr;   { destination address }
      );
    1: (
      ip6_un2_vfc:uint8_t; { 4 bits version, top 4 bits tclass }
      );
   end;

  {$EXTERNALSYM icmp6_hdr}
      icmp6_hdr = packed record
             icmp6_type : uint8_t;   //* type field */
            icmp6_code : uint8_t;   //* code field */
            icmp6_cksum : uint16_t;  //* checksum field */
        case Integer of
          1: (icmp6_un_data32 : uint32_t); //* type-specific field */
          2: (icmp6_un_data16 : array[0..1] of uint16_t); //* type-specific field */
          3: (icmp6_un_data8 : array[0..3] of uint8_t);  //* type-specific field */
      end;

const
//ICMPv6 Type and Code Values - rfc 3542
      ICMP6_DST_UNREACH            = 1;
      ICMP6_PACKET_TOO_BIG         = 2;
      ICMP6_TIME_EXCEEDED          = 3;
      ICMP6_PARAM_PROB             = 4;

      ICMP6_INFOMSG_MASK  = $80;    ///* all informational messages */

      ICMP6_ECHO_REQUEST        =  128;
      ICMP6_ECHO_REPLY         =   129;

      ICMP6_DST_UNREACH_NOROUTE    = 0; //* no route to destination */

      ICMP6_DST_UNREACH_ADMIN      = 1; //* communication with
                                        //  destination */
                                        //* admin. prohibited */
      ICMP6_DST_UNREACH_BEYONDSCOPE = 2; //* beyond scope of source address */
      ICMP6_DST_UNREACH_ADDR       = 3; //* address unreachable */
      ICMP6_DST_UNREACH_NOPORT     = 4; //* bad port */

      ICMP6_TIME_EXCEED_TRANSIT    = 0; //* Hop Limit == 0 in  transit */
      ICMP6_TIME_EXCEED_REASSEMBLY = 1; //* Reassembly time out */

      ICMP6_PARAMPROB_HEADER       = 0; //* erroneous header field */
      ICMP6_PARAMPROB_NEXTHEADER   = 1; //* unrecognized  Next Header */
      ICMP6_PARAMPROB_OPTION       = 2; //* unrecognized  IPv6 option */

//ICMPv6 Neighbor Discovery Definitions
      ND_ROUTER_SOLICIT          = 133;
      ND_ROUTER_ADVERT           = 134;
      ND_NEIGHBOR_SOLICIT        = 135;
      ND_NEIGHBOR_ADVERT         = 136;
      ND_REDIRECT                = 137;

type
  {$EXTERNALSYM Tnd_router_solicit}
  Tnd_router_solicit = packed record     //* router solicitation */
    nd_rs_hdr : icmp6_hdr;
          //* could be followed by options */
  end;
  {$EXTERNALSYM Tnd_router_advert}
  Tnd_router_advert = packed record
    nd_ra_hdr: icmp6_hdr;
    nd_ra_reachable: uint32_t;
    nd_ra_retransmit: uint32_t;
  end;

  {$EXTERNALSYM Tnd_neighbor_solicit}
  Tnd_neighbor_solicit = packed record   //* neighbor solicitation */
     nd_ns_hdr : icmp6_hdr;
      nd_ns_target : in6_addr; //* target address */
          //* could be followed by options */
  end;
  {$EXTERNALSYM Tnd_neighbor_advert}
  Tnd_neighbor_advert = packed record    //* neighbor advertisement */
    nd_na_hdr : icmp6_hdr;
    nd_na_target : in6_addr; //* target address */
          //* could be followed by options */
  end;

const
   ND_OPT_SOURCE_LINKADDR      = 1;
   ND_OPT_TARGET_LINKADDR      = 2;
   ND_OPT_PREFIX_INFORMATION   = 3;
   ND_OPT_REDIRECTED_HEADER    = 4;
   ND_OPT_MTU                  = 5;

type
  {$EXTERNALSYM nd_opt_prefix_info}
  nd_opt_prefix_info = packed record    //* prefix information */
      nd_opt_pi_type : uint8_t;
      nd_opt_pi_len : uint8_t;
      nd_opt_pi_prefix_len : uint8_t;
      nd_opt_pi_flags_reserved : uint8_t;
      nd_opt_pi_valid_time : uint32_t;
      nd_opt_pi_preferred_time : uint32_t;
      nd_opt_pi_reserved2 : uint32_t;
      nd_opt_pi_prefix : in6_addr;
   end;

const
  ND_OPT_PI_FLAG_ONLINK       = $80;
  ND_OPT_PI_FLAG_AUTO         = $40;

type
//sturc
  {$EXTERNALSYM nd_opt_rd_hdr}
  nd_opt_rd_hdr = packed record         //* redirected header */
     nd_opt_rh_type : uint8_t;
     nd_opt_rh_len : uint8_t;
     nd_opt_rh_reserved1 : uint16_t;
     nd_opt_rh_reserved2 : uint32_t;
     //* followed by IP header and data */
  end;

  {$EXTERNALSYM Tnd_opt_mtu}
   Tnd_opt_mtu = packed record            //* MTU option */
       nd_opt_mtu_type : uint8_t;
       nd_opt_mtu_len : uint8_t;
       nd_opt_mtu_reserved : uint16_t;
       nd_opt_mtu_mtu : uint32_t;
    end;

// Multicast Listener Discovery Definitions
const
  MLD_LISTENER_QUERY         = 130;
  MLD_LISTENER_REPORT        = 131;
  MLD_LISTENER_REDUCTION     = 132;
type
  {$EXTERNALSYM mld_hdr}
  mld_hdr = packed record
       mld_icmp6_hdr : icmp6_hdr;
       mld_addr      : in6_addr; //* multicast address */
  end;

const
  ND_NA_FLAG_ROUTER        = $00000080;
  ND_NA_FLAG_SOLICITED     = $00000040;
  ND_NA_FLAG_OVERRIDE      = $00000020;


type
  {$EXTERNALSYM Tnd_redirect}
  Tnd_redirect = packed record           //* redirect */
    nd_rd_hdr : icmp6_hdr;
    nd_rd_target : in6_addr; //* target address */
    nd_rd_dst : in6_addr;    //* destination address */
          //* could be followed by options */
  end;
  {$EXTERNALSYM nd_opt_hdr}
  nd_opt_hdr = packed record         //* Neighbor discovery option header */
      nd_opt_type : uint8_t;
          nd_opt_len : uint8_t;      //* in units of 8 octets */
          //* followed by option specific data */
  end;
      // Possible flags for the  iiFlags - bitmask

const
  {$EXTERNALSYM IFF_UP           }
	IFF_UP           = $00000001;  // Interface is up
  {$EXTERNALSYM IFF_BROADCAST    }
	IFF_BROADCAST    = $00000002;  // Broadcast is  supported
  {$EXTERNALSYM IFF_LOOPBACK     }
	IFF_LOOPBACK     = $00000004;  // this is loopback interface
  {$EXTERNALSYM IFF_POINTTOPOINT }
	IFF_POINTTOPOINT = $00000008;  // this is point-to-point interface
  {$EXTERNALSYM IFF_MULTICAST    }
	IFF_MULTICAST    = $00000010;  // multicast is supported

type
// structure for IP_PKTINFO option
//
  {$EXTERNALSYM in_pktinfo}
  in_pktinfo = packed record
     ipi_addr : TInAddr; // destination IPv4 address
     ipi_ifindex : Cardinal; // received interface index
  end;
  {$EXTERNALSYM Pin_pktinfo }
  Pin_pktinfo = ^in_pktinfo;
  {$EXTERNALSYM Tin_pktinfo}
  Tin_pktinfo = in_pktinfo;

// structure for IPV6_PKTINFO option
//
  {$EXTERNALSYM in6_pktinfo}
  in6_pktinfo = packed record
     ipi6_addr : TIn6Addr; // destination IPv6 address
     ipi6_ifindex : Cardinal; // received interface index
  end;
  {$EXTERNALSYM Pin6_pktinfo }
  Pin6_pktinfo = ^in6_pktinfo;
  {$EXTERNALSYM Tin6_pktinfo}
  Tin6_pktinfo = in6_pktinfo;
//=============================================================

{
	wsipx.h

	Microsoft Windows
	Copyright (C) Microsoft Corporation, 1992-1999.

	Windows Sockets include file for IPX/SPX.  This file contains all
	standardized IPX/SPX information.  Include this header file after
	winsock.h.

	To open an IPX socket, call socket() with an address family of
	AF_IPX, a socket type of SOCK_DGRAM, and protocol NSPROTO_IPX.
	Note that the protocol value must be specified, it cannot be 0.
	All IPX packets are sent with the packet type field of the IPX
	header set to 0.

	To open an SPX or SPXII socket, call socket() with an address
	family of AF_IPX, socket type of SOCK_SEQPACKET or SOCK_STREAM,
	and protocol of NSPROTO_SPX or NSPROTO_SPXII.  If SOCK_SEQPACKET
	is specified, then the end of message bit is respected, and
	recv() calls are not completed until a packet is received with
	the end of message bit set.  If SOCK_STREAM is specified, then
	the end of message bit is not respected, and recv() completes
	as soon as any data is received, regardless of the setting of the
	end of message bit.  Send coalescing is never performed, and sends
	smaller than a single packet are always sent with the end of
	message bit set.  Sends larger than a single packet are packetized
	with the end of message bit set on only the last packet of the
	send.
}


// This is the structure of the SOCKADDR structure for IPX and SPX.

type

	SOCKADDR_IPX = packed record
		sa_family : u_short;
		sa_netnum : Array [0..3] of Char;
		sa_nodenum : Array [0..5] of Char;
		sa_socket : u_short;
	end;
	TSOCKADDR_IPX = SOCKADDR_IPX;
  TSockAddrIPX = SOCKADDR_IPX;
	PSOCKADDR_IPX = ^SOCKADDR_IPX;
  PSockAddrIPX = ^SOCKADDR_IPX;
	LPSOCKADDR_IPX = ^SOCKADDR_IPX;

//  Protocol families used in the "protocol" parameter of the socket() API.

const
  {$EXTERNALSYM NSPROTO_IPX  }
	NSPROTO_IPX   = 1000;
  {$EXTERNALSYM NSPROTO_SPX  }
	NSPROTO_SPX   = 1256;
  {$EXTERNALSYM NSPROTO_SPXII}
	NSPROTO_SPXII = 1257;


//=============================================================

{
	wsnwlink.h

	Microsoft Windows
	Copyright (C) Microsoft Corporation, 1992-1999.
		Microsoft-specific extensions to the Windows NT IPX/SPX Windows
		Sockets interface.  These extensions are provided for use as
		necessary for compatibility with existing applications.  They are
		otherwise not recommended for use, as they are only guaranteed to
		work     over the Microsoft IPX/SPX stack.  An application which
		uses these     extensions may not work over other IPX/SPX
		implementations.  Include this header file after winsock.h and
		wsipx.h.

		To open an IPX socket where a particular packet type is sent in
		the IPX header, specify NSPROTO_IPX + n as the protocol parameter
		of the socket() API.  For example, to open an IPX socket that
		sets the packet type to 34, use the following socket() call:

    		s = socket(AF_IPX, SOCK_DGRAM, NSPROTO_IPX + 34);
}

// Below are socket option that may be set or retrieved by specifying
// the appropriate manifest in the "optname" parameter of getsockopt()
// or setsockopt().  Use NSPROTO_IPX as the "level" argument for the
// call.
const

//	Set/get the IPX packet type.  The value specified in the
//	optval argument will be set as the packet type on every IPX
//	packet sent from this socket.  The optval parameter of
//	getsockopt()/setsockopt() points to an int.
  {$EXTERNALSYM IPX_PTYPE }
	IPX_PTYPE = $4000;

//	Set/get the receive filter packet type.  Only IPX packets with
//	a packet type equal to the value specified in the optval
//	argument will be returned; packets with a packet type that
//	does not match are discarded.  optval points to an int.
  {$EXTERNALSYM IPX_FILTERPTYPE }
	IPX_FILTERPTYPE = $4001;

//	Stop filtering on packet type set with IPX_FILTERPTYPE.
  {$EXTERNALSYM IPX_STOPFILTERPTYPE }
	IPX_STOPFILTERPTYPE = $4003;

//	Set/get the value of the datastream field in the SPX header on
//	every packet sent.  optval points to an int.
  {$EXTERNALSYM IPX_DSTYPE }
	IPX_DSTYPE = $4002;

//	Enable extended addressing.  On sends, adds the element
//	"unsigned char sa_ptype" to the SOCKADDR_IPX structure,
//	making the total length 15 bytes.  On receives, add both
//	the sa_ptype and "unsigned char sa_flags" to the SOCKADDR_IPX
//	structure, making the total length 16 bytes.  The current
//	bits defined in sa_flags are:
//		0x01 - the received frame was sent as a broadcast
//		0x02 - the received frame was sent from this machine
//	optval points to a BOOL.
  {$EXTERNALSYM IPX_EXTENDED_ADDRESS }
	IPX_EXTENDED_ADDRESS = $4004;

//	Send protocol header up on all receive packets.  optval points
//	to a BOOL.
  {$EXTERNALSYM IPX_RECVHDR }
	IPX_RECVHDR = $4005;

//	Get the maximum data size that can be sent.  Not valid with
//	setsockopt().  optval points to an int where the value is
//	returned.
  {$EXTERNALSYM IPX_MAXSIZE }
	IPX_MAXSIZE = $4006;

//	Query information about a specific adapter that IPX is bound
//	to.  In a system with n adapters they are numbered 0 through n-1.
//	Callers can issue the IPX_MAX_ADAPTER_NUM getsockopt() to find
//	out the number of adapters present, or call IPX_ADDRESS with
//	increasing values of adapternum until it fails.  Not valid
//	with setsockopt().  optval points to an instance of the
//	IPX_ADDRESS_DATA structure with the adapternum filled in.
  {$EXTERNALSYM IPX_ADDRESS }
	IPX_ADDRESS = $4007;
type
	IPX_ADDRESS_DATA = packed record
		adapternum : Integer;                 // input: 0-based adapter number
		netnum     : Array [0..3] of Byte;    // output: IPX network number
		nodenum    : Array [0..5] of Byte;    // output: IPX node address
		wan        : Boolean;                 // output: TRUE = adapter is on a wan link
		status     : Boolean;                 // output: TRUE = wan link is up (or adapter is not wan)
		maxpkt     : Integer;                 // output: max packet size, not including IPX header
		linkspeed  : ULONG;                   // output: link speed in 100 bytes/sec (i.e. 96 == 9600 bps)
	end;
	PIPX_ADDRESS_DATA = ^IPX_ADDRESS_DATA;

const
//	Query information about a specific IPX network number.  If the
//	network is in IPX's cache it will return the information directly,    {Do not Localize}
//	otherwise it will issue RIP requests to find it.  Not valid with
//	setsockopt().  optval points to an instance of the IPX_NETNUM_DATA
//	structure with the netnum filled in.
  {$EXTERNALSYM IPX_GETNETINFO }
	IPX_GETNETINFO = $4008;
type
	IPX_NETNUM_DATA = packed record
		netnum   : Array [0..3] of Byte;  // input: IPX network number
		hopcount : Word;                  // output: hop count to this network, in machine order
		netdelay : Word;                  // output: tick count to this network, in machine order
		cardnum  : Integer;               // output: 0-based adapter number used to route to this net;
		                                  // can be used as adapternum input to IPX_ADDRESS
		router   : Array [0..5] of Byte;  // output: MAC address of the next hop router, zeroed if
																			// the network is directly attached
	end;
	PIPX_NETNUM_DATA = ^IPX_NETNUM_DATA;

const
//	Like IPX_GETNETINFO except it  does not  issue RIP requests. If the
//	network is in IPX's cache it will return the information, otherwise    {Do not Localize}
//	it will fail (see also IPX_RERIPNETNUMBER which  always  forces a
//	re-RIP). Not valid with setsockopt().  optval points to an instance of
//	the IPX_NETNUM_DATA structure with the netnum filled in.
  {$EXTERNALSYM IPX_GETNETINFO_NORIP }
	IPX_GETNETINFO_NORIP = $4009;

//	Get information on a connected SPX socket.  optval points
//	to an instance of the IPX_SPXCONNSTATUS_DATA structure.
//  *** All numbers are in Novell (high-low) order. ***
  {$EXTERNALSYM IPX_SPXGETCONNECTIONSTATUS }
	IPX_SPXGETCONNECTIONSTATUS = $400B;
type
	IPX_SPXCONNSTATUS_DATA = packed record
		ConnectionState         : Byte;
		WatchDogActive          : Byte;
		LocalConnectionId       : Word;
		RemoteConnectionId      : Word;
		LocalSequenceNumber     : Word;
		LocalAckNumber          : Word;
		LocalAllocNumber        : Word;
		RemoteAckNumber         : Word;
		RemoteAllocNumber       : Word;
		LocalSocket             : Word;
		ImmediateAddress        : Array [0..5] of Byte;
		RemoteNetwork           : Array [0..3] of Byte;
		RemoteNode              : Array [0..5] of Byte;
		RemoteSocket            : Word;
		RetransmissionCount     : Word;
		EstimatedRoundTripDelay : Word;                 // In milliseconds
		RetransmittedPackets    : Word;
		SuppressedPacket        : Word;
	end;
	PIPX_SPXCONNSTATUS_DATA = ^IPX_SPXCONNSTATUS_DATA;

const
//	Get notification when the status of an adapter that IPX is
//	bound to changes.  Typically this will happen when a wan line
//	goes up or down.  Not valid with setsockopt().  optval points
//	to a buffer which contains an IPX_ADDRESS_DATA structure
//	followed immediately by a HANDLE to an unsignaled event.
//
//	When the getsockopt() query is submitted, it will complete
//	successfully.  However, the IPX_ADDRESS_DATA pointed to by
//	optval will not be updated at that point.  Instead the
//	request is queued internally inside the transport.
//
//	When the status of an adapter changes, IPX will locate a
//	queued getsockopt() query and fill in all the fields in the
//	IPX_ADDRESS_DATA structure.  It will then signal the event
//	pointed to by the HANDLE in the optval buffer.  This handle
//	should be obtained before calling getsockopt() by calling
//	CreateEvent().  If multiple getsockopts() are submitted at
//	once, different events must be used.
//
//	The event is used because the call needs to be asynchronous
//	but currently getsockopt() does not support this.
//
//	WARNING: In the current implementation, the transport will
//	only signal one queued query for each status change.  Therefore
//	only one service which uses this query should be running at
//	once.
  {$EXTERNALSYM IPX_ADDRESS_NOTIFY }
	IPX_ADDRESS_NOTIFY = $400C;

//	Get the maximum number of adapters present.  If this call returns
//	n then the adapters are numbered 0 through n-1.  Not valid
//	with setsockopt().  optval points to an int where the value
//	is returned.
  {$EXTERNALSYM IPX_MAX_ADAPTER_NUM }
	IPX_MAX_ADAPTER_NUM = $400D;

//	Like IPX_GETNETINFO except it forces IPX to re-RIP even if the
//	network is in its cache (but not if it is directly attached to).
//	Not valid with setsockopt().  optval points to an instance of
//	the IPX_NETNUM_DATA structure with the netnum filled in.
  {$EXTERNALSYM IPX_RERIPNETNUMBER }
	IPX_RERIPNETNUMBER = $400E;

//	A hint that broadcast packets may be received.  The default is
//	TRUE.  Applications that do not need to receive broadcast packets
//	should set this sockopt to FALSE which may cause better system
//	performance (note that it does not necessarily cause broadcasts
//	to be filtered for the application).  Not valid with getsockopt().
//	optval points to a BOOL.
  {$EXTERNALSYM IPX_RECEIVE_BROADCAST }
	IPX_RECEIVE_BROADCAST = $400F;


//	On SPX connections, don't delay before sending ack.  Applications    {Do not Localize}
//	that do not tend to have back-and-forth traffic over SPX should
//	set this; it will increase the number of acks sent but will remove
//	delays in sending acks.  optval points to a BOOL.
  {$EXTERNALSYM IPX_IMMEDIATESPXACK }
	IPX_IMMEDIATESPXACK = $4010;


//=============================================================

//	wsnetbs.h
//	Copyright (c) 1994-1999, Microsoft Corp. All rights reserved.
//
//	Windows Sockets include file for NETBIOS.  This file contains all
//	standardized NETBIOS information.  Include this header file after
//	winsock.h.

//	To open a NetBIOS socket, call the socket() function as follows:
//
//		s = socket( AF_NETBIOS, {SOCK_SEQPACKET|SOCK_DGRAM}, -Lana );
//
//	where Lana is the NetBIOS Lana number of interest.  For example, to
//	open a socket for Lana 2, specify -2 as the "protocol" parameter
//	to the socket() function.


//	This is the structure of the SOCKADDR structure for NETBIOS.

const
  {$EXTERNALSYM NETBIOS_NAME_LENGTH}
 NETBIOS_NAME_LENGTH = 16;

type
	SOCKADDR_NB = packed record
		snb_family : Smallint;
		snb_type   : u_short;
		snb_name   : array[0..NETBIOS_NAME_LENGTH-1] of Char;
	end;
  TSockAddrNB  = SOCKADDR_NB;
  PSockAddrNB  = ^SOCKADDR_NB;
  LPSOCKADDR_NB = ^SOCKADDR_NB;

//	Bit values for the snb_type field of SOCKADDR_NB.
const
  {$EXTERNALSYM NETBIOS_UNIQUE_NAME       }
	NETBIOS_UNIQUE_NAME       = $0000;
  {$EXTERNALSYM NETBIOS_GROUP_NAME        }
	NETBIOS_GROUP_NAME        = $0001;
  {$EXTERNALSYM NETBIOS_TYPE_QUICK_UNIQUE }
	NETBIOS_TYPE_QUICK_UNIQUE = $0002;
  {$EXTERNALSYM NETBIOS_TYPE_QUICK_GROUP  }
	NETBIOS_TYPE_QUICK_GROUP  = $0003;

//	A macro convenient for setting up NETBIOS SOCKADDRs.
{$IFDEF CIL}
procedure SET_NETBIOS_SOCKADDR( var snb : TSockAddrNB; const SnbType : Word; const Name : String; const Port : Char );
{$ELSE}
{$EXTERNALSYM SET_NETBIOS_SOCKADDR}
procedure SET_NETBIOS_SOCKADDR( snb : PSockAddrNB; const SnbType : Word; const Name : PChar; const Port : Char );
{$ENDIF}


//=============================================================

//  Copyright 1997 - 1998 Microsoft Corporation
//
//  Module Name:
//
//  	ws2atm.h
//
//  Abstract:
//
//  	Winsock 2 ATM Annex definitions.


const
  {$EXTERNALSYM ATMPROTO_AALUSER }
	ATMPROTO_AALUSER = $00; // User-defined AAL
  {$EXTERNALSYM ATMPROTO_AAL1    }
	ATMPROTO_AAL1    = $01; // AAL 1
  {$EXTERNALSYM ATMPROTO_AAL2    }
	ATMPROTO_AAL2    = $02; // AAL 2
  {$EXTERNALSYM ATMPROTO_AAL34   }
	ATMPROTO_AAL34   = $03; // AAL 3/4
  {$EXTERNALSYM ATMPROTO_AAL5    }
	ATMPROTO_AAL5    = $05; // AAL 5

  {$EXTERNALSYM SAP_FIELD_ABSENT        }
	SAP_FIELD_ABSENT        = $FFFFFFFE;
  {$EXTERNALSYM SAP_FIELD_ANY           }
	SAP_FIELD_ANY           = $FFFFFFFF;
  {$EXTERNALSYM SAP_FIELD_ANY_AESA_SEL  }
	SAP_FIELD_ANY_AESA_SEL  = $FFFFFFFA;
  {$EXTERNALSYM SAP_FIELD_ANY_AESA_REST }
	SAP_FIELD_ANY_AESA_REST = $FFFFFFFB;

// values used for AddressType in struct ATM_ADDRESS
  {$EXTERNALSYM ATM_E164 }
	ATM_E164 = $01; // E.164 addressing scheme
  {$EXTERNALSYM ATM_NSAP }
	ATM_NSAP = $02; // NSAP-style ATM Endsystem Address scheme
  {$EXTERNALSYM ATM_AESA }
	ATM_AESA = $02; // NSAP-style ATM Endsystem Address scheme

  {$EXTERNALSYM ATM_ADDR_SIZE}
	ATM_ADDR_SIZE = 20;
type
	ATM_ADDRESS = packed record
		AddressType : DWORD;                        // E.164 or NSAP-style ATM Endsystem Address
		NumofDigits : DWORD;                        // number of digits;
		Addr : Array[0..(ATM_ADDR_SIZE)-1] of Byte; // IA5 digits for E164, BCD encoding for NSAP
																								// format as defined in the ATM Forum UNI 3.1
	end;

//-------------------------------------------------------------
// values used for Layer2Protocol in B-LLI
const
  {$EXTERNALSYM BLLI_L2_ISO_1745       }
	BLLI_L2_ISO_1745       = $01; // Basic mode ISO 1745
  {$EXTERNALSYM BLLI_L2_Q921           }
	BLLI_L2_Q921           = $02; // CCITT Rec. Q.921
  {$EXTERNALSYM BLLI_L2_X25L           }
	BLLI_L2_X25L           = $06; // CCITT Rec. X.25, link layer
  {$EXTERNALSYM BLLI_L2_X25M           }
	BLLI_L2_X25M           = $07; // CCITT Rec. X.25, multilink
  {$EXTERNALSYM BLLI_L2_ELAPB          }
	BLLI_L2_ELAPB          = $08; // Extended LAPB; for half duplex operation
  {$EXTERNALSYM BLLI_L2_HDLC_NRM       }
	BLLI_L2_HDLC_NRM       = $09; // HDLC NRM (ISO 4335)
  {$EXTERNALSYM BLLI_L2_HDLC_ABM       }
	BLLI_L2_HDLC_ABM       = $0A; // HDLC ABM (ISO 4335)
  {$EXTERNALSYM BLLI_L2_HDLC_ARM       }
	BLLI_L2_HDLC_ARM       = $0B; // HDLC ARM (ISO 4335)
  {$EXTERNALSYM BLLI_L2_LLC            }
	BLLI_L2_LLC            = $0C; // LAN logical link control (ISO 8802/2)
  {$EXTERNALSYM BLLI_L2_X75            }
	BLLI_L2_X75            = $0D; // CCITT Rec. X.75, single link procedure
  {$EXTERNALSYM BLLI_L2_Q922           }
	BLLI_L2_Q922           = $0E; // CCITT Rec. Q.922
  {$EXTERNALSYM BLLI_L2_USER_SPECIFIED }
	BLLI_L2_USER_SPECIFIED = $10; // User Specified
  {$EXTERNALSYM BLLI_L2_ISO_7776       }
	BLLI_L2_ISO_7776       = $11; // ISO 7776 DTE-DTE operation

//-------------------------------------------------------------
// values used for Layer3Protocol in B-LLI
  {$EXTERNALSYM BLLI_L3_X25            }
	BLLI_L3_X25            = $06; // CCITT Rec. X.25, packet layer
  {$EXTERNALSYM BLLI_L3_ISO_8208       }
	BLLI_L3_ISO_8208       = $07; // ISO/IEC 8208 (X.25 packet layer for DTE
  {$EXTERNALSYM BLLI_L3_X223           }
	BLLI_L3_X223           = $08; // X.223/ISO 8878
  {$EXTERNALSYM BLLI_L3_SIO_8473       }
	BLLI_L3_SIO_8473       = $09; // ISO/IEC 8473 (OSI connectionless)
  {$EXTERNALSYM BLLI_L3_T70            }
	BLLI_L3_T70            = $0A; // CCITT Rec. T.70 min. network layer
  {$EXTERNALSYM BLLI_L3_ISO_TR9577     }
	BLLI_L3_ISO_TR9577     = $0B; // ISO/IEC TR 9577 Network Layer Protocol ID
  {$EXTERNALSYM BLLI_L3_USER_SPECIFIED }
	BLLI_L3_USER_SPECIFIED = $10; // User Specified

//-------------------------------------------------------------
// values used for Layer3IPI in B-LLI
  {$EXTERNALSYM BLLI_L3_IPI_SNAP }
	BLLI_L3_IPI_SNAP = $80; // IEEE 802.1 SNAP identifier
  {$EXTERNALSYM BLLI_L3_IPI_IP   }
	BLLI_L3_IPI_IP   = $CC; // Internet Protocol (IP) identifier

type
	ATM_BLLI = packed record
		// Identifies the layer-two protocol.
		// Corresponds to the User information layer 2 protocol field in the B-LLI information element.
		// A value of SAP_FIELD_ABSENT indicates that this field is not used, and a value of SAP_FIELD_ANY means wildcard.
		Layer2Protocol              : DWORD; // User information layer 2 protocol
		// Identifies the user-specified layer-two protocol.
		// Only used if the Layer2Protocol parameter is set to BLLI_L2_USER_SPECIFIED.
		// The valid values range from zero–127.
		// Corresponds to the User specified layer 2 protocol information field in the B-LLI information element.
		Layer2UserSpecifiedProtocol : DWORD; // User specified layer 2 protocol information
		// Identifies the layer-three protocol.
		// Corresponds to the User information layer 3 protocol field in the B-LLI information element.
		// A value of SAP_FIELD_ABSENT indicates that this field is not used, and a value of SAP_FIELD_ANY means wildcard.
		Layer3Protocol              : DWORD; // User information layer 3 protocol
		// Identifies the user-specified layer-three protocol.
		// Only used if the Layer3Protocol parameter is set to BLLI_L3_USER_SPECIFIED.
		// The valid values range from zero–127.
		// Corresponds to the User specified layer 3 protocol information field in the B-LLI information element.
		Layer3UserSpecifiedProtocol : DWORD; // User specified layer 3 protocol information
		// Identifies the layer-three Initial Protocol Identifier.
		// Only used if the Layer3Protocol parameter is set to BLLI_L3_ISO_TR9577.
		// Corresponds to the ISO/IEC TR 9577 Initial Protocol Identifier field in the B-LLI information element.
		Layer3IPI                   : DWORD; // ISO/IEC TR 9577 Initial Protocol Identifier
		// Identifies the 802.1 SNAP identifier.
		// Only used if the Layer3Protocol parameter is set to BLLI_L3_ISO_TR9577 and Layer3IPI is set to BLLI_L3_IPI_SNAP,
		// indicating an IEEE 802.1 SNAP identifier. Corresponds to the OUI and PID fields in the B-LLI information element.
		SnapID                      : Array[0..4] of Byte; // SNAP ID consisting of OUI and PID
	end;

//-------------------------------------------------------------
// values used for the HighLayerInfoType field in ATM_BHLI
const
  {$EXTERNALSYM BHLI_ISO                 }
	BHLI_ISO                 = $00; // ISO
  {$EXTERNALSYM BHLI_UserSpecific        }
	BHLI_UserSpecific        = $01; // User Specific
  {$EXTERNALSYM BHLI_HighLayerProfile    }
	BHLI_HighLayerProfile    = $02; // High layer profile (only in UNI3.0)
  {$EXTERNALSYM BHLI_VendorSpecificAppId }
	BHLI_VendorSpecificAppId = $03; // Vendor-Specific Application ID

type
	ATM_BHLI = packed record
		// Identifies the high layer information type field in the B-LLI information element.
		// Note that the type BHLI_HighLayerProfile has been eliminated in UNI 3.1.
		// A value of SAP_FIELD_ABSENT indicates that B-HLI is not present, and a value of SAP_FIELD_ANY means wildcard.
		HighLayerInfoType   : DWORD; // High Layer Information Type
		// Identifies the number of bytes from one to eight in the HighLayerInfo array.
		// Valid values include eight for the cases of BHLI_ISO and BHLI_UserSpecific,
		// four for BHLI_HighLayerProfile, and seven for BHLI_VendorSpecificAppId.
		HighLayerInfoLength : DWORD; // number of bytes in HighLayerInfo
		// Identifies the high layer information field in the B-LLI information element.
		// In the case of HighLayerInfoType being BHLI_VendorSpecificAppId,
		// the first 3 bytes consist of a globally-administered Organizationally Unique Identifier (OUI)
		// (as per IEEE standard 802-1990), followed by a 4-byte application identifier,
		// which is administered by the vendor identified by the OUI.
		// Value for the case of BHLI_UserSpecific is user defined and requires bilateral agreement between two end users.
		HighLayerInfo       : Array[0..7] of Byte; // the value dependent on the HighLayerInfoType field
	end;

//-------------------------------------------------------------
// A new address family, AF_ATM, is introduced for native ATM services,
// and the corresponding SOCKADDR structure, sockaddr_atm, is defined in the following.
// To open a socket for native ATM services, parameters in socket should contain
// AF_ATM, SOCK_RAW, and ATMPROTO_AAL5 or ATMPROTO_AALUSER, respectively.
	sockaddr_atm = packed record
		// Identifies the address family, which is AF_ATM in this case.
		satm_family : u_short;
		// Identifies the ATM address that could be either in E.164 or NSAP-style ATM End Systems Address format.
		// This field will be mapped to the Called Party Number IE (Information Element)
		// if it is specified in bind and WSPBind for a listening socket, or in connect, WSAConnect, WSPConnect,
		// WSAJoinLeaf, or WSPJoinLeaf for a connecting socket.
		// It will be mapped to the Calling Party Number IE if specified in bind and WSPBind for a connecting socket.
		satm_number : ATM_ADDRESS;
		// Identifies the fields in the B-LLI Information Element that are used along with satm_bhli to identify an application.
		// Note that the B-LLI layer two information is treated as not present
		// if its Layer2Protocol field contains SAP_FIELD_ABSENT, or as a wildcard if it contains SAP_FIELD_ANY.
		// Similarly, the B-LLI layer three information is treated as not present
		// if its Layer3Protocol field contains SAP_FIELD_ABSENT, or as a wildcard if it contains SAP_FIELD_ANY.
		satm_blli   : ATM_BLLI;    // B-LLI
		// Identifies the fields in the B-HLI Information Element that are used along with satm_blli to identify an application.
		satm_bhli   : ATM_BHLI;    // B-HLI
	end;
	TSockAddrATM = sockaddr_atm;
	PSockAddrATM = ^TSockAddrATM;
	LPSockAddrATM = ^TSockAddrATM;
	PSOCKADDR_ATM = ^sockaddr_atm;
	LPSOCKADDR_ATM = ^sockaddr_atm;

//-------------------------------------------------------------
	Q2931_IE_TYPE = ( IE_AALParameters, IE_TrafficDescriptor,
		IE_BroadbandBearerCapability, IE_BHLI, IE_BLLI,IE_CalledPartyNumber,
		IE_CalledPartySubaddress, IE_CallingPartyNumber, IE_CallingPartySubaddress,
		IE_Cause, IE_QOSClass, IE_TransitNetworkSelection
	);

	Q2931_IE = record
		IEType   : Q2931_IE_TYPE;
		IELength : ULONG;
		IE       : Array[0..0] of Byte;
	end;

//-------------------------------------------------------------
// manifest constants for the AALType field in struct AAL_PARAMETERS_IE
	AAL_TYPE = LongInt;
const
  {$EXTERNALSYM AALTYPE_5    }
	AALTYPE_5    =  5; // AAL 5
  {$EXTERNALSYM AALTYPE_USER}
	AALTYPE_USER = 16; // user-defined AAL

//-------------------------------------------------------------
// values used for the Mode field in struct AAL5_PARAMETERS
  {$EXTERNALSYM AAL5_MODE_MESSAGE   }
	AAL5_MODE_MESSAGE   = $01;
  {$EXTERNALSYM AAL5_MODE_STREAMING }
	AAL5_MODE_STREAMING = $02;

//-------------------------------------------------------------
// values used for the SSCSType field in struct AAL5_PARAMETERS
  {$EXTERNALSYM AAL5_SSCS_NULL              }
	AAL5_SSCS_NULL              = $00;
  {$EXTERNALSYM AAL5_SSCS_SSCOP_ASSURED     }
	AAL5_SSCS_SSCOP_ASSURED     = $01;
  {$EXTERNALSYM AAL5_SSCS_SSCOP_NON_ASSURED }
	AAL5_SSCS_SSCOP_NON_ASSURED = $02;
  {$EXTERNALSYM AAL5_SSCS_FRAME_RELAY       }
	AAL5_SSCS_FRAME_RELAY       = $04;

type
	AAL5_PARAMETERS = packed record
		ForwardMaxCPCSSDUSize  : ULONG;
		BackwardMaxCPCSSDUSize : ULONG;
		Mode     : Byte; // only available in UNI 3.0
		SSCSType : Byte;
	end;

	AALUSER_PARAMETERS = packed record
		UserDefined : ULONG;
	end;

	AAL_PARAMETERS_IE = packed record
		AALType : AAL_TYPE;
		AALSpecificParameters : packed record
		case Byte of
			 0 : ( AAL5Parameters    : AAL5_PARAMETERS );
			 1 : ( AALUserParameters : AALUSER_PARAMETERS );
		end;
	end;

	ATM_TD = packed record
		PeakCellRate_CLP0         : ULONG;
		PeakCellRate_CLP01        : ULONG;
		SustainableCellRate_CLP0  : ULONG;
		SustainableCellRate_CLP01 : ULONG;
		MaxBurstSize_CLP0         : ULONG;
		MaxBurstSize_CLP01        : ULONG;
		Tagging                   : LongBool;
	end;

	ATM_TRAFFIC_DESCRIPTOR_IE = packed record
		Forward    : ATM_TD;
		Backward   : ATM_TD;
		BestEffort : LongBool;
	end;

//-------------------------------------------------------------
// values used for the BearerClass field in struct ATM_BROADBAND_BEARER_CAPABILITY_IE
const
  {$EXTERNALSYM BCOB_A }
	BCOB_A = $01; // Bearer class A
  {$EXTERNALSYM BCOB_C }
	BCOB_C = $03; // Bearer class C
  {$EXTERNALSYM BCOB_X }
	BCOB_X = $10; // Bearer class X

//-------------------------------------------------------------
// values used for the TrafficType field in struct ATM_BROADBAND_BEARER_CAPABILITY_IE

  {$EXTERNALSYM TT_NOIND }
	TT_NOIND = $00; // No indication of traffic type
  {$EXTERNALSYM TT_CBR   }
	TT_CBR   = $04; // Constant bit rate
  {$EXTERNALSYM TT_VBR   }
	TT_VBR   = $06; // Variable bit rate

//-------------------------------------------------------------
// values used for the TimingRequirements field in struct ATM_BROADBAND_BEARER_CAPABILITY_IE
  {$EXTERNALSYM TR_NOIND         }
	TR_NOIND         = $00; // No timing requirement indication
  {$EXTERNALSYM TR_END_TO_END    }
	TR_END_TO_END    = $01; // End-to-end timing required
  {$EXTERNALSYM TR_NO_END_TO_END }
	TR_NO_END_TO_END = $02; // End-to-end timing not required

//-------------------------------------------------------------
// values used for the ClippingSusceptability field in struct ATM_BROADBAND_BEARER_CAPABILITY_IE
  {$EXTERNALSYM CLIP_NOT }
	CLIP_NOT = $00; // Not susceptible to clipping
  {$EXTERNALSYM CLIP_SUS }
	CLIP_SUS = $20; // Susceptible to clipping

//-------------------------------------------------------------
// values used for the UserPlaneConnectionConfig field in struct ATM_BROADBAND_BEARER_CAPABILITY_IE
  {$EXTERNALSYM UP_P2P  }
	UP_P2P  = $00; // Point-to-point connection
  {$EXTERNALSYM UP_P2MP }
	UP_P2MP = $01; // Point-to-multipoint connection

type
	ATM_BROADBAND_BEARER_CAPABILITY_IE = packed record
		BearerClass : Byte;
		TrafficType : Byte;
		TimingRequirements        : Byte;
		ClippingSusceptability    : Byte;
		UserPlaneConnectionConfig : Byte;
	end;
	ATM_BHLI_IE = ATM_BHLI;

//-------------------------------------------------------------
// values used for the Layer2Mode field in struct ATM_BLLI_IE
const
  {$EXTERNALSYM BLLI_L2_MODE_NORMAL }
	BLLI_L2_MODE_NORMAL = $40;
  {$EXTERNALSYM BLLI_L2_MODE_EXT    }
	BLLI_L2_MODE_EXT    = $80;

//-------------------------------------------------------------
// values used for the Layer3Mode field in struct ATM_BLLI_IE
  {$EXTERNALSYM BLLI_L3_MODE_NORMAL }
	BLLI_L3_MODE_NORMAL = $40;
  {$EXTERNALSYM BLLI_L3_MODE_EXT    }
	BLLI_L3_MODE_EXT    = $80;

//-------------------------------------------------------------
// values used for the Layer3DefaultPacketSize field in struct ATM_BLLI_IE
  {$EXTERNALSYM BLLI_L3_PACKET_16   }
	BLLI_L3_PACKET_16   = $04;
  {$EXTERNALSYM BLLI_L3_PACKET_32   }
	BLLI_L3_PACKET_32   = $05;
  {$EXTERNALSYM BLLI_L3_PACKET_64   }
	BLLI_L3_PACKET_64   = $06;
  {$EXTERNALSYM BLLI_L3_PACKET_128  }
	BLLI_L3_PACKET_128  = $07;
  {$EXTERNALSYM BLLI_L3_PACKET_256  }
	BLLI_L3_PACKET_256  = $08;
  {$EXTERNALSYM BLLI_L3_PACKET_512  }
	BLLI_L3_PACKET_512  = $09;
  {$EXTERNALSYM BLLI_L3_PACKET_1024 }
	BLLI_L3_PACKET_1024 = $0A;
  {$EXTERNALSYM BLLI_L3_PACKET_2048 }
	BLLI_L3_PACKET_2048 = $0B;
  {$EXTERNALSYM BLLI_L3_PACKET_4096 }
	BLLI_L3_PACKET_4096 = $0C;

  // User information layer 2 protocol
  // User specified layer 2 protocol information
  // User information layer 3 protocol
  // User specified layer 3 protocol information
  // ISO/IEC TR 9577 Initial Protocol Identifier
  // SNAP ID consisting of OUI and PID

type

	ATM_BLLI_IE = record
		Layer2Protocol              : DWORD;
		Layer2Mode                  : Byte;
		Layer2WindowSize            : Byte;
		Layer2UserSpecifiedProtocol : DWORD;
		Layer3Protocol              : DWORD;
		Layer3Mode                  : Byte;
		Layer3DefaultPacketSize     : Byte;
		Layer3PacketWindowSize      : Byte;
		Layer3UserSpecifiedProtocol : DWORD;
		Layer3IPI                   : DWORD;
		SnapID       : Array[0..4] of Byte;
	end;
	ATM_CALLED_PARTY_NUMBER_IE = ATM_ADDRESS;
	ATM_CALLED_PARTY_SUBADDRESS_IE = ATM_ADDRESS;

//-------------------------------------------------------------
// values used for the Presentation_Indication field in struct ATM_CALLING_PARTY_NUMBER_IE
const
  {$EXTERNALSYM PI_ALLOWED              }
	PI_ALLOWED              = $00;
  {$EXTERNALSYM PI_RESTRICTED           }
	PI_RESTRICTED           = $40;
  {$EXTERNALSYM PI_NUMBER_NOT_AVAILABLE }
	PI_NUMBER_NOT_AVAILABLE = $80;

//-------------------------------------------------------------
// values used for the Screening_Indicator field in struct ATM_CALLING_PARTY_NUMBER_IE
  {$EXTERNALSYM SI_USER_NOT_SCREENED }
	SI_USER_NOT_SCREENED = $00;
  {$EXTERNALSYM SI_USER_PASSED       }
	SI_USER_PASSED       = $01;
  {$EXTERNALSYM SI_USER_FAILED       }
	SI_USER_FAILED       = $02;
  {$EXTERNALSYM SI_NETWORK           }
	SI_NETWORK           = $03;

type
	ATM_CALLING_PARTY_NUMBER_IE = record
		ATM_Number              : ATM_ADDRESS;
		Presentation_Indication : Byte;
		Screening_Indicator     : Byte;
	end;
	ATM_CALLING_PARTY_SUBADDRESS_IE = ATM_ADDRESS;

//-------------------------------------------------------------
// values used for the Location field in struct ATM_CAUSE_IE
const
  {$EXTERNALSYM CAUSE_LOC_USER                  }
	CAUSE_LOC_USER                  = $00;
  {$EXTERNALSYM CAUSE_LOC_PRIVATE_LOCAL         }
	CAUSE_LOC_PRIVATE_LOCAL         = $01;
  {$EXTERNALSYM CAUSE_LOC_PUBLIC_LOCAL          }
	CAUSE_LOC_PUBLIC_LOCAL          = $02;
  {$EXTERNALSYM CAUSE_LOC_TRANSIT_NETWORK       }
	CAUSE_LOC_TRANSIT_NETWORK       = $03;
  {$EXTERNALSYM CAUSE_LOC_PUBLIC_REMOTE         }
	CAUSE_LOC_PUBLIC_REMOTE         = $04;
  {$EXTERNALSYM CAUSE_LOC_PRIVATE_REMOTE        }
	CAUSE_LOC_PRIVATE_REMOTE        = $05;
  {$EXTERNALSYM CAUSE_LOC_INTERNATIONAL_NETWORK }
	CAUSE_LOC_INTERNATIONAL_NETWORK = $06;
  {$EXTERNALSYM CAUSE_LOC_BEYOND_INTERWORKING   }
	CAUSE_LOC_BEYOND_INTERWORKING   = $0A;

//-------------------------------------------------------------
// values used for the Cause field in struct ATM_CAUSE_IE
  {$EXTERNALSYM CAUSE_UNALLOCATED_NUMBER                }
	CAUSE_UNALLOCATED_NUMBER                = $01;
  {$EXTERNALSYM CAUSE_NO_ROUTE_TO_TRANSIT_NETWORK       }
	CAUSE_NO_ROUTE_TO_TRANSIT_NETWORK       = $02;
  {$EXTERNALSYM CAUSE_NO_ROUTE_TO_DESTINATION           }
	CAUSE_NO_ROUTE_TO_DESTINATION           = $03;
  {$EXTERNALSYM CAUSE_VPI_VCI_UNACCEPTABLE              }
	CAUSE_VPI_VCI_UNACCEPTABLE              = $0A;
  {$EXTERNALSYM CAUSE_NORMAL_CALL_CLEARING              }
	CAUSE_NORMAL_CALL_CLEARING              = $10;
  {$EXTERNALSYM CAUSE_USER_BUSY                         }
	CAUSE_USER_BUSY                         = $11;
  {$EXTERNALSYM CAUSE_NO_USER_RESPONDING                }
	CAUSE_NO_USER_RESPONDING                = $12;
  {$EXTERNALSYM CAUSE_CALL_REJECTED                     }
	CAUSE_CALL_REJECTED                     = $15;
  {$EXTERNALSYM CAUSE_NUMBER_CHANGED                    }
	CAUSE_NUMBER_CHANGED                    = $16;
  {$EXTERNALSYM CAUSE_USER_REJECTS_CLIR                 }
	CAUSE_USER_REJECTS_CLIR                 = $17;
  {$EXTERNALSYM CAUSE_DESTINATION_OUT_OF_ORDER          }
	CAUSE_DESTINATION_OUT_OF_ORDER          = $1B;
  {$EXTERNALSYM CAUSE_INVALID_NUMBER_FORMAT             }
	CAUSE_INVALID_NUMBER_FORMAT             = $1C;
  {$EXTERNALSYM CAUSE_STATUS_ENQUIRY_RESPONSE           }
	CAUSE_STATUS_ENQUIRY_RESPONSE           = $1E;
  {$EXTERNALSYM CAUSE_NORMAL_UNSPECIFIED                }
	CAUSE_NORMAL_UNSPECIFIED                = $1F;
  {$EXTERNALSYM CAUSE_VPI_VCI_UNAVAILABLE               }
	CAUSE_VPI_VCI_UNAVAILABLE               = $23;
  {$EXTERNALSYM CAUSE_NETWORK_OUT_OF_ORDER              }
	CAUSE_NETWORK_OUT_OF_ORDER              = $26;
  {$EXTERNALSYM CAUSE_TEMPORARY_FAILURE                 }
	CAUSE_TEMPORARY_FAILURE                 = $29;
  {$EXTERNALSYM CAUSE_ACCESS_INFORMAION_DISCARDED       }
	CAUSE_ACCESS_INFORMAION_DISCARDED       = $2B;
  {$EXTERNALSYM CAUSE_NO_VPI_VCI_AVAILABLE              }
	CAUSE_NO_VPI_VCI_AVAILABLE              = $2D;
  {$EXTERNALSYM CAUSE_RESOURCE_UNAVAILABLE              }
	CAUSE_RESOURCE_UNAVAILABLE              = $2F;
  {$EXTERNALSYM CAUSE_QOS_UNAVAILABLE                   }
	CAUSE_QOS_UNAVAILABLE                   = $31;
  {$EXTERNALSYM CAUSE_USER_CELL_RATE_UNAVAILABLE        }
	CAUSE_USER_CELL_RATE_UNAVAILABLE        = $33;
  {$EXTERNALSYM CAUSE_BEARER_CAPABILITY_UNAUTHORIZED    }
	CAUSE_BEARER_CAPABILITY_UNAUTHORIZED    = $39;
  {$EXTERNALSYM CAUSE_BEARER_CAPABILITY_UNAVAILABLE     }
	CAUSE_BEARER_CAPABILITY_UNAVAILABLE     = $3A;
  {$EXTERNALSYM CAUSE_OPTION_UNAVAILABLE                }
	CAUSE_OPTION_UNAVAILABLE                = $3F;
  {$EXTERNALSYM CAUSE_BEARER_CAPABILITY_UNIMPLEMENTED   }
	CAUSE_BEARER_CAPABILITY_UNIMPLEMENTED   = $41;
  {$EXTERNALSYM CAUSE_UNSUPPORTED_TRAFFIC_PARAMETERS    }
	CAUSE_UNSUPPORTED_TRAFFIC_PARAMETERS    = $49;
  {$EXTERNALSYM CAUSE_INVALID_CALL_REFERENCE            }
	CAUSE_INVALID_CALL_REFERENCE            = $51;
  {$EXTERNALSYM CAUSE_CHANNEL_NONEXISTENT               }
	CAUSE_CHANNEL_NONEXISTENT               = $52;
  {$EXTERNALSYM CAUSE_INCOMPATIBLE_DESTINATION          }
	CAUSE_INCOMPATIBLE_DESTINATION          = $58;
  {$EXTERNALSYM CAUSE_INVALID_ENDPOINT_REFERENCE        }
	CAUSE_INVALID_ENDPOINT_REFERENCE        = $59;
  {$EXTERNALSYM CAUSE_INVALID_TRANSIT_NETWORK_SELECTION }
	CAUSE_INVALID_TRANSIT_NETWORK_SELECTION = $5B;
  {$EXTERNALSYM CAUSE_TOO_MANY_PENDING_ADD_PARTY        }
	CAUSE_TOO_MANY_PENDING_ADD_PARTY        = $5C;
  {$EXTERNALSYM CAUSE_AAL_PARAMETERS_UNSUPPORTED        }
	CAUSE_AAL_PARAMETERS_UNSUPPORTED        = $5D;
  {$EXTERNALSYM CAUSE_MANDATORY_IE_MISSING              }
	CAUSE_MANDATORY_IE_MISSING              = $60;
  {$EXTERNALSYM CAUSE_UNIMPLEMENTED_MESSAGE_TYPE        }
	CAUSE_UNIMPLEMENTED_MESSAGE_TYPE        = $61;
  {$EXTERNALSYM CAUSE_UNIMPLEMENTED_IE                  }
	CAUSE_UNIMPLEMENTED_IE                  = $63;
  {$EXTERNALSYM CAUSE_INVALID_IE_CONTENTS               }
	CAUSE_INVALID_IE_CONTENTS               = $64;
  {$EXTERNALSYM CAUSE_INVALID_STATE_FOR_MESSAGE         }
	CAUSE_INVALID_STATE_FOR_MESSAGE         = $65;
  {$EXTERNALSYM CAUSE_RECOVERY_ON_TIMEOUT               }
	CAUSE_RECOVERY_ON_TIMEOUT               = $66;
  {$EXTERNALSYM CAUSE_INCORRECT_MESSAGE_LENGTH          }
	CAUSE_INCORRECT_MESSAGE_LENGTH          = $68;
  {$EXTERNALSYM CAUSE_PROTOCOL_ERROR                    }
	CAUSE_PROTOCOL_ERROR                    = $6F;

//-------------------------------------------------------------
// values used for the Condition portion of the Diagnostics field
// in struct ATM_CAUSE_IE, for certain Cause values
  {$EXTERNALSYM CAUSE_COND_UNKNOWN   }
	CAUSE_COND_UNKNOWN   = $00;
  {$EXTERNALSYM CAUSE_COND_PERMANENT }
	CAUSE_COND_PERMANENT = $01;
  {$EXTERNALSYM CAUSE_COND_TRANSIENT }
	CAUSE_COND_TRANSIENT = $02;

//-------------------------------------------------------------
// values used for the Rejection Reason portion of the Diagnostics field
// in struct ATM_CAUSE_IE, for certain Cause values

  {$EXTERNALSYM CAUSE_REASON_USER            }
	CAUSE_REASON_USER            = $00;
  {$EXTERNALSYM CAUSE_REASON_IE_MISSING      }
	CAUSE_REASON_IE_MISSING      = $04;
  {$EXTERNALSYM CAUSE_REASON_IE_INSUFFICIENT }
	CAUSE_REASON_IE_INSUFFICIENT = $08;

//-------------------------------------------------------------
// values used for the P-U flag of the Diagnostics field
// in struct ATM_CAUSE_IE, for certain Cause values
  {$EXTERNALSYM CAUSE_PU_PROVIDER }
	CAUSE_PU_PROVIDER = $00;
  {$EXTERNALSYM CAUSE_PU_USER     }
	CAUSE_PU_USER     = $08;

//-------------------------------------------------------------
// values used for the N-A flag of the Diagnostics field
// in struct ATM_CAUSE_IE, for certain Cause values
  {$EXTERNALSYM CAUSE_NA_NORMAL }
	CAUSE_NA_NORMAL = $00;
  {$EXTERNALSYM CAUSE_NA_ABNORMAL }
	CAUSE_NA_ABNORMAL = $04;

type
	ATM_CAUSE_IE = record
		Location          : Byte;
		Cause             : Byte;
		DiagnosticsLength : Byte;
		Diagnostics       : Array[0..3] of Byte;
	end;

//-------------------------------------------------------------
// values used for the QOSClassForward and QOSClassBackward
// field in struct ATM_QOS_CLASS_IE
const
  {$EXTERNALSYM QOS_CLASS0 }
	QOS_CLASS0 = $00;
  {$EXTERNALSYM QOS_CLASS1 }
	QOS_CLASS1 = $01;
  {$EXTERNALSYM QOS_CLASS2 }
	QOS_CLASS2 = $02;
  {$EXTERNALSYM QOS_CLASS3 }
	QOS_CLASS3 = $03;
  {$EXTERNALSYM QOS_CLASS4 }
	QOS_CLASS4 = $04;

type
	ATM_QOS_CLASS_IE = packed record
		QOSClassForward  : Byte;
		QOSClassBackward : Byte;
	end;

//-------------------------------------------------------------
// values used for the TypeOfNetworkId field in struct ATM_TRANSIT_NETWORK_SELECTION_IE
const
  {$EXTERNALSYM TNS_TYPE_NATIONAL }
	TNS_TYPE_NATIONAL = $40;

//-------------------------------------------------------------
// values used for the NetworkIdPlan field in struct ATM_TRANSIT_NETWORK_SELECTION_IE
  {$EXTERNALSYM TNS_PLAN_CARRIER_ID_CODE }
	TNS_PLAN_CARRIER_ID_CODE = $01;

type
	ATM_TRANSIT_NETWORK_SELECTION_IE = record
		TypeOfNetworkId : Byte;
		NetworkIdPlan   : Byte;
		NetworkIdLength : Byte;
		NetworkId : Array[0..0] of Byte;
	end;

//-------------------------------------------------------------
// ATM specific Ioctl codes
const
  {$EXTERNALSYM SIO_GET_NUMBER_OF_ATM_DEVICES }
	SIO_GET_NUMBER_OF_ATM_DEVICES = $50160001;
  {$EXTERNALSYM SIO_GET_ATM_ADDRESS           }
	SIO_GET_ATM_ADDRESS           = $d0160002;
  {$EXTERNALSYM SIO_ASSOCIATE_PVC             }
	SIO_ASSOCIATE_PVC             = $90160003;
  {$EXTERNALSYM SIO_GET_ATM_CONNECTION_ID     }
	SIO_GET_ATM_CONNECTION_ID     = $50160004; // ATM Connection Identifier

type
	ATM_CONNECTION_ID = packed record
		DeviceNumber : DWORD;
		VPI          : DWORD;
		VCI          : DWORD;
	end;

// Input buffer format for SIO_ASSOCIATE_PVC
	ATM_PVC_PARAMS = packed record
		PvcConnectionId : ATM_CONNECTION_ID;
		PvcQos          : QOS;
	end;

function Winsock2Loaded : Boolean;

{$IFDEF CIL}
function ConnectEx(const s : TSocket; const name: PSockAddr; const namelen: Integer; lpSendBuffer : Pointer; dwSendDataLength : DWord; var lpdwBytesSent : DWord; var lpOverlapped : wsaoverlapped ) : BOOL;
function DisconnectEx(const hSocket : TSocket; AOverlapped: Pointer; const dwFlags : DWord; const dwReserved : DWord) : BOOL;
function WSARecvMsg ( const s : TSocket; lpMsg : PWSAMSG; var lpNumberOfBytesRecvd : DWORD; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer;
function TransmitPackets(hSocket: TSocket; lpPacketArray: LPTRANSMIT_PACKETS_ELEMENT; nElementCount: DWORD; nSendSize: DWORD; lpOverlapped: LPwsaoverlapped; dwFlags: DWORD): BOOL;
function ServiceQueryTransmitFile(hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD; nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped; lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL;
{$ELSE}
{$EXTERNALSYM ConnectEx}
function ConnectEx(const s : TSocket; const name: PSockAddr; const namelen: Integer; lpSendBuffer : Pointer; dwSendDataLength : DWord; var lpdwBytesSent : DWord; lpOverlapped : LPwsaoverlapped ) : BOOL;
{$EXTERNALSYM DisconnectEx}
function DisconnectEx(const hSocket : TSocket; AOverlapped: Pointer; const dwFlags : DWord; const dwReserved : DWord) : BOOL;
{$EXTERNALSYM WSARecvMsg (}
function WSARecvMsg ( const s : TSocket; lpMsg : PWSAMSG; var lpNumberOfBytesRecvd : DWORD; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer;
{$EXTERNALSYM TransmitPackets}
function TransmitPackets(hSocket: TSocket; lpPacketArray: LPTRANSMIT_PACKETS_ELEMENT; nElementCount: DWORD; nSendSize: DWORD; lpOverlapped: LPwsaoverlapped; dwFlags: DWORD): BOOL;
{$EXTERNALSYM ServiceQueryTransmitFile}
function ServiceQueryTransmitFile(hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD; nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped; lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL;
{$ENDIF}

//=============================================================
implementation

uses IdResourceStrings;

//=============================================================
// (c) March 2001,  "Alex Konshin"<alexk@mtgroup.ru>

type
  PPointer = ^Pointer;

var
  hWS2Dll : THandle = 0; // WS2.DLL handle
  {$NODEFINE WS2_WSAStartup}
  WS2_WSAStartup : TWSAStartupProc;

function Winsock2Loaded : Boolean;
begin
  Result := hWS2Dll <> 0;
end;

constructor EIdWinsockStubError.Build( const ATitle : String; AWin32Error : DWORD );
begin
  FTitle := ATitle;
  FWin32Error := AWin32Error;
  if AWin32Error=0 then
  begin
    inherited Create( ATitle )
  end
  else
  begin
    FWin32ErrorMessage := SysUtils.SysErrorMessage(AWin32Error);
    inherited Create( ATitle+': '+FWin32ErrorMessage );    {Do not Localize}
  end;
end;

procedure FixupStub(const AName: string; var VStub: Pointer);
begin
  if hWS2Dll = 0 then begin
    EIdWinsockStubError.Build(Format(RSWinsockCallError, [AName]), WSANOTINITIALISED);
  end;
  VStub := Windows.GetProcAddress(hWS2Dll, PChar(AName));
end;

function Stub_WSACleanup: Integer; stdcall;
begin
  FixupStub('WSACleanup', @WSACleanup); {Do not Localize}
  Result := WSACleanup;
end;

function Stub_accept (const s: TSocket; addr: PSockAddr; addrlen: PInteger): TSocket; stdcall;
begin
  FixupStub('accept', @accept); {Do not Localize}
  Result := accept(s, addr, addrlen);
end;

function Stub_bind (const s: TSocket; const name: PSockAddr; const namelen: Integer): Integer; stdcall;
begin
  FixupStub('bind', @bind); {Do not Localize}
  Result := bind(s, name, namelen);
end;

function Stub_closesocket (const s: TSocket): Integer; stdcall;
begin
  FixupStub('closesocket', @closesocket); {Do not Localize}
  Result := closesocket(s);
end;

function Stub_connect (const s: TSocket; const name: PSockAddr; const namelen: Integer): Integer; stdcall;
begin
  FixupStub('connect', @connect); {Do not Localize}
  Result := connect(s, name, namelen);
end;

function Stub_ioctlsocket (const s: TSocket; const cmd: DWORD; var arg: u_long): Integer; stdcall;
begin
  FixupStub('ioctlsocket', @ioctlsocket); {Do not Localize}
  Result := ioctlsocket(s, cmd, arg);
end;

function Stub_getpeername (const s: TSocket; const name: PSockAddr; var namelen: Integer): Integer; stdcall;
begin
  FixupStub('getpeername', @getpeername); {Do not Localize}
  Result := getpeername(s, name, namelen);
end;

function Stub_getsockname (const s: TSocket; const name: PSockAddr; var namelen: Integer): Integer; stdcall;
begin
  FixupStub('getsockname', @getsockname); {Do not Localize}
  Result := getsockname(s, name, namelen);
end;

function Stub_getsockopt (const s: TSocket; const level, optname: Integer; optval: PChar; var optlen: Integer): Integer; stdcall;
begin
  FixupStub('getsockopt', @getsockopt); {Do not Localize}
  Result := getsockopt(s, level, optname, optval, optlen);
end;

function Stub_htonl (hostlong: u_long): u_long; stdcall;
begin
  FixupStub('htonl', @htonl); {Do not Localize}
  Result := htonl(hostlong);
end;

function Stub_htons (hostshort: u_short): u_short; stdcall;
begin
  FixupStub('htons', @htons); {Do not Localize}
  Result := htons(hostshort);
end;

function Stub_inet_addr (cp: PChar): u_long; stdcall;
begin
  FixupStub('inet_addr', @inet_addr); {Do not Localize}
  Result := inet_addr(cp);
end;

function Stub_inet_ntoa (inaddr: TInAddr): PChar; stdcall;
begin
  FixupStub('inet_ntoa', @inet_ntoa); {Do not Localize}
  Result := inet_ntoa(inaddr);
end;

function Stub_listen (const s: TSocket; backlog: Integer): Integer; stdcall;
begin
  FixupStub('listen', @listen); {Do not Localize}
  Result := listen(s, backlog);
end;

function Stub_ntohl (netlong: u_long): u_long; stdcall;
begin
  FixupStub('ntohl', @ntohl); {Do not Localize}
  Result := ntohl(netlong);
end;

function Stub_ntohs (netshort: u_short): u_short; stdcall;
begin
  FixupStub('ntohs', @ntohs); {Do not Localize}
  Result := ntohs(netshort);
end;

function Stub_recv (const s: TSocket; var Buf; len, flags: Integer): Integer; stdcall;
begin
  FixupStub('recv', @recv); {Do not Localize}
  Result := recv(s, Buf, len, flags);
end;

function Stub_recvfrom (const s: TSocket; var Buf; len, flags: Integer; from: PSockAddr; fromlen: PInteger): Integer; stdcall;
begin
  FixupStub('recvfrom', @recvfrom); {Do not Localize}
  Result := recvfrom(s, Buf, len, flags, from, fromlen);
end;

function Stub_select (nfds: Integer; readfds, writefds, exceptfds: PFDSet; timeout: PTimeVal): Integer; stdcall;
begin
  FixupStub('select', @select); {Do not Localize}
  Result := select(nfds, readfds, writefds, exceptfds, timeout);
end;

function Stub_send (const s: TSocket; const Buf; len, flags: Integer): Integer; stdcall;
begin
  FixupStub('send', @send); {Do not Localize}
  Result := send(s, Buf, len, flags);
end;

function Stub_sendto (const s: TSocket; const Buf; const len, flags: Integer; const addrto: PSockAddr; const tolen: Integer): Integer; stdcall;
begin
  FixupStub('sendto', @sendto); {Do not Localize}
  Result := sendto(s, Buf, len, flags, addrto, tolen);
end;

function Stub_setsockopt (const s: TSocket; const level, optname: Integer; optval: PChar; const optlen: Integer): Integer; stdcall;
begin
  FixupStub('setsockopt', @setsockopt); {Do not Localize}
  Result := setsockopt(s, level, optname, optval, optlen);
end;

function Stub_shutdown (const s: TSocket; const how: Integer): Integer; stdcall;
begin
  FixupStub('shutdown', @shutdown); {Do not Localize}
  Result := shutdown(s, how);
end;

function Stub_socket (const af, istruct, protocol: Integer): TSocket; stdcall;
begin
  FixupStub('socket', @socket); {Do not Localize}
  Result := socket(af, istruct, protocol);
end;

function Stub_gethostbyaddr (addr: Pointer; const len, addrtype: Integer): PHostEnt; stdcall;
begin
  FixupStub('gethostbyaddr', @gethostbyaddr); {Do not Localize}
  Result := gethostbyaddr(addr, len, addrtype);
end;

function Stub_gethostbyname (name: PChar): PHostEnt; stdcall;
begin
  FixupStub('gethostbyname', @gethostbyname); {Do not Localize}
  Result := gethostbyname(name);
end;

function Stub_gethostname (name: PChar; len: Integer): Integer; stdcall;
begin
  FixupStub('gethostname', @gethostname); {Do not Localize}
  Result := gethostname(name, len);
end;

function Stub_getservbyport (const port: Integer; const proto: PChar): PServEnt; stdcall;
begin
  FixupStub('getservbyport', @getservbyport); {Do not Localize}
  Result := getservbyport(port, proto);
end;

function Stub_getservbyname (const name, proto: PChar): PServEnt; stdcall;
begin
  FixupStub('getservbyname', @getservbyname); {Do not Localize}
  Result := getservbyname(name, proto);
end;

function Stub_getprotobynumber (const proto: Integer): PProtoEnt; stdcall;
begin
  FixupStub('getprotobynumber', @getprotobynumber); {Do not Localize}
  Result := getprotobynumber(proto);
end;

function Stub_getprotobyname (const name: PChar): PProtoEnt; stdcall;
begin
  FixupStub('getprotobyname', @getprotobyname); {Do not Localize}
  Result := getprotobyname(name);
end;

procedure Stub_WSASetLastError (const iError: Integer); stdcall;
begin
  FixupStub('WSASetLastError', @WSASetLastError); {Do not Localize}
  WSASetLastError(iError);
end;

function Stub_WSAGetLastError: Integer; stdcall;
begin
  FixupStub('WSAGetLastError', @WSAGetLastError); {Do not Localize}
  Result := WSAGetLastError;
end;

function Stub_WSAIsBlocking: BOOL; stdcall;
begin
  FixupStub('WSAIsBlocking', @WSAIsBlocking); {Do not Localize}
  Result := WSAIsBlocking;
end;

function Stub_WSAUnhookBlockingHook: Integer; stdcall;
begin
  FixupStub('WSAUnhookBlockingHook', @WSAUnhookBlockingHook); {Do not Localize}
  Result := WSAUnhookBlockingHook;
end;

function Stub_WSASetBlockingHook (lpBlockFunc: TFarProc): TFarProc; stdcall;
begin
  FixupStub('WSASetBlockingHook', @WSASetBlockingHook); {Do not Localize}
  Result := WSASetBlockingHook(lpBlockFunc);
end;

function Stub_WSACancelBlockingCall: Integer; stdcall;
begin
  FixupStub('WSACancelBlockingCall', @WSACancelBlockingCall); {Do not Localize}
  Result := WSACancelBlockingCall;
end;

function Stub_WSAAsyncGetServByName (HWindow: HWND; wMsg: u_int; name, proto, buf: PChar; buflen: Integer): THandle; stdcall;
begin
  FixupStub('WSAAsyncGetServByName', @WSAAsyncGetServByName); {Do not Localize}
  Result := WSAAsyncGetServByName(HWindow, wMsg, name, proto, buf, buflen);
end;

function Stub_WSAAsyncGetServByPort (HWindow: HWND; wMsg, port: u_int; proto, buf: PChar; buflen: Integer): THandle; stdcall;
begin
  FixupStub('WSAAsyncGetServByPort', @WSAAsyncGetServByPort); {Do not Localize}
  Result := WSAAsyncGetServByPort(HWindow, wMsg, port, proto, buf, buflen);
end;

function Stub_WSAAsyncGetProtoByName (HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer): THandle; stdcall;
begin
  FixupStub('WSAAsyncGetProtoByName', @WSAAsyncGetProtoByName); {Do not Localize}
  Result := WSAAsyncGetProtoByName(HWindow, wMsg, name, buf, buflen);
end;

function Stub_WSAAsyncGetProtoByNumber (HWindow: HWND; wMsg: u_int; number: Integer; buf: PChar; buflen: Integer): THandle; stdcall;
begin
  FixupStub('WSAAsyncGetProtoByNumber', @WSAAsyncGetProtoByNumber); {Do not Localize}
  Result := WSAAsyncGetProtoByNumber(HWindow, wMsg, number, buf, buflen);
end;

function Stub_WSAAsyncGetHostByName (HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer): THandle; stdcall;
begin
  FixupStub('WSAAsyncGetHostByName', @WSAAsyncGetHostByName); {Do not Localize}
  Result := WSAAsyncGetHostByName(HWindow, wMsg, name, buf, buflen);
end;

function Stub_WSAAsyncGetHostByAddr (HWindow: HWND; wMsg: u_int; addr: PChar; len, istruct: Integer; buf: PChar; buflen: Integer): THandle; stdcall;
begin
  FixupStub('WSAAsyncGetHostByAddr', @WSAAsyncGetHostByAddr); {Do not Localize}
  Result := WSAAsyncGetHostByAddr(HWindow, wMsg, addr, len, istruct, buf, buflen);
end;

function Stub_WSACancelAsyncRequest (hAsyncTaskHandle: THandle): Integer; stdcall;
begin
  FixupStub('WSACancelAsyncRequest', @WSACancelAsyncRequest); {Do not Localize}
  Result := WSACancelAsyncRequest(hAsyncTaskHandle);
end;

function Stub_WSAAsyncSelect (const s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint): Integer; stdcall;
begin
  FixupStub('WSAAsyncSelect', @WSAAsyncSelect); {Do not Localize}
  Result := WSAAsyncSelect(s, HWindow, wMsg, lEvent);
end;

function Stub___WSAFDIsSet (const s: TSocket; var FDSet: TFDSet): Bool; stdcall;
begin
  FixupStub('__WSAFDIsSet', @__WSAFDIsSet); {Do not Localize}
  Result := __WSAFDIsSet(s, FDSet);
end;

function Stub_WSAAccept (const s: TSocket; addr: PSockAddr; addrlen: PInteger; lpfnCondition: LPCONDITIONPROC; const dwCallbackData: DWORD): TSocket; stdcall;
begin
  FixupStub('WSAAccept', @WSAAccept); {Do not Localize}
  Result := WSAAccept(s, addr, addrlen, lpfnCondition, dwCallbackData);
end;

function Stub_WSACloseEvent (const hEvent: wsaevent): WordBool; stdcall;
begin
  FixupStub('WSACloseEvent', @WSACloseEvent); {Do not Localize}
  Result := WSACloseEvent(hEvent);
end;

function Stub_WSAConnect (const s: TSocket; const name: PSockAddr; const namelen: Integer; lpCallerData,lpCalleeData: LPWSABUF; lpSQOS,lpGQOS: LPQOS): Integer; stdcall;
begin
  FixupStub('WSAConnect', @WSAConnect); {Do not Localize}
  Result := WSAConnect(s, name, namelen, lpCallerData, lpCalleeData, lpSQOS, lpGQOS);
end;

function Stub_WSACreateEvent: wsaevent; stdcall;
begin
  FixupStub('WSACreateEvent', @WSACreateEvent); {Do not Localize}
  Result := WSACreateEvent;
end;

function Stub_WSADuplicateSocketA (const s: TSocket; const dwProcessId: DWORD; lpProtocolInfo: LPWSAProtocol_InfoA): Integer; stdcall;
begin
  FixupStub('WSADuplicateSocketA', @WSADuplicateSocketA); {Do not Localize}
  Result := WSADuplicateSocketA(s, dwProcessId, lpProtocolInfo);
end;

function Stub_WSADuplicateSocketW (const s: TSocket; const dwProcessId: DWORD; lpProtocolInfo: LPWSAProtocol_InfoW): Integer; stdcall;
begin
  FixupStub('WSADuplicateSocketW', @WSADuplicateSocketW); {Do not Localize}
  Result := WSADuplicateSocketW(s, dwProcessId, lpProtocolInfo);
end;

function Stub_WSADuplicateSocket (const s: TSocket; const dwProcessId: DWORD; lpProtocolInfo: LPWSAProtocol_Info): Integer; stdcall;
begin
  FixupStub('WSADuplicateSocket', @WSADuplicateSocket); {Do not Localize}
  Result := WSADuplicateSocket(s, dwProcessId, lpProtocolInfo);
end;

function Stub_WSAEnumNetworkEvents (const s: TSocket; const hEventObject: wsaevent; lpNetworkEvents: LPWSANETWORKEVENTS):Integer; stdcall;
begin
  FixupStub('WSAEnumNetworkEvents', @WSAEnumNetworkEvents); {Do not Localize}
  Result := WSAEnumNetworkEvents(s, hEventObject, lpNetworkEvents);
end;

function Stub_WSAEnumProtocolsA (lpiProtocols: PInteger; lpProtocolBuffer: LPWSAProtocol_InfoA; var lpdwBufferLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAEnumProtocolsA', @WSAEnumProtocolsA); {Do not Localize}
  Result := WSAEnumProtocolsA(lpiProtocols, lpProtocolBuffer, lpdwBufferLength);
end;

function Stub_WSAEnumProtocolsW (lpiProtocols: PInteger; lpProtocolBuffer: LPWSAProtocol_InfoW; var lpdwBufferLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAEnumProtocolsW', @WSAEnumProtocolsW); {Do not Localize}
  Result := WSAEnumProtocolsW(lpiProtocols, lpProtocolBuffer, lpdwBufferLength);
end;

function Stub_WSAEnumProtocols (lpiProtocols: PInteger; lpProtocolBuffer: LPWSAProtocol_Info; var lpdwBufferLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAEnumProtocolsA', @WSAEnumProtocols); {Do not Localize}
  Result := WSAEnumProtocols(lpiProtocols, lpProtocolBuffer, lpdwBufferLength);
end;

function Stub_WSAEventSelect (const s: TSocket; const hEventObject: wsaevent; lNetworkEvents: LongInt): Integer; stdcall;
begin
  FixupStub('WSAEventSelect', @WSAEventSelect); {Do not Localize}
  Result := WSAEventSelect(s, hEventObject, lNetworkEvents);
end;

function Stub_WSAGetOverlappedResult (const s: TSocket; AOverlapped: Pointer; lpcbTransfer: LPDWORD; fWait: BOOL; var lpdwFlags: DWORD): WordBool; stdcall;
begin
  FixupStub('WSAGetOverlappedResult', @WSAGetOverlappedResult); {Do not Localize}
  Result := WSAGetOverlappedResult(s, AOverlapped, lpcbTransfer, fWait, lpdwFlags);
end;

function Stub_WSAGetQOSByName (const s: TSocket; lpQOSName: LPWSABUF; lpQOS: LPQOS): WordBool; stdcall;
begin
  FixupStub('WSAGetQOSByName', @WSAGetQOSByName); {Do not Localize}
  Result := WSAGetQOSByName(s, lpQOSName, lpQOS);
end;

function Stub_WSAHtonl (const s: TSocket; hostlong: u_long; var lpnetlong: DWORD): Integer; stdcall;
begin
  FixupStub('WSAHtonl', @WSAHtonl); {Do not Localize}
  Result := WSAHtonl(s, hostlong, lpnetlong);
end;

function Stub_WSAHtons (const s: TSocket; hostshort: u_short; var lpnetshort: WORD): Integer; stdcall;
begin
  FixupStub('WSAHtons', @WSAHtons); {Do not Localize}
  Result := WSAHtons(s, hostshort, lpnetshort);
end;

function Stub_WSAIoctl (const s: TSocket; dwIoControlCode: DWORD; lpvInBuffer: Pointer; cbInBuffer: DWORD; lpvOutBuffer: Pointer; cbOutBuffer: DWORD; lpcbBytesReturned: LPDWORD; AOverlapped: Pointer; lpCompletionRoutine: LPwsaoverlapped_COMPLETION_ROUTINE): Integer; stdcall;
begin
  FixupStub('WSAIoctl', @WSAIoctl); {Do not Localize}
  Result := WSAIoctl(s, dwIoControlCode, lpvInBuffer, cbInBuffer, lpvOutBuffer, cbOutBuffer, lpcbBytesReturned, AOverlapped, lpCompletionRoutine)
end;

function Stub_WSAJoinLeaf (const s: TSocket; name: PSockAddr; namelen: Integer; lpCallerData,lpCalleeData: LPWSABUF; lpSQOS,lpGQOS: LPQOS; dwFlags: DWORD): TSocket; stdcall;
begin
  FixupStub('WSAJoinLeaf', @WSAJoinLeaf); {Do not Localize}
  Result := WSAJoinLeaf(s, name, namelen, lpCallerData, lpCalleeData, lpSQOS, lpGQOS, dwFlags);
end;

function Stub_WSANtohl (const s: TSocket; netlong: u_long; var lphostlong: DWORD): Integer; stdcall;
begin
  FixupStub('WSANtohl', @WSANtohl); {Do not Localize}
  Result := WSANtohl(s, netlong, lphostlong);
end;

function Stub_WSANtohs (const s: TSocket; netshort: u_short; var lphostshort: WORD): Integer; stdcall;
begin
  FixupStub('WSANtohs', @WSANtohs); {Do not Localize}
  Result := WSANtohs(s, netshort, lphostshort);
end;

function Stub_WSARecv (const s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var lpNumberOfBytesRecvd: DWORD; var lpFlags: DWORD; AOverlapped: Pointer; lpCompletionRoutine: LPwsaoverlapped_COMPLETION_ROUTINE): Integer; stdcall;
begin
  FixupStub('WSARecv', @WSARecv); {Do not Localize}
  Result := WSARecv(s, lpBuffers, dwBufferCount, lpNumberOfBytesRecvd, lpFlags, AOverlapped, lpCompletionRoutine);
end;

function Stub_WSARecvDisconnect (const s: TSocket; lpInboundDisconnectData: LPWSABUF): Integer; stdcall;
begin
  FixupStub('WSARecvDisconnect', @WSARecvDisconnect); {Do not Localize}
  Result := WSARecvDisconnect(s, lpInboundDisconnectData);
end;

function Stub_WSARecvFrom (const s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var lpNumberOfBytesRecvd: DWORD; var lpFlags: DWORD; lpFrom: PSockAddr; lpFromlen: PInteger; AOverlapped: Pointer; lpCompletionRoutine: LPwsaoverlapped_COMPLETION_ROUTINE): Integer; stdcall;
begin
  FixupStub('WSARecvFrom', @WSARecvFrom); {Do not Localize}
  Result := WSARecvFrom(s, lpBuffers, dwBufferCount, lpNumberOfBytesRecvd, lpFlags, lpFrom, lpFromlen, AOverlapped, lpCompletionRoutine);
end;

function Stub_WSAResetEvent (hEvent: wsaevent): WordBool; stdcall;
begin
  FixupStub('WSAResetEvent', @WSAResetEvent); {Do not Localize}
  Result := WSAResetEvent(hEvent);
end;

function Stub_WSASend (const s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var lpNumberOfBytesSent: DWORD; dwFlags: DWORD; AOverlapped: Pointer; lpCompletionRoutine: LPwsaoverlapped_COMPLETION_ROUTINE): Integer; stdcall;
begin
  FixupStub('WSASend', @WSASend); {Do not Localize}
  Result := WSASend(s, lpBuffers, dwBufferCount, lpNumberOfBytesSent, dwFlags, AOverlapped, lpCompletionRoutine);
end;

function Stub_WSASendDisconnect (const s: TSocket; lpOutboundDisconnectData: LPWSABUF): Integer; stdcall;
begin
  FixupStub('WSASendDisconnect', @WSASendDisconnect); {Do not Localize}
  Result := WSASendDisconnect(s, lpOutboundDisconnectData);
end;

function Stub_WSASendTo (const s: TSocket; lpBuffers: LPWSABUF; dwBufferCount: DWORD; var lpNumberOfBytesSent: DWORD; dwFlags: DWORD; lpTo: PSockAddr; iTolen: Integer; AOverlapped: Pointer; lpCompletionRoutine: LPwsaoverlapped_COMPLETION_ROUTINE): Integer; stdcall;
begin
  FixupStub('WSASendTo', @WSASendTo); {Do not Localize}
  Result := WSASendTo(s, lpBuffers, dwBufferCount, lpNumberOfBytesSent, dwFlags, lpTo, iTolen, AOverlapped, lpCompletionRoutine);
end;

function Stub_WSASetEvent (hEvent: wsaevent): WordBool; stdcall;
begin
  FixupStub('WSASetEvent', @WSASetEvent); {Do not Localize}
  Result := WSASetEvent(hEvent);
end;

function Stub_WSASocketA (af, iType, protocol: Integer; lpProtocolInfo: LPWSAProtocol_InfoA; g: GROUP; dwFlags: DWORD): TSocket; stdcall;
begin
  FixupStub('WSASocketA', @WSASocketA); {Do not Localize}
  Result := WSASocketA(af, iType, protocol, lpProtocolInfo, g, dwFlags);
end;

function Stub_WSASocketW (af, iType, protocol: Integer; lpProtocolInfo: LPWSAProtocol_InfoW; g: GROUP; dwFlags: DWORD): TSocket; stdcall;
begin
  FixupStub('WSASocketW', @WSASocketW); {Do not Localize}
  Result := WSASocketW(af, iType, protocol, lpProtocolInfo, g, dwFlags);
end;

function Stub_WSASocket (af, iType, protocol: Integer; lpProtocolInfo: LPWSAProtocol_Info; g: GROUP; dwFlags: DWORD): TSocket; stdcall;
begin
  FixupStub('WSASocket', @WSASocket); {Do not Localize}
  Result := WSASocket(af, iType, protocol, lpProtocolInfo, g, dwFlags);
end;

function Stub_WSAWaitForMultipleEvents (cEvents: DWORD; lphEvents: Pwsaevent; fWaitAll: LongBool; dwTimeout: DWORD; fAlertable: LongBool): DWORD; stdcall;
begin
  FixupStub('WSAWaitForMultipleEvents', @WSAWaitForMultipleEvents); {Do not Localize}
  Result := WSAWaitForMultipleEvents(cEvents, lphEvents, fWaitAll, dwTimeout, fAlertable);
end;

function Stub_WSAAddressToStringA (lpsaAddress: PSockAddr; const dwAddressLength: DWORD; const lpProtocolInfo: LPWSAProtocol_InfoA; const lpszAddressString: PChar; var lpdwAddressStringLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAAddressToStringA', @WSAAddressToStringA); {Do not Localize}
  Result := WSAAddressToStringA(lpsaAddress, dwAddressLength, lpProtocolInfo, lpszAddressString, lpdwAddressStringLength);
end;

function Stub_WSAAddressToStringW (lpsaAddress: PSockAddr; const dwAddressLength: DWORD; const lpProtocolInfo: LPWSAProtocol_InfoW; const lpszAddressString: PWideChar; var lpdwAddressStringLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAAddressToStringW', @WSAAddressToStringW); {Do not Localize}
  Result := WSAAddressToStringW(lpsaAddress, dwAddressLength, lpProtocolInfo, lpszAddressString, lpdwAddressStringLength);
end;

function Stub_WSAAddressToString (lpsaAddress: PSockAddr; const dwAddressLength: DWORD; const lpProtocolInfo: LPWSAProtocol_Info; const lpszAddressString: PMBChar; var lpdwAddressStringLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAAddressToString', @WSAAddressToString); {Do not Localize}
  Result := WSAAddressToString(lpsaAddress, dwAddressLength, lpProtocolInfo, lpszAddressString, lpdwAddressStringLength);
end;

function Stub_WSAStringToAddressA (const AddressString: PChar; const AddressFamily: Integer; const lpProtocolInfo: LPWSAProtocol_InfoA; var lpAddress: TSockAddr; var lpAddressLength: Integer): Integer; stdcall;
begin
  FixupStub('WSAStringToAddressA', @WSAStringToAddressA); {Do not Localize}
  Result := WSAStringToAddressA(AddressString, AddressFamily, lpProtocolInfo, lpAddress, lpAddressLength);
end;

function Stub_WSAStringToAddressW (const AddressString: PWideChar; const AddressFamily: Integer; const lpProtocolInfo: LPWSAProtocol_InfoW; var lpAddress: TSockAddr; var lpAddressLength: Integer): Integer; stdcall;
begin
  FixupStub('WSAStringToAddressW', @WSAStringToAddressW); {Do not Localize}
  Result := WSAStringToAddressW(AddressString, AddressFamily, lpProtocolInfo, lpAddress, lpAddressLength);
end;

function Stub_WSAStringToAddress (const AddressString: PMBChar; const AddressFamily: Integer; const lpProtocolInfo: LPWSAProtocol_Info; var lpAddress: TSockAddr; var lpAddressLength: Integer): Integer; stdcall;
begin
  FixupStub('WSAStringToAddress', @WSAStringToAddress); {Do not Localize}
  Result := WSAStringToAddress(AddressString, AddressFamily, lpProtocolInfo, lpAddress, lpAddressLength);
end;

function Stub_WSALookupServiceBeginA (var qsRestrictions: TWSAQuerySetA; const dwControlFlags: DWORD; var hLookup: THANDLE): Integer; stdcall;
begin
  FixupStub('WSALookupServiceBeginA', @WSALookupServiceBeginA); {Do not Localize}
  Result := WSALookupServiceBeginA(qsRestrictions, dwControlFlags, hLookup);
end;

function Stub_WSALookupServiceBeginW (var qsRestrictions: TWSAQuerySetW; const dwControlFlags: DWORD; var hLookup: THANDLE): Integer; stdcall;
begin
  FixupStub('WSALookupServiceBeginW', @WSALookupServiceBeginW); {Do not Localize}
  Result := WSALookupServiceBeginW(qsRestrictions, dwControlFlags, hLookup);
end;

function Stub_WSALookupServiceBegin (var qsRestrictions: TWSAQuerySet; const dwControlFlags: DWORD; var hLookup: THANDLE): Integer; stdcall;
begin
  FixupStub('WSALookupServiceBegin', @WSALookupServiceBegin); {Do not Localize}
  Result := WSALookupServiceBegin(qsRestrictions, dwControlFlags, hLookup);
end;

function Stub_WSALookupServiceNextA (const hLookup: THandle; const dwControlFlags: DWORD; var dwBufferLength: DWORD; lpqsResults: PWSAQuerySetA): Integer; stdcall;
begin
  FixupStub('WSALookupServiceNextA', @WSALookupServiceNextA); {Do not Localize}
  Result := WSALookupServiceNextA(hLookup, dwControlFlags, dwBufferLength, lpqsResults);
end;

function Stub_WSALookupServiceNextW (const hLookup: THandle; const dwControlFlags: DWORD; var dwBufferLength: DWORD; lpqsResults: PWSAQuerySetW): Integer; stdcall;
begin
  FixupStub('WSALookupServiceNextW', @WSALookupServiceNextW); {Do not Localize}
  Result := WSALookupServiceNextW(hLookup, dwControlFlags, dwBufferLength, lpqsResults);
end;

function Stub_WSALookupServiceNext (const hLookup: THandle; const dwControlFlags: DWORD; var dwBufferLength: DWORD; lpqsResults: PWSAQuerySet): Integer; stdcall;
begin
  FixupStub('WSALookupServiceNext', @WSALookupServiceNext); {Do not Localize}
  Result := WSALookupServiceNext(hLookup, dwControlFlags, dwBufferLength, lpqsResults);
end;

function Stub_WSALookupServiceEnd (const hLookup: THandle): Integer; stdcall;
begin
  FixupStub('WSALookupServiceEnd', @WSALookupServiceEnd); {Do not Localize}
  Result := WSALookupServiceEnd(hLookup);
end;

function Stub_WSAInstallServiceClassA (const lpServiceClassInfo: LPWSAServiceClassInfoA): Integer; stdcall;
begin
  FixupStub('WSAInstallServiceClassA', @WSAInstallServiceClassA); {Do not Localize}
  Result := WSAInstallServiceClassA(lpServiceClassInfo);
end;

function Stub_WSAInstallServiceClassW (const lpServiceClassInfo: LPWSAServiceClassInfoW): Integer; stdcall;
begin
  FixupStub('WSAInstallServiceClassW', @WSAInstallServiceClassW); {Do not Localize}
  Result := WSAInstallServiceClassW(lpServiceClassInfo);
end;

function Stub_WSAInstallServiceClass (const lpServiceClassInfo: LPWSAServiceClassInfo): Integer; stdcall;
begin
  FixupStub('WSAInstallServiceClass', @WSAInstallServiceClass); {Do not Localize}
  Result := WSAInstallServiceClass(lpServiceClassInfo);
end;

function Stub_WSARemoveServiceClass (const lpServiceClassId: PGUID): Integer; stdcall;
begin
  FixupStub('WSARemoveServiceClass', @WSARemoveServiceClass); {Do not Localize}
  Result := WSARemoveServiceClass(lpServiceClassId);
end;

function Stub_WSAGetServiceClassInfoA (const lpProviderId: PGUID; const lpServiceClassId: PGUID; var lpdwBufSize: DWORD; lpServiceClassInfo: LPWSAServiceClassInfoA): Integer; stdcall;
begin
  FixupStub('WSAGetServiceClassInfoA', @WSAGetServiceClassInfoA); {Do not Localize}
  Result := WSAGetServiceClassInfoA(lpProviderId, lpServiceClassId, lpdwBufSize, lpServiceClassInfo);
end;

function Stub_WSAGetServiceClassInfoW (const lpProviderId: PGUID; const lpServiceClassId: PGUID; var lpdwBufSize: DWORD; lpServiceClassInfo: LPWSAServiceClassInfoW): Integer; stdcall;
begin
  FixupStub('WSAGetServiceClassInfoW', @WSAGetServiceClassInfoW); {Do not Localize}
  Result := WSAGetServiceClassInfoW(lpProviderId, lpServiceClassId, lpdwBufSize, lpServiceClassInfo);
end;

function Stub_WSAGetServiceClassInfo (const lpProviderId: PGUID; const lpServiceClassId: PGUID; var lpdwBufSize: DWORD; lpServiceClassInfo: LPWSAServiceClassInfo): Integer; stdcall;
begin
  FixupStub('WSAGetServiceClassInfo', @WSAGetServiceClassInfo); {Do not Localize}
  Result := WSAGetServiceClassInfo(lpProviderId, lpServiceClassId, lpdwBufSize, lpServiceClassInfo);
end;

function Stub_WSAEnumNameSpaceProvidersA (var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoA): Integer; stdcall;
begin
  FixupStub('WSAEnumNameSpaceProvidersA', @WSAEnumNameSpaceProvidersA); {Do not Localize}
  Result := WSAEnumNameSpaceProvidersA(lpdwBufferLength, lpnspBuffer);
end;

function Stub_WSAEnumNameSpaceProvidersW (var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoW): Integer; stdcall;
begin
  FixupStub('WSAEnumNameSpaceProvidersW', @WSAEnumNameSpaceProvidersW); {Do not Localize}
  Result := WSAEnumNameSpaceProvidersW(lpdwBufferLength, lpnspBuffer);
end;

function Stub_WSAEnumNameSpaceProviders (var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_Info): Integer; stdcall;
begin
  FixupStub('WSAEnumNameSpaceProviders', @WSAEnumNameSpaceProviders); {Do not Localize}
  Result := WSAEnumNameSpaceProviders(lpdwBufferLength, lpnspBuffer);
end;

function Stub_WSAGetServiceClassNameByClassIdA (const lpServiceClassId: PGUID; lpszServiceClassName: PChar; var lpdwBufferLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAGetServiceClassNameByClassIdA', @WSAGetServiceClassNameByClassIdA); {Do not Localize}
  Result := WSAGetServiceClassNameByClassIdA(lpServiceClassId, lpszServiceClassName, lpdwBufferLength);
end;

function Stub_WSAGetServiceClassNameByClassIdW (const lpServiceClassId: PGUID; lpszServiceClassName: PWideChar; var lpdwBufferLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAGetServiceClassNameByClassIdW', @WSAGetServiceClassNameByClassIdW); {Do not Localize}
  Result := WSAGetServiceClassNameByClassIdW(lpServiceClassId, lpszServiceClassName, lpdwBufferLength);
end;

function Stub_WSAGetServiceClassNameByClassId (const lpServiceClassId: PGUID; lpszServiceClassName: PMBChar; var lpdwBufferLength: DWORD): Integer; stdcall;
begin
  FixupStub('WSAGetServiceClassNameByClassId', @WSAGetServiceClassNameByClassId); {Do not Localize}
  Result := WSAGetServiceClassNameByClassId(lpServiceClassId, lpszServiceClassName, lpdwBufferLength);
end;

function Stub_WSASetServiceA (const lpqsRegInfo: LPWSAQuerySetA; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD): Integer; stdcall;
begin
  FixupStub('WSASetServiceA', @WSASetServiceA); {Do not Localize}
  Result := WSASetServiceA(lpqsRegInfo, essoperation, dwControlFlags);
end;

function Stub_WSASetServiceW (const lpqsRegInfo: LPWSAQuerySetW; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD): Integer; stdcall;
begin
  FixupStub('WSASetServiceW', @WSASetServiceW); {Do not Localize}
  Result := WSASetServiceW(lpqsRegInfo, essoperation, dwControlFlags);
end;

function Stub_WSASetService (const lpqsRegInfo: LPWSAQuerySet; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD): Integer; stdcall;
begin
  FixupStub('WSASetService', @WSASetService); {Do not Localize}
  Result := WSASetService(lpqsRegInfo, essoperation, dwControlFlags);
end;

function Stub_WSAProviderConfigChange (var lpNotificationHandle: THandle; AOverlapped: Pointer; lpCompletionRoutine: LPwsaoverlapped_COMPLETION_ROUTINE): Integer; stdcall;
begin
  FixupStub('WSAProviderConfigChange', @WSAProviderConfigChange); {Do not Localize}
  Result := WSAProviderConfigChange(lpNotificationHandle, AOverlapped, lpCompletionRoutine);
end;

function Stub_TransmitFile (hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD; nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped; lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL; stdcall;
begin
  FixupStub('TransmitFile', @TransmitFile); {Do not Localize}
  Result := TransmitFile(hSocket, hFile, nNumberOfBytesToWrite, nNumberOfBytesPerSend, lpOverlapped, lpTransmitBuffers, dwReserved);
end;

procedure FixupStubs;
begin
  WSACleanup                       := Stub_WSACleanup;
  accept                           := Stub_accept;
  bind                             := Stub_bind;
  closesocket                      := Stub_closesocket;
  connect                          := Stub_connect;
  ioctlsocket                      := Stub_ioctlsocket;
  getpeername                      := Stub_getpeername;
  getsockname                      := Stub_getsockname;
  getsockopt                       := Stub_getsockopt;
  htonl                            := Stub_htonl;
  htons                            := Stub_htons;
  inet_addr                        := Stub_inet_addr;
  inet_ntoa                        := Stub_inet_ntoa;
  listen                           := Stub_listen;
  ntohl                            := Stub_ntohl;
  ntohs                            := Stub_ntohs;
  recv                             := Stub_recv;
  recvfrom                         := Stub_recvfrom;
  select                           := Stub_select;
  send                             := Stub_send;
  sendto                           := Stub_sendto;
  setsockopt                       := Stub_setsockopt;
  shutdown                         := Stub_shutdown;
  socket                           := Stub_socket;
  gethostbyaddr                    := Stub_gethostbyaddr;
  gethostbyname                    := Stub_gethostbyname;
  gethostname                      := Stub_gethostname;
  getservbyport                    := Stub_getservbyport;
  getservbyname                    := Stub_getservbyname;
  getprotobynumber                 := Stub_getprotobynumber;
  getprotobyname                   := Stub_getprotobyname;
  WSASetLastError                  := Stub_WSASetLastError;
  WSAGetLastError                  := Stub_WSAGetLastError;
  WSAIsBlocking                    := Stub_WSAIsBlocking;
  WSAUnhookBlockingHook            := Stub_WSAUnhookBlockingHook;
  WSASetBlockingHook               := Stub_WSASetBlockingHook;
  WSACancelBlockingCall            := Stub_WSACancelBlockingCall;
  WSAAsyncGetServByName            := Stub_WSAAsyncGetServByName;
  WSAAsyncGetServByPort            := Stub_WSAAsyncGetServByPort;
  WSAAsyncGetProtoByName           := Stub_WSAAsyncGetProtoByName;
  WSAAsyncGetProtoByNumber         := Stub_WSAAsyncGetProtoByNumber;
  WSAAsyncGetHostByName            := Stub_WSAAsyncGetHostByName;
  WSAAsyncGetHostByAddr            := Stub_WSAAsyncGetHostByAddr;
  WSACancelAsyncRequest            := Stub_WSACancelAsyncRequest;
  WSAAsyncSelect                   := Stub_WSAAsyncSelect;
  __WSAFDIsSet                     := Stub___WSAFDIsSet;
  WSAAccept                        := Stub_WSAAccept;
  WSACloseEvent                    := Stub_WSACloseEvent;
  WSAConnect                       := Stub_WSAConnect;
  WSACreateEvent                   := Stub_WSACreateEvent;
  WSADuplicateSocketA              := Stub_WSADuplicateSocketA;
  WSADuplicateSocketW              := Stub_WSADuplicateSocketW;
  WSADuplicateSocket               := Stub_WSADuplicateSocket;
  WSAEnumNetworkEvents             := Stub_WSAEnumNetworkEvents;
  WSAEnumProtocolsA                := Stub_WSAEnumProtocolsA;
  WSAEnumProtocolsW                := Stub_WSAEnumProtocolsW;
  WSAEnumProtocols                 := Stub_WSAEnumProtocols;
  WSAEventSelect                   := Stub_WSAEventSelect;
  WSAGetOverlappedResult           := Stub_WSAGetOverlappedResult;
  WSAGetQOSByName                  := Stub_WSAGetQOSByName;
  WSAHtonl                         := Stub_WSAHtonl;
  WSAHtons                         := Stub_WSAHtons;
  WSAIoctl                         := Stub_WSAIoctl;
  WSAJoinLeaf                      := Stub_WSAJoinLeaf;
  WSANtohl                         := Stub_WSANtohl;
  WSANtohs                         := Stub_WSANtohs;
  WSARecv                          := Stub_WSARecv;
  WSARecvDisconnect                := Stub_WSARecvDisconnect;
  WSARecvFrom                      := Stub_WSARecvFrom;
  WSAResetEvent                    := Stub_WSAResetEvent;
  WSASend                          := Stub_WSASend;
  WSASendDisconnect                := Stub_WSASendDisconnect;
  WSASendTo                        := Stub_WSASendTo;
  WSASetEvent                      := Stub_WSASetEvent;
  WSASocketA                       := Stub_WSASocketA;
  WSASocketW                       := Stub_WSASocketW;
  WSASocket                        := Stub_WSASocket;
  WSAWaitForMultipleEvents         := Stub_WSAWaitForMultipleEvents;
  WSAAddressToStringA              := Stub_WSAAddressToStringA;
  WSAAddressToStringW              := Stub_WSAAddressToStringW;
  WSAAddressToString               := Stub_WSAAddressToString;
  WSAStringToAddressA              := Stub_WSAStringToAddressA;
  WSAStringToAddressW              := Stub_WSAStringToAddressW;
  WSAStringToAddress               := Stub_WSAStringToAddress;
  WSALookupServiceBeginA           := Stub_WSALookupServiceBeginA;
  WSALookupServiceBeginW           := Stub_WSALookupServiceBeginW;
  WSALookupServiceBegin            := Stub_WSALookupServiceBegin;
  WSALookupServiceNextA            := Stub_WSALookupServiceNextA;
  WSALookupServiceNextW            := Stub_WSALookupServiceNextW;
  WSALookupServiceNext             := Stub_WSALookupServiceNext;
  WSALookupServiceEnd              := Stub_WSALookupServiceEnd;
  WSAInstallServiceClassA          := Stub_WSAInstallServiceClassA;
  WSAInstallServiceClassW          := Stub_WSAInstallServiceClassW;
  WSAInstallServiceClass           := Stub_WSAInstallServiceClass;
  WSARemoveServiceClass            := Stub_WSARemoveServiceClass;
  WSAGetServiceClassInfoA          := Stub_WSAGetServiceClassInfoA;
  WSAGetServiceClassInfoW          := Stub_WSAGetServiceClassInfoW;
  WSAGetServiceClassInfo           := Stub_WSAGetServiceClassInfo;
  WSAEnumNameSpaceProvidersA       := Stub_WSAEnumNameSpaceProvidersA;
  WSAEnumNameSpaceProvidersW       := Stub_WSAEnumNameSpaceProvidersW;
  WSAEnumNameSpaceProviders        := Stub_WSAEnumNameSpaceProviders;
  WSAGetServiceClassNameByClassIdA := Stub_WSAGetServiceClassNameByClassIdA;
  WSAGetServiceClassNameByClassIdW := Stub_WSAGetServiceClassNameByClassIdW;
  WSAGetServiceClassNameByClassId  := Stub_WSAGetServiceClassNameByClassId;
  WSASetServiceA                   := Stub_WSASetServiceA;
  WSASetServiceW                   := Stub_WSASetServiceW;
  WSASetService                    := Stub_WSASetService;
  WSAProviderConfigChange          := Stub_WSAProviderConfigChange;
  TransmitFile                     := Stub_TransmitFile;
{$IFDEF UNICODE}
{$ELSE}
{$ENDIF}
end;

(*
const
  WS2StubEntryCount = 108;
  WS2StubTable : Array [0..WS2StubEntryCount-1] of WS2StubEntry = (
  	(StubProc: @WS2Stub_WSACleanup; ProcVar: @@WSACleanup; Name: 'WSACleanup'),
  	(StubProc: @WS2Stub_accept; ProcVar: @@accept; Name: 'accept'),
  	(StubProc: @WS2Stub_bind; ProcVar: @@bind; Name: 'bind'),
  	(StubProc: @WS2Stub_closesocket; ProcVar: @@closesocket; Name: 'closesocket'),
  	(StubProc: @WS2Stub_connect; ProcVar: @@connect; Name: 'connect'),
  	(StubProc: @WS2Stub_ioctlsocket; ProcVar: @@ioctlsocket; Name: 'ioctlsocket'),
  	(StubProc: @WS2Stub_getpeername; ProcVar: @@getpeername; Name: 'getpeername'),
  	(StubProc: @WS2Stub_getsockname; ProcVar: @@getsockname; Name: 'getsockname'),
  	(StubProc: @WS2Stub_getsockopt; ProcVar: @@getsockopt; Name: 'getsockopt'),
  	(StubProc: @WS2Stub_htonl; ProcVar: @@htonl; Name: 'htonl'),
  	(StubProc: @WS2Stub_htons; ProcVar: @@htons; Name: 'htons'),
  	(StubProc: @WS2Stub_inet_addr; ProcVar: @@inet_addr; Name: 'inet_addr'),
  	(StubProc: @WS2Stub_inet_ntoa; ProcVar: @@inet_ntoa; Name: 'inet_ntoa'),
  	(StubProc: @WS2Stub_listen; ProcVar: @@listen; Name: 'listen'),
  	(StubProc: @WS2Stub_ntohl; ProcVar: @@ntohl; Name: 'ntohl'),
  	(StubProc: @WS2Stub_ntohs; ProcVar: @@ntohs; Name: 'ntohs'),
  	(StubProc: @WS2Stub_recv; ProcVar: @@recv; Name: 'recv'),
  	(StubProc: @WS2Stub_recvfrom; ProcVar: @@recvfrom; Name: 'recvfrom'),
  	(StubProc: @WS2Stub_select; ProcVar: @@select; Name: 'select'),
  	(StubProc: @WS2Stub_send; ProcVar: @@send; Name: 'send'),
  	(StubProc: @WS2Stub_sendto; ProcVar: @@sendto; Name: 'sendto'),
  	(StubProc: @WS2Stub_setsockopt; ProcVar: @@setsockopt; Name: 'setsockopt'),
  	(StubProc: @WS2Stub_shutdown; ProcVar: @@shutdown; Name: 'shutdown'),
  	(StubProc: @WS2Stub_socket; ProcVar: @@socket; Name: 'socket'),
  	(StubProc: @WS2Stub_gethostbyaddr; ProcVar: @@gethostbyaddr; Name: 'gethostbyaddr'),
  	(StubProc: @WS2Stub_gethostbyname; ProcVar: @@gethostbyname; Name: 'gethostbyname'),
  	(StubProc: @WS2Stub_gethostname; ProcVar: @@gethostname; Name: 'gethostname'),
  	(StubProc: @WS2Stub_getservbyport; ProcVar: @@getservbyport; Name: 'getservbyport'),
  	(StubProc: @WS2Stub_getservbyname; ProcVar: @@getservbyname; Name: 'getservbyname'),
  	(StubProc: @WS2Stub_getprotobynumber; ProcVar: @@getprotobynumber; Name: 'getprotobynumber'),
  	(StubProc: @WS2Stub_getprotobyname; ProcVar: @@getprotobyname; Name: 'getprotobyname'),
  	(StubProc: @WS2Stub_WSASetLastError; ProcVar: @@WSASetLastError; Name: 'WSASetLastError'),
  	(StubProc: @WS2Stub_WSAGetLastError; ProcVar: @@WSAGetLastError; Name: 'WSAGetLastError'),
  	(StubProc: @WS2Stub_WSAIsBlocking; ProcVar: @@WSAIsBlocking; Name: 'WSAIsBlocking'),
  	(StubProc: @WS2Stub_WSAUnhookBlockingHook; ProcVar: @@WSAUnhookBlockingHook; Name: 'WSAUnhookBlockingHook'),
  	(StubProc: @WS2Stub_WSASetBlockingHook; ProcVar: @@WSASetBlockingHook; Name: 'WSASetBlockingHook'),
  	(StubProc: @WS2Stub_WSACancelBlockingCall; ProcVar: @@WSACancelBlockingCall; Name: 'WSACancelBlockingCall'),
  	(StubProc: @WS2Stub_WSAAsyncGetServByName; ProcVar: @@WSAAsyncGetServByName; Name: 'WSAAsyncGetServByName'),
  	(StubProc: @WS2Stub_WSAAsyncGetServByPort; ProcVar: @@WSAAsyncGetServByPort; Name: 'WSAAsyncGetServByPort'),
  	(StubProc: @WS2Stub_WSAAsyncGetProtoByName; ProcVar: @@WSAAsyncGetProtoByName; Name: 'WSAAsyncGetProtoByName'),
  	(StubProc: @WS2Stub_WSAAsyncGetProtoByNumber; ProcVar: @@WSAAsyncGetProtoByNumber; Name: 'WSAAsyncGetProtoByNumber'),
  	(StubProc: @WS2Stub_WSAAsyncGetHostByName; ProcVar: @@WSAAsyncGetHostByName; Name: 'WSAAsyncGetHostByName'),
  	(StubProc: @WS2Stub_WSAAsyncGetHostByAddr; ProcVar: @@WSAAsyncGetHostByAddr; Name: 'WSAAsyncGetHostByAddr'),
  	(StubProc: @WS2Stub_WSACancelAsyncRequest; ProcVar: @@WSACancelAsyncRequest; Name: 'WSACancelAsyncRequest'),
  	(StubProc: @WS2Stub_WSAAsyncSelect; ProcVar: @@WSAAsyncSelect; Name: 'WSAAsyncSelect'),
  	(StubProc: @WS2Stub___WSAFDIsSet; ProcVar: @@__WSAFDIsSet; Name: '__WSAFDIsSet'),
  	(StubProc: @WS2Stub_WSAAccept; ProcVar: @@WSAAccept; Name: 'WSAAccept'),
  	(StubProc: @WS2Stub_WSACloseEvent; ProcVar: @@WSACloseEvent; Name: 'WSACloseEvent'),
  	(StubProc: @WS2Stub_WSAConnect; ProcVar: @@WSAConnect; Name: 'WSAConnect'),
  	(StubProc: @WS2Stub_WSACreateEvent; ProcVar: @@WSACreateEvent ; Name: 'WSACreateEvent'),
  	(StubProc: @WS2Stub_WSADuplicateSocketA; ProcVar: @@WSADuplicateSocketA; Name: 'WSADuplicateSocketA'),
  	(StubProc: @WS2Stub_WSADuplicateSocketW; ProcVar: @@WSADuplicateSocketW; Name: 'WSADuplicateSocketW'),
  	(StubProc: @WS2Stub_WSAEnumNetworkEvents; ProcVar: @@WSAEnumNetworkEvents; Name: 'WSAEnumNetworkEvents'),
  	(StubProc: @WS2Stub_WSAEnumProtocolsA; ProcVar: @@WSAEnumProtocolsA; Name: 'WSAEnumProtocolsA'),
  	(StubProc: @WS2Stub_WSAEnumProtocolsW; ProcVar: @@WSAEnumProtocolsW; Name: 'WSAEnumProtocolsW'),
  	(StubProc: @WS2Stub_WSAEventSelect; ProcVar: @@WSAEventSelect; Name: 'WSAEventSelect'),
  	(StubProc: @WS2Stub_WSAGetOverlappedResult; ProcVar: @@WSAGetOverlappedResult; Name: 'WSAGetOverlappedResult'),
  	(StubProc: @WS2Stub_WSAGetQosByName; ProcVar: @@WSAGetQosByName; Name: 'WSAGetQosByName'),
  	(StubProc: @WS2Stub_WSAHtonl; ProcVar: @@WSAHtonl; Name: 'WSAHtonl'),
  	(StubProc: @WS2Stub_WSAHtons; ProcVar: @@WSAHtons; Name: 'WSAHtons'),
  	(StubProc: @WS2Stub_WSAIoctl; ProcVar: @@WSAIoctl; Name: 'WSAIoctl'),
  	(StubProc: @WS2Stub_WSAJoinLeaf; ProcVar: @@WSAJoinLeaf; Name: 'WSAJoinLeaf'),
  	(StubProc: @WS2Stub_WSANtohl; ProcVar: @@WSANtohl; Name: 'WSANtohl'),
  	(StubProc: @WS2Stub_WSANtohs; ProcVar: @@WSANtohs; Name: 'WSANtohs'),
  	(StubProc: @WS2Stub_WSARecv; ProcVar: @@WSARecv; Name: 'WSARecv'),
  	(StubProc: @WS2Stub_WSARecvDisconnect; ProcVar: @@WSARecvDisconnect; Name: 'WSARecvDisconnect'),
  	(StubProc: @WS2Stub_WSARecvFrom; ProcVar: @@WSARecvFrom; Name: 'WSARecvFrom'),
  	(StubProc: @WS2Stub_WSAResetEvent; ProcVar: @@WSAResetEvent; Name: 'WSAResetEvent'),
  	(StubProc: @WS2Stub_WSASend; ProcVar: @@WSASend; Name: 'WSASend'),
  	(StubProc: @WS2Stub_WSASendDisconnect; ProcVar: @@WSASendDisconnect; Name: 'WSASendDisconnect'),
  	(StubProc: @WS2Stub_WSASendTo; ProcVar: @@WSASendTo; Name: 'WSASendTo'),
  	(StubProc: @WS2Stub_WSASetEvent; ProcVar: @@WSASetEvent; Name: 'WSASetEvent'),
  	(StubProc: @WS2Stub_WSASocketA; ProcVar: @@WSASocketA; Name: 'WSASocketA'),
  	(StubProc: @WS2Stub_WSASocketW; ProcVar: @@WSASocketW; Name: 'WSASocketW'),
  	(StubProc: @WS2Stub_WSAWaitForMultipleEvents; ProcVar: @@WSAWaitForMultipleEvents; Name: 'WSAWaitForMultipleEvents'),
  	(StubProc: @WS2Stub_WSAAddressToStringA; ProcVar: @@WSAAddressToStringA; Name: 'WSAAddressToStringA'),
  	(StubProc: @WS2Stub_WSAAddressToStringW; ProcVar: @@WSAAddressToStringW; Name: 'WSAAddressToStringW'),
  	(StubProc: @WS2Stub_WSAStringToAddressA; ProcVar: @@WSAStringToAddressA; Name: 'WSAStringToAddressA'),
  	(StubProc: @WS2Stub_WSAStringToAddressW; ProcVar: @@WSAStringToAddressW; Name: 'WSAStringToAddressW'),
  	(StubProc: @WS2Stub_WSALookupServiceBeginA; ProcVar: @@WSALookupServiceBeginA; Name: 'WSALookupServiceBeginA'),
  	(StubProc: @WS2Stub_WSALookupServiceBeginW; ProcVar: @@WSALookupServiceBeginW; Name: 'WSALookupServiceBeginW'),
  	(StubProc: @WS2Stub_WSALookupServiceNextA; ProcVar: @@WSALookupServiceNextA; Name: 'WSALookupServiceNextA'),
  	(StubProc: @WS2Stub_WSALookupServiceNextW; ProcVar: @@WSALookupServiceNextW; Name: 'WSALookupServiceNextW'),
  	(StubProc: @WS2Stub_WSALookupServiceEnd; ProcVar: @@WSALookupServiceEnd; Name: 'WSALookupServiceEnd'),
  	(StubProc: @WS2Stub_WSAInstallServiceClassA; ProcVar: @@WSAInstallServiceClassA; Name: 'WSAInstallServiceClassA'),
  	(StubProc: @WS2Stub_WSAInstallServiceClassW; ProcVar: @@WSAInstallServiceClassW; Name: 'WSAInstallServiceClassW'),
  	(StubProc: @WS2Stub_WSARemoveServiceClass; ProcVar: @@WSARemoveServiceClass; Name: 'WSARemoveServiceClass'),
  	(StubProc: @WS2Stub_WSAGetServiceClassInfoA; ProcVar: @@WSAGetServiceClassInfoA; Name: 'WSAGetServiceClassInfoA'),
  	(StubProc: @WS2Stub_WSAGetServiceClassInfoW; ProcVar: @@WSAGetServiceClassInfoW; Name: 'WSAGetServiceClassInfoW'),
  	(StubProc: @WS2Stub_WSAEnumNameSpaceProvidersA; ProcVar: @@WSAEnumNameSpaceProvidersA; Name: 'WSAEnumNameSpaceProvidersA'),
  	(StubProc: @WS2Stub_WSAEnumNameSpaceProvidersW; ProcVar: @@WSAEnumNameSpaceProvidersW; Name: 'WSAEnumNameSpaceProvidersW'),
  	(StubProc: @WS2Stub_WSAGetServiceClassNameByClassIdA; ProcVar: @@WSAGetServiceClassNameByClassIdA; Name: 'WSAGetServiceClassNameByClassIdA'),
  	(StubProc: @WS2Stub_WSAGetServiceClassNameByClassIdW; ProcVar: @@WSAGetServiceClassNameByClassIdW; Name: 'WSAGetServiceClassNameByClassIdW'),
  	(StubProc: @WS2Stub_WSASetServiceA; ProcVar: @@WSASetServiceA; Name: 'WSASetServiceA'),
  	(StubProc: @WS2Stub_WSASetServiceW; ProcVar: @@WSASetServiceW; Name: 'WSASetServiceW'),
  	(StubProc: @WS2Stub_WSAProviderConfigChange; ProcVar: @@WSAProviderConfigChange; Name: 'WSAProviderConfigChange'),
{$IFDEF UNICODE}
  	(StubProc: @WS2Stub_WSADuplicateSocket; ProcVar: @@WSADuplicateSocket; Name: 'WSADuplicateSocketW'),
  	(StubProc: @WS2Stub_WSAEnumProtocols; ProcVar: @@WSAEnumProtocols; Name: 'WSAEnumProtocolsW'),
  	(StubProc: @WS2Stub_WSASocket; ProcVar: @@WSASocket; Name: 'WSASocketW'),
  	(StubProc: @WS2Stub_WSAAddressToString; ProcVar: @@WSAAddressToString; Name: 'WSAAddressToStringW'),
  	(StubProc: @WS2Stub_WSAStringToAddress; ProcVar: @@WSAStringToAddress; Name: 'WSAStringToAddressW'),
  	(StubProc: @WS2Stub_WSALookupServiceBegin; ProcVar: @@WSALookupServiceBegin; Name: 'WSALookupServiceBeginW'),
  	(StubProc: @WS2Stub_WSALookupServiceNext; ProcVar: @@WSALookupServiceNext; Name: 'WSALookupServiceNextW'),
  	(StubProc: @WS2Stub_WSAInstallServiceClass; ProcVar: @@WSAInstallServiceClass; Name: 'WSAInstallServiceClassW'),
  	(StubProc: @WS2Stub_WSAGetServiceClassInfo; ProcVar: @@WSAGetServiceClassInfo; Name: 'WSAGetServiceClassInfoW'),
  	(StubProc: @WS2Stub_WSAEnumNameSpaceProviders; ProcVar: @@WSAEnumNameSpaceProviders; Name: 'WSAEnumNameSpaceProvidersW'),
  	(StubProc: @WS2Stub_WSAGetServiceClassNameByClassId; ProcVar: @@WSAGetServiceClassNameByClassId; Name: 'WSAGetServiceClassNameByClassIdW'),
  	(StubProc: @WS2Stub_WSASetService; ProcVar: @@WSASetService; Name: 'WSASetServiceW')
{$ELSE}
  	(StubProc: @WS2Stub_WSADuplicateSocket; ProcVar: @@WSADuplicateSocket; Name: 'WSADuplicateSocketA'),
  	(StubProc: @WS2Stub_WSAEnumProtocols; ProcVar: @@WSAEnumProtocols; Name: 'WSAEnumProtocolsA'),
  	(StubProc: @WS2Stub_WSASocket; ProcVar: @@WSASocket; Name: 'WSASocketA'),
  	(StubProc: @WS2Stub_WSAAddressToString; ProcVar: @@WSAAddressToString; Name: 'WSAAddressToStringA'),
  	(StubProc: @WS2Stub_WSAStringToAddress; ProcVar: @@WSAStringToAddress; Name: 'WSAStringToAddressA'),
  	(StubProc: @WS2Stub_WSALookupServiceBegin; ProcVar: @@WSALookupServiceBegin; Name: 'WSALookupServiceBeginA'),
  	(StubProc: @WS2Stub_WSALookupServiceNext; ProcVar: @@WSALookupServiceNext; Name: 'WSALookupServiceNextA'),
  	(StubProc: @WS2Stub_WSAInstallServiceClass; ProcVar: @@WSAInstallServiceClass; Name: 'WSAInstallServiceClassA'),
  	(StubProc: @WS2Stub_WSAGetServiceClassInfo; ProcVar: @@WSAGetServiceClassInfo; Name: 'WSAGetServiceClassInfoA'),
  	(StubProc: @WS2Stub_WSAEnumNameSpaceProviders; ProcVar: @@WSAEnumNameSpaceProviders; Name: 'WSAEnumNameSpaceProvidersA'),
  	(StubProc: @WS2Stub_WSAGetServiceClassNameByClassId; ProcVar: @@WSAGetServiceClassNameByClassId; Name: 'WSAGetServiceClassNameByClassIdA'),
  	(StubProc: @WS2Stub_WSASetService; ProcVar: @@WSASetService; Name: 'WSASetServiceA')
{$ENDIF}
       	);

function WS2Call( AStubEntryIndex : DWORD ) : Pointer;
begin
  with WS2StubTable[AStubEntryIndex] do
  begin
    if hWS2Dll=0 then
    begin
      raise EIdWS2StubError.Build( Format(RSWS2CallError,[Name]), WSANOTINITIALISED );
    end;
    Result := Windows.GetProcAddress( hWS2Dll, Name );
    ProcVar^ := Result;
  end;
end;

*)
function StubTransmitFile(hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD;
    nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped;
    lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL; stdcall;
begin
  @TransmitFile := GetProcAddress(LoadLibrary('WSOCK32.dll'), 'TransmitFile'); {Do not Localize}
  result := TransmitFile(hSocket, hFile, nNumberOfBytesToWrite,
    nNumberOfBytesPerSend, lpOverlapped, lpTransmitBuffers, dwReserved);
end;

(*
procedure WS2StubInit;
var i : Integer;
begin
  hWS2Dll := 0;
  for i := 0 to WS2StubEntryCount-1 do
    with WS2StubTable[i] do
      ProcVar^ := StubProc;
  @TransmitFile:=@StubTransmitFile;
end;
*)

{
IMPORTANT COMMENT!!!  DO NOT REMOVE!!!!

 Bob Quinn had noted:

WSIoctl() fails with WSAEFAULT (10014):. On Microsoft's WinSock 2
implementation for NT4 and Win95, many of the new WinSock 2 WSAIoctl() commands
fail with WSAEFAULT (10014) unless valid pointers are provided for both input
and output buffer arguments to buffers of at least 4-bytes in size, even when
either an input or output buffer isn't required by the API (as indicated by the
IOC_IN and IOC_OUT control code bits described in the WinSock 2 API
specification

See URL:  http://www.sockets.com/ws2_stat.htm

Note that I did verify this on WindowsXP Professional with Service Pack 2 on May
21, 2005
}
function ServiceQueryTransmitFile(hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD;
    nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped;
    lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD): BOOL;
const GuidTransmitFile:
  TGUID = (D1:$b5367df0; D2:$cbac; D3:$11cf; D4:($95, $ca, $00, $80, $5f, $48, $a1, $92));
var LStatus: Integer;
    LTransmitFile: TTransmitFileProc;
    LBytesSend: DWord;
    LDummy1, LDummy2 : Cardinal;

begin
  LStatus:=WSAIoctl(hSocket, SIO_GET_EXTENSION_FUNCTION_POINTER, @GuidTransmitFile, sizeof(GuidTransmitFile),
    @@LTransmitFile, sizeof(@LTransmitFile), @LBytesSend, @LDummy1, @LDummy2);
  if LStatus=0 then begin
    result := LTransmitFile(hSocket, hFile, nNumberOfBytesToWrite,nNumberOfBytesPerSend,lpOverlapped,lpTransmitBuffers,dwReserved);
    if not result then begin
      Result := GetLastError=997; // 997=ERROR_IO_PENDING
    end;
  end else begin
    result := false;//  WSAGetLastError returns 10022 when function is not supported
  end;
end;

function ServiceQueryAcceptEx(sListenSocket, sAcceptSocket: TSocket;
    lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength,
    dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD;
    lpOverlapped: POverlapped): BOOL;
const GuidAcceptEx:TGuid=(D1:$b5367df1;D2:$cbac;D3:$11cf;D4:($95,$ca,$00,$80,$5f,$48,$a1,$92));
var LStatus : integer;
    LAcceptEx : TAcceptExProc;
    LDummy1, LDummy2, LDummy3 : Cardinal;
begin
  LStatus:=WSAIoctl(sListenSocket, SIO_GET_EXTENSION_FUNCTION_POINTER, @GuidAcceptEx, sizeof(GuidAcceptEx),
    @@LAcceptEx, sizeof(@LAcceptEx), @LDummy1, @LDummy2, @LDummy3);
  if LStatus=0 then begin
    result := LAcceptEx( sListenSocket, sAcceptSocket,
      lpOutputBuffer, dwReceiveDataLength, dwLocalAddressLength,
      dwRemoteAddressLength, lpdwBytesReceived, lpOverlapped);
  end else begin
    result := false;//  WSAGetLastError returns 10022 when function is not supported
  end;
End;

//Note that the s parameter is required only because WSAIoctl requires
//a socket
procedure ServiceQueryGetAcceptExSockaddrs(s : TSocket; lpOutputBuffer: Pointer;
    dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD;
    var LocalSockaddr: TSockAddr; var LocalSockaddrLength: Integer;
    var RemoteSockaddr: TSockAddr; var RemoteSockaddrLength: Integer);
const GuidGetAcceptExSockaddrs:TGuid=(D1:$b5367df2;D2:$cbac;D3:$11cf;D4:($95,$ca,$00,$80,$5f,$48,$a1,$92));
var LStatus : integer;
    LGetAcceptExSockaddrs : TGetAcceptExSockaddrsProc;
    LDummy1, LDummy2, LDummy3 : Cardinal;
begin
  LStatus:=WSAIoctl(s,SIO_GET_EXTENSION_FUNCTION_POINTER,@GuidGetAcceptExSockaddrs, sizeof(GuidGetAcceptExSockaddrs),
    @@LGetAcceptExSockaddrs, sizeof(@LGetAcceptExSockaddrs), @LDummy1, @LDummy2, @LDummy3);
  if LStatus=0 then begin
     LGetAcceptExSockaddrs(lpOutputBuffer,dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength,
       LocalSockaddr, LocalSockaddrLength,RemoteSockaddr, RemoteSockaddrLength);
  end;
end;

{Todo:  Find out what the GUID for RecvEx really is
function ServiceQueryWSARecvEx(s: TSocket; var buf; len: Integer; var flags: Integer): Integer;
const GuidWSARecvEx:TGuid=
var LStatus : integer;
    LGetWSARecvEx : TWSARecvExProc;

begin
  LStatus:=WSAIoctl(s,SIO_GET_EXTENSION_FUNCTION_POINTER,@GuidWSARecvEx, sizeof(GuidWSARecvEx),
    @@LGetWSARecvEx, sizeof(@LGetWSARecvEx), nil, nil, nil);
  if LStatus=0 then begin
    result := LGetWSARecvEx(s,buf, len, flags);
  end else begin
    result := SOCKET_ERROR;//  WSAGetLastError returns 10022 when function is not supported
    WSASetLastError(10022);
  end;
end;          }

function ConnectEx(const s : TSocket; const name: PSockAddr; const namelen: Integer; lpSendBuffer : Pointer; dwSendDataLength : DWord; var lpdwBytesSent : DWord; lpOverlapped : LPwsaoverlapped ) : BOOL;
const GuidConnectEx:TGuid=(D1:$25a207b9;D2:$ddf3;D3:$4660;D4:($8e,$e9,$76,$e5,$8c,$74,$06,$3e));
var LStatus : integer;
    LConnectEx : TConnectExProc;
    LDummy1, LDummy2, LDummy3 : Cardinal;
begin
  LStatus:=WSAIoctl(s,SIO_GET_EXTENSION_FUNCTION_POINTER,@GuidConnectEx, sizeof(GuidConnectEx),
    @@LConnectEx, sizeof(@LConnectEx),@LDummy1, @LDummy2, @LDummy3);
  if LStatus=0 then begin
    result := LConnectEx(s, name, namelen, lpSendBuffer, dwSendDataLength, lpdwBytesSent, lpOverlapped);
  end else begin
    result := false;//  WSAGetLastError returns 10022 when function is not supported
  end;
End;

function DisconnectEx(const hSocket : TSocket; AOverlapped: Pointer; const dwFlags : DWord; const dwReserved : DWord) : BOOL;
const GuidDisConnectEx:TGuid=(D1:$7fda2e11;D2:$8630;D3:$436f;D4:($a0,$31,$f5,$36,$a6,$ee,$c1,$57));
var LStatus : integer;
   LDisConnectEx : TDisConnectExProc;
   LDummy1, LDummy2, LDummy3 : Cardinal;
begin
  LStatus:=WSAIoctl(hSocket,SIO_GET_EXTENSION_FUNCTION_POINTER,@GuidDisConnectEx, sizeof(GuidDisConnectEx),
    @@LDisConnectEx, sizeof(@LDisConnectEx), @LDummy1, @LDummy2, @LDummy3);
  if LStatus=0 then begin
    result:=LDisConnectEx(hSocket, AOverlapped,dwFlags,dwReserved);
  end else begin
    result:=false;//  WSAGetLastError returns 10022 when function is not supported
  end;
End;

function WSARecvMsg( const s : TSocket; lpMsg : PWSAMSG; var lpNumberOfBytesRecvd : DWORD; AOverlapped: Pointer; lpCompletionRoutine : LPwsaoverlapped_COMPLETION_ROUTINE ): Integer;
const GuidWSARecvMsg:TGuid=(D1:$f689d7c8;D2:$6f1f;D3:$436b;D4:($8a,$53,$e5,$4f,$e3,$51,$c3,$22));
var LStatus : integer;
    LWSARecvMsg : TWSARecvMsgProc;
    LDummy1, LDummy2, LDummy3 : Cardinal;
begin
  LStatus:=WSAIoctl(s, SIO_GET_EXTENSION_FUNCTION_POINTER, @GuidWSARecvMsg, sizeof(GuidWSARecvMsg),
    @@LWSARecvMsg, sizeof(@LWSARecvMsg), @LDummy1, @LDummy2, @LDummy3);
  if LStatus=0 then begin
    result := LWSARecvMsg(s, lpMsg, lpNumberOfBytesRecvd, AOverlapped, lpCompletionRoutine);
  end else begin
    result := SOCKET_ERROR;//  WSAGetLastError returns 10022 when function is not supported
  end;
End;

function TransmitPackets(hSocket: TSocket;
    lpPacketArray: LPTRANSMIT_PACKETS_ELEMENT;
    nElementCount: DWORD;
    nSendSize: DWORD;
    lpOverlapped: LPwsaoverlapped;
    dwFlags: DWORD): BOOL;
const GuidTransmitPackets:TGUID=(D1:$d9689da0;D2:$1f90;D3:$11d3;D4:($99,$71,$00,$c0,$4f,$68,$c8,$76));
var LStatus : integer;
    LTransmitPackets : TTransmitPacketsProc;
    LDummy1, LDummy2, LDummy3 : Cardinal;
begin
  LStatus:=WSAIoctl(hSocket, SIO_GET_EXTENSION_FUNCTION_POINTER, @GuidTransmitPackets, sizeof(GuidTransmitPackets),
    @@LTransmitPackets, sizeof(@LTransmitPackets), @LDummy1, @LDummy2, @LDummy3);
  if LStatus=0 then begin
    result := LTransmitPackets(hSocket, lpPacketArray, nElementCount, nSendSize, lpOverlapped, dwFlags);
  end else begin
    result := false;//  WSAGetLastError returns 10022 when function is not supported
  end;
End;

function WSAStartup( const wVersionRequired: word; var WSData: TWSAData ): Integer;
begin
  if hWS2Dll=0 then
  begin
    hWS2Dll := LoadLibrary( WINSOCK2_DLL );
    if hWS2Dll=0 then
    begin
      raise EIdWinsockStubError.Build( Format(RSWinsockLoadError,[WINSOCK2_DLL]), Windows.GetLastError );
    end;
    WS2_WSAStartup := TWSAStartupProc( Windows.GetProcAddress( hWS2Dll, 'WSAStartup' ) );    {Do not Localize}
    Result := WS2_WSAStartup( wVersionRequired, WSData );
  end
  else
  begin
    //actually, this not really be called if the lib is already loaded.
    Result:= 0; ///<<<<<<<<< if loaded then all ok
  end;
end;

function WSAMakeSyncReply;
begin
  WSAMakeSyncReply:= MakeLong(Buflen, Error);
end;

function WSAMakeSelectReply;
begin
  WSAMakeSelectReply:= MakeLong(Event, Error);
end;

function WSAGetAsyncBuflen;
begin
  WSAGetAsyncBuflen:= LOWORD(Param);
end;

function WSAGetAsyncError;
begin
  WSAGetAsyncError:= HIWORD(Param);
end;

function WSAGetSelectEvent;
begin
  WSAGetSelectEvent:= LOWORD(Param);
end;

function WSAGetSelectError;
begin
  WSAGetSelectError:= HIWORD(Param);
end;

procedure fd_clr(Socket: TSocket; var FDSet: TFDSet);
//var i: DWord;
var i : Integer;
begin
  i := 0;
  while i < FDSet.fd_count do
  begin
    if FDSet.fd_array[i] = Socket then
    begin
      while i < FDSet.fd_count - 1 do
      begin
        FDSet.fd_array[i] := FDSet.fd_array[i+1];
        Inc(i);
      end;
      Dec(FDSet.fd_count);
      Break;
    end;
    Inc(i);
  end;
end;

function fd_isset(Socket: TSocket; var FDSet: TFDSet): Boolean;
begin
  Result := __WSAFDIsSet(Socket, FDSet);
end;

procedure fd_set(Socket: TSocket; var FDSet: TFDSet);
begin
  if FDSet.fd_count < fd_setsize then
  begin
    FDSet.fd_array[FDSet.fd_count] := Socket;
    Inc(FDSet.fd_count);
  end;
end;

procedure fd_zero(var FDSet: TFDSet);
begin
  FDSet.fd_count := 0;
end;

//  A macro convenient for setting up NETBIOS SOCKADDRs.
{$IFDEF CIL}
procedure SET_NETBIOS_SOCKADDR( var snb : TSockAddrNB; const SnbType : Word; const Name : String; const Port : Char );
{$ELSE}
procedure SET_NETBIOS_SOCKADDR( snb : PSockAddrNB; const SnbType : Word; const Name : PChar; const Port : Char );
{$ENDIF}
var len : Integer;
begin
  if snb<>nil then with snb^ do
  begin
    snb_family := AF_NETBIOS;
    snb_type := SnbType;
    len := StrLen(Name);
    if len>=NETBIOS_NAME_LENGTH-1 then
    begin
      System.Move(Name^,snb_name,NETBIOS_NAME_LENGTH-1)
    end
    else
    begin
      if len>0 then
      begin
        System.Move(Name^,snb_name,len);
      end;
      System.FillChar( (PChar(@snb_name)+len)^, NETBIOS_NAME_LENGTH-1-len, ' ' );    {Do not Localize}
    end;
    snb_name[NETBIOS_NAME_LENGTH-1] := Port;
  end;
end;

//Macro translation of IP6OPT_TYPE
function  IP6OPT_TYPE(const o : Byte) : byte;
begin
  Result := ((o) and $c0);
end;

//This is an attempt to simulate a macro in Winnt.h

function TYPE_ALIGNMENT(const AInt : Cardinal): Cardinal;
begin
  if AInt mod 4 <> 0 then
  begin
    Result := AInt and $FFFFFFFC + 4;
  end
  else
  begin
    Result := AInt;
  end;
end;

///*
// * Alignment macros for header and data members of
// * the control buffer.
// */
function WSA_CMSGHDR_ALIGN(length : Cardinal) : Cardinal;
begin
  Result := ( ((length) + TYPE_ALIGNMENT(Cardinal(SizeOf(WSACMSGHDR)))-1) and
     ( not (TYPE_ALIGNMENT(Cardinal(SizeOf(WSACMSGHDR)))-1)) );
end;

function WSA_CMSGDATA_ALIGN(length : Cardinal) : Cardinal;
begin
  Result := ( ((length) + MAX_NATURAL_ALIGNMENT-1) and
            ( not (MAX_NATURAL_ALIGNMENT-1)) );
end;
//*
// *  WSA_CMSG_FIRSTHDR
// *
// *  Returns a pointer to the first ancillary data object,
// *  or a null pointer if there is no ancillary data in the
// *  control buffer of the WSAMSG structure.
// *
// *  LPCMSGHDR
// *  WSA_CMSG_FIRSTHDR (
// *      LPWSAMSG    msg
// *      );
// */
function WSA_CMSG_FIRSTHDR(msg : LPWSAMSG):LPWSACMSGHDR;
begin
  Result := nil;
  if msg^.Control.len >= sizeof(_WSACMSGHDR) then
  begin
    Result := LPWSACMSGHDR(msg^.Control.buf);
  end;
end;

{/*
 *  WSA_CMSG_NXTHDR
 *
 *  Returns a pointer to the next ancillary data object,
 *  or a null if there are no more data objects.
 *
 *  LPCMSGHDR
 *  WSA_CMSG_NEXTHDR (
 *      LPWSAMSG        msg,
 *      LPWSACMSGHDR    cmsg
 *      );
 */  }
function WSA_CMSG_NXTHDR(msg : LPWSAMSG; cmsg : LPWSACMSGHDR) : LPWSACMSGHDR;
//originally, the cardinal typecast was ^u_char;
begin
  if cmsg=nil then begin
    result:=WSA_CMSG_FIRSTHDR(msg);
  end else begin
  	if  ((Cardinal(cmsg) + WSA_CMSGHDR_ALIGN((cmsg)^.cmsg_len) + sizeof(WSACMSGHDR) ) >
      Cardinal ((msg)^.Control.buf) + msg^.Control.len ) then begin
  		result := nil;
  	end else begin
  	  result := LPWSACMSGHDR(Cardinal (cmsg) + WSA_CMSGHDR_ALIGN((cmsg)^.cmsg_len)) ;
  	end;
  end;
end;

{/*
 *  WSA_CMSG_DATA
 *
 *  Returns a pointer to the first byte of data (what is referred 
 *  to as the cmsg_data member though it is not defined in 
 *  the structure).
 *
 *  u_char *
 *  WSA_CMSG_DATA (
 *      LPWSACMSGHDR   pcmsg
 *      );
 */               }

function WSA_CMSG_DATA(cmsg : LPWSACMSGHDR) : Pointer;
begin
  Result := Pointer( Cardinal(cmsg) + WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR)) );
end;
{/*
 *  WSA_CMSG_SPACE
 *
 *  Returns total size of an ancillary data object given 
 *  the amount of data. Used to allocate the correct amount 
 *  of space.
 *
 *  SIZE_T
 *  WSA_CMSG_SPACE (
 *      SIZE_T length
 *      );
 */ }
function WSA_CMSG_SPACE(length : Cardinal) : Cardinal;
begin
  Result := (WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR) + WSA_CMSGHDR_ALIGN(length)))
end;
{
/*
 *  WSA_CMSG_LEN
 *
 *  Returns the value to store in cmsg_len given the amount of data.
 *
 *  SIZE_T
 *  WSA_CMSG_LEN (
 *      SIZE_T length
 *  );
 */  }
function WSA_CMSG_LEN(length : Cardinal) : Cardinal;
begin
  Result := (WSA_CMSGDATA_ALIGN(sizeof(WSACMSGHDR)) + length)
end;


initialization
  FixupStubs;
end.

