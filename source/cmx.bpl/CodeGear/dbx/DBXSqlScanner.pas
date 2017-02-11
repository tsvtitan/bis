{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXSqlScanner;
interface
uses
  DBXPlatformUtil;
type
  TDBXSqlScanner = class
  public
    constructor Create(const QuoteChar: WideString; const QuotePrefix: WideString; const QuoteSuffix: WideString);
    destructor Destroy; override;
    procedure RegisterId(const Id: WideString; const Token: Integer);
    procedure Init(const Query: WideString); overload;
    procedure Init(const Query: WideString; const StartIndex: Integer); overload;
    function LookAtNextToken: Integer;
    function NextToken: Integer;
    function IsKeyword(const Keyword: WideString): Boolean;
  protected
    function GetId: WideString;
  private
    class function ToQuoteChar(const QuoteString: WideString): WideChar; static;
    procedure ResetId;
    function ScanNumber: Integer;
    function QuotedToken: Integer;
    function PrefixQuotedToken: Integer;
    function UnquotedToken: Integer;
    function ScanSymbol: Integer;
    procedure SkipToEndOfLine;
  private
    FQuotePrefix: WideString;
    FQuoteSuffix: WideString;
    FQuote: WideString;
    FQuotePrefixChar: WideChar;
    FQuoteSuffixChar: WideChar;
    FQuoteChar: WideChar;
    FKeywords: TDBXObjectStore;
    FQuery: WideString;
    FIndex: Integer;
    FStartOfId: Integer;
    FEndOfId: Integer;
    FId: WideString;
    FWasId: Boolean;
    FWasQuoted: Boolean;
    FSymbol: WideChar;
  public
    property Id: WideString read GetId;
    property Quoted: Boolean read FWasQuoted;
    property Symbol: WideChar read FSymbol;
    property SqlQuery: WideString read FQuery;
    property NextIndex: Integer read FIndex;
  public
    const TokenEos = -1;
    const TokenId = -2;
    const TokenComma = -3;
    const TokenPeriod = -4;
    const TokenSemicolon = -5;
    const TokenOpenParen = -6;
    const TokenCloseParen = -7;
    const TokenNumber = -8;
    const TokenSymbol = -9;
    const TokenError = -10;
  end;

implementation
uses
  DBXMetaDataUtil,
  SysUtils;

constructor TDBXSqlScanner.Create(const QuoteChar: WideString; const QuotePrefix: WideString; const QuoteSuffix: WideString);
begin
  inherited Create;
  self.FQuotePrefix := QuotePrefix;
  self.FQuoteSuffix := QuoteSuffix;
  self.FQuote := QuoteChar;
  self.FQuotePrefixChar := ToQuoteChar(QuotePrefix);
  self.FQuoteSuffixChar := ToQuoteChar(QuoteSuffix);
  self.FQuoteChar := ToQuoteChar(QuoteChar);
end;

destructor TDBXSqlScanner.Destroy;
begin
  FreeAndNil(FKeywords);
  inherited Destroy;
end;

procedure TDBXSqlScanner.RegisterId(const Id: WideString; const Token: Integer);
begin
  if FKeywords = nil then
    FKeywords := TDBXObjectStore.Create;
  FKeywords[WideLowerCase(Id)] := TDBXInt32Object.Create(Token);
end;

procedure TDBXSqlScanner.Init(const Query: WideString);
begin
  Init(Query, 0);
end;

procedure TDBXSqlScanner.Init(const Query: WideString; const StartIndex: Integer);
begin
  self.FQuery := Query;
  self.FIndex := StartIndex;
  ResetId;
end;

class function TDBXSqlScanner.ToQuoteChar(const QuoteString: WideString): WideChar;
begin
  if (StringIsNil(QuoteString)) or (Length(QuoteString) = 0) then
    Result := #$0
  else if Length(QuoteString) > 1 then
    raise Exception.Create(SIllegalArgument)
  else 
    Result := QuoteString[1+0];
end;

function TDBXSqlScanner.LookAtNextToken: Integer;
var
  Save: Integer;
  Token: Integer;
begin
  Save := FIndex;
  Token := NextToken;
  FIndex := Save;
  Result := Token;
end;

function TDBXSqlScanner.NextToken: Integer;
var
  Ch: WideChar;
begin
  ResetId;
  while FIndex < Length(FQuery) do
  begin
    Ch := FQuery[1+IncrAfter(FIndex)];
    case Ch of
      ' ',
      #$9,
      #$d,
      #$a:;
      '(':
        begin
          FSymbol := Ch;
          begin
            Result := TokenOpenParen;
            exit;
          end;
        end;
      ')':
        begin
          FSymbol := Ch;
          begin
            Result := TokenCloseParen;
            exit;
          end;
        end;
      ',':
        begin
          FSymbol := Ch;
          begin
            Result := TokenComma;
            exit;
          end;
        end;
      '.':
        begin
          FSymbol := Ch;
          begin
            Result := TokenPeriod;
            exit;
          end;
        end;
      ';':
        begin
          FSymbol := Ch;
          begin
            Result := TokenSemicolon;
            exit;
          end;
        end;
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9':
        begin
          Result := ScanNumber;
          exit;
        end;
      else
        if Ch = FQuoteChar then
        begin
          Result := QuotedToken;
          exit;
        end
        else if Ch = FQuotePrefixChar then
        begin
          Result := PrefixQuotedToken;
          exit;
        end
        else if IsIdentifierStart(Ch) then
        begin
          Result := UnquotedToken;
          exit;
        end
        else if (Ch = '-') and (FIndex < Length(FQuery)) and (FQuery[1+FIndex] = '-') then
          SkipToEndOfLine
        else 
        begin
          Result := ScanSymbol;
          exit;
        end;
    end;
  end;
  Result := TokenEos;
end;

function TDBXSqlScanner.GetId: WideString;
begin
  if StringIsNil(FId) then
  begin
    FId := Copy(FQuery,FStartOfId+1,FEndOfId-(FStartOfId));
    if FWasQuoted then
      FId := TDBXMetaDataUtil.UnquotedIdentifier(FId, FQuote, FQuotePrefix, FQuoteSuffix);
  end;
  Result := FId;
end;

function TDBXSqlScanner.IsKeyword(const Keyword: WideString): Boolean;
begin
  Result := FWasId and (Keyword = Id);
end;

procedure TDBXSqlScanner.ResetId;
begin
  FId := NullString;
  FStartOfId := 0;
  FEndOfId := 0;
  FWasId := False;
  FWasQuoted := False;
  FSymbol := #$0;
end;

function TDBXSqlScanner.ScanNumber: Integer;
var
  Ch: WideChar;
begin
  FStartOfId := FIndex - 1;
  while FIndex < Length(FQuery) do
  begin
    Ch := FQuery[1+IncrAfter(FIndex)];
    case Ch of
      '.',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9':;
      else
        begin
          FEndOfId := Decr(FIndex);
          begin
            Result := TokenNumber;
            exit;
          end;
        end;
    end;
  end;
  FEndOfId := FIndex - 1;
  Result := TokenNumber;
end;

function TDBXSqlScanner.QuotedToken: Integer;
var
  Ch: WideChar;
begin
  FStartOfId := FIndex - 1;
  while FIndex < Length(FQuery) do
  begin
    Ch := FQuery[1+IncrAfter(FIndex)];
    if Ch = FQuoteChar then
    begin
      if (FIndex = Length(FQuery)) or (FQuery[1+FIndex] <> FQuoteChar) then
      begin
        FEndOfId := FIndex;
        FWasId := True;
        FWasQuoted := True;
        begin
          Result := TokenId;
          exit;
        end;
      end;
      IncrAfter(FIndex);
    end;
  end;
  Result := TokenError;
end;

function TDBXSqlScanner.PrefixQuotedToken: Integer;
var
  Ch: WideChar;
begin
  FStartOfId := FIndex - 1;
  while FIndex < Length(FQuery) do
  begin
    Ch := FQuery[1+IncrAfter(FIndex)];
    if Ch = FQuoteSuffixChar then
    begin
      FEndOfId := FIndex;
      FWasId := True;
      FWasQuoted := True;
      begin
        Result := TokenId;
        exit;
      end;
    end;
  end;
  Result := TokenError;
end;

function TDBXSqlScanner.UnquotedToken: Integer;
var
  Token: Integer;
  Ch: WideChar;
  Keyword: TDBXInt32Object;
begin
  Token := TokenId;
  FStartOfId := FIndex - 1;
  while FIndex < Length(FQuery) do
  begin
    Ch := FQuery[1+IncrAfter(FIndex)];
    if not IsIdentifierPart(Ch) then
    begin
      Decr(FIndex);
      break;
    end;
  end;
  FEndOfId := FIndex;
  FWasId := True;
  if FKeywords <> nil then
  begin
    Keyword := TDBXInt32Object(FKeywords[WideLowerCase(Id)]);
    if Keyword <> nil then
      Token := Keyword.IntValue;
  end;
  Result := Token;
end;

function TDBXSqlScanner.ScanSymbol: Integer;
begin
  FSymbol := FQuery[1+FIndex - 1];
  Result := TokenSymbol;
end;

procedure TDBXSqlScanner.SkipToEndOfLine;
var
  Ch: WideChar;
begin
  Ch := '-';
  while ((Ch <> #$d) and (Ch <> #$a)) and (FIndex < Length(FQuery)) do
    Ch := FQuery[1+IncrAfter(FIndex)];
end;

end.
