procedure WS2Stub_WSACleanup;                       asm  mov eax,  0; call WS2Call; jmp eax; end;
procedure WS2Stub_accept;                           asm  mov eax,  1; call WS2Call; jmp eax; end;
procedure WS2Stub_bind;                             asm  mov eax,  2; call WS2Call; jmp eax; end;
procedure WS2Stub_closesocket;                      asm  mov eax,  3; call WS2Call; jmp eax; end;
procedure WS2Stub_connect;                          asm  mov eax,  4; call WS2Call; jmp eax; end;
procedure WS2Stub_ioctlsocket;                      asm  mov eax,  5; call WS2Call; jmp eax; end;
procedure WS2Stub_getpeername;                      asm  mov eax,  6; call WS2Call; jmp eax; end;
procedure WS2Stub_getsockname;                      asm  mov eax,  7; call WS2Call; jmp eax; end;
procedure WS2Stub_getsockopt;                       asm  mov eax,  8; call WS2Call; jmp eax; end;
procedure WS2Stub_htonl;                            asm  mov eax,  9; call WS2Call; jmp eax; end;
procedure WS2Stub_htons;                            asm  mov eax, 10; call WS2Call; jmp eax; end;
procedure WS2Stub_inet_addr;                        asm  mov eax, 11; call WS2Call; jmp eax; end;
procedure WS2Stub_inet_ntoa;                        asm  mov eax, 12; call WS2Call; jmp eax; end;
procedure WS2Stub_listen;                           asm  mov eax, 13; call WS2Call; jmp eax; end;
procedure WS2Stub_ntohl;                            asm  mov eax, 14; call WS2Call; jmp eax; end;
procedure WS2Stub_ntohs;                            asm  mov eax, 15; call WS2Call; jmp eax; end;
procedure WS2Stub_recv;                             asm  mov eax, 16; call WS2Call; jmp eax; end;
procedure WS2Stub_recvfrom;                         asm  mov eax, 17; call WS2Call; jmp eax; end;
procedure WS2Stub_select;                           asm  mov eax, 18; call WS2Call; jmp eax; end;
procedure WS2Stub_send;                             asm  mov eax, 19; call WS2Call; jmp eax; end;
procedure WS2Stub_sendto;                           asm  mov eax, 20; call WS2Call; jmp eax; end;
procedure WS2Stub_setsockopt;                       asm  mov eax, 21; call WS2Call; jmp eax; end;
procedure WS2Stub_shutdown;                         asm  mov eax, 22; call WS2Call; jmp eax; end;
procedure WS2Stub_socket;                           asm  mov eax, 23; call WS2Call; jmp eax; end;
procedure WS2Stub_gethostbyaddr;                    asm  mov eax, 24; call WS2Call; jmp eax; end;
procedure WS2Stub_gethostbyname;                    asm  mov eax, 25; call WS2Call; jmp eax; end;
procedure WS2Stub_gethostname;                      asm  mov eax, 26; call WS2Call; jmp eax; end;
procedure WS2Stub_getservbyport;                    asm  mov eax, 27; call WS2Call; jmp eax; end;
procedure WS2Stub_getservbyname;                    asm  mov eax, 28; call WS2Call; jmp eax; end;
procedure WS2Stub_getprotobynumber;                 asm  mov eax, 29; call WS2Call; jmp eax; end;
procedure WS2Stub_getprotobyname;                   asm  mov eax, 30; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASetLastError;                  asm  mov eax, 31; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetLastError;                  asm  mov eax, 32; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAIsBlocking;                    asm  mov eax, 33; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAUnhookBlockingHook;            asm  mov eax, 34; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASetBlockingHook;               asm  mov eax, 35; call WS2Call; jmp eax; end;
procedure WS2Stub_WSACancelBlockingCall;            asm  mov eax, 36; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncGetServByName;            asm  mov eax, 37; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncGetServByPort;            asm  mov eax, 38; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncGetProtoByName;           asm  mov eax, 39; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncGetProtoByNumber;         asm  mov eax, 40; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncGetHostByName;            asm  mov eax, 41; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncGetHostByAddr;            asm  mov eax, 42; call WS2Call; jmp eax; end;
procedure WS2Stub_WSACancelAsyncRequest;            asm  mov eax, 43; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAsyncSelect;                   asm  mov eax, 44; call WS2Call; jmp eax; end;
procedure WS2Stub___WSAFDIsSet;                     asm  mov eax, 45; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAccept;                        asm  mov eax, 46; call WS2Call; jmp eax; end;
procedure WS2Stub_WSACloseEvent;                    asm  mov eax, 47; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAConnect;                       asm  mov eax, 48; call WS2Call; jmp eax; end;
procedure WS2Stub_WSACreateEvent ;                  asm  mov eax, 49; call WS2Call; jmp eax; end;
procedure WS2Stub_WSADuplicateSocketA;              asm  mov eax, 50; call WS2Call; jmp eax; end;
procedure WS2Stub_WSADuplicateSocketW;              asm  mov eax, 51; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumNetworkEvents;             asm  mov eax, 52; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumProtocolsA;                asm  mov eax, 53; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumProtocolsW;                asm  mov eax, 54; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEventSelect;                   asm  mov eax, 55; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetOverlappedResult;           asm  mov eax, 56; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetQosByName;                  asm  mov eax, 57; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAHtonl;                         asm  mov eax, 58; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAHtons;                         asm  mov eax, 59; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAIoctl;                         asm  mov eax, 60; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAJoinLeaf;                      asm  mov eax, 61; call WS2Call; jmp eax; end;
procedure WS2Stub_WSANtohl;                         asm  mov eax, 62; call WS2Call; jmp eax; end;
procedure WS2Stub_WSANtohs;                         asm  mov eax, 63; call WS2Call; jmp eax; end;
procedure WS2Stub_WSARecv;                          asm  mov eax, 64; call WS2Call; jmp eax; end;
procedure WS2Stub_WSARecvDisconnect;                asm  mov eax, 65; call WS2Call; jmp eax; end;
procedure WS2Stub_WSARecvFrom;                      asm  mov eax, 66; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAResetEvent;                    asm  mov eax, 67; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASend;                          asm  mov eax, 68; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASendDisconnect;                asm  mov eax, 69; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASendTo;                        asm  mov eax, 70; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASetEvent;                      asm  mov eax, 71; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASocketA;                       asm  mov eax, 72; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASocketW;                       asm  mov eax, 73; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAWaitForMultipleEvents;         asm  mov eax, 74; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAddressToStringA;              asm  mov eax, 75; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAddressToStringW;              asm  mov eax, 76; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAStringToAddressA;              asm  mov eax, 77; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAStringToAddressW;              asm  mov eax, 78; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceBeginA;           asm  mov eax, 79; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceBeginW;           asm  mov eax, 80; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceNextA;            asm  mov eax, 81; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceNextW;            asm  mov eax, 82; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceEnd;              asm  mov eax, 83; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAInstallServiceClassA;          asm  mov eax, 84; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAInstallServiceClassW;          asm  mov eax, 85; call WS2Call; jmp eax; end;
procedure WS2Stub_WSARemoveServiceClass;            asm  mov eax, 86; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetServiceClassInfoA;          asm  mov eax, 87; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetServiceClassInfoW;          asm  mov eax, 88; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumNameSpaceProvidersA;       asm  mov eax, 89; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumNameSpaceProvidersW;       asm  mov eax, 90; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetServiceClassNameByClassIdA; asm  mov eax, 91; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetServiceClassNameByClassIdW; asm  mov eax, 92; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASetServiceA;                   asm  mov eax, 93; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASetServiceW;                   asm  mov eax, 94; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAProviderConfigChange;          asm  mov eax, 95; call WS2Call; jmp eax; end;
procedure WS2Stub_WSADuplicateSocket;               asm  mov eax, 96; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumProtocols;                 asm  mov eax, 97; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASocket;                        asm  mov eax, 98; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAAddressToString;               asm  mov eax, 99; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAStringToAddress;               asm  mov eax,100; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceBegin;            asm  mov eax,101; call WS2Call; jmp eax; end;
procedure WS2Stub_WSALookupServiceNext;             asm  mov eax,102; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAInstallServiceClass;           asm  mov eax,103; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetServiceClassInfo;           asm  mov eax,104; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAEnumNameSpaceProviders;        asm  mov eax,105; call WS2Call; jmp eax; end;
procedure WS2Stub_WSAGetServiceClassNameByClassId;  asm  mov eax,106; call WS2Call; jmp eax; end;
procedure WS2Stub_WSASetService;                    asm  mov eax,107; call WS2Call; jmp eax; end;
{$IFDEF WS2_MS_EXTENTION}
procedure WS2Stub_TransmitFile;                     asm  mov eax,108; call WS2Call; jmp eax; end;
procedure WS2Stub_AcceptEx;                         asm  mov eax,109; call WS2Call; jmp eax; end;
procedure WS2Stub_GetAcceptExSockaddrs;             asm  mov eax,110; call WS2Call; jmp eax; end;
procedure WS2Stub_WSARecvEx;                        asm  mov eax,111; call WS2Call; jmp eax; end;
{$ENDIF} // WS2_MS_EXTENTION


const
{$IFDEF WS2_MS_EXTENTION}
	WS2StubEntryCount = 112;
	MSWSStubEntryCount = 4;
{$ELSE}
	WS2StubEntryCount = 108;
{$ENDIF} // WS2_MS_EXTENTION
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
		(StubProc: @WS2Stub_WSACreateEvent ; ProcVar: @@WSACreateEvent ; Name: 'WSACreateEvent '),
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
{$IFDEF WS2_MS_EXTENTION}
    , // comma
		(StubProc: @WS2Stub_TransmitFile; ProcVar: @@TransmitFile; Name: 'TransmitFile'),
		(StubProc: @WS2Stub_AcceptEx; ProcVar: @@AcceptEx; Name: 'AcceptEx'),
		(StubProc: @WS2Stub_GetAcceptExSockaddrs; ProcVar: @@GetAcceptExSockaddrs; Name: 'GetAcceptExSockaddrs'),
		(StubProc: @WS2Stub_WSARecvEx; ProcVar: @@WSARecvEx; Name: 'WSARecvEx')
{$ENDIF} // WS2_MS_EXTENTION
	);
