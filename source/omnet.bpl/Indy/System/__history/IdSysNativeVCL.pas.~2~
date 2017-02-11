{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}

unit IdSysNativeVCL;

interface

uses IdSysVCL, SysUtils;

type

  TIdSysNativeVCL = class(TIdSysVCL)
  public
    class function AnsiCompareStr(const S1, S2: AnsiString): Integer; overload;
    class function AnsiUpperCase(const S: AnsiString): AnsiString; overload;
    class function AnsiLowerCase(const S: AnsiString): AnsiString; overload;
    class function AnsiCompareText(const S1, S2: AnsiString): Integer; overload;
    class function AnsiPos(const Substr, S: AnsiString): Integer; overload;

    class function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;
    class function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;
    class function StrPas(const Str: PChar): string;
    class function StrNew(const Str: PChar): PChar;
    class procedure StrDispose(Str: PChar);
    class function CompareMem(P1, P2: Pointer; Length: Integer): Boolean;
    class function ByteType(const S: string; Index: Integer): TMbcsByteType;
    //done because for some reason, mbSingleByte can only be exposed directly from the SysUtils unit,
    //I tried doing it from here without luck
    class function IsSingleByteType(const S: string; Index: Integer): Boolean;
  end;

  TIdDateTimeBase = TDateTime;

implementation

class function TIdSysNativeVCL.CompareMem(P1, P2: Pointer;
  Length: Integer): Boolean;
begin
  Result := SysUtils.CompareMem(P1,P2,Length);
end;
class function TIdSysNativeVCL.AnsiExtractQuotedStr(var Src: PChar;
  Quote: Char): string;
begin
  Result := SysUtils.AnsiExtractQuotedStr(Src,Quote);
end;

class function TIdSysNativeVCL.StrLCopy(Dest: PChar; const Source: PChar;
  MaxLen: Cardinal): PChar;
begin
  Result := SysUtils.StrLCopy(Dest,Source,MaxLen);
end;

class function TIdSysNativeVCL.StrPas(const Str: PChar): string;
begin
  Result := SysUtils.StrPas(Str);
end;

class function TIdSysNativeVCL.StrNew(const Str: PChar): PChar;
begin
  Result := SysUtils.StrNew(Str);
end;

class procedure TIdSysNativeVCL.StrDispose(Str: PChar);
begin
  SysUtils.StrDispose(Str);
end;

class function TIdSysNativeVCL.AnsiCompareStr(const S1,
  S2: AnsiString): Integer;
begin
  Result := SysUtils.AnsiCompareStr(S1,S2);
end;

class function TIdSysNativeVCL.AnsiLowerCase(const S: AnsiString): AnsiString;
begin
  Result := SysUtils.AnsiLowerCase(S);
end;

class function TIdSysNativeVCL.AnsiUpperCase(const S: AnsiString): AnsiString;
begin
  Result := SysUtils.AnsiUpperCase(S);
end;

class function TIdSysNativeVCL.AnsiCompareText(const S1,
  S2: AnsiString): Integer;
begin
  Result := SysUtils.AnsiCompareText(S1,S2);
end;

class function TIdSysNativeVCL.AnsiPos(const Substr, S: AnsiString): Integer;
begin
  Result := SysUtils.AnsiPos(Substr,S);
end;

class function TIdSysNativeVCL.ByteType(const S: string;
  Index: Integer): TMbcsByteType;
begin
  Result := SysUtils.ByteType(S,Index)
end;

class function TIdSysNativeVCL.IsSingleByteType(const S: string;
  Index: Integer): Boolean;
begin
  Result  := ByteType(S,Index)=mbSingleByte;
end;

end.
