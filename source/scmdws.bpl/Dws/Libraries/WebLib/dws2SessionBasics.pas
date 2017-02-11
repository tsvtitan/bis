unit dws2SessionBasics;
interface
uses SysUtils, Classes;
const
  DWS_DEFAULT_BRAND = 'default';
  DWS_BRAND_LENGTH = 14;

  // secured web documents
  DWS_Spacer = '_';
  DWS_SessS = 'S';
  DWS_LogS = 'L';
  DWS_MaxS = 'M';

  DWS_NotSecured = ''; // normal DWS document..
  DWS_SessionSecured = DWS_Spacer + DWS_SessS; // to access this doc. you must have a valid User Session!
  DWS_LoginSecured = DWS_Spacer + DWS_LogS; // user must have made a valid Login (State >= 9);
  DWS_MaximumSecured = DWS_Spacer + DWS_MaxS; // user has to log in! (NOT as Guest! State >= 10);


  M_NotAllowedAndLogged = 'You are not allowed to access this document! Your attemt has been logged.';
  M_NeedValidSession = 'You need a valid user session in order to access this document!';
  M_NeedLogin = 'You need to login before you may access this document!';
  M_NeedToBeMember = 'You need to login as member before you can access this document!';



  // session server
  SLF = #1#10#13;
  NF = #2; // maxlength = 1!!
  IsSession = 1;
  NewSession = 2;
  EndSession = 3;
  GetSession = 4;
  EditSessionData = 5;
  EnumerateSessions = 6;

  // session state constants for UserSession.FClientState
  dwsClientStateLOFF = -1; // end session and log off
  dwsClientStateTOUT = -2; // session timed out
  dwsClientStateNLI = 0; // user is not logged in
  dwsClientStatePRF = 1; // still to proof session
  dwsClientStateGLI = 9; // logged in as guest
  dwsClientStateULI = 10; // user is logged in, session exists
  dwsClientStateNAT = 12; // logged in on higher level
  dwsClientStateVIP = 20; // logged in on VIP level
  dwsClientStateSU = 100; // logged in on SU level

type
  TSessionTrackingState = (dssOK, dssNoSession, dssInvalid, dssTimeOut, dssToManyUsers);

  TUserSession = class(TObject)
  private
    FUserData: TStringlist;
    FSessionBrand: string; // unique label for active user session
    FTrackingState: TSessionTrackingState;
    FClientState: Integer; // session state (new session, logged in..)
    FTLogin, // time of login request in this user session
      FTLastTouch, // time of last request in this user session (autoreload)
      FTLastAction: TDateTime; // last request with activity, cmd or interaction
    FIPaddr: string; // ..
  protected
    MySessionSync: TMultiReadExclusiveWriteSynchronizer;
    function GenerateSessionBrand: string; virtual;
    function GetUserData(const Name: string): variant; virtual;
    procedure SetUserData(const Name: string; Value: variant); virtual;
    function GetSessionBrand: string; virtual;
    procedure SetSessionBrand(Value: string); virtual;
    function GetTrackingState: TSessionTrackingState; virtual;
    procedure SetTrackingState(Value: TSessionTrackingState); virtual;
    function GetClientState: Integer; virtual;
    procedure SetClientState(Value: Integer); virtual;
    function GetTLogin: TDateTime; virtual;
    procedure SetTLogin(Value: TDateTime); virtual;
    function GetTLastTouch: TDateTime; virtual;
    procedure SetTLastTouch(Value: TDateTime); virtual;
    function GetTLastAction: TDateTime; virtual;
    procedure SetTLastAction(Value: TDateTime); virtual;
    function GetIPaddr: string; virtual;
    procedure SetIPaddr(Value: string); virtual;
  public
    constructor create;
    destructor destroy; override;
    procedure free;
    procedure assign(OtherSession: TUserSession); virtual;
    function ToString: string; virtual;
    procedure FromString(const AString: string); virtual;
    procedure reset; virtual;
    property UserData[const Name: string]: variant read GetUserData write SetUserData;
    property SessionBrand: string read GetSessionBrand write SetSessionBrand;
    property TrackingState: TSessionTrackingState read GetTrackingState write SetTrackingState;
    property ClientState: Integer read GetClientState write SetClientState;
    property TLogin: TDateTime read GetTLogin write SetTLogin;
    property TLastTouch: TDateTime read GetTLastTouch write SetTLastTouch;
    property TLastAction: TDateTime read GetTLastAction write SetTLastAction;
    property IPaddr: string read GetIPaddr write SetIPaddr;
  end;

implementation
// ************************** TUserSession  *************************

constructor TUserSession.create;
begin
  MySessionSync := TMultiReadExclusiveWriteSynchronizer.Create;
  FUserData := TStringlist.create;
  reset;
end;

destructor TUserSession.destroy;
begin
  FUserData.free;
  MySessionSync.Free;
  inherited;
end;

procedure TUserSession.free;
begin
  destroy;
end;

procedure TUserSession.reset;
begin
  if assigned(FUserData) then
    FUserData.Clear;
  SessionBrand := GenerateSessionBrand;
  TrackingState := dssNoSession;
  ClientState := dwsClientStateNLI;
  TLogin := now;
  TLastTouch := now;
  TLastAction := now;
  IPaddr := '';
end;

function TUserSession.GetUserData(const Name: string): variant;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FUserData.Values[Name];
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetUserData(const Name: string; Value: variant);
var
  i: Integer;
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  i := FUserData.IndexOfName(Name);
  if i >= 0 then
    FUserData.Values[Name] := Value
  else
    FUserData.Add(Name + '=' + string(Value));
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

procedure TUserSession.assign(OtherSession: TUserSession);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FUserData.Clear;
  FUserData.AddStrings(OtherSession.FUserData);
  SessionBrand := OtherSession.SessionBrand;
  TrackingState := OtherSession.TrackingState;
  ClientState := OtherSession.ClientState;
  TLogin := OtherSession.TLogin;
  TLastTouch := OtherSession.TLastTouch;
  TLastAction := OtherSession.TLastAction;
  IPaddr := OtherSession.IPaddr;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GenerateSessionBrand: string;
var
  sH: string;
  i: integer;
begin
  sH := copy(Format('%8.8f', [now]), 1, DWS_BRAND_LENGTH);
  Result := '';
  for i := 1 to length(sH) do
  begin
    Result := Result + chr(random(ord(sH[i]) - 32) + 65);
  end;
end;

function TUserSession.GetSessionBrand: string;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FSessionBrand;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetSessionBrand(Value: string);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FSessionBrand := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GetTrackingState: TSessionTrackingState;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FTrackingState;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetTrackingState(Value: TSessionTrackingState);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FTrackingState := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GetClientState: Integer;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FClientState;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetClientState(Value: Integer);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FClientState := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GetTLogin: TDateTime;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FTLogin;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetTLogin(Value: TDateTime);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FTLogin := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GetTLastTouch: TDateTime;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FTLastTouch;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetTLastTouch(Value: TDateTime);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FTLastTouch := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GetTLastAction: TDateTime;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FTLastAction;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetTLastAction(Value: TDateTime);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FTLastAction := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.GetIPaddr: string;
begin
  MySessionSync.BeginRead; // ********** MySessionSync **************
  result := FIPaddr;
  MySessionSync.EndRead; // ********** MySessionSync **************
end;

procedure TUserSession.SetIPaddr(Value: string);
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FIPaddr := Value;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

procedure TUserSession.FromString(const AString: string);
  function GetString(var input: string; const HasLength: Boolean = false): string;
  var
    str1: string;
  begin
    if HasLength then
    begin
     // i know, aweful code...
      str1 := copy(input, 1, pos(nf, input) - 1);
      input := copy(input, pos(nf, input) + 1, length(input));
      result := copy(input, 1, strtoint(str1));
      input := copy(input, strtoint(str1) + 1, length(input));
    end else
    begin
      result := copy(input, 1, pos(NF, input) - 1);
      input := copy(input, pos(NF, input) + 1, length(input));
    end;
  end;
var
  Output, Input: string;
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  FUserData.Clear;
  Input := AString;
  OutPut := getstring(Input, true);
  FUserData.Text := OutPut;
  OutPut := getstring(Input, true);
  SessionBrand := OutPut;
  OutPut := getString(Input);
  TrackingState := TSessionTrackingState(Word(strtoint(OutPut)));
  OutPut := getString(Input);
  ClientState := StrToInt(OutPut);
  OutPut := getString(Input);
  try
    TLogIn := StrToDateTime(OutPut);
  except
    asm int 3 end;
  end;
  OutPut := getString(Input);
  TLastTouch := StrToDateTime(OutPut);
  OutPut := getString(Input);
  FTLastAction := StrToDateTime(OutPut);
  OutPut := getString(Input);
  IPaddr := OutPut;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

function TUserSession.ToString: string;
begin
  MySessionSync.BeginWrite; // ********** MySessionSync **************
  Result := inttostr(length(FUserData.Text)) + NF + FUserData.Text +
    inttostr(length(SessionBrand)) + NF + SessionBrand +
    inttostr(Word(TrackingState)) +
    NF + inttostr(ClientState) +
    NF + DateTimeToStr(TLogin) +
    NF + DateTimeToStr(TLastTouch) +
    NF + DateTimeToStr(FTLastAction) +
    NF + IPaddr + NF;
  MySessionSync.EndWrite; // ********** MySessionSync **************
end;

end.


