{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXPlatform;

interface
uses
      SysUtils, FMTBcd, SqlTimSt
{$IF DEFINED(CLR)}
  , System.Text, System.Threading
{$ELSE}
  , Windows
{$IFEND}
;


type

  TInt32                = LongInt;
  TDBXWideChars         = array of WideChar;
  TDBXInt32s            = array of Integer;
//  TUInt32               = LongWord;

{$IF DEFINED(WIN32)}
  TDBXByteArray            = PByte;
  TDBXWideString           = PWideChar;
  TDBXAnsiString           = PChar;
  TDBXWideStringVar        = PWideChar;
  TDBXAnsiStringVar        = PChar;
  TDBXWideStringBuilder    = PWideChar;
  TDBXAnsiStringBuilder    = PChar;
{$ELSE IF DEFINED(CLR)}
  TDBXByteArray            = array of byte;
  TDBXWideCharArray        = array of char;
  TDBXWideString           = String;
  TDBXAnsiString           = String;
  TDBXWideStringVar        = StringBuilder;
  TDBXAnsiStringVar        = StringBuilder;
  TDBXWideStringBuilder    = StringBuilder;
  TDBXAnsiStringBuilder    = StringBuilder;
{$IFEND}

TDBXPlatform = class
  class function StrToBytes(const Value: String): TBytes; static;
  class function WideStrToBytes(const Value: WideString): TBytes; static; inline;
  class function BytesToWideStr(const Value: TBytes): WideString; static; inline;

  class function GetStringBuilderLength(const Value: TDBXAnsiStringBuilder): TInt32; static;
  class function CreateStringBuilder(Length:  TInt32): TDBXAnsiStringBuilder; static;
  class function ToString(const Value: TDBXAnsiStringBuilder): String; static;
  class procedure CopyStringBuilder(const Value: TDBXAnsiStringBuilder; var Dest: String); static; inline;
  class procedure FreeAndNilStringBuilder(var Value: TDBXAnsiStringBuilder); static;
  class procedure ResizeStringBuilder(var Value: TDBXAnsiStringBuilder; Size: Integer); static;

  class function GetWideStringBuilderLength(const Value: TDBXWideStringBuilder): TInt32; static; inline;
  class function CreateWideStringBuilder(Length:  TInt32): TDBXWideStringBuilder; static; inline;
  class function ToWideString(const Value: TDBXWideStringBuilder): WideString; static; inline;
  class procedure CopyWideStringBuilder(const Value: TDBXWideStringBuilder; var Dest: WideString); static; inline;
  class procedure ResizeWideStringBuilder(var Value: TDBXWideStringBuilder; Size: Integer); static; inline;
  class procedure FreeAndNilWideStringBuilder(var Value: TDBXWideStringBuilder); static;
  class procedure CopyWideStringToBuilder(const Source: WideString; var Value: TDBXWideStringBuilder); static;

  class procedure CopyInt32Array(const Source: TDBXInt32s; SourceOffset: Integer; const Dest: TDBXInt32s; DestOffset: Integer; Count: Integer); static; inline;
  class procedure CopyCharArray(const Source: TDBXWideChars; SourceOffset: Integer; const Dest: TDBXWideChars; DestOffset: Integer; Count: Integer); static; inline;
  class procedure CopyByteArray(const Source: TBytes; SourceOffset: Integer; const Dest: TBytes; DestOffset: Integer; Count: Integer); static; inline;
  class function  CreateWideString(const Source: TDBXWideChars; Count: Integer): WideString; static; inline;
  class procedure WriteAsciiBytes(const Message: String; ByteBuffer: TBytes; Offset: Integer; Count: Integer);
  class function  Int64BitsToDouble(const value: Int64): Double;
  class function  DoubleToInt64Bits(const value: Double): Int64;
  class function Int32BitsToSingle(const value: TInt32): Single; static;
  class function SingleToInt32Bits(const Value: Single): TInt32; static;

  class procedure CopyInt32(const Value: Integer; const Dest: TBytes; const DestOffset: Integer); static; inline;
  class procedure CopyInt16(const Value: SmallInt; const Dest: TBytes; const DestOffset: Integer); static; inline;
  class procedure CopyInt64(const Value: Int64; const Dest: TBytes; const DestOffset: Integer); static; inline;
  class procedure CopySqlTimeStamp(const Value: TSQLTimeStamp; const Dest: TBytes; const DestOffset: Integer); static; inline;
  class procedure CopyBcd(const Value: TBcd; const Dest: TBytes; const DestOffset: Integer); static; inline;
end;

TDBXSemaphore = class
  private
{$IF DEFINED(CLR)}
    FWaiterCount:     Integer;
{$ELSE}
    FSemaphore:       THandle;
{$IFEND}
    FCount:           Integer;
  public
    constructor Create(Count: Integer);
    destructor  Destroy; override;
    function Acquire(Timeout: Int64): Boolean;
    procedure Release;

end;


implementation
{$IF NOT DEFINED(CLR)}
uses  WideStrUtils;
{$IFEND}

{ TDBXPlatform }
class procedure TDBXPlatform.CopyInt32(const Value: Integer; const Dest: TBytes; const DestOffset: Integer);
begin
    Dest[DestOffset]    := Byte(Value);
    Dest[DestOffset+1]  := Byte(Value shr 8);
    Dest[DestOffset+2]  := Byte(Value shr 16);
    Dest[DestOffset+3]  := Byte(Value shr 24);
end;

class procedure TDBXPlatform.CopyInt64(const Value: Int64; const Dest: TBytes; const DestOffset: Integer);
begin
    Dest[DestOffset]    := Byte(Value);
    Dest[DestOffset+1]  := Byte(Value shr 8);
    Dest[DestOffset+2]  := Byte(Value shr 16);
    Dest[DestOffset+3]  := Byte(Value shr 24);

    Dest[DestOffset+4] := Byte(Value shr 32);
    Dest[DestOffset+5] := Byte(Value shr 40);
    Dest[DestOffset+6] := Byte(Value shr 48);
    Dest[DestOffset+7] := Byte(Value shr 56);

end;

class procedure TDBXPlatform.CopyInt16(const Value: SmallInt;
  const Dest: TBytes; const DestOffset: Integer);
begin
    Dest[DestOffset]    := Byte(Value);
    Dest[DestOffset+1]  := Byte(Value shr 8);
end;

class procedure TDBXPlatform.CopySqlTimeStamp(const Value: TSQLTimeStamp;
  const Dest: TBytes; const DestOffset: Integer);
begin
    TDBXPlatform.CopyInt16(Value.Year, Dest, DestOffset);
    TDBXPlatform.CopyInt16(Value.Month, Dest, DestOffset+2);
    TDBXPlatform.CopyInt16(Value.Day, Dest, DestOffset+4);
    TDBXPlatform.CopyInt16(Value.Hour, Dest, DestOffset+6);
    TDBXPlatform.CopyInt16(Value.Minute, Dest, DestOffset+8);
    TDBXPlatform.CopyInt16(Value.Second, Dest, DestOffset+10);
    TDBXPlatform.CopyInt32(Value.Fractions, Dest, DestOffset+12);
end;

class procedure TDBXPlatform.CopyBcd(const Value: TBcd; const Dest: TBytes;
  const DestOffset: Integer);
begin
{$IF DEFINED(WIN32)}
  Dest[DestOffset] := Value.Precision;
  Dest[DestOffset+1] := Value.SignSpecialPlaces;
  Move(Value.Fraction[0], Dest[DestOffset+2], Length(Value.Fraction));
{$ELSE}
  CopyByteArray(TBcd.ToBytes(Value), 0, Dest, DestOffset, SizeOfTBCD);
{$IFEND}

end;

{$IF DEFINED(WIN32)}
class function TDBXPlatform.CreateWideStringBuilder(
  Length: TInt32): TDBXWideStringBuilder;
begin
  GetMem(Result, Length*2);
end;
class function TDBXPlatform.ToWideString(const Value: TDBXWideStringBuilder): WideString;
begin
  Result := Value;
end;

class function TDBXPlatform.CreateStringBuilder(
  Length: TInt32): TDBXAnsiStringBuilder;
begin
  GetMem(Result, length);
end;
class function TDBXPlatform.ToString(const Value: TDBXAnsiStringBuilder): String;
begin
  Result := Value;
end;
class function TDBXPlatform.GetStringBuilderLength(
  const Value: TDBXAnsiStringBuilder): TInt32;
begin
  Result := Length(Value);
end;

class function TDBXPlatform.GetWideStringBuilderLength(
  const Value: TDBXWideStringBuilder): TInt32;
begin
  Result := Length(Value);
end;
class procedure TDBXPlatform.CopyStringBuilder(const Value: TDBXAnsiStringBuilder; var Dest: String);
begin
  Dest := Value; //Copy(Value, 0, StrLen(TDBXAnsiStringVar(Value)));
end;
class procedure TDBXPlatform.CopyWideStringBuilder(const Value: TDBXWideStringBuilder; var Dest: WideString);
begin
  Dest := WideString(Value);//Copy(Value, 0, WStrLen(TDBXWideStringVar(Value)));
end;
class procedure TDBXPlatform.ResizeStringBuilder(var Value: TDBXAnsiStringBuilder;
  Size: Integer);
begin
  if Value <> nil then
    FreeAndNilStringBuilder(Value);
  GetMem(Value, Size);
end;

class procedure TDBXPlatform.FreeAndNilStringBuilder(
  var Value: TDBXAnsiStringBuilder);
begin
  if Value <> nil then
    FreeMem(Value);
  Value := nil;
end;

class procedure TDBXPlatform.ResizeWideStringBuilder(
  var Value: TDBXWideStringBuilder; Size: Integer);
begin
  if Value <> nil then
    FreeMem(Value);
  GetMem(Value, Size*2);
end;

class procedure TDBXPlatform.FreeAndNilWideStringBuilder(
  var Value: TDBXWideStringBuilder);
begin
  if Value <> nil then
    FreeMem(Value);
  Value := nil;
end;

class procedure TDBXPlatform.CopyWideStringToBuilder(const Source: WideString;
  var Value: TDBXWideStringBuilder);
begin
  move(TDBXWideStringBuilder(Source)^, Value^, (Length(Source)+1)*2);
end;

class procedure TDBXPlatform.CopyInt32Array(const Source: TDBXInt32s;
  SourceOffset: Integer; const Dest: TDBXInt32s; DestOffset, Count: Integer);
begin
  Assert(Length(Dest) >= (Count+DestOffset));
  Move(Source[SourceOffset], Dest[DestOffset], Count*4);
end;

class procedure TDBXPlatform.CopyByteArray(const Source: TBytes;
  SourceOffset: Integer; const Dest: TBytes; DestOffset, Count: Integer);
begin
  Assert(Length(Dest) >= (Count+DestOffset));
  Move(Source[SourceOffset], Dest[DestOffset], Count);
end;
class procedure TDBXPlatform.CopyCharArray(
  const Source: TDBXWideChars; SourceOffset: Integer; const Dest: TDBXWideChars; DestOffset: Integer; Count: Integer);
begin
  Assert(Length(Dest) >= (Count+DestOffset));
  Move(Source[SourceOffset], Dest[DestOffset], Count*2);
end;
class function TDBXPlatform.CreateWideString(const Source: TDBXWideChars;
  Count: Integer): WideString;
begin
//  Result := PWideChar(Source); Only works if string is null terminated.
  SetLength(Result, Count);
  Move(Source[0], Result[1], Count*2);
end;


{$ELSE IF DEFINED(CLR)}
class function TDBXPlatform.CreateWideStringBuilder(
  Length: TInt32): TDBXWideStringBuilder;
begin
  Result := StringBuilder.Create(Length);
end;

class procedure TDBXPlatform.FreeAndNilWideStringBuilder(
  var Value: TDBXWideStringBuilder);
begin
  Value := nil;
end;

class procedure TDBXPlatform.FreeAndNilStringBuilder(
  var Value: TDBXAnsiStringBuilder);
begin
  Value := nil;
end;

class function TDBXPlatform.GetStringBuilderLength(
  const Value: TDBXAnsiStringBuilder): TInt32;
begin
  Result := Value.Length;
end;

class function TDBXPlatform.GetWideStringBuilderLength(
  const Value: TDBXWideStringBuilder): TInt32;
begin
  Result := Value.Length;
end;

class function TDBXPlatform.Int64BitsToDouble(const value: Int64): Double;
begin
  Result := BitConverter.Int64BitsToDouble(value);
end;

class function TDBXPlatform.DoubleToInt64Bits(const value: Double): Int64;
begin
  Result := BitConverter.DoubleToInt64Bits(value);
end;

class function TDBXPlatform.Int32BitsToSingle(const value: TInt32): Single;
var
  Bytes: TBytes;
begin
  Bytes := BitConverter.GetBytes(Value);
  Result := System.BitConverter.ToSingle(Bytes, 0);
end;

class function TDBXPlatform.SingleToInt32Bits(const Value: Single): TInt32;
var
  Bytes: TBytes;
begin
  Bytes := BitConverter.GetBytes(Value);
  Result := BitConverter.ToInt32(Bytes, 0);
end;

class procedure TDBXPlatform.ResizeStringBuilder(var Value: TDBXAnsiStringBuilder;
  Size: Integer);
begin
  Value.EnsureCapacity(Size);
end;

class procedure TDBXPlatform.ResizeWideStringBuilder(
  var Value: TDBXWideStringBuilder; Size: Integer);
begin
  Value.EnsureCapacity(Size);
end;

class function TDBXPlatform.ToWideString(const Value: TDBXWideStringBuilder): WideString;
begin
  Result := Value.ToString;
end;
//class procedure TDBXPlatform.SetWideLength(Value: TDBXWideStringBuilder);
//begin
//  Value.SetLength(Length);
//end;
class function TDBXPlatform.CreateStringBuilder(
  Length: TInt32): TDBXAnsiStringBuilder;
begin
  Result := StringBuilder.Create(Length);
end;
class function TDBXPlatform.ToString(const Value: TDBXAnsiStringBuilder): String;
begin
  Result := Value.ToString;
end;

class procedure TDBXPlatform.CopyStringBuilder(const Value: TDBXAnsiStringBuilder; var Dest: String);
begin
  Dest := Value.ToString;
end;
class procedure TDBXPlatform.CopyWideStringBuilder(const Value: TDBXWideStringBuilder; var Dest: WideString);
begin
  Dest := Value.ToString;
end;

class procedure TDBXPlatform.CopyWideStringToBuilder(const Source: WideString;
  var Value: TDBXWideStringBuilder);
begin
  Value := StringBuilder.Create(Source);
end;

class procedure TDBXPlatform.CopyByteArray(const Source: TBytes;
  SourceOffset: Integer; const Dest: TBytes; DestOffset, Count: Integer);
begin
  System.Array.Copy(Source, SourceOffset, Dest, DestOffset, Count);
end;

class procedure TDBXPlatform.CopyCharArray(
  const Source: TDBXWideChars; SourceOffset: Integer; const Dest: TDBXWideChars; DestOffset: Integer; Count: Integer);
begin
  System.Array.Copy(Source, SourceOffset, Dest, DestOffset, Count);
end;

class procedure TDBXPlatform.CopyInt32Array(const Source: TDBXInt32s;
  SourceOffset: Integer; const Dest: TDBXInt32s; DestOffset, Count: Integer);
begin
  System.Array.Copy(Source, SourceOffset, Dest, DestOffset, Count);
end;

class function TDBXPlatform.CreateWideString(const Source: TDBXWideChars;
  Count: Integer): WideString;
begin
  Result := System.String.Create(Source, 0, Count);
end;


{$IFEND}


{ TDBXSemaphore }

{$IF DEFINED(CLR)}
constructor TDBXSemaphore.Create(Count: Integer);
begin
  inherited Create;
  FCount      := Count;
end;

procedure TDBXSemaphore.Release;
begin
  Monitor.Enter(Self);
  try
    inc(FCount);
    if FWaiterCount > 0 then
      Monitor.Pulse(Self);
  finally
    Monitor.Exit(Self);
  end;
end;

function TDBXSemaphore.Acquire(Timeout: Int64): Boolean;
begin
  Monitor.Enter(Self);
  try
    if FCount < 1 then
    begin
      inc(FWaiterCount);
      try
        Monitor.Wait(Self, Timeout);
      except
        dec(FWaiterCount);
        Result := false;
      end;
      if FCount > 0 then
      begin
        dec(FWaiterCount);
        Result := true;
      end else
      begin
        Result := false;
        Assert(false, 'Unexpected condition TDBXSemaphoreRequest.FCount < 1:  '+IntToStr(FCount));
      end;
    end else
    begin
      dec(FWaiterCount);
      Result := true;
    end;
  finally
    Monitor.Exit(Self);
  end;
end;

destructor TDBXSemaphore.Destroy;
begin

  inherited;
end;


class function TDBXPlatform.StrToBytes(const Value: String): TBytes;
var
  Index: Integer;
  Count: Integer;
begin
  Count := Length(Value);
  SetLength(Result, Count);
  for Index := 0 to Count - 1 do
  begin
    Result[Index] := Byte(Value[Index+1]);
  end;
end;

class function TDBXPlatform.WideStrToBytes(const Value: WideString): TBytes;
var
  CharIndex:  Integer;
  ByteIndex:  Integer;
  Count:  Integer;
  Ch:     WideChar;
begin
  Count := Length(Value);
  SetLength(Result, Count*2);
  ByteIndex := 0;
  CharIndex := 0;
  while CharIndex < Count do
  begin
    inc(CharIndex);
    Ch := Value[CharIndex];
    Result[ByteIndex] := Byte(Ch);
    inc(ByteIndex);
    Result[ByteIndex] := Byte((Integer(Ch) shr 8));
    inc(ByteIndex);
  end;
end;

class function TDBXPlatform.BytesToWideStr(const Value: TBytes): WideString;
var
  Count: Integer;
  Ch:     WideChar;
  ByteIndex: Integer;
  CharIndex: Integer;
  WideChars: TDBXWideChars;
begin
  Count := Length(Value);
  SetLength(WideChars, Count div 2);
  ByteIndex := 0;
  CharIndex := 0;
  while ByteIndex < Count do
  begin
    Ch := WideChar((Integer(Value[ByteIndex+1]) shl 8) + Integer(Value[ByteIndex]));
    WideChars[CharIndex] := Ch;
    inc(CharIndex);
    inc(ByteIndex, 2);
  end;
  Result := WideString(WideChars);
end;

{$ELSE}
constructor TDBXSemaphore.Create(Count: Integer);
begin
  FCount := Count;
  FSemaphore := CreateSemaphore(nil, Count, Count, '');
end;

destructor TDBXSemaphore.Destroy;
begin
  if FSemaphore <> 0 then
    CloseHandle(FSemaphore);
  inherited;
end;

procedure TDBXSemaphore.Release;
begin
  ReleaseSemaphore(FSemaphore, 1, nil);
end;

function TDBXSemaphore.Acquire(Timeout: Int64): Boolean;
var
  WaitResult: Integer;
begin
  WaitResult := WaitForSingleObject(FSemaphore, TimeOut);
  if WaitResult <> WAIT_OBJECT_0 then
    Result := false
  else
    Result := true;
end;
class function TDBXPlatform.Int64BitsToDouble(const Value: Int64): Double;
begin
  Move(Value, Result, 8);
end;
class function TDBXPlatform.DoubleToInt64Bits(const value: Double): Int64;
begin
  Move(Value, Result, 8);
end;
class function TDBXPlatform.Int32BitsToSingle(const value: TInt32): Single;
begin
  Move(Value, Result, 4);
end;

class function TDBXPlatform.SingleToInt32Bits(const Value: Single): TInt32;
begin
  Move(Value, Result, 4);
end;

class function TDBXPlatform.StrToBytes(const Value: String): TBytes;
//begin
//  Result := TBytes(Value);
//end;
var
//  Index: Integer;
  Count: Integer;
begin
  Count := Length(Value);
  SetLength(Result, Count);
  Move(Value[1], Result[0], Count);
//  for Index := 0 to Count - 1 do
//  begin
//    Result[Index] := Byte(Value[Index+1]);
//  end;
end;

class function TDBXPlatform.WideStrToBytes(const Value: WideString): TBytes;
begin
  Result := TBytes(Value);
end;

class function TDBXPlatform.BytesToWideStr(const Value: TBytes): WideString;
begin
  Result := WideString(Value);
end;
{
var
  Count: Integer;
  Ch:     WideChar;
  ByteIndex: Integer;
  CharIndex: Integer;
begin
  Count := Length(Value);
  SetLength(Result, Count div 2);
  ByteIndex := 0;
  CharIndex := 0;
  while ByteIndex < Count do
  begin
    Ch := WideChar((Integer(Value[ByteIndex+1]) shl 8) + Integer(Value[ByteIndex]));
    inc(CharIndex);
    Result[CharIndex] := Ch;
    inc(ByteIndex, 2);
  end;
end;
}
{$IFEND}



class procedure TDBXPlatform.WriteAsciiBytes(const Message: String;
  ByteBuffer: TBytes; Offset, Count: Integer);
var
  Index: Integer;
  curChar: char;
begin
  Write(Message+' offset: '+IntToStr(Offset)+' count: '+IntToStr(Count));
  for Index := offset to Count - 1 do
  begin
    curChar := char(ByteBuffer[Index]);
    if (curChar < ' ') or (curChar > '~') then
    begin
      Write('#');
      Write(IntToStr(Integer(curChar)));
    end else
    begin
      Write(curChar);
    end;
  end;
  Writeln;
end;


end.
