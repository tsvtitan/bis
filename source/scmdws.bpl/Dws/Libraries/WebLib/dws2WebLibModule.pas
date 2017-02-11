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
{    Contributor(s): Willibald Krenn, Eric Grange.                     }
{                                                                      }
{**********************************************************************}

unit dws2WebLibModule;

interface

uses
{$IFDEF LINUX}
  Libc,
{$ELSE}
  Windows, Forms,
{$ENDIF}
  SysUtils, Classes, HTTPApp, dws2Comp, StrUtils, dws2Exprs, dws2Errors,
  dws2WebBasics, dws2SessionBasics, dws2HtmlFilter;

type

  ESecurityException = class(Exception);
  //DWS_SessS
  ENeedSession = class(ESecurityException);
  //DWS_LogS
  ENeedLogin = class(ESecurityException);
  //DWS_MaxS
  ENeedMemberLogin = class(ESecurityException);

  Tdws2WebLib = class;
  TOnCustomCommandEvent = procedure(dwsWebLib: Tdws2WebLib; HttpInfo: THttpInfo; CommmandStr: string) of object;
  TOnISAPISessionEvent = procedure(dwsWebLib: Tdws2WebLib) of object;
  TOnISAPIEvalEvent = procedure(dwsWebLib: Tdws2WebLib) of object;

  Tdws2WebLib = class(TDatamodule)
    customWebUnit: Tdws2Unit;
    procedure dws2WebUnitClassesRequestMethodsParamEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsParamCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsParamNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsParamValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsAuthorizationEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsContentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsContentLengthEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsContentTypeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsDateEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsFromEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsHostEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsRefererEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsRemoteAddrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsPathInfoEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsRemoteHostEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsScriptNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsTitleEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsUrlEval(Info: TProgramInfo;
      ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsUserAgentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetAllowEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetContentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetContentEncodingEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetContentLengthEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetContentTypeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetContentVersionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetDateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetDerivedFromEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetExpiresEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetLastModifiedEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetLocationEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetLogMessageEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetRealmEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetReasonStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetServerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetStatusCodeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetTitleEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSetVersionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetAllowEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetContentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetContentEncodingEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetContentLengthEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetContentTypeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetContentVersionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetDateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetDerivedFromEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetExpiresEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetLastModifiedEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetLocationEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetLogMessageEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetRealmEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetReasonStringEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetServerEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetStatusCodeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetTitleEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsGetVersionEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesScriptDocMethodsDateEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesScriptDocMethodsSizeEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesScriptDocMethodsFileNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesScriptDocMethodsPathEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsSendRedirectEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsSetDomainEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsSetExpiresEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsSetNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsSetPathEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsSetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetDomainEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetExpiresEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetHeaderValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetPathEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsSetSecureEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesTCookieMethodsGetSecureEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsCookieCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsCookieEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsCookieNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsCookieValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsCookieCountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsCookieEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsCookieByNameEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesResponseMethodsNewCookieEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsParamsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsLogContentEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsAcceptEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitClassesRequestMethodsMethodEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure dws2WebUnitFunctionsRtfToHtmlEval(Info: TProgramInfo);
    procedure dws2WebUnitFunctionsFormVarEval(Info: TProgramInfo);
    procedure dws2WebUnitFunctionsTrimURLEval(Info: TProgramInfo);
    procedure dws2WebUnitFunctionsacceptWMLEval(Info: TProgramInfo);
    procedure dws2WebUnitFunctionsURLencodeEval(Info: TProgramInfo);
    procedure dws2WebUnitFunctionsURLdecodeEval(Info: TProgramInfo);
    procedure dws2WebUnitFunctionsforwardEval(Info: TProgramInfo);
    procedure customWebUnitClassesTFormVarGroupMethodsSetPrefixEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsGetPrefixEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsSetAddNullFieldsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodscountEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsExtEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsValueEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsGetAddNullFieldsEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsEofEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsFirstEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsNextEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupMethodsRecNrEval(
      Info: TProgramInfo; ExtObject: TObject);
    procedure customWebUnitClassesTFormVarGroupConstructorsCreateAssignExternalObject(
      Info: TProgramInfo; var ExtObject: TObject);
  private
    FScript: TDelphiWebScriptII;
    FHttpInfo: THttpInfo;
    FDumpActContent: boolean;
    FDumpFileName, FDumpPatternOpen, FDumpPatternClose: string;

    FMultiPartBoundary: string;
    //    FMsMultipartFormParser: TMsMultipartFormParser;
    FCustCommand: string;
    // fieldname in HTML form that fires OnCustomCommand event
    FOnEvalRequest, FOnEvalResponse, FOnEvalCookie, FOnEvalScriptDoc,
      FOnEvalFormVar, FOnEvalDWS: TOnISAPIEvalEvent; //
    FOnCustomCommandEval: TOnCustomCommandEvent; // OnCustomCommand eventhandler
    FBeforeInitISAPISession, FAfterInitISAPISession: TOnISAPISessionEvent;
    // OnInitISAPISession eventhandler
    FBeforeCloseISAPISession, FAfterCloseISAPISession: TOnISAPISessionEvent;
    // OnCloseISAPISession eventhandler
    FSessionManagerIntf: ISessionManager;
    FSessionManager: TComponent;
    FNeedMemberLoginDWSErrorFile: string;
    FNeedLoginDWSErrorFile: string;
    FNeedSessionDWSErrorFile: string;
    procedure SetSessionManager(const Value: TComponent);
    procedure SetScript(const Value: TDelphiWebScriptII);
    procedure SetNeedLoginDWSErrorFile(const Value: string);
    procedure SetNeedMemberLoginDWSErrorFile(const Value: string);
    procedure SetNeedSessionDWSErrorFile(const Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    function ManageUserSession(SessionManager: ISessionManager): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitISAPIsession(Request: TWebRequest; Response: TWebResponse);
    procedure CloseIsapiSession;
    function ActivateDumpScript(DumpStr: string): string;
    property HttpInfo: THttpInfo read FHttpInfo;
    property MultiPartBoundary: string read FMultiPartBoundary write
      FMultiPartBoundary;
    //    property MsMultipartFormParser: TMsMultipartFormParser read FMsMultipartFormParser write FMsMultipartFormParser;
    property DumpActContent: boolean read FDumpActContent write FDumpActContent;
    property DumpFileName: string read FDumpFileName write FDumpFileName;
  published
    property Script: TDelphiWebScriptII read FScript write SetScript;
    property NeedSessionDWSErrorFile: string read FNeedSessionDWSErrorFile write
      SetNeedSessionDWSErrorFile;
    property NeedLoginDWSErrorFile: string read FNeedLoginDWSErrorFile write
      SetNeedLoginDWSErrorFile;
    property NeedMemberLoginDWSErrorFile: string read
      FNeedMemberLoginDWSErrorFile write SetNeedMemberLoginDWSErrorFile;
    property SessionManager: TComponent read FSessionManager write
      SetSessionManager;
    property CustomCommand: string read FCustCommand write FCustCommand;
    property DumpPatternOpen: string read FDumpPatternOpen write
      FDumpPatternOpen;
    property DumpPatternClose: string read FDumpPatternClose write
      FDumpPatternClose;
    property OnCustomCommand: TOnCustomCommandEvent read FOnCustomCommandEval
      write FOnCustomCommandEval;
    property BeforeInitISAPISession: TOnISAPISessionEvent read
      FBeforeInitISAPISession write FBeforeInitISAPISession;
    property AfterInitISAPISession: TOnISAPISessionEvent read
      FAfterInitISAPISession write FAfterInitISAPISession;
    property BeforeCloseISAPISession: TOnISAPISessionEvent read
      FBeforeCloseISAPISession write FBeforeCloseISAPISession;
    property AfterCloseISAPISession: TOnISAPISessionEvent read
      FAfterCloseISAPISession write FAfterCloseISAPISession;
    property OnEvalCookie: TOnISAPIEvalEvent read FOnEvalCookie write
      FOnEvalCookie;
    property OnEvalFormVar: TOnISAPIEvalEvent read FOnEvalFormVar write
      FOnEvalFormVar;
    property OnEvalDWS: TOnISAPIEvalEvent read FOnEvalDWS write FOnEvalDWS;
    property OnEvalRequest: TOnISAPIEvalEvent read FOnEvalRequest write
      FOnEvalRequest;
    property OnEvalResponse: TOnISAPIEvalEvent read FOnEvalResponse write
      FOnEvalResponse;
    property OnEvalScriptDoc: TOnISAPIEvalEvent read FOnEvalScriptDoc write
      FOnEvalScriptDoc;
  end;

procedure Register;

implementation

{$R *.dfm}

procedure Register;
begin
  RegisterComponents('DWS2', [Tdws2WebLib]);
end;

{ TDataModule2 }

constructor Tdws2WebLib.create(AOwner: TComponent);
begin
  inherited;
  FDumpPatternOpen := '<!--%%';
  FDumpPatternClose := '%%-->';
  FCustCommand := 'action';
  FHttpInfo := THttpInfo.Create;
end;

destructor Tdws2WebLib.destroy;
begin
  if not (FHttpInfo = nil) then
    FHttpInfo.Free;
  inherited;
end;

procedure Tdws2WebLib.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FScript) then
    SetScript(nil);
  if (Operation = opRemove) and (AComponent = FSessionManager) then
    SetSessionManager(nil);
  inherited;
end;

procedure Tdws2WebLib.SetScript(const Value: TDelphiWebScriptII);
var
  x: Integer;
begin
  if Assigned(FScript) then
    FScript.RemoveFreeNotification(Self);
  FScript := Value;
  if Assigned(FScript) then
    FScript.FreeNotification(Self);
  if not (csDesigning in ComponentState) then
    for x := 0 to ComponentCount - 1 do
      if Components[x] is Tdws2Unit then
        Tdws2Unit(Components[x]).Script := Value;
  //  customWebUnit.Script := FScript;
end;

procedure Tdws2WebLib.SetSessionManager(const Value: TComponent);
begin
  if Assigned(Value) then
  begin
    if not Supports(Value, ISessionManager, FSessionManagerIntf) then
      raise
        Exception.CreateFmt('Component "%s" doesn''t support the ISessionManager interface', [Value.Name]);
  end
  else
    FSessionManagerIntf := nil;
  if Assigned(FSessionManager) then
    FSessionManager.RemoveFreeNotification(Self);
  FSessionManager := Value;
  if Assigned(FSessionManager) then
    FSessionManager.FreeNotification(Self);
end;

// ************************** Request Initialization *************************
{ XXX ************************** }

procedure Tdws2WebLib.InitISAPIsession(Request: TWebRequest; Response:
  TWebResponse);
var
  filename: ShortString; // speed this up
  treatspecial: char;
  cstate: Integer;
begin
  if Assigned(BeforeInitISAPISession) then
  begin
    BeforeInitISAPISession(self);
  end;

  treatspecial := #0;
  filename := changefileext(extractfilename(HttpInfo.ScriptDocFileName), '');
  cstate := length(filename) - 1;
  if (cstate >= 1) and (filename[cstate] = DWS_Spacer) then
    treatspecial := uppercase(filename[cstate])[1];

  with FHttpInfo do
  begin
    HttpRequest := TWebRequest(Request);
    HttpResponse := TWebResponse(Response);

    if Assigned(SessionManager) then
    begin
      ManageUserSession(FSessionManagerIntf);

      if (FSessionManagerIntf.LocateUserSession(FHttpInfo) <> dssOk) and
        (treatspecial <> #0) then
        raise ENeedSession.Create(M_NeedValidSession);

      if assigned(UserSession) then
        cstate := UserSession.ClientState
      else
        cstate := -9999;

      case treatspecial of
        //DWS_SessS: if cstate < 0 then
        //    raise ENeedSession.Create(M_NeedValidSession);
        DWS_LogS: if cstate < 9 then
            raise ENeedLogin.Create(M_NeedLogin);
        DWS_MaxS: if cstate < 10 then
            raise ENeedMemberLogin.Create(M_NeedToBeMember);
      end;
    end
    else if treatspecial <> #0 then
      raise ENeedSession.Create(M_NotAllowedAndLogged);

    if (Length(CustomCommand) > 0) and Assigned(OnCustomCommand) then
      // e.g. form input action=login
      if (Params.IndexOfName(CustomCommand) >= 0) then
      begin
        OnCustomCommand(self, HttpInfo,
          uppercase(Params.Values[CustomCommand]));
      end;
  end;

  if Assigned(AfterInitISAPISession) then
  begin
    AfterInitISAPISession(self);
  end;
end;

{ XXX ************************** }

procedure Tdws2WebLib.CloseIsapiSession;
begin
  if Assigned(BeforeCloseISAPISession) then
  begin
    BeforeCloseISAPISession(self);
  end;

  {  if Assigned(SessionManager) then
    begin
      ManageUserSession(FSessionManagerIntf);
    end;}

  if Assigned(AfterCloseISAPISession) then
  begin
    AfterCloseISAPISession(self);
  end;
end;

function Tdws2WebLib.ManageUserSession(SessionManager: ISessionManager): string;
var
  ustate: TSessionTrackingState;
begin
  result := '';
  if Assigned(SessionManager) then
  begin
    try
      ustate := SessionManager.LocateUserSession(FHttpInfo);
      if ustate = dssNoSession then
        result := 'NOP';
    except
      on e: Exception do
        result := e.ClassName + ' ' + e.Message;
    end;
  end;
end;

// ************************** Class-Methods *************************

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsParamEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.Params.Values[Info['Name']];
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsParamCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.Params.Count;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsParamNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.Params.Names[Integer(Info['Index'])];
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsParamValueEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  name: string;
begin
  name :=
    FHttpInfo.Params.Names[Integer(Info['Index'])];
  Info['Result'] :=
    FHttpInfo.Params.Values[name];
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsAuthorizationEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Authorization;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsContentEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Content;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsContentLengthEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.ContentLength;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsContentTypeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.ContentType;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsDateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Date;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsFromEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.From;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsHostEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Host;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsPathInfoEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.PathInfo;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsRefererEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Referer;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsRemoteAddrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.RemoteAddr;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsRemoteHostEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.RemoteHost;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsScriptNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.ScriptName;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsTitleEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Title;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsUrlEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.Url;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsUserAgentEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.UserAgent;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetAllowEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Allow := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetContentEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Content := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetContentEncodingEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.ContentEncoding := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetContentLengthEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.ContentLength := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetContentTypeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.ContentType := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetContentVersionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.ContentVersion := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetDateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Date := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetDerivedFromEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.DerivedFrom := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetExpiresEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Expires := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetLastModifiedEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.LastModified := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetLocationEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Location := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetLogMessageEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.LogMessage := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetRealmEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Realm := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetReasonStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.ReasonString := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetServerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Server := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetStatusCodeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.StatusCode := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetTitleEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Title := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSetVersionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.Version := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetAllowEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Allow;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetContentEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Content;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetContentEncodingEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.ContentEncoding;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetContentLengthEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.ContentLength;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetContentTypeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.ContentType;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetContentVersionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.ContentVersion;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetDateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Date;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetDerivedFromEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.DerivedFrom;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetExpiresEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Expires;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetLastModifiedEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.LastModified;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetLocationEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Location;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetLogMessageEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.LogMessage;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetRealmEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Realm;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetReasonStringEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.ReasonString;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetServerEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Server;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetStatusCodeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.StatusCode;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetTitleEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Title;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsGetVersionEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpResponse.Version;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsSendRedirectEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  FHttpInfo.HttpResponse.SendRedirect(Info['Uri']);
end;

procedure Tdws2WebLib.dws2WebUnitClassesScriptDocMethodsDateEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.ScriptDocDate;
end;

procedure Tdws2WebLib.dws2WebUnitClassesScriptDocMethodsSizeEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.ScriptDocSize;
end;

procedure Tdws2WebLib.dws2WebUnitClassesScriptDocMethodsFileNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.ScriptDocFileName;
end;

procedure Tdws2WebLib.dws2WebUnitClassesScriptDocMethodsPathEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.ScriptDocPath;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsSetDomainEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TCookie(ExtObject).Domain := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsSetExpiresEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TCookie(ExtObject).Expires := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsSetNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TCookie(ExtObject).Name := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsSetSecureEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TCookie(ExtObject).Secure := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsSetPathEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TCookie(ExtObject).Path := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsSetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TCookie(ExtObject).Value := Info['Value'];
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetDomainEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).Domain;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetExpiresEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).Expires;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetHeaderValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).HeaderValue;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).Name;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetSecureEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).Secure;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetPathEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).Path;
end;

procedure Tdws2WebLib.dws2WebUnitClassesTCookieMethodsGetValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TCookie(ExtObject).Value;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsCookieCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.CookieFields.Count;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsCookieEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.CookieFields.Values[Info['Name']];
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsCookieNameEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpRequest.CookieFields.Names[Info['Index']];
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsCookieValueEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  name: string;
begin
  name := FHttpInfo.HttpRequest.CookieFields.Names[Info['Index']];
  Info['Result'] :=
    FHttpInfo.HttpRequest.CookieFields.Values[name];
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsCookieCountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    FHttpInfo.HttpResponse.Cookies.Count;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsCookieEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['TCookie'].GetConstructor('Create',
    FHttpInfo.HttpResponse.Cookies[Info['Index']]
    ).Call.Value;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsCookieByNameEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  x: Integer;
  name: string;
  cookies: TCookieCollection;
begin
  name := Info['Name'];
  cookies := FHttpInfo.HttpResponse.Cookies;
  for x := 0 to cookies.Count - 1 do
    if AnsiSameText(cookies[x].Name, name) then
    begin
      Info['Result'] :=
        Info.Vars['TCookie'].GetConstructor('Create', cookies[x]).Call.Value;
      exit;
    end;
  Info['Result'] := 0;
end;

procedure Tdws2WebLib.dws2WebUnitClassesResponseMethodsNewCookieEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] :=
    Info.Vars['TCookie'].GetConstructor('Create',
    FHttpInfo.HttpResponse.Cookies.Add
    ).Call.Value;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsParamsEval(
  Info: TProgramInfo; ExtObject: TObject);
var
  x: Integer;
  name: string;
  strs, params: TStrings;
begin
  name := Info['Name'];
  strs := FHttpInfo.Params;
  params := TStringList.Create;
  for x := 0 to strs.Count - 1 do
    if AnsiSameText(strs.Names[x], name) then
    begin
      if Pos('=', strs[x]) > 0 then
        params.Add(Copy(strs[x], Pos('=', strs[x]) + 1, Length(strs[x])))
      else
        params.Add('');
    end;

  //  Info['Result'] := Info.Vars['TStrings'].GetConstructor('Create', params).Value;
  // changed by hannes to skip dependecy from ClassesLib!
  // with this change, function params is compatible to all DWS TStrings solutions (VCL, Classes..)

  Info['Result'] := params.Text;
  params.Free;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsLogContentEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with FHttpInfo.HttpRequest do
  begin
    Info['Result'] := 'ContentFields ' + ContentFields.Text + #10#13
      + 'QueryFields ' + QueryFields.Text + #10#13
      + 'Accept ' + Accept + #10#13
      + 'CacheControl ' + CacheControl + #10#13
      + 'Connection ' + Connection + #10#13
      + 'ContentEncoding ' + ContentEncoding + #10#13
      + 'ContentType ' + ContentType + #10#13
      + 'ContentVersion ' + ContentVersion + #10#13
      + 'Cookie ' + Cookie + #10#13
      + 'DerivedFrom ' + DerivedFrom + #10#13
      + 'From ' + From + #10#13
      + 'Host ' + Host + #10#13
      + 'Method ' + Method + #10#13
      + 'PathInfo ' + PathInfo + #10#13
      + 'PathTranslated ' + PathTranslated + #10#13
      + 'ProtocolVersion ' + ProtocolVersion + #10#13
      + 'Query ' + Query + #10#13
      + 'Referer ' + Referer + #10#13
      + 'RemoteAddr ' + RemoteAddr + #10#13
      + 'RemoteHost ' + RemoteHost + #10#13
      + 'ScriptName ' + ScriptName + #10#13
      + 'Title ' + Title + #10#13
      + 'URL ' + URL + #10#13
      + 'UserAgent ' + UserAgent + #10#13
      + 'Authorization ' + Authorization + #10#13;
  end;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsAcceptEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpRequest.Accept;
end;

procedure Tdws2WebLib.dws2WebUnitClassesRequestMethodsMethodEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := FHttpInfo.HttpRequest.Method;
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsRtfToHtmlEval(
  Info: TProgramInfo);
var
  sH: string;
begin
  sH := Info['RtfStr'];
  Info['Result'] := StringReplace(sH, #13, '<br>', [rfReplaceAll]);
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsFormVarEval(Info: TProgramInfo);
begin
  Info['Result'] :=
    FHttpInfo.Params.Values[Info['ParamName']];
end;

function Tdws2WebLib.ActivateDumpScript(DumpStr: string): string;
begin
  DumpStr := StringReplace(DumpStr, FDumpPatternOpen,
    Tdws2HtmlFilter(Script.Config.Filter).PatternOpen, [rfReplaceAll]);
  Result := StringReplace(DumpStr, FDumpPatternClose,
    Tdws2HtmlFilter(Script.Config.Filter).PatternClose, [rfReplaceAll]);
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsTrimURLEval(Info: TProgramInfo);
var
  sH: string;
begin
  sH := Info['sURL'];
  if pos('HTTP://', uppercase(sH)) = 1 then
    delete(sH, 1, 7);
  Info['Result'] := sH;
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsacceptWMLEval(
  Info: TProgramInfo);
begin
  if (pos('wml', FHttpInfo.HttpRequest.Accept) = 0) then
    Info['Result'] := false
  else
  begin
    Info['Result'] := true;
    FHttpInfo.HttpResponse.ContentType := 'text/vnd.wap.wml';
  end;
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsURLencodeEval(
  Info: TProgramInfo);
var
  i, iMax: Integer;
  sH, sURL: string;
begin
  sH := '';
  sURL := Info['sURL'];
  iMax := Length(sURL);
  for i := 1 to iMax do
    if sURL[i] < #64 then
      sH := sH + '%' + IntToHex(Ord(sURL[i]), 2)
    else
      sH := sH + sURL[i];
  Info['Result'] := sH;
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsURLdecodeEval(
  Info: TProgramInfo);
var
  ch: Char;
  sURL, sH: string;
  i: Integer;
begin
  sURL := Info['sURL'];
  i := Pos('%', sURL);
  while i > 0 do
  begin
    sH := '$' + Copy(sURL, i + 1, 2);
    Ch := Char(StrToInt(sH));
    sURL := Copy(sURL, 1, i - 1) + Ch + Copy(sURL, i + 3, Length(sURL));
    i := Pos('%', sURL);
  end;
  i := Pos('+', sURL);
  while i > 0 do
  begin
    sURL := Copy(sURL, 1, i - 1) + #32 + Copy(sURL, i + 1, Length(sURL));
    i := Pos('+', sURL);
  end;
  Info['Result'] := sURL;
end;

procedure Tdws2WebLib.dws2WebUnitFunctionsforwardEval(Info: TProgramInfo);
begin
  raise EForward.Create(Info['Newfile']);
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupConstructorsCreateAssignExternalObject(
  Info: TProgramInfo; var ExtObject: TObject);
begin
  ExtObject := TFormVarGroupObj.create(TStringList(FHttpInfo.Params));
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsSetPrefixEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TFormVarGroupObj(ExtObject).Prefix := Info['Prefix'];
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsGetPrefixEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TFormVarGroupObj(ExtObject).Prefix;
end;

procedure
  Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsSetAddNullFieldsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TFormVarGroupObj(ExtObject).AddNullFields := Info['Value'];
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodscountEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TFormVarGroupObj(ExtObject).Count;
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsExtEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TFormVarGroupObj(ExtObject).Ext;
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsValueEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TFormVarGroupObj(ExtObject).Value;
end;

procedure
  Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsGetAddNullFieldsEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TFormVarGroupObj(ExtObject).AddNullFields;
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsEofEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  with TFormVarGroupObj(ExtObject) do
    Info['Result'] := (RecNr >= Count) or (RecNr < 0);
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsFirstEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TFormVarGroupObj(ExtObject).RecNr := 0;
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsNextEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  TFormVarGroupObj(ExtObject).RecNr := TFormVarGroupObj(ExtObject).RecNr + 1;
end;

procedure Tdws2WebLib.customWebUnitClassesTFormVarGroupMethodsRecNrEval(
  Info: TProgramInfo; ExtObject: TObject);
begin
  Info['Result'] := TFormVarGroupObj(ExtObject).RecNr;
end;

procedure Tdws2WebLib.SetNeedLoginDWSErrorFile(const Value: string);
begin
  FNeedLoginDWSErrorFile := Value;
end;

procedure Tdws2WebLib.SetNeedMemberLoginDWSErrorFile(const Value: string);
begin
  FNeedMemberLoginDWSErrorFile := Value;
end;

procedure Tdws2WebLib.SetNeedSessionDWSErrorFile(const Value: string);
begin
  FNeedSessionDWSErrorFile := Value;
end;

end.

