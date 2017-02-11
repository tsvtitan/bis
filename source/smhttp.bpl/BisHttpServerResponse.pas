unit BisHttpServerResponse;

interface

uses Classes,
     HTTPApp,
     IdContext, IdCustomHTTPServer,
     BisHttpServerHandlers, BisHttpServerRedirects;

type
  TBisHttpServerResponse = class(TWebResponse)
  private
    FOnSendResponse: TNotifyEvent;
    FHandler: TBisHttpServerHandler;
    FPath: String;
    FScript: String;
    FPort: String;
    FHost: String;
    FRedirect: TBisHttpServerRedirect;
  protected
    FContent: string;
    FRequestInfo: TIdHTTPRequestInfo;
    FResponseInfo: TIdHTTPResponseInfo;
    FSent: Boolean;
    FContext: TIdContext;

    function GetContent: string; override;
    function GetDateVariable(Index: Integer): TDateTime; override;
    function GetStatusCode: Integer; override;
    function GetIntegerVariable(Index: Integer): Integer; override;
    function GetLogMessage: string; override;
    function GetStringVariable(Index: Integer): string; override;
    procedure SetContent(const AValue: string); override;
    procedure SetContentStream(AValue: TStream); override;
    procedure SetStatusCode(AValue: Integer); override;
    procedure SetStringVariable(Index: Integer; const Value: string); override;
    procedure SetDateVariable(Index: Integer; const Value: TDateTime); override;
    procedure SetIntegerVariable(Index: Integer; Value: Integer); override;
    procedure SetLogMessage(const Value: string); override;
    procedure MoveCookiesAndCustomHeaders;
  public
    constructor Create(AHTTPRequest: TWebRequest; AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    destructor Destroy; override;

    procedure SendRedirect(const URI: string); override;
    procedure SendResponse; override;
    procedure SendStream(AStream: TStream); override;
    function Sent: Boolean; override;

    property Handler: TBisHttpServerHandler read FHandler write FHandler;
    property Redirect: TBisHttpServerRedirect read FRedirect write FRedirect;

    property Host: String read FHost write FHost;
    property Port: String read FPort write FPort;
    property Path: String read FPath write FPath;
    property Script: String read FScript write FScript;

    
    property OnSendResponse: TNotifyEvent read FOnSendResponse write FOnSendResponse;
  end;


implementation

uses SysUtils,
     IdException, IdHTTPHeaderInfo, IdGlobal, IdCookie, IdSocketHandle, IdAssignedNumbers,
     IdResourceStrings, IdIOHandlerSocket,

     BisHttpServerConsts;

{ TBisHttpServerResponse }

constructor TBisHttpServerResponse.Create(AHTTPRequest: TWebRequest; AContext: TIdContext;
                                          ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  FContext := AContext;
  FRequestInfo := ARequestInfo;
  FResponseInfo := AResponseInfo;
  inherited Create(AHTTPRequest);
  if Length(FHTTPRequest.ProtocolVersion) = 0 then begin
    Version := '1.0';
  end;
  StatusCode := 200;
  LastModified := -1;
  Expires := -1;
  Date := -1;
  ContentType := 'text/html';
  FResponseInfo.FreeContentStream:=false;
  ContentStream:=TMemoryStream.Create;
end;

destructor TBisHttpServerResponse.Destroy;
begin
  inherited Destroy;
end;

function TBisHttpServerResponse.GetContent: string;
begin
  Result := FResponseInfo.ContentText;
end;

function TBisHttpServerResponse.GetLogMessage: string;
begin
  Result := '';
end;

function TBisHttpServerResponse.GetStatusCode: Integer;
begin
  Result := FResponseInfo.ResponseNo;
end;

function TBisHttpServerResponse.GetDateVariable(Index: Integer): TDateTime;
begin
  case Index of
    INDEX_RESP_Date             : Result := FResponseInfo.Date;
    INDEX_RESP_Expires          : Result := FResponseInfo.Expires;
    INDEX_RESP_LastModified     : Result := FResponseInfo.LastModified;
  else
    raise EIdException.Create('Invalid Index '+inttostr(Index)+' in TBisHttpServerResponse.GetDateVariable');
  end;
end;

procedure TBisHttpServerResponse.SetDateVariable(Index: Integer; const Value: TDateTime);
begin
  case Index of
    INDEX_RESP_Date             : FResponseInfo.Date := Value;
    INDEX_RESP_Expires          : FResponseInfo.Expires := Value;
    INDEX_RESP_LastModified     : FResponseInfo.LastModified := Value;
  else
    raise EIdException.Create('Invalid Index '+inttostr(Index)+' in TBisHttpServerResponse.SetDateVariable');
  end;
end;

function TBisHttpServerResponse.GetIntegerVariable(Index: Integer): Integer;
begin
  case Index of
    INDEX_RESP_ContentLength: Result := FResponseInfo.ContentLength;
  else
    raise EIdException.Create('Invalid Index '+inttostr(Index)+' in TBisHttpServerResponse.GetIntegerVariable');
  end;
end;

procedure TBisHttpServerResponse.SetIntegerVariable(Index, Value: Integer);
begin
  case Index of
    INDEX_RESP_ContentLength: FResponseInfo.ContentLength := Value;
  else
    raise EIdException.Create('Invalid Index '+inttostr(Index)+' in TBisHttpServerResponse.SetIntegerVariable');
  end;
end;

function TBisHttpServerResponse.GetStringVariable(Index: Integer): string;
begin
  case Index of
    INDEX_RESP_Version           :Result := FRequestInfo.Version;
    INDEX_RESP_ReasonString      :Result := FResponseInfo.ResponseText;
    INDEX_RESP_Server            :Result := FResponseInfo.Server;
    INDEX_RESP_WWWAuthenticate   :Result := FResponseInfo.WWWAuthenticate.Text;
    INDEX_RESP_Realm             :Result := FResponseInfo.AuthRealm;
    INDEX_RESP_Allow             :Result := FResponseInfo.CustomHeaders.Values['Allow'];
    INDEX_RESP_Location          :Result := FResponseInfo.Location;
    INDEX_RESP_ContentEncoding   :Result := FResponseInfo.ContentEncoding;
    INDEX_RESP_ContentType       :Result := FResponseInfo.ContentType;
    INDEX_RESP_ContentVersion    :Result := FResponseInfo.ContentVersion;
    INDEX_RESP_DerivedFrom       :Result := FResponseInfo.CustomHeaders.Values['Derived-From'];
    INDEX_RESP_Title             :Result := FResponseInfo.CustomHeaders.Values['Title'];
  else
    raise EIdException.Create('Invalid Index ' + IntToStr(Index)
     + ' in TBisHttpServerResponse.GetStringVariable');
  end;
end;

procedure TBisHttpServerResponse.SetStringVariable(Index: Integer; const Value: string);
begin
  case Index of
    INDEX_RESP_Version           :EIdException.Create('TBisHttpServerResponse.SetStringVariable: Cannot set the version');
    INDEX_RESP_ReasonString      :FResponseInfo.ResponseText := Value;
    INDEX_RESP_Server            :FResponseInfo.Server := Value;
    INDEX_RESP_WWWAuthenticate   :FResponseInfo.WWWAuthenticate.Text := Value;
    INDEX_RESP_Realm             :FResponseInfo.AuthRealm := Value;
    INDEX_RESP_Allow             :FResponseInfo.CustomHeaders.Values['Allow'] := Value;
    INDEX_RESP_Location          :FResponseInfo.Location := Value;
    INDEX_RESP_ContentEncoding   :FResponseInfo.ContentEncoding := Value;
    INDEX_RESP_ContentType       :FResponseInfo.ContentType := Value;
    INDEX_RESP_ContentVersion    :FResponseInfo.ContentVersion := Value;
    INDEX_RESP_DerivedFrom       :FResponseInfo.CustomHeaders.Values['Derived-From'] := Value;
    INDEX_RESP_Title             :FResponseInfo.CustomHeaders.Values['Title'] := Value;
  else
    raise EIdException.Create('Invalid Index ' + IntToStr(Index)
     + ' in TBisHttpServerResponse.SetStringVariable');
  end;
end;

procedure TBisHttpServerResponse.SendRedirect(const URI: string);
begin
  FSent := True;
  MoveCookiesAndCustomHeaders;
  FResponseInfo.Redirect(URI);
end;

procedure TBisHttpServerResponse.SendResponse;
begin
  FSent := True;
  // Reset to -1 so Indy will auto set it
  FResponseInfo.ContentLength := -1;
  MoveCookiesAndCustomHeaders;
  if Assigned(FOnSendResponse) then
    FOnSendResponse(Self);
  FResponseInfo.WriteContent;
end;

procedure TBisHttpServerResponse.SendStream(AStream: TStream);
begin
  FContext.Connection.Socket.Write(AStream);
end;

function TBisHttpServerResponse.Sent: Boolean;
begin
  Result := FSent;
end;

procedure TBisHttpServerResponse.SetContent(const AValue: string);
begin
  if not Assigned(FResponseInfo.ContentStream) then begin
    FResponseInfo.ContentText := AValue;
    FResponseInfo.ContentLength := Length(AValue);
  end else begin
    FResponseInfo.ContentStream.Write(Pointer(AValue)^,Length(AValue));
  end;
end;

procedure TBisHttpServerResponse.SetLogMessage(const Value: string);
begin
  // logging not supported
end;

procedure TBisHttpServerResponse.SetStatusCode(AValue: Integer);
begin
  FResponseInfo.ResponseNo := AValue;
end;

procedure TBisHttpServerResponse.SetContentStream(AValue: TStream);
begin
  inherited;
  FResponseInfo.ContentStream := AValue;
end;

procedure TBisHttpServerResponse.MoveCookiesAndCustomHeaders;
Var
  i: Integer;
begin
  for i := 0 to Cookies.Count - 1 do begin
    with FResponseInfo.Cookies.Add do begin
      CookieText := Cookies[i].HeaderValue
    end;
  end;
  FResponseInfo.CustomHeaders.Clear;
  for i := 0 to CustomHeaders.Count - 1 do begin
    FResponseInfo.CustomHeaders.Values[CustomHeaders.Names[i]] :=
      CustomHeaders.Values[CustomHeaders.Names[i]];
  end;
end;

end.
