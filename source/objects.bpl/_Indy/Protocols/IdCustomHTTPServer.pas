{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13778: IdCustomHTTPServer.pas
{
{   Rev 1.34    10/26/2004 8:59:32 PM  JPMugaas
{ Updated with new TStrings references for more portability.
}
{
{   Rev 1.33    2004.05.20 11:37:12 AM  czhower
{ IdStreamVCL
}
{
{   Rev 1.32    5/6/04 3:19:00 PM  RLebeau
{ Added extra comments
}
{
{   Rev 1.31    2004.04.18 12:52:06 AM  czhower
{ Big bug fix with server disconnect and several other bug fixed that I found
{ along the way.
}
{
{   Rev 1.30    2004.04.08 1:46:32 AM  czhower
{ Small Optimizations
}
{
{   Rev 1.29    7/4/2004 4:10:44 PM  SGrobety
{ Small fix to keep it synched with the IOHandler properties
}
{
{   Rev 1.28    6/4/2004 5:15:02 PM  SGrobety
{ Implemented MaximumHeaderLineCount property (default to 1024)
}
{
{   Rev 1.27    2004.02.03 5:45:02 PM  czhower
{ Name changes
}
{
{   Rev 1.26    1/27/2004 3:58:52 PM  SPerry
{ StringStream ->IdStringStream
}
{
{   Rev 1.25    2004.01.22 5:58:58 PM  czhower
{ IdCriticalSection
}
{
{   Rev 1.24    1/22/2004 8:26:28 AM  JPMugaas
{ Ansi* calls changed.
}
{
{   Rev 1.23    1/21/2004 1:57:30 PM  JPMugaas
{ InitComponent
}
{
{   Rev 1.22    21.1.2004 �. 13:22:18  DBondzhev
{ Fix for Dccil bug
}
{
{   Rev 1.21    10/25/2003 06:51:44 AM  JPMugaas
{ Updated for new API changes and tried to restore some functionality.  
}
{
{   Rev 1.20    2003.10.24 10:43:02 AM  czhower
{ TIdSTream to dos
}
{
    Rev 1.19    10/19/2003 11:49:40 AM  DSiders
  Added localization comments.
}
{
    Rev 1.18    10/17/2003 12:05:40 AM  DSiders
  Corrected spelling error in resource string.
}
{
{   Rev 1.17    10/15/2003 11:10:16 PM  GGrieve
{ DotNet changes
}
{
{   Rev 1.16    2003.10.12 3:37:58 PM  czhower
{ Now compiles again.
}
{
    Rev 1.15    6/24/2003 11:38:50 AM  BGooijen
  Fixed ssl support
}
{
    Rev 1.14    6/18/2003 11:44:04 PM  BGooijen
  Moved ServeFile and SmartServeFile to TIdHTTPResponseInfo.
  Added TIdHTTPResponseInfo.HTTPServer field
}
{
{   Rev 1.13    05.6.2003 �. 11:11:12  DBondzhev
{ Socket exceptions should  not be stopped after DoCommandGet.
}
{
    Rev 1.12    4/9/2003 9:38:40 PM  BGooijen
  fixed av on FSessionList.PurgeStaleSessions(Terminated);
}
{
{   Rev 1.11    20/3/2003 19:49:24  GGrieve
{ Define SmartServeFile
}
{
    Rev 1.10    3/13/2003 10:21:14 AM  BGooijen
  Changed result of function .execute
}
{
    Rev 1.9    2/25/2003 10:43:36 AM  BGooijen
  removed unneeded assignment
}
{
    Rev 1.8    2/25/2003 10:38:46 AM  BGooijen
  The Serversoftware wasn't send to the client, because of duplicate properties
  (.Server and .ServerSoftware).
}
{
{   Rev 1.7    2/24/2003 08:20:50 PM  JPMugaas
{ Now should compile with new code.
}
{
{   Rev 1.6    11.2.2003 13:36:14  TPrami
{ - Fixed URL get paremeter handling (SeeRFC 1866 section 8.2.1.)
}
{
{   Rev 1.5    1/17/2003 05:35:20 PM  JPMugaas
{ Now compiles with new design.
}
{
{   Rev 1.4    1-1-2003 20:12:44  BGooijen
{ Changed to support the new TIdContext class
}
{
{   Rev 1.3    12-15-2002 13:08:38  BGooijen
{ simplified TimeStampInterval
}
{
{   Rev 1.2    6/12/2002 10:59:34 AM  SGrobety    Version: 1.1
{ Made to work with Indy 10
}
{
{   Rev 1.0    21/11/2002 12:41:04 PM  SGrobety    Version: Indy 10
}
{
{   Rev 1.0    11/14/2002 02:16:32 PM  JPMugaas
}
unit IdCustomHTTPServer;

interface

uses
  Classes,
  IdAssignedNumbers,
  IdContext, IdException,
  IdGlobal, IdStack,
  IdExceptionCore, IdGlobalProtocols, IdHeaderList, IdTCPServer, IdTCPConnection, IdThread, IdCookie,
  IdHTTPHeaderInfo, IdStackConsts, IdTStrings,
  SysUtils;

type
  // Enums
  THTTPCommandType = (hcUnknown, hcHEAD, hcGET, hcPOST, hcDELETE, hcPUT, hcTRACE, hcOPTION);

const
  Id_TId_HTTPServer_KeepAlive = false;
  Id_TId_HTTPServer_ParseParams = True;
  Id_TId_HTTPServer_SessionState = False;
  {This probably should be something else but I don't know what
  I have fixed a problem which was caused by a timeout of 0 so I am extremely
  suspecious of this}      // S.G. 5/12/2002: <--- who wrote this note and what is it refering to ?
  Id_TId_HTTPSessionTimeOut = 0;
  Id_TId_HTTPAutoStartSession = False;

  Id_TId_HTTPMaximumHeaderLineCount = 1024;

  GResponseNo = 200;
  GFContentLength = -1;
  GServerSoftware = gsIdProductName + '/' + gsIdVersion;    {Do not Localize}
  GContentType = 'text/html';    {Do not Localize}
  GSessionIDCookie = 'IDHTTPSESSIONID';    {Do not Localize}
  HTTPRequestStrings: array[0..ord(high(THTTPCommandType))] of string = ('UNKNOWN', 'HEAD','GET','POST','DELETE','PUT','TRACE', 'OPTIONS'); {do not localize}

type
  // Forwards
  TIdHTTPSession = Class;
  TIdHTTPCustomSessionList = Class;
  TIdHTTPRequestInfo = Class;
  TIdHTTPResponseInfo = Class;
  TIdCustomHTTPServer = Class;
  //events
  TOnSessionEndEvent = procedure(Sender: TIdHTTPSession) of object;
  TOnSessionStartEvent = procedure(Sender: TIdHTTPSession) of object;
  TOnCreateSession = procedure(ASender:TIdContext;
   var VHTTPSession: TIdHTTPSession) of object;
  TOnCreatePostStream = procedure(AContext: TIdContext;
   var VPostStream: TStream) of object;
  TIdHTTPGetEvent = procedure(AContext:TIdContext;
   ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo) of object;
  TIdHTTPOtherEvent = procedure(AContext: TIdContext;
   const asCommand, asData, asVersion: string) of object;
  TIdHTTPInvalidSessionEvent = procedure(AContext: TIdContext;
    ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
    var VContinueProcessing: Boolean; const AInvalidSessionID: String) of object;
  //objects
  EIdHTTPServerError = class(EIdException);
  EIdHTTPHeaderAlreadyWritten = class(EIdHTTPServerError);
  EIdHTTPErrorParsingCommand = class(EIdHTTPServerError);
  EIdHTTPUnsupportedAuthorisationScheme = class(EIdHTTPServerError);
  EIdHTTPCannotSwitchSessionStateWhenActive = class(EIdHTTPServerError);

  TIdHTTPRequestInfo = class(TIdRequestHeaderInfo)
  protected
    FAuthExists: Boolean;
    FCookies: TIdServerCookies;
    FParams: TIdStrings;
    FPostStream: TStream;
    FRawHTTPCommand: string;
    FRemoteIP: string;
    FSession: TIdHTTPSession;
    FDocument: string;
    FCommand: string;
    FVersion: string;
    FAuthUsername: string;
    FAuthPassword: string;
    FUnparsedParams: string;
    FQueryParams: string;
    FFormParams: string;
    FCommandType: THTTPCommandType;
    //
    procedure DecodeAndSetParams(const AValue: String); virtual;
    procedure DecodeCommand; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Session: TIdHTTPSession read FSession;
    //
    property AuthExists: Boolean read FAuthExists;
    property AuthPassword: string read FAuthPassword;
    property AuthUsername: string read FAuthUsername;
    property Command: string read FCommand;
    property CommandType: THTTPCommandType read FCommandType;
    property Cookies: TIdServerCookies read FCookies;
    property Document: string read FDocument write FDocument; // writable for isapi compatibility. Use with care
    property Params: TIdStrings read FParams;
    property PostStream: TStream read FPostStream write FPostStream;
    property RawHTTPCommand: string read FRawHTTPCommand;
    property RemoteIP: String read FRemoteIP;
    property UnparsedParams: string read FUnparsedParams write FUnparsedParams; // writable for isapi compatibility. Use with care
    property FormParams: string read FFormParams write FFormParams; // writable for isapi compatibility. Use with care
    property QueryParams: string read FQueryParams write FQueryParams; // writable for isapi compatibility. Use with care
    property Version: string read FVersion;
  end;

  TIdHTTPResponseInfo = class(TIdResponseHeaderInfo)
  protected
    FAuthRealm: string;
    FContentType: string;
    FConnection: TIdTCPConnection;
    FResponseNo: Integer;
    FCookies: TIdServerCookies;
    FContentStream: TStream;
    FContentText: string;
    FCloseConnection: Boolean;
    FFreeContentStream: Boolean;
    FHeaderHasBeenWritten: Boolean;
    FResponseText: string;
    FHTTPServer: TIdCustomHTTPServer;
    FSession: TIdHTTPSession;
    //
    procedure ReleaseContentStream;
    procedure SetCookies(const AValue: TIdServerCookies);
    procedure SetHeaders; override;
    procedure SetResponseNo(const AValue: Integer);
    procedure SetCloseConnection(const Value: Boolean);
  public
    function GetServer: string;
    procedure SetServer(const Value: string);
  public
    procedure CloseSession;
    constructor Create(AConnection: TIdTCPConnection; AServer: TIdCustomHTTPServer ); reintroduce;
    destructor Destroy; override;
    procedure Redirect(const AURL: string);
    procedure WriteHeader;
    procedure WriteContent;
    //
    function ServeFile(AContext:TIdContext; aFile: TFileName): cardinal; virtual;
    function SmartServeFile(AContext:TIdContext; ARequestInfo: TIdHTTPRequestInfo; aFile: TFileName): cardinal;
    //
    property AuthRealm: string read FAuthRealm write FAuthRealm;
    property CloseConnection: Boolean read FCloseConnection write SetCloseConnection;
    property ContentStream: TStream read FContentStream write FContentStream;
    property ContentText: string read FContentText write FContentText;
    property Cookies: TIdServerCookies read FCookies write SetCookies;
    property FreeContentStream: Boolean read FFreeContentStream write FFreeContentStream;
    // writable for isapi compatibility. Use with care
    property HeaderHasBeenWritten: Boolean read FHeaderHasBeenWritten write FHeaderHasBeenWritten;
    property ResponseNo: Integer read FResponseNo write SetResponseNo;
    property ResponseText: String read FResponseText write FResponseText;
    property HTTPServer: TIdCustomHTTPServer read FHTTPServer;
    property ServerSoftware: string read GetServer write SetServer;
    property Session: TIdHTTPSession read FSession;
  end;

  TIdHTTPSession = Class(TObject)
  protected
    FContent: TIdStrings;
    FLastTimeStamp: TDateTime;
    FLock: TIdCriticalSection;
    FOwner: TIdHTTPCustomSessionList;
    FSessionID: string;
    FRemoteHost: string;
    //
    procedure SetContent(const Value: TIdStrings);
    function GetContent: TIdStrings;
    function IsSessionStale: boolean; virtual;
    procedure DoSessionEnd; virtual;
  public
    constructor Create(AOwner: TIdHTTPCustomSessionList); virtual;
    constructor CreateInitialized(AOwner: TIdHTTPCustomSessionList; const SessionID,
                                  RemoteIP: string); virtual;
    destructor Destroy; override;
    procedure Lock;
    procedure Unlock;
    //
    property Content: TIdStrings read GetContent write SetContent;
    property LastTimeStamp: TDateTime read FLastTimeStamp;
    property RemoteHost: string read FRemoteHost;
    property SessionID: String read FSessionID;
  end;

  TIdHTTPCustomSessionList = class(TComponent)
  private
    FSessionTimeout: Integer;
    FOnSessionEnd: TOnSessionEndEvent;
    FOnSessionStart: TOnSessionStartEvent;
  protected
    // remove a session from the session list. Called by the session on "Free"
    procedure RemoveSession(Session: TIdHTTPSession); virtual; abstract;
  public
    procedure Clear; virtual; abstract;
    procedure PurgeStaleSessions(PurgeAll: Boolean = false); virtual; abstract;
    function CreateUniqueSession(const RemoteIP: String): TIdHTTPSession; virtual; abstract;
    function CreateSession(const RemoteIP, SessionID: String): TIdHTTPSession; virtual; abstract;
    function GetSession(const SessionID, RemoteIP: string): TIdHTTPSession; virtual; abstract;
    procedure Add(ASession: TIdHTTPSession); virtual; Abstract;
  published
    property SessionTimeout: Integer read FSessionTimeout write FSessionTimeout;
    property OnSessionEnd: TOnSessionEndEvent read FOnSessionEnd write FOnSessionEnd;
    property OnSessionStart: TOnSessionStartEvent read FOnSessionStart write FOnSessionStart;
  end;

  TIdCustomHTTPServer = class(TIdTCPServer)
  protected
    FAutoStartSession: Boolean;
    FKeepAlive: Boolean;
    FParseParams: Boolean;
    FServerSoftware: string;
    FMIMETable: TIdMimeTable;
    FSessionList: TIdHTTPCustomSessionList;
    FSessionState: Boolean;
    FSessionTimeOut: Integer;
    FOkToProcessCommand : Boolean; // allow descendents to process requests without requiring FOnCommandGet to be assigned
    FOnCreatePostStream: TOnCreatePostStream;
    FOnCreateSession: TOnCreateSession;
    FOnInvalidSession: TIdHTTPInvalidSessionEvent;
    FOnSessionEnd: TOnSessionEndEvent;
    FOnSessionStart: TOnSessionStartEvent;
    FOnCommandGet: TIdHTTPGetEvent;
    FOnCommandOther: TIdHTTPOtherEvent;
    FSessionCleanupThread: TIdThread;
    FMaximumHeaderLineCount: Integer;
    //
    procedure DoOnCreateSession(AContext:TIdContext; var VNewSession: TIdHTTPSession); virtual;
    procedure DoInvalidSession(AContext:TIdContext;
     ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
     var VContinueProcessing: Boolean; const AInvalidSessionID: String); virtual;
    procedure DoCommandOther(AContext:TIdContext; const asCommand, asData
     , asVersion: string); virtual;
    procedure DoCommandGet(AContext:TIdContext;
     ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
     virtual;
    procedure CreatePostStream(ASender: TIdContext; var VPostStream: TStream); virtual;
    procedure DoConnect(AContext: TIdContext); override;
    procedure DoCreatePostStream(ASender: TIdContext;
     var VPostStream: TStream);
    function DoExecute(AContext:TIdContext): Boolean; override;
    procedure SetActive(AValue: Boolean); override;
    procedure SetSessionState(const Value: Boolean);
    function GetSessionFromCookie(AContext:TIdContext;
     AHTTPrequest: TIdHTTPRequestInfo; AHTTPResponse: TIdHTTPResponseInfo;
     var VContinueProcessing: Boolean): TIdHTTPSession;
    procedure InitComponent; override;
    { to be published in TIdHTTPServer}
    property OnCreatePostStream: TOnCreatePostStream read FOnCreatePostStream
     write FOnCreatePostStream;
    property OnCommandGet: TIdHTTPGetEvent read FOnCommandGet
     write FOnCommandGet;
  public
    function CreateSession(AContext:TIdContext;
     HTTPResponse: TIdHTTPResponseInfo;
     HTTPRequest: TIdHTTPRequestInfo): TIdHTTPSession;
    destructor Destroy; override;
    function EndSession(const SessionName: string): boolean;
    //
    property MIMETable: TIdMimeTable read FMIMETable;
    property SessionList: TIdHTTPCustomSessionList read FSessionList;
  published
    property MaximumHeaderLineCount: Integer read FMaximumHeaderLineCount write FMaximumHeaderLineCount default Id_TId_HTTPMaximumHeaderLineCount;
    property AutoStartSession: boolean read FAutoStartSession write FAutoStartSession default Id_TId_HTTPAutoStartSession;
    property DefaultPort default IdPORT_HTTP;
    property OnInvalidSession: TIdHTTPInvalidSessionEvent read FOnInvalidSession
     write FOnInvalidSession;
    property OnSessionStart: TOnSessionStartEvent read FOnSessionStart
     write FOnSessionStart;
    property OnSessionEnd: TOnSessionEndEvent read FOnSessionEnd
     write FOnSessionEnd;
    property OnCreateSession: TOnCreateSession read FOnCreateSession
     write FOnCreateSession;
    property KeepAlive: Boolean read FKeepAlive write FKeepAlive
     default Id_TId_HTTPServer_KeepAlive;
    property ParseParams: boolean read FParseParams write FParseParams
     default Id_TId_HTTPServer_ParseParams;
    property ServerSoftware: string read FServerSoftware write FServerSoftware;
    property SessionState: Boolean read FSessionState write SetSessionState
     default Id_TId_HTTPServer_SessionState;
    property SessionTimeOut: Integer read FSessionTimeOut write FSessionTimeOut
     default Id_TId_HTTPSessionTimeOut;
    property OnCommandOther: TIdHTTPOtherEvent read FOnCommandOther
     write FOnCommandOther;
  end;
  TIdHTTPDefaultSessionList = Class(TIdHTTPCustomSessionList)
  protected
    SessionList: TThreadList;
    procedure RemoveSession(Session: TIdHTTPSession); override;
    // remove a session surgically when list already locked down (prevent deadlock)
    procedure RemoveSessionFromLockedList(AIndex: Integer; ALockedSessionList: TList);
  public
    Constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Add(ASession: TIdHTTPSession); override;
    procedure PurgeStaleSessions(PurgeAll: Boolean = false); override;
    function CreateUniqueSession(const RemoteIP: String): TIdHTTPSession; override;
    function CreateSession(const RemoteIP, SessionID: String): TIdHTTPSession; override;
    function GetSession(const SessionID, RemoteIP: string): TIdHTTPSession; override;
  end;

implementation

uses
  IdCoderMIME, IdResourceStringsProtocols, IdURI, IdIOHandlerSocket, IdSSL, IdStreamVCL;

const
  SessionCapacity = 128;

  // Calculate the number of MS between two TimeStamps

function TimeStampInterval(const AStartStamp, AEndStamp: TDateTime): integer;
begin
  result := trunc((AEndStamp - AStartStamp) * MSecsPerDay);
end;

{ //(Bas Gooijen) was:
function TimeStampInterval(StartStamp, EndStamp: TDateTime): integer;
var
  days: Integer;
  hour, min, s, ms: Word;
begin
  days := Trunc(EndStamp - StartStamp); // whole days
  DecodeTime(EndStamp - StartStamp, hour, min, s, ms);
  result := (((days * 24 + hour) * 60 + min) * 60 + s) * 1000 + ms;
end;
}


function GetRandomString(NumChar: cardinal): string;
const
  CharMap='qwertzuiopasdfghjklyxcvbnmQWERTZUIOPASDFGHJKLYXCVBNM1234567890';    {Do not Localize}
var
  i: integer;
  MaxChar: cardinal;
begin
  randomize;
  MaxChar := length(CharMap) - 1;
  for i := 1 to NumChar do
  begin
    // Add one because CharMap is 1-based
    Result := result + CharMap[Random(maxChar) + 1];
  end;
end;

type
  TIdHTTPSessionCleanerThread = Class(TIdThread)
  protected
    FSessionList: TIdHTTPCustomSessionList;
  public
    constructor Create(SessionList: TIdHTTPCustomSessionList); reintroduce;
    procedure AfterRun; override;
    procedure Run; override;
  end; // class

{ TIdCustomHTTPServer }

procedure TIdCustomHTTPServer.InitComponent;
begin
  inherited;
  FSessionState := Id_TId_HTTPServer_SessionState;
  DefaultPort := IdPORT_HTTP;
  ParseParams := Id_TId_HTTPServer_ParseParams;
  FSessionList := TIdHTTPDefaultSessionList.Create(Self);
  FMIMETable := TIdMimeTable.Create(True);
  FSessionTimeOut := Id_TId_HTTPSessionTimeOut;
  FAutoStartSession := Id_TId_HTTPAutoStartSession;
  FKeepAlive := Id_TId_HTTPServer_KeepAlive;
  FOkToProcessCommand := false;
  FMaximumHeaderLineCount := Id_TId_HTTPMaximumHeaderLineCount;
end;

procedure TIdCustomHTTPServer.DoOnCreateSession(AContext: TIdContext; Var VNewSession: TIdHTTPSession);
begin
  VNewSession := nil;
  if Assigned(FOnCreateSession) then
  begin
    OnCreateSession(AContext, VNewSession);
  end;
end;

function TIdCustomHTTPServer.CreateSession(AContext: TIdContext; HTTPResponse: TIdHTTPResponseInfo;
  HTTPRequest: TIdHTTPRequestInfo): TIdHTTPSession;
begin
  if SessionState then begin
    DoOnCreateSession(AContext, Result);
    if not Assigned(result) then
    begin
      result := FSessionList.CreateUniqueSession(HTTPRequest.RemoteIP);
    end
    else begin
      FSessionList.Add(result);
    end;

    with HTTPResponse.Cookies.Add do
    begin
      CookieName := GSessionIDCookie;
      Value := result.SessionID;
      Path := '/';    {Do not Localize}
      MaxAge := -1; // By default the cookies wil be valid until the user has closed his browser window.
      // MaxAge := SessionTimeOut div 1000;
    end;
    HTTPResponse.FSession := result;
    HTTPRequest.FSession := result;
  end else begin
    result := nil;
  end;
end;

destructor TIdCustomHTTPServer.Destroy;
begin
  Active := false; // Set Active to false in order to cloase all active sessions.

  FreeAndNil(FMIMETable);
  FreeAndNil(FSessionList);
  inherited Destroy;
end;

procedure TIdCustomHTTPServer.DoCommandGet(AContext:TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if Assigned(FOnCommandGet) then begin
    FOnCommandGet(AContext, ARequestInfo, AResponseInfo);
  end;
end;

procedure TIdCustomHTTPServer.DoCommandOther(AContext:TIdContext;
  const asCommand, asData, asVersion: string);
begin
  if Assigned(FOnCommandOther) then begin
    OnCommandOther(AContext, asCommand, asData, asVersion);
  end;
end;

procedure TIdCustomHTTPServer.DoConnect(AContext: TIdContext);
begin
  if AContext.Connection.IOHandler is TIdSSLIOHandlerSocketBase then begin
    TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough:=false;
  end;
  inherited DoConnect(AContext);
end;

function TIdCustomHTTPServer.DoExecute(AContext:TIdContext): boolean;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LResponseInfo: TIdHTTPResponseInfo;
  LP : TIdStreamVCL;

  procedure ReadCookiesFromRequestHeader;
  var
    LRawCookies: TIdStringList;
    i: Integer;
    S: String;
  begin
    LRawCookies := TIdStringList.Create; try
      LRequestInfo.RawHeaders.Extract('cookie', LRawCookies);    {Do not Localize}
      for i := 0 to LRawCookies.Count -1 do begin
        S := LRawCookies[i];
        while IndyPos(';', S) > 0 do begin    {Do not Localize}
          LRequestInfo.Cookies.AddSrcCookie(Fetch(S, ';'));    {Do not Localize}
          S := Trim(S);
        end;
        if S <> '' then
          LRequestInfo.Cookies.AddSrcCookie(S);
      end;
    finally LRawCookies.Free; end;
  end;

var
  i: integer;
  s, sInputLine, sCmd, sVersion: String;
  LURI: TIdURI;
  LImplicitPostStream: Boolean;
  LRawHTTPCommand: string;
  ContinueProcessing: Boolean;
  LCloseConnection: Boolean;
begin
  ContinueProcessing := True;
  Result := False;
  LCloseConnection := not KeepAlive;
  try
    try repeat
      with AContext.Connection do begin
        sInputLine := IOHandler.ReadLn;
        LRawHTTPCommand := sInputLine;
        i := RPos(' ', sInputLine, -1);    {Do not Localize}
        if i = 0 then begin
          raise EIdHTTPErrorParsingCommand.Create(RSHTTPErrorParsingCommand);
        end;
        sVersion := Copy(sInputLine, i + 1, MaxInt);
        SetLength(sInputLine, i - 1);
        {TODO Check for 1.0 only at this point}
        sCmd := UpperCase(Fetch(sInputLine, ' '));    {Do not Localize}

        // These essentially all "retrieve" so they are all "Get"s
        if ((sCmd = 'GET') or (sCmd = 'POST')    {Do not Localize}
         or (sCmd = 'HEAD')) and (Assigned(OnCommandGet) or FOkToProcessCommand) then begin    {Do not Localize}
          LRequestInfo := TIdHTTPRequestInfo.Create; try
            LRequestInfo.FRawHTTPCommand := LRawHTTPCommand;
            LRequestInfo.FRemoteIP := (AContext.Connection.IOHandler as TIdIOHandlerSocket).Binding.PeerIP;
            LRequestInfo.FCommand := sCmd;
            // Retrieve the HTTP header
            LRequestInfo.RawHeaders.Clear;
            // S.G. 6/4/2004: Set the maximum number of lines that will be catured
            // S.G. 6/4/2004: to prevent a remote resource starvation DOS
            IOHandler.MaxCapturedLines := MaximumHeaderLineCount;
            IOHandler.Capture(LRequestInfo.RawHeaders, '');    {Do not Localize}
            LRequestInfo.ProcessHeaders;
            // Grab Params so we can parse them
            // POSTed data - may exist with GETs also. With GETs, the action
            // params from the form element will be posted
            // TODO: Rune this is the area that needs fixed. Ive hacked it for now
            // Get data can exists with POSTs, but can POST data exist with GETs?
            // If only the first, the solution is easy. If both - need more
            // investigation.

            // i := StrToIntDef(LRequestInfo.Headers.Values['Content-Length'], -1);    {Do not Localize}
            LRequestInfo.PostStream := nil;
            CreatePostStream(AContext, LRequestInfo.FPostStream);
            LImplicitPostStream := LRequestInfo.PostStream = nil;
            try
              if LImplicitPostStream then begin
                LRequestInfo.PostStream := TIdStringStream.Create('');    {Do not Localize}
              end;
              LP := TIdStreamVCL.Create(LRequestInfo.PostStream);
              try
                if LRequestInfo.ContentLength > 0 then begin
                  AContext.Connection.IOHandler.ReadStream(LP
                  , LRequestInfo.ContentLength);
                end else begin
                  if sCmd = 'POST' then begin    {Do not Localize}
                    if not LRequestInfo.HasContentLength then
                     AContext.Connection.IOHandler.ReadStream(LP, -1, True);
                    {LResponseInfo := TIdHTTPResponseInfo.Create(AThread.Connection);
                    try
                      LResponseInfo.SetResponseNo(406);
                      LResponseInfo.WriteHeader;
                      LResponseInfo.WriteContent;
                      raise EIdClosedSocket.Create('');  // Force the server to close the connection and to free all associated resources
                    finally
                      LResponseInfo.Free;
                    end;
                    {if LowerCase(LRequestInfo.ContentType) = 'application/x-www-form-urlencoded' then begin
                      S := ReadLn;
                      LRequestInfo.PostStream.Write(S[1], Length(S));
                    end
                    else}
                  end;
                end;
              finally
                FreeAndNil(LP);
              end;
              if LRequestInfo.PostStream is TIdStringStream then begin
                LRequestInfo.FormParams := TIdStringStream(LRequestInfo.PostStream).DataString;
                LRequestInfo.UnparsedParams := LRequestInfo.FormParams;
              end;
            finally
              if LImplicitPostStream then begin
                FreeAndNil(LRequestInfo.FPostStream);
              end;
            end;
            // GET data - may exist with POSTs also
            LRequestInfo.QueryParams := sInputLine;
            sInputLine := Fetch(LRequestInfo.FQueryParams, '?');    {Do not Localize}
            // glue together parameters passed in the URL and those
            //
            if Length(LRequestInfo.QueryParams) > 0 then begin
              if Length(LRequestInfo.UnparsedParams) = 0 then begin
                LRequestInfo.FUnparsedParams := LRequestInfo.QueryParams;
              end else begin
                LRequestInfo.FUnparsedParams := LRequestInfo.UnparsedParams + '&'  {Do not Localize}
                 + LRequestInfo.QueryParams;
              end;
            end;
            // Parse Params
            if ParseParams then begin
              if (LowerCase(LRequestInfo.ContentType) = 'application/x-www-form-urlencoded') then begin    {Do not Localize}
                LRequestInfo.DecodeAndSetParams(LRequestInfo.UnparsedParams);
              end
              else begin
                // Parse only query params when content type is not 'application/x-www-form-urlencoded'    {Do not Localize}
                LRequestInfo.DecodeAndSetParams(LRequestInfo.QueryParams);
              end;
            end;
            // Cookies
            ReadCookiesFromRequestHeader;
            // Host
            // LRequestInfo.FHost := LRequestInfo.Headers.Values['host'];    {Do not Localize}
            LRequestInfo.FVersion := sVersion;
            // Parse the document input line
            if sInputLine = '*' then begin    {Do not Localize}
              LRequestInfo.FDocument := '*';    {Do not Localize}
            end else begin
              LURI := TIdURI.Create(sInputLine);
              // SG 29/11/01: Per request of Doychin
              // Try to fill the "host" parameter
              LRequestInfo.FDocument := TIdURI.URLDecode(LURI.Path) + TIdURI.URLDecode(LURI.Document) + LURI.Params;
              if (Length(LURI.Host) > 0) and (Length(LRequestInfo.FHost) = 0) then begin
                LRequestInfo.FHost := LURI.Host;
              end;
              LURI.Free;
            end;

            s := LRequestInfo.RawHeaders.Values['Authorization'];    {Do not Localize}
            LRequestInfo.FAuthExists := Length(s) > 0;
            if LRequestInfo.AuthExists then begin
              if TextIsSame(Fetch(s, ' '), 'Basic') then begin    {Do not Localize}
                s := TIdDecoderMIME.DecodeString(s);
                LRequestInfo.FAuthUsername := Fetch(s, ':');    {Do not Localize}
                LRequestInfo.FAuthPassword := s;
              end else begin
                raise EIdHTTPUnsupportedAuthorisationScheme.Create(
                 RSHTTPUnsupportedAuthorisationScheme);
              end;
            end;
            LResponseInfo := TIdHTTPResponseInfo.Create(AContext.Connection, Self); try
              LResponseInfo.CloseConnection := not (FKeepAlive and
                TextIsSame(LRequestInfo.Connection, 'Keep-alive')); {Do not Localize}
              // Session management
              GetSessionFromCookie(AContext, LRequestInfo, LResponseInfo
               , ContinueProcessing);
              // SG 05.07.99
              // Set the ServerSoftware string to what it's supposed to be.    {Do not Localize}
              if Length(Trim(ServerSoftware)) > 0  then begin
                LResponseInfo.ServerSoftware := ServerSoftware;
              end;
              try
                if ContinueProcessing then begin
                  DoCommandGet(AContext, LRequestInfo, LResponseInfo);
                end;
              except
                on E: EIdSocketError do begin // don't stop socket exceptions
                  raise;
                end;
                on E: Exception do begin
                  LResponseInfo.ResponseNo := 500;
                  LResponseInfo.ContentText := E.Message;
                end;
              end;
              // Write even though WriteContent will, may be a redirect or other
              if not LResponseInfo.HeaderHasBeenWritten then begin
                LResponseInfo.WriteHeader;
              end;
              // Always check ContentText first
              if (Length(LResponseInfo.ContentText) > 0)
               or Assigned(LResponseInfo.ContentStream) then begin
                LResponseInfo.WriteContent;
              end;
            finally
              LCloseConnection := LResponseInfo.CloseConnection;
              FreeAndNil(LResponseInfo);
            end;
          finally FreeAndNil(LRequestInfo); end;
        end else begin
          DoCommandOther(AContext, sCmd, sInputLine, sVersion);
        end;
      end;
    until LCloseConnection;
    except
      on E: EIdSocketError do begin
        if E.LastError <> Id_WSAECONNRESET then begin
          raise;
        end;
      end;
      on E: EIdClosedSocket do begin
        AContext.Connection.Disconnect;
      end;
    end;
  finally AContext.Connection.Disconnect(False); end;
end;

procedure TIdCustomHTTPServer.DoInvalidSession(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
  var VContinueProcessing: Boolean; const AInvalidSessionID: String);
begin
  if Assigned(FOnInvalidSession) then begin
    FOnInvalidSession(AContext, ARequestInfo, AResponseInfo, VContinueProcessing, AInvalidSessionID)
  end;
end;

function TIdCustomHTTPServer.EndSession(const SessionName: string): boolean;
var
  ASession: TIdHTTPSession;
begin
  ASession := SessionList.GetSession(SessionName, '');    {Do not Localize}
  result := Assigned(ASession);
  if result then
  begin
    ASession.free;
  end;
end;

function TIdCustomHTTPServer.GetSessionFromCookie(AContext: TIdContext;
  AHTTPRequest: TIdHTTPRequestInfo; AHTTPResponse: TIdHTTPResponseInfo;
  var VContinueProcessing: Boolean): TIdHTTPSession;
var
  CurrentCookieIndex: Integer;
  SessionId: String;
begin
  Result := nil;
  VContinueProcessing := True;
  if SessionState then
  begin
    CurrentCookieIndex := AHTTPRequest.Cookies.GetCookieIndex(0, GSessionIDCookie);
    while (result = nil) and (CurrentCookieIndex >= 0) do
    begin
      SessionId := AHTTPRequest.Cookies.Items[CurrentCookieIndex].Value;
      Result := FSessionList.GetSession(SessionID, AHTTPrequest.RemoteIP);
      if not Assigned(Result) then
        DoInvalidSession(AContext, AHTTPRequest, AHTTPResponse, VContinueProcessing, SessionId);
      Inc(CurrentCookieIndex);
      CurrentCookieIndex := AHTTPRequest.Cookies.GetCookieIndex(CurrentCookieIndex, GSessionIDCookie);
    end;    { while }
    // check if a session was returned. If not and if AutoStartSession is set to
    // true, Create a new session
    if (FAutoStartSession and VContinueProcessing) and (result = nil) then
    begin
      Result := CreateSession(AContext, AHTTPResponse, AHTTPrequest);
    end;
  end;
  AHTTPRequest.FSession := result;
  AHTTPResponse.FSession := result;
end;

procedure TIdCustomHTTPServer.SetActive(AValue: Boolean);
begin
  if (not (csDesigning in ComponentState)) and (FActive <> AValue)
      and (not (csLoading in ComponentState)) then begin
    if AValue then
    begin
      // starting server
      // set the session timeout and options
      if FSessionTimeOut <> 0 then
        FSessionList.FSessionTimeout := FSessionTimeOut
      else
        FSessionState := false;
      // Session events
      FSessionList.OnSessionStart := FOnSessionStart;
      FSessionList.OnSessionEnd := FOnSessionEnd;
      // If session handeling is enabled, create the housekeeper thread
      if SessionState then
        FSessionCleanupThread := TIdHTTPSessionCleanerThread.Create(FSessionList);
    end
    else
    begin
      // Stopping server
      // Boost the clear thread priority to give it a good chance to terminate
      if assigned(FSessionCleanupThread) then begin
        SetThreadPriority(FSessionCleanupThread, tpNormal);
        FSessionCleanupThread.TerminateAndWaitFor;
        FreeAndNil(FSessionCleanupThread);
      end;
      FSessionCleanupThread := nil;
      FSessionList.Clear;
    end;
  end;
  inherited;
end;

procedure TIdCustomHTTPServer.SetSessionState(const Value: Boolean);
begin
  // ToDo: Add thread multiwrite protection here
  if (not ((csDesigning in ComponentState) or (csLoading in ComponentState))) and Active then
    raise EIdHTTPCannotSwitchSessionStateWhenActive.Create(RSHTTPCannotSwitchSessionStateWhenActive);
  FSessionState := Value;
end;

procedure TIdCustomHTTPServer.DoCreatePostStream(ASender: TIdContext;
  var VPostStream: TStream);
begin
  if Assigned(OnCreatePostStream) then begin
    OnCreatePostStream(ASender, VPostStream);
  end;
end;

procedure TIdCustomHTTPServer.CreatePostStream(ASender: TIdContext;
  var VPostStream: TStream);
begin
  DoCreatePostStream(ASender, VPostStream);
end;

{ TIdHTTPSession }

constructor TIdHTTPSession.Create(AOwner: TIdHTTPCustomSessionList);
begin
  inherited Create;

  FLock := TIdCriticalSection.Create;
  FContent := TIdStringList.Create;
  FOwner := AOwner;
  if assigned( AOwner ) then
  begin
    if assigned(AOwner.OnSessionStart) then
    begin
      AOwner.OnSessionStart(self);
    end;
  end;
end;

{TIdSession}
constructor TIdHTTPSession.CreateInitialized(AOwner: TIdHTTPCustomSessionList; const SessionID, RemoteIP: string);
begin
  inherited Create;

  FSessionID := SessionID;
  FRemoteHost := RemoteIP;
  FLastTimeStamp := Now;
  FLock := TIdCriticalSection.Create;
  FContent := TIdStringList.Create;
  FOwner := AOwner;
  if assigned( AOwner ) then
  begin
    if assigned(AOwner.OnSessionStart) then
    begin
      AOwner.OnSessionStart(self);
    end;
  end;
end;

destructor TIdHTTPSession.Destroy;
begin
// code added here should also be reflected in
// the TIdHTTPDefaultSessionList.RemoveSessionFromLockedList method
// Why? It calls this function and this code gets executed?
  DoSessionEnd;
  FContent.Free;
  FLock.Free;
  if Assigned(FOwner) then begin
    FOwner.RemoveSession(self);
  end;
  inherited;
end;

procedure TIdHTTPSession.DoSessionEnd;
begin
  if assigned(FOwner) and assigned(FOwner.FOnSessionEnd) then
    FOwner.FOnSessionEnd(self);
end;

function TIdHTTPSession.GetContent: TIdStrings;
begin
  result := FContent;
end;

function TIdHTTPSession.IsSessionStale: boolean;
begin
  result := TimeStampInterval(FLastTimeStamp, Now) > Integer(FOwner.SessionTimeout);
end;

procedure TIdHTTPSession.Lock;
begin
  // ToDo: Add session locking code here
  FLock.Enter;
end;

procedure TIdHTTPSession.SetContent(const Value: TIdStrings);
begin
  FContent.Assign(Value);
end;

procedure TIdHTTPSession.Unlock;
begin
  // ToDo: Add session unlocking code here
  FLock.Leave;
end;

{ TIdHTTPRequestInfo }

constructor TIdHTTPRequestInfo.Create;
begin
  inherited;
  FCommandType := hcUnknown;
  FCookies := TIdServerCookies.Create(self);
  FParams  := TIdStringList.Create;
  ContentLength := -1;
end;

procedure TIdHTTPRequestInfo.DecodeAndSetParams(const AValue: String);
var
  i, j : Integer;
  s: string;
begin
  // Convert special characters
  // ampersand '&' separates values    {Do not Localize}
  Params.BeginUpdate;
  try
    Params.Clear;
    i := 1;
    while i <= length(AValue) do
    begin
      j := i;
      while (j <= length(AValue)) and (AValue[j] <> '&') do
      begin
        inc(j);
      end;
      s := copy(AValue, i, j-i);
      // See RFC 1866 section 8.2.1. TP
      s := StringReplace(s, '+', ' ', [rfReplaceAll]);  {do not localize}
      Params.Add(TIdURI.URLDecode(s));
      i := j + 1;
    end;
  finally
    Params.EndUpdate;
  end;
end;

procedure TIdHTTPRequestInfo.DecodeCommand;
var
  I: Integer;
begin
  for I := low(HTTPRequestStrings) to High(HTTPRequestStrings) do    // Iterate
  begin
    if TextIsSame(Command, HTTPRequestStrings[i]) then
      FCommandType := THTTPCommandType(i);
  end;    // for
end;

destructor TIdHTTPRequestInfo.Destroy;
begin
  FreeAndNil(FCookies);
  FreeAndNil(FParams);
  FreeAndNil(FPostStream);
  inherited;
end;

{ TIdHTTPResponseInfo }

procedure TIdHTTPResponseInfo.CloseSession;
var
  i: Integer;
begin
  i := Cookies.GetCookieIndex(0, GSessionIDCookie);
  if i > -1 then begin
    Cookies.Delete(i);
  end;
  Cookies.Add.CookieName := GSessionIDCookie;
  FreeAndNil(FSession);
end;

constructor TIdHTTPResponseInfo.Create(AConnection: TIdTCPConnection; AServer: TIdCustomHTTPServer);
begin
  inherited Create;

  FFreeContentStream := True;
  ContentLength := GFContentLength;
  {Some clients may not support folded lines}
  RawHeaders.FoldLines := False;
  FCookies := TIdServerCookies.Create(self);
  {TODO Specify version - add a class method dummy that calls version}
  ServerSoftware := GServerSoftware;
  ContentType := GContentType;

  FConnection := AConnection;
  FHttpServer := AServer;
  ResponseNo := GResponseNo;
end;

destructor TIdHTTPResponseInfo.Destroy;
begin
  FreeAndNil(FCookies);
  ReleaseContentStream;
  inherited Destroy;
end;

procedure TIdHTTPResponseInfo.Redirect(const AURL: string);
begin
  ResponseNo := 302;
  Location := AURL;
end;

procedure TIdHTTPResponseInfo.ReleaseContentStream;
begin
  if FreeContentStream then begin
    FreeAndNil(FContentStream);
  end else begin
    FContentStream := nil;
  end;
end;

procedure TIdHTTPResponseInfo.SetCloseConnection(const Value: Boolean);
begin
  Connection := iif(Value, 'close', 'keep-alive');    {Do not Localize}
  FCloseConnection := Value;
end;

procedure TIdHTTPResponseInfo.SetCookies(const AValue: TIdServerCookies);
begin
  FCookies.Assign(AValue);
end;

procedure TIdHTTPResponseInfo.SetHeaders;
begin
  inherited SetHeaders;

  with RawHeaders do
  begin
    if Server <> '' then
      Values['Server'] := Server;    {Do not Localize}
    if ContentType <> '' then
      Values['Content-Type'] := ContentType;    {Do not Localize}
    if Location <> '' then
    begin
      Values['Location'] := Location;    {Do not Localize}
    end;
    if ContentLength > -1 then
    begin
      Values['Content-Length'] := IntToStr(ContentLength);    {Do not Localize}
    end;
    if FLastModified > 0 then
    begin
      Values['Last-Modified'] := DateTimeGMTToHttpStr(FLastModified); {do not localize}
    end;

    if AuthRealm <> '' then {Do not Localize}
    begin
      ResponseNo := 401;
      Values['WWW-Authenticate'] := 'Basic realm="' + AuthRealm + '"';    {Do not Localize}
      FContentText := '<HTML><BODY><B>' + IntToStr(ResponseNo) + ' ' + RSHTTPUnauthorized + '</B></BODY></HTML>';    {Do not Localize}
    end;
  end;
end;

procedure TIdHTTPResponseInfo.SetResponseNo(const AValue: Integer);
begin
  FResponseNo := AValue;
  case FResponseNo of
    100: ResponseText := RSHTTPContinue;
    // 2XX: Success
    200: ResponseText := RSHTTPOK;
    201: ResponseText := RSHTTPCreated;
    202: ResponseText := RSHTTPAccepted;
    203: ResponseText := RSHTTPNonAuthoritativeInformation;
    204: ResponseText := RSHTTPNoContent;
    205: ResponseText := RSHTTPResetContent;
    206: ResponseText := RSHTTPPartialContent;
    // 3XX: Redirections
    301: ResponseText := RSHTTPMovedPermanently;
    302: ResponseText := RSHTTPMovedTemporarily;
    303: ResponseText := RSHTTPSeeOther;
    304: ResponseText := RSHTTPNotModified;
    305: ResponseText := RSHTTPUseProxy;
    // 4XX Client Errors
    400: ResponseText := RSHTTPBadRequest;
    401: ResponseText := RSHTTPUnauthorized;
    403: ResponseText := RSHTTPForbidden;
    404: begin
      ResponseText := RSHTTPNotFound;
      // Close connection
      CloseConnection := true;
    end;
    405: ResponseText := RSHTTPMethodNotAllowed;
    406: ResponseText := RSHTTPNotAcceptable;
    407: ResponseText := RSHTTPProxyAuthenticationRequired;
    408: ResponseText := RSHTTPRequestTimeout;
    409: ResponseText := RSHTTPConflict;
    410: ResponseText := RSHTTPGone;
    411: ResponseText := RSHTTPLengthRequired;
    412: ResponseText := RSHTTPPreconditionFailed;
    413: ResponseText := RSHTTPRequestEntityToLong;
    414: ResponseText := RSHTTPRequestURITooLong;
    415: ResponseText := RSHTTPUnsupportedMediaType;
    // 5XX Server errors
    500: ResponseText := RSHTTPInternalServerError;
    501: ResponseText := RSHTTPNotImplemented;
    502: ResponseText := RSHTTPBadGateway;
    503: ResponseText := RSHTTPServiceUnavailable;
    504: ResponseText := RSHTTPGatewayTimeout;
    505: ResponseText := RSHTTPHTTPVersionNotSupported;
    else
      ResponseText := RSHTTPUnknownResponseCode;
  end;

  {if ResponseNo >= 400 then
    // Force COnnection closing when there is error during the request processing
    CloseConnection := true;
  end;}
end;


function TIdHTTPResponseInfo.ServeFile(AContext: TIdContext; AFile: TFileName): Cardinal;
begin
  if Length(ContentType) = 0 then begin
    ContentType := HTTPServer.MIMETable.GetFileMIMEType(aFile);
  end;
  ContentLength := FileSizeByName(aFile);
  WriteHeader;
  //TODO: allow TransferFileEnabled function
  result := AContext.Connection.IOHandler.WriteFile(aFile);
end;

function TIdHTTPResponseInfo.SmartServeFile(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; aFile: TFileName): cardinal;
var
  LFileDate : TDateTime;
  LReqDate : TDateTime;
begin
  LFileDate := FileDateToDateTime(FileAge(AFile));
  LReqDate := GMTToLocalDateTime(ARequestInfo.RawHeaders.Values['If-Modified-Since']);  {do not localize}

  // if the file date in the If-Modified-Since header is within 2 seconds of the
  // actual file, then we will send a 304. We don't use the ETag - offers nothing
  // over the file date for static files on windows. Linux: consider using iNode
  if (LReqDate <> 0) and (abs(LReqDate - LFileDate) < 2 * (1 / (24 * 60 * 60))) then
    begin
    ResponseNo := 304;
    result := 0;
    end
  else
    begin
    if Length(ContentType) = 0 then begin
      ContentType := HTTPServer.MIMETable.GetFileMIMEType(aFile);
    end;
    Date := LFileDate;
    ContentLength := FileSizeByName(aFile);
    WriteHeader;
    //TODO: allow TransferFileEnabled function
    result := AContext.Connection.IOHandler.WriteFile(aFile);
    end;
end;

procedure TIdHTTPResponseInfo.WriteContent;
var
  LS : TIdStreamVCL;
begin
  if not HeaderHasBeenWritten then begin
    WriteHeader;
  end;
  with FConnection do begin
    // Always check ContentText first
    if ContentText <> '' then begin
      IOHandler.Write(ContentText);
    end else if Assigned(ContentStream) then begin
      LS := TIdStreamVCL.Create(ContentStream);
      try
        IOHandler.Write(LS);
      finally
        FreeAndNil(LS);
      end;
    end else begin
      FConnection.IOHandler.WriteLn('<HTML><BODY><B>' + IntToStr(ResponseNo) + ' ' + ResponseText    {Do not Localize}
       + '</B></BODY></HTML>');    {Do not Localize}
    end;
    // Clear All - This signifies that WriteConent has been called.
    ContentText := '';    {Do not Localize}
    ReleaseContentStream;
  end;
end;

procedure TIdHTTPResponseInfo.WriteHeader;
var
  i: Integer;
begin
  EIdHTTPHeaderAlreadyWritten.IfTrue(HeaderHasBeenWritten, RSHTTPHeaderAlreadyWritten);
  FHeaderHasBeenWritten := True;

  if ContentLength = -1 then begin
    // Always check ContentText first
    if ContentText <> '' then begin
      ContentLength := Length(ContentText);
    end else if Assigned(ContentStream) then begin
      ContentLength := ContentStream.Size;
    end;
  end;
  SetHeaders;
  FConnection.IOHandler.WriteBufferOpen; try
    // Write HTTP status response
    // Client will be forced to close the connection. We are not going to support
    // keep-alive feature for now
    FConnection.IOHandler.WriteLn('HTTP/1.1 ' + IntToStr(ResponseNo) + ' ' + ResponseText);    {Do not Localize}
    // Write headers
    for i := 0 to RawHeaders.Count -1 do begin
      FConnection.IOHandler.WriteLn(RawHeaders[i]);
    end;
    // Write cookies
    for i := 0 to Cookies.Count - 1 do begin
      FConnection.IOHandler.WriteLn('Set-Cookie: ' + Cookies[i].ServerCookie);    {Do not Localize}
    end;
    // HTTP headers ends with a double CR+LF
    FConnection.IOHandler.WriteLn;
  finally FConnection.IOHandler.WriteBufferClose; end;
end;

function TIdHTTPResponseInfo.GetServer: string;
begin
  result := Server;
end;

procedure TIdHTTPResponseInfo.SetServer(const Value: string);
begin
  Server := Value;
end;

{ TIdHTTPDefaultSessionList }

procedure TIdHTTPDefaultSessionList.Add(ASession: TIdHTTPSession);
begin
  SessionList.Add(ASession);
end;

procedure TIdHTTPDefaultSessionList.Clear;
var
  ASessionList: TList;
  i: Integer;
begin
  ASessionList := SessionList.LockList;
  try
    for i := ASessionList.Count - 1 DownTo 0 do
      if ASessionList[i] <> nil then
      begin
        TIdHTTPSession(ASessionList[i]).DoSessionEnd;
        TIdHTTPSession(ASessionList[i]).FOwner := nil;
        TIdHTTPSession(ASessionList[i]).Free;
      end;
    ASessionList.Clear;
    ASessionList.Capacity := SessionCapacity;
  finally
    SessionList.UnlockList;
  end;
end;

constructor TIdHTTPDefaultSessionList.Create(AOwner: TComponent);
begin
  inherited;

  SessionList := TThreadList.Create;
  SessionList.LockList.Capacity := SessionCapacity;
  SessionList.UnlockList;
end;

function TIdHTTPDefaultSessionList.CreateSession(const RemoteIP, SessionID: String): TIdHTTPSession;
begin
  result := TIdHTTPSession.CreateInitialized(Self, SessionID, RemoteIP);
  SessionList.Add(result);
end;

function TIdHTTPDefaultSessionList.CreateUniqueSession(
  const RemoteIP: String): TIdHTTPSession;
var
  SessionID: String;
begin
  SessionID := GetRandomString(15);
  while GetSession(SessionID, RemoteIP) <> nil do
  begin
    SessionID := GetRandomString(15);
  end;    // while
  result := CreateSession(RemoteIP, SessionID);
end;

destructor TIdHTTPDefaultSessionList.destroy;
begin
  Clear;
  SessionList.free;
  inherited;
end;

function TIdHTTPDefaultSessionList.GetSession(const SessionID, RemoteIP: string): TIdHTTPSession;
var
  ASessionList: TList;
  i: Integer;
  ASession: TIdHTTPSession;
begin
  Result := nil;
  ASessionList := SessionList.LockList;
  try
    // get current time stamp
    for i := 0 to ASessionList.Count - 1 do
    begin
      ASession := TIdHTTPSession(ASessionList[i]);
      Assert(ASession <> nil);
      // the stale sessions check has been removed... the cleanup thread should suffice plenty
      if TextIsSame(ASession.FSessionID, SessionID) and ((length(RemoteIP) = 0) or TextIsSame(ASession.RemoteHost, RemoteIP)) then
      begin
        // Session found
        ASession.FLastTimeStamp := Now;
        result := ASession;
        break;
      end;
    end;
  finally
    SessionList.UnlockList;
  end;
end;

procedure TIdHTTPDefaultSessionList.PurgeStaleSessions(PurgeAll: Boolean = false);
var
  i: Integer;
  aSessionList: TList;
begin
  // S.G. 24/11/00: Added a way to force a session purge (Used when thread is terminated)
  // Get necessary data
  aSessionList := SessionList.LockList;
  try
    // Loop though the sessions.
    for i := aSessionList.Count - 1 downto 0 do
    begin
      // Identify the stale sessions
      if Assigned(ASessionList[i]) and
         (PurgeAll or TIdHTTPSession(aSessionList[i]).IsSessionStale) then
      begin
        RemoveSessionFromLockedList(i, aSessionList);
      end;
    end;
  finally
    SessionList.UnlockList;
  end;
end;

procedure TIdHTTPDefaultSessionList.RemoveSession(Session: TIdHTTPSession);
var
  ASessionList: TList;
  Index: integer;
begin
  ASessionList := SessionList.LockList;
  try
    Index := ASessionList.IndexOf(TObject(Session));
    if index > -1 then
    begin
      ASessionList.Delete(index);
    end;
  finally
    SessionList.UnlockList;
  end;
end;

procedure TIdHTTPDefaultSessionList.RemoveSessionFromLockedList(AIndex: Integer;
  ALockedSessionList: TList);
begin
  TIdHTTPSession(ALockedSessionList[AIndex]).DoSessionEnd;
  // must set the owner to nil or the session will try to remove itself from the
  // session list and deadlock
  TIdHTTPSession(ALockedSessionList[AIndex]).FOwner := nil;
  TIdHTTPSession(ALockedSessionList[AIndex]).Free;
  ALockedSessionList.Delete(AIndex);
end;

{ TIdHTTPSessionClearThread }

procedure TIdHTTPSessionCleanerThread.AfterRun;
begin
  if Assigned(FSessionList) then
    FSessionList.PurgeStaleSessions(true);
  inherited AfterRun;
end;

constructor TIdHTTPSessionCleanerThread.Create(SessionList: TIdHTTPCustomSessionList);
begin
  inherited Create(false);
  // thread priority used to be set to tpIdle but this is not supported
  // under DotNet. How low do you want to go?
  SetThreadPriority(Self, tpLowest);
  FSessionList := SessionList;
  FreeOnTerminate := False;
end;

procedure TIdHTTPSessionCleanerThread.Run;
begin
  Sleep(1000);
  if Assigned(FSessionList) then begin
    FSessionList.PurgeStaleSessions(Terminated);
  end;
end;

end.
