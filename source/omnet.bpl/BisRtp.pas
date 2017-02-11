unit BisRtp;

interface

uses Classes, Contnrs, Sysutils,
     BisLocks;

type

  TBisRtpPacketVersion=(vZero,vFirst,vSecond,vThird);

  TBisRtpPacketPayloadType=(ptUnknown,ptPCMU,ptReserved1,ptReserved2,ptGSM,ptG723,ptDVI4r8000,ptDVI4r16000,ptLPC,
                            ptPCMA,ptG722,ptL16r44100c2,ptL16r44100c1,ptQCELP,ptCN,ptMPA,ptG728,
                            ptDVI4r11025,ptDVI4r22050,ptG729,ptReserved19,
                            pt20,pt21,pt22,pt23,pt24,pt25,pt26,pt27,pt28,pt29,pt30,pt31,pt32,pt33,pt34,pt35,pt36,pt37,pt38,pt39,
                            pt40,pt41,pt42,pt43,pt44,pt45,pt46,pt47,pt48,pt49,pt50,pt51,pt52,pt53,pt54,pt55,pt56,pt57,pt58,pt59,
                            pt60,pt61,pt62,pt63,pt64,pt65,pt66,pt67,pt68,pt69,pt70,pt71,pt72,pt73,pt74,pt75,pt76,pt77,pt78,pt79,
                            pt80,pt81,pt82,pt83,pt84,pt85,pt86,pt87,pt88,pt89,pt90,pt91,pt92,pt93,pt94,pt95,pt96,pt97,pt98,pt99,
                            pt100,pt101,pt102);
                            
  TBisRtpPacketPayloadTypes=set of TBisRtpPacketPayloadType;                             

  TBisRtpPacketCSRCList=class(TList)
  private
    function GetItem(Index: Integer): LongWord;
  public
    function Add(CSRC: LongWord): Boolean;

    property Items[Index: Integer]: LongWord read GetItem; default;
  end;

  TBisRtpPacket=class(TObject)
  private
    FVersion: TBisRtpPacketVersion;
    FPadding: Boolean;
    FSSRCIdentifier: LongWord;
    FSequence: Word;
    FPayloadType: TBisRtpPacketPayloadType;
    FMarker: Boolean;
    FExtension: Boolean;
    FTimeStamp: LongWord;
    FCSRCList: TBisRtpPacketCSRCList;
    FExternalHeader: TBytes;
    FPayload: TBytes;

    function CalcWord(A, B: Byte): Word;
    function CalcLongWord(A, B: Word): LongWord;
    function GetBit(Value: Byte; Bit: Byte): Boolean;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const Body: String); overload;
    procedure Parse(Data: TBytes); overload;
    function GetData(var Data: TBytes): Boolean; overload;
    function GetData(var Data: String): Boolean; overload;
    procedure SetPayload(const Payload: TBytes); overload;
    procedure SetPayLoad(const Payload: String); overload;

    property CSRCList: TBisRtpPacketCSRCList read FCSRCList;

    property Version: TBisRtpPacketVersion read FVersion write FVersion;
    property Padding: Boolean read FPadding write FPadding;
    property Extension: Boolean read FExtension write FExtension;
    property Marker: Boolean read FMarker write FMarker;
    property PayloadType: TBisRtpPacketPayloadType read FPayloadType write FPayloadType;
    property Sequence: Word read FSequence write FSequence;
    property TimeStamp: LongWord read FTimeStamp write FTimeStamp;
    property SSRCIdentifier: LongWord read FSSRCIdentifier write FSSRCIdentifier;
    property ExternalHeader: TBytes read FExternalHeader write FExternalHeader;
    property Payload: TBytes read FPayload write SetPayload;
  end;

  TBisRtpPackets=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisRtpPacket;
    function FindLast(Packet: TBisRtpPacket): Integer;
  public

    procedure InsertLast(Packet: TBisRtpPacket);
    procedure SavePayloadToStream(Stream: TStream; PayloadType: TBisRtpPacketPayloadType; FromIndex: Integer=0);

    property Items[Index: Integer]: TBisRtpPacket read GetItem; default;
  end;

implementation

uses Windows,
     IdGlobal;

const
  HeaderLength=12;

{ TBisRtpPacketCSRCList }

function TBisRtpPacketCSRCList.Add(CSRC: LongWord): Boolean;
begin
  Result:=inherited Add(Pointer(CSRC))<>-1;
end;

function TBisRtpPacketCSRCList.GetItem(Index: Integer): LongWord;
begin
  Result:=LongWord(inherited Items[Index]);
end;

{ TBisRtpPacket }

constructor TBisRtpPacket.Create;
begin
  inherited Create;
  FCSRCList:=TBisRtpPacketCSRCList.Create;
  SetLength(FExternalHeader,0);
  SetLength(FPayload,0);
end;

destructor TBisRtpPacket.Destroy;
begin
  FCSRCList.Free;
  inherited Destroy;
end;

function TBisRtpPacket.CalcWord(A, B: Byte): Word;
begin
  Result:=A or B shl 8;
end;

function TBisRtpPacket.CalcLongWord(A, B: Word): LongWord;
begin
  Result:=A or B shl 16;
end;

function TBisRtpPacket.GetBit(Value: Byte; Bit: Byte): Boolean;
begin
  Result:=(Value and (1 shl Bit)) <> 0;
end;

procedure TBisRtpPacket.Parse(Data: TBytes);
var
  PayloadOffset: Integer;

  function GetByte(Index: Integer; var B: Byte): Boolean;
  var
    L: Integer;
  begin
    Result:=false;
    L:=Length(Data);
    if (Index>=0) and (Index<L) then begin
      B:=Data[Index];
      Result:=true;
    end;
  end;

  function GetWord(Index: Integer; var W: Word): Boolean;
  var
    L: Integer;
    B1, B2: Byte;
  begin
    Result:=false;
    L:=Length(Data);
    if (Index>=0) and (Index<L) then begin
      B2:=Data[Index];
      if ((Index+1)>=0) and ((Index+1)<L) then begin
        B1:=Data[Index+1];
        W:=CalcWord(B1,B2);
        Result:=true;
      end;
    end;
  end;

  function GetLongWord(Index: Integer; var LW: LongWord): Boolean;
  var
    W1, W2: Word;
  begin
    Result:=false;
    if GetWord(Index,W2) and GetWord(Index+2,W1) then begin
      LW:=CalcLongWord(W1,W2);
      Result:=true;
    end;
  end;

  function GetValue(Index: Integer; FromBit, ToBit: Byte): Word;
  var
    B: Byte;
    i: Byte;
    Bi: Boolean;
  begin
    Result:=0;
    if GetByte(Index,B) then begin
      for i:=ToBit downto FromBit do begin
        Bi:=GetBit(B,i);
        if Bi then begin
          Result:=Result or (1 shl i);
        end;
      end;
    end;
  end;

  procedure GetVersion;
  var
    B: Byte;
    B6, B7: Boolean;
  begin
    FVersion:=vZero;
    if GetByte(0,B) then begin
      B6:=GetBit(B,6);
      B7:=GetBit(B,7);
      if B6 and B7 then
        FVersion:=vThird
      else if B6 then
        FVersion:=vFirst
      else if B7 then
        FVersion:=vSecond;
    end;
  end;

  procedure GetPadding;
  var
    B: Byte;
  begin
    FPadding:=false;
    if GetByte(0,B) then
      FPadding:=GetBit(B,5);
  end;

  procedure GetExtension;
  var
    B: Byte;
  begin
    FExtension:=false;
    if GetByte(0,B) then
      FExtension:=GetBit(B,4);
  end;

  procedure GetCSRCCount(var ACount: Byte);
  begin
    ACount:=GetValue(0,0,3);
  end;

  procedure GetMarker;
  var
    B: Byte;
  begin
    FMarker:=false;
    if GetByte(1,B) then
      FMarker:=GetBit(B,7);
  end;

  procedure GetPayloadType;
  begin
    FPayloadType:=TBisRtpPacketPayloadType(GetValue(1,0,6)+1);
  end;

  procedure GetSequence;
  var
    W: Word;
  begin
    FSequence:=0;
    if GetWord(2,W) then
      FSequence:=W;
  end;

  procedure GetTimeStamp;
  var
    LW: LongWord;
  begin
    FTimeStamp:=0;
    if GetLongWord(4,LW) then
      FTimeStamp:=LW;
  end;

  procedure GetSSRCIdentifier;
  var
    LW: LongWord;
  begin
    FSSRCIdentifier:=0;
    if GetLongWord(8,LW) then begin
      FSSRCIdentifier:=LW;
      PayloadOffset:=12;
    end;
  end;

  procedure GetCRSCList(ACount: Byte);
  var
    i: Byte;
    LW: LongWord;
    Index: Integer;
  begin
    FCSRCList.Clear;
    if ACount>0 then begin
      Index:=PayloadOffset;
      for i:=0 to ACount-1 do begin
        if GetLongWord(Index,LW) then
          FCSRCList.Add(LW);
        Inc(Index,SizeOf(LongWord));
        PayloadOffset:=Index;
      end;
    end;
  end;

  procedure GetExternalHeader;
  var
    LW: LongWord;
    i: Integer;
    Index: Integer;
    B: Byte;
  begin
    SetLength(FExternalHeader,0);
    if FExtension then begin
      if GetLongWord(PayloadOffset,LW) then begin
        SetLength(FExternalHeader,LW);
        Inc(PayloadOffset,SizeOf(LW));
        for i:=0 to LW-1 do begin
          Index:=PayloadOffset+i;
          if GetByte(Index,B) then
            FExternalHeader[i]:=B;
        end;
        Inc(PayloadOffset,LW);
      end;
    end;
  end;

  procedure GetPayload;
  var
    L: Integer;
  begin
    SetLength(FPayload,0);
    L:=Length(Data);
    if (PayloadOffset>=0) and (PayloadOffset<L) then begin
      L:=L-PayloadOffset;
      SetLength(FPayload,L);
      FPayload:=Copy(Data,PayloadOffset,L);
    end;
  end;

var
  CRSÑCount: Byte;
begin
  PayloadOffset:=0;
  if Length(Data)>=HeaderLength then begin
    GetVersion;
    GetPadding;
    GetExtension;
    GetCSRCCount(CRSÑCount);
    GetMarker;
    GetPayloadType;
    GetSequence;
    GetTimeStamp;
    GetSSRCIdentifier;
    GetCRSCList(CRSÑCount);
    GetExternalHeader;
    GetPayload;
  end;
end;

procedure TBisRtpPacket.SetPayload(const Payload: String);
begin
  SetPayload(ToBytes(Payload));
end;

procedure TBisRtpPacket.SetPayload(const Payload: TBytes);
var
  L: Integer;
begin
  L:=Length(Payload);
  SetLength(FPayload,L);
  Move(Pointer(Payload)^,Pointer(FPayload)^,L)
end;

procedure TBisRtpPacket.Parse(const Body: String);
begin
  Parse(ToBytes(Body));
end;

function TBisRtpPacket.GetData(var Data: TBytes): Boolean;

  procedure SetBit(var Value: Byte; Bit: Byte);
  begin
    Value:=Value or (1 shl Bit);
  end;

  function GetByte(Index: Integer; var B: Byte): Boolean;
  var
    L: Integer;
  begin
    Result:=false;
    L:=Length(Data);
    if (Index>=0) and (Index<L) then begin
      B:=Data[Index];
      Result:=true;
    end;
  end;

  function SetByte(Index: Integer; B: Byte): Boolean;
  var
    L: Integer;
  begin
    Result:=false;
    L:=Length(Data);
    if (Index>=0) and (Index<L) then begin
      Data[Index]:=B;
      Result:=true;
    end;
  end;

  procedure SetValue(Index: Integer; FromBit, ToBit: Byte; Value: Word);
  var
    B: Byte;
    i: Byte;
    Bi: Boolean;
  begin
    if GetByte(Index,B) then begin
      for i:=ToBit downto FromBit do begin
        Bi:=GetBit(Value,i);
        if Bi then begin
          SetBit(B,i);
          SetByte(Index,B);
        end;
      end;
    end;
  end;

  procedure SetWord(Index: Integer; W: Word);
  var
    L: Integer;
    B1, B2: Byte;
  begin
    L:=Length(Data);
    B1:=Hi(W);
    B2:=Lo(W);
    if (Index>=0) and (Index<L) then begin
      Data[Index]:=B1;
      if ((Index+1)>=0) and ((Index+1)<L) then begin
        Data[Index+1]:=B2;
      end;
    end;
  end;

  procedure SetLongWord(Index: Integer; LW: LongWord);
  var
    W1, W2: Word;
  begin
    W1:=HiWord(LW);
    W2:=LoWord(LW);
    SetWord(Index,W1);
    SetWord(Index+2,W2);
  end;

  procedure SetVersion;
  var
    B: Byte;
  begin
    if GetByte(0,B) then begin
      case FVersion of
        vZero: ;
        vFirst: SetBit(B,6);
        vSecond: SetBit(B,7);
        vThird: begin
          SetBit(B,6);
          SetBit(B,7);
        end;
      end;
      SetByte(0,B);
    end;
  end;

  procedure SetPadding;
  var
    B: Byte;
  begin
    if FPadding then begin
      if GetByte(0,B) then begin
        SetBit(B,5);
        SetByte(0,B);
      end;
    end;
  end;

  procedure SetExtension;
  var
    B: Byte;
  begin
    if FExtension then begin
      if GetByte(0,B) then begin
        SetBit(B,4);
        SetByte(0,B);
      end;
    end;
  end;

  procedure SetCSRCCount;
  begin
    if FCSRCList.Count>0 then
      SetValue(0,0,3,FCSRCList.Count);
  end;

  procedure SetMarker;
  var
    B: Byte;
  begin
    if FMarker then begin
      if GetByte(1,B) then begin
        SetBit(B,7);
        SetByte(1,B);
      end;
    end;
  end;

  procedure SetPayloadType;
  begin
    SetValue(1,0,6,Word(FPayloadType)-1);
  end;

  procedure SetSequence;
  begin
    SetWord(2,FSequence);
  end;

  procedure SetTimeStamp;
  begin
    SetLongWord(4,FTimeStamp);
  end;

  procedure SetSSRCIdentifier;
  begin
    SetLongWord(8,FSSRCIdentifier);
  end;

  procedure SetCRSCList;
  var
    DataL, L: Integer;
    i: Integer;
    Index: Integer;
  begin
    if FCSRCList.Count>0 then begin
      L:=FCSRCList.Count*SizeOf(LongWord);
      DataL:=Length(Data);
      SetLength(Data,DataL+L);
      for i:=0 to FCSRCList.Count-1 do begin
        Index:=DataL+i;
        SetLongWord(Index,FCSRCList.Items[i]);
      end;
    end;
  end;

  procedure SetExternalHeader;
  var
    DataL: Integer;
    HeaderL: Integer;
    i: Integer;
    Index: Integer;
  begin
    if FExtension then begin
      DataL:=Length(Data);
      HeaderL:=Length(FExternalHeader);
      SetLength(Data,DataL+HeaderL+SizeOf(LongWord));
      SetLongWord(DataL,HeaderL);
      for i:=0 to HeaderL-1 do begin
        Index:=DataL+i+SizeOf(LongWord);
        SetLongWord(Index,FExternalHeader[i]);
      end;
    end;
  end;

  procedure SetPayload;
  var
    DataL: Integer;
    PayloadL: Integer;
  begin
    DataL:=Length(Data);
    PayloadL:=Length(FPayload);
    if PayloadL>0 then begin
      SetLength(Data,DataL+PayloadL);
      Move(Pointer(FPayload)^,Pointer(Integer(Data)+DataL)^,PayloadL);
    end;
  end;

begin
  SetLength(Data,HeaderLength);
  SetVersion;
  SetPadding;
  SetExtension;
  SetCSRCCount;
  SetMarker;
  SetPayloadType;
  SetSequence;
  SetTimeStamp;
  SetSSRCIdentifier;
  SetCRSCList;
  SetExternalHeader;
  SetPayload;
  Result:=Length(Data)>0;
end;

function TBisRtpPacket.GetData(var Data: String): Boolean;
var
  AData: TBytes;
begin
  Result:=GetData(AData);
  if Result then
    Data:=BytesToString(AData);
end;

{ TBisRtpPackets }

function TBisRtpPackets.GetItem(Index: Integer): TBisRtpPacket;
begin
  Result:=TBisRtpPacket(inherited Items[Index]);
end;

function TBisRtpPackets.FindLast(Packet: TBisRtpPacket): Integer;
var
  i: Integer;
  Item: TBisRtpPacket;
begin
  Result:=0;
  if Assigned(Packet) then begin
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      if Item.FTimeStamp<Packet.TimeStamp then begin
        Result:=i;
        exit;
      end;
    end;
  end;
end;

procedure TBisRtpPackets.InsertLast(Packet: TBisRtpPacket);
var
  Index: Integer;
begin
  Index:=FindLast(Packet);
  Insert(Index,Packet);
end;

procedure TBisRtpPackets.SavePayloadToStream(Stream: TStream; PayloadType: TBisRtpPacketPayloadType; FromIndex: Integer=0);
var
  i: Integer;
  Item: TBisRtpPacket;
begin
  if Assigned(Stream) then begin
    for i:=FromIndex to Count-1 do begin
      Item:=Items[i];
      if Item.PayloadType=PayloadType then
        Stream.Write(Pointer(Item.Payload)^,Length(Item.Payload));
    end;
  end;
end;

end.
