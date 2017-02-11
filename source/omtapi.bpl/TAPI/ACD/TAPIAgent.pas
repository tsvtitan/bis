{******************************************************************************}
{*        Copyright 1999-2001 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5                                     *}
{*        System          :  Windows NT / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  26.03.2001                                       *}
{*        Version         :  0.01                                             *}
{*        EMail           :  tapi@delphiclub.de                               *}
{******************************************************************************}
{*                                                                            *}
{*    This File is free software; You can redistribute it and/or modify it    *}
{*    under the term of GNU Library General Public License as published by    *}
{*    the Free Software Foundation. This File is distribute in the hope       *}
{*    it will be useful "as is", but WITHOUT ANY WARRANTY OF ANY KIND;        *}
{*    See the GNU Library Public Licence for more details.                    *}
{*                                                                            *}
{******************************************************************************}
{*                                                                            *}
{*    Diese Datei ist Freie-Software. Sie können sie weitervertreiben         *}
{*    und/oder verändern im Sinne der Bestimmungen der "GNU Library GPL"      *}
{*    der Free Software Foundation. Diese Datei wird,"wie sie ist",           *}
{*    zur Verfügung gestellt, ohne irgendeine GEWÄHRLEISTUNG                  *}
{*                                                                            *}
{******************************************************************************}
{*                          www.delphiclub.de                                 *}
{******************************************************************************}
unit TAPIAgent;

interface

uses Windows,Classes,TAPI,TAPISystem ,TAPIServices, TAPIAddress,TAPIHelpFunc;

{$INCLUDE TAPI.INC}
{$INCLUDE TAPISVR.INC}

{$IFDEF TAPI20}
type
  TLineAgentFeature =(lagfSetAgentGroup,lagfSetAgentState,lagfSetAgentActivity,
    lagfAgentSpecific,lagfGetAgentActivityList,lagfGetAgentGroup);
  TLineAgentFeatures= Set of TLineAgentFeature;

  TLineAgentState = (lagsLoggedOff,lagsNotReady,lagsReady,lagsBusyACD,
    lagsBusyIncoming,lagsBusyOutBound,lagsBusyOther,lagsWorkingAfterCall,
    lagsUnknown,lagsUnavail);
  TLineAgentStates= set of TLineAgentState;

  TLineAgentStatusMsgs = set of (agsGroup,agsState,agsNextState,agsActivity,agsActivityList,
     agsGroupList,agsCapsChange,agsValidStates,agsValidNextStates);


  type
  TAgentGroupEntry = class(TCollectionItem)
  private
    FGroupID1:DWord;
    FGroupID2:DWord;
    FGroupID3:DWord;
    FGroupID4:DWord;
    FName:String;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy;override;
    property GroupID1:DWord read FGroupID1 write FGroupID1;
    property GroupID2:DWord read FGroupID2 write FGroupID2;
    property GroupID3:DWord read FGroupID3 write FGroupID3;
    property GroupID4:DWord read FGroupID4 write FGroupID4;
    property Name:String read FName write FName;
  end;

  TAgentGroupList = class(TCollection)
  private
  public
    constructor Create(ItemClass: TCollectionItemClass);overload;
    constructor Create(LineAgentGroupList:TLineAgentGroupList);overload;
    destructor Destroy; override;
    function Add: TCollectionItem;
    procedure Assign(Source: TPersistent); override;
  end;


  TAgentStatus=class(TPersistent)
  private
    FGroupList:TAgentGroupList;
    FState:TLineAgentState;
    FNextState:TLineAgentState;
    FActivityID:DWord;
    FFeatures:TLineAgentFeatures;
    FActivity:String;
    FValidStates:TLineAgentStates;
    FValidNextStates:TLineAgentStates;
  public
    constructor Create;
    destructor Destroy;override;
    procedure GetStatus(var Status:PLineAgentStatus);
    property State:TLineAgentState read FState write FState;
    property NextState:TLineAgentState read FNextState write FNextState;
    property ActivityID:DWord read FActivityID write FActivityID;
    property Activity:String read FActivity write FActivity;
    property Features:TLineAgentFeatures read FFeatures write FFeatures;
    property ValidStates:TLineAgentStates read FValidStates write FValidStates;
    property ValidNextStates:TLineAgentStates read FValidNextStates write FValidNextStates;
  end;

  TAgentActivityEntry  = class(TCollectionItem)
  private
    FID:DWord;
    FName: String;
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy;override;
    property ID:DWord read FID  write FID default 0;
    property Name: String read FName  write FName ;
  end;

  TAgentActivityList =class(TCollection)
  private
    function GetItem(Index: Integer): TAgentActivityEntry;
    procedure SetItem(Index: Integer; const Value: TAgentActivityEntry);
    //function ClassName: ShortString;
  public
    property Items[Index:Integer]:TAgentActivityEntry read GetItem write SetItem;
    procedure GetList(var ActivityList:TLineAgentActivityList);
    function Add:TAgentActivityEntry;

  end;

  TAgentCaps=class(TPersistent)
  private
    FLineAgentCaps:PLineAgentCaps;
    FAgentHandlerInfo:String;
    FCapsVersion:DWord;
    FFeatures:TLineAgentFeatures;
    FStates:TLineAgentStates;
    FNextStates:TLineAgentStates;
    FMaxNumGroupEntries:DWord;
    FAgentStatusMessages:TLineAgentStatusMsgs;
    FNumAgentExtensionIDs:DWord;
    FAgentExtensionIDList:Array of TLineExtensionID;
    {$IFDEF TAPI22}
    FProxyGUID: TGUID;
    {$ENDIF}
    function GetLineExtensionIDList(Index: Integer): TLineExtensionID;
    procedure SetCaps(Caps:PLineAgentCaps);
  public
    constructor Create;overload;
    constructor Create(ALineApp:HLineApp;ADeviceID,AAddressID,AAPIVersion:DWord);overload;
    destructor Destroy;override;
    procedure GetCaps(var Proxy: PLineProxyRequest);
    procedure Reply(AsyncFunc:TAsyncFunc;Error:DWord);
    property AgentHandlerInfo:String read FAgentHandlerInfo write FAgentHandlerInfo;
    property CapsVersion:DWord read  FCapsVersion write FCapsVersion;
    property Features:TLineAgentFeatures read FFeatures write FFeatures;
    property States:TLineAgentStates read FStates write FStates;
    property NextStates:TLineAgentStates read FNextStates write FNextStates;
    property MaxNumGroupEntries:DWord read FMaxNumGroupEntries;
    property AgentStatusMessages:TLineAgentStatusMsgs read FAgentStatusMessages write FAgentStatusMessages;
    property NumAgentExtensionIDs:DWord read FNumAgentExtensionIDs;
    property AgentExtensionIDList[Index:Integer]:TLineExtensionID read GetLineExtensionIDList;
    {$IFDEF TAPI22}
    property ProxyGUID: TGUID read FProxyGUID;
    {$ENDIF}
  published
  end;



type
  TTAPILineAgent = class(TTAPIComponent)
  private
    FAddress:TTAPIAddress;
    FAgentCaps:TAgentCaps;
    FAgentActivityList:TAgentActivityList;
    FConnected:Boolean;
    // Events
    FOnCapsChange:TNotifyEvent;
    FOnDisconnect:TNotifyEvent;
    //
    function GetCaps: TAgentCaps;
    //procedure SetCaps(const Value: TAgentCaps);
    procedure SetAddress(const Value: TTAPIAddress);
    function GetConnected: Boolean;
    //procedure SetCaps(const Value: TAgentCaps);
    procedure SetConnected(const Value: Boolean);
  protected
    procedure Notification(AComponent:TComponent; Operation :TOperation); override;
  public
    constructor Create(Owner:TComponent);override;
    destructor Destroy;override;
    procedure CapsChange;
    procedure Close;
    procedure PerformMsg(Msg: TCMTAPI);override;
    property Caps:TAgentCaps read GetCaps;
    property Connected:Boolean read GetConnected write SetConnected default False;
  published
    property Address:TTAPIAddress read FAddress write SetAddress;
    //property Specific:
    property AgentActivityList:TAgentActivityList read FAgentActivityList write FAgentActivityList;
    property OnCapsChange:TNotifyEvent read FOnCapsChange write FOnCapsChange;
    property OnDisconnect:TNotifyEvent read FOnDisconnect write FOnDisconnect;
  end;

function LineAgentFeaturesToInt(Value:TLineAgentFeatures):DWord;
function LineAgentStatesToInt(Value:TLineAgentStates):DWord;
function LineAgentStateToInt(Value:TLineAgentState):DWord;
function LineAgentStatusMsgsToInt(Value: TLineAgentStatusMsgs):DWord;

procedure Register;
{$ENDIF}

implementation

uses SysUtils,Forms,TAPIErr{$IFDEF VER120},D4Comp{$ENDIF};

{$IFDEF TAPI20}
procedure Register;
begin
{$IFDEF TAPI30}
  RegisterComponents('TAPI30', [TTAPILineAgent]);
{$ELSE}
{$IFDEF TAPI22}
  RegisterComponents('TAPI22', [TTAPILineAgent]);
{$ELSE}
{$IFDEF TAPI21}
  RegisterComponents('TAPI21', [TTAPILineAgent]);
{$ELSE}
{$IFDEF TAPI20}
  RegisterComponents('TAPI20', [TTAPILineAgent]);
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;


function LineAgentFeaturesToInt(Value:TLineAgentFeatures):DWord;
begin
  Result:=0;
  if lagfSetAgentGroup in Value then Result:=Result+LINEAGENTFEATURE_SETAGENTGROUP ;
  if lagfSetAgentState in Value then Result:=Result+LINEAGENTFEATURE_SETAGENTSTATE ;
  if lagfSetAgentActivity in Value then Result:=Result+ LINEAGENTFEATURE_SETAGENTACTIVITY;
  if lagfAgentSpecific in Value then Result:=Result+LINEAGENTFEATURE_AGENTSPECIFIC ;
  if lagfGetAgentActivityList in Value then Result:=Result+LINEAGENTFEATURE_GETAGENTACTIVITYLIST ;
  if lagfGetAgentGroup in Value then Result:=Result+LINEAGENTFEATURE_GETAGENTGROUP ;
end;

function LineAgentStatesToInt(Value:TLineAgentStates):DWord;
begin
  Result:=0;
  if lagsLoggedOff in Value then Result:=Result+ LINEAGENTSTATE_LOGGEDOFF;
  if lagsNotReady in Value then Result:=Result+ LINEAGENTSTATE_NOTREADY;
  if lagsReady in Value then Result:=Result+ LINEAGENTSTATE_READY;
  if lagsBusyACD in Value then Result:=Result+ LINEAGENTSTATE_BUSYACD;
  if lagsBusyIncoming in Value then Result:=Result+ LINEAGENTSTATE_BUSYINCOMING;
  if lagsBusyOutBound in Value then Result:=Result+ LINEAGENTSTATE_BUSYOUTBOUND;
  if lagsBusyOther in Value then Result:=Result+ LINEAGENTSTATE_BUSYOTHER;
  if lagsWorkingAfterCall in Value then Result:=Result+ LINEAGENTSTATE_WORKINGAFTERCALL;
  if lagsUnknown in Value then Result:=Result+ LINEAGENTSTATE_UNKNOWN;
  if lagsUnavail in Value then Result:=Result+ LINEAGENTSTATE_UNAVAIL;
end;

function LineAgentStateToInt(Value:TLineAgentState):DWord;
begin
  Result:=0;
  case Value of
    lagsLoggedOff:Result:=LINEAGENTSTATE_LOGGEDOFF;
    lagsNotReady:Result:=LINEAGENTSTATE_NOTREADY;
    lagsReady:Result:=LINEAGENTSTATE_READY;
    lagsBusyACD:Result:=LINEAGENTSTATE_BUSYACD;
    lagsBusyIncoming:Result:=LINEAGENTSTATE_BUSYINCOMING;
    lagsBusyOutBound:Result:=LINEAGENTSTATE_BUSYOUTBOUND;
    lagsBusyOther:Result:=LINEAGENTSTATE_BUSYOTHER;
    lagsWorkingAfterCall:Result:=LINEAGENTSTATE_WORKINGAFTERCALL;
    lagsUnknown:Result:=LINEAGENTSTATE_UNKNOWN;
    lagsUnavail:Result:=LINEAGENTSTATE_UNAVAIL;
  end;
end;

function LineAgentStatusMsgsToInt(Value: TLineAgentStatusMsgs):DWord;
begin
  Result:=0;
  if agsGroup in Value then Result:=Result+LINEAGENTSTATUS_GROUP;
  if agsState in Value then Result:=Result+LINEAGENTSTATUS_STATE;
  if agsNextState in Value then Result:=Result+LINEAGENTSTATUS_NEXTSTATE;
  if agsActivity in Value then Result:=Result+LINEAGENTSTATUS_ACTIVITY;
  if agsActivityList in Value then Result:=Result+LINEAGENTSTATUS_ACTIVITYLIST;
  if agsGroupList in Value then Result:=Result+LINEAGENTSTATUS_GROUPLIST;
  if agsCapsChange in Value then Result:=Result+LINEAGENTSTATUS_CAPSCHANGE;
  if agsValidStates in Value then Result:=Result+LINEAGENTSTATUS_VALIDSTATES;
  if agsValidNextStates in Value then Result:=Result+LINEAGENTSTATUS_VALIDNEXTSTATES;
end;

{ TAgentGroupList }

function TAgentGroupList.Add: TCollectionItem;
begin
  result:=TAgentGroupEntry(inherited Add);
end;

procedure TAgentGroupList.Assign(Source: TPersistent);
begin
  inherited;
end;

constructor TAgentGroupList.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(TAgentGroupEntry);
end;

constructor TAgentGroupList.Create(LineAgentGroupList:TLineAgentGroupList);
begin
  inherited Create(TAgentGroupEntry);
end;

destructor TAgentGroupList.Destroy;
begin
  inherited;
end;

{ TAgentGroupEntry }

constructor TAgentGroupEntry.Create(Collection: TCollection);
begin
  inherited;
end;

destructor TAgentGroupEntry.Destroy;
begin
  inherited;
end;


{ TAgentCaps }

constructor TAgentCaps.Create;
begin
  inherited Create;
end;  

constructor TAgentCaps.Create(ALineApp:HLineApp;ADeviceID,AAddressID,AAPIVersion:DWord);
var Size:DWord;
    R:LongWord;
begin
  inherited Create;
  if Assigned(AppTAPIMgr)=False then AppTAPIMgr := TTAPIMgr.Create(Application);
  AppTAPIMgr.TAPIObjects.Add(self);
  Size:=SizeOf(TLineAgentCaps)+1000;
  try
    GetMem(PLINEAGENTCAPS(FLineAgentCaps),Size);
    FillChar(FLineAgentCaps^,Size,#0);
    FLineAgentCaps.dwTotalSize:=Size;
    R:=LineGetAgentCaps(ALineApp,ADeviceID,AAddressID,AAPIVersion,FLineAgentCaps);
    if DWord(R)> DWord($80000000) then
    begin
      RaiseTAPILineError(R);
    end
    else
    begin
      AppTAPIMgr.AsyncList.Add(afGetAgentCaps,R,self);
    end;
  finally
    //FreeMem(FLineAgentCaps);
  end;
end;

destructor TAgentCaps.Destroy;
begin
  FreeMem(FLineAgentCaps);
  inherited;
end;

procedure TAgentCaps.GetCaps(var Proxy: PLineProxyRequest);
var Offset:DWord;
begin
  Offset:=SizeOf(TLineAgentCaps)+1;

  with Proxy^.GetAgentCaps do
  begin
    AgentCaps.dwAgentHandlerInfoOffset:=Offset;
    // -- UNICODE --
    StringToWideChar(FAgentHandlerInfo,PWideChar(PChar(@AgentCaps)+offset),(Length(FAgentHandlerInfo)*2)+1);
    AgentCaps.dwAgentHandlerInfoSize:=Length(PWideChar(PChar(@AgentCaps)+offset))*2;
    Offset:=Offset+AgentCaps.dwAgentHandlerInfoSize;
    AgentCaps.dwUsedSize:=Offset;
    AgentCaps.dwNeededSize:=Offset;
    AgentCaps.dwCapsVersion:=FCapsVersion;
    AgentCaps.dwFeatures:=LineAgentFeaturesToInt(FFeatures);
    AgentCaps.dwStates:=LineAgentStatesToInt(FStates);
    AgentCaps.dwNextStates:=LineAgentStatesToInt(FNextStates);
    AgentCaps.dwMaxNumGroupEntries:=FMaxNumGroupEntries;
    AgentCaps.dwAgentStatusMessages:=LineAgentStatusMsgsToInt(FAgentStatusMessages);
    AgentCaps.dwNumAgentExtensionIDs:=0;// nicht unterstützt
    AgentCaps.dwAgentExtensionIDListSize:=0;
    AgentCaps.dwAgentExtensionIDListOffset:=0;
    {$IFDEF TAPI22}
    // Const - TAPISVR.INC !
    AgentCaps.ProxyGUID:=SvrGUID;
    {$ENDIF}
  end;
end;

function TAgentCaps.GetLineExtensionIDList(
  Index: Integer): TLineExtensionID;
begin
  Result:=FAgentExtensionIDList[Index];
end;

procedure TAgentCaps.Reply(AsyncFunc:TAsyncFunc;Error:DWord);
begin
   if Error = 0 then
     SetCaps(FLineAgentCaps);
end;

procedure TAgentCaps.SetCaps(Caps: PLineAgentCaps);
var Dummy:Array of byte;
begin
  if Caps^.dwAgentHandlerInfoSize > 0 then
  begin
    SetLength(Dummy,Caps^.dwAgentHandlerInfoSize);
    StrCopy(PChar(Dummy),Pchar(Caps)+Caps^.dwAgentHandlerInfoOffset);
    FAgentHandlerInfo:=PChar(Dummy);
  end
  else FAgentHandlerInfo:='';

  FCapsVersion:=Caps^.dwCapsVersion;
  //FFeatures:=TLineAgentFeatures(FLineAgentCaps^.dwFeatures);
  //FStates:=IntToAgentStates(
  //FNextStates:=IntToAgentStates(
  FMaxNumGroupEntries:=Caps^.dwMaxNumGroupEntries;
  //FAgentStatusMessages,
  //FNumAgentExtensionIDs,
  //FAgentExtensionIDList
  {$IFDEF TAPI22}
  FProxyGUID:=Caps^.ProxyGUID;
  {$ENDIF}
  //FLineAgentCaps.dwAgentHandlerInfoSize
   { dwAgentHandlerInfoSize,                              // TAPI v2.0
    dwAgentHandlerInfoOffset,                            // TAPI v2.0
    dwCapsVersion,                                       // TAPI v2.0
    dwFeatures,                                          // TAPI v2.0
    dwStates,                                            // TAPI v2.0
    dwNextStates,                                        // TAPI v2.0
    dwMaxNumGroupEntries,                                // TAPI v2.0
    dwAgentStatusMessages,                               // TAPI v2.0
    dwNumAgentExtensionIDs,                              // TAPI v2.0
    dwAgentExtensionIDListSize,                          // TAPI v2.0
    dwAgentExtensionIDListOffset: DWORD;                 // TAPI v2.0}
end;



{ TTAPILineAgent }

procedure TTAPILineAgent.CapsChange;
begin
  if Assigned(FOnCapsChange) then FOnCapsChange(Self);
end;

procedure TTAPILineAgent.Close;
begin
  SetConnected(False);
  if Assigned(FOnDisconnect) then FOnDisconnect(Self);
end;

constructor TTAPILineAgent.Create(Owner: TComponent);
begin
  inherited;
  FConnected:=False;
  FAgentActivityList:=TAgentActivityList.Create(TAgentActivityEntry);
end;

destructor TTAPILineAgent.Destroy;
begin
  FAgentActivityList.Free;
  FAgentCaps.Free;
  inherited;
end;

function TTAPILineAgent.GetCaps: TAgentCaps;
begin
  Result:=FAgentCaps;
end;


{procedure TTAPILineAgent.LineProxyRequest(dwParam1, dwParam2, dwParam3:DWord);
var ARequest:TLineProxyRequest;
    Size:DWord;
begin
  ARequest:=PLINEPROXYREQUEST(dwParam1)^;
  case ARequest.dwRequestType of
    4: Begin
         //if Assigned(FOnProxyRequestGetCaps) then FOnProxyRequestGetCaps(self);
         //Size:=ARequest.GetAgentCaps.AgentCaps.dwTotalSize;
        //ARequest.GetAgentCaps.AgentCaps.dwNeededSize:=Size;
        //ARequest.GetAgentCaps.AgentCaps.dwUsedSize:=Size;
        Caps.GetCaps(ARequest.GetAgentCaps.AgentCaps);
      end;
    5:begin
        //if Assigned(FOnProxyRequestGetStatus) then FOnProxyRequestGetStatus(self);
        //ARequest.GetAgentStatus.dwAddressID;
        //ARequest.GetAgentStatus.AgentStatus.
      end;
  end;

end; }

{procedure TTAPILineAgent.SetAddressID(const Value: DWord);
begin
  if Value <> FAdressID then
  begin
    FAddressID := Value;
    FreeAndNil(FAgentCaps);
  end;
end; }

function TTAPILineAgent.GetConnected: Boolean;
begin
  Result:=FConnected;
end;

procedure TTAPILineAgent.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) and (AComponent=FAddress) then
    FAddress:=nil;
end;

procedure TTAPILineAgent.PerformMsg(Msg: TCMTAPI);
begin
  inherited;
  with Msg.TAPIRec^ do
  begin
    case dwMsg of
      LINE_AGENTSPECIFIC:;
      LINE_AGENTSTATUS:;
    end
  end;
end;

procedure TTAPILineAgent.SetAddress(const Value: TTAPIAddress);
begin
  if Value <> FAddress then
  begin
    FAddress := Value;
    SetConnected(False);
  end;
end;

procedure TTAPILineAgent.SetConnected(const Value: Boolean);
begin
  if Value<>FConnected then
  begin
    if Value then
    begin
      with FAddress.Line.Device do
      begin
        try
          FAgentCaps:=TAgentCaps.Create(Service.Handle,ID,FAddress.ID,APIVersion);
          FConnected:=True;
        except
          FConnected:=False;
          Raise;
        end;
      end;
    end
    else
    begin
      FreeAndNil(FAgentCaps);
      FConnected:=False;
    end;
  end;
end;

{ TAgentStatus }

constructor TAgentStatus.Create;
begin
  inherited Create;
  FGroupList:=TAgentGroupList.Create(TAgentGroupEntry);
end;

destructor TAgentStatus.Destroy;
begin
  FGroupList.Free;
  inherited;
end;

procedure TAgentStatus.GetStatus(var Status: PLineAgentStatus);
var Offset:DWord;

begin
  Offset:=SizeOf(TLineAgentStatus)+1;
  Status.dwNumEntries:=FGroupList.Count;
  Status.dwGroupListSize:=0;
  Status.dwGroupListOffset:=0;
  Status.dwState:=LineAgentStateToInt(FState);
  Status.dwNextState:=LineAgentStateToInt(FNextState);
  Status.dwActivityID:=FActivityID;
  Status.dwActivitySize:=Length(FActivity);
  Status.dwActivityOffset:=Offset;
  StrCopy(PChar(Status)+Offset,PChar(FActivity));
  Offset:=Offset+DWord(Length(FActivity)+1);
  Status.dwAgentFeatures:=LineAgentFeaturesToInt(FFeatures);
  Status.dwValidStates:=LineAgentStatesToInt(FValidStates);
  Status.dwValidNextStates:=LineAgentStatesToInt(FValidNextStates);
  Status.dwNeededSize:=Offset;
  Status.dwUsedSize:=Offset;
end;



{ TAgentActivityEntry }

constructor TAgentActivityEntry.Create(Collection: TCollection);
begin
  inherited;
  FID:=0;
  FName:='';
end;

destructor TAgentActivityEntry.Destroy;
begin
  inherited;

end;

{ TAgentActivityList }

function TAgentActivityList.Add: TAgentActivityEntry;
begin
  Result:=TAgentActivityEntry(inherited Add);
end;

{function TAgentActivityList.ClassName: ShortString;
begin
  Result:='TAgentActivityList';
end;}

function TAgentActivityList.GetItem(Index: Integer): TAgentActivityEntry;
begin
  result:=TAgentActivityEntry(inherited Items[Index]);
end;

procedure TAgentActivityList.GetList(var ActivityList: TLineAgentActivityList);
var Offset,SubOffset:DWord;
    i:Integer;
    Size:DWord;
begin
  Offset:=SizeOf(TLineAgentActivityList)-SizeOf(TLineAgentActivityEntry);
  ActivityList.dwNumEntries:=Count;
  ActivityList.dwListSize:=SizeOf(TLineAgentActivityEntry)*Count;
  ActivityList.dwListOffset:=SizeOf(TLineAgentActivityList);
  SubOffset:=SizeOf(TLineAgentActivityList)+(SizeOf(TLineAgentActivityEntry)*DWord(Count));
  for i:=0 to Count-1 do
  begin
    Offset:=Offset+(SizeOf(TLineAgentActivityEntry));
    StrCopy(PChar(@ActivityList)+Offset,@Items[i].ID);
    //SubOffset:=Offset+12;
    StringToWideChar(Items[i].Name,PWideChar(PChar(@ActivityList)+SubOffset),Length(Items[i].Name+#0));
    Size:=Length(PWideChar(PChar(@ActivityList)+SubOffset))*2;
    StrCopy(PChar(@ActivityList)+Offset+4,@Size);
    StrCopy(PChar(@ActivityList)+Offset+8,@SubOffset);
    SubOffset:=SubOffset+Size;
  end;
  ActivityList.dwNeededSize:=Offset+SubOffset+(2*DWord(Length(PWideChar(PChar(@ActivityList)+SubOffset))));
  ActivityList.dwUsedSize:=Offset+SubOffset+(2*DWord(Length(PWideChar(PChar(@ActivityList)+SubOffset))));
end;


procedure TAgentActivityList.SetItem(Index: Integer;
  const Value: TAgentActivityEntry);
begin
  inherited SetItem(Index,Value)
end;
{$ENDIF}
end.
