{******************************************************************************}
{*        Copyright 1999-2001 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 5                                         *}
{*        System          :  Windows NT / 2000                                *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 3.0)      *}
{*        Last Update     :  26.05.2002                                       *}
{*        Version         :  1.2                                              *}
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
unit ACDProxy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TAPI,TAPISystem ,TAPIAddress,TAPIAgent;

{$INCLUDE TAPI.INC}

{$IFDEF TAPI20}

type
  TACDClient = class(TPersistent)
  private
    FMachineName:String;
    FUserName:String;
    FAppAPIVersion:DWord;
  public
    constructor Create(ProxyRequest:PLineProxyRequest);
    destructor Destroy;override;
    property MachineName:String read FMachineName;
    property UserName:String read FUserName;
    property AppAPIVersion:DWord read FAppAPIVersion;
  end;

  TProxyRequestSetAgentGroup=procedure(Sender:TObject;Client:TACDClient;AddressID:DWord;GroupList:TAgentGroupList)of Object;
  TProxyRequestSetAgentState=procedure(Sender:TObject;Client:TACDClient;AddressID:DWord;AgentState:TLineAgentState;NextAgentState: TLineAgentState) of Object;
  TProxyRequestSetAgentActivity=procedure(Sender:TObject;Client:TACDClient;AddressID,ActivityID:DWord)of Object;
  TProxyRequestGetAgentCaps=procedure(Sender:TObject;Client:TACDClient;AddressID:DWord;AgentCaps:TAgentCaps)of Object;
  TProxyRequestGetAgentStatus=procedure (Sender:TObject;Client:TACDClient;AddressID:DWord;AgentStatus:TAgentStatus)of Object;
  TProxyRequestAgentSpecific=procedure (Sender:TObject;Client:TACDClient;AddressID,AgentExtensionIDIndex:DWord;Params:Array of Byte)of object;
  TProxyRequestGetAgentActivityList=procedure (Sender:TObject;Client:TACDClient;AddressID:DWord;AgentActivityList:TAgentActivityList)of Object;


  TTAPIProxy = class(TTAPIComponent)
  private
    FOnRequestSetAgentGroup:TProxyRequestSetAgentGroup;
    FOnRequestSetAgentState:TProxyRequestSetAgentState;
    FOnRequestSetAgentActivity:TProxyRequestSetAgentActivity;
    FOnRequestGetAgentCaps:TProxyRequestGetAgentCaps;
    FOnRequestGetAgentStatus:TProxyRequestGetAgentStatus;
    FOnRequestAgentSpecific:TProxyRequestAgentSpecific;
    FOnRequestGetAgentActivityList:TProxyRequestGetAgentActivityList;
    FAddress: TTAPIAddress;
     procedure LineProxyRequest(var dwParam1,dwParam2,dwParam3:DWord);
  protected
    procedure Notification(AComponent:TComponent; Operation :TOperation); override;
  public
    procedure PerformMsg(Msg: TCMTAPI);override;
  published
    property OnRequestSetAgentGroup:TProxyRequestSetAgentGroup read FOnRequestSetAgentGroup write FOnRequestSetAgentGroup;
    property OnRequestSetAgentState:TProxyRequestSetAgentState read FOnRequestSetAgentState write FOnRequestSetAgentState;
    property OnRequestSetAgentActivity:TProxyRequestSetAgentActivity read FOnRequestSetAgentActivity write FOnRequestSetAgentActivity;
    property OnRequestGetAgentCaps:TProxyRequestGetAgentCaps read FOnRequestGetAgentCaps write FOnRequestGetAgentCaps;
    property OnRequestGetAgentStatus:TProxyRequestGetAgentStatus read FOnRequestGetAgentStatus write FOnRequestGetAgentStatus ;
    property OnRequestAgentSpecific:TProxyRequestAgentSpecific read FOnRequestAgentSpecific write FOnRequestAgentSpecific ;
    property OnRequestGetAgentActivityList:TProxyRequestGetAgentActivityList read FOnRequestGetAgentActivityList write FOnRequestGetAgentActivityList ;
    property Address:TTAPIAddress read FAddress write FAddress;
  end;

function IntToLineAgentState(Value:LongWord):TLineAgentState;

procedure Register;

{$ENDIF}

implementation

{$IFDEF TAPI20}

procedure Register;
begin
{$IFDEF TAPI30}
  RegisterComponents('TAPI30', [TTAPIProxy]);
{$ELSE}
{$IFDEF TAPI22}
  RegisterComponents('TAPI22', [TTAPIProxy]);
{$ELSE}
{$IFDEF TAPI21}
  RegisterComponents('TAPI21', [TTAPIProxy]);
{$ELSE}
{$IFDEF TAPI20}
  RegisterComponents('TAPI20', [TTAPIProxy]);
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;

function IntToLineAgentState(Value:LongWord):TLineAgentState;
begin
  result:=lagsUnknown;
  case Value of
    LINEAGENTSTATE_LOGGEDOFF:Result:=lagsLoggedOff;
    LINEAGENTSTATE_NOTREADY:Result:=lagsNotReady;
    LINEAGENTSTATE_READY:Result:=lagsReady;
    LINEAGENTSTATE_BUSYACD:Result:=lagsBusyACD;
    LINEAGENTSTATE_BUSYINCOMING:Result:=lagsBusyIncoming;
    LINEAGENTSTATE_BUSYOUTBOUND:Result:=lagsBusyOutBound;
    LINEAGENTSTATE_BUSYOTHER:Result:=lagsBusyOther;
    LINEAGENTSTATE_WORKINGAFTERCALL:Result:=lagsWorkingAfterCall;
    LINEAGENTSTATE_UNKNOWN:Result:=lagsUnknown;
    LINEAGENTSTATE_UNAVAIL:Result:=lagsUnavail;
  end;
end;

{ TTAPIProxy }

procedure TTAPIProxy.LineProxyRequest(var dwParam1, dwParam2, dwParam3: DWord);
var ARequest:PLineProxyRequest;
    Client:TACDClient;
    AgentGroupList:TAgentGroupList;
    AgentCaps:TAgentCaps;
    //ACaps:TLineAgentCaps;
    AStatus:PLineAgentStatus;
    AgentStatus:TAgentStatus;
    AgentActivityList:TAgentActivityList;
begin
  Client:=TACDClient.Create(PLineProxyRequest(Pointer(dwParam1)));
  ARequest:=PLineProxyRequest(dwParam1);
  case ARequest^.dwRequestType-1 of
    0: begin
         // SetAgentGroup
         AgentGroupList:=TAgentGroupList.Create(ARequest.SetAgentGroup.GroupList);
         if Assigned(FOnRequestSetAgentGroup) then FOnRequestSetAgentGroup(self,Client,ARequest.SetAgentGroup.dwAddressID,AgentGroupList);
         AgentGroupList.Free;
       end;
    1: begin
         // SetAgentState
         if Assigned(FOnRequestSetAgentState) then FOnRequestSetAgentState(self,Client,ARequest.SetAgentState.dwAddressID,IntToLineAgentState(ARequest.SetAgentState.dwAgentState),IntToLineAgentState(ARequest.SetAgentState.dwNextAgentState));
       end;
    2: begin
         // SetAgentActivity
         if Assigned(FOnRequestSetAgentActivity) then FOnRequestSetAgentActivity(self,Client,ARequest.SetAgentActivity.dwAddressID,ARequest.SetAgentActivity.dwActivityID);

       end;
    3: begin
         // GetAgentCaps
         //if Assigned(AgentCaps)=False then
         AgentCaps:=TAgentCaps.Create;
         if Assigned(FOnRequestGetAgentCaps) then FOnRequestGetAgentCaps(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
         //StrCopy(PChar(@ACaps),PChar(@ARequest.GetAgentCaps.AgentCaps));
         //AgentCaps.GetCaps(ACaps);
         AgentCaps.GetCaps(ARequest);
         AgentCaps.Free;
       end;
    4: begin
         //GetAgentStatus
         AgentStatus:=TAgentStatus.Create;
         if Assigned(FOnRequestGetAgentStatus) then FOnRequestGetAgentStatus(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentStatus);
         AStatus:=@ARequest.GetAgentStatus.AgentStatus;
         AgentStatus.GetStatus(AStatus);
         AgentStatus.Free;
       end;
    5:begin
        //AgentSpecific
        //if Assigned(FOnRequestAgentSpecific) then FOnRequestAgentSpecific(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
      end;
    6:begin
        //GetAgentActivityList
        AgentActivityList:=TAgentActivityList.Create(TAgentActivityEntry);
        if Assigned(FOnRequestGetAgentActivityList) then FOnRequestGetAgentActivityList(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentActivityList);
        AgentActivityList.GetList(ARequest.GetAgentActivityList.ActivityList);
        AgentActivityList.Free;
      end;
    7:begin
        //GetAgentGroupList
        //if Assigned(FOnRequestGetAgentGroupList) then FOnRequestGetAgentGroupList(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);

      end;
    8:begin
        //CreateAgent
        //if Assigned(FOnRequestCreateAgent) then FOnRequestCreateAgent(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
      end;
    9:begin
        //SetAgentStateEx
        //if Assigned(FOnRequestSetAgentStateEx) then FOnRequestSetAgentStateEx(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
      end;
    10:begin
         //SetAgentMeasurementPeriod
         //if Assigned(FOnRequestSetAgentMeasurementPeriod) then FOnRequestSetAgentMeasurementPeriod(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    11:begin
         //GetAgentInfo
         //if Assigned(FOnRequestGetAgentInfo) then FOnRequestGetAgentInfo(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    12:begin
         //CreateAgentSession
         //if Assigned(FOnRequestCreateAgentSession) then FOnRequestCreateAgentSession(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
      end;
    13:begin
         //GetAgentSessionList
         //if Assigned(FOnRequestGetAgentSessionList) then FOnRequestGetAgentSessionList(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    14:begin
         //GetAgentSessionInfo
         //if Assigned(FOnRequestGetAgentSessionInfo) then FOnRequestGetAgentSessionInfo(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    15:begin
         //SetAgentSessionState
         //if Assigned(FOnRequestSetAgentSessionState) then FOnRequestSetAgentSessionState(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    16:begin
         //GetQueueList
         //if Assigned(FOnRequestGetQueueList) then FOnRequestGetQueueList(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    17:begin
         //SetQueueMeasurementPeriod
         //if Assigned(FOnRequestSetQueueMeasurementPeriod) then FOnRequestSetQueueMeasurementPeriod(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    18:begin
         //GetQueueInfo
         //if Assigned(FOnRequestGetQueueInfo) then FOnRequestGetQueueInfo(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
    19:begin
         //GetGroupList
         //if Assigned(FOnRequestGetGroupList) then FOnRequesGetGroupListt(self,Client,ARequest.GetAgentCaps.dwAddressID,AgentCaps);
       end;
  end;
  Client.Free;
end;


procedure TTAPIProxy.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) and (AComponent=FAddress) then
    FAddress:=nil;

end;

procedure TTAPIProxy.PerformMsg(Msg: TCMTAPI);
begin
  inherited;
  with Msg.TAPIRec^ do
  begin
    if Assigned(FAddress) then
    begin
      if Assigned(FAddress.Line) then
      begin
        if Address.Line.Handle=hDevice then
        begin
          case dwMsg of
            LINE_PROXYREQUEST:
            begin
              LineProxyRequest(dwParam1,dwParam2,dwParam3);
              LineProxyResponse(hDevice,PLineProxyRequest(dwParam1),0);
            end;
          end;
        end;
      end;
    end;
  end;
end;

{ TACDClient }

constructor TACDClient.Create(ProxyRequest: PLineProxyRequest);
//var Dummy:PWideChar;
    //i:Integer;
    //Size:DWord;

begin
  inherited Create;
  //Size:=SizeOf(TLineProxyRequest);
  //Proxy:=New(PLProxyRequest);
  //SetLength(Proxy.Data,ProxyRequest.dwSize-Size);
  //Proxy:=PLProxyRequest(ProxyRequest);
  //SetLength(A,ProxyRequest.dwClientMachineNameSize);
  {for i:=0 to ProxyRequest.dwClientMachineNameSize-1 do
  begin
    Dummy[i]:=Proxy.Data[i];
  end;}
  //StrCopy(PChar(A),PChar(ProxyRequest)+ProxyRequest^.dwClientMachineNameOffset);
  //Dummy:=PWideChar(PChar(ProxyRequest)+ProxyRequest^.dwClientMachineNameOffset);
  //StrCopy(PChar(A),PChar(@ProxyRequest)+ProxyRequest.dwClientMachineNameOffset);
  FMachineName:=WideCharToString(PWideChar(PChar(ProxyRequest)+ProxyRequest^.dwClientMachineNameOffset));
  FUserName:=WideCharToString(PWideChar(PChar(ProxyRequest)+ProxyRequest^.dwClientUserNameOffset));

  //PWideChar(Dummy));
  //OleStrToStrVar(PWideChar(@ProxyRequest)+ProxyRequest.dwClientMachineNameOffset,FMachineName);
  //StrCopy(PChar(FUserName),PChar(@ProxyRequest)+ProxyRequest.dwClientUserNameOffset);
  FAppAPIVersion:=ProxyRequest^.dwClientAppAPIVersion;
end;

destructor TACDClient.Destroy;
begin
  inherited;
end;



{$ENDIF}
end.

