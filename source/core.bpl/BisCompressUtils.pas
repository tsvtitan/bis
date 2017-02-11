unit BisCompressUtils;

interface

uses Classes, ZLib;

procedure CompressStream(Stream: TStream; Level: TCompressionLevel);
function CompressString(const S: String; Level: TCompressionLevel): String;

procedure DecompressStream(Stream: TStream);
function DecompressString(const S: String): String;

implementation

procedure CompressStream(Stream: TStream; Level: TCompressionLevel);
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Zip:=TCompressionStream.Create(Level,TempStream);
      try
        Stream.Position:=0;
        Zip.CopyFrom(Stream,Stream.Size);
      finally
        Zip.Free;
      end;
      Stream.Size:=0;
      TempStream.Position:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      TempStream.Free;
    end;
  end;
end;

function CompressString(const S: String; Level: TCompressionLevel): String;
var
  Stream: TStringStream;
begin
  Result:=S;
  if S<>'' then begin
    Stream:=TStringStream.Create(S);
    try
      Stream.Position:=0;
      CompressStream(Stream,Level);
      SetLength(Result,Stream.Size);
      Stream.Read(Pointer(Result)^,Length(Result));
    finally
      Stream.Free;
    end;
  end;
end;

procedure DecompressStream(Stream: TStream);
var
  Zip: TDecompressionStream;
  Count: Integer;
  Buffer: array[0..1023] of Char;
  TempStream: TMemoryStream;
begin
  if Assigned(Stream) then begin
    TempStream:=TMemoryStream.Create;
    try
      Stream.Position:=0;
      Zip:=TDecompressionStream.Create(Stream);
      try
        repeat
          Count:=Zip.Read(Buffer,SizeOf(Buffer));
          TempStream.Write(Buffer,Count);
        until Count=0;
      finally
        Zip.Free;
      end;
      TempStream.Position:=0;
      Stream.Size:=0;
      Stream.CopyFrom(TempStream,TempStream.Size);
      Stream.Position:=0;
    finally
      TempStream.Free;
    end;
  end;
end;

function DecompressString(const S: String): String;
var
  Stream: TStringStream;
begin
  Result:=S;
  if S<>'' then begin
    Stream:=TStringStream.Create(S);
    try
      Stream.Position:=0;
      DecompressStream(Stream);
      SetLength(Result,Stream.Size);
      Stream.Read(Pointer(Result)^,Length(Result));
    finally
      Stream.Free;
    end;
  end;
end;

end.
