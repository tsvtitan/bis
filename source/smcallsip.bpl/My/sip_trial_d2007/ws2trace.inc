


//-------------------------------------------------------------
// Helper functions
const
	i2xtable : array [0..15] of char = '0123456789abcdef';

function c2x( Dest, Src : Pointer; len : Integer ) : Integer; assembler;
asm
	push	esi
	push	edi
  push	eax
	mov		esi,edx
	mov		edi,eax
	xor		eax,eax
	xor		edx,edx
@@loop:
	mov		al,[esi]	// lodsb
	inc		esi
	mov		dl,al
	shr		al,4
	and		dl,15
	mov		al,byte ptr[i2xtable+eax]
	mov   [edi],al
	inc		edi
	mov		al,byte ptr[i2xtable+edx]
	mov   [edi],al
	inc		edi
	loop	@@loop
	mov		eax,edi
  pop		edx
  sub		eax,edx
	pop		edi
	pop		esi
end;


function p2x( const ptr : Pointer; len : Integer ) : String;
begin
	if (ptr=nil) then Result := 'nil'
	else
		begin
			Result := IntToHex(DWORD(ptr),8);
			if (len>0)and(len<32) then
			begin
				SetLength(Result,len+len+12);
				(PChar(Result)+8)^ := '-';
				(PChar(Result)+9)^ := '>';
				c2x(PChar(Result)+10,ptr,len);
			end;
		end
end;

function DumpToBuf( Dest, Src : Pointer; len : Integer ) : Integer; assembler;
asm
	push	esi
	push	edi
  push	eax
	push	ebx
	mov		esi,edx
	mov		edi,eax
	xor		eax,eax
	xor		ebx,ebx
	xor		edx,edx
	jmp		@@enter
@@loop:
	inc		bl
	mov		al,bl
	and		al,15
	jnz   @@1
	mov		word ptr [edi],$0a0d
	inc		edi
	jmp		@@2
@@1:
	mov		byte ptr [edi],' '
	inc		edi
	and		al,3
	jnz   @@enter
	mov		byte ptr [edi],' '
@@2:
	inc		edi
@@enter:
	lodsb
	mov		dl,al
	shr		al,4
	and		dl,15
	mov		al,byte ptr[i2xtable+eax]
	mov   [edi],al
	inc		edi
	mov		al,byte ptr[i2xtable+edx]
	mov   [edi],al
	inc		edi
	loop	@@loop
	mov		eax,edi
	pop		ebx
  pop		edx
  sub		eax,edx
	pop		edi
	pop		esi
end;

function dump( ptr : Pointer; len : Integer ) : String;
begin
	Result := '';
	if (len<=0)or(ptr=nil) then Exit;
	SetLength(Result,(len*3)+((len-1) shr 2)-1);
	DumpToBuf(Pointer(Result),ptr,len);
end;

procedure Trace( AFormat : String; Args : array of const );
begin
	try
		OutputDebugString(PChar(Format(AFormat,Args)));
	except
		on E:Exception do
		begin
			OutputDebugString(PChar(E.ClassName+' on Winsock2.Trace('''+AFormat+''',...): '+E.Message));
		end;			
	end;
end;

//-------------------------------------------------------------

{$IFDEF WS2_DLL_DYNAMIC_LOAD}
const
	WS2_EntryCount = 100;
{$IFDEF WS2_MS_EXTENTION}
	MSWS_EntryCount = 4;
{$ENDIF} // WS2_MS_EXTENTION
var
	WS2_Entry : Array [0..WS2_EntryCount-1] of Pointer;

function WS2_EntryAddress( AIndex : Integer; AFuncName : PChar ) : Pointer;
var pVar : PPointer;
begin
	pVar := PPointer(@WS2_Entry[AIndex]);
	if pVar^=nil then
	begin
		if hWS2Dll=0 then
			raise EWS2StubError.Build( 'Error on call Winsock2 library function '''+AFuncName+'''', WSANOTINITIALISED );
{$IFDEF WS2_MS_EXTENTION}
		if Integer(AIndex) >= (WS2_EntryCount-MSWS_EntryCount) then
			begin
				if hMSWSDll=0 then
				begin
					hMSWSDll := LoadLibrary( MSWSOCK_DLL );
					if hMSWSDll=0 then
					begin
						// TODO: Microsoft extension functions
	
						raise EWS2StubError.Build( 'Can''t load Microsoft Winsock2 Extension library('+MSWSOCK_DLL+')', WSANOTINITIALISED );
					end;
				end;
				pVar^ := Windows.GetProcAddress( hMSWSDll, AFuncName );
			end
		else
{$ENDIF} // WS2_MS_EXTENTION
			pVar^ := Windows.GetProcAddress( hWS2Dll, AFuncName );
	end;
	Result := pVar^;
end;

{$ELSE}
function WS2_WSAStartup( const wVersionRequired: word; var WSData: TWSAData ): Integer; external WINSOCK2_DLL name 'WSAStartup';
function WS2_WSACleanup: Integer; external WINSOCK2_DLL name 'WSACleanup';
function WS2_accept( const s: TSocket; addr: PSockAddr; addrlen: PInteger ): TSocket; external WINSOCK2_DLL name 'accept';
function WS2_bind( const s: TSocket; const name: PSockAddr; const namelen: Integer ): Integer; external WINSOCK2_DLL name 'bind';
function WS2_closesocket( const s: TSocket ): Integer; external WINSOCK2_DLL name 'closesocket';
function WS2_connect( const s: TSocket; const name: PSockAddr; const namelen: Integer): Integer; external WINSOCK2_DLL name 'connect';
function WS2_ioctlsocket( const s: TSocket; const cmd: DWORD; var arg: u_long ): Integer; external WINSOCK2_DLL name 'ioctlsocket';
function WS2_getpeername( const s: TSocket; const name: PSockAddr; var namelen: Integer ): Integer; external WINSOCK2_DLL name 'getpeername';
function WS2_getsockname( const s: TSocket; const name: PSockAddr; var namelen: Integer ): Integer; external WINSOCK2_DLL name 'getsockname';
function WS2_getsockopt( const s: TSocket; const level, optname: Integer; optval: PChar; var optlen: Integer ): Integer; external WINSOCK2_DLL name 'getsockopt';
function WS2_htonl(hostlong: u_long): u_long; external WINSOCK2_DLL name 'htonl';
function WS2_htons(hostshort: u_short): u_short; external WINSOCK2_DLL name 'htons';
function WS2_inet_addr(cp: PChar): u_long; external WINSOCK2_DLL name 'inet_addr';
function WS2_inet_ntoa(inaddr: TInAddr): PChar; external WINSOCK2_DLL name 'inet_ntoa';
function WS2_listen( const s: TSocket; backlog: Integer ): Integer; external WINSOCK2_DLL name 'listen';
function WS2_ntohl(netlong: u_long): u_long; external WINSOCK2_DLL name 'ntohl';
function WS2_ntohs(netshort: u_short): u_short; external WINSOCK2_DLL name 'ntohs';
function WS2_recv( const s: TSocket; var Buf; len, flags: Integer ): Integer; external WINSOCK2_DLL name 'recv';
function WS2_recvfrom( const s: TSocket; var Buf; len, flags: Integer; from: PSockAddr; fromlen: PInteger ): Integer; external WINSOCK2_DLL name 'recvfrom';
function WS2_select(nfds: Integer; readfds, writefds, exceptfds: PFDSet; timeout: PTimeVal ): Integer; external WINSOCK2_DLL name 'select';
function WS2_send( const s: TSocket; var Buf; len, flags: Integer ): Integer; external WINSOCK2_DLL name 'send';
function WS2_sendto( const s: TSocket; var Buf; const len, flags: Integer; const addrto: PSockAddr; const tolen: Integer ): Integer; external WINSOCK2_DLL name 'sendto';
function WS2_setsockopt( const s: TSocket; const level, optname: Integer; optval: PChar; const optlen: Integer ): Integer; external WINSOCK2_DLL name 'setsockopt';
function WS2_shutdown( const s: TSocket; const how: Integer ): Integer; external WINSOCK2_DLL name 'shutdown';
function WS2_socket( const af, struct, protocol: Integer ): TSocket; external WINSOCK2_DLL name 'socket';
function WS2_gethostbyaddr( addr: Pointer; const len, addrtype: Integer ): PHostEnt; external WINSOCK2_DLL name 'gethostbyaddr';
function WS2_gethostbyname( name: PChar ): PHostEnt; external WINSOCK2_DLL name 'gethostbyname';
function WS2_gethostname( name: PChar; len: Integer ): Integer; external WINSOCK2_DLL name 'gethostname';
function WS2_getservbyport( const port: Integer; const proto: PChar ): PServEnt; external WINSOCK2_DLL name 'getservbyport';
function WS2_getservbyname( const name, proto: PChar ): PServEnt; external WINSOCK2_DLL name 'getservbyname';
function WS2_getprotobynumber( const proto: Integer ): PProtoEnt; external WINSOCK2_DLL name 'getprotobynumber';
function WS2_getprotobyname( const name: PChar ): PProtoEnt; external WINSOCK2_DLL name 'getprotobyname';
procedure WS2_WSASetLastError( const iError: Integer ); external WINSOCK2_DLL name 'WSASetLastError';
function WS2_WSAGetLastError: Integer; external WINSOCK2_DLL name 'WSAGetLastError';
function WS2_WSAIsBlocking: BOOL; external WINSOCK2_DLL name 'WSAIsBlocking';
function WS2_WSAUnhookBlockingHook: Integer; external WINSOCK2_DLL name 'WSAUnhookBlockingHook';
function WS2_WSASetBlockingHook( lpBlockFunc: TFarProc ): TFarProc; external WINSOCK2_DLL name 'WSASetBlockingHook';
function WS2_WSACancelBlockingCall: Integer; external WINSOCK2_DLL name 'WSACancelBlockingCall';
function WS2_WSAAsyncGetServByName( HWindow: HWND; wMsg: u_int; name, proto, buf: PChar; buflen: Integer ): THandle; external WINSOCK2_DLL name 'WSAAsyncGetServByName';
function WS2_WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int; proto, buf: PChar; buflen: Integer ): THandle; external WINSOCK2_DLL name 'WSAAsyncGetServByPort';
function WS2_WSAAsyncGetProtoByName( HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer ): THandle; external WINSOCK2_DLL name 'WSAAsyncGetProtoByName';
function WS2_WSAAsyncGetProtoByNumber( HWindow: HWND; wMsg: u_int; number: Integer; buf: PChar; buflen: Integer ): THandle; external WINSOCK2_DLL name 'WSAAsyncGetProtoByNumber';
function WS2_WSAAsyncGetHostByName( HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer ): THandle; external WINSOCK2_DLL name 'WSAAsyncGetHostByName';
function WS2_WSAAsyncGetHostByAddr( HWindow: HWND; wMsg: u_int; addr: PChar; len, struct: Integer; buf: PChar; buflen: Integer ): THandle; external WINSOCK2_DLL name 'WSAAsyncGetHostByAddr';
function WS2_WSACancelAsyncRequest( hAsyncTaskHandle: THandle ): Integer; external WINSOCK2_DLL name 'WSACancelAsyncRequest';
function WS2_WSAAsyncSelect( const s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint ): Integer; external WINSOCK2_DLL name 'WSAAsyncSelect';
function WS2___WSAFDIsSet( const s: TSocket; var FDSet: TFDSet ): Bool; external WINSOCK2_DLL name '__WSAFDIsSet';
function WS2_WSAAccept( const s : TSocket; addr : PSockAddr; addrlen : PInteger; lpfnCondition : LPCONDITIONPROC; const dwCallbackData : DWORD ): TSocket; external WINSOCK2_DLL name 'WSAAccept';
function WS2_WSACloseEvent( const hEvent : WSAEVENT ) : WordBool; external WINSOCK2_DLL name 'WSACloseEvent';
function WS2_WSAConnect( const s : TSocket; const name : PSockAddr; const namelen : Integer; lpCallerData,lpCalleeData : LPWSABUF; lpSQOS,lpGQOS : LPQOS ) : Integer; external WINSOCK2_DLL name 'WSAConnect';
function WS2_WSACreateEvent : WSAEVENT; external WINSOCK2_DLL name 'WSACreateEvent ';
function WS2_WSADuplicateSocketA( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_InfoA ) : Integer; external WINSOCK2_DLL name 'WSADuplicateSocketA';
function WS2_WSADuplicateSocketW( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_InfoW ) : Integer; external WINSOCK2_DLL name 'WSADuplicateSocketW';
function WS2_WSAEnumNetworkEvents( const s : TSocket; const hEventObject : WSAEVENT; lpNetworkEvents : LPWSANETWORKEVENTS ) :Integer; external WINSOCK2_DLL name 'WSAEnumNetworkEvents';
function WS2_WSAEnumProtocolsA( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_InfoA; var lpdwBufferLength : DWORD ) : Integer; external WINSOCK2_DLL name 'WSAEnumProtocolsA';
function WS2_WSAEnumProtocolsW( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_InfoW; var lpdwBufferLength : DWORD ) : Integer; external WINSOCK2_DLL name 'WSAEnumProtocolsW';
function WS2_WSAEventSelect( const s : TSocket; const hEventObject : WSAEVENT; lNetworkEvents : LongInt ): Integer; external WINSOCK2_DLL name 'WSAEventSelect';
function WS2_WSAGetOverlappedResult( const s : TSocket; lpOverlapped : LPWSAOVERLAPPED; lpcbTransfer : LPDWORD; fWait : BOOL; var lpdwFlags : DWORD ) : WordBool; external WINSOCK2_DLL name 'WSAGetOverlappedResult';
function WS2_WSAGetQosByName( const s : TSocket; lpQOSName : LPWSABUF; lpQOS : LPQOS ): WordBool; external WINSOCK2_DLL name 'WSAGetQosByName';
function WS2_WSAHtonl( const s : TSocket; hostlong : u_long; var lpnetlong : DWORD ): Integer; external WINSOCK2_DLL name 'WSAHtonl';
function WS2_WSAHtons( const s : TSocket; hostshort : u_short; var lpnetshort : WORD ): Integer; external WINSOCK2_DLL name 'WSAHtons';
function WS2_WSAIoctl( const s : TSocket; dwIoControlCode : DWORD; lpvInBuffer : Pointer; cbInBuffer : DWORD; lpvOutBuffer : Pointer; cbOutBuffer : DWORD;
  lpcbBytesReturned : LPDWORD; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ) : Integer; external WINSOCK2_DLL name 'WSAIoctl';
function WS2_WSAJoinLeaf( const s : TSocket; name : PSockAddr; namelen : Integer; lpCallerData,lpCalleeData : LPWSABUF;
  lpSQOS,lpGQOS : LPQOS; dwFlags : DWORD ) : TSocket; external WINSOCK2_DLL name 'WSAJoinLeaf';
function WS2_WSANtohl( const s : TSocket; netlong : u_long; var lphostlong : DWORD ): Integer; external WINSOCK2_DLL name 'WSANtohl';
function WS2_WSANtohs( const s : TSocket; netshort : u_short; var lphostshort : WORD ): Integer; external WINSOCK2_DLL name 'WSANtohs';
function WS2_WSARecv( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
  lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; external WINSOCK2_DLL name 'WSARecv';
function WS2_WSARecvDisconnect( const s : TSocket; lpInboundDisconnectData : LPWSABUF ): Integer; external WINSOCK2_DLL name 'WSARecvDisconnect';
function WS2_WSARecvFrom( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
  lpFrom : PSockAddr; lpFromlen : PInteger; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; external WINSOCK2_DLL name 'WSARecvFrom';
function WS2_WSAResetEvent( hEvent : WSAEVENT ): WordBool; external WINSOCK2_DLL name 'WSAResetEvent';
function WS2_WSASend( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesSent : DWORD; dwFlags : DWORD;
  lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; external WINSOCK2_DLL name 'WSASend';
function WS2_WSASendDisconnect( const s : TSocket; lpOutboundDisconnectData : LPWSABUF ): Integer; external WINSOCK2_DLL name 'WSASendDisconnect';
function WS2_WSASendTo( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesSent : DWORD; dwFlags : DWORD;
  lpTo : PSockAddr; iTolen : Integer; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; external WINSOCK2_DLL name 'WSASendTo';
function WS2_WSASetEvent( hEvent : WSAEVENT ): WordBool; external WINSOCK2_DLL name 'WSASetEvent';
function WS2_WSASocketA( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_InfoA; g : GROUP; dwFlags : DWORD ): TSocket; external WINSOCK2_DLL name 'WSASocketA';
function WS2_WSASocketW( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_InfoW; g : GROUP; dwFlags : DWORD ): TSocket; external WINSOCK2_DLL name 'WSASocketW';
function WS2_WSAWaitForMultipleEvents( cEvents : DWORD; lphEvents : PWSAEVENT; fWaitAll : LongBool;
  dwTimeout : DWORD; fAlertable : LongBool ): DWORD; external WINSOCK2_DLL name 'WSAWaitForMultipleEvents';
function WS2_WSAAddressToStringA( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_InfoA;
  const lpszAddressString : PChar; var lpdwAddressStringLength : DWORD ): Integer; external WINSOCK2_DLL name 'WSAAddressToStringA';
function WS2_WSAAddressToStringW( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_InfoW;
  const lpszAddressString : PWideChar; var lpdwAddressStringLength : DWORD ): Integer; external WINSOCK2_DLL name 'WSAAddressToStringW';
function WS2_WSAStringToAddressA( const AddressString : PChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_InfoA;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; external WINSOCK2_DLL name 'WSAStringToAddressA';
function WS2_WSAStringToAddressW( const AddressString : PWideChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_InfoW;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; external WINSOCK2_DLL name 'WSAStringToAddressW';
function WS2_WSALookupServiceBeginA( var qsRestrictions : TWSAQuerySetA; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; external WINSOCK2_DLL name 'WSALookupServiceBeginA';
function WS2_WSALookupServiceBeginW( var qsRestrictions : TWSAQuerySetW; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; external WINSOCK2_DLL name 'WSALookupServiceBeginW';
function WS2_WSALookupServiceNextA( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySetA ): Integer; external WINSOCK2_DLL name 'WSALookupServiceNextA';
function WS2_WSALookupServiceNextW( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySetW ): Integer; external WINSOCK2_DLL name 'WSALookupServiceNextW';
function WS2_WSALookupServiceEnd( const hLookup : THandle ): Integer; external WINSOCK2_DLL name 'WSALookupServiceEnd';
function WS2_WSAInstallServiceClassA( const lpServiceClassInfo : LPWSAServiceClassInfoA ) : Integer; external WINSOCK2_DLL name 'WSAInstallServiceClassA';
function WS2_WSAInstallServiceClassW( const lpServiceClassInfo : LPWSAServiceClassInfoW ) : Integer; external WINSOCK2_DLL name 'WSAInstallServiceClassW';
function WS2_WSARemoveServiceClass( const lpServiceClassId : PGUID ) : Integer; external WINSOCK2_DLL name 'WSARemoveServiceClass';
function WS2_WSAGetServiceClassInfoA( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfoA ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassInfoA';
function WS2_WSAGetServiceClassInfoW( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfoW ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassInfoW';
function WS2_WSAEnumNameSpaceProvidersA( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoA ): Integer; external WINSOCK2_DLL name 'WSAEnumNameSpaceProvidersA';
function WS2_WSAEnumNameSpaceProvidersW( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoW ): Integer; external WINSOCK2_DLL name 'WSAEnumNameSpaceProvidersW';
function WS2_WSAGetServiceClassNameByClassIdA( const lpServiceClassId: PGUID; lpszServiceClassName: PChar; var lpdwBufferLength: DWORD ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassNameByClassIdA';
function WS2_WSAGetServiceClassNameByClassIdW( const lpServiceClassId: PGUID; lpszServiceClassName: PWideChar; var lpdwBufferLength: DWORD ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassNameByClassIdW';
function WS2_WSASetServiceA( const lpqsRegInfo: LPWSAQuerySetA; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; external WINSOCK2_DLL name 'WSASetServiceA';
function WS2_WSASetServiceW( const lpqsRegInfo: LPWSAQuerySetW; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; external WINSOCK2_DLL name 'WSASetServiceW';
function WS2_WSAProviderConfigChange( var lpNotificationHandle : THandle; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ) : Integer; external WINSOCK2_DLL name 'WSAProviderConfigChange';
{$IFDEF WS2_MS_EXTENTION}
function WS2_TransmitFile( hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD; nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped; lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD ): BOOL; external MSWSOCK_DLL name 'TransmitFile';
function WS2_AcceptEx( sListenSocket, sAcceptSocket: TSocket; lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD; lpOverlapped: POverlapped ): BOOL; external MSWSOCK_DLL name 'AcceptEx';
procedure WS2_GetAcceptExSockaddrs( lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD; var LocalSockaddr: TSockAddr; var LocalSockaddrLength: Integer; var RemoteSockaddr: TSockAddr; var RemoteSockaddrLength: Integer); external MSWSOCK_DLL name 'GetAcceptExSockaddrs';
function WS2_WSARecvEx(s: TSocket; var buf; len: Integer; var flags: Integer): Integer; external MSWSOCK_DLL name 'WSARecvEx';
{$ENDIF} // WS2_MS_EXTENTION
{$IFDEF UNICODE}
function WS2_WSADuplicateSocket( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_Info ) : Integer; external WINSOCK2_DLL name 'WSADuplicateSocketW';
function WS2_WSAEnumProtocols( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_Info; var lpdwBufferLength : DWORD ) : Integer; external WINSOCK2_DLL name 'WSAEnumProtocolsW';
function WS2_WSASocket( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_Info; g : GROUP; dwFlags : DWORD ): TSocket; external WINSOCK2_DLL name 'WSASocketW';
function WS2_WSAAddressToString( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_Info;
  const lpszAddressString : PMBChar; var lpdwAddressStringLength : DWORD ): Integer; external WINSOCK2_DLL name 'WSAAddressToStringW';
function WS2_WSAStringToAddress( const AddressString : PMBChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_Info;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; external WINSOCK2_DLL name 'WSAStringToAddressW';
function WS2_WSALookupServiceBegin( var qsRestrictions : TWSAQuerySet; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; external WINSOCK2_DLL name 'WSALookupServiceBeginW';
function WS2_WSALookupServiceNext( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySet ): Integer; external WINSOCK2_DLL name 'WSALookupServiceNextW';
function WS2_WSAInstallServiceClass( const lpServiceClassInfo : LPWSAServiceClassInfo ) : Integer; external WINSOCK2_DLL name 'WSAInstallServiceClassW';
function WS2_WSAGetServiceClassInfo( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfo ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassInfoW';
function WS2_WSAEnumNameSpaceProviders( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_Info ): Integer; external WINSOCK2_DLL name 'WSAEnumNameSpaceProvidersW';
function WS2_WSAGetServiceClassNameByClassId( const lpServiceClassId: PGUID; lpszServiceClassName: PMBChar; var lpdwBufferLength: DWORD ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassNameByClassIdW';
function WS2_WSASetService( const lpqsRegInfo: LPWSAQuerySet; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; external WINSOCK2_DLL name 'WSASetServiceW';
{$ELSE}
function WS2_WSADuplicateSocket( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_Info ) : Integer; external WINSOCK2_DLL name 'WSADuplicateSocketA';
function WS2_WSAEnumProtocols( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_Info; var lpdwBufferLength : DWORD ) : Integer; external WINSOCK2_DLL name 'WSAEnumProtocolsA';
function WS2_WSASocket( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_Info; g : GROUP; dwFlags : DWORD ): TSocket; external WINSOCK2_DLL name 'WSASocketA';
function WS2_WSAAddressToString( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_Info;
  const lpszAddressString : PMBChar; var lpdwAddressStringLength : DWORD ): Integer; external WINSOCK2_DLL name 'WSAAddressToStringA';
function WS2_WSAStringToAddress( const AddressString : PMBChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_Info;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; external WINSOCK2_DLL name 'WSAStringToAddressA';
function WS2_WSALookupServiceBegin( var qsRestrictions : TWSAQuerySet; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; external WINSOCK2_DLL name 'WSALookupServiceBeginA';
function WS2_WSALookupServiceNext( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySet ): Integer; external WINSOCK2_DLL name 'WSALookupServiceNextA';
function WS2_WSAInstallServiceClass( const lpServiceClassInfo : LPWSAServiceClassInfo ) : Integer; external WINSOCK2_DLL name 'WSAInstallServiceClassA';
function WS2_WSAGetServiceClassInfo( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfo ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassInfoA';
function WS2_WSAEnumNameSpaceProviders( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_Info ): Integer; external WINSOCK2_DLL name 'WSAEnumNameSpaceProvidersA';
function WS2_WSAGetServiceClassNameByClassId( const lpServiceClassId: PGUID; lpszServiceClassName: PMBChar; var lpdwBufferLength: DWORD ): Integer; external WINSOCK2_DLL name 'WSAGetServiceClassNameByClassIdA';
function WS2_WSASetService( const lpqsRegInfo: LPWSAQuerySet; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; external WINSOCK2_DLL name 'WSASetServiceA';
{$ENDIF}
{$ENDIF}

function WSACleanup: Integer; 
begin
	if WS2TraceSwitch and(trc_WSACleanup in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSACleanup',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSACLEANUP(WS2_EntryAddress(0,'WSACleanup'));
{$ELSE}
	Result := WS2_WSACleanup;
{$ENDIF}
end;

function accept( const s: TSocket; addr: PSockAddr; addrlen: PInteger ): TSocket; 
begin
	if WS2TraceSwitch and(trc_accept in WS2TraceMask) then
		Trace('%.4x: WS2_32.accept s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_ACCEPT(WS2_EntryAddress(1,'accept'))(s,addr,addrlen);
{$ELSE}
	Result := WS2_accept(s,addr,addrlen);
{$ENDIF}
end;

function bind( const s: TSocket; const name: PSockAddr; const namelen: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_bind in WS2TraceMask) then
		Trace('%.4x: WS2_32.bind s=%.4x name=%s namelen=%d',[GetCurrentThreadId,s,p2x(name,namelen),namelen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_BIND(WS2_EntryAddress(2,'bind'))(s,name,namelen);
{$ELSE}
	Result := WS2_bind(s,name,namelen);
{$ENDIF}
end;

function closesocket( const s: TSocket ): Integer; 
begin
	if WS2TraceSwitch and(trc_closesocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.closesocket s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_CLOSESOCKET(WS2_EntryAddress(3,'closesocket'))(s);
{$ELSE}
	Result := WS2_closesocket(s);
{$ENDIF}
end;

function connect( const s: TSocket; const name: PSockAddr; const namelen: Integer): Integer; 
begin
	if WS2TraceSwitch and(trc_connect in WS2TraceMask) then
		Trace('%.4x: WS2_32.connect s=%.4x name=%s namelen=%d',[GetCurrentThreadId,s,p2x(name,namelen),namelen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_CONNECT(WS2_EntryAddress(4,'connect'))(s,name,namelen);
{$ELSE}
	Result := WS2_connect(s,name,namelen);
{$ENDIF}
end;

function ioctlsocket( const s: TSocket; const cmd: DWORD; var arg: u_long ): Integer; 
begin
	if WS2TraceSwitch and(trc_ioctlsocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.ioctlsocket s=%.4x cmd=%.8x',[GetCurrentThreadId,s,cmd]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_IOCTLSOCKET(WS2_EntryAddress(5,'ioctlsocket'))(s,cmd,arg);
{$ELSE}
	Result := WS2_ioctlsocket(s,cmd,arg);
{$ENDIF}
end;

function getpeername( const s: TSocket; const name: PSockAddr; var namelen: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_getpeername in WS2TraceMask) then
		Trace('%.4x: WS2_32.getpeername s=%.4x namelen=%d',[GetCurrentThreadId,s,namelen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETPEERNAME(WS2_EntryAddress(6,'getpeername'))(s,name,namelen);
{$ELSE}
	Result := WS2_getpeername(s,name,namelen);
{$ENDIF}
end;

function getsockname( const s: TSocket; const name: PSockAddr; var namelen: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_getsockname in WS2TraceMask) then
		Trace('%.4x: WS2_32.getsockname s=%.4x namelen=%d',[GetCurrentThreadId,s,namelen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETSOCKNAME(WS2_EntryAddress(7,'getsockname'))(s,name,namelen);
{$ELSE}
	Result := WS2_getsockname(s,name,namelen);
{$ENDIF}
end;

function getsockopt( const s: TSocket; const level, optname: Integer; optval: PChar; var optlen: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_getsockopt in WS2TraceMask) then
		Trace('%.4x: WS2_32.getsockopt s=%.4x level=%d optname=%d',[GetCurrentThreadId,s,level,optname]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETSOCKOPT(WS2_EntryAddress(8,'getsockopt'))(s,level,optname,optval,optlen);
{$ELSE}
	Result := WS2_getsockopt(s,level,optname,optval,optlen);
{$ENDIF}
end;

function htonl(hostlong: u_long): u_long; 
begin
	if WS2TraceSwitch and(trc_htonl in WS2TraceMask) then
		Trace('%.4x: WS2_32.htonl hostlong=%.8x',[GetCurrentThreadId,hostlong]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_HTONL(WS2_EntryAddress(9,'htonl'))(hostlong);
{$ELSE}
	Result := WS2_htonl(hostlong);
{$ENDIF}
end;

function htons(hostshort: u_short): u_short; 
begin
	if WS2TraceSwitch and(trc_htons in WS2TraceMask) then
		Trace('%.4x: WS2_32.htons hostshort=%.4x',[GetCurrentThreadId,hostshort]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_HTONS(WS2_EntryAddress(10,'htons'))(hostshort);
{$ELSE}
	Result := WS2_htons(hostshort);
{$ENDIF}
end;

function inet_addr(cp: PChar): u_long; 
begin
	if WS2TraceSwitch and(trc_inet_addr in WS2TraceMask) then
		Trace('%.4x: WS2_32.inet_addr',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_INET_ADDR(WS2_EntryAddress(11,'inet_addr'))(cp);
{$ELSE}
	Result := WS2_inet_addr(cp);
{$ENDIF}
end;

function inet_ntoa(inaddr: TInAddr): PChar; 
begin
	if WS2TraceSwitch and(trc_inet_ntoa in WS2TraceMask) then
		Trace('%.4x: WS2_32.inet_ntoa',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_INET_NTOA(WS2_EntryAddress(12,'inet_ntoa'))(inaddr);
{$ELSE}
	Result := WS2_inet_ntoa(inaddr);
{$ENDIF}
end;

function listen( const s: TSocket; backlog: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_listen in WS2TraceMask) then
		Trace('%.4x: WS2_32.listen s=%.4x backlog=%d',[GetCurrentThreadId,s,backlog]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_LISTEN(WS2_EntryAddress(13,'listen'))(s,backlog);
{$ELSE}
	Result := WS2_listen(s,backlog);
{$ENDIF}
end;

function ntohl(netlong: u_long): u_long; 
begin
	if WS2TraceSwitch and(trc_ntohl in WS2TraceMask) then
		Trace('%.4x: WS2_32.ntohl netlong=%.8x',[GetCurrentThreadId,netlong]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_NTOHL(WS2_EntryAddress(14,'ntohl'))(netlong);
{$ELSE}
	Result := WS2_ntohl(netlong);
{$ENDIF}
end;

function ntohs(netshort: u_short): u_short; 
begin
	if WS2TraceSwitch and(trc_ntohs in WS2TraceMask) then
		Trace('%.4x: WS2_32.ntohs netshort=%.4x',[GetCurrentThreadId,netshort]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_NTOHS(WS2_EntryAddress(15,'ntohs'))(netshort);
{$ELSE}
	Result := WS2_ntohs(netshort);
{$ENDIF}
end;

function recv( const s: TSocket; var Buf; len, flags: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_recv in WS2TraceMask) then
		Trace('%.4x: WS2_32.recv s=%.4x len=%d flags=%d',[GetCurrentThreadId,s,len,flags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_RECV(WS2_EntryAddress(16,'recv'))(s,Buf,len,flags);
{$ELSE}
	Result := WS2_recv(s,Buf,len,flags);
{$ENDIF}
	if WS2TraceSwitch and(trc_recv in WS2TraceMask) then
		if WS2TraceRecvPackets then OutputDebugString(PChar(dump(@Buf,len)));
end;

function recvfrom( const s: TSocket; var Buf; len, flags: Integer; from: PSockAddr; fromlen: PInteger ): Integer; 
begin
	if WS2TraceSwitch and(trc_recvfrom in WS2TraceMask) then
		Trace('%.4x: WS2_32.recvfrom s=%.4x len=%d flags=%d',[GetCurrentThreadId,s,len,flags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_RECVFROM(WS2_EntryAddress(17,'recvfrom'))(s,Buf,len,flags,from,fromlen);
{$ELSE}
	Result := WS2_recvfrom(s,Buf,len,flags,from,fromlen);
{$ENDIF}
	if WS2TraceSwitch and(trc_recvfrom in WS2TraceMask) then
	begin
		Trace('%.4x: WS2_32.recvfrom from=%s',[GetCurrentThreadId,p2x(from,len)]);
		if WS2TraceRecvPackets then OutputDebugString(PChar(dump(@Buf,len)));
	end;
end;

function select(nfds: Integer; readfds, writefds, exceptfds: PFDSet; timeout: PTimeVal ): Integer; 
begin
	if WS2TraceSwitch and(trc_select in WS2TraceMask) then
		Trace('%.4x: WS2_32.select nfds=%d',[GetCurrentThreadId,nfds]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_SELECT(WS2_EntryAddress(18,'select'))(nfds,readfds,writefds,exceptfds,timeout);
{$ELSE}
	Result := WS2_select(nfds,readfds,writefds,exceptfds,timeout);
{$ENDIF}
end;

function send( const s: TSocket; var Buf; len, flags: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_send in WS2TraceMask) then
	begin
		Trace('%.4x: WS2_32.send s=%.4x len=%d flags=%d',[GetCurrentThreadId,s,len,flags]);
		if WS2TraceSendPackets then OutputDebugString(PChar(dump(@Buf,len)));
	end;
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_SEND(WS2_EntryAddress(19,'send'))(s,Buf,len,flags);
{$ELSE}
	Result := WS2_send(s,Buf,len,flags);
{$ENDIF}
end;

function sendto( const s: TSocket; var Buf; const len, flags: Integer; const addrto: PSockAddr; const tolen: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_sendto in WS2TraceMask) then
	begin
		Trace('%.4x: WS2_32.sendto s=%.4x len=%d flags=%d addrto=%s tolen=%d',[GetCurrentThreadId,s,len,flags,p2x(addrto,tolen),tolen]);
		if WS2TraceSendPackets then OutputDebugString(PChar(dump(@Buf,len)));
	end;
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_SENDTO(WS2_EntryAddress(20,'sendto'))(s,Buf,len,flags,addrto,tolen);
{$ELSE}
	Result := WS2_sendto(s,Buf,len,flags,addrto,tolen);
{$ENDIF}
end;

function setsockopt( const s: TSocket; const level, optname: Integer; optval: PChar; const optlen: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_setsockopt in WS2TraceMask) then
		Trace('%.4x: WS2_32.setsockopt s=%.4x level=%d optname=%d optval=%s optlen=%d',[GetCurrentThreadId,s,level,optname,p2x(optval,optlen),optlen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_SETSOCKOPT(WS2_EntryAddress(21,'setsockopt'))(s,level,optname,optval,optlen);
{$ELSE}
	Result := WS2_setsockopt(s,level,optname,optval,optlen);
{$ENDIF}
end;

function shutdown( const s: TSocket; const how: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_shutdown in WS2TraceMask) then
		Trace('%.4x: WS2_32.shutdown s=%.4x how=%d',[GetCurrentThreadId,s,how]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_SHUTDOWN(WS2_EntryAddress(22,'shutdown'))(s,how);
{$ELSE}
	Result := WS2_shutdown(s,how);
{$ENDIF}
end;

function socket( const af, struct, protocol: Integer ): TSocket; 
begin
	if WS2TraceSwitch and(trc_socket in WS2TraceMask) then
		Trace('%.4x: WS2_32.socket af=%d struct=%d protocol=%d',[GetCurrentThreadId,af,struct,protocol]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_SOCKET(WS2_EntryAddress(23,'socket'))(af,struct,protocol);
{$ELSE}
	Result := WS2_socket(af,struct,protocol);
{$ENDIF}
end;

function gethostbyaddr( addr: Pointer; const len, addrtype: Integer ): PHostEnt; 
begin
	if WS2TraceSwitch and(trc_gethostbyaddr in WS2TraceMask) then
		Trace('%.4x: WS2_32.gethostbyaddr addr=%s len=%d addrtype=%d',[GetCurrentThreadId,p2x(addr,len),len,addrtype]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETHOSTBYADDR(WS2_EntryAddress(24,'gethostbyaddr'))(addr,len,addrtype);
{$ELSE}
	Result := WS2_gethostbyaddr(addr,len,addrtype);
{$ENDIF}
end;

function gethostbyname( name: PChar ): PHostEnt; 
begin
	if WS2TraceSwitch and(trc_gethostbyname in WS2TraceMask) then
		Trace('%.4x: WS2_32.gethostbyname name=''%s''',[GetCurrentThreadId,name]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETHOSTBYNAME(WS2_EntryAddress(25,'gethostbyname'))(name);
{$ELSE}
	Result := WS2_gethostbyname(name);
{$ENDIF}
end;

function gethostname( name: PChar; len: Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_gethostname in WS2TraceMask) then
		Trace('%.4x: WS2_32.gethostname len=%d',[GetCurrentThreadId,len]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETHOSTNAME(WS2_EntryAddress(26,'gethostname'))(name,len);
{$ELSE}
	Result := WS2_gethostname(name,len);
{$ENDIF}
end;

function getservbyport( const port: Integer; const proto: PChar ): PServEnt; 
begin
	if WS2TraceSwitch and(trc_getservbyport in WS2TraceMask) then
		Trace('%.4x: WS2_32.getservbyport port=%d proto=''%s''',[GetCurrentThreadId,port,proto]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETSERVBYPORT(WS2_EntryAddress(27,'getservbyport'))(port,proto);
{$ELSE}
	Result := WS2_getservbyport(port,proto);
{$ENDIF}
end;

function getservbyname( const name, proto: PChar ): PServEnt; 
begin
	if WS2TraceSwitch and(trc_getservbyname in WS2TraceMask) then
		Trace('%.4x: WS2_32.getservbyname name=''%s'' proto=''%s''',[GetCurrentThreadId,name,proto]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETSERVBYNAME(WS2_EntryAddress(28,'getservbyname'))(name,proto);
{$ELSE}
	Result := WS2_getservbyname(name,proto);
{$ENDIF}
end;

function getprotobynumber( const proto: Integer ): PProtoEnt; 
begin
	if WS2TraceSwitch and(trc_getprotobynumber in WS2TraceMask) then
		Trace('%.4x: WS2_32.getprotobynumber proto=%d',[GetCurrentThreadId,proto]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETPROTOBYNUMBER(WS2_EntryAddress(29,'getprotobynumber'))(proto);
{$ELSE}
	Result := WS2_getprotobynumber(proto);
{$ENDIF}
end;

function getprotobyname( const name: PChar ): PProtoEnt; 
begin
	if WS2TraceSwitch and(trc_getprotobyname in WS2TraceMask) then
		Trace('%.4x: WS2_32.getprotobyname name=''%s''',[GetCurrentThreadId,name]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_GETPROTOBYNAME(WS2_EntryAddress(30,'getprotobyname'))(name);
{$ELSE}
	Result := WS2_getprotobyname(name);
{$ENDIF}
end;

procedure WSASetLastError( const iError: Integer ); 
begin
	if WS2TraceSwitch and(trc_WSASetLastError in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASetLastError iError=%d',[GetCurrentThreadId,iError]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	LPFN_WSASETLASTERROR(WS2_EntryAddress(31,'WSASetLastError'))(iError);
{$ELSE}
	WS2_WSASetLastError(iError);
{$ENDIF}
end;

function WSAGetLastError: Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetLastError in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetLastError',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETLASTERROR(WS2_EntryAddress(32,'WSAGetLastError'));
{$ELSE}
	Result := WS2_WSAGetLastError;
{$ENDIF}
end;

function WSAIsBlocking: BOOL; 
begin
	if WS2TraceSwitch and(trc_WSAIsBlocking in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAIsBlocking',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAISBLOCKING(WS2_EntryAddress(33,'WSAIsBlocking'));
{$ELSE}
	Result := WS2_WSAIsBlocking;
{$ENDIF}
end;

function WSAUnhookBlockingHook: Integer; 
begin
	if WS2TraceSwitch and(trc_WSAUnhookBlockingHook in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAUnhookBlockingHook',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAUNHOOKBLOCKINGHOOK(WS2_EntryAddress(34,'WSAUnhookBlockingHook'));
{$ELSE}
	Result := WS2_WSAUnhookBlockingHook;
{$ENDIF}
end;

function WSASetBlockingHook( lpBlockFunc: TFarProc ): TFarProc; 
begin
	if WS2TraceSwitch and(trc_WSASetBlockingHook in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASetBlockingHook',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASETBLOCKINGHOOK(WS2_EntryAddress(35,'WSASetBlockingHook'))(lpBlockFunc);
{$ELSE}
	Result := WS2_WSASetBlockingHook(lpBlockFunc);
{$ENDIF}
end;

function WSACancelBlockingCall: Integer; 
begin
	if WS2TraceSwitch and(trc_WSACancelBlockingCall in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSACancelBlockingCall',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSACANCELBLOCKINGCALL(WS2_EntryAddress(36,'WSACancelBlockingCall'));
{$ELSE}
	Result := WS2_WSACancelBlockingCall;
{$ENDIF}
end;

function WSAAsyncGetServByName( HWindow: HWND; wMsg: u_int; name, proto, buf: PChar; buflen: Integer ): THandle; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncGetServByName in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncGetServByName HWindow=%.8x wMsg=%.8x buflen=%d',[GetCurrentThreadId,HWindow,wMsg,buflen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCGETSERVBYNAME(WS2_EntryAddress(37,'WSAAsyncGetServByName'))(HWindow,wMsg,name,proto,buf,buflen);
{$ELSE}
	Result := WS2_WSAAsyncGetServByName(HWindow,wMsg,name,proto,buf,buflen);
{$ENDIF}
end;

function WSAAsyncGetServByPort( HWindow: HWND; wMsg, port: u_int; proto, buf: PChar; buflen: Integer ): THandle; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncGetServByPort in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncGetServByPort HWindow=%.8x wMsg=%.8x port=%.8x buflen=%d',[GetCurrentThreadId,HWindow,wMsg,port,buflen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCGETSERVBYPORT(WS2_EntryAddress(38,'WSAAsyncGetServByPort'))(HWindow,wMsg,port,proto,buf,buflen);
{$ELSE}
	Result := WS2_WSAAsyncGetServByPort(HWindow,wMsg,port,proto,buf,buflen);
{$ENDIF}
end;

function WSAAsyncGetProtoByName( HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer ): THandle; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncGetProtoByName in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncGetProtoByName HWindow=%.8x wMsg=%.8x buflen=%d',[GetCurrentThreadId,HWindow,wMsg,buflen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCGETPROTOBYNAME(WS2_EntryAddress(39,'WSAAsyncGetProtoByName'))(HWindow,wMsg,name,buf,buflen);
{$ELSE}
	Result := WS2_WSAAsyncGetProtoByName(HWindow,wMsg,name,buf,buflen);
{$ENDIF}
end;

function WSAAsyncGetProtoByNumber( HWindow: HWND; wMsg: u_int; number: Integer; buf: PChar; buflen: Integer ): THandle; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncGetProtoByNumber in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncGetProtoByNumber HWindow=%.8x wMsg=%.8x number=%d buflen=%d',[GetCurrentThreadId,HWindow,wMsg,number,buflen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCGETPROTOBYNUMBER(WS2_EntryAddress(40,'WSAAsyncGetProtoByNumber'))(HWindow,wMsg,number,buf,buflen);
{$ELSE}
	Result := WS2_WSAAsyncGetProtoByNumber(HWindow,wMsg,number,buf,buflen);
{$ENDIF}
end;

function WSAAsyncGetHostByName( HWindow: HWND; wMsg: u_int; name, buf: PChar; buflen: Integer ): THandle; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncGetHostByName in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncGetHostByName HWindow=%.8x wMsg=%.8x buflen=%d',[GetCurrentThreadId,HWindow,wMsg,buflen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCGETHOSTBYNAME(WS2_EntryAddress(41,'WSAAsyncGetHostByName'))(HWindow,wMsg,name,buf,buflen);
{$ELSE}
	Result := WS2_WSAAsyncGetHostByName(HWindow,wMsg,name,buf,buflen);
{$ENDIF}
end;

function WSAAsyncGetHostByAddr( HWindow: HWND; wMsg: u_int; addr: PChar; len, struct: Integer; buf: PChar; buflen: Integer ): THandle; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncGetHostByAddr in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncGetHostByAddr HWindow=%.8x wMsg=%.8x len=%d struct=%d buflen=%d',[GetCurrentThreadId,HWindow,wMsg,len,struct,buflen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCGETHOSTBYADDR(WS2_EntryAddress(42,'WSAAsyncGetHostByAddr'))(HWindow,wMsg,addr,len,struct,buf,buflen);
{$ELSE}
	Result := WS2_WSAAsyncGetHostByAddr(HWindow,wMsg,addr,len,struct,buf,buflen);
{$ENDIF}
end;

function WSACancelAsyncRequest( hAsyncTaskHandle: THandle ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSACancelAsyncRequest in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSACancelAsyncRequest hAsyncTaskHandle=%.8x',[GetCurrentThreadId,hAsyncTaskHandle]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSACANCELASYNCREQUEST(WS2_EntryAddress(43,'WSACancelAsyncRequest'))(hAsyncTaskHandle);
{$ELSE}
	Result := WS2_WSACancelAsyncRequest(hAsyncTaskHandle);
{$ENDIF}
end;

function WSAAsyncSelect( const s: TSocket; HWindow: HWND; wMsg: u_int; lEvent: Longint ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAAsyncSelect in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAsyncSelect s=%.4x HWindow=%.8x wMsg=%.8x',[GetCurrentThreadId,s,HWindow,wMsg]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAASYNCSELECT(WS2_EntryAddress(44,'WSAAsyncSelect'))(s,HWindow,wMsg,lEvent);
{$ELSE}
	Result := WS2_WSAAsyncSelect(s,HWindow,wMsg,lEvent);
{$ENDIF}
end;

function __WSAFDIsSet( const s: TSocket; var FDSet: TFDSet ): Bool; 
begin
	if WS2TraceSwitch and(trc___WSAFDIsSet in WS2TraceMask) then
		Trace('%.4x: WS2_32.__WSAFDIsSet s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN___WSAFDISSET(WS2_EntryAddress(45,'__WSAFDIsSet'))(s,FDSet);
{$ELSE}
	Result := WS2___WSAFDIsSet(s,FDSet);
{$ENDIF}
end;

function WSAAccept( const s : TSocket; addr : PSockAddr; addrlen : PInteger; lpfnCondition : LPCONDITIONPROC; const dwCallbackData : DWORD ): TSocket; 
begin
	if WS2TraceSwitch and(trc_WSAAccept in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAccept s=%.4x dwCallbackData=%.8x',[GetCurrentThreadId,s,dwCallbackData]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAACCEPT(WS2_EntryAddress(46,'WSAAccept'))(s,addr,addrlen,lpfnCondition,dwCallbackData);
{$ELSE}
	Result := WS2_WSAAccept(s,addr,addrlen,lpfnCondition,dwCallbackData);
{$ENDIF}
end;

function WSACloseEvent( const hEvent : WSAEVENT ) : WordBool; 
begin
	if WS2TraceSwitch and(trc_WSACloseEvent in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSACloseEvent hEvent=%.8x',[GetCurrentThreadId,hEvent]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSACLOSEEVENT(WS2_EntryAddress(47,'WSACloseEvent'))(hEvent);
{$ELSE}
	Result := WS2_WSACloseEvent(hEvent);
{$ENDIF}
end;

function WSAConnect( const s : TSocket; const name : PSockAddr; const namelen : Integer; lpCallerData,lpCalleeData : LPWSABUF; lpSQOS,lpGQOS : LPQOS ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAConnect in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAConnect s=%.4x name=%s namelen=%d',[GetCurrentThreadId,s,p2x(name,namelen),namelen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSACONNECT(WS2_EntryAddress(48,'WSAConnect'))(s,name,namelen,lpCallerData,lpCalleeData,lpSQOS,lpGQOS);
{$ELSE}
	Result := WS2_WSAConnect(s,name,namelen,lpCallerData,lpCalleeData,lpSQOS,lpGQOS);
{$ENDIF}
end;

function WSACreateEvent : WSAEVENT; 
begin
	if WS2TraceSwitch and(trc_WSACreateEvent  in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSACreateEvent ',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSACREATEEVENT (WS2_EntryAddress(49,'WSACreateEvent '));
{$ELSE}
	Result := WS2_WSACreateEvent ;
{$ENDIF}
end;

function WSADuplicateSocketA( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_InfoA ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSADuplicateSocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSADuplicateSocketA s=%.4x dwProcessId=%.8x',[GetCurrentThreadId,s,dwProcessId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSADUPLICATESOCKETA(WS2_EntryAddress(50,'WSADuplicateSocketA'))(s,dwProcessId,lpProtocolInfo);
{$ELSE}
	Result := WS2_WSADuplicateSocketA(s,dwProcessId,lpProtocolInfo);
{$ENDIF}
end;

function WSADuplicateSocketW( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_InfoW ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSADuplicateSocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSADuplicateSocketW s=%.4x dwProcessId=%.8x',[GetCurrentThreadId,s,dwProcessId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSADUPLICATESOCKETW(WS2_EntryAddress(51,'WSADuplicateSocketW'))(s,dwProcessId,lpProtocolInfo);
{$ELSE}
	Result := WS2_WSADuplicateSocketW(s,dwProcessId,lpProtocolInfo);
{$ENDIF}
end;

function WSADuplicateSocket( const s : TSocket; const dwProcessId : DWORD; lpProtocolInfo : LPWSAProtocol_Info ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSADuplicateSocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSADuplicateSocket s=%.4x dwProcessId=%.8x',[GetCurrentThreadId,s,dwProcessId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSADUPLICATESOCKET(WS2_EntryAddress(51,'WSADuplicateSocketW'))(s,dwProcessId,lpProtocolInfo);
{$ELSE}
	Result := LPFN_WSADUPLICATESOCKET(WS2_EntryAddress(50,'WSADuplicateSocketA'))(s,dwProcessId,lpProtocolInfo);
{$ENDIF}
{$ELSE}
	Result := WS2_WSADuplicateSocket(s,dwProcessId,lpProtocolInfo);
{$ENDIF}
end;

function WSAEnumNetworkEvents( const s : TSocket; const hEventObject : WSAEVENT; lpNetworkEvents : LPWSANETWORKEVENTS ) :Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumNetworkEvents in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumNetworkEvents s=%.4x hEventObject=%.8x',[GetCurrentThreadId,s,hEventObject]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAENUMNETWORKEVENTS(WS2_EntryAddress(52,'WSAEnumNetworkEvents'))(s,hEventObject,lpNetworkEvents);
{$ELSE}
	Result := WS2_WSAEnumNetworkEvents(s,hEventObject,lpNetworkEvents);
{$ENDIF}
end;

function WSAEnumProtocolsA( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_InfoA; var lpdwBufferLength : DWORD ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumProtocols in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumProtocolsA',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAENUMPROTOCOLSA(WS2_EntryAddress(53,'WSAEnumProtocolsA'))(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ELSE}
	Result := WS2_WSAEnumProtocolsA(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ENDIF}
end;

function WSAEnumProtocolsW( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_InfoW; var lpdwBufferLength : DWORD ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumProtocols in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumProtocolsW',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAENUMPROTOCOLSW(WS2_EntryAddress(54,'WSAEnumProtocolsW'))(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ELSE}
	Result := WS2_WSAEnumProtocolsW(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ENDIF}
end;

function WSAEnumProtocols( lpiProtocols : PInteger; lpProtocolBuffer : LPWSAProtocol_Info; var lpdwBufferLength : DWORD ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumProtocols in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumProtocols',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSAENUMPROTOCOLS(WS2_EntryAddress(54,'WSAEnumProtocolsW'))(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ELSE}
	Result := LPFN_WSAENUMPROTOCOLS(WS2_EntryAddress(53,'WSAEnumProtocolsA'))(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAEnumProtocols(lpiProtocols,lpProtocolBuffer,lpdwBufferLength);
{$ENDIF}
end;

function WSAEventSelect( const s : TSocket; const hEventObject : WSAEVENT; lNetworkEvents : LongInt ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEventSelect in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEventSelect s=%.4x hEventObject=%.8x',[GetCurrentThreadId,s,hEventObject]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAEVENTSELECT(WS2_EntryAddress(55,'WSAEventSelect'))(s,hEventObject,lNetworkEvents);
{$ELSE}
	Result := WS2_WSAEventSelect(s,hEventObject,lNetworkEvents);
{$ENDIF}
end;

function WSAGetOverlappedResult( const s : TSocket; lpOverlapped : LPWSAOVERLAPPED; lpcbTransfer : LPDWORD; fWait : BOOL; var lpdwFlags : DWORD ) : WordBool; 
begin
	if WS2TraceSwitch and(trc_WSAGetOverlappedResult in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetOverlappedResult s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETOVERLAPPEDRESULT(WS2_EntryAddress(56,'WSAGetOverlappedResult'))(s,lpOverlapped,lpcbTransfer,fWait,lpdwFlags);
{$ELSE}
	Result := WS2_WSAGetOverlappedResult(s,lpOverlapped,lpcbTransfer,fWait,lpdwFlags);
{$ENDIF}
end;

function WSAGetQosByName( const s : TSocket; lpQOSName : LPWSABUF; lpQOS : LPQOS ): WordBool; 
begin
	if WS2TraceSwitch and(trc_WSAGetQosByName in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetQosByName s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETQOSBYNAME(WS2_EntryAddress(57,'WSAGetQosByName'))(s,lpQOSName,lpQOS);
{$ELSE}
	Result := WS2_WSAGetQosByName(s,lpQOSName,lpQOS);
{$ENDIF}
end;

function WSAHtonl( const s : TSocket; hostlong : u_long; var lpnetlong : DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAHtonl in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAHtonl s=%.4x hostlong=%.8x',[GetCurrentThreadId,s,hostlong]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAHTONL(WS2_EntryAddress(58,'WSAHtonl'))(s,hostlong,lpnetlong);
{$ELSE}
	Result := WS2_WSAHtonl(s,hostlong,lpnetlong);
{$ENDIF}
end;

function WSAHtons( const s : TSocket; hostshort : u_short; var lpnetshort : WORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAHtons in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAHtons s=%.4x hostshort=%.4x',[GetCurrentThreadId,s,hostshort]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAHTONS(WS2_EntryAddress(59,'WSAHtons'))(s,hostshort,lpnetshort);
{$ELSE}
	Result := WS2_WSAHtons(s,hostshort,lpnetshort);
{$ENDIF}
end;

function WSAIoctl( const s : TSocket; dwIoControlCode : DWORD; lpvInBuffer : Pointer; cbInBuffer : DWORD; lpvOutBuffer : Pointer; cbOutBuffer : DWORD;
  lpcbBytesReturned : LPDWORD; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAIoctl in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAIoctl s=%.4x dwIoControlCode=%.8x cbInBuffer=%.8x cbOutBuffer=%.8x',[GetCurrentThreadId,s,dwIoControlCode,cbInBuffer,cbOutBuffer]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAIOCTL(WS2_EntryAddress(60,'WSAIoctl'))(s,dwIoControlCode,lpvInBuffer,cbInBuffer,lpvOutBuffer,cbOutBuffer,lpcbBytesReturned,lpOverlapped,lpCompletionRoutine);
{$ELSE}
	Result := WS2_WSAIoctl(s,dwIoControlCode,lpvInBuffer,cbInBuffer,lpvOutBuffer,cbOutBuffer,lpcbBytesReturned,lpOverlapped,lpCompletionRoutine);
{$ENDIF}
end;

function WSAJoinLeaf( const s : TSocket; name : PSockAddr; namelen : Integer; lpCallerData,lpCalleeData : LPWSABUF;
  lpSQOS,lpGQOS : LPQOS; dwFlags : DWORD ) : TSocket; 
begin
	if WS2TraceSwitch and(trc_WSAJoinLeaf in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAJoinLeaf s=%.4x namelen=%d dwFlags=%.8x',[GetCurrentThreadId,s,namelen,dwFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAJOINLEAF(WS2_EntryAddress(61,'WSAJoinLeaf'))(s,name,namelen,lpCallerData,lpCalleeData,lpSQOS,lpGQOS,dwFlags);
{$ELSE}
	Result := WS2_WSAJoinLeaf(s,name,namelen,lpCallerData,lpCalleeData,lpSQOS,lpGQOS,dwFlags);
{$ENDIF}
end;

function WSANtohl( const s : TSocket; netlong : u_long; var lphostlong : DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSANtohl in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSANtohl s=%.4x netlong=%.8x',[GetCurrentThreadId,s,netlong]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSANTOHL(WS2_EntryAddress(62,'WSANtohl'))(s,netlong,lphostlong);
{$ELSE}
	Result := WS2_WSANtohl(s,netlong,lphostlong);
{$ENDIF}
end;

function WSANtohs( const s : TSocket; netshort : u_short; var lphostshort : WORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSANtohs in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSANtohs s=%.4x netshort=%.4x',[GetCurrentThreadId,s,netshort]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSANTOHS(WS2_EntryAddress(63,'WSANtohs'))(s,netshort,lphostshort);
{$ELSE}
	Result := WS2_WSANtohs(s,netshort,lphostshort);
{$ENDIF}
end;

function WSARecv( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
  lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSARecv in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSARecv s=%.4x dwBufferCount=%.8x',[GetCurrentThreadId,s,dwBufferCount]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSARECV(WS2_EntryAddress(64,'WSARecv'))(s,lpBuffers,dwBufferCount,lpNumberOfBytesRecvd,lpFlags,lpOverlapped,lpCompletionRoutine);
{$ELSE}
	Result := WS2_WSARecv(s,lpBuffers,dwBufferCount,lpNumberOfBytesRecvd,lpFlags,lpOverlapped,lpCompletionRoutine);
{$ENDIF}
end;

function WSARecvDisconnect( const s : TSocket; lpInboundDisconnectData : LPWSABUF ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSARecvDisconnect in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSARecvDisconnect s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSARECVDISCONNECT(WS2_EntryAddress(65,'WSARecvDisconnect'))(s,lpInboundDisconnectData);
{$ELSE}
	Result := WS2_WSARecvDisconnect(s,lpInboundDisconnectData);
{$ENDIF}
end;

function WSARecvFrom( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesRecvd : DWORD; var lpFlags : DWORD;
  lpFrom : PSockAddr; lpFromlen : PInteger; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSARecvFrom in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSARecvFrom s=%.4x dwBufferCount=%.8x',[GetCurrentThreadId,s,dwBufferCount]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSARECVFROM(WS2_EntryAddress(66,'WSARecvFrom'))(s,lpBuffers,dwBufferCount,lpNumberOfBytesRecvd,lpFlags,lpFrom,lpFromlen,lpOverlapped,lpCompletionRoutine);
{$ELSE}
	Result := WS2_WSARecvFrom(s,lpBuffers,dwBufferCount,lpNumberOfBytesRecvd,lpFlags,lpFrom,lpFromlen,lpOverlapped,lpCompletionRoutine);
{$ENDIF}
end;

function WSAResetEvent( hEvent : WSAEVENT ): WordBool; 
begin
	if WS2TraceSwitch and(trc_WSAResetEvent in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAResetEvent hEvent=%.8x',[GetCurrentThreadId,hEvent]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSARESETEVENT(WS2_EntryAddress(67,'WSAResetEvent'))(hEvent);
{$ELSE}
	Result := WS2_WSAResetEvent(hEvent);
{$ENDIF}
end;

function WSASend( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesSent : DWORD; dwFlags : DWORD;
  lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSASend in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASend s=%.4x dwBufferCount=%.8x dwFlags=%.8x',[GetCurrentThreadId,s,dwBufferCount,dwFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASEND(WS2_EntryAddress(68,'WSASend'))(s,lpBuffers,dwBufferCount,lpNumberOfBytesSent,dwFlags,lpOverlapped,lpCompletionRoutine);
{$ELSE}
	Result := WS2_WSASend(s,lpBuffers,dwBufferCount,lpNumberOfBytesSent,dwFlags,lpOverlapped,lpCompletionRoutine);
{$ENDIF}
end;

function WSASendDisconnect( const s : TSocket; lpOutboundDisconnectData : LPWSABUF ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSASendDisconnect in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASendDisconnect s=%.4x',[GetCurrentThreadId,s]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASENDDISCONNECT(WS2_EntryAddress(69,'WSASendDisconnect'))(s,lpOutboundDisconnectData);
{$ELSE}
	Result := WS2_WSASendDisconnect(s,lpOutboundDisconnectData);
{$ENDIF}
end;

function WSASendTo( const s : TSocket; lpBuffers : LPWSABUF; dwBufferCount : DWORD; var lpNumberOfBytesSent : DWORD; dwFlags : DWORD;
  lpTo : PSockAddr; iTolen : Integer; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSASendTo in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASendTo s=%.4x dwBufferCount=%d dwFlags=%d lpTo=%s iTolen=%d',[GetCurrentThreadId,s,dwBufferCount,dwFlags,p2x(lpTo,iTolen),iTolen]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASENDTO(WS2_EntryAddress(70,'WSASendTo'))(s,lpBuffers,dwBufferCount,lpNumberOfBytesSent,dwFlags,lpTo,iTolen,lpOverlapped,lpCompletionRoutine);
{$ELSE}
	Result := WS2_WSASendTo(s,lpBuffers,dwBufferCount,lpNumberOfBytesSent,dwFlags,lpTo,iTolen,lpOverlapped,lpCompletionRoutine);
{$ENDIF}
end;

function WSASetEvent( hEvent : WSAEVENT ): WordBool; 
begin
	if WS2TraceSwitch and(trc_WSASetEvent in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASetEvent hEvent=%.8x',[GetCurrentThreadId,hEvent]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASETEVENT(WS2_EntryAddress(71,'WSASetEvent'))(hEvent);
{$ELSE}
	Result := WS2_WSASetEvent(hEvent);
{$ENDIF}
end;

function WSASocketA( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_InfoA; g : GROUP; dwFlags : DWORD ): TSocket; 
begin
	if WS2TraceSwitch and(trc_WSASocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASocketA af=%d iType=%d protocol=%d dwFlags=%.8x',[GetCurrentThreadId,af,iType,protocol,dwFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASOCKETA(WS2_EntryAddress(72,'WSASocketA'))(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ELSE}
	Result := WS2_WSASocketA(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ENDIF}
end;

function WSASocketW( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_InfoW; g : GROUP; dwFlags : DWORD ): TSocket; 
begin
	if WS2TraceSwitch and(trc_WSASocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASocketW af=%d iType=%d protocol=%d dwFlags=%.8x',[GetCurrentThreadId,af,iType,protocol,dwFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASOCKETW(WS2_EntryAddress(73,'WSASocketW'))(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ELSE}
	Result := WS2_WSASocketW(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ENDIF}
end;

function WSASocket( af, iType, protocol : Integer; lpProtocolInfo : LPWSAProtocol_Info; g : GROUP; dwFlags : DWORD ): TSocket; 
begin
	if WS2TraceSwitch and(trc_WSASocket in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASocket af=%d iType=%d protocol=%d dwFlags=%.8x',[GetCurrentThreadId,af,iType,protocol,dwFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSASOCKET(WS2_EntryAddress(73,'WSASocketW'))(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ELSE}
	Result := LPFN_WSASOCKET(WS2_EntryAddress(72,'WSASocketA'))(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ENDIF}
{$ELSE}
	Result := WS2_WSASocket(af,iType,protocol,lpProtocolInfo,g,dwFlags);
{$ENDIF}
end;

function WSAWaitForMultipleEvents( cEvents : DWORD; lphEvents : PWSAEVENT; fWaitAll : LongBool;
  dwTimeout : DWORD; fAlertable : LongBool ): DWORD; 
begin
	if WS2TraceSwitch and(trc_WSAWaitForMultipleEvents in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAWaitForMultipleEvents cEvents=%d fWaitAll=%d dwTimeout=%d fAlertable=%d',[GetCurrentThreadId,cEvents,DWORD(fWaitAll),dwTimeout,DWORD(fAlertable)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAWAITFORMULTIPLEEVENTS(WS2_EntryAddress(74,'WSAWaitForMultipleEvents'))(cEvents,lphEvents,fWaitAll,dwTimeout,fAlertable);
{$ELSE}
	Result := WS2_WSAWaitForMultipleEvents(cEvents,lphEvents,fWaitAll,dwTimeout,fAlertable);
{$ENDIF}
end;

function WSAAddressToStringA( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_InfoA;
  const lpszAddressString : PChar; var lpdwAddressStringLength : DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAAddressToString in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAddressToStringA dwAddressLength=%.8x lpszAddressString=''%s''',[GetCurrentThreadId,dwAddressLength,lpszAddressString]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAADDRESSTOSTRINGA(WS2_EntryAddress(75,'WSAAddressToStringA'))(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ELSE}
	Result := WS2_WSAAddressToStringA(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ENDIF}
end;

function WSAAddressToStringW( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_InfoW;
  const lpszAddressString : PWideChar; var lpdwAddressStringLength : DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAAddressToString in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAddressToStringW dwAddressLength=%.8x',[GetCurrentThreadId,dwAddressLength]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAADDRESSTOSTRINGW(WS2_EntryAddress(76,'WSAAddressToStringW'))(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ELSE}
	Result := WS2_WSAAddressToStringW(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ENDIF}
end;

function WSAAddressToString( lpsaAddress : PSockAddr; const dwAddressLength : DWORD; const lpProtocolInfo : LPWSAProtocol_Info;
  const lpszAddressString : PMBChar; var lpdwAddressStringLength : DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAAddressToString in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAAddressToString dwAddressLength=%.8x',[GetCurrentThreadId,dwAddressLength]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSAADDRESSTOSTRING(WS2_EntryAddress(76,'WSAAddressToStringW'))(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ELSE}
	Result := LPFN_WSAADDRESSTOSTRING(WS2_EntryAddress(75,'WSAAddressToStringA'))(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAAddressToString(lpsaAddress,dwAddressLength,lpProtocolInfo,lpszAddressString,lpdwAddressStringLength);
{$ENDIF}
end;

function WSAStringToAddressA( const AddressString : PChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_InfoA;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAStringToAddress in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAStringToAddressA AddressFamily=%d',[GetCurrentThreadId,AddressFamily]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASTRINGTOADDRESSA(WS2_EntryAddress(77,'WSAStringToAddressA'))(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ELSE}
	Result := WS2_WSAStringToAddressA(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ENDIF}
end;

function WSAStringToAddressW( const AddressString : PWideChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_InfoW;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAStringToAddress in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAStringToAddressW AddressFamily=%d',[GetCurrentThreadId,AddressFamily]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASTRINGTOADDRESSW(WS2_EntryAddress(78,'WSAStringToAddressW'))(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ELSE}
	Result := WS2_WSAStringToAddressW(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ENDIF}
end;

function WSAStringToAddress( const AddressString : PMBChar; const AddressFamily: Integer; const lpProtocolInfo : LPWSAProtocol_Info;
  var lpAddress : TSockAddr; var lpAddressLength : Integer ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAStringToAddress in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAStringToAddress AddressFamily=%d',[GetCurrentThreadId,AddressFamily]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSASTRINGTOADDRESS(WS2_EntryAddress(78,'WSAStringToAddressW'))(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ELSE}
	Result := LPFN_WSASTRINGTOADDRESS(WS2_EntryAddress(77,'WSAStringToAddressA'))(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAStringToAddress(AddressString,AddressFamily,lpProtocolInfo,lpAddress,lpAddressLength);
{$ENDIF}
end;

function WSALookupServiceBeginA( var qsRestrictions : TWSAQuerySetA; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceBegin in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceBeginA dwControlFlags=%.8x',[GetCurrentThreadId,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSALOOKUPSERVICEBEGINA(WS2_EntryAddress(79,'WSALookupServiceBeginA'))(qsRestrictions,dwControlFlags,hLookup);
{$ELSE}
	Result := WS2_WSALookupServiceBeginA(qsRestrictions,dwControlFlags,hLookup);
{$ENDIF}
end;

function WSALookupServiceBeginW( var qsRestrictions : TWSAQuerySetW; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceBegin in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceBeginW dwControlFlags=%.8x',[GetCurrentThreadId,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSALOOKUPSERVICEBEGINW(WS2_EntryAddress(80,'WSALookupServiceBeginW'))(qsRestrictions,dwControlFlags,hLookup);
{$ELSE}
	Result := WS2_WSALookupServiceBeginW(qsRestrictions,dwControlFlags,hLookup);
{$ENDIF}
end;

function WSALookupServiceBegin( var qsRestrictions : TWSAQuerySet; const dwControlFlags : DWORD; var hLookup : THANDLE ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceBegin in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceBegin dwControlFlags=%.8x',[GetCurrentThreadId,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSALOOKUPSERVICEBEGIN(WS2_EntryAddress(80,'WSALookupServiceBeginW'))(qsRestrictions,dwControlFlags,hLookup);
{$ELSE}
	Result := LPFN_WSALOOKUPSERVICEBEGIN(WS2_EntryAddress(79,'WSALookupServiceBeginA'))(qsRestrictions,dwControlFlags,hLookup);
{$ENDIF}
{$ELSE}
	Result := WS2_WSALookupServiceBegin(qsRestrictions,dwControlFlags,hLookup);
{$ENDIF}
end;

function WSALookupServiceNextA( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySetA ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceNext in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceNextA hLookup=%.8x dwControlFlags=%.8x',[GetCurrentThreadId,hLookup,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSALOOKUPSERVICENEXTA(WS2_EntryAddress(81,'WSALookupServiceNextA'))(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ELSE}
	Result := WS2_WSALookupServiceNextA(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ENDIF}
end;

function WSALookupServiceNextW( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySetW ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceNext in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceNextW hLookup=%.8x dwControlFlags=%.8x',[GetCurrentThreadId,hLookup,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSALOOKUPSERVICENEXTW(WS2_EntryAddress(82,'WSALookupServiceNextW'))(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ELSE}
	Result := WS2_WSALookupServiceNextW(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ENDIF}
end;

function WSALookupServiceNext( const hLookup : THandle; const dwControlFlags : DWORD; var dwBufferLength : DWORD; lpqsResults : PWSAQuerySet ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceNext in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceNext hLookup=%.8x dwControlFlags=%.8x',[GetCurrentThreadId,hLookup,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSALOOKUPSERVICENEXT(WS2_EntryAddress(82,'WSALookupServiceNextW'))(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ELSE}
	Result := LPFN_WSALOOKUPSERVICENEXT(WS2_EntryAddress(81,'WSALookupServiceNextA'))(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ENDIF}
{$ELSE}
	Result := WS2_WSALookupServiceNext(hLookup,dwControlFlags,dwBufferLength,lpqsResults);
{$ENDIF}
end;

function WSALookupServiceEnd( const hLookup : THandle ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSALookupServiceEnd in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSALookupServiceEnd hLookup=%.8x',[GetCurrentThreadId,hLookup]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSALOOKUPSERVICEEND(WS2_EntryAddress(83,'WSALookupServiceEnd'))(hLookup);
{$ELSE}
	Result := WS2_WSALookupServiceEnd(hLookup);
{$ENDIF}
end;

function WSAInstallServiceClassA( const lpServiceClassInfo : LPWSAServiceClassInfoA ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAInstallServiceClass in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAInstallServiceClassA',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAINSTALLSERVICECLASSA(WS2_EntryAddress(84,'WSAInstallServiceClassA'))(lpServiceClassInfo);
{$ELSE}
	Result := WS2_WSAInstallServiceClassA(lpServiceClassInfo);
{$ENDIF}
end;

function WSAInstallServiceClassW( const lpServiceClassInfo : LPWSAServiceClassInfoW ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAInstallServiceClass in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAInstallServiceClassW',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAINSTALLSERVICECLASSW(WS2_EntryAddress(85,'WSAInstallServiceClassW'))(lpServiceClassInfo);
{$ELSE}
	Result := WS2_WSAInstallServiceClassW(lpServiceClassInfo);
{$ENDIF}
end;

function WSAInstallServiceClass( const lpServiceClassInfo : LPWSAServiceClassInfo ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAInstallServiceClass in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAInstallServiceClass',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSAINSTALLSERVICECLASS(WS2_EntryAddress(85,'WSAInstallServiceClassW'))(lpServiceClassInfo);
{$ELSE}
	Result := LPFN_WSAINSTALLSERVICECLASS(WS2_EntryAddress(84,'WSAInstallServiceClassA'))(lpServiceClassInfo);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAInstallServiceClass(lpServiceClassInfo);
{$ENDIF}
end;

function WSARemoveServiceClass( const lpServiceClassId : PGUID ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSARemoveServiceClass in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSARemoveServiceClass lpServiceClassId=%s',[GetCurrentThreadId,p2x(lpServiceClassId,16)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAREMOVESERVICECLASS(WS2_EntryAddress(86,'WSARemoveServiceClass'))(lpServiceClassId);
{$ELSE}
	Result := WS2_WSARemoveServiceClass(lpServiceClassId);
{$ENDIF}
end;

function WSAGetServiceClassInfoA( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfoA ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetServiceClassInfo in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetServiceClassInfoA lpProviderId=%s lpServiceClassId=%s',[GetCurrentThreadId,p2x(lpProviderId,16),p2x(lpServiceClassId,16)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETSERVICECLASSINFOA(WS2_EntryAddress(87,'WSAGetServiceClassInfoA'))(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ELSE}
	Result := WS2_WSAGetServiceClassInfoA(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ENDIF}
end;

function WSAGetServiceClassInfoW( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfoW ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetServiceClassInfo in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetServiceClassInfoW lpProviderId=%s lpServiceClassId=%s',[GetCurrentThreadId,p2x(lpProviderId,16),p2x(lpServiceClassId,16)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETSERVICECLASSINFOW(WS2_EntryAddress(88,'WSAGetServiceClassInfoW'))(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ELSE}
	Result := WS2_WSAGetServiceClassInfoW(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ENDIF}
end;

function WSAGetServiceClassInfo( const lpProviderId : PGUID; const lpServiceClassId : PGUID; var lpdwBufSize : DWORD;
  lpServiceClassInfo : LPWSAServiceClassInfo ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetServiceClassInfo in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetServiceClassInfo lpProviderId=%s lpServiceClassId=%s',[GetCurrentThreadId,p2x(lpProviderId,16),p2x(lpServiceClassId,16)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSAGETSERVICECLASSINFO(WS2_EntryAddress(88,'WSAGetServiceClassInfoW'))(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ELSE}
	Result := LPFN_WSAGETSERVICECLASSINFO(WS2_EntryAddress(87,'WSAGetServiceClassInfoA'))(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAGetServiceClassInfo(lpProviderId,lpServiceClassId,lpdwBufSize,lpServiceClassInfo);
{$ENDIF}
end;

function WSAEnumNameSpaceProvidersA( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoA ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumNameSpaceProviders in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumNameSpaceProvidersA',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAENUMNAMESPACEPROVIDERSA(WS2_EntryAddress(89,'WSAEnumNameSpaceProvidersA'))(lpdwBufferLength,lpnspBuffer);
{$ELSE}
	Result := WS2_WSAEnumNameSpaceProvidersA(lpdwBufferLength,lpnspBuffer);
{$ENDIF}
end;

function WSAEnumNameSpaceProvidersW( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_InfoW ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumNameSpaceProviders in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumNameSpaceProvidersW',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAENUMNAMESPACEPROVIDERSW(WS2_EntryAddress(90,'WSAEnumNameSpaceProvidersW'))(lpdwBufferLength,lpnspBuffer);
{$ELSE}
	Result := WS2_WSAEnumNameSpaceProvidersW(lpdwBufferLength,lpnspBuffer);
{$ENDIF}
end;

function WSAEnumNameSpaceProviders( var lpdwBufferLength: DWORD; const lpnspBuffer: LPWSANameSpace_Info ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAEnumNameSpaceProviders in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAEnumNameSpaceProviders',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSAENUMNAMESPACEPROVIDERS(WS2_EntryAddress(90,'WSAEnumNameSpaceProvidersW'))(lpdwBufferLength,lpnspBuffer);
{$ELSE}
	Result := LPFN_WSAENUMNAMESPACEPROVIDERS(WS2_EntryAddress(89,'WSAEnumNameSpaceProvidersA'))(lpdwBufferLength,lpnspBuffer);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAEnumNameSpaceProviders(lpdwBufferLength,lpnspBuffer);
{$ENDIF}
end;

function WSAGetServiceClassNameByClassIdA( const lpServiceClassId: PGUID; lpszServiceClassName: PChar; var lpdwBufferLength: DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetServiceClassNameByClassId in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetServiceClassNameByClassIdA lpServiceClassId=%s lpszServiceClassName=''%s''',[GetCurrentThreadId,p2x(lpServiceClassId,16),lpszServiceClassName]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDA(WS2_EntryAddress(91,'WSAGetServiceClassNameByClassIdA'))(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ELSE}
	Result := WS2_WSAGetServiceClassNameByClassIdA(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ENDIF}
end;

function WSAGetServiceClassNameByClassIdW( const lpServiceClassId: PGUID; lpszServiceClassName: PWideChar; var lpdwBufferLength: DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetServiceClassNameByClassId in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetServiceClassNameByClassIdW lpServiceClassId=%s',[GetCurrentThreadId,p2x(lpServiceClassId,16)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAGETSERVICECLASSNAMEBYCLASSIDW(WS2_EntryAddress(92,'WSAGetServiceClassNameByClassIdW'))(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ELSE}
	Result := WS2_WSAGetServiceClassNameByClassIdW(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ENDIF}
end;

function WSAGetServiceClassNameByClassId( const lpServiceClassId: PGUID; lpszServiceClassName: PMBChar; var lpdwBufferLength: DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSAGetServiceClassNameByClassId in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAGetServiceClassNameByClassId lpServiceClassId=%s',[GetCurrentThreadId,p2x(lpServiceClassId,16)]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSAGETSERVICECLASSNAMEBYCLASSID(WS2_EntryAddress(92,'WSAGetServiceClassNameByClassIdW'))(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ELSE}
	Result := LPFN_WSAGETSERVICECLASSNAMEBYCLASSID(WS2_EntryAddress(91,'WSAGetServiceClassNameByClassIdA'))(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ENDIF}
{$ELSE}
	Result := WS2_WSAGetServiceClassNameByClassId(lpServiceClassId,lpszServiceClassName,lpdwBufferLength);
{$ENDIF}
end;

function WSASetServiceA( const lpqsRegInfo: LPWSAQuerySetA; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSASetService in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASetServiceA dwControlFlags=%.8x',[GetCurrentThreadId,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASETSERVICEA(WS2_EntryAddress(93,'WSASetServiceA'))(lpqsRegInfo,essoperation,dwControlFlags);
{$ELSE}
	Result := WS2_WSASetServiceA(lpqsRegInfo,essoperation,dwControlFlags);
{$ENDIF}
end;

function WSASetServiceW( const lpqsRegInfo: LPWSAQuerySetW; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSASetService in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASetServiceW dwControlFlags=%.8x',[GetCurrentThreadId,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSASETSERVICEW(WS2_EntryAddress(94,'WSASetServiceW'))(lpqsRegInfo,essoperation,dwControlFlags);
{$ELSE}
	Result := WS2_WSASetServiceW(lpqsRegInfo,essoperation,dwControlFlags);
{$ENDIF}
end;

function WSASetService( const lpqsRegInfo: LPWSAQuerySet; const essoperation: TWSAeSetServiceOp; const dwControlFlags: DWORD ): Integer; 
begin
	if WS2TraceSwitch and(trc_WSASetService in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSASetService dwControlFlags=%.8x',[GetCurrentThreadId,dwControlFlags]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
{$IFDEF UNICODE}
	Result := LPFN_WSASETSERVICE(WS2_EntryAddress(94,'WSASetServiceW'))(lpqsRegInfo,essoperation,dwControlFlags);
{$ELSE}
	Result := LPFN_WSASETSERVICE(WS2_EntryAddress(93,'WSASetServiceA'))(lpqsRegInfo,essoperation,dwControlFlags);
{$ENDIF}
{$ELSE}
	Result := WS2_WSASetService(lpqsRegInfo,essoperation,dwControlFlags);
{$ENDIF}
end;

function WSAProviderConfigChange( var lpNotificationHandle : THandle; lpOverlapped : LPWSAOVERLAPPED; lpCompletionRoutine : LPWSAOVERLAPPED_COMPLETION_ROUTINE ) : Integer; 
begin
	if WS2TraceSwitch and(trc_WSAProviderConfigChange in WS2TraceMask) then
		Trace('%.4x: WS2_32.WSAProviderConfigChange',[GetCurrentThreadId]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSAPROVIDERCONFIGCHANGE(WS2_EntryAddress(95,'WSAProviderConfigChange'))(lpNotificationHandle,lpOverlapped,lpCompletionRoutine);
{$ELSE}
	Result := WS2_WSAProviderConfigChange(lpNotificationHandle,lpOverlapped,lpCompletionRoutine);
{$ENDIF}
end;
{$IFDEF WS2_MS_EXTENTION}

function TransmitFile( hSocket: TSocket; hFile: THandle; nNumberOfBytesToWrite: DWORD; nNumberOfBytesPerSend: DWORD; lpOverlapped: POverlapped; lpTransmitBuffers: PTransmitFileBuffers; dwReserved: DWORD ): BOOL; 
begin
	if WS2TraceSwitch and(trc_TransmitFile in WS2TraceMask) then
		Trace('%.4x: MSWSOCK.TransmitFile hSocket=%.4x hFile=%.8x nNumberOfBytesToWrite=%.8x nNumberOfBytesPerSend=%.8x dwReserved=%.8x',[GetCurrentThreadId,hSocket,hFile,nNumberOfBytesToWrite,nNumberOfBytesPerSend,dwReserved]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_TRANSMITFILE(WS2_EntryAddress(96,'TransmitFile'))(hSocket,hFile,nNumberOfBytesToWrite,nNumberOfBytesPerSend,lpOverlapped,lpTransmitBuffers,dwReserved);
{$ELSE}
	Result := WS2_TransmitFile(hSocket,hFile,nNumberOfBytesToWrite,nNumberOfBytesPerSend,lpOverlapped,lpTransmitBuffers,dwReserved);
{$ENDIF}
end;

function AcceptEx( sListenSocket, sAcceptSocket: TSocket; lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD; var lpdwBytesReceived: DWORD; lpOverlapped: POverlapped ): BOOL; 
begin
	if WS2TraceSwitch and(trc_AcceptEx in WS2TraceMask) then
		Trace('%.4x: MSWSOCK.AcceptEx sListenSocket=%.4x sAcceptSocket=%.4x dwReceiveDataLength=%.8x dwLocalAddressLength=%.8x dwRemoteAddressLength=%.8x',[GetCurrentThreadId,sListenSocket,sAcceptSocket,dwReceiveDataLength,dwLocalAddressLength,dwRemoteAddressLength]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_ACCEPTEX(WS2_EntryAddress(97,'AcceptEx'))(sListenSocket,sAcceptSocket,lpOutputBuffer,dwReceiveDataLength,dwLocalAddressLength,dwRemoteAddressLength,lpdwBytesReceived,lpOverlapped);
{$ELSE}
	Result := WS2_AcceptEx(sListenSocket,sAcceptSocket,lpOutputBuffer,dwReceiveDataLength,dwLocalAddressLength,dwRemoteAddressLength,lpdwBytesReceived,lpOverlapped);
{$ENDIF}
end;

procedure GetAcceptExSockaddrs( lpOutputBuffer: Pointer; dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength: DWORD; var LocalSockaddr: TSockAddr; var LocalSockaddrLength: Integer; var RemoteSockaddr: TSockAddr; var RemoteSockaddrLength: Integer); 
begin
	if WS2TraceSwitch and(trc_GetAcceptExSockaddrs in WS2TraceMask) then
		Trace('%.4x: MSWSOCK.GetAcceptExSockaddrs dwReceiveDataLength=%.8x dwLocalAddressLength=%.8x dwRemoteAddressLength=%.8x',[GetCurrentThreadId,dwReceiveDataLength,dwLocalAddressLength,dwRemoteAddressLength]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	LPFN_GETACCEPTEXSOCKADDRS(WS2_EntryAddress(98,'GetAcceptExSockaddrs'))(lpOutputBuffer,dwReceiveDataLength,dwLocalAddressLength,dwRemoteAddressLength,LocalSockaddr,LocalSockaddrLength,RemoteSockaddr,RemoteSockaddrLength);
{$ELSE}
	WS2_GetAcceptExSockaddrs(lpOutputBuffer,dwReceiveDataLength,dwLocalAddressLength,dwRemoteAddressLength,LocalSockaddr,LocalSockaddrLength,RemoteSockaddr,RemoteSockaddrLength);
{$ENDIF}
end;

function WSARecvEx(s: TSocket; var buf; len: Integer; var flags: Integer): Integer; 
begin
	if WS2TraceSwitch and(trc_WSARecvEx in WS2TraceMask) then
		Trace('%.4x: MSWSOCK.WSARecvEx s=%.4x len=%d',[GetCurrentThreadId,s,len]);
{$IFDEF WS2_DLL_DYNAMIC_LOAD}
	Result := LPFN_WSARECVEX(WS2_EntryAddress(99,'WSARecvEx'))(s,buf,len,flags);
{$ELSE}
	Result := WS2_WSARecvEx(s,buf,len,flags);
{$ENDIF}
end;
{$ENDIF} // WS2_MS_EXTENTION
