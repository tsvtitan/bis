
{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Network Detection Part                  }
{           version 5.4 for Delphi 3,4,5                }
{                                                       }
{       Copyright © 1997,2001 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MSI_Network;

interface

uses
  SysUtils, Windows, Classes, WinSock;

type
  TWinsock = class(TPersistent)
  private
    FDesc: string;
    FStat: string;
    FMajVer: word;
    FMinVer: word;
  public
    procedure GetInfo;
  published
    property Description: string read FDesc write FDesc stored False;
    property MajorVersion: word read FMajVer write FMajVer stored False;
    property MinorVersion: word read FMinVer write FMinVer stored False;
    property Status: string read FStat write FStat stored False;
  end;

  TNetwork = class(TPersistent)
  private
    FAdapter: TStrings;
    FWinsock: TWinsock;
    FIPAddress: TStrings;
    FMACAddress: TStrings;
    FCli: TStrings;
    FServ: TStrings;
    FProto: TStrings;
    FNCAI: integer;
    FExtendedReport: Boolean;
    function GetLocalIP :string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetInfo;
    procedure Report(var sl :TStringList);
    property ExtendedReport: Boolean read FExtendedReport write FExtendedReport;
  published
    property IPAddresses: TStrings read FIPAddress write FIPAddress stored false;
    property MACAddresses: TStrings read FMACAddress write FMACAddress stored False;
    property Adapters :TStrings read FAdapter write FAdapter stored false;
    property CardAdapterIndex: integer read FNCAI write FNCAI stored False;
    property Protocols :TStrings read FProto write FProto stored False;
    property Services :TStrings read FServ write FServ stored False;
    property Clients :TStrings read FCli write FCli stored False;
    property WinSock: TWinsock read FWinsock write FWinsock;
  end;

implementation

uses Registry, MiTeC_Routines, MSI_Devices;

const
  NBNAMESIZE    = 16;
  MAXLANAS      = 254;
  NCB_ASYNC     = $80;   { asynch command bit to be or-ed into command }
  NCB_CALL      = $10;   { open a session }
  NCB_LISTEN    = $11;   { wait for a call }
  NCB_HANGUP    = $12;   { end session }
  NCB_SEND      = $14;   { send data }
  NCB_RECV      = $15;   { receive data }
  NCB_RECVANY   = $16;   { receive data on any session }
  NCB_CHAINSEND = $17;   { chain send data }
  NCB_DGSEND    = $20;   { send a datagram }
  NCB_DGRECV    = $21;   { receive datagram }
  NCB_DGSENDBC  = $22;   { send broadcast datagram }
  NCB_DGREVCBC  = $23;   { receive broadcast datagram }
  NCB_ADDNAME   = $30;   { add unique name to local table }
  NCB_DELNAME   = $31;   { delete name from local table }
  NCB_RESET     = $32;   { reset adapter }
  NCB_ADPSTAT   = $33;   { adapter status }
  NCB_SSTAT     = $34;   { session status }
  NCB_CANCEL    = $35;   { cancel NCB request }
  NCB_ADDGRPNAME= $36;   { add group name to local table }
  NCB_ENUM      = $37;   { enum adapters }
  NCB_UNLINK    = $70;   { unlink remote boot code }
  NCB_SENDNA    = $71;   { send, don't wait for ACK }
  NCB_CHAINSENDNA=$72;   { chain send, but don't wait for ACK }
  NCB_LANSTALERT= $73;   { lan status alert }
  NCB_ACTION    = $77;   { enable extensions }
  NCB_FINDNAME  = $78;   { search for name on the network }
  NCB_TRACE     = $79;   { activate / stop tracing }
  NRC_GOODRET     = $00;    { good return
  NRC_BUFLEN      = $01;    { illegal buffer length                      }
  NRC_ILLCMD      = $03;    { illegal command                            }
  NRC_CMDTMO      = $05;    { command timed out                          }
  NRC_INCOMP      = $06;    { message incomplete, issue another command  }
  NRC_BADDR       = $07;    { illegal buffer address                     }
  NRC_SNUMOUT     = $08;    { session number out of range                }
  NRC_NORES       = $09;    { no resource available                      }
  NRC_SCLOSED     = $0a;    { session closed                             }
  NRC_CMDCAN      = $0b;    { command cancelled                          }
  NRC_DUPNAME     = $0d;    { duplicate name                             }
  NRC_NAMTFUL     = $0e;    { name table full                            }
  NRC_ACTSES      = $0f;    { no deletions, name has active sessions     }
  NRC_LOCTFUL     = $11;    { local session table full                   }
  NRC_REMTFUL     = $12;    { remote session table full                  }
  NRC_ILLNN       = $13;    { illegal name number                        }
  NRC_NOCALL      = $14;    { no callname                                }
  NRC_NOWILD      = $15;    { cannot put * in NCB_NAME                   }
  NRC_INUSE       = $16;    { name in use on remote adapter              }
  NRC_NAMERR      = $17;    { name deleted                               }
  NRC_SABORT      = $18;    { session ended abnormally                   }
  NRC_NAMCONF     = $19;    { name conflict detected                     }
  NRC_IFBUSY      = $21;    { interface busy, IRET before retrying       }
  NRC_TOOMANY     = $22;    { too many commands outstanding, retry later }
  NRC_BRIDGE      = $23;    { ncb_lana_num field invalid                 }
  NRC_CANOCCR     = $24;    { command completed while cancel occurring   }
  NRC_CANCEL      = $26;    { command not valid to cancel                }
  NRC_DUPENV      = $30;    { name defined by anther local process       }
  NRC_ENVNOTDEF   = $34;    { environment undefined. RESET required      }
  NRC_OSRESNOTAV  = $35;    { required OS resources exhausted            }
  NRC_MAXAPPS     = $36;    { max number of applications exceeded        }
  NRC_NOSAPS      = $37;    { no saps available for netbios              }
  NRC_NORESOURCES = $38;    { requested resources are not available      }
  NRC_INVADDRESS  = $39;    { invalid ncb address or length > segment    }
  NRC_INVDDID     = $3B;    { invalid NCB DDID                           }
  NRC_LOCKFAIL    = $3C;    { lock of user area failed                   }
  NRC_OPENERR     = $3f;    { NETBIOS not loaded                         }
  NRC_SYSTEM      = $40;    { system error                               }
  NRC_PENDING     = $ff;    { asynchronous command is not yet finished   }
  ALL_TRANSPORTS = 'M'#$00#$00#$00;
  MS_NBF         = 'MNBF';
  NAME_FLAGS_MASK = $87;
  GROUP_NAME      = $80;
  UNIQUE_NAME     = $00;

type
{ Netbios Name }
  TNBName = array[0..(NBNAMESIZE - 1)] of byte;

 { MAC address }
  TMacAddress = array[0..5] of byte;

  PNCB = ^TNCB;

 { Netbios Control Block }

 {$IFDEF WIN32}
  TNCBPostProc = procedure(P: PNCB);
 {$ENDIF}

  TNCB = packed record        { Netbios Control Block }
    Command:  byte;      { command code                       }
    RetCode:  byte;      { return code                        }
    LSN:      byte;      { local session number               }
    Num:      byte;      { name number                        }
    Buf:      ^byte;     { data buffer                        }
    Length:   word;      { data length                        }
    CallName: TNBName;   { name to call                       }
    Name:     TNBName;   { our own name                       }
    RTO:      byte;      { receive time-out                   }
    STO:      byte;      { send time-out                      }
  {$IFNDEF WIN32}
    Post_Offs:word;      { asynch notification routine offset }
    Post_Seg: word;      { asynch notification routine segment}
  {$ELSE}
    PostPrc:  TNCBPostProc;{ asynch notification routine (nb30) }
  {$ENDIF}
    Lana_Num: byte;     { adapter number                     }
    Cmd_Cplt: byte;     { command completion flag            }
  {$IFDEF WIN32}
    Reserved: array[0..9] of byte;  { Reserverd for Bios use }
    Event:    THandle;  { WIN32 event handle to be signalled }
                        { for asynch cmd completion          }
  {$ELSE}
    Reserved: array[0..13] of byte;  { Reserved }
  {$ENDIF}
  end;


{ Netbios Name Info record }
  PNameInfo = ^TNameInfo;
  TNameInfo = packed record  { name info record }
    Name:   TNBName;       { netbios name }
    NameNum:byte;          { name number  }
    NameSt: byte;          { name status  }
  end;

{ Netbios adapter status }
  PAdpStat = ^TAdpStat;
  TAdpStat = packed record    { adapter status record}
    ID:       TMacAddress;   { adapter mac address           }
    VMajor:   byte;          { software version major number }
    Resvd0:   byte;
    AdpType:  byte;          { adapter type                  }
    VMinor:   byte;          { software version minor number }
    RptTime:  word;          { reporting time period         }
    RcvCRC:   word;          { receive crc errors            }
    RcvOth:   word;          { receive other errors          }
    TxmCol:   word;          { transmit collisions           }
    TxmOth:   word;          { transmit other errors         }
    TxmOK:    LongInt;       { successfull transmissions     }
    RcvOK:    LongInt;       { successfull receives          }
    TxmRetr:  word;          { transmit retries              }
    NoRcvBuf: word;          { number of 'no receive buffer' }
    T1_tmo:   word;          { t1 time-outs                  }
    Ti_tmo:   word;          { ti time_outs                  }
    Resvd1:   LongInt;
    Free_Ncbs:word;          { number of free ncb's          }
    Cfg_Ncbs: word;          { number of configured ncb's    }
    max_Ncbs: word;          { max ncb's used                }
    NoTxmBuf: word;          { number of 'no transmit buffer'}
    MaxDGSize:word;          { max. datagram size            }
    Pend_Ses: word;          { number of pending sessions    }
    Cfg_Ses:  word;          { number of configured sessions }
    Max_Ses:  word;          { max sessions used             }
    Max_SPSz: word;          { max. session packet size      }
    nNames:   word;          { number of names in local table}
    Names:    array[0..15] of TnameInfo; { local name table  }
  end;

{
   Structure returned to the NCB command NCBSSTAT is SESSION_HEADER followed
   by an array of SESSION_BUFFER structures. If the NCB_NAME starts with an
   asterisk then an array of these structures is returned containing the
   status for all names.
}

{ session header }
  PSession_Header = ^TSession_Header;
  TSession_Header = packed record
    sess_name:            byte;
    num_sess:             byte;
    rcv_dg_outstanding:   byte;
    rcv_any_outstanding:  byte;
  end;

{ session buffer }
  PSession_Buffer = ^TSession_Buffer;
  TSession_Buffer = packed record
    lsn:                  byte;
    state:                byte;
    local_name:           TNBName;
    remote_name:          TNBName;
    rcvs_outstanding:     byte;
    sends_outstanding:    byte;
  end;

{
   Structure returned to the NCB command NCBENUM.

   On a system containing lana's 0, 2 and 3, a structure with
   length =3, lana[0]=0, lana[1]=2 and lana[2]=3 will be returned.
}
  PLana_Enum = ^TLana_Enum;
  TLANA_ENUM = packed record
    length:   byte;         {  Number of valid entries in lana[] }
    lana:     array[0..(MAXLANAS - 1)] of byte;
  end;

{
   Structure returned to the NCB command NCBFINDNAME is FIND_NAME_HEADER followed
   by an array of FIND_NAME_BUFFER structures.
 }

  PFind_Name_Header = ^TFind_Name_Header;
  TFind_Name_Header = packed record
    node_count:    word;
    reserved:      byte;
    unique_group:  byte;
  end;

  PFind_Name_Buffer = ^TFind_Name_Buffer;
  TFind_Name_Buffer = packed record
    length:          byte;
    access_control:  byte;
    frame_control:   byte;
    destination_addr:TMacAddress;
    source_addr:     TMacAddress;
    routing_info:    array[0..17] of byte;
  end;

{
   Structure provided with NCBACTION. The purpose of NCBACTION is to provide
   transport specific extensions to netbios.
 }

  PAction_Header = ^TAction_Header;
  TAction_Header = packed record
    transport_id: LongInt;
    action_code:  Word;
    reserved:     Word;
  end;

{$IFDEF WIN32}
function Netbios(P: PNCB): Char; stdcall; external 'netapi32.dll' name 'Netbios';
{$ENDIF}

function NetbiosCmd(var NCB: TNCB): Word;
begin
{$IFNDEF WIN32}
  asm
    push bp                   { save bp }
    push ss                   { save ss }
    push ds                   { save ds }
    les  bx, NCB              { get segment/offset address of NCB }
    call NetBiosCall;         { 16 bit Windows Netbios call }
    xor  ah,ah
    mov  @Result, ax          { store return code }
    pop  ds                   { restore ds }
    pop  ss                   { restore ss }
    pop  bp                   { restore bp }
  end;
{$ELSE}
  Result:=Word(Netbios(PNCB(@NCB)));
{$ENDIF}
end;

function NbLanaEnum: TLana_Enum;
var
  NCB: TNCB;
  L_Enum: TLana_Enum;
  RetCode: Word;
begin
{$IFDEF WIN32}
  FillChar(NCB, SizeOf(NCB),0);
  FillChar(L_Enum, SizeOf(TLana_Enum),0);
  NCB.Command:=NCB_ENUM;
  NCB.Buf:=@L_Enum;
  NCB.Length:=Sizeof(L_Enum);
  RetCode:=NetBiosCmd(NCB);
  if RetCode<>NRC_GOODRET then begin
    L_Enum.Length:=0;
    L_Enum.Lana[0]:=Byte(RetCode);
  end;
{$ELSE}
  L_Enum.Length:=1;
  L_Enum.Lana[0]:=0;
{$ENDIF}
  Result:=L_Enum;
end;

function NbReset(l: Byte): Word;
var
  NCB: TNCB;
begin
{$IFNDEF WIN32}
  Result:=NRC_GOODRET;
{$ELSE}
  FillChar(NCB,SizeOf(NCB),0);
  NCB.Command:=NCB_RESET;
  NCB.Lana_Num:=l;
  Result:=NetBiosCmd(NCB);
{$ENDIF}
end;

function NbGetMacAddr(LanaNum: Integer): String;
var
  NCB: TNCB;
  AdpStat: TAdpStat;
  RetCode: Word;
begin
  FillChar(NCB,SizeOf(NCB),0);
  FillChar(AdpStat,SizeOf(AdpStat),0);
  NCB.Command:=NCB_ADPSTAT;
  NCB.Buf:=@AdpStat;
  NCB.Length:=Sizeof(AdpStat);
  FillChar(NCB.CallName,Sizeof(TNBName),$20);
  NCB.CallName[0]:=Byte('*');
  NCB.Lana_Num:=LanaNum;
  RetCode:=NetBiosCmd(NCB);
  if RetCode=NRC_GOODRET then begin
    Result:=Format('%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x',
                   [AdpStat.ID[0],
                   AdpStat.ID[1],
                   AdpStat.ID[2],
                   AdpStat.ID[3],
                   AdpStat.ID[4],
                   AdpStat.ID[5]
                   ]);
  end else
    Result:='??:??:??:??:??:??';
end;

{ TWinsock }

procedure TWinsock.GetInfo;
var
  GInitData :TWSADATA;
begin
  try
    if wsastartup($101,GInitData)=0 then begin
      FDesc:=GInitData.szDescription;
      FStat:=GInitData.szSystemStatus;
      FMajVer:=Hi(GInitData.wHighVersion);
      FMinVer:=Lo(GInitData.wHighVersion);
      wsacleanup;
    end else
      FStat:='Winsock cannot be initialized.';
  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TWinsock.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

{ TNetwork }

function TNetwork.GetLocalIP: string;
type
  TaPInAddr = array [0..255] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe  :PHostEnt;
  pptr :PaPInAddr;
  Buffer :array [0..63] of char;
  i :integer;
  GInitData :TWSADATA;
begin
  wsastartup($101,GInitData);
  result:='';
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(buffer);
  if not assigned(phe) then
    exit;
  pptr:=PaPInAddr(Phe^.h_addr_list);
  i:=0;
  while pptr^[I]<>nil do begin
    result:=Result+StrPas(inet_ntoa(pptr^[I]^))+',';
    inc(i);
  end;
  Delete(Result,Length(Result),1);
  wsacleanup;
end;

procedure TNetwork.GetInfo;
var
  L_Enum: TLana_Enum;
  RetCode: Word;
  i: integer;
  ck,dv: string;
const
  rkNetworkNT = {HKEY_LOCAL_MACHINE\}'SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards';
  rkNetwork2K = {HKEY_LOCAL_MACHINE\}'SYSTEM\CurrentControlSet\Control\Network';

  rvNetworkNT = 'Description';

  rvProtoClass = 'NetTrans';
  rvServClass = 'NetService';
  rvCliClass = 'NetClient';
begin
  try

  FWinSock.GetInfo;
  FIPAddress.CommaText:=GetLocalIP;
  FAdapter.Clear;
  FNCAI:=-1;

  if FExtendedReport then begin
    with TDevices.Create do begin
      GetInfo;
      for i:=0 to DeviceCount-1 do
        if Devices[i].DeviceClass=dcNet then begin
          if Devices[i].FriendlyName='' then
            ck:=Devices[i].Description
          else
            ck:=Devices[i].FriendlyName;
          FAdapter.Add(ck);
          if (Devices[i].Location<>'') and (FNCAI=-1) then
            FNCAI:=FAdapter.Count-1;
        end;
      Free;
    end;

    if Is2K then begin
      ck:=rkNetwork2K;
      dv:=rvNetworkNT;
    end else begin
      ck:=ClassKey;
      dv:=DescValue;
    end;
    GetClassDevices(ck,rvProtoClass,dv,FProto);
    GetClassDevices(ck,rvServClass,dv,FServ);
    GetClassDevices(ck,rvCliClass,dv,FCli);
  end;  

  FMACAddress.Clear;
  L_Enum:=NbLanaEnum;
  if L_Enum.Length<>0 then
    for i:=0 to (L_Enum.Length-1) do begin
      RetCode:=NbReset(L_Enum.Lana[i]);
      if RetCode=NRC_GOODRET then begin
        ck:=NbGetMacAddr(L_Enum.Lana[i]);
        if FMacAddress.IndexOf(ck)=-1 then
          FMacAddress.Add(ck);
      end;
    end;

  except
    on e:Exception do begin
      MessageBox(0,PChar(e.message),'TNetwork.GetInfo',MB_OK or MB_ICONERROR);
    end;
  end;
end;

constructor TNetwork.Create;
begin
  inherited;
  FWinsock:=TWinsock.Create;
  FAdapter:=TStringList.Create;
  FIPAddress:=TStringList.Create;
  FMACAddress:=TStringList.Create;
  FProto:=TStringList.Create;
  FServ:=TStringList.Create;
  FCli:=TStringList.Create;
end;

destructor TNetwork.Destroy;
begin
  FWinsock.Free;
  FAdapter.Free;
  FMACAddress.Free;
  FIPAddress.Free;
  FProto.Free;
  FCli.Free;
  FServ.Free;
  inherited;
end;

procedure TNetwork.Report(var sl: TStringList);
begin
  with sl do begin
    Add('[Network]');
    if FExtendedReport then begin
      StringsToRep(Adapters,'Count','Adapter',sl);
      StringsToRep(Protocols,'ProtoCount','Protocol',sl);
      StringsToRep(Services,'ServiceCount','Service',sl);
      StringsToRep(Clients,'ClientCount','Client',sl);
    end;  
    StringsToRep(IPAddresses,'IPCount','IPAddress',sl);
    StringsToRep(MACAddresses,'MACCount','MACAddress',sl);
    Add('[Winsock]');
    Add(Format('Description=%s',[Winsock.Description]));
    Add(Format('Version=%d.%d',[Hi(Winsock.MajorVersion),Lo(Winsock.MinorVersion)]));
    Add(Format('Status=%s',[Winsock.Status]));
  end;
end;


end.
