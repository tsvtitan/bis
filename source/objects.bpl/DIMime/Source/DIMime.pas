{ The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DIMime.pas.

  The Initial Developer of the Original Code is Ralf Junker <delphi@yunqa.de>.

  All Rights Reserved.

------------------------------------------------------------------------------ }

unit DIMime;

interface

{$I DI.inc}

function MimeEncodeString(const s: AnsiString): AnsiString;

function MimeEncodeStringNoCRLF(const s: AnsiString): AnsiString;

function MimeDecodeString(const s: AnsiString): AnsiString;

function MimeEncodedSize(const InputSize: Cardinal): Cardinal;

function MimeEncodedSizeNoCRLF(const InputSize: Cardinal): Cardinal;

function MimeDecodedSize(const InputSize: Cardinal): Cardinal;

procedure DecodeHttpBasicAuthentication(const BasicCredentials: AnsiString; out UserId, Password: AnsiString);

procedure MimeEncode(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);

procedure MimeEncodeNoCRLF(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);

procedure MimeEncodeFullLines(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);

function MimeDecode(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer): Cardinal;

function MimeDecodePartial(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;

function MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer: Cardinal; const ByteBufferSpace: Cardinal): Cardinal;

const

  MIME_ENCODED_LINE_BREAK = 76;

  MIME_DECODED_LINE_BREAK = MIME_ENCODED_LINE_BREAK div 4 * 3;

implementation

const

  MIME_ENCODE_TABLE: array[0..63] of Byte = (
    065, 066, 067, 068, 069, 070, 071, 072,
    073, 074, 075, 076, 077, 078, 079, 080,
    081, 082, 083, 084, 085, 086, 087, 088,
    089, 090, 097, 098, 099, 100, 101, 102,
    103, 104, 105, 106, 107, 108, 109, 110,
    111, 112, 113, 114, 115, 116, 117, 118,
    119, 120, 121, 122, 048, 049, 050, 051,
    052, 053, 054, 055, 056, 057, 043, 047);

  MIME_PAD_CHAR = Byte('=');

  MIME_DECODE_TABLE: array[Byte] of Cardinal = (
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 062, 255, 255, 255, 063,
    052, 053, 054, 055, 056, 057, 058, 059,
    060, 061, 255, 255, 255, 255, 255, 255,
    255, 000, 001, 002, 003, 004, 005, 006,
    007, 008, 009, 010, 011, 012, 013, 014,
    015, 016, 017, 018, 019, 020, 021, 022,
    023, 024, 025, 255, 255, 255, 255, 255,
    255, 026, 027, 028, 029, 030, 031, 032,
    033, 034, 035, 036, 037, 038, 039, 040,
    041, 042, 043, 044, 045, 046, 047, 048,
    049, 050, 051, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255);

type
  PByte4 = ^TByte4;
  TByte4 = packed record
    b1, b2, b3, b4: Byte;
  end;

  PByte3 = ^TByte3;
  TByte3 = packed record
    b1, b2, b3: Byte;
  end;

  PCardinal = ^Cardinal;

function MimeEncodeString(const s: AnsiString): AnsiString;
var
  l: Cardinal;
begin
  if Pointer(s) <> nil then
    begin
      l := PCardinal(Cardinal(s) - 4)^;
      SetString(Result, nil, MimeEncodedSize(l));
      MimeEncode(Pointer(s)^, l, Pointer(Result)^);
    end
  else
    Result := '';
end;

function MimeEncodeStringNoCRLF(const s: AnsiString): AnsiString;
var
  l: Cardinal;
begin
  if Pointer(s) <> nil then
    begin
      l := PCardinal(Cardinal(s) - 4)^;
      SetString(Result, nil, MimeEncodedSizeNoCRLF(l));
      MimeEncodeNoCRLF(Pointer(s)^, l, Pointer(Result)^);
    end
  else
    Result := '';
end;

function MimeDecodeString(const s: AnsiString): AnsiString;
var
  ByteBuffer, ByteBufferSpace: Cardinal;
  l: Cardinal;
begin
  if Pointer(s) <> nil then
    begin
      l := PCardinal(Cardinal(s) - 4)^;
      SetString(Result, nil, MimeDecodedSize(l));
      ByteBuffer := 0;
      ByteBufferSpace := 4;
      l := MimeDecodePartial(Pointer(s)^, l, Pointer(Result)^, ByteBuffer, ByteBufferSpace);
      Inc(l, MimeDecodePartialEnd(Pointer(Cardinal(Result) + l)^, ByteBuffer, ByteBufferSpace));
      SetLength(Result, l);
    end
  else
    Result := '';
end;

procedure DecodeHttpBasicAuthentication(const BasicCredentials: AnsiString; out UserId, Password: AnsiString);
label
  Fail;
const
  LBasic = 6;
var
  DecodedPtr, p: PAnsiChar;
  i, l: Cardinal;
begin
  p := Pointer(BasicCredentials);
  if p = nil then goto Fail;

  l := Cardinal(Pointer(p - 4)^);
  if l <= LBasic then goto Fail;

  Dec(l, LBasic);
  Inc(p, LBasic);

  GetMem(DecodedPtr, MimeDecodedSize(l));
  l := MimeDecode(p^, l, DecodedPtr^);

  i := 0;
  p := DecodedPtr;
  while (l > 0) and (p[i] <> ':') do
    begin
      Inc(i);
      Dec(l);
    end;

  SetString(UserId, DecodedPtr, i);
  if l > 1 then
    SetString(Password, DecodedPtr + i + 1, l - 1)
  else
    Password := '';

  FreeMem(DecodedPtr);
  Exit;

  Fail:
  UserId := '';
  Password := '';
end;

function MimeEncodedSize(const InputSize: Cardinal): Cardinal;
begin
  if InputSize > 0 then
    Result := (InputSize + 2) div 3 * 4 + (InputSize - 1) div MIME_DECODED_LINE_BREAK * 2
  else
    Result := InputSize;
end;

function MimeEncodedSizeNoCRLF(const InputSize: Cardinal): Cardinal;
begin
  Result := (InputSize + 2) div 3 * 4;
end;

function MimeDecodedSize(const InputSize: Cardinal): Cardinal;
begin
  Result := (InputSize + 3) div 4 * 3;
end;

procedure MimeEncode(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
var
  iDelta, ODelta: Cardinal;
begin
  MimeEncodeFullLines(InputBuffer, InputByteCount, OutputBuffer);
  iDelta := InputByteCount div MIME_DECODED_LINE_BREAK;
  ODelta := iDelta * (MIME_ENCODED_LINE_BREAK + 2);
  iDelta := iDelta * MIME_DECODED_LINE_BREAK;
  MimeEncodeNoCRLF(Pointer(Cardinal(@InputBuffer) + iDelta)^, InputByteCount - iDelta, Pointer(Cardinal(@OutputBuffer) + ODelta)^);
end;

procedure MimeEncodeFullLines(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
var
  b, InnerLimit, OuterLimit: Cardinal;
  InPtr: PByte3;
  OutPtr: PByte4;
begin

  if InputByteCount < MIME_DECODED_LINE_BREAK then Exit;

  InPtr := @InputBuffer;
  OutPtr := @OutputBuffer;

  InnerLimit := Cardinal(InPtr);
  Inc(InnerLimit, MIME_DECODED_LINE_BREAK);

  OuterLimit := Cardinal(InPtr);
  Inc(OuterLimit, InputByteCount);

  repeat

    repeat

      b := InPtr^.b1;
      b := b shl 8;
      b := b or InPtr^.b2;
      b := b shl 8;
      b := b or InPtr^.b3;
      Inc(InPtr);

      OutPtr^.b4 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b3 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b2 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b1 := MIME_ENCODE_TABLE[b];
      Inc(OutPtr);
    until Cardinal(InPtr) >= InnerLimit;

    OutPtr^.b1 := 13;
    OutPtr^.b2 := 10;
    Inc(Cardinal(OutPtr), 2);

    Inc(InnerLimit, MIME_DECODED_LINE_BREAK);
  until InnerLimit > OuterLimit;
end;

procedure MimeEncodeNoCRLF(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
var
  b, InnerLimit, OuterLimit: Cardinal;
  InPtr: PByte3;
  OutPtr: PByte4;
begin
  if InputByteCount = 0 then Exit;

  InPtr := @InputBuffer;
  OutPtr := @OutputBuffer;

  OuterLimit := InputByteCount div 3 * 3;

  InnerLimit := Cardinal(InPtr);
  Inc(InnerLimit, OuterLimit);

  while Cardinal(InPtr) < InnerLimit do
    begin

      b := InPtr^.b1;
      b := b shl 8;
      b := b or InPtr^.b2;
      b := b shl 8;
      b := b or InPtr^.b3;
      Inc(InPtr);

      OutPtr^.b4 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b3 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b2 := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr^.b1 := MIME_ENCODE_TABLE[b];
      Inc(OutPtr);
    end;

  case InputByteCount - OuterLimit of
    1:
      begin
        b := InPtr^.b1;
        b := b shl 4;
        OutPtr.b2 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr.b1 := MIME_ENCODE_TABLE[b];
        OutPtr.b3 := MIME_PAD_CHAR;
        OutPtr.b4 := MIME_PAD_CHAR;
      end;
    2:
      begin
        b := InPtr^.b1;
        b := b shl 8;
        b := b or InPtr^.b2;
        b := b shl 2;
        OutPtr.b3 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr.b2 := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr.b1 := MIME_ENCODE_TABLE[b];
        OutPtr.b4 := MIME_PAD_CHAR;
      end;
  end;
end;

function MimeDecode(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer): Cardinal;
var
  ByteBuffer, ByteBufferSpace: Cardinal;
begin
  ByteBuffer := 0;
  ByteBufferSpace := 4;
  Result := MimeDecodePartial(InputBuffer, InputBytesCount, OutputBuffer, ByteBuffer, ByteBufferSpace);
  Inc(Result, MimeDecodePartialEnd(Pointer(Cardinal(@OutputBuffer) + Result)^, ByteBuffer, ByteBufferSpace));
end;

function MimeDecodePartial(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;
var
  lByteBuffer, lByteBufferSpace, c: Cardinal;
  InPtr, OuterLimit: ^Byte;
  OutPtr: PByte3;
begin
  if InputBytesCount > 0 then
    begin
      InPtr := @InputBuffer;
      Cardinal(OuterLimit) := Cardinal(InPtr) + InputBytesCount;
      OutPtr := @OutputBuffer;
      lByteBuffer := ByteBuffer;
      lByteBufferSpace := ByteBufferSpace;
      while InPtr <> OuterLimit do
        begin

          c := MIME_DECODE_TABLE[InPtr^];
          Inc(InPtr);
          if c = $FF then Continue;
          lByteBuffer := lByteBuffer shl 6;
          lByteBuffer := lByteBuffer or c;
          Dec(lByteBufferSpace);

          if lByteBufferSpace <> 0 then Continue;

          OutPtr^.b3 := Byte(lByteBuffer);
          lByteBuffer := lByteBuffer shr 8;
          OutPtr^.b2 := Byte(lByteBuffer);
          lByteBuffer := lByteBuffer shr 8;
          OutPtr^.b1 := Byte(lByteBuffer);
          lByteBuffer := 0;
          Inc(OutPtr);
          lByteBufferSpace := 4;
        end;
      ByteBuffer := lByteBuffer;
      ByteBufferSpace := lByteBufferSpace;
      Result := Cardinal(OutPtr) - Cardinal(@OutputBuffer);
    end
  else
    Result := 0;
end;

function MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer: Cardinal; const ByteBufferSpace: Cardinal): Cardinal;
var
  lByteBuffer: Cardinal;
begin
  case ByteBufferSpace of
    1:
      begin
        lByteBuffer := ByteBuffer shr 2;
        PByte3(@OutputBuffer)^.b2 := Byte(lByteBuffer);
        lByteBuffer := lByteBuffer shr 8;
        PByte3(@OutputBuffer)^.b1 := Byte(lByteBuffer);
        Result := 2;
      end;
    2:
      begin
        lByteBuffer := ByteBuffer shr 4;
        PByte3(@OutputBuffer)^.b1 := Byte(lByteBuffer);
        Result := 1;
      end;
  else
    Result := 0;
  end;
end;

end.

