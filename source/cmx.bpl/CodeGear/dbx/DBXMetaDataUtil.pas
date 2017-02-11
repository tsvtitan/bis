{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXMetaDataUtil;
interface
type
  TDBXMetaDataUtil = class
  public
    class function QuoteIdentifier(const UnquotedIdentifier: WideString; const QuoteChar: WideString; const QuotePrefix: WideString; const QuoteSuffix: WideString): WideString; static;
    class function UnquotedIdentifier(const QuotedIdentifier: WideString; const QuoteChar: WideString; const QuotePrefix: WideString; const QuoteSuffix: WideString): WideString; static;
  end;

implementation
uses
  DBXPlatformUtil,
  StrUtils,
  SysUtils;

class function TDBXMetaDataUtil.QuoteIdentifier(const UnquotedIdentifier: WideString; const QuoteChar: WideString; const QuotePrefix: WideString; const QuoteSuffix: WideString): WideString;
var
  Buffer: TDBXWideStringBuffer;
  Index: Integer;
  From: Integer;
  QuotedIdentifier: WideString;
begin
  Buffer := TDBXWideStringBuffer.Create;
  Index := StringIndexOf(UnquotedIdentifier,QuoteSuffix);
  if (Index < 0) or (Length(QuoteSuffix) = 0) then
  begin
    Buffer.Append(QuotePrefix);
    Buffer.Append(UnquotedIdentifier);
    Buffer.Append(QuoteSuffix);
  end
  else 
  begin
    Buffer.Append(QuoteChar);
    From := 0;
    Index := StringIndexOf(UnquotedIdentifier,QuoteChar);
    if Length(QuoteChar) > 0 then
      while Index >= 0 do
      begin
        IncrAfter(Index);
        Buffer.Append(Copy(UnquotedIdentifier,From+1,Index-(From)));
        Buffer.Append(QuoteChar);
        From := Index;
        Index := StringIndexOf(UnquotedIdentifier,QuoteChar,From);
      end;
    Buffer.Append(Copy(UnquotedIdentifier,From+1,Length(UnquotedIdentifier)-(From)));
    Buffer.Append(QuoteChar);
  end;
  QuotedIdentifier := Buffer.ToString;
  FreeAndNil(Buffer);
  Result := QuotedIdentifier;
end;

class function TDBXMetaDataUtil.UnquotedIdentifier(const QuotedIdentifier: WideString; const QuoteChar: WideString; const QuotePrefix: WideString; const QuoteSuffix: WideString): WideString;
var
  Identifier: WideString;
  DoubleEndQuote: WideString;
  Index: Integer;
  Buffer: TDBXWideStringBuffer;
  From: Integer;
begin
  Identifier := QuotedIdentifier;
  if StringStartsWith(Identifier,QuotePrefix) and StringEndsWith(Identifier,QuoteSuffix) then
    Identifier := Copy(Identifier,Length(QuotePrefix)+1,Length(Identifier) - Length(QuoteSuffix)-(Length(QuotePrefix)))
  else if StringStartsWith(Identifier,QuoteChar) and StringEndsWith(Identifier,QuoteChar) then
  begin
    Identifier := Copy(Identifier,Length(QuotePrefix)+1,Length(Identifier) - Length(QuoteSuffix)-(Length(QuotePrefix)));
    DoubleEndQuote := QuoteChar + QuoteChar;
    Index := StringIndexOf(Identifier,DoubleEndQuote);
    if Index >= 0 then
    begin
      Buffer := TDBXWideStringBuffer.Create;
      From := 0;
      while Index >= 0 do
      begin
        Buffer.Append(Copy(Identifier,From+1,Index-(From)));
        Buffer.Append(QuoteChar);
        From := Index + Length(DoubleEndQuote);
        Index := StringIndexOf(Identifier,DoubleEndQuote,From);
      end;
      Buffer.Append(Copy(Identifier,From+1,Length(Identifier)-(From)));
      Identifier := Buffer.ToString;
      FreeAndNil(Buffer);
    end;
  end;
  Result := Identifier;
end;

end.
