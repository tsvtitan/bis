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

unit IdSysNet;

interface

uses
  System.Globalization,
  System.Text, //here so we can refer to StringBuilder class
  IdSysBase;

type

  //I know EAbort violates our rule about basing exceptions on EIdException.
  //I'm doing this for one reason, to be compatible with SysUtils where a reference
  //is made to the EAbort exception.
  EAbort = class(Exception);
  EConvertError = class(Exception);
  TSysCharSet = set of AnsiChar;

  //I'm doing it this way because you can't inherit directly from StringBuilder
  //because of MS defined it.
  //This is necessary because the StringBuilder does NOT have an IndexOF method and
  //StringBuilder is being used for speed to prevent immutability problems with the String class
  //in DotNET
  TIdStringBuilder = System.Text.StringBuilder;

  TIdStringBuilderHelper =  class helper for System.Text.StringBuilder
  public
   function IndexOf(const value : String; const startIndex, count : Integer) : Integer; overload;
   function IndexOf(const value : String; const startIndex : Integer) : Integer; overload;
   function IndexOf(const value : String) : Integer; overload;
   function LastIndexOf(const value : String; const startIndex, count : Integer) : Integer; overload;
   function LastIndexOf(const value : String; const startIndex : Integer) : Integer; overload;
   function LastIndexOf(const value : String) : Integer; overload;

   function ReplaceOnlyFirst(const oldValue, newValue : String): StringBuilder; overload;
   function ReplaceOnlyFirst(const oldValue, newValue : String; const startIndex, count : Integer ): StringBuilder; overload;

   function ReplaceOnlyLast(const oldValue, newValue : String): StringBuilder; overload;
   function ReplaceOnlyLast(const oldValue, newValue : String; const startIndex, count : Integer ): StringBuilder; overload;

  end;

  TIdDateTimeBase = &Double;

  TIdSysNet = class(TIdSysBase)
  private
  protected
    class function AddStringToFormat(SB: StringBuilder; I: Integer; S: String): Integer; static;
    class procedure FmtStr(var Result: string; const Format: string;
      const Args: array of const); static;
  public
    class function FormatBuf(var Buffer: System.Text.StringBuilder; const Format: string;
      FmtLen: Cardinal; const Args: array of const; Provider: IFormatProvider): Cardinal; overload; static;
    class function FormatBuf(var Buffer: System.Text.StringBuilder; const Format: string;
      FmtLen: Cardinal; const Args: array of const): Cardinal;  overload; static;
    class function AnsiCompareText(const S1, S2: WideString): Integer; static;
    class function LastChars(const AStr : String; const ALen : Integer): String; static;
    class function AddMSecToTime(const ADateTime : TIdDateTimeBase; const AMSec : Integer): TIdDateTimeBase; static;
    class function StrToInt64(const S: string): Int64; overload; static;
    class function StrToInt64(const S: string; const Default : Int64): Int64; overload; static;
    class function TwoDigitYearCenturyWindow : Word; static;
    class function FloatToIntStr(const AFloat : Extended) : String; static;
    class function AlignLeftCol(const AStr : String; const AWidth : Integer=0) : String; static;
    class procedure DecodeTime(const ADateTime: TIdDateTimeBase; var Hour, Min, Sec, MSec: Word); static;
    class procedure DecodeDate(const ADateTime: TIdDateTimeBase; var Year, Month, Day: Word); static;
    class function EncodeTime(Hour, Min, Sec, MSec: Word): TIdDateTimeBase; static;
    class function EncodeDate(Year, Month, Day: Word): TIdDateTimeBase; static;
    class function DateTimeToStr(const ADateTime: TIdDateTimeBase): string; static;
    class function StrToDateTime(const S : String): TIdDateTimeBase; static;
    class function Now : TIdDateTimeBase; static;
    class function DayOfWeek(const ADateTime: TIdDateTimeBase): Word; static;
    class function FormatDateTime(const Format: string; ADateTime: TIdDateTimeBase): string; static;
    class function Format(const Format: string; const Args: array of const): string; static;
    class function SameText(const S1, S2 : String) : Boolean; static;
    class function CompareStr(const S1, S2: string): Integer; static;
    class function CompareDate(const D1, D2 : TIdDateTimeBase) : Integer; static;
    class procedure FreeAndNil(var Obj);  static;
        class function IntToStr(Value: Integer): string; overload; static;
    class function IntToHex(Value: Integer; Digits: Integer): string; overload; static;
    class function IntToHex(Value: Int64; Digits: Integer): string; overload; static;
    class function DateTimeToInternetStr(const Value: TIdDateTimeBase; const AIsGMT : Boolean = False) : String;
    class function DateTimeGMTToHttpStr(const GMTValue: TIdDateTimeBase) : String;
    class function DateTimeToGmtOffSetStr(ADateTime: TIdDateTimeBase; SubGMT: Boolean): string;
    class function OffsetFromUTC: TIdDateTimeBase; 
    class function IntToStr(Value: Int64): string; overload; static;
    class function UpperCase(const S: string): string;  static;
    class function LowerCase(const S: string): string;  static;
    class function IncludeTrailingPathDelimiter(const S: string): string; static;
    class function ExcludeTrailingPathDelimiter(const S: string): string; static;
    class function StrToInt(const S: string): Integer; overload; static;
    class function StrToInt(const S: string; Default: Integer): Integer; overload; static;
    class function Trim(const S: string): string; static;
    class function TrimLeft(const S: string): string; static;
    class function TrimRight(const S: string): string; static;
    class procedure Abort; static;
    class function FileAge(const FileName: string): TIdDateTimeBase; static;
    class function FileExists(const FileName: string): Boolean; static;
    class function DirectoryExists(const Directory: string): Boolean; static;
    class function DeleteFile(const FileName: string): Boolean; static;
    class function ExtractFileName(const FileName: string): string; static;
    class function ExtractFilePath(const AFileName: string) : string; static;
    class function ExtractFileExt(const FileName: string): string; static;
    class function ChangeFileExt(const FileName, Extension: string): string; static;
    class function LastDelimiter(const Delimiters, S: string): Integer; static;
    class function StrToInt64Def(const S: string; const Default: Int64): Int64;  static;
    class function StringReplace(const S, OldPattern, NewPattern: string): string; overload; static;
    class function StringReplace(const S : String; const OldPattern, NewPattern: array of string): string; overload; static;
    class function ConvertFormat(const AFormat : String;
           const ADate : TIdDateTimeBase;
           DTInfo : System.Globalization.DateTimeFormatInfo): String; static;
    class function ReplaceOnlyFirst(const S, OldPattern, NewPattern: string): string; overload; static;
    class function AnsiCompareStr(const S1, S2: WideString): Integer; overload; deprecated;
    class function AnsiUpperCase(const S: WideString): WideString; overload; deprecated;
    class function IsLeapYear(Year: Word): Boolean;
    class function AnsiLowerCase(const S: WideString): WideString; overload; deprecated;
    class function AnsiPos(const Substr, S: WideString): Integer; overload;  deprecated;
  end;

const PATH_DELIN = '\';

implementation

uses
  System.IO;

{ SysUtils }

class procedure TIdSysNet.Abort;
begin
  raise EAbort.Create;
end;

class function TIdSysNet.IsLeapYear(Year: Word): Boolean;
begin
  Result := DateTime.IsLeapYear(Year)
end;


class function TIdSysNet.CompareStr(const S1, S2: string): Integer;
begin
  Result := System.&String.Compare(S1,S2,False);
end;

class function TIdSysNet.DateTimeToStr(const ADateTime: TIdDateTimeBase): string;
begin
  Result := ADateTime.ToString;
end;

class function TIdSysNet.FileExists(const FileName: string): Boolean;
begin
  Result := System.IO.File.Exists(FileName);
end;

class function TIdSysNet.Format(const Format: string;  const Args: array of const): string;
begin
  FmtStr(Result, Format, Args);
end;

class procedure TIdSysNet.FreeAndNil(var Obj);
begin
  TObject(Obj).Free;
  Obj := nil;
end;

class function TIdSysNet.IncludeTrailingPathDelimiter( const S: string): string;
begin
  Result := S;
  if (S = '') or (S[Length(S)] <> PATH_DELIN) then
  begin
    Result := S + PATH_DELIN;
  end;
end;

class function TIdSysNet.ExcludeTrailingPathDelimiter(const S: string): string;
begin
  Result := S;
  if (S <> '') and (S[Length(S)] = PATH_DELIN) then
  begin
    Result := Copy(S, 1, Length(S) - 1);
  end;
end;

class function TIdSysNet.IntToHex(Value: Int64; Digits: Integer): string;
begin
  Result := System.&String.Format('{0:x' + Digits.ToString + '}', TObject(Value) );
  //Borland's standard string is one based, not zero based
  Result := Copy(Result,Length(Result)-Digits+1,Digits);
end;

class function TIdSysNet.IntToHex(Value, Digits: Integer): string;
begin
  Result := System.&String.Format('{0:x' + Digits.ToString + '}', TObject(Value));
  //Borland's standard string is one based, not zero based
  Result := Copy(Result,Length(Result)-Digits+1,Digits);
end;

class function TIdSysNet.IntToStr(Value: Int64): string;
begin
  Result := System.Convert.ToString(Value);
end;

class function TIdSysNet.IntToStr(Value: Integer): string;
begin
  Result := System.Convert.ToString(Value);
end;

class function TIdSysNet.LastDelimiter(const Delimiters,
  S: string): Integer;
begin
  Result := 0;
  if Assigned(S) and Assigned(Delimiters) then
  begin
    Result := s.LastIndexOfAny(Delimiters.ToCharArray) + 1;
  end;
end;

class function TIdSysNet.Now: TIdDateTimeBase;
begin
  Result := System.DateTime.Now.ToOADate;
end;

class function TIdSysNet.StringReplace(const S, OldPattern,
  NewPattern: string): string;
begin
  if Assigned(S) then
  begin
    Result := S.Replace(OldPattern, NewPattern)
  end
  else
  begin
    Result := S;
  end;
end;

class function TIdSysNet.ReplaceOnlyFirst(const S, OldPattern,
  NewPattern: string): string;
var
  LS : StringBuilder;
  i : Integer;
  i2 : Integer;
begin
  Result := S;
  if Assigned(S) then
  begin
    i := S.IndexOf(OldPattern);
    if i >= 0 then
    begin
      i2 := OldPattern.Length;
      LS := StringBuilder.Create;
      LS.Append(S,0,i);
      LS.Append(NewPattern);
      LS.Append(S,i+i2,S.Length-(i2+i));
      Result := LS.ToString;
    end;
  end;
end;

class function TIdSysNet.StringReplace(const S: String; const OldPattern,
  NewPattern: array of string): string;
var LS : StringBuilder;
  i : Integer;
begin
  LS := StringBuilder.Create(S);
  for i := Low(OldPattern) to High(OldPattern) do
  begin
    LS.Replace(OldPattern[i],NewPattern[i]);
  end;
  Result := LS.ToString;
end;

class function TIdSysNet.StrToInt64Def(const S: string;
  const Default: Int64): Int64;
var LErr : Integer;
begin
  Val(Trim(S),Result,LErr);
  if LErr<>0 then
  begin
    Result := Default;
  end;
end;

class function TIdSysNet.StrToInt(const S: string): Integer;
var
  LErr: Integer;
begin
  Val(Trim(S),Result,LErr);
  if LErr <> 0 then
  begin
    raise EConvertError.Create('');
  end;
end;

class function TIdSysNet.StrToInt(const S: string;
  Default: Integer): Integer;
var LErr : Integer;
begin
  Val(Trim(S),Result,LErr);
  if LErr<>0 then
  begin
    Result := Default;
  end;
end;

class function TIdSysNet.Trim(const S: string): string;
begin
  Result := S;
  if Assigned(S) then
  begin
    Result := S.Trim;
  end;
end;

class function TIdSysNet.UpperCase(const S: string): string;
begin
  Result := S;
  if Assigned(S) then
  begin
    Result := S.ToUpper
  end;
end;

class function TIdSysNet.LowerCase(const S: string): string;
begin
  Result := S;
  if Assigned(S) then
  begin
    Result := S.ToLower;
  end;
end;

class procedure TIdSysNet.DecodeDate(const ADateTime: TIdDateTimeBase; var Year,
  Month, Day: Word);
var
  TempDate: DateTime;
begin
  TempDate := DateTime.FromOADate(ADateTime);
  Year := TempDate.Year;
  Month := TempDate.Month;
  Day := TempDate.Day;
end;

class procedure TIdSysNet.DecodeTime(const ADateTime: TIdDateTimeBase; var Hour,
  Min, Sec, MSec: Word);
var
  TempDate: DateTime;
begin
  TempDate := DateTime.FromOADate(ADateTime);
  Hour := TempDate.Hour;
  Min := TempDate.Minute;
  Sec := TempDate.Second;
  MSec := TempDate.Millisecond;
end;

class function TIdSysNet.TrimLeft(const S: string): string;
var
  Len: Integer;
  LDelTo: Integer;
begin
  Result := S;
  if Assigned(S) then
  begin
    Len := S.Length;
    LDelTo := 0;
    while (LDelTo < Len) and (S.Chars[LDelTo] <= ' ') do
    begin
      Inc(LDelTo);
    end;
    if LDelTo > 0 then
    begin
      Result := S.Substring(LDelTo);
    end;
  end;
end;

class function TIdSysNet.TrimRight(const S: string): string;
var
  LastIndex: Integer;
  LDelPos: Integer;
begin
  Result := S;
  if Assigned(S) then
  begin
    LastIndex := S.Length - 1;
    LDelPos := LastIndex;
    while (LDelPos >= 0) and (S.Chars[LDelPos] <= ' ') do
    begin
      Dec(LDelPos);
    end;
    if LDelPos < LastIndex then
    begin
      Result := S.Substring(0, LDelPos + 1);
    end;
  end;
end;

class function TIdSysNet.DirectoryExists(const Directory: string): Boolean;
begin
  Result := System.IO.Directory.Exists(Directory);
end;

class function TIdSysNet.ExtractFileExt(const FileName: string): string;
begin
  Result := System.IO.Path.GetExtension(FileName);
end;

class function TIdSysNet.EncodeTime(Hour, Min, Sec, MSec: Word): TIdDateTimeBase;
begin
  Result := System.DateTime.Create(1, 1, 1, Hour, Min, Sec, MSec).ToOADate;
end;

class function TIdSysNet.EncodeDate(Year, Month, Day: Word): TIdDateTimeBase;
begin
 Result := System.DateTime.Create(Year, Month, Day, 0, 0, 0, 0).ToOADate;
end;

class function TIdSysNet.AlignLeftCol(const AStr: String;
  const AWidth: Integer): String;
begin
  Result := Copy(Result,Length(AStr)-AWidth+1,AWidth);
end;

class function TIdSysNet.FloatToIntStr(const AFloat: Extended): String;
begin
  Result := Int(AFloat).ToString;
end;

class function TIdSysNet.TwoDigitYearCenturyWindow: Word;
begin
//in SysUtils, this value is adjustable but I haven't figured out how to do that
//here.  Borland's is 50 but for our purposes, 1970 should work since it is the Unix epech
//and FTP was started around 1973 anyway.   Besides, if I mess up, chances are
//that I will not be around to fix it :-).
  Result := 70;
end;

class function TIdSysNet.ExtractFileName(const FileName: string): string;
begin
  Result := System.IO.Path.GetFileName(FileName);
end;

class function TIdSysNet.DeleteFile(const FileName: string): Boolean;
begin
  Result := False;
  if System.IO.&File.Exists(FileName) then
  begin
    System.IO.&File.Delete(FileName);
    Result := not System.IO.&File.Exists(FileName);
  end;
end;

class function TIdSysNet.FileAge(const FileName: string): TIdDateTimeBase;
begin
  if System.IO.&File.Exists(FileName) then
  begin
    Result := System.IO.&File.GetLastWriteTime(FileName).ToOADate;
  end
  else
  begin
    Result := 0;
  end;
end;

class function TIdSysNet.CompareDate(const D1, D2: TIdDateTimeBase): Integer;
begin
  Result := D1.CompareTo(&Object(D2));
end;

class function TIdSysNet.StrToDateTime(const S: String): TIdDateTimeBase;
begin
  Result := DateTime.Parse(S).ToOADate;
end;

class function TIdSysNet.StrToInt64(const S: string): Int64;
var LErr : Integer;
begin
  Val(Trim(S),Result,LErr);
  if LErr <> 0 then
  begin
    raise EConvertError.Create('');
  end;
end;

class function TIdSysNet.StrToInt64(const S: string;
  const Default: Int64): Int64;
var LErr : Integer;
begin
  Val(Trim(S),Result,LErr);
  if LErr <> 0 then
  begin
    Result := Default;
  end;
end;

class function TIdSysNet.SameText(const S1, S2: String): Boolean;
begin
  Result := System.&String.Compare(S1,S2,True)=0;
end;

class function TIdSysNet.AddStringToFormat(SB: StringBuilder; I: Integer; S: String): Integer;
begin
  SB.Append(S);
  Result := I + 1;
end;

class function TIdSysNet.ConvertFormat(const AFormat : String;
  const ADate : TIdDateTimeBase;
  DTInfo : System.Globalization.DateTimeFormatInfo): String;
var
  LSB : StringBuilder;
  I, LCount, LHPos, LH2Pos, LLen: Integer;
  c : Char;
  LAMPM : String;
begin
  Result := '';
  LSB := StringBuilder.Create;
  Llen := AFormat.Length;
  if LLen=0 then
  begin
    Exit;
  end;
  I := 1;
  LHPos := -1;
  LH2Pos := -1;
  repeat
    if I > LLen then
    begin
      Break;
    end;
    C := AFormat[I];
    case C of
      't', 'T' : //t - short time, tt - long time
      begin
        if (i < LLen) and ((AFormat[i+1]='t') or (AFormat.Chars[i]='T')) then
        begin
          LSB.Append(DTInfo.LongTimePattern );
          i := i + 2;
        end
        else
        begin
          LSB.Append(DTInfo.ShortTimePattern );
          i := i + 1;
        end;
      end;
      'c', 'C' : //
      begin
        LSB.Append( DTInfo.ShortDatePattern  );
        i := AddStringToFormat(LSB,i,' ');
        LSB.Append( DTInfo.LongTimePattern );
      end;
      'd' : //must do some mapping
      begin
        LCount := 0;
        while (i + LCount<=LLen) and ((AFormat[i+LCount] ='D') or
          (AFormat[i+LCount] ='d')) do
        begin
          Inc(LCount);
        end;
        case LCount of
          5 : LSB.Append(DTInfo.ShortDatePattern);
          6 : LSB.Append(DTInfo.LongDatePattern);
        else
          LSB.Append(StringOfChar(c,LCount));
        end;
        Inc(i,LCount);
      end;
      'h' : //h -
      //assume 24 hour format
      //remember positions in case am/pm pattern appears later
      begin
        LHPos := LSB.Length;
        i := AddStringToFormat(LSB,i,'H');
        if (i <= LLen) then
        begin
          if (AFormat[i] ='H') or (AFormat[i] = 'h') then
          begin
            LH2Pos := LSB.Length;
            i := AddStringToFormat(LSB,i,'H');
          end;
        end;
      end;
      'a' : //check for AM/PM formats
      begin
        if LAMPM ='' then
        begin
          //We want to honor both lower and uppercase just like Borland's
          //FormatDate should
          if DateTime.FromOADate(ADate).Hour <12 then
          begin
            LAMPM := DTInfo.AMDesignator;
          end
          else
          begin
            LAMPM := DTInfo.PMDesignator;
          end;
        end;
        if System.&String.Compare(AFormat,i-1,'am/pm',0,5,True)=0 then
        begin
          LSB.Append('"');
          if AFormat.Chars[i-1]='a' then
          begin
            LSB.Append( System.Char.ToLower( LAMPM.Chars[0]) );
          end
          else
          begin
            LSB.Append( LSB.Append( System.Char.ToUpper( LAMPM.Chars[0]) ));
          end;
          if AFormat.Chars[i]='m' then
          begin
            LSB.Append( System.Char.ToLower( LAMPM.Chars[1]) );
          end
          else
          begin
            LSB.Append( LSB.Append( System.Char.ToUpper( LAMPM.Chars[1]) ));
          end;
          LSB.Append('"');
          i := i + 5;
        end
        else
        begin
          if System.&String.Compare(AFormat,i-1,'a/p',0,3,True)=0 then
          begin
            LSB.Append('"');
            if AFormat.Chars[i-1]='a' then
            begin
              LSB.Append( System.Char.ToLower( LAMPM.Chars[0]) );
            end
            else
            begin
              LSB.Append( LSB.Append( System.Char.ToUpper( LAMPM.Chars[0]) ));
            end;
            LSB.Append('"');
            i := i + 3;
          end
          else
          begin
            LSB.Append('"');
            if AFormat.Chars[i-1]='a' then
            begin
              LSB.Append( System.Char.ToLower( LAMPM.Chars[0]) );
            end
            else
            begin
              LSB.Append( LSB.Append( System.Char.ToUpper( LAMPM.Chars[0]) ));
            end;
            if AFormat.Chars[i]='m' then
            begin
              LSB.Append( System.Char.ToLower( LAMPM.Chars[1]) );
            end
            else
            begin
              LSB.Append( LSB.Append( System.Char.ToUpper( LAMPM.Chars[1]) ));
            end;
            LSB.Append('"');
            i := i + 5;
          end;
        end;
        if LHPos <> -1 then
        begin
          LSB.Chars[LHPos] := 'h';
          if LH2Pos<>-1 then
          begin
            LSB.Chars[LH2Pos] := 'h';
          end;
          LHPos := -1;
          LH2Pos := -1;
        end;
      end;
      'z', 'Z' :
      begin
        if (i+2 < LLen) and (System.&String.Compare(AFormat,i-1,'zzz',0,3,True)=0) then
        begin
          LSB.Append(DateTime.FromOADate(ADate).Millisecond.ToString );
          i := i + 3;
        end
        else
        begin
          LSB.Append('fff');
          i := i + 1;
        end;
      end;
      '/' : //double his
      begin
        i := AddStringToFormat(LSB,i,'\\');
      end;
      '''','"' : //litteral
      begin
        i := AddStringToFormat(LSB,i,C);
        LCount := 0;
        while (i + LCount < LLen) and (AFormat.Chars[I+LCount]<>C) do
        begin
          Inc(LCount);
        end;
        LSB.Append(AFormat,i-1,LCount);
        inc(i,LCount);
        if i<=LLen then
        begin
          AddStringToFormat(LSB,i,c);
        end;

      end;
      'n','N' : //minutes - lowercase m
      begin
        i := AddStringToFormat(LSB,i,'m');
      end;
      'm','M' : //monthes - must be uppercase
      begin
        i := AddStringToFormat(LSB,i,'M');
      end;
      'y','Y' : //year - must be lowercase
      begin
        i := AddStringToFormat(LSB,i,'y');
      end;
      's','S' : //seconds -must be lowercase
      begin
        i := AddStringToFormat(LSB,i,'s');
      end
      else
      begin
        i := AddStringToFormat(LSB,i,C);
      end;
    end;
  until False;
  Result := LSB.ToString;
end;

class function TIdSysNet.FormatDateTime(const Format: string;
  ADateTime: TIdDateTimeBase): string;
var LF : System.Globalization.DateTimeFormatInfo;
begin
  //unlike Borland's FormatDate, we only want the ENglish language
  LF := System.Globalization.DateTimeFormatInfo.InvariantInfo;
  Result := DateTime.FromOADate(ADateTime).ToString(ConvertFormat(Format,ADateTime,LF),LF);
end;

class function TIdSysNet.DayOfWeek(const ADateTime: TIdDateTimeBase): Word;
begin
  Result := Integer(DateTime.FromOADate(ADateTime).DayOfWeek) + 1;
end;

class function TIdSysNet.AddMSecToTime(const ADateTime: TIdDateTimeBase;
  const AMSec: Integer): TIdDateTimeBase;
var LD : DateTime;
begin
  LD := DateTime.FromOADate(ADateTime);
  LD := LD.AddMilliseconds(AMSec);
  Result := LD.ToOADate;
end;

class function TIdSysNet.LastChars(const AStr: String; const ALen : Integer): String;
begin
  if Assigned(AStr) and (AStr.Length > ALen) then
  begin
    Result := Copy(AStr,Length(AStr)-ALen+1,ALen);
  end
  else
  begin
    Result := AStr;
  end;
end;

{ TIdStringBuilderHelper }

function TIdStringBuilderHelper.IndexOf(const value: String): Integer;
begin
  Result := IndexOf(value,0,Self.Length);
end;

function TIdStringBuilderHelper.IndexOf(const value: String;
  const startIndex: Integer): Integer;
begin
   Result := IndexOf(value,startIndex,Self.Length);
end;

function TIdStringBuilderHelper.IndexOf(const value: String;
  const startIndex, count: Integer): Integer;
var i,j,l : Integer;
    LFoundSubStr : Boolean;
begin
  Result := -1;
  if not Assigned(value)
    or (value.Length + startIndex > (Self.Length + startIndex))
    or (value.Length > startIndex + count)  then
  begin
    Exit;
  end;
  l := (startIndex + count);

  if l > (Self.Length - 1) then
  begin
    l := Self.Length - 1;
  end;

  for i := startIndex to l-value.Length+1 do
  begin
    if i < 0 then
    begin
      break;
    end;
    if Self.Chars[i] = value.Chars[0] then
    begin
      //we don't want to loop through the substring if it has only
      //one char because there's no sense to evaluate the same thing
      //twice
      if value.Length > 1 then
      begin
        Result := i;
        Break;
      end
      else
      begin
        LFoundSubStr := True;
        for j := 1 to value.Length-1 do
        begin
         if Self.Chars[i + j] <> value.Chars[j] then
         begin
           LFoundSubStr := False;
           break;
         end;
        end;
        if LFoundSubStr then
        begin
          Result := i;
          Exit;
        end;
      end;
    end;

  end;
end;

function TIdStringBuilderHelper.LastIndexOf(const value: String): Integer;
begin
 Result := LastIndexOf(value,Self.Length);
end;

function TIdStringBuilderHelper.LastIndexOf(const value: String;
  const startIndex: Integer): Integer;
begin
  Result := LastIndexOf(value,startIndex,Self.Length);
end;

function TIdStringBuilderHelper.LastIndexOf(const value: String;
  const startIndex, count: Integer): Integer;
var i,j : Integer;
    LFoundSubStr : Boolean;
    LEndIndex, LStartIndex : Integer;
begin
  Result := -1;
  LEndIndex := startindex - count;
  if LEndIndex < 0 then
  begin
    LEndIndex := 0;
  end;
  if (LEndIndex > Self.Length) or not Assigned(value) then
  begin
    Exit;
  end;
  LStartIndex := startIndex;
  if LStartIndex >= Self.Length then
  begin
    LStartIndex := Self.Length-1;
  end;


  for i := LStartIndex downto LEndIndex+1+value.Length do
  begin
    if Self.Chars[i] = value.Chars[0] then
    begin
      //we don't want to loop through the substring if it has only
      //one char because there's no sense to evaluate the same thing
      //twice
      if value.Length < 2 then
      begin
        Result := i;
        Break;
      end
      else
      begin
        LFoundSubStr := True;
        for j := value.Length-1 downto 1 do
        begin
         if Self.Chars[i + j] <> value.Chars[j] then
         begin
           LFoundSubStr := False;
           break;
         end;
        end;
        if LFoundSubStr then
        begin
          Result := i;
          Exit;
        end;
      end;
    end;

  end;
end;

function TIdStringBuilderHelper.ReplaceOnlyFirst(const oldValue,
  newValue: String; const startIndex, count: Integer): StringBuilder;
var
  i : Integer;

begin
  Result := Self;
  i := Self.IndexOf(OldValue,startIndex,count);
  if i < 0 then
  begin
    Exit;
  end;
  if Assigned(oldValue) then
  begin
    Self.Remove(i,oldValue.Length);
  end;
  Self.Insert(i,newValue);
end;

function TIdStringBuilderHelper.ReplaceOnlyFirst(const oldValue,
  newValue: String): StringBuilder;
begin
  Result := ReplaceOnlyFirst(oldValue,newValue,0,Self.Length);
end;

function TIdStringBuilderHelper.ReplaceOnlyLast(const oldValue,
  newValue: String; const startIndex, count: Integer): StringBuilder;
var
  i : Integer;

begin
  Result := Self;
  i := Self.LastIndexOf(OldValue,startIndex,count);
  if i < 0 then
  begin
    Exit;
  end;
  if Assigned(oldValue) then
  begin
    Self.Remove(i,oldValue.Length);
  end;
  Self.Insert(i,newValue);
end;

function TIdStringBuilderHelper.ReplaceOnlyLast(const oldValue,
  newValue: String): StringBuilder;

begin
  Result := Self.ReplaceOnlyLast(oldValue,newValue,Self.Length,Self.Length);
end;

class function TIdSysNet.FormatBuf(var Buffer: System.Text.StringBuilder;
  const Format: string; FmtLen: Cardinal; const Args: array of const): Cardinal;
var
  LFormat: NumberFormatInfo;
begin
  //for most of our uses, we want the immutable settings instead of the user's
  //local settings.
  LFormat := NumberFormatInfo.InvariantInfo;

  Result := FormatBuf(Buffer, Format, FmtLen, Args, LFormat);
end;

class function TIdSysNet.FormatBuf(var Buffer: System.Text.StringBuilder;
  const Format: string; FmtLen: Cardinal; const Args: array of const;
  Provider: IFormatProvider): Cardinal;

  function ReadNumber(const AFmt : String;
    const AArgs: array of const;
    AProvider: IFormatProvider;
    var VIdx : Integer;
    var VArgIdx : Integer;
    AScratch : System.Text.StringBuilder): Integer;

  begin
    Result := 0;
    AScratch.Length := 0;
    if AFmt.Chars[VIdx] = '-' then
    begin
      AScratch.Append(AFmt.Chars[VIdx]);
      Inc(VIdx);
      if VIdx >= AFmt.Length then
      begin
        Exit;
      end;
    end;
    if AFmt.Chars[VIdx] = '*' then
    begin
      //The value is embedded in the Args paramer;

       AScratch.Append(AArgs[VArgIdx]);
      Inc(VArgIdx);
      Inc(VIdx);
    end
    else
    begin
      //parse the value
      repeat

        if VIdx >= AFmt.Length then
        begin
          Break;
        end;

         if System.Char.IsDigit(AFmt.Chars[VIdx]) then
         begin
           AScratch.Append( AFmt.Chars[VIdx]);
         end
         else
         begin
           break;
         end;
         inc(VIdx);
      until False;
    end;
    if AScratch.Length>0 then
    begin
      Result := System.Convert.ToInt32 ( AScratch.ToString, AProvider );
    end;
  end;


var
  LStrLen : Integer;
  LIdx, LArgIdx : Integer;
  LPerLen : Integer;
  LWidth : Integer;
  LFmStr : System.Text.StringBuilder;
  LScratch : System.Text.StringBuilder; //scratch pad for int. usage

begin
  LWidth := 0;
  LIdx := 0;
  LArgIdx := 0;
  LStrLen := Format.Length;
  LFmStr := System.Text.StringBuilder.Create;
  LScratch := System.Text.StringBuilder.Create;
  repeat
    if LIdx >= LStrLen then
    begin
      Break;
    end;
    if Format.Chars[LIdx]='%' then
    begin
      inc(LIdx);
      if LIdx >= LStrLen then
      begin
        break;
      end;
      //interpret as one litteral % in a string
      if Format.Chars[LIdx] ='%' then
      begin
        Buffer.Append(Format.Chars[LIdx]);
        Continue;
      end;
      LFmStr.Length := 0;
      LFmStr.Append('{0');
      //width specifier might be first
      LWidth := ReadNumber(Format,Args,Provider,LIdx,LArgIdx,LScratch);

      if Format.Chars[LIdx] = ':' then
      begin
        inc(LIdx);
        if LIdx >= LStrLen then
        begin
          break;
        end;
        //That was not the width but the Index
        if LWidth >-1 then
        begin
          LArgIdx := LWidth;
          LWidth := -1;
        end
        else
        begin
          LArgIdx := 0;
          Inc(LIdx);
          if LIdx >= LStrLen then
          begin
            break;
          end;
        end;

        LWidth := ReadNumber(Format,Args,Provider,LIdx,LArgIdx,LScratch);
      end;
      //Percission value
      if Format.Chars[LIdx] = '.' then
      begin
        inc(LIdx);
        if LIdx >= LStrLen then
        begin
          break;
        end;
        LPerLen := ReadNumber(Format,Args,Provider,LIdx,LArgIdx,LScratch);
      end
      else
      begin
        LPerLen := 0;
      end;
      if LWidth <> 0 then
      begin
        LFmStr.Append(','+LWidth.ToString);
      end;
      LFmStr.Append(Char(':'));

      case Format.Chars[LIdx] of
        'd', 'D',
        'u', 'U': LFmStr.Append(Char('d'));
        'e', 'E',
        'f', 'F',
        'g', 'G',
        'n', 'N',
        'x', 'X':  LFmStr.Append(Char(Format.Chars[LIdx]));

        'm', 'M': LFmStr.Append(Char('c'));
        'p', 'P': LFmStr.Append(Char('x'));
        's', 'S': ;  // no format spec needed for strings
      else
        Continue;
      end;
      if LPerLen>0 then
      begin
        LFmStr.Append(LPerLen.ToString);
      end;
      LFmStr.Append(Char('}'));
      //we'll AppendFormat to our scratchpad instead of directly into
      //buffer because the Width specifier needs to truncate with a string.
      LScratch.Length := 0;
      LScratch.AppendFormat(Provider, LFmStr.ToString, [Args[LArgIdx]]);
      if ((Format.Chars[LIdx] = 's') or (Format.Chars[LIdx] = 'S')) and
        (LPerLen>0) then
      begin
        LScratch.Length := LPerLen;
      end;
      Buffer.Append(LScratch);
      Inc(LArgIdx);
    end
    else
    begin
      Buffer.Append(Format.Chars[LIdx]);
    end;
    Inc(LIdx);
  until False;
  Result := Buffer.Length;
end;

class procedure TIdSysNet.FmtStr(var Result: string; const Format: string;
  const Args: array of const);
var
  Buffer: System.Text.StringBuilder;
begin
  Buffer := System.Text.StringBuilder.Create(Length(Format) * 2);
  FormatBuf(Buffer, Format, Length(Format), Args);
  Result := Buffer.ToString;
end;

class function TIdSysNet.AnsiCompareText(const S1, S2: WideString): Integer;
begin
  Result := System.String.Compare(S1, S2, True);
end;

class function TIdSysNet.ChangeFileExt(const FileName,
  Extension: string): string;
begin
  if Length(Extension) <> 0 then
  begin
    Result := System.IO.Path.ChangeExtension(FileName, Extension)
  end
  else
  begin
    Result := System.IO.Path.ChangeExtension(FileName, System.String(nil));
  end;
end;

class function TIdSysNet.AnsiCompareStr(const S1, S2: string): Integer;
begin
  if not Assigned(S1) and not Assigned(S2) then
  begin
    Result := 0;
  end
  else if not Assigned(S1) then
  begin
    Result := S1.CompareTo(S2);
  end
  else
    Result := -1;
end;

class function TIdSysNet.AnsiLowerCase(const S: WideString): WideString;
begin
  Result := S;
  if Assigned(S) then
  begin
    Result := S.ToLower;
  end;
end;

class function TIdSysNet.AnsiUpperCase(const S: WideString): WideString;
begin
  Result := S;
  if Assigned(S) then
  begin
    Result := S.ToUpper;
  end;
end;

class function TIdSysNet.AnsiPos(const Substr, S: WideString): Integer;
begin
  Result := 0;
  if Assigned(S) then
  begin
    Result := S.IndexOf(Substr) + 1;
  end;
end;

class function TIdSysNet.OffsetFromUTC: TIdDateTimeBase;
begin
  Result := System.Timezone.CurrentTimezone.GetUTCOffset(DateTime.FromOADate(Now)).TotalDays;
end;

const
  wdays: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'    {Do not Localize}
   , 'Sat'); {do not localize}
  monthnames: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May'    {Do not Localize}
   , 'Jun',  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}

class function TIdSysNet.DateTimeGMTToHttpStr(const GMTValue: TIdDateTimeBase) : String;
// should adhere to RFC 2616

var
  wDay,
  wMonth,
  wYear: Word;
begin
  DecodeDate(GMTValue, wYear, wMonth, wDay);
  Result := Format('%s, %.2d %s %.4d %s %s',    {do not localize}
                   [wdays[DayOfWeek(GMTValue)], wDay, monthnames[wMonth],
                    wYear, DateTime.FromOADate(GMTValue).ToString('HH:mm:ss'), 'GMT']);  {do not localize}
end;


{This should never be localized}
class function TIdSysNet.DateTimeToInternetStr(const Value: TIdDateTimeBase; const AIsGMT : Boolean = False) : String;
var
  wDay,
  wMonth,
  wYear: Word;
begin
  DecodeDate(Value, wYear, wMonth, wDay);
  Result := Format('%s, %d %s %d %s %s',    {do not localize}
                   [ wdays[DayOfWeek(Value)], wDay, monthnames[wMonth],
                    wYear, DateTime.FromOADate(Value).ToString('HH:mm:ss'),  {do not localize}
                    DateTimeToGmtOffSetStr(OffsetFromUTC, AIsGMT)]);
end;

class function TIdSysNet.DateTimeToGmtOffSetStr(ADateTime: TIdDateTimeBase; SubGMT: Boolean): string;
var
  AHour, AMin, ASec, AMSec: Word;
begin
  if (ADateTime = 0.0) and SubGMT then
  begin
    Result := 'GMT'; {do not localize}
    Exit;
  end;
  DecodeTime(ADateTime, AHour, AMin, ASec, AMSec);
  Result := Format(' {0}{1}', [AHour.ToString('G2'), AMin.ToString('G2')]); {do not localize}
  if ADateTime < 0.0 then
  begin
    Result[1] := '-'; {do not localize}
  end
  else
  begin
    Result[1] := '+';  {do not localize}
  end;
end;

class function TIdSysNet.ExtractFilePath(const AFileName: string): string;
begin
  Result := Path.GetDirectoryName(AFileName);
end;

end.
