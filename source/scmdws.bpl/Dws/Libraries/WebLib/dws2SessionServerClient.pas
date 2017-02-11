{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at                                          }
{                                                                      }
{    http://www.mozilla.org/MPL/                                       }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    The Original Code is DWSII SessionServer source code, released    }
{    January 1, 2002                                                   }
{                                                                      }
{    http://www.dwscript.com                                           }
{                                                                      }
{    The Initial Developer of the Original Code is Willibald Krenn     }
{    Portions created by Willibald Krenn are Copyright (C) 2001        }
{    Willibald Krenn, Austria. All Rights Reserved.                    }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2SessionServerClient;

interface
uses dws2SessionLibModule, dws2SessionGlobals, IdBaseComponent, IdComponent,
  IdTCPConnection,
  IdTCPClient, dws2webbasics, contnrs, sysutils, classes, syncobjs,
  dws2SessionBasics;

type
  TGlobalSessionServerClient = class; // forward

  // our user session class. (extensions for server-side user session tracking)
  TServerSession = class(TUserSession)
  private
    Fclient: TIdTCPClient;
    Fvalid: Boolean;
    FTchTime: real;
    FReqTime: real;
    FDoNotTouch: Boolean;
    FUpdatesLocked: Boolean;
    FSession: TGlobalSessionServerClient;
    procedure Setclient(const Value: TIdTCPClient);
    procedure Setvalid(const Value: Boolean);
    procedure SetReqTime(const Value: real);
    procedure SetTchTime(const Value: real);
    procedure SetDoNotTouch(const Value: Boolean);
    procedure UpdateServer;
  protected
    // we need to override the get/set methods in order to be able to
    // update the server...
    function GenerateSessionBrand: string; override;
    function GetUserData(const Name: string): variant; override;
    procedure SetUserData(const Name: string; Value: variant); override;
    function GetSessionBrand: string; override;
    procedure SetSessionBrand(Value: string); override;
    function GetTrackingState: TSessionTrackingState; override;
    procedure SetTrackingState(Value: TSessionTrackingState); override;
    function GetClientState: Integer; override;
    procedure SetClientState(Value: Integer); override;
    function GetTLogin: TDateTime; override;
    procedure SetTLogin(Value: TDateTime); override;
    function GetTLastTouch: TDateTime; override;
    procedure SetTLastTouch(Value: TDateTime); override;
    function GetTLastAction: TDateTime; override;
    procedure SetTLastAction(Value: TDateTime); override;
    function GetIPaddr: string; override;
    procedure SetIPaddr(Value: string); override;
  public
    constructor create(ASession: TGlobalSessionServerClient);
    // create session and connect to server
    destructor destroy; override;
    procedure reset; override;

    function LockUpdates: Boolean;
    procedure UnlockUpdates;

    property client: TIdTCPClient read Fclient write Setclient;
    property valid: Boolean read Fvalid write Setvalid;
    property DoNotTouch: Boolean read FDoNotTouch write SetDoNotTouch;
    property ReqTime: real read FReqTime write SetReqTime;
    // max time between requests (we get this from server!)
    property TchTime: real read FTchTime write SetTchTime;
    // max time between touches (we get this from server!)
    property UpdatesLocked: Boolean read FUpdatesLocked;
  end;

  TGlobalSessionServerClient = class(TGlobalSessionList)
  private
    FMaxSessions: Integer;
    SessionObjectList: TThreadList;
    Lock: TCriticalSection;
    function TouchSession(SBrand: string; const getsession: boolean = false):
      TUserSession;
  public
{$IFDEF LOGGING}
    LogFile: Textfile;
{$ENDIF}
    constructor create;
    destructor destroy; override;
    procedure FreeListObjects; override;
    function CreateUserSession: TUserSession; override;
    function GetUserSession(SBrand: string; ReqTime, TchTime: real):
      TUserSession; override;
    function TouchUserSession(SBrand: string; lReqTime, lTchTime: real):
      TUserSession; override;
    procedure DeleteUserSession(SBrand: string); override;
    function GetExpiredSessions(ReqTime, Tchtime: real): TObjectList; override;
    property MaxSessions: integer read FMaxSessions write FMaxSessions;
  end;

procedure InitClient;
procedure FinishClient;

implementation

{ TGlobalSessionServerClient }

constructor TGlobalSessionServerClient.create;
begin
  inherited;
  Lock := TCriticalSection.Create;
  SessionObjectList := TThreadList.Create;
  Sorted := true;
{$IFDEF LOGGING}
  AssignFile(LogFile, '/home/kylix2/kylix2/SessClient.log');
  rewrite(LogFile);
{$ENDIF}
end;

function TGlobalSessionServerClient.CreateUserSession: TUserSession;
var
  i: integer;
label
  1;
begin
  if count < DWS_MAXUSERSESSIONS then
  begin
    Lock.Acquire;
    try
      i := 0;
      result := TServerSession.create(self);
      with TServerSession(result) do
      begin
        SessionObjectList.Add(Pointer(result));
        1:
        result.Reset;
        // create session on server
        client.Write(inttostr(NewSession) + slf);
        client.Write(result.SessionBrand + slf);
        client.Write(result.ToString + slf);
        if client.ReadLn(slf) <> result.SessionBrand then
        begin
          inc(i);
          if i < 4 then
            goto 1;
          raise Exception.Create('Could not create Session!');
        end;
        Add(SessionBrand);
        valid := true;
        DoNotTouch := False;
        UnlockUpdates;
      end; // with
    finally
      Lock.Release;
    end;
  end
  else
    raise ESessionOverflow.Create('SessionOverflow');
  // example for code:  on e: ESessionOverflow do raise;
end;

procedure TGlobalSessionServerClient.DeleteUserSession(SBrand: string);
var
  alist: TList;
  i: Integer;
begin
  // delete session locally
  Lock.Acquire;
  try
    alist := SessionObjectList.LockList;
    try
      for i := 0 to aList.Count - 1 do
        with TServerSession(aList[i]) do
        begin
          if SessionBrand = SBrand then
          begin
            // delete session on the server
            client.Write(inttostr(EndSession) + slf); // delete
            client.Write(SBrand + slf);
            client.ReadLn(slf);
            free;
            alist.Delete(i);
            break;
          end;
        end; // with
    finally
      SessionObjectList.UnlockList;
    end;
  finally
    Lock.Release;
  end;
end;

destructor TGlobalSessionServerClient.destroy;
var
  i: integer;
  alist: TList;
begin
{$IFDEF LOGGING}
  flush(LogFile);
  close(LogFile);
{$ENDIF}
  Lock.Acquire;
  try
    aList := SessionObjectList.LockList;
    try
      for i := aList.Count - 1 downto 0 do
        if assigned(aList[i]) then
          TServerSession(aList[i]).Free;
      alist.Clear;
    finally
      SessionObjectList.UnlockList;
    end;
    freeandnil(SessionObjectList);
  finally
    Lock.Release;
  end;
  Lock.Free;
  inherited;
end;

procedure TGlobalSessionServerClient.FreeListObjects;
begin
  //inherited;
end;

function TGlobalSessionServerClient.GetExpiredSessions(ReqTime,
  Tchtime: real): TObjectList;
var
  i, a: integer;
  alist: TList;
begin
  Lock.Acquire;
  try
    Result := TObjectList.Create;
    aList := SessionObjectList.LockList;
    try
      for i := aList.Count - 1 downto 0 do
      begin
        with TServerSession(alist[i]) do
        begin
          if (TLastAction < now - ReqTime) or (TLastTouch < now - TchTime)
            or (ClientState = dwsClientStateTOUT) then
          begin
            if Find(SessionBrand, a) then
              Delete(a);
            LockUpdates;
            client.Disconnect;
            valid := false;
            ClientState := dwsClientStateTOUT;
            Result.Add(alist[i]);
            alist.Delete(i);
            UnlockUpdates;
          end;
        end; // with
      end;
    finally
      SessionObjectList.UnlockList;
    end;
  finally
    Lock.Release;
  end;
end;

function TGlobalSessionServerClient.GetUserSession(SBrand: string; ReqTime,
  TchTime: real): TUserSession;
begin
  result := TouchSession(SBrand, True);
end;

function TGlobalSessionServerClient.TouchSession(SBrand: string;
  const getsession: boolean): TUserSession;
var
  id: integer;
  dtReqTime, dtTchTime: TDateTime;
  alist: TList;
  action: string;
begin
  result := nil;
  // is session already here (can only be true if we are working with ISAPIs..)
  alist := SessionObjectList.LockList;
  try
    for id := 0 to aList.Count - 1 do
      if TServerSession(aList[id]).SessionBrand = SBrand then
      begin
        result := TServerSession(aList[id]);
        action := DateTimeToStr(result.TLastAction);
        if (result as TServerSession).DoNotTouch then
          exit;
        break;
      end;
  finally
    SessionObjectList.UnlockList;
  end;

  Lock.Acquire;
  try
    // session locally not found - so we are trying to get it from the server
    if not assigned(result) then
    begin
      result := TServerSession.create(self);
      with TServerSession(result) do
      begin
        LockUpdates;
        client.Write(inttostr(dws2SessionBasics.GetSession) + slf); // get
        client.Write(SBrand + slf);
        if client.ReadLn(slf) <> SBrand then
        begin
          // session not on the server - so this is an invalid session brand!!
          result.free;
          result := nil;
          exit;
        end;
        // we found a session on the server - now pull it onto the client..
        action := client.ReadLn(slf);
        result.FromString(action);
        client.ReadLn(slf); // touch
        action := client.ReadLn(slf); // action
        if result.ClientState <> dwsClientStateTOUT then
        begin
          Add(SessionBrand);
          SessionObjectList.add(Pointer(result));
          valid := true;
          DoNotTouch := False;
        end
        else
        begin
          result.free;
          result := nil;
        end;
      end; // with
    end;

    with result as TServerSession do
    begin
      // here we have got the session - now we have to update the touch-time!
      // this part is 1:1 from Hannes' WebLib
      if assigned(result) then
      begin
        LockUpdates;
        dtReqTime := now - ReqTime;
        if TchTime > 0 then
          dtTchTime := now - TchTime
        else
          dtTchTime := now - ReqTime;
        if (Result.TLastAction < dtReqTime) or (Result.TLastTouch < dtTchTime)
          then
          result.ClientState := dwsClientStateTOUT
        else
        begin
          result.TLastTouch := now;
          if getsession then
            result.TLastAction := now;
        end;
        // update session on server
        // session must be known on the server because we already created it in CreateUserSession!
        try
          UnlockUpdates; // update
        except
          on EAbort do // we are not connected to the server anymore!!
          begin
            LockUpdates;
            result.ClientState := dwsClientStateTOUT;
          end;
        end;
        if (result.ClientState = dwsClientStateTOUT) then
          result := nil;
      end; // if
    end;
  finally
    lock.Release;
  end;
end;

function TGlobalSessionServerClient.TouchUserSession(SBrand: string;
  lReqTime, lTchTime: real): TUserSession;
begin
  Result := TouchSession(SBrand);
end;

procedure InitClient;
begin
  GlobalSessionList.Free;
  GlobalSessionList := TGlobalSessionServerClient.create;
end;

procedure FinishClient;
begin
  GlobalSessionList.Free;
end;

{ TServerSession }

constructor TServerSession.create;
var
  input: string;
begin
  FUpdatesLocked := true;
  inherited Create;
  FSession := ASession;
  TLogin := 0;
  DoNotTouch := True;
  client := TIdTCPClient.Create(nil);
  client.Host := '127.0.0.1';
  client.Port := 9000;
  try
    client.Connect;
    // get expire times!
    input := client.ReadLn(slf);
    self.TchTime := strtofloat(input);
    input := client.ReadLn(slf);
    self.ReqTime := strtofloat(input);
    valid := true;
  except
    on e: exception do
    begin
{$IFDEF LOGGING}
      FSession.Lock.Acquire;
      try
        write(FSession.LogFile, 'Client Error: ' + e.message);
        flush(FSession.LogFile);
      finally
        FSession.Lock.Release;
      end;
{$ENDIF}
      raise;
    end;
  end;
end;

destructor TServerSession.destroy;
begin
  FUpdatesLocked := True;
  try
    if client.Connected then
      client.Disconnect;
    client.Free;
  except
    // eat all exceptions here...
    // what should we do anyway?
  end;
  inherited;
end;

function TServerSession.GenerateSessionBrand: string;
var
  Basis: ShortString;
  i, a, code: integer;
begin
  Basis := Format('%8.8f', [now]);
  for i := 1 to length(basis) do
  begin
    val(Basis[i], a, code);
    if code = 0 then
      Basis[i] := chr(a + 65)
    else
      Basis[i] := 'A';
  end;
  result := copy(basis, length(basis) - DWS_BRAND_LENGTH, length(basis));
end;

function TServerSession.GetClientState: Integer;
begin
  Result := inherited GetClientState;
end;

function TServerSession.GetIPaddr: string;
begin
  Result := inherited GetIPaddr;
end;

function TServerSession.GetSessionBrand: string;
begin
  Result := inherited GetSessionBrand;
end;

function TServerSession.GetTLastAction: TDateTime;
begin
  Result := inherited GetTLastAction;
end;

function TServerSession.GetTLastTouch: TDateTime;
begin
  Result := inherited GetTLastTouch;
end;

function TServerSession.GetTLogin: TDateTime;
begin
  Result := inherited GetTLogin;
end;

function TServerSession.GetTrackingState: TSessionTrackingState;
begin
  Result := inherited GetTrackingState;
end;

function TServerSession.GetUserData(const Name: string): variant;
begin
  Result := inherited GetUserData(Name);
end;

function TServerSession.LockUpdates: Boolean;
begin
  result := true;
  FUpdatesLocked := true;
end;

procedure TServerSession.reset;
begin
  inherited;
  SessionBrand := GenerateSessionBrand;
end;

procedure TServerSession.Setclient(const Value: TIdTCPClient);
begin
  Fclient := Value;
end;

procedure TServerSession.SetClientState(Value: Integer);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetDoNotTouch(const Value: Boolean);
begin
  FDoNotTouch := Value;
end;

procedure TServerSession.SetIPaddr(Value: string);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetReqTime(const Value: real);
begin
  FReqTime := Value;
end;

procedure TServerSession.SetSessionBrand(Value: string);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetTchTime(const Value: real);
begin
  FTchTime := Value;
end;

procedure TServerSession.SetTLastAction(Value: TDateTime);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetTLastTouch(Value: TDateTime);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetTLogin(Value: TDateTime);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetTrackingState(Value: TSessionTrackingState);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.SetUserData(const Name: string; Value: variant);
begin
  inherited;
  // now update the server
  if not UpdatesLocked then
    UpDateServer;
end;

procedure TServerSession.Setvalid(const Value: Boolean);
begin
  Fvalid := Value;
end;

procedure TServerSession.UnlockUpdates;
begin
  UpdateServer;
  FUpdatesLocked := false;
end;

procedure TServerSession.UpdateServer;
begin
  MySessionSync.BeginWrite;
  try
    if not client.Connected then
      raise EAbort.Create('');
    client.Write(inttostr(EditSessionData) + slf);
    client.Write(SessionBrand + slf);
    client.Write(ToString + slf);
    client.Write(datetimetostr(now) + slf);
    client.Write(datetimetostr(now) + slf); // action
    if client.ReadLn(slf) <> SessionBrand then
    begin
      ClientState := dwsClientStateTOUT;
      valid := false;
    end;
  finally
    MySessionSync.EndWrite;
  end;
end;

end.

