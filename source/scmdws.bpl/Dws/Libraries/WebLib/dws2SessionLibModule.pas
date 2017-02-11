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
{    The Original Code is DelphiWebScriptII source code, released      }
{    January 1, 2001                                                   }
{                                                                      }
{    http://www.dwscript.com                                           }
{                                                                      }
{    The Initial Developers of the Original Code are Matthias          }
{    Ackermann and hannes hernler.                                     }
{    Portions created by Matthias Ackermann are Copyright (C) 2001     }
{    Matthias Ackermann, Switzerland. All Rights Reserved.             }
{    Portions created by hannes hernler are Copyright (C) 2001         }
{    hannes hernler, Austria. All Rights Reserved.                     }
{                                                                      }
{    Contributor(s): ______________________________________.           }
{                                                                      }
{**********************************************************************}

unit dws2SessionLibModule;

interface

uses
{$IFDEF LINUX}
  Libc,
{$ELSE}
  Windows, Forms,
{$ENDIF}
  SysUtils, Classes, contnrs, HTTPApp,
  dws2Comp, dws2Exprs, SyncObjs, dws2WebBasics, dws2SessionGlobals, dws2SessionBasics;

const
  DWS_ACTION_TDIFF = 0.001; // 10 / (24 * 60); // 14 minutes session timeout
  DWS_TOUCH_TDIFF = 0.0001; // 1 / (24 * 60); // 1.4 minutes session timeout
  DWS_COOKIEPREFIX = 'DWSC'; // prefix that is sent with user tracking cookies
  DWS_TOUCHBRAND_PREFIX = 'TOUCH';

type
  Tdws2SessionLib = class;

  TOnCustomUSTEvent = procedure(SessionLib: Tdws2SessionLib; USession: TUserSession) of object;

  Tdws2SessionLib = class(TDatamodule, IUnknown, ISessionManager)
    customSessionUnit: Tdws2Unit;
    procedure dws2UnitClassesUserMethodsSetIpAddrEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsSetSstateEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsSetSBrandEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsSetTLoginEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsSetTLastActionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsGetActiveUsersEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsGetIpAddrEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsGetSstateEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsGetSBrandEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsGetTLoginEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2UnitClassesUserMethodsGetTLastActionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2UnitFunctionsTIDEval(Info: TProgramInfo);
    procedure dws2UnitClassesUserMethodsGetUserdataEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure customSessionUnitClassesUserMethodsSetUserDataEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customSessionUnitFunctionsActivSessionEval(
      Info: TProgramInfo);
    procedure customSessionUnitFunctionsURLEval(Info: TProgramInfo);
  private
    { Private-Deklarationen }
    FScript: TDelphiWebScriptII;
    FUseSessionCookie: boolean; // use cookies for user tracking
    FSessionBrandLabel: string; // name for unique lable for active user session
    FSessionCookiePrefix: string;
    FSessionCookieExpireTime: real;
    FSessionExpireTime: real;
    FSessionTouchTime: real;
    FHttpInfo: THttpInfo;
    FOnCloseUserSession, FOnNewUserSession: TOnCustomUSTEvent;
    FFailedAuthMessage: TStringList; // OnCustomUSTEvent eventhandler
    procedure AddSBrandFunction;
    procedure RemoveSBrandFunction;
    procedure SetScript(const Value: TDelphiWebScriptII);
    procedure SetFailedAuthMessage(const Value: TStringList);
  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
//    function QueryInterface(const IID: TGUID; out Obj): HResult; override;
//    function _AddRef: Integer; stdcall;
//    function _Release: Integer; stdcall;

    function GetUserSession: TUserSession; // interface
    function GetSessionBrand: string; // interface
    function LocateUserSession(HttpInfo: THttpInfo): TSessionTrackingState; // interface
    function CreateUserSession: TUserSession; // interface
    procedure CloseUserSession(USession: TUserSession); // interface

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property HttpInfo: THttpInfo read FHttpInfo;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property SessionCookiePrefix: string read FSessionCookiePrefix write FSessionCookiePrefix;
    property SessionCookieExpireTime: real read FSessionCookieExpireTime write FSessionCookieExpireTime;
    property SessionExpireTime: real read FSessionExpireTime write FSessionExpireTime;
    property SessionTouchTime: real read FSessionTouchTime write FSessionTouchTime;
    property SessionBrandLabel: string read FSessionBrandLabel write FSessionBrandLabel;
    property UseSessionCookie: boolean read FUseSessionCookie write FUseSessionCookie;
    property FailedAuthMessage: TStringList read FFailedAuthMessage write SetFailedAuthMessage;
    property OnNewUserSession: TOnCustomUSTEvent read FOnNewUserSession write FOnNewUserSession;
    property OnCloseUserSession: TOnCustomUSTEvent read FOnCloseUserSession write FOnCloseUserSession;
  end;

var
  GlobalSessionList: TGlobalSessionList;

procedure Register;


implementation

{$R *.dfm}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2SessionLib]);
end;

// ************************** Tdws2SessionLib  *************************

constructor Tdws2SessionLib.create(AOwner: TComponent);
begin
  inherited;
  FFailedAuthMessage:= TStringList.Create;
  FSessionCookiePrefix := DWS_COOKIEPREFIX;
  FSessionCookieExpireTime := 0.2;
  FSessionExpireTime := DWS_ACTION_TDIFF;
  FSessionTouchTime := DWS_ACTION_TDIFF;
  FSessionBrandLabel := 'TID';
end;

procedure Tdws2SessionLib.AddSBrandFunction;
var
  sbfunc: Tdws2Function;
begin
  if Assigned(FScript) and not (csDesigning in ComponentState) then
  begin
    sbfunc := Tdws2Function(customSessionUnit.Functions.Add);
    sbfunc.ResultType := 'String';
    sbfunc.Name := FSessionBrandLabel;
    sbfunc.OnEval := dws2UnitFunctionsTIDEval;
  end;
end;

procedure Tdws2SessionLib.RemoveSBrandFunction;
var
  i: Integer;
begin
  if Assigned(FScript) and not (csDesigning in ComponentState) then
    with customSessionUnit.Functions do
    begin
      for i := 0 to count - 1 do
      begin
        if Tdws2Function(items[i]).name = FSessionBrandLabel then
        begin
          delete(i);
          exit;
        end;
      end;
    end;
end;

procedure Tdws2SessionLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
  inherited;
end;

procedure Tdws2SessionLib.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
  begin
    FScript.RemoveFreeNotification(Self);
    RemoveSBrandFunction;
  end;
  FScript := Value;
  if Assigned(FScript) then
  begin
    Value.FreeNotification(FScript);
    AddSBrandFunction;
  end;
  if not (csDesigning in ComponentState) then
    for x := 0 to ComponentCount - 1 do
      if Components[x] is Tdws2Unit then
        Tdws2Unit(Components[x]).Script := Value;
//    customSessionUnit.Script := Value;
end;

function Tdws2SessionLib.GetUserSession: TUserSession;
begin
  Result := FHttpInfo.UserSession;
end;

function Tdws2SessionLib.LocateUserSession(HttpInfo: THttpInfo): TSessionTrackingState;
var
  sH, sBrand, sTouchBrand: string;
begin
  Result := dssNoSession;
  FHttpInfo := HttpInfo;
  with FHttpInfo do
  begin
    UserSession := nil;
    if UseSessionCookie then // Session ID in cookie
    begin
      sH := FSessionCookiePrefix + SessionBrandLabel;
      sBrand := HttpInfo.HttpRequest.CookieFields.Values[sH];
    end
    else
      sBrand := params.Values[SessionBrandLabel];
    sH := DWS_TOUCHBRAND_PREFIX + SessionBrandLabel;

    sTouchBrand := params.Values[sH];
    if (length(sTouchBrand) = DWS_BRAND_LENGTH) then
    begin
      UserSession := GlobalSessionList.TouchUserSession(sTouchBrand, FSessionExpireTime, FSessionTouchTime);
      if not (UserSession = nil) then
        Result := dssOk;
    end
    else begin // else  length(sTouchBrand)<>DWS_BRAND_LENGTH
      if (length(sBrand) = DWS_BRAND_LENGTH) then
        UserSession := GlobalSessionList.GetUserSession(sBrand, FSessionExpireTime, FSessionTouchTime);
      if not (UserSession = nil) then
      begin // UserSession != nil
        Result := dssOk;
        if UseSessionCookie then
          with FHttpInfo.HttpResponse.Cookies.Add do
          begin
            Name := FSessionCookiePrefix + SessionBrandLabel; // set LastPassword-Cookie to active SessionBrand
            Value := UserSession.SessionBrand;
            Expires := Now + FSessionCookieExpireTime; // Cookie expires after x days
          end;
      end; // UserSession != nil
    end; // else  length(sTouchBrand)<>DWS_BRAND_LENGTH
  end;
end;

// ************************** CreateUserSession  *************************

function Tdws2SessionLib.CreateUserSession: TUserSession;
var
  ExpiredSessions: TObjectList;
  i: Integer;
begin
  ExpiredSessions := GlobalSessionList.GetExpiredSessions(
    FSessionExpireTime, FSessionTouchTime);
  with ExpiredSessions do
  begin
    for i := 0 to count - 1 do
    begin
      if Assigned(OnCloseUserSession) then
        OnCloseUserSession(Self, HttpInfo.UserSession);
    end;
    clear;
  end;

  try
    result := GlobalSessionList.CreateUserSession;
    result.IPaddr := FHttpInfo.HttpRequest.RemoteAddr;
    result.ClientState := dwsClientStateNLI;
    if Assigned(OnNewUserSession) then
    begin
      OnNewUserSession(Self, result);
    end;
    if UseSessionCookie then
      with FHttpInfo.HttpResponse.Cookies.Add do
      begin
        Name := FSessionCookiePrefix + SessionBrandLabel; // set LastPassword-Cookie to active SessionBrand
        Value := result.SessionBrand;
        Expires := Now + FSessionCookieExpireTime; // Cookie expires after x days
      end;
  except
    on e: ESessionOverflow do raise;
  end;
end;

procedure Tdws2SessionLib.CloseUserSession(USession: TUserSession);
begin
  if Assigned(OnCloseUserSession) and not (USession = nil) then
  begin
    OnCloseUserSession(Self, USession);
  end;
  USession.reset;
end;

function Tdws2SessionLib.GetSessionBrand: string;
begin
  if FHttpInfo.UserSession = nil then
  try
    FHttpInfo.UserSession := CreateUserSession;
    Result := FHttpInfo.UserSession.SessionBrand;
  except
    on ESessionOverflow do
      Result := 'overflow';
  else
    Result := '';
  end
  else
    Result := FHttpInfo.UserSession.SessionBrand;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsSetIpAddrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if not (FHttpInfo.UserSession = nil) then
    FHttpInfo.UserSession.IPaddr := Info['Value'];
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsSetSstateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if not (FHttpInfo.UserSession = nil) then
    FHttpInfo.UserSession.ClientState := Info['Value'];
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsSetSBrandEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if not (FHttpInfo.UserSession = nil) then
    FHttpInfo.UserSession.SessionBrand := Info['Value'];
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsSetTLoginEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if not (FHttpInfo.UserSession = nil) then
    FHttpInfo.UserSession.TLogin := Info['Value'];
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsSetTLastActionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if FHttpInfo.UserSession = nil then
    Info['Result'] := ''
  else
    FHttpInfo.UserSession.TLastAction := Info['Value'];
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetActiveUsersEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := GlobalSessionList.Count;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetIpAddrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if FHttpInfo.UserSession = nil then
    Info['Result'] := ''
  else
    Info['Result'] := FHttpInfo.UserSession.IPaddr;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetSstateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if FHttpInfo.UserSession = nil then
    Info['Result'] := 0
  else
    Info['Result'] := FHttpInfo.UserSession.ClientState;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetSBrandEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := GetSessionBrand;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetTLoginEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if FHttpInfo.UserSession = nil then
    Info['Result'] := 0
  else
    Info['Result'] := FHttpInfo.UserSession.TLogin;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetTLastActionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  if FHttpInfo.UserSession = nil then
    Info['Result'] := 0
  else
    Info['Result'] := FHttpInfo.UserSession.TLastAction;
end;

procedure Tdws2SessionLib.dws2UnitFunctionsTIDEval(Info: TProgramInfo);
begin
  Info['Result'] := GetSessionBrand;
end;

procedure Tdws2SessionLib.dws2UnitClassesUserMethodsGetUserdataEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  sH: string;
begin
  if FHttpInfo.UserSession = nil then
    Info['Result'] := ''
  else begin
    sH := Info['Name'];
    Info['Result'] := FHttpInfo.UserSession.UserData[sH];
  end;
end;

procedure Tdws2SessionLib.customSessionUnitClassesUserMethodsSetUserDataEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  sH: string;
begin
  if not (FHttpInfo.UserSession = nil) then
  begin
    sH := Info['Name'];
    FHttpInfo.UserSession.UserData[sH] := Info['Value'];
  end;
end;

procedure Tdws2SessionLib.customSessionUnitFunctionsActivSessionEval(
  Info: TProgramInfo);
begin
  Info['Result'] := not (FHttpInfo.UserSession = nil);
end;

procedure Tdws2SessionLib.customSessionUnitFunctionsURLEval(
  Info: TProgramInfo);
begin
  Info['Result'] := Info['AnURL'] + '?' + SessionBrandLabel + '=' + GetSessionBrand;
end;

procedure Tdws2SessionLib.SetFailedAuthMessage(const Value: TStringList);
begin
  FFailedAuthMessage := Value;
end;

destructor Tdws2SessionLib.destroy;
begin
  FFailedAuthMessage.Free;
  inherited;
end;

initialization
  GlobalSessionList := TGlobalSessionList.create;
finalization
  GlobalSessionList.free;
end.

