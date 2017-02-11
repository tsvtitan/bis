{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  111212: IdFSP.pas 
{
{   Rev 1.11    11/11/2004 11:22:54 PM  JPMugaas
{ Removed an $IFDEF that's no longer needed.
}
{
{   Rev 1.10    11/8/2004 8:36:04 PM  JPMugaas
{ Added value for command that may appear later.
}
{
{   Rev 1.9    11/7/2004 11:34:16 PM  JPMugaas
{ Now uses inherited methods again.  The inherited methods now use the Binding
{ methods we used here.
}
{
{   Rev 1.8    11/6/2004 1:46:34 AM  JPMugaas
{ Minor bug fix for when there is no data in a reply to CC_GET_PRO.
}
{
{   Rev 1.7    11/5/2004 7:55:02 PM  JPMugaas
{ Changed to use, Connect, Recv, Send, and Disconnect instead of ReceiveFrom
{ and SendTo.  This should improve performance as we do make repeated contacts
{ to the host and UDP connect will cause the stack to filter out packets that
{ aren't from the peer.  There should only be one DNS resolution per session
{ making this more efficient (cutting down to about 87 seconds to get a dir).
}
{
{   Rev 1.4    10/31/2004 1:49:58 AM  JPMugaas
{ Now uses item type from TIdFTPList for dirs and files.  We don't use Skip
{ items or end of dir marker items.
}
{
{   Rev 1.2    10/30/2004 10:23:58 PM  JPMugaas
{ Should be much faster.
}
{
{   Rev 1.1    10/30/2004 7:04:26 PM  JPMugaas
{ FSP Upload.
}
{
{   Rev 1.0    10/29/2004 12:34:20 PM  JPMugaas
{ File Services Protocol implementation started
}
unit IdFSP;

interface
uses Classes, IdException, IdFTPList,  IdGlobal, IdStreamVCL, IdTStrings, IdUDPClient;

{This is based on:

http://cvs.sourceforge.net/viewcvs.py/fsp/fsp/doc/PROTOCOL?rev=1.4&view=markup

and the Java Lib at fsp.sourceforge.net was also referenced.

I have verified this on a CygWin build of the FSP Server at fsp.sourceforge.net.
}
{


FSP Packet format:
  HEADER - size = Fixed size 12 bytes. Always present.
  DATA         - size = defined in header (DATA_LENGTH)
  XTRA DATA- size = packet_size - header_size (12) - DATA_LENGTH

Maximal data size DATA_LENGTH + XTRA_DATA length is 1024. Clients and servers
are not required to support XTRA DATA (but in current FSP implementation does).
If XTRA DATA are provided, there must be also contained in MESSAGE_CHECKSUM.

HEADER FORMAT (12 bytes)
 byte FSP_COMMAND
 byte MESSAGE_CHECKSUM
 word KEY
 word SEQUENCE
 word DATA_LENGTH
 long FILE_POSITION

MESSAGE_CHECKSUM
Entire packet (HEADER + DATA + XTRA DATA) is checksumed.  When computing a
checksum use zero in place of MESSAGE_CHECKSUM header field. 

Due to some unknown reason, method of computing checksums is different in each
direction. For packets travelling from server to client initial checksum
value is zero, otherwise it is HEADER + DATA + XTRA DATA size.

Checksums in server->client direction are computed as follows:

 /* assume that we have already zeroed checksum in packet */
 unsigned int sum,checksum;
 for(t = packet_start, sum = 0; t < packet_end; sum += *t++);
 checksum= sum + (sum >> 8);

KEY
Client's message to server contain a KEY value that is the same as the KEY
value of the previous message received from the server. KEY is choosen random
by server.
}

{



 CC_VERSION     0x10- Get server version string and setup

                request
                file position: ignored
                data:          not used
xtra data:     not used

reply
file position:  size of optional extra version data
data:           ASCIIZ Server version string
xtra data:      optional extra version data
byte - FLAGS
        bit 0 set - server does logging
bit 1 set - server is read only
bit 2 set - reverse lookup required
bit 3 set - server is in private mode
bit 4 set - thruput control
        if bit 4 is set thruput info follows
long - max_thruput allowed (in bytes/sec)
word - max. packet size supported by server
}

const
  IdPORT_FSP = 21;

  HSIZE=12;
  MAXSPACE=1024;
  MAXSIZE=MAXSPACE+HSIZE;

{
  HEADER - size = Fixed size 12 bytes. Always present.
  DATA         - size = defined in header (DATA_LENGTH)
  XTRA DATA- size = packet_size - header_size (12) - DATA_LENGTH
}

//commands
  CC_VERSION     = $10;  //Get server version string and setup
  CC_INFO        = $11;  //return server's extended info block
  CC_ERR         = $40;  //error response from server
  CC_GET_DIR     = $41; // get a directory listing
  CC_GET_FILE    = $42; // get a file
  CC_UP_LOAD     = $43; // open a file for writing
  CC_INSTALL     = $44; // close and install file opened for writing
  CC_DEL_FILE    = $45; // delete a file
  CC_DEL_DIR     = $46; // delete a directory
  CC_GET_PRO     = $47; // get directory protection
  CC_SET_PRO     = $48; // set directory protection
  CC_MAKE_DIR    = $49; // create a directory
  CC_BYE         = $4A; // finish a session
  CC_GRAB_FILE   = $4B; // atomic get+delete a file
  CC_GRAB_DONE   = $4C; // atomic get+delete a file done
  CC_STAT        = $4D; // get information about file/directory
  CC_RENAME      = $4E; // rename file or directory
  CC_CH_PASSW    = $4F; // change password
//Reserved commands:
 CC_LIMIT        = $80;
 { commands > 0x7F will have extended
     header. No such extensions or commands
    which uses that are known today. This
    header will be used in protocol version 3.   }

  CC_TEST         = $81; //reserved for testing of new header

  RDTYPE_END      = $00;
  RDTYPE_FILE     = $01;
  RDTYPE_DIR      = $02;
  RDTYPE_SKIP     = $2A;   //42

  MINTIMEOUT =   1340;   //1.34 seconds
  MAXTIMEOUT = 300000; //300 seconds
type
  EIdFSPException = class(EIdException);
  EIdFSPFileAlreadyExists = class(EIdFSPException);
  EIdFSPFileNotFound = class(EIdFSPException);
  EIdFSPProtException = class(EIdFSPException);
{
RDIRENT.HEADER types:
  RDTYPE_END      0x00
  RDTYPE_FILE     0x01
  RDTYPE_DIR      0x02
  RDTYPE_SKIP     0x2A
}
  TIdFSPStatInfo = class(TCollectionItem)
  protected
      FModifiedDateGMT : TDateTime;
    FModifiedDate: TDateTime;
    //Size is Int64 in case FSP 3 has an expansion, otherise, it can only handle
    //file sizes up 4 GB's.  It's not a bug, it's a feature.
    FSize: Int64;
    FItemType :TIdDirItemType;
  published
    property ItemType :TIdDirItemType read FItemType write FItemType;
    property Size: Int64 read FSize write FSize;
    property ModifiedDate: TDateTime read FModifiedDate write FModifiedDate;
    property ModifiedDateGMT : TDateTime read FModifiedDateGMT write FModifiedDateGMT;
  end;
  TIdFSPListItem = class(TIdFSPStatInfo)
  protected
    FFileName: string;
  published
    property FileName: string read FFileName write FFileName;
  end;
  TIdFSPListItems = class(TCollection)
  protected
    function GetItems(AIndex: Integer): TIdFSPListItem;
    procedure SetItems(AIndex: Integer; const Value: TIdFSPListItem);
  public
    function Add: TIdFSPListItem;
    constructor Create; reintroduce;
    function ParseEntries(const AData : TIdBytes; const ADataLen : Cardinal) : Boolean;
    function IndexOf(AItem: TIdFSPListItem): Integer;
    property Items[AIndex: Integer]: TIdFSPListItem read GetItems write SetItems; default;

  end;
  TIdFSPDirInfo = class(TObject)
  protected
    FOwnsDir,
    FCanDeleteFiles,
    FCanAddFiles,
    FCanMakeDir,
    FOnlyOwnerCanReadFiles,
    FHasReadMe,
    FCanBeListed,
    FCanRenameFiles : Boolean;
    FReadMe : String;
  public
    property OwnsDir : Boolean read FOwnsDir write FOwnsDir;
    property CanDeleteFiles : Boolean read FCanDeleteFiles write FCanDeleteFiles;
    property CanAddFiles : Boolean read FCanAddFiles write FCanAddFiles;
    property CanMakeDir : Boolean read FCanMakeDir write FCanMakeDir;
    property OnlyOwnerCanReadFiles : Boolean read FOnlyOwnerCanReadFiles write FOnlyOwnerCanReadFiles;
    property HasReadMe : Boolean read FHasReadMe write FHasReadMe;
{


        Compatibility

Versions older than 2.8.1b6 do not uses bits 6 and 7. This
causes that directory can be listable even it do not have
6th bit set.
}
    property CanBeListed : Boolean read FCanBeListed write FCanBeListed;
    property CanRenameFiles : Boolean read FCanRenameFiles write FCanRenameFiles;
    property ReadMe : String read FReadMe write FReadMe;
  end;
  TIdFSPPacket = class(TObject)
  protected
    FCmd: Byte;
    FFilePosition: Cardinal;
    FData: TIdBytes;
    FDataLen : Cardinal;
    FExtraData: TIdBytes;
//    FExtraDataLen : Cardinal;
    FSequence: Word;
    FKey: Word;
    FValid : Boolean;
  public
    constructor Create;
    function WritePacket : TIdBytes;
    procedure ReadPacket(const AData : TIdBytes; const ALen : Cardinal);
    property Valid : Boolean read FValid;
    property Cmd : Byte read FCmd write FCmd;
    property Key : Word read FKey write FKey;
    property Sequence : Word read FSequence write FSequence;
    property FilePosition : Cardinal read FFilePosition write FFilePosition;
    property Data : TIdBytes read FData write FData;
    property DataLen : Cardinal read FDataLen write FDataLen;
    property ExtraData : TIdBytes read FExtraData write FExtraData;
  //  property WritePacket : TIdBytes read GetWritePacket write SetWritePacket;
  end;
  TIdFSPLogEvent = procedure (Sender : TObject; APacket : TIdFSPPacket) of object;
  TIdFSP = class(TIdUDPClient)
  protected
    FConEstablished : Boolean;
    FSequence : Word;
    FKey : Word;
    FSystemDesc: string;
    FSystemServerLogs : Boolean;
    FSystemReadOnly : Boolean;
    FSystemReverseLookupRequired : Boolean;
    FSystemPrivateMode : Boolean;
    FSystemAcceptsExtraData : Boolean;
    FThruputControl : Boolean;

    FMaxThruPut : Cardinal;  //bytes per sec
    FMaxPacketSize : Word; //maximum packet size
    FDirectoryListing: TIdFSPListItems;
    FDirInfo : TIdFSPDirInfo;
    FStatInfo : TIdFSPStatInfo;
    FOnRecv, FOnSend : TIdFSPLogEvent;
    //note:  This is optimized for performance - DO NOT MESS with it even if you don't like it
    //or think its wrong.  There is a performance penalty that is noticable with downloading,
    //uploading, and dirs because those use a series of packets - not one and we limited in
    //packet size.  We also do not want to eat CPU cycles excessively which I've noticed
    //with previous code.
    procedure SendCmd(ACmdPacket, ARecvPacket : TIdFSPPacket; var VTempBuf : TIdBytes; const ARaiseException : Boolean=True); overload;
    procedure SendCmd(const ACmd : Byte; const AData, AExtraData : TIdBYtes;
      const AFilePosition : Int64; //in case FSP 3.0 does support more than 4GB
      var VData, VExtraData : TIdBytes; const ARaiseException : Boolean=True);  overload;
    procedure SendCmd(const ACmd : Byte; const AData : TIdBYtes;
      const AFilePosition : Int64; //in case FSP 3.0 does support more than 4GB
      var VData, VExtraData : TIdBytes; const ARaiseException : Boolean=True); overload;
    procedure ParseDirInfo(const ABuf, AExtraBuf: TIdBytes; ADir : TIdFSPDirInfo);
    procedure InitComponent; override;
  public
    destructor Destroy; override;
    procedure Connect; override; //this is so we can use it similarly to FTP
    procedure Disconnect; override;
    procedure Version;
    procedure Delete(const AFilename: string);
    procedure RemoveDir(const ADirName: string);
    procedure Rename(const ASourceFile, ADestFile: string);
    procedure MakeDir(const ADirName: string);
    //this is so we can use it similarly to FTP
    //and also sends a BYE command which is the courteous thing to do.
    procedure List;  overload;
    procedure List(  
      const ASpecifier: string); overload;
    procedure GetDirInfo(const ADIR : String); overload;
    procedure GetDirInfo(const ADIR : String; ADirInfo : TIdFSPDirInfo); overload;
    procedure GetStatInfo(const APath : String);
    procedure Get(const ASourceFile, ADestFile: string; const ACanOverwrite: boolean = false;
      AResume: Boolean = false); overload;
    procedure Get(const ASourceFile: string; ADest: TStream; AResume: Boolean = false); overload;
    procedure Get(const ASourceFile: string; ADest: TIdStreamVCL; AResume: Boolean = false); overload;
    procedure Put(const ASource: TIdStreamVCL; const ADestFile: string;
       const AGMTTime : TDateTime=0); overload;
    procedure Put(const ASource: TStream; const ADestFile: string;
       const AGMTTime : TDateTime=0); overload;
    procedure Put(const ASourceFile: string; const ADestFile: string=''); overload;
    property SystemDesc: string read FSystemDesc;
    property SystemServerLogs : Boolean read  FSystemServerLogs;
    property SystemReadOnly : Boolean read FSystemReadOnly;
    property SystemReverseLookupRequired : Boolean read FSystemReverseLookupRequired;
    property SystemPrivateMode : Boolean read FSystemPrivateMode;
    property SystemAcceptsExtraData : Boolean read  FSystemAcceptsExtraData;
    property ThruputControl : Boolean read FThruputControl;
    property MaxThruPut : Cardinal read FMaxThruPut;
    property MaxPacketSize : Word read FMaxPacketSize;
    property DirectoryListing: TIdFSPListItems read FDirectoryListing;
    property DirInfo : TIdFSPDirInfo read FDirInfo;
    property StatInfo : TIdFSPStatInfo read FStatInfo;
  published
    property Port default IdPORT_FSP;
    property OnWork;
    property OnWorkBegin;
    property OnWorkEnd;
    property OnRecv : TIdFSPLogEvent read FOnRecv write FOnRecv;
    property OnSend : TIdFSPLogEvent read  FOnSend write FOnSend;
  end;

implementation
uses IdComponent, IdGlobalProtocols, IdResourceStringsProtocols, SysUtils
  IdStack;

//This is from: http://www.swissdelphicenter.ch/en/showcode.php?id=844
const
  // Sets UnixStartDate to TDateTime of 01/01/1970
  UnixStartDate: TDateTime = 25569.0;

function ParseASCIIZ(const ABytes : TIdBytes; const ALen : Cardinal) : String;
var i : Cardinal;
begin
  Result := '';
  if ALen=0 then
  begin
    Exit;
  end;
  for i := 0 to ALen do
  begin
    if ABytes[i]=0 then
    begin
      Break;
    end
    else
    begin
      Result := Result + Char(ABytes[i]);
    end;
  end;
end;

function UnixDateTimeToDelphiDateTime(UnixDateTime: Cardinal): TDateTime;
begin
   Result := (UnixDateTime / 86400) + UnixStartDate;
{
From: http://homepages.borland.com/efg2lab/Library/UseNet/1999/0309b.txt
 }
   //  Result := EncodeDate(1970, 1, 1) + (UnixDateTime / 86400); {86400=No. of secs. per day}
end;

function DateTimeToUnix(ADateTime: TDateTime): Cardinal;
begin
  //example: DateTimeToUnix(now);
  Result := Round((ADateTime - UnixStartDate) * 86400);
end;

procedure ParseStatInfo(const AData : TIdBytes; VL : TIdFSPStatInfo; var VI : Cardinal);
var LC : Cardinal;
begin
  //we don't parse the file type because there is some variation between CC_GET_DIR and CC_STAT
   LC := ((AData[VI] shl 8) or (AData[VI+1] and $FF)) shl 16;
   LC := LC or ((AData[VI+2] and $FF) shl 8) or (AData[VI+3] and $FF);
   VL.FModifiedDateGMT := UnixDateTimeToDelphiDateTime(LC);
   VL.FModifiedDate := VL.FModifiedDateGMT + OffSetFromUTC;
   VI := VI + 4;
   LC := ((AData[VI] shl 8) or (AData[VI+1] and $FF)) shl 16;
   LC := LC or ((AData[VI+2] and $FF) shl 8) or (AData[VI+3] and $FF);
   VL.Size := LC;
   VI := VI + 5;     //we want to skip over the type byte we processed earlier
 
end;

{ TIdFSP }

procedure TIdFSP.Connect;
begin
  FSequence := 1;
  FKey := 0;
  FMaxThruPut := 0;
  FMaxPacketSize := MAXSIZE;
  inherited Connect;
end;

destructor TIdFSP.Destroy;
begin
  Disconnect;
  FreeAndNil( FDirInfo );
  FreeAndNil( FDirectoryListing );
  FreeAndNil( FStatInfo );
  inherited;
end;

procedure TIdFSP.Disconnect;
var
  LBuf,LData, LExtra : TIdBytes;
begin
  if FConEstablished then
  begin
    SetLength(LBuf,0);
    SendCmd( CC_BYE,LBuf,0,LData,LExtra);
    inherited Disconnect;
  end;
  FConEstablished := False;
end;

procedure TIdFSP.Get(const ASourceFile: string; ADest: TStream;
  AResume: Boolean);
var LStream : TIdStreamVCL;
begin
  LStream := TIdStreamVCL.Create(ADest);
  try
    Get(ASourceFile,LStream,AResume);
  finally
    FreeAndNil(LStream);
  end;
end;

procedure TIdFSP.Get(const ASourceFile, ADestFile: string;
  const ACanOverwrite: boolean; AResume: Boolean);
var
  LDestStream: TFileStream;
begin
  if FileExists(ADestFile) then begin
    if ACanOverwrite and (not AResume) then begin
      DeleteFile(ADestFile);
      LDestStream := TFileStream.Create(ADestFile, fmCreate);
    end
    else begin
      if (not ACanOverwrite) and AResume then begin
        LDestStream := TFileStream.Create(ADestFile, fmOpenReadWrite or fmShareDenyWrite);
        LDestStream.Position := LDestStream.Size;
      end
      else begin
        raise EIdFSPFileAlreadyExists.Create(RSDestinationFileAlreadyExists);
      end;
    end;
  end
  else begin
    LDestStream := TFileStream.Create(ADestFile, fmCreate);
  end;

  try
    Get(ASourceFile, LDestStream, AResume);
  finally
    FreeAndNil(LDestStream);
  end;
end;

procedure TIdFSP.Get(const ASourceFile: string; ADest: TIdStreamVCL;
  AResume: Boolean);
var LSendPacket : TIdFSPPacket;
    LRecvPacket :  TIdFSPPacket;
    LLen : Integer;
    LTmpBuf : TIdBytes;
begin
  SetLength(LTmpBuf,MAXSIZE);
  LSendPacket := TIdFSPPacket.Create;
  LRecvPacket :=  TIdFSPPacket.Create;
  try
    if AResume then begin
       LSendPacket.FFilePosition := ADest.VCLStream.Position;
    end
    else
    begin
      LSendPacket.FFilePosition := 0;
    end;
    LSendPacket.Cmd := CC_GET_FILE;
    LSendPacket.FData := ToBytes(ASourceFile+#0);
    LSendPacket.FDataLen := Length(ASourceFile)+1;
    BeginWork(wmRead);
    try
      repeat
         SendCmd(LSendPacket,LRecvPacket,LTmpBuf);
         LLen := LRecvPacket.FDataLen; //Length(LRecvPacket.Data);
         if LLen >0 then
         begin
           ADest.Write(LRecvPacket.Data,LLen);
           DoWork(wmRead,LLen);
           Inc(LSendPacket.FFilePosition,LLen);
         end
         else
         begin
           Break;
         end;
      until False;
    finally
      EndWork(wmRead);
    end;
  finally
    FreeAndNil(LSendPacket);
    FreeAndNil(LRecvPacket);
  end;
end;

procedure TIdFSP.GetDirInfo(const ADIR: String);
begin
  GetDirInfo(ADir,Self.FDirInfo );
end;

procedure TIdFSP.InitComponent;
begin
  inherited;
  Port := IdPORT_FSP;
  FSequence := 0;
  FKey := 0;
   FDirInfo := TIdFSPDirInfo.Create;
  FDirectoryListing:= TIdFSPListItems.Create;
  FStatInfo := TIdFSPStatInfo.Create(nil);
  BroadcastEnabled := False;
  FConEstablished := False;
end;

procedure TIdFSP.List;
begin
  List('/');
end;

procedure TIdFSP.List(const ASpecifier: string);
var

  LSendPacket : TIdFSPPacket;
  LRecvPacket :  TIdFSPPacket;
  LTmpBuf : TIdBytes;
begin
  SetLength(LTmpBuf,MAXSIZE);
  LSendPacket := TIdFSPPacket.Create;
  LRecvPacket :=  TIdFSPPacket.Create;
  try
  //
    LSendPacket.Cmd := CC_GET_DIR;
    LSendPacket.FFilePosition := 0;
    SetLength(LRecvPacket.FData, MAXSIZE );
    SetLength(LSendPacket.FExtraData,0);
    FDirectoryListing.Clear;
    repeat

      if ASpecifier ='' then
      begin
        LSendPacket.Data := ToBytes('/'+#0);
        LSendPacket.DataLen := 2;
      end
      else
      begin
        LSendPacket.Data := ToBytes(ASpecifier+#0);
        LSendPacket.DataLen := Length(LSendPacket.Data);
      end;
      SendCmd(LSendPacket,LRecvPacket,LTmpBuf);

      if LRecvPacket.DataLen > 0 then
      begin
        Inc(LSendPacket.FFilePosition,LRecvPacket.DataLen);
      end
      else
      begin
        Break;
      end;
    until FDirectoryListing.ParseEntries( LRecvPacket.FData, LRecvPacket.FDataLen );
  finally
    FreeAndNil(LSendPacket);
    FreeAndNil(LRecvPacket);
  end;
end;

procedure TIdFSP.SendCmd(const ACmd: Byte; const AData,
  AExtraData: TIdBYtes; const AFilePosition: Int64; var VData,
  VExtraData: TIdBytes; const ARaiseException : Boolean=True);
var LSendPacket : TIdFSPPacket;
    LRecvPacket :  TIdFSPPacket;
    LTmpBuf : TIdBytes;
begin
  SetLength(LTmpBuf,MAXSIZE);
  LSendPacket := TIdFSPPacket.Create;
   LRecvPacket :=  TIdFSPPacket.Create;
  try
    LSendPacket.Cmd := ACmd;
    LSendPacket.FilePosition := AFilePosition;
    LSendPacket.Data := AData;
    LSendPacket.FDataLen := Length(AData);
    LSendPacket.ExtraData := AExtraData;
    SendCmd(LSendPacket,LRecvPacket,LTmpBuf,ARaiseException );
    VData := LRecvPacket.Data;
    VExtraData := LRecvPacket.ExtraData;

  finally
    FreeAndNil(LSendPacket);
    FreeAndNil(LRecvPacket);
  end;
end;

procedure TIdFSP.SendCmd(const ACmd: Byte; const AData: TIdBYtes;
  const AFilePosition: Int64; var VData, VExtraData: TIdBytes; const ARaiseException : Boolean=True);
var LExtraData : TIdBytes;
begin
  SetLength(LExtraData,0);
  SendCmd(ACmd,AData,LExtraData,AFilePosition,VData,VExtraData, ARaiseException);
end;

procedure TIdFSP.Version;
var
  LData, LBuf, LExtraBuf : TIdBytes;
  LDetails : Byte;
  LC : Cardinal;
begin
  SetLength(LData,0);

  SendCmd(CC_VERSION,LData,0,LBuf,LExtraBuf);
  FSystemDesc := ParseASCIIZ( LBuf, Length(LBuf));
  if Length(LExtraBuf)>0 then
  begin
    LDetails := LExtraBuf[0];
    //bit 0 set - server does logging
    FSystemServerLogs := LDetails and $01=$01;
    //bit 1 set - server is read only
    FSystemReadOnly := LDetails and $02=$02;
    //bit 2 set - reverse lookup required
    FSystemReverseLookupRequired := LDetails and $04=$04;
    //bit 3 set - server is in private mode
    FSystemPrivateMode := LDetails and $08=$08;
    //  if bit 4 is set thruput info follows
    FThruputControl := LDetails and $10=$10;
    // bit 5 set - server accept XTRA
   //  DATA on input
    FSystemAcceptsExtraData := LDetails and $20=$20;
    //long - max_thruput allowed (in bytes/sec)
    //word - max. packet size supported by server
    if FThruputControl then
    begin
      if Length(LExtraBuf)>4 then
      begin
        LC := ((LExtraBuf[1] shl 8) or (LExtraBuf[2] and $FF)) shl 16;
        LC := LC or ((LExtraBuf[3] and $FF) shl 8) or (LExtraBuf[4] and $FF);
        FMaxThruPut := LC;
        if Length(LExtraBuf)>6 then
        begin
          LC := ((LExtraBuf[5] shl 8) or (LExtraBuf[6] and $FF));
          FMaxPacketSize := LC and $FFFF;
        end;
      end;
    end
    else
    begin
      if Length(LExtraBuf)>2 then
      begin
        LC := ((LExtraBuf[1] shl 8) or (LExtraBuf[2] and $FF));
        FMaxPacketSize := LC and $FFFF;
      end;
    end;
  end;
end;

procedure TIdFSP.SendCmd(ACmdPacket, ARecvPacket: TIdFSPPacket; var VTempBuf : TIdBytes; const ARaiseException : Boolean=True);
var 
  LLen : Integer;
  LBuf : TIdBytes;
  LSendBuf : TIdBytes;

  LMSec : Integer;
begin
  Inc(FSequence);
  SetLength(LBuf,MAXSIZE);
  ACmdPacket.Key := FKey;
  ACmdPacket.Sequence := FSequence;
  LMSec := MINTIMEOUT;
  LSendBuf := ACmdPacket.WritePacket;
    repeat
      SendBuffer(LSendBuf);

      if Assigned(FOnSend) then
      begin
        FOnSend(Self,ACmdPacket);
      end;
      LLen := ReceiveBuffer( LBuf, LMsec );
      ARecvPacket.ReadPacket(LBuf,LLen);

      if ARecvPacket.FValid then
      begin
        if Assigned(FOnRecv) then
        begin
          FOnRecv(Self,ARecvPacket);
        end;
        if (ARecvPacket.Sequence = FSequence) then
        begin
          break;
        end;
      end;

      LMSec := Round(LMSec * 1.5);
      if LMSec > MAXTIMEOUT then
      begin
        LMSec := MAXTIMEOUT;
      end;  
    until False;
    FKey := ARecvPacket.Key;

    if ARaiseException and (ARecvPacket.Cmd = CC_ERR) then
    begin
      Raise EIdFSPProtException.Create( ParseASCIIZ(ARecvPacket.Data, ARecvPacket.DataLen));
    end;

end;

procedure TIdFSP.GetStatInfo(const APath: String);
var
  LData, LBuf,LExtraBuf : TIdBytes;
  i : Cardinal;
begin
  i := 0;
  LData := ToBytes(APath + #0);
  SendCmd(CC_STAT,LData,0,LBuf,LExtraBuf);
  if Length(LBuf)>8 then
  begin
{


data format is the same as in directory listing with exception
that there is no file name appended. If file do not exists or
there is other problem (no access rights) return type of file is
0.

        struct STAT  {
      long  time;
      long  size;
      byte  type;
}
     case LBuf[8] of
       0 : //file not found
       begin
         raise EIdFSPFileNotFound.Create('');
       end;
       RDTYPE_FILE :
       begin
         FStatInfo.ItemType := ditFile;
       end;
       RDTYPE_DIR :
       begin
         FStatInfo.ItemType := ditDirectory;
       end;
     end;
     ParseStatInfo(LBuf,Self.FStatInfo,i);
  end;
end;

procedure TIdFSP.Put(const ASource: TIdStreamVCL; const ADestFile: string;
  const AGMTTime: TDateTime);
var LUnixDate : Cardinal;
  LSendPacket : TIdFSPPacket;
  LRecvPacket :  TIdFSPPacket;
  LPosition : Cardinal;
  LLen : Integer;
  LTmpBuf : TIdBytes;
begin
  LPosition := 0;
  SetLength( LTmpBuf,MAXSIZE);
  LSendPacket := TIdFSPPacket.Create;
  LRecvPacket :=  TIdFSPPacket.Create;
  try
    SetLength(LSendPacket.FData,MAXSIZE);
    LSendPacket.Cmd := CC_UP_LOAD;
    repeat
      LLen := ASource.ReadBytes(LSendPacket.FData,MAXSIZE,0,False);
      if LLen < MAXSIZE then
      begin
        if LLen = 0 then
        begin
          break;
        end;
      end;
      LSendPacket.FDataLen := LLen;
      LSendPacket.FilePosition := LPosition;

      SendCmd(LSendPacket,LRecvPacket,LTmpBuf);
      if LLen < MAXSIZE then
      begin
        break;
      end;
      inc(LPosition,LLen);
    until False;
    //send the Install packet
    LSendPacket.Cmd := CC_INSTALL;
    LSendPacket.FilePosition := 0;
    LSendPacket.Data := ToBytes(ADestFile+#0);
    LSendPacket.FDataLen := Length(LSendPacket.Data);
    //File date - optional
    if AGMTTime=0 then
    begin
      SetLength(LSendPacket.FExtraData ,0);
    end
    else
    begin
      LUnixDate := DateTimeToUnix(AGMTTime);
      SetLength(LSendPacket.FExtraData,4);

      LSendPacket.FExtraData[0]  := Byte( (LUnixDate shr 24) and $FF);
      LSendPacket.FExtraData[1]  := Byte( (LUnixDate shr 16) and $FF);
      LSendPacket.FExtraData[2] := Byte( (LUnixDate shr 8) and $FF);
      LSendPacket.FExtraData[3] := Byte( LUnixDate and $FF);
    end;
    SendCmd(LSendPacket,LRecvPacket,LTmpBuf);
  finally
    FreeAndNil(LSendPacket);
    FreeAndNil(LRecvPacket);
  end;

end;

procedure TIdFSP.Put(const ASource: TStream; const ADestFile: string;
  const AGMTTime: TDateTime);
var LStream : TIdStreamVCL;
begin
  LStream := TIdStreamVCL.Create(ASource);
  try
    Put(LStream,ADestFile,AGMTTime);
  finally
    FreeAndNil(LStream);
  end;
end;



procedure TIdFSP.Put(const ASourceFile, ADestFile: string);
var
  LSourceStream: TFileStream;
  LDestFileName : String;
begin
  LDestFileName := ADestFile;
  if LDestFileName = '' then
  begin
   LDestFileName := ExtractFileName(ASourceFile);
  end;
  LSourceStream := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyNone); try
    Put(LSourceStream, LDestFileName, GetGMTDateByName(ASourceFile) );
  finally FreeAndNil(LSourceStream); end;
end;

procedure TIdFSP.Delete(const AFilename: string);
var LData : TIdBytes;
  LBuf, LExBuf : TIdBytes;
begin
  LData := ToBytes(AFilename+#0);
  SendCmd(CC_DEL_FILE,LData,0,LBuf, LExBuf);
end;

procedure TIdFSP.MakeDir(const ADirName: string);
var LData : TIdBytes;
  LBuf, LExBuf : TIdBytes;
begin
  LData := ToBytes(ADirName+#0);
  SendCmd(CC_MAKE_DIR,LData,0,LBuf, LExBuf);
  ParseDirInfo(LBuf,LExBuf, FDirInfo);
end;

procedure TIdFSP.RemoveDir(const ADirName: string);
var LData : TIdBytes;
  LBuf, LExBuf : TIdBytes;
begin
  LData := ToBytes(ADirName+#0);
  SendCmd(CC_DEL_DIR,LData,0,LBuf, LExBuf);
end;

procedure TIdFSP.Rename(const ASourceFile, ADestFile: string);
var LBuf, LData, LDataExt : TIdBytes;
begin
   SetLength(LData,0);
   SetLength(LDataExt,0);
   LBuf := ToBytes(ASourceFile+#0+ADestFile);
   SendCmd(CC_RENAME,LBuf,0,LData,LDataExt);
end;

procedure TIdFSP.ParseDirInfo(const ABuf, AExtraBuf: TIdBytes; ADir : TIdFSPDirInfo);
begin
  ADir.ReadMe := ParseASCIIZ(ABuf,Length(ABuf));
  if Length(AExtraBuf)>0 then
  begin
    //0 - caller owns the directory
    ADir.OwnsDir        := AExtraBuf[0] and $01=$01;
    //1 - files can be deleted from this dir
    ADir.CanDeleteFiles := AExtraBuf[0] and $02=$02;
   // 2 - files can be added to this dir
    ADir.CanAddFiles    := AExtraBuf[0] and $04=$04;
    //3 - new subdirectories can be created
    ADir.CanMakeDir     := AExtraBuf[0] and $08=$08;
    //4 - files are NOT readable by non-owners
    ADir.OnlyOwnerCanReadFiles  := AExtraBuf[0] and $10=$10;
    //5 - directory contain an readme file
    ADir.HasReadMe      := AExtraBuf[0] and $20=$20;
    //6 - directory can be listed
    ADir.CanBeListed    := AExtraBuf[0] and $40=$40;
    //7 - files can be renamed in this directory
    ADir.CanRenameFiles := AExtraBuf[0] and $80=$80;
  end;
end;

procedure TIdFSP.GetDirInfo(const ADIR: String; ADirInfo: TIdFSPDirInfo);
var LData, LBuf, LExtraBuf : TIdBytes;
begin
  LData := ToBytes(ADIR+#0);
  SendCmd(CC_GET_PRO,LData,0,LBuf,LExtraBuf);
  ParseDirInfo(LBuf,LExtraBuf, ADirInfo );
end;

{ TIdFSPPacket }

constructor TIdFSPPacket.Create;
begin
  inherited Create;
  FCmd := 0;
  FFilePosition := 0;
  FDataLen := 0;
  SetLength(FData,0);
  SetLength(FExtraData,0);
  FSequence:=0;
  FKey:=0;
end;

function TIdFSPPacket.WritePacket : TIdBytes;
var
   LExtraDataLen : Word;
   LSum : Cardinal;
   i : Integer;
//ported from:
//http://cvs.sourceforge.net/viewcvs.py/fsp/javalib/FSPpacket.java?rev=1.6&view=markup
begin
  SetLength(Result,HSIZE);
  //cmd
  Result[0]  := Cmd;
  //checksum
  Result[1]  := 0;  //this will be the checksum value
  //key
  Result[2]  := Byte( (FKey shr 8) and $FF);
  Result[3]  := Byte( FKey and $FF);
  // sequence
  Result[4]  := Byte( (FSequence shr 8) and $FF);
  Result[5]  := Byte( FSequence and $FF);
  // data length
//  FDataLen       := Length(FData);
  Result[6]  := Byte( ( FDataLen shr 8) and $FF);
  Result[7]  := Byte( FDataLen and $FF);
  // position
  Result[8]  := Byte( (FFilePosition shr 24) and $FF);
  Result[9]  := Byte( (FFilePosition shr 16) and $FF);
  Result[10] := Byte( (FFilePosition shr 8) and $FF);
  Result[11] := Byte( FFilePosition and $FF);
  //end of header
  LExtraDataLen := Length(Self.FExtraData);
  SetLength(Result,HSIZE+FDataLen+LExtraDataLen);
  //data section
  if FDataLen >0 then
  begin
    CopyTIdBytes(FData,0,Result,HSIZE,FDataLen);
  end;
  //extra data section
  if LExtraDataLen>0 then
  begin
    CopyTIdBytes(FExtraData, 0,Result,HSIZE+FDataLen,LExtraDataLen);
  end;
  //checksum
  LSum := HSIZE + FDataLen + LExtraDataLen;
  for i := (HSIZE + FDataLen + LExtraDataLen) - 1 downto 0 do begin
	  LSum:=LSum + (Result[i] and $FF);
  end;
  Result[1]:=byte(LSum+(LSum shr 8));
end;

procedure TIdFSPPacket.ReadPacket(const AData : TIdBytes; const ALen : Cardinal);
var
  LSum, LnSum, LcSum : Cardinal; //cardinal to prevent a range-check error
  t : Word;
  LExtraDataLen : Cardinal;

begin
  FValid := True;
  if Length(AData)<HSIZE then
  begin
    FValid := False;
    Exit;
  end;
  //check data length
  FDataLen := ((AData[6] shl 8) or (AData[7] and $FF));
  FDataLen := FDataLen and $FFFF;
  if FDataLen > Cardinal(Length(AData)) then
  begin
    FValid := False;
  end;
 // LExtraLen := Length(Value)-(HSIZE + FDataLen);
  //validate checksum
  LSum := AData[1]; //checksum
  AData[1] := 0; //zero it out so we can verify the data
  LnSum := Cardinal(Length(AData));
  t:=Lnsum-1;
  Lnsum:=0;
  for t:=t downto 0 do begin
      Lnsum := Lnsum + (AData[t] and $FF);
  end;
  lcsum:=byte(Lnsum + (Lnsum shr 8));
  if LcSum <> LSum then
  begin
    FValid := False;
  end;
  //command
  FCmd :=AData[0];
  //key
  FKey := ((AData[2] shl 8) or (AData[3] and $FF));
  // sequence
  FSequence := ((AData[4] shl 8) or (AData[5] and $FF));
  //6-7 are data length which was already processed
  //file position

  FFilePosition := ((AData[8] shl 8) or (AData[9] and $FF)) shl 16;
  FFilePosition := FFilePosition or ((AData[10] and $FF) shl 8) or (AData[11] and $FF);
  //extract data
  if FDataLen > Cardinal(Length(FData)) then
  begin
    SetLength(FData,FDataLen);
  end;
  if FDataLen >0 then
  begin
    CopyTIdBytes(AData,HSIZE,FData,0,FDataLen);
  end;
  LExtraDataLen := Cardinal(Length(AData)) - (HSIZE+FDataLen);
  //extract extra data
  if LExtraDataLen>0 then
  begin
    SetLength(FExtraData,LExtraDataLen);
    CopyTIdBytes(AData,HSIZE+FDataLen,FExtraData,0,LExtraDataLen);
  end
  else
  begin
    SetLength(FExtraData,0);
  end;
end;

{ TIdFSPListItems }

function TIdFSPListItems.Add: TIdFSPListItem;
begin
  Result := TIdFSPListItem(inherited Add);
end;

constructor TIdFSPListItems.Create;
begin
  inherited Create(TIdFSPListItem);
end;

function TIdFSPListItems.GetItems(AIndex: Integer): TIdFSPListItem;
begin
  Result := TIdFSPListItem(inherited Items[AIndex]);
end;

function TIdFSPListItems.IndexOf(AItem: TIdFSPListItem): Integer;
Var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if AItem = Items[i] then begin
      result := i;
      break;
    end;

end;

function TIdFSPListItems.ParseEntries(const AData: TIdBytes; const ADataLen : Cardinal) : Boolean;
var 
  i : Cardinal;
  LI : TIdFSPListItem;
  LSkip : Boolean;
  LFileName : String;
begin
  Result := False;
  i := 0;
  repeat
    if i < (ADataLen-9) then
    begin
      LI := nil;
      LSkip := False;
      case AData[i+8] of
        RDTYPE_END  :
        begin
          Result := True;
          Exit;
        end;
        RDTYPE_FILE :
        begin
          LI := Add;
          LI.ItemType := ditFile;
        end;
        RDTYPE_DIR  :
        begin
          LI := Add;
          LI.ItemType := ditDirectory;
        end;
        RDTYPE_SKIP :
        begin
          LSkip := True;
        end
      else
        Exit;
      end;
      if LSkip then
      begin
        i := i + 8;
      end
      else
      begin
        ParseStatInfo(AData,LI,i);
      end;
      if not LSkip then
      begin
        LFileName := '';
        repeat
          if i>=ADataLen then
          begin
            Break;
          end;
          if AData[i]=0 then
          begin
            break;
          end
          else
          begin
            LFileName := LFileName + Char(AData[i]);
          end;
          inc(i);
        until (i >= ADataLen);
        LI.FileName := LFileName;
      end;
      repeat
        inc(i);
      until (i and $03)=0;
    end
    else
    begin
      Exit;
    end;
  until False;
end;

procedure TIdFSPListItems.SetItems(AIndex: Integer; const Value: TIdFSPListItem);
begin
  inherited Items[AIndex] := Value;
end;

end.
