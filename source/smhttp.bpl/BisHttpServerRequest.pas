unit BisHttpServerRequest;

interface

uses Classes,
     HTTPApp,
     IdContext, IdCustomHTTPServer;

type

  TBisHttpServerRequest = class(TWebRequest)
  protected
    FRequestInfo   : TIdHTTPRequestInfo;
    FResponseInfo  : TIdHTTPResponseInfo;
    FContext        : TIdContext;
    FClientCursor  : Integer;
    FNewPathInfo: string;
    FNewScriptName: string;

    function GetDateVariable(Index: Integer): TDateTime; override;
    function GetIntegerVariable(Index: Integer): Integer; override;
    function GetStringVariable(Index: Integer): string; override;
    function GetInternalPathInfo: string; override;
    function GetInternalScriptName: string; override;
  public
    constructor Create(AContext: TIdContext; ARequestInfo: TidHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function GetFieldByName(const Name: string): string; override;
    function ReadClient(var Buffer; Count: Integer): Integer; override;
    function ReadString(Count: Integer): string; override;
    function TranslateURI(const URI: string): string; override;
    function WriteClient(var ABuffer; ACount: Integer): Integer; override;
    function WriteHeaders(StatusCode: Integer; const ReasonString, Headers: string): Boolean; override;
    function WriteString(const AString: string): Boolean; override;

    property NewPathInfo: string read FNewPathInfo write FNewPathInfo;
    property NewScriptName: string read FNewScriptName write FNewScriptName;
  end;

implementation

uses SysUtils,
     IdException, IdHTTPHeaderInfo, IdGlobal, IdCookie, IdSocketHandle, IdAssignedNumbers,
     IdResourceStrings, IdIOHandlerSocket,

     BisHttpServerConsts;

{ TBisHttpServerRequest }

constructor TBisHttpServerRequest.Create(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
Var
  i: Integer;
begin
  FContext := AContext;
  FRequestInfo := ARequestInfo;
  FResponseInfo := AResponseInfo;
  inherited Create;
  FClientCursor := 0;
  for i := 0 to ARequestInfo.Cookies.Count - 1 do begin
    CookieFields.Add(ARequestInfo.Cookies[i].ClientCookie);
  end;
end;

function TBisHttpServerRequest.GetInternalPathInfo: string;
begin
  if NewPathInfo<>'' then
    Result:=FNewPathInfo
  else
    Result:=inherited GetInternalPathInfo;
end;

function TBisHttpServerRequest.GetInternalScriptName: string;
begin
  if NewScriptName<>'' then
    Result:=FNewScriptName
  else
    Result:=inherited GetInternalScriptName;
end;

function TBisHttpServerRequest.GetDateVariable(Index: Integer): TDateTime;
var
  LValue: string;
begin
  LValue := GetStringVariable(Index);
  if Length(LValue) > 0 then begin
    Result := ParseDate(LValue)
  end else begin
    Result := -1;
  end;
end;

function TBisHttpServerRequest.GetIntegerVariable(Index: Integer): Integer;
begin
  Result := StrToIntDef(GetStringVariable(Index), -1)
end;

function TBisHttpServerRequest.GetStringVariable(Index: Integer): string;
var
  s: string;
begin
  case Index of
    INDEX_Method          : Result := FRequestInfo.Command;
    INDEX_ProtocolVersion : Result := FRequestInfo.Version;
    INDEX_URL             : Result := FRequestInfo.Document;
    INDEX_Query           : Result := FRequestInfo.UnparsedParams;
    INDEX_PathInfo        : Result := FRequestInfo.Document;
    INDEX_PathTranslated  : Result := FRequestInfo.Document;             // it's not clear quite what should be done here - we can't translate to a path
    INDEX_CacheControl    : Result := GetFieldByName('CACHE_CONTROL');   {do not localize}
    INDEX_Date            : Result := GetFieldByName('DATE');            {do not localize}
    INDEX_Accept          : Result := FRequestInfo.Accept;
    INDEX_From            : Result := FRequestInfo.From;
    INDEX_Host: begin
      s := FRequestInfo.Host;
      Result := Fetch(s, ':');
    end;
    INDEX_IfModifiedSince : Result := GetFieldByName('IF_MODIFIED_SINCE'); {do not localize}
    INDEX_Referer         : Result := FRequestInfo.Referer;
    INDEX_UserAgent       : Result := FRequestInfo.UserAgent;
    INDEX_ContentEncoding : Result := FRequestInfo.ContentEncoding;
    INDEX_ContentType     : Result := FRequestInfo.ContentType;
    INDEX_ContentLength   : Result := IntToStr(Length(FRequestInfo.UnparsedParams));
    INDEX_ContentVersion  : Result := GetFieldByName('CONTENT_VERSION'); {do not localize}
    INDEX_DerivedFrom     : Result := GetFieldByName('DERIVED_FROM');    {do not localize}
    INDEX_Expires         : Result := GetFieldByName('EXPIRES');         {do not localize}
    INDEX_Title           : Result := GetFieldByName('TITLE');           {do not localize}
    INDEX_RemoteAddr      : Result := FRequestInfo.RemoteIP;
    INDEX_RemoteHost      : Result := GetFieldByName('REMOTE_HOST');     {do not localize}
    INDEX_ScriptName      : Result := FNewScriptName;
    INDEX_ServerPort: begin
      Result := FRequestInfo.Host;
      Fetch(Result, ':');
      if Length(Result) = 0 then begin
        Result := IntToStr(TIdIOHandlerSocket(FContext.Connection.IOHandler).Binding.Port);
        // Result := '80';
      end;
    end;
    INDEX_Content         : begin
      if Assigned(FRequestInfo.PostStream) then begin
        FRequestInfo.PostStream.Position:=0;
        SetLength(s,FRequestInfo.PostStream.Size);
        FRequestInfo.PostStream.ReadBuffer(Pointer(s)^,Length(s));
        Result:=s;
      end else
        Result:='';
    end;
    INDEX_Connection      : Result := GetFieldByName('CONNECTION');      {do not localize}
    INDEX_Cookie          : Result := '';  // not available at present. FRequestInfo.Cookies....;
    INDEX_Authorization   : Result := GetFieldByName('AUTHORIZATION');   {do not localize}
  else
    Result := '';
  end;
end;

function TBisHttpServerRequest.GetFieldByName(const Name: string): string;
begin
  if Assigned(FContext) then begin
    if AnsiSameText(Name,'REMOTE_IP') then Result:=FContext.Binding.PeerIP
    else if AnsiSameText(Name,'REMOTE_PORT') then Result:=IntToStr(FContext.Binding.PeerPort)
    else if AnsiSameText(Name,'AUTH_USER_NAME') then Result:=FRequestInfo.AuthUsername
    else if AnsiSameText(Name,'AUTH_PASSWORD') then Result:=FRequestInfo.AuthPassword
    else
      Result := FRequestInfo.RawHeaders.Values[Name];
  end else
    Result := FRequestInfo.RawHeaders.Values[Name];
end;

function TBisHttpServerRequest.ReadClient(var Buffer; Count: Integer): Integer;
begin
  Result := Min(Count, length(FRequestInfo.UnparsedParams)) - FClientCursor;
  if Result > 0 then begin
    Move(FRequestInfo.UnparsedParams[FClientCursor + 1], Buffer, Result);
    Inc(FClientCursor, Result);
  end else begin
    // well, it shouldn't be less than 0. but let's not take chances
    Result := 0;
  end;
end;

function TBisHttpServerRequest.ReadString(Count: Integer): string;
var
  LLength: Integer;
begin
  LLength := Min(Count, length(FRequestInfo.UnparsedParams)) - FClientCursor;
  if LLength > 0 then
    begin
    Result := copy(FRequestInfo.UnparsedParams, FClientCursor, LLength);
    inc(FClientCursor, LLength);
    end
  else
    Result := '';
end;

function TBisHttpServerRequest.TranslateURI(const URI: string): string;
begin
  // we don't have the concept of a path translation. It's not quite clear
  // what to do about this. Comments welcome (grahame@kestral.com.au)
  Result := URI;
end;

function TBisHttpServerRequest.WriteHeaders(StatusCode: Integer; const ReasonString, Headers: string): Boolean;
begin
  FResponseInfo.ResponseNo := StatusCode;
  FResponseInfo.ResponseText := ReasonString;
  FResponseInfo.CustomHeaders.Add(Headers);
  FResponseInfo.WriteHeader;
  Result := True;
end;

function TBisHttpServerRequest.WriteString(const AString: string): Boolean;
begin
  WriteClient(PChar(AString)^, Length(AString));
  Result := True;
end;

function TBisHttpServerRequest.WriteClient(var ABuffer; ACount: Integer): Integer;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    Stream.WriteBuffer(ABuffer,ACount);
    Stream.Position:=0;
    FContext.Connection.Socket.Write(Stream);
    Result := ACount;
  finally
    Stream.Free;
  end;
end;


end.
