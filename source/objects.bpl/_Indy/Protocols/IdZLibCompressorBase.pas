{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  21840: IdZLibCompressorBase.pas
{
{   Rev 1.19    9/16/2004 3:24:08 AM  JPMugaas
{ TIdFTP now compresses to the IOHandler and decompresses from the IOHandler.
{ 
{ Noted some that the ZLib code is based was taken from ZLibEx.
}
{
{   Rev 1.18    9/12/2004 7:49:06 PM  JPMugaas
{ Removed an abstract method that was removed from the descendant to prevent a
{ warning.  It was part of an idea i had that hasn't yet developed due to
{ another obsticle.
}
{
{   Rev 1.17    9/11/2004 10:58:10 AM  JPMugaas
{ FTP now decompresses output directly to the IOHandler.
}
{
    Rev 1.16    7/18/2004 3:01:44 PM  DSiders
  Added localization comments.
}
{
{   Rev 1.15    6/15/2004 6:33:50 PM  JPMugaas
{ Bug fix for RaidenFTPD and ShareIt FTP Server.  Since we now specifically
{ look for the ZLIB headers, we pass the Window Bits value as negative
{ DecompressFTPDeflate.  I have verified this on RaidenFTPD and ShareIt.
{
{ Note that there is an inconsistancy in the FTP Deflate drafts
{
{ http://community.roxen.com/developers/idocs/drafts/draft-preston-ftpext-deflat
{ e-02.html
{
{ and
{
{ http://community.roxen.com/developers/idocs/drafts/draft-preston-ftpext-deflat
{ e-00.html
}
{
{   Rev 1.14    6/14/2004 6:14:42 PM  JPMugaas
{ A fix from Bas.  RaidenFTPD 1455 (http://www.raidenftpd.com) was sending the
{
{  2 byte header, the compression methods flags
{
{ while ShareIt (www.noisette-software.com/products/windows/ShareIt/) was not
{ doing so.
}
{
{   Rev 1.13    2004.05.20 11:37:22 AM  czhower
{ IdStreamVCL
}
{
{   Rev 1.12    2/15/2004 6:56:44 AM  JPMugaas
{ GZip decompression should now work again.
}
{
{   Rev 1.11    2/15/2004 6:22:26 AM  JPMugaas
{ Fixed some parameter errors.
}
{
{   Rev 1.10    2/14/2004 9:59:48 PM  JPMugaas
{ Reworked the API.  There is now a separate API for the Inflate_ and
{ InflateInit2_ functions as well as separate functions for DeflateInit_ and
{ DeflateInit2_.  This was required for FTP.  The API also includes an optional
{ output stream for the servers.
}
{
{   Rev 1.9    2/12/2004 11:35:00 PM  JPMugaas
{ FTP Deflate preliminary support.  Work still needs to be done for upload and
{ downloading.
}
{
{   Rev 1.8    2/12/2004 11:11:24 AM  JPMugaas
{ Added methods for HTTP Compression and decompression using RFC 1950.  I have
{ verified these.
}
{
{   Rev 1.7    2004.02.03 5:45:48 PM  czhower
{ Name changes
}
{
{   Rev 1.6    10/25/2003 06:52:26 AM  JPMugaas
{ Updated for new API changes and tried to restore some functionality.
}
{
{   Rev 1.5    10/24/2003 05:04:54 PM  JPMugaas
{ SHould work as before.
}
{
{   Rev 1.4    2003.10.24 10:43:14 AM  czhower
{ TIdSTream to dos
}
{
{   Rev 1.3    10/7/2003 10:07:08 PM  GGrieve
{ Get HTTP compiling for DotNet
}
{
    Rev 1.2    7/13/2003 10:57:30 PM  BGooijen
  Fixed GZip and Deflate decoding
}
{
{   Rev 1.1    7/13/2003 11:30:56 AM  JPMugaas
{ Stub methods for Deflate and inflate methods if needed.
}
{
{   Rev 1.0    7/13/2003 11:08:38 AM  JPMugaas
{ classes for ZLib compression.
}
unit IdZLibCompressorBase;

interface
uses Classes, IdBaseComponent, IdIOHandler;

type
  TIdCompressionLevel = 0..9;
  TIdZLibCompressorBase = class(TIdBaseComponent)
  public
  //these call the standard InflateInit and DeflateInit
    procedure DeflateStream(AStream : TStream; const ALevel : TIdCompressionLevel=0; const AOutStream : TStream=nil); virtual; abstract;
    procedure InflateStream(AStream : TStream; const AOutStream : TStream=nil); virtual; abstract;

    //VAdler32 is for the benefit of people needing the Adler32 for uncompressed data
    //these call the standard InflateInit2 and DeflateInit2
    procedure CompressStream(AStream : TStream; const ALevel : TIdCompressionLevel; const AWindowBits, AMemLevel,
      AStrategy: Integer; AOutStream : TStream); virtual; abstract;

    procedure DecompressStream(AStream : TStream; const AWindowBits : Integer; const AOutStream : TStream=nil); virtual; abstract;

    procedure DecompressDeflateStream(AStream : TStream; const AOutStream : TStream=nil); virtual;

    //RFC 1950 complient input and output
    procedure CompressFTPDeflate(AStream : TStream; const ALevel, AWindowBits, AMemLevel,
      AStrategy: Integer; const AOutStream : TStream=nil);
    procedure CompressFTPToIO(AStream : TStream; AIOHandler : TIdIOHandler; const ALevel, AWindowBits, AMemLevel,
      AStrategy: Integer); virtual; abstract;
    procedure DecompressFTPFromIO(AIOHandler : TIdIOHandler; const AWindowBits : Integer; AOutputStream : TStream); virtual; abstract;
    procedure DecompressFTPDeflate(AStream : TStream; const AWindowBits : Integer; const AOutStream : TStream=nil);
    procedure CompressHTTPDeflate(AStream : TStream; const ALevel : TIdCompressionLevel; const AOutStream : TStream=nil);
    procedure DecompressHTTPDeflate(AStream : TStream; const AOutStream : TStream=nil);
    //RFC 1952 complient input and output
    procedure DecompressGZipStream(AStream : TStream; const AOutStream : TStream=nil); virtual;

  end;

implementation

uses
  IdException,
  IdGlobal,
  IdStreamVCL, SysUtils;

procedure TIdZLibCompressorBase.DecompressGZipStream(AStream : TStream; const AOutStream : TStream=nil);

  procedure GotoDataStart;
  var LFlags:byte;
      LExtra:word;
      LNullFindChar:char;
  begin
    AStream.Seek(3,soFromCurrent);
    AStream.Read(LFlags,1);
    AStream.Seek(6,soFromCurrent);
    // at pos 10 now

    if LFlags and $4 = $4 then begin // FEXTRA
      AStream.Read(LExtra, 2);
      AStream.Seek(LExtra, soFromCurrent);
    end;

    if LFlags and $8 = $8 then begin // FNAME
      repeat
        AStream.Read(LNullFindChar, 1);
      until LNullFindChar=#0;
    end;

    if LFlags and $10 = $10 then begin // FCOMMENT
      repeat
        AStream.Read(LNullFindChar, 1);
      until LNullFindChar=#0;
    end;

    if LFlags and $2 = $2 then begin // FHCRC
      AStream.Seek(2, soFromCurrent); // CRC16
    end;
  end;

var
  LBytes : TIdBytes;
  LStr : TIdStreamVCL;
begin
  GotoDataStart;
  AStream.Seek(-2, soFromCurrent);
  SetLength(LBytes, 2);
  LBytes[0] := $78; //7=32K blocks, 8=deflate
  LBytes[1] := $9C;
  LStr := TIdStreamVCL.Create(AStream);
  try
    LStr.Write(LBytes, 2);
  finally
    FreeAndNil(LStr);
  end;
  AStream.Seek(-2, soFromCurrent);
  AStream.size := AStream.size - 8; // remove the CRC32 and the size
  InflateStream(AStream,AOutStream);
end;

procedure TIdZLibCompressorBase.DecompressDeflateStream(AStream : TStream; const AOutStream : TStream=nil);
begin
  AStream.Seek(10, soFromCurrent); // skip junk at front
//  AStream.size := AStream.size-4;  // remove the adler32 hash
  InflateStream(AStream,AOutStream);
end;

{procedure TIdZLibCompressorBase.DecompressFTPDeflate(AStream : TStream; const AWindowBits : Integer; const AOutStream : TStream=nil);
var
  LBCmp : Byte;
  LFlags : Byte;
  LWinBits : Integer;
begin
  AStream.Read(LBCmp,1);
  AStream.Read(LFlags,1);    }
  {
  This is a workaround for some clients and servers that do not send decompression
  headers.  The reason is that there's an inconsistancy in Internet Drafts for ZLIB
  compression.  One says to include the headers while an older one says do not
  include the headers.
  }
{  LWinBits := AWindowBits;
  if LWinBits > 0 then
  begin
    LWinBits := 0 - LWinBits;
  end;
  if ((LBCmp * 256)+LFlags ) mod 31 = 0 then begin
    if (LFlags and 32)>0 then begin
      AStream.Position:=AStream.Position+4;
    end;
    AStream.Size:=AStream.Size-4;
  end else begin
    AStream.Position:=AStream.Position-2; // there was no header, seek back
  end;
  DecompressStream(AStream,LWinBits,AOutStream);
end;       }

procedure TIdZLibCompressorBase.DecompressFTPDeflate(AStream : TStream; const AWindowBits : Integer; const AOutStream : TStream=nil);
var
  LWinBits : Integer;
begin
  {
  This is a workaround for some clients and servers that do not send decompression
  headers.  The reason is that there's an inconsistancy in Internet Drafts for ZLIB
  compression.  One says to include the headers while an older one says do not
  include the headers.
  }
  LWinBits := AWindowBits;
  if LWinBits > 0 then
  begin
    LWinBits := Abs( LWinBits) + 32;
  end;

  DecompressStream(AStream,LWinBits,AOutStream);
end;

procedure TIdZLibCompressorBase.CompressFTPDeflate(AStream : TStream;
  const ALevel, AWindowBits, AMemLevel,
      AStrategy: Integer;const AOutStream : TStream=nil);
begin
  CompressStream(AStream,ALevel, AWindowBits, AMemLevel,
      AStrategy,AOutStream);

end;

procedure TIdZLibCompressorBase.CompressHTTPDeflate(AStream : TStream; const ALevel : TIdCompressionLevel; const AOutStream : TStream=nil);
begin
  DeflateStream(AStream,ALevel,AOutStream);
end;

procedure TIdZLibCompressorBase.DecompressHTTPDeflate(AStream: TStream;const AOutStream : TStream=nil);
var
  LBCmp : Byte;
  LFlags : Byte;
  LDict : Cardinal;
  LOrgPos : Int64;

begin
  LOrgPos := AStream.Position;
  AStream.Read(LBCmp,1);
  AStream.Read(LFlags,1);
  EIdException.IfFalse(((LBCmp * 256)+LFlags ) mod 31 = 0,'Error - invalid header'); {do not localize}
  AStream.Read(LDict,4);
  AStream.Position := LOrgPos;
  InflateStream(AStream,AOutStream);
  AStream.Position := LOrgPos;
end;

end.
