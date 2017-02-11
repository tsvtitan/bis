// DO NOT EDIT THIS FILE - WARNING WARNING - Generated file
unit DBXRowBlobStreamReader;
interface
uses
  DBXCommon,
  DBXJSonStreamReader,
  DBXJSonStreamWriter,
  SysUtils;
type
  TDBXRowBlobStreamReader = class(TDBXStreamReader)
  public
    procedure Init(IsBlobHeader: Boolean; Size: Int64; BufferSize: Integer);
    procedure Store(InBuffer: TBytes; InOffset: Integer; Count: Integer); overload;
    function Read(const Buf: TBytes; Offset: Integer; Size: Integer): Integer; override;
    function Eos: Boolean; override;
    function Size: Int64; override;
    destructor Destroy; override;
  private
    procedure InitBufferTo(BufferSize: Integer);
    procedure Store(Count: Integer); overload;
  private
    FDbxStreamReader: TDBXJSonStreamReader;
    FDbxStreamWriter: TDBXJSonStreamWriter;
    FHandle: Integer;
    FId: Integer;
    FOrdinal: Integer;
    FRow: Int64;
    FClient: Boolean;
    FParameterBuffer: Boolean;
    FBuffer: TBytes;
    FBufferBytes: Integer;
    FBufferOffset: Integer;
    FHasMoreData: Boolean;
    FEos: Boolean;
    FKnownSize: Int64;
  public
    property Buffer: TBytes read FBuffer;
    property StreamReader: TDBXJSonStreamReader write FDbxStreamReader;
    property StreamWriter: TDBXJSonStreamWriter write FDbxStreamWriter;
    property Handle: Integer write FHandle;
    property Id: Integer write FId;
    property Ordinal: Integer write FOrdinal;
    property Row: Int64 write FRow;
    property Client: Boolean write FClient;
    property ParameterBuffer: Boolean read FParameterBuffer write FParameterBuffer;
  end;

implementation
uses
  DBXPlatform,
  DBXPlatformUtil,
  DBXTokens;

procedure TDBXRowBlobStreamReader.Init(IsBlobHeader: Boolean; Size: Int64; BufferSize: Integer);
begin
  InitBufferTo(BufferSize);
  FEos := False;
  FHasMoreData := True;
  if IsBlobHeader then
    self.FKnownSize := Size
  else 
  begin
    FKnownSize := -1;
    FBufferBytes := BufferSize;
    FBufferOffset := 0;
  end;
end;

procedure TDBXRowBlobStreamReader.InitBufferTo(BufferSize: Integer);
begin
  if (FBuffer = nil) or (Length(FBuffer) < BufferSize) then
    SetLength(FBuffer,BufferSize);
end;

procedure TDBXRowBlobStreamReader.Store(InBuffer: TBytes; InOffset: Integer; Count: Integer);
begin
  InitBufferTo(Count);
  TDBXPlatform.CopyByteArray(InBuffer, InOffset, self.FBuffer, 0, Count);
  FBufferBytes := Count;
  FBufferOffset := 0;
end;

procedure TDBXRowBlobStreamReader.Store(Count: Integer);
begin
  InitBufferTo(Count);
  FDbxStreamReader.ReadDataBytes(FBuffer, 0, Count);
  FBufferBytes := Count;
  FBufferOffset := 0;
end;

function TDBXRowBlobStreamReader.Read(const Buf: TBytes; Offset: Integer; Size: Integer): Integer;
var
  ReturnBytes: Integer;
  TransferBytes: Integer;
  AvailableBytes: Integer;
begin
  ReturnBytes := 0;
  if FBufferBytes > 0 then
  begin
    TransferBytes := FBufferBytes;
    if Size < TransferBytes then
      TransferBytes := Size;
    TDBXPlatform.CopyByteArray(FBuffer, FBufferOffset, Buf, Offset, TransferBytes);
    Offset := Offset + TransferBytes;
    FBufferOffset := FBufferOffset + TransferBytes;
    FBufferBytes := FBufferBytes - TransferBytes;
    ReturnBytes := ReturnBytes + TransferBytes;
    Size := Size - TransferBytes;
    if Size < 1 then
    begin
      Result := ReturnBytes;
      exit;
    end;
  end;
  if not FHasMoreData then
  begin
    FEos := True;
    begin
      Result := ReturnBytes;
      exit;
    end;
  end;
  if FClient then
  begin
    FDbxStreamWriter.WriteMoreBlobObject(FHandle, FId, FRow, FOrdinal, FParameterBuffer);
    FDbxStreamReader.NextResultObjectStart;
    FDbxStreamReader.Next(TDBXTokens.ArrayStartToken);
  end
  else 
    FDbxStreamWriter.WriteMoreBlobResultObject(FHandle, FId, FRow, FOrdinal);
  FDbxStreamReader.Next(TDBXTokens.ObjectStartToken);
  FDbxStreamReader.Next(TDBXTokens.StringStartToken);
  FDbxStreamReader.ReadStringCode;
  FDbxStreamReader.Next(TDBXTokens.NameSeparatorToken);
  FDbxStreamReader.Next(TDBXTokens.ArrayStartToken);
  AvailableBytes := FDbxStreamReader.ReadInt;
  FDbxStreamReader.Next(TDBXTokens.ValueSeparatorToken);
  if AvailableBytes < 0 then
  begin
    FHasMoreData := False;
    AvailableBytes := -AvailableBytes;
  end;
  TransferBytes := AvailableBytes;
  if Size < TransferBytes then
    TransferBytes := Size;
  ;
  FDbxStreamReader.ReadDataBytes(Buf, Offset, TransferBytes);
  AvailableBytes := AvailableBytes - TransferBytes;
  if AvailableBytes > 0 then
    Store(AvailableBytes);
  FDbxStreamReader.SkipToEndOfObject;
  if FClient then
    FDbxStreamReader.SkipToEndOfObject;
  ReturnBytes := ReturnBytes + TransferBytes;
  Result := ReturnBytes;
end;

function TDBXRowBlobStreamReader.Eos: Boolean;
begin
  Result := FEos;
end;

function TDBXRowBlobStreamReader.Size: Int64;
begin
  Result := FKnownSize;
end;

destructor TDBXRowBlobStreamReader.Destroy;
begin
  FBuffer := nil;
  inherited Destroy;
end;
//    Diagnostic.freeAndNullout(dbxStreamReader);
//    Diagnostic.freeAndNullout(dbxStreamWriter);

end.