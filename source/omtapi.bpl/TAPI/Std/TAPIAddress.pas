{******************************************************************************}
{*        Copyright 1999-2003 by J.Friebel all rights reserved.               *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5 / 6 / 7                             *}
{*        System          :  Windows                                          *}
{*        Projekt         :  TAPI Komponenten (TAPI Version 1.4 bis 2.2)      *}
{*        Last Update     :  04.01.2004                                       *}
{*        Version         :  BETA 6.0                                         *}
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
unit TAPIAddress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TAPI,TAPISystem,TAPIServices,TAPIDevices,TAPILines,TAPICall;

{$INCLUDE TAPI.INC}

type
  TLineAddressSharing = (lasPrivate,lasBridgedexcl,lasBridgednew,
    lasBridgedshared,lasMonitored);
  TLineAddressState = (asOther,asDevSpecific,asInUseZerro,asInUseOne,
    asInUseMany,asNumCalls,asForward,asTerminals,asCapSchanged);
  TLineAddressStates = Set of TLineAddressState;

  TLineCallInfoState = (cisOther,cisDevSpecific,cisBearerMode,cisRate,
    cisMediaMode,cisAppSpecific,cisCallId,cisRelatedCallId,cisOrigin,cisReason,
    cisCompletionId,cisNumOwnerIncr,cisNumOwnwerDecr,cisNumMonitors,cisTrunk,
    cisCallerId,cisCalledId,cisConnectedId,cisReDirectionId,cisReDirectingId,
    cisDisplay,cisUserUserInfo,cisHighLevelComp,cisLowLevelComp,cisChargingInfo,
    cisTerminal,cisDialParams,cisMonitormodes {$IFDEF TAPI20},cisTreatment,
    cisQOS,cisCallData {$ENDIF});
  TLineCallInfoStates = Set of TLineCallInfoState;

  TLineAddrCapsFlags = Set of (lacfFWDNumRings,lacfPickupGroupId,lacfSecure,
    lacfBlockIdDefault,lacfBlockIdOverride,lacfDialed,lacfOrigOffHook,
    lacfDestOffHook,lacfFWDConsult,lacfSetupConfNull,lacfAutoReconnect,
    lacfCompletionId,lacfTransferHeld,lacfTransferMake,lacfConferenceHeld,
    lacfConferenceMake,lacfPartialDial,lacfFWDStatusValid,lacfFWDInTextAddr,
    lacfFWDBusyNAAddr,lacfAcceptToAlert,lacfConfDrop,lacfPickupCallWait
    {$IFDEF TAPI20},lacfPredictiveDialer,lacfQUEUE,lacfRoutePoint,lacfHoldMakesNew,
    lacfNoInternalCalls,lacfNoExternalCalls,lacfSetCallingId{$ENDIF}
    {$IFDEF TAPI22},lacfACDGroup{$ENDIF});

  TLineRemoveFromConf = (rfcNone,rfcLast,rfcAny);

  TLineTransferMode = (ltmConference,ltmTransfer);
  TLineTransferModes =set of TLineTransferMode;

  TLineParkMode = (lpmDirected,lpmNoDirected);
  TLineParkModes =set of TLineParkMode;

  TLineForwardMode = (lfmUnCond,lfmUnCondInternal,lfmUnCondExternal,
    lfmUnCondSpecific,lfmBusy,lfmBusyInternal,lfmBusyExternal,lfmBusySpecific,
    lfmNoAnsw,lfmNoAnswInternal,lfmNoAnswExternal,lfmNoAnswSpecific,lfmBusyNA,
    lfmBusyNAInternal,lfmBusyNAExternal,lfmBusyNASpecific,lfmUnknown,
    lfmUnavail);
  TLineForwardModes = set of TLineForwardMode;

  TLineAddrFeature = (lafForward,lafMakeCall,lafPickup,lafSetMediaControl,
    lafSetTerminal,lafSetupConf,lafUncompleteCall,lafUnPark
    {$IFDEF TAPI20},lafPickupHeld,lafPickupGroup,lafPickupDirect,
    lafPickupwaiting,lafForwardFWD,lafForwardDND{$ENDIF});
  TLineAddrFeatures = set of TLineAddrFeature;

  TLineTranslateOption = (toCardOverride,toCancelCallWaiting,
    toForceLocal,toForceLd);
  TLineTranslateOptions = set of TLineTranslateOption;

  TLineCallSelect =(lcsAddress,lcsCall,lcsLine{$IFDEF TAPI21},lcsDeviceId{$ENDIF}
    {$IFDEF TAPI30},lcsCallId{$ENDIF});


  TAppNewCallEvent=procedure(Sender:TObject;Call:TTAPICall;AddressID:DWord;Privilege:TLineCallPrivileges)of Object;

  TForwardEntry=class(TPersistent)
  private
    FDestCountryCode: DWord;
    FCallerAddress: String;
    FDestAddress: String;
    FForwardMode: TLineForwardMode;
  public
    constructor Create(AForwardEntry: PLineForward);
    destructor Destroy;override;
    property ForwardMode:TLineForwardMode read FForwardMode;
    property CallerAddress :String read FCallerAddress;
    property DestCountryCode:DWord read FDestCountryCode;
    property DestAddress :String read FDestAddress;
  end;

  TForwardList=class(TList)
  end;

  {$IFDEF TAPI20}
  TCallTreatmentEntry=class(TPersistent)
  private
    FID: DWord;
    FName: String;
  public
    constructor Create(ALineCallTreatmentEntry: PLineCallTreatmentEntry);
    destructor Destroy;override;
    property ID: DWord read FID;
    property Name: String read FName;
  end;

  TCallTreatmentList=class(TList)
  public
    //constructor Create(ALineCallTreatmentEntry: PLineCallTreatmentEntry);
    //destructor Destroy;override;
  end;
  {$ENDIF}
type
  TAddressStatus=class(TPersistent)
  private
    FNumInUse,
    FNumActiveCalls,
    FNumOnHoldCalls,
    FNumOnHoldPendCalls:DWord;
    FAddressFeatures:TLineAddrFeatures;
    FNumRingsNoAnswer:DWord;
    //FForwardNumEntries:DWord;
    FForwards: TForwardList;
    FTerminalModes:Array of TLineTermModes;
    FDevSpecific: Array of Byte;
    FDevSpecificSize:DWord;
    FOnDevSpecTrans: TNotifyEvent;
    procedure SetStatus(ALineAddressStatus:PLineAddressStatus);
    function GetTerminalModes(Index:Integer):TLineTermModes;
    function GetForwards(Index: Integer): TForwardEntry;
  public
    constructor Create(ALine:HLine;AAddressID:DWord; Transl:TNotifyEvent);overload;virtual;
    constructor Create(ALineAddressStatus:PLineAddressStatus);overload;
    destructor Destroy;override;
    property TerminalModes[Index: Integer]:TLineTermModes read GetTerminalModes;
    procedure GetDevSpecific(var APointer: Pointer);overload;
    procedure GetDevSpecific(var AString: String);overload;
    property NumInUse:DWord read FNumInUse;
    property NumActiveCalls:DWord read FNumActiveCalls;
    property NumOnHoldCalls:DWord read FNumOnHoldCalls;
    property NumOnHoldPendCalls:DWord read FNumOnHoldPendCalls;
    property AddressFeatures:TLineAddrFeatures read FAddressFeatures;
    property NumRingsNoAnswer:DWord read FNumRingsNoAnswer;
    property Forwards[Index: Integer]:TForwardEntry read GetForwards;
    property DevSpecificSize:DWord read FDevSpecificSize; 
  end;

type
  PAddressCaps=^TAddressCaps;
  TAddressCaps=class(TPersistent)
  private
    FLineDeviceID: DWord;
    FAddress: String;
    //FDevSpecific: Array of Byte;
    FDevSpecificSize:DWord;
    FAddressSharing: TLineAddressSharing;
    FAddressStates: TLineAddressStates;
    FCallInfoStates: TLineCallInfoStates;
    FCalledIDFlags: TLineCallPartyID;
    FCallerIDFlags: TLineCallPartyID;
    FConnectedIDFlags: TLineCallPartyID;
    FRedirectingIDFlags: TLineCallPartyID;
    FRedirectionIDFlags: TLineCallPartyID;
    FCallStates: TLineCallStates;
    FDialToneModes: TLineDialtoneModes;
    FBusyModes: TLineBusyModes;
    FSpecialInfo: TLineSpecialInfo;
    FDisconnectModes :TLineDisconnectModes;
    FMaxNumActiveCalls,
    FMaxNumOnHoldCalls,
    FMaxNumOnHoldPentingCalls,
    FMaxNumConference,
    FMaxNumTransConf:DWord;
    FAddrCapFlags:TLineAddrCapsFlags;
    FCallFeatures:TLineCallFeatures;
    FRemoveFromConfCaps:TLineRemoveFromConf;
    FRemoveFromConfState:TLineCallStates;
    FTransferModes:TLineTransferModes;
    FParkModes:TLineParkModes;
    FForwardModes:TLineForwardModes;
    FMaxForwardEntries:Dword;
    FMaxSpecificEntries:DWord;
    FMinFwdNumRings:DWord;
    FMaxFwdNumRings:DWord;
    FMaxCallCompletions:DWord;
    FCallCompletionConds:TLineCallComplConds;
    FCallCompletionModes:TLineCallComplModes;
    FNumCompletionMessages:DWord;
    //FCompletionMsgTextEntrySize:Dword;
    FCompletionMsgText:TStringList;
    FAddressFeatures:TLineAddrFeatures;
    {$IFDEF TAPI20}
    FPredictiveAutoTransferStates:TLineCallStates;
    FNumCallTreatments:DWord;
    FCallTreatmentList:TCallTreatmentList;
    FDeviceClasses:TStringList;
    FMaxCallDataSize:DWord;
    FCallFeatures2:TLineCallFeatures2;
    FMaxNoAnswerTimeout:Dword;
    FConnectedModes:TLineConnectedModes;
    FOfferingModes:TLineOfferingModes;
    FAvailableMediaModes:TLineMediaModes;
    {$ENDIF}
    FOnDevSpecTrans: TNotifyEvent;
    procedure SetCaps(var Caps:PLineAddresscaps);
  public
    constructor Create(ALineApp:HLineApp;ADeviceID,AAddressID,AAPIVersion,AExtVersion:DWord);overload;virtual;
    constructor Create(ALineAddressCaps:PLINEADDRESSCAPS);overload;
    destructor Destroy;override;
  published
    property LineDeviceID:DWord read FLineDeviceID ;
    property Address:String read FAddress ;
    property DevSpecificSize: DWord read FDevSpecificSize;
    property AddresSharing:TLineAddressSharing read FAddressSharing ;
    property AddressStates:TLineAddressStates read FAddressStates ;
    property CallInfoStates:TLineCallInfoStates read FCallInfoStates;
    property CallerIDFlags:TLineCallPartyID read FCallerIDFlags;
    property CalledIDFlags:TLineCallPartyID read FCalledIDFlags;
    property ConnectedIDFlags:TLineCallPartyID read FConnectedIDFlags;
    property RedirectionIDFlags:TLineCallPartyID read FRedirectionIDFlags;
    property RedirectingIDFlags:TLineCallPartyID read FRedirectingIDFlags;
    property CallStates:TLineCallStates read FCallStates;
    property DialToneModes:TLineDialtoneModes read FDialToneModes;
    property BusyModes:TLineBusyModes read FBusyModes;
    property SpecialInfo:TLineSpecialInfo read FSpecialInfo;
    property DisconnectModes :TLineDisconnectModes read FDisconnectModes;
    property MaxNumActiveCalls:DWord read FMaxNumActiveCalls;
    property MaxNumOnHoldCalls:DWord read FMaxNumOnHoldCalls;
    property MaxNumOnHoldPentingCalls:DWord read FMaxNumOnHoldPentingCalls;
    property MaxNumConference:DWord read FMaxNumConference;
    property MaxNumTransConf:DWord read FMaxNumTransConf;
    property AddrCapFlags:TLineAddrCapsFlags read FAddrCapFlags;
    property CallFeatures:TLineCallFeatures read FCallFeatures;
    property RemoveFromConfCaps:TLineRemoveFromConf read FRemoveFromConfCaps;
    property RemoveFromConfState:TLineCallStates read FRemoveFromConfState;
    property TransferModes:TLineTransferModes read FTransferModes;
    property ParkModes:TLineParkModes read FParkModes;
    property ForwardModes:TLineForwardModes read FForwardModes;
    property MaxForwardEntries:DWord read FMaxForwardEntries;
    property MaxSpecificEntries:DWord read FMaxSpecificEntries;
    property MinFwdNumRings:DWord read FMinFwdNumRings;
    property MaxFwdNumRings:DWord read FMaxFwdNumRings;
    property MaxCallCompletions:DWord read FMaxCallCompletions;
    property CallCompletionConds:TLineCallComplConds read FCallCompletionConds;
    property CallCompletionModes:TLineCallComplModes read FCallCompletionModes;
    property NumCompletionMessages:DWord read FNumCompletionMessages;
    //property CompletionMsgTextEntrySize:DWord read FCompletionMsgTextEntrySize;
    property CompletionMsgText:TStringList read FCompletionMsgText;
    property AddressFeatures:TLineAddrFeatures read FAddressFeatures;
    {$IFDEF TAPI20}
    property PredictiveAutoTransferStates:TLineCallStates read FPredictiveAutoTransferStates;
    property NumCallTreatments:DWord read FNumCallTreatments;
    property CallTreatmentList:TCallTreatmentList read FCallTreatmentList;
    property DeviceClasses:TStringList read FDeviceClasses;
    property MaxCallDataSize:DWord read FMaxCallDataSize;
    property CallFeatures2:TLineCallFeatures2 read FCallFeatures2;
    property MaxNoAnswerTimeout:Dword read FMaxNoAnswerTimeout;
    property ConnectedModes:TLineConnectedModes read FConnectedModes;
    property OfferingModes:TLineOfferingModes read FOfferingModes;
    property AvailableMediaModes:TLineMediaModes read FAvailableMediaModes;
    {$ENDIF}
  end;

type
  TCMLineOpen=packed record
    Msg: Cardinal;
    DevID: DWord;
    LineHandle: THandle;
    Result: Longint;
  end;

type
  TTAPIAddress = class(TTAPIComponent)
  private
    FAddressCaps:TAddressCaps;
    FAddressMode:TLineAddressMode;
    FNumRings:DWord;
    FLine:TTAPILine;
    FOutBoundCall:TTAPICall;
    FInBoundCall:TTAPICall;
    FMonitorCall:TTAPICall;
    FAddressStatus:TAddressStatus;
    FAddressID:DWord;
    FAddress:String;
    FTranslateOptions:DWord;
    FCountryCode:DWord;
    FAddressStateMessages:TLineAddressStates;
    FOnForward: TNotifyEvent;
    FOnInUseMany: TNotifyEvent;
    FOnDevSpecific: TNotifyEvent;
    FOnTerminals: TNotifyEvent;
    FOnOther: TNotifyEvent;
    FOnInUseOne: TNotifyEvent;
    FOnNumCalls: TNotifyEvent;
    FOnInUseZero: TNotifyEvent;
    FOnCapsChanged: TNotifyEvent;
    FOnAppNewCall:TAppNewCallEvent;
    //FActive: Boolean;
    FOnDevSpecTrans: TNotifyEvent;
    //FAgent: TTAPILineAgent;
    //FACDProxy:TACDProxy;
    function GetAddressCaps: TAddressCaps;
    procedure SetAddressID(const Value: DWord);
    function GetDialableAdress: String;
    function GetTranslateOptions: TLineTranslateOptions;
    procedure SetTranslateOptions(const Value: TLineTranslateOptions);
    function GetAddressStatus: TAddressStatus;
    function GetNumRings: DWord;
    procedure SetNumRings(const Value: DWord);
    procedure SetLine(const Value: TTAPILine);
    //procedure SetActive(const Value: Boolean);
    //procedure SetAgent(const Value: TTAPILineAgent);
  protected
    procedure Notification(AComponent:TComponent; Operation :TOperation); override;
    procedure StateChange(AddressStatus:DWord);
    procedure AppNewCall(hDevice,dwParam1,dwParam2,dwParam3:LongWord);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    function GetStateMsg:DWord;
    function GetMode:DWord;
    procedure MakeCall;
    procedure Dial;//(DestAddress:String;CountryCode:DWord);
    procedure SetStatusMessages;
    procedure GetID(var ACall:TTAPICall;var AddressID:Dword;Select:TLineCallSelect; var VarStr:TVarString);
    property Caps:TAddressCaps read GetAddressCaps ;
    property Status:TAddressStatus read GetAddressStatus;
    property DialableAddress:String read GetDialableAdress;
    //property Active:Boolean read FActive write SetActive;
    procedure PerformMsg(Msg: TCMTAPI);override;
    procedure GetAddressID(var AddrID: PChar);
  published
    property OnDevSpecTrans: TNotifyEvent read FOnDevSpecTrans write FOnDevSpecTrans;
    property OnCapsChanged:TNotifyEvent read FOnCapsChanged write FOnCapsChanged;
    property OnDevSpecific:TNotifyEvent read FOnDevSpecific write FOnDevSpecific;
    property OnForward:TNotifyEvent read FOnForward write FOnForward;
    property OnInUseMany:TNotifyEvent read FOnInUseMany write FOnInUseMany;
    property OnInUseOne:TNotifyEvent read FOnInUseOne  write FOnInUseOne;
    property OnInuseZero:TNotifyEvent read FOnInuseZero write FOnInuseZero;
    property OnNumCalls:TNotifyEvent read FOnNumCalls write FOnNumCalls;
    property OnOther:TNotifyEvent read FOnOther write FOnOther;
    property OnTerminals:TNotifyEvent read FOnTerminals write FOnTerminals;
    property OnAppNewCall:TAppNewCallEvent read FOnAppNewCall write FOnAppNewCall;
    property Line:TTAPILine read FLine write SetLine;
    {$IFDEF TAPI20}
    //property Agent:TTAPILineAgent read FAgent write SetAgent;
    //property ACDProxy:TACDProxy read FACDProxy write FACDProxy;
    {$ENDIF}
    property Address:String read FAddress write FAddress ;
    property TranslateOptions:TLineTranslateOptions read GetTranslateOptions write SetTranslateOptions;
    property CountryCode:DWord read  FCountryCode write  FCountryCode default 0;
    property Mode:TLineAddressMode read FAddressMode write FAddressMode default amDialableAddr;
    property NumRings:DWord read GetNumRings write SetNumRings default 0;
    property InboundCall:TTAPICall read FInBoundCall write FInBoundCall;
    property OutboundCall:TTAPICall read FOutBoundCall write FOutBoundCall;
    property MonitorCall:TTAPICall read FMonitorCall write FMonitorCall;
    property ID:DWord read FAddressID write SetAddressID default 0;
  end;


function CallSelectToInt(Value:TLineCallSelect):LongWord;
function TranslateOptionsToInt(Value:TLineTranslateOptions):LongWord;
function IntToTranslateOptions(Value:LongWord):TLineTranslateOptions;
function IntToAddrFeatures(Value:LongWord):TLineAddrFeatures;
function IntToForwardModes(Value:LongWord):TLineForwardModes;
function IntToForwardMode(Value:LongWord):TLineForwardMode;
function IntToParkModes(Value:LongWord):TLineParkModes;
function IntToTransferModes(Value:LongWord):TLineTransferModes;
function IntToAddressSharing(Value:LongWord):TLineAddressSharing;
function IntToAddressStates(Value:LongWord):TLineAddressStates;
function AddressStatesToInt(Value:TLineAddressStates):LongWord;
function IntToCallInfoStates(Value:LongWord):TLineCallInfoStates;
function IntToAddrCapsFlags(Value:LongWord):TLineAddrCapsFlags;
function IntToRemoveFromConf(Value:LongWord):TLineRemoveFromConf;
function ForwardModeToInt(Value:TLineForwardMode):LongWord;

procedure Register;

implementation

uses {$IFDEF VER120}D4Comp,{$ENDIF}TAPIErr,TAPIHelpFunc;

procedure Register;
begin
{$IFDEF TAPI30}
  RegisterComponents('TAPI30', [TTAPIAddress]);
{$ELSE}
{$IFDEF TAPI22}
  RegisterComponents('TAPI22', [TTAPIAddress]);
{$ELSE}
{$IFDEF TAPI21}
  RegisterComponents('TAPI21', [TTAPIAddress]);
{$ELSE}
{$IFDEF TAPI20}
  RegisterComponents('TAPI20', [TTAPIAddress]);
{$ELSE}
  RegisterComponents('TAPI', [TTAPIAddress]);
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
end;

function CallSelectToInt(Value:TLineCallSelect):LongWord;
begin
  Result:=0;
  case Value of
    lcsAddress:Result:=LINECALLSELECT_ADDRESS;
    lcsCall:Result:=LINECALLSELECT_CALL;
    lcsLine:Result:=LINECALLSELECT_LINE;
    {$IFDEF TAPI21}
    lcsDeviceId:Result:=LINECALLSELECT_DEVICEID;
    {$ENDIF}
    {$IFDEF TAPI30}
    lcsCallId:Result:=LINECALLSELECT_CALLID;
    {$ENDIF}
  end;
end;

function TranslateOptionsToInt(Value:TLineTranslateOptions):LongWord;
begin
  Result:=0;
  if toCardOverride in Value then Result:=Result or LINETRANSLATEOPTION_CARDOVERRIDE;
  if toCancelCallWaiting in Value then Result:=Result or  LINETRANSLATEOPTION_CANCELCALLWAITING;
  if toForceLocal in Value then Result:=Result or LINETRANSLATEOPTION_FORCELOCAL;
  if toForceLd in Value then Result:=Result or LINETRANSLATEOPTION_FORCELD;
end;

function IntToTranslateOptions(Value:LongWord):TLineTranslateOptions;
begin
  Result:=[];
  if Value and LINETRANSLATEOPTION_CARDOVERRIDE = LINETRANSLATEOPTION_CARDOVERRIDE then Result:=Result+[toCardOverride];
  if Value and LINETRANSLATEOPTION_CANCELCALLWAITING = LINETRANSLATEOPTION_CANCELCALLWAITING then Result:=Result+[toCancelCallWaiting];
  if Value and LINETRANSLATEOPTION_FORCELOCAL = LINETRANSLATEOPTION_FORCELOCAL then Result:=Result+[toForceLocal];
  if Value and LINETRANSLATEOPTION_FORCELD = LINETRANSLATEOPTION_FORCELD then Result:=Result+[toForceLd];
end;

function IntToAddrFeatures(Value:LongWord):TLineAddrFeatures;
begin
  Result:=[];
  if Value and LINEADDRFEATURE_FORWARD = LINEADDRFEATURE_FORWARD then Result:=Result+[lafForward];
  if Value and LINEADDRFEATURE_MAKECALL = LINEADDRFEATURE_MAKECALL then Result:=Result+[lafMakeCall];
  if Value and LINEADDRFEATURE_PICKUP = LINEADDRFEATURE_PICKUP then Result:=Result+[lafPickup];
  if Value and LINEADDRFEATURE_SETMEDIACONTROL = LINEADDRFEATURE_SETMEDIACONTROL then Result:=Result+[lafSetMediaControl];
  if Value and LINEADDRFEATURE_SETTERMINAL = LINEADDRFEATURE_SETTERMINAL then Result:=Result+[lafSetTerminal];
  if Value and LINEADDRFEATURE_SETUPCONF = LINEADDRFEATURE_SETUPCONF then Result:=Result+[lafSetupConf];
  if Value and LINEADDRFEATURE_UNCOMPLETECALL = LINEADDRFEATURE_UNCOMPLETECALL then Result:=Result+[lafUncompleteCall];
  if Value and LINEADDRFEATURE_UNPARK = LINEADDRFEATURE_UNPARK then Result:=Result+[lafUnPark];
  {$IFDEF TAPI20}
  if Value and LINEADDRFEATURE_PICKUPHELD = LINEADDRFEATURE_PICKUPHELD then Result:=Result+[lafPickupHeld];
  if Value and LINEADDRFEATURE_PICKUPGROUP = LINEADDRFEATURE_PICKUPGROUP then Result:=Result+[lafPickupGroup];
  if Value and LINEADDRFEATURE_PICKUPDIRECT = LINEADDRFEATURE_PICKUPDIRECT then Result:=Result+[lafPickupDirect];
  if Value and LINEADDRFEATURE_PICKUPWAITING = LINEADDRFEATURE_PICKUPWAITING then Result:=Result+[lafPickupwaiting];
  if Value and LINEADDRFEATURE_FORWARDFWD = LINEADDRFEATURE_FORWARDFWD then Result:=Result+[lafForwardFWD];
  if Value and LINEADDRFEATURE_FORWARDDND = LINEADDRFEATURE_FORWARDDND then Result:=Result+[lafForwardDND];
  {$ENDIF}
end;

function IntToForwardModes(Value:LongWord):TLineForwardModes;
begin
  Result:=[];
  if Value and LINEFORWARDMODE_UNCOND = LINEFORWARDMODE_UNCOND then Result:=Result+[lfmUnCond];
  if Value and LINEFORWARDMODE_UNCONDINTERNAL = LINEFORWARDMODE_UNCONDINTERNAL then Result:=Result+[lfmUnCondInternal];
  if Value and LINEFORWARDMODE_UNCONDEXTERNAL = LINEFORWARDMODE_UNCONDEXTERNAL then Result:=Result+[lfmUnCondExternal];
  if Value and LINEFORWARDMODE_UNCONDSPECIFIC = LINEFORWARDMODE_UNCONDSPECIFIC then Result:=Result+[lfmUnCondSpecific];
  if Value and LINEFORWARDMODE_BUSY = LINEFORWARDMODE_BUSY then Result:=Result+[lfmBusy];
  if Value and LINEFORWARDMODE_BUSYINTERNAL = LINEFORWARDMODE_BUSYINTERNAL then Result:=Result+[lfmBusyInternal];
  if Value and LINEFORWARDMODE_BUSYEXTERNAL = LINEFORWARDMODE_BUSYEXTERNAL then Result:=Result+[lfmBusyExternal];
  if Value and LINEFORWARDMODE_BUSYSPECIFIC = LINEFORWARDMODE_BUSYSPECIFIC then Result:=Result+[lfmBusySpecific];
  if Value and LINEFORWARDMODE_NOANSW = LINEFORWARDMODE_NOANSW then Result:=Result+[lfmNoAnsw];
  if Value and LINEFORWARDMODE_NOANSWINTERNAL = LINEFORWARDMODE_NOANSWINTERNAL then Result:=Result+[lfmNoAnswInternal];
  if Value and LINEFORWARDMODE_NOANSWEXTERNAL = LINEFORWARDMODE_NOANSWEXTERNAL then Result:=Result+[lfmNoAnswExternal];
  if Value and LINEFORWARDMODE_NOANSWSPECIFIC = LINEFORWARDMODE_NOANSWSPECIFIC then Result:=Result+[lfmNoAnswSpecific];
  if Value and LINEFORWARDMODE_BUSYNA = LINEFORWARDMODE_BUSYNA then Result:=Result+[lfmBusyNA];
  if Value and LINEFORWARDMODE_BUSYNAINTERNAL = LINEFORWARDMODE_BUSYNAINTERNAL then Result:=Result+[lfmBusyNAInternal];
  if Value and LINEFORWARDMODE_BUSYNAEXTERNAL = LINEFORWARDMODE_BUSYNAEXTERNAL then Result:=Result+[lfmBusyNAExternal];
  if Value and LINEFORWARDMODE_BUSYNASPECIFIC = LINEFORWARDMODE_BUSYNASPECIFIC then Result:=Result+[lfmBusyNASpecific];
  if Value and LINEFORWARDMODE_UNKNOWN = LINEFORWARDMODE_UNKNOWN then Result:=Result+[lfmUnknown];
  if Value and LINEFORWARDMODE_UNAVAIL = LINEFORWARDMODE_UNAVAIL then Result:=Result+[lfmUnavail];
end;

function IntToForwardMode(Value:LongWord):TLineForwardMode;
begin
  Result:=lfmUnavail;
  case Value of
    LINEFORWARDMODE_UNCOND: Result:=lfmUnCond;
    LINEFORWARDMODE_UNCONDINTERNAL : Result:=lfmUnCondInternal;
    LINEFORWARDMODE_UNCONDEXTERNAL : Result:=lfmUnCondExternal;
    LINEFORWARDMODE_UNCONDSPECIFIC : Result:=lfmUnCondSpecific;
    LINEFORWARDMODE_BUSY : Result:=lfmBusy;
    LINEFORWARDMODE_BUSYINTERNAL : Result:=lfmBusyInternal;
    LINEFORWARDMODE_BUSYEXTERNAL : Result:=lfmBusyExternal;
    LINEFORWARDMODE_BUSYSPECIFIC : Result:=lfmBusySpecific;
    LINEFORWARDMODE_NOANSW : Result:=lfmNoAnsw;
    LINEFORWARDMODE_NOANSWINTERNAL : Result:=lfmNoAnswInternal;
    LINEFORWARDMODE_NOANSWEXTERNAL : Result:=lfmNoAnswExternal;
    LINEFORWARDMODE_NOANSWSPECIFIC : Result:=lfmNoAnswSpecific;
    LINEFORWARDMODE_BUSYNA : Result:=lfmBusyNA;
    LINEFORWARDMODE_BUSYNAINTERNAL : Result:=lfmBusyNAInternal;
    LINEFORWARDMODE_BUSYNAEXTERNAL : Result:=lfmBusyNAExternal;
    LINEFORWARDMODE_BUSYNASPECIFIC : Result:=lfmBusyNASpecific;
    LINEFORWARDMODE_UNKNOWN : Result:=lfmUnknown;
    LINEFORWARDMODE_UNAVAIL : Result:=lfmUnavail;
  end;
end;

function ForwardModeToInt(Value:TLineForwardMode):LongWord;
begin
  Result:=0;
  case Value of
    lfmUnCond : Result:=LINEFORWARDMODE_UNCOND;
    lfmUnCondInternal : Result:=LINEFORWARDMODE_UNCONDINTERNAL;
    lfmUnCondExternal : Result:=LINEFORWARDMODE_UNCONDEXTERNAL;
    lfmUnCondSpecific : Result:=LINEFORWARDMODE_UNCONDSPECIFIC;
    lfmBusy : Result:=LINEFORWARDMODE_BUSY;
    lfmBusyInternal : Result:=LINEFORWARDMODE_BUSYINTERNAL;
    lfmBusyExternal : Result:=LINEFORWARDMODE_BUSYEXTERNAL;
    lfmBusySpecific : Result:=LINEFORWARDMODE_BUSYSPECIFIC;
    lfmNoAnsw : Result:=LINEFORWARDMODE_NOANSW;
    lfmNoAnswInternal : Result:=LINEFORWARDMODE_NOANSWINTERNAL;
    lfmNoAnswExternal : Result:=LINEFORWARDMODE_NOANSWEXTERNAL;
    lfmNoAnswSpecific : Result:=LINEFORWARDMODE_NOANSWSPECIFIC;
    lfmBusyNA : Result:=LINEFORWARDMODE_BUSYNA;
    lfmBusyNAInternal : Result:=LINEFORWARDMODE_BUSYNAINTERNAL;
    lfmBusyNAExternal : Result:=LINEFORWARDMODE_BUSYNAEXTERNAL;
    lfmBusyNASpecific : Result:=LINEFORWARDMODE_BUSYNASPECIFIC;
    lfmUnknown : Result:=LINEFORWARDMODE_UNKNOWN;
    lfmUnavail : Result:=LINEFORWARDMODE_UNAVAIL;
  end;
end;


function IntToParkModes(Value:LongWord):TLineParkModes;
begin
  result:=[];
  if Value and LINEPARKMODE_DIRECTED = LINEPARKMODE_DIRECTED then Result:=Result+[lpmDirected];
  if Value and LINEPARKMODE_NONDIRECTED = LINEPARKMODE_NONDIRECTED then Result:=Result+[lpmNoDirected];
end;

function IntToTransferModes(Value:LongWord):TLineTransferModes;
begin
  result:=[];
  if Value and LINETRANSFERMODE_CONFERENCE = LINETRANSFERMODE_CONFERENCE then Result:=Result+[ltmConference];
  if Value and LINETRANSFERMODE_TRANSFER = LINETRANSFERMODE_TRANSFER then Result:=Result+[ltmTransfer];
end;

function IntToAddressSharing(Value:LongWord):TLineAddressSharing;
begin
  Result:=lasPrivate;
  case Value of
    LINEADDRESSSHARING_PRIVATE:Result:=lasPrivate;
    LINEADDRESSSHARING_BRIDGEDEXCL:Result:=lasBridgedexcl;
    LINEADDRESSSHARING_BRIDGEDNEW:Result:=lasBridgednew;
    LINEADDRESSSHARING_BRIDGEDSHARED:Result:=lasBridgedshared;
    LINEADDRESSSHARING_MONITORED:Result:=lasMonitored;
  end;
end;

function IntToRemoveFromConf(Value:LongWord):TLineRemoveFromConf;
begin
  Result:=rfcNone;
  case Value of
    LINEREMOVEFROMCONF_NONE:Result:=rfcNone;
    LINEREMOVEFROMCONF_LAST:Result:=rfcLast;
    LINEREMOVEFROMCONF_ANY:Result:=rfcAny;
  end;
end;

function IntToAddressStates(Value:LongWord):TLineAddressStates;
begin
  Result:=[];
  if Value and LINEADDRESSSTATE_OTHER = LINEADDRESSSTATE_OTHER then Result:=Result+[asOther];
  if Value and LINEADDRESSSTATE_DEVSPECIFIC = LINEADDRESSSTATE_DEVSPECIFIC then Result:=Result+[asDevSpecific];
  if Value and LINEADDRESSSTATE_INUSEZERO = LINEADDRESSSTATE_INUSEZERO then Result:=Result+[asInUseZerro];
  if Value and LINEADDRESSSTATE_INUSEONE = LINEADDRESSSTATE_INUSEONE then Result:=Result+[asInUseOne];
  if Value and LINEADDRESSSTATE_INUSEMANY = LINEADDRESSSTATE_INUSEMANY then Result:=Result+[asInUseMany];
  if Value and LINEADDRESSSTATE_NUMCALLS = LINEADDRESSSTATE_NUMCALLS then Result:=Result+[asNumCalls];
  if Value and LINEADDRESSSTATE_FORWARD = LINEADDRESSSTATE_FORWARD then Result:=Result+[asForward];
  if Value and LINEADDRESSSTATE_TERMINALS = LINEADDRESSSTATE_TERMINALS then Result:=Result+[asTerminals];
  if Value and LINEADDRESSSTATE_CAPSCHANGE = LINEADDRESSSTATE_CAPSCHANGE then Result:=Result+[asCapSchanged];
end;

function AddressStatesToInt(Value:TLineAddressStates):LongWord;
begin
  Result:=0;
  IF asOther in Value then Result:=Result or LINEADDRESSSTATE_OTHER;
  IF asDevSpecific in Value then Result:=Result or LINEADDRESSSTATE_DEVSPECIFIC;
  IF asInUseZerro in Value then Result:=Result or LINEADDRESSSTATE_INUSEZERO;
  IF asInUseOne in Value then Result:=Result or LINEADDRESSSTATE_INUSEONE;
  IF asInUseMany in Value then Result:=Result or LINEADDRESSSTATE_INUSEMANY;
  IF asNumCalls in Value then Result:=Result or LINEADDRESSSTATE_NUMCALLS;
  IF asForward in Value then Result:=Result or LINEADDRESSSTATE_FORWARD;
  IF asTerminals in Value then Result:=Result or LINEADDRESSSTATE_TERMINALS;
  IF asCapSchanged in Value then Result:=Result or LINEADDRESSSTATE_CAPSCHANGE;
end;

function IntToCallInfoStates(Value:LongWord):TLineCallInfoStates;
begin
  Result:=[];
  if Value and LINECALLINFOSTATE_OTHER = LINECALLINFOSTATE_OTHER then Result:=Result+[cisOther];
  if Value and LINECALLINFOSTATE_DEVSPECIFIC = LINECALLINFOSTATE_DEVSPECIFIC then Result:=Result+[cisDevSpecific];
  if Value and LINECALLINFOSTATE_BEARERMODE = LINECALLINFOSTATE_BEARERMODE then Result:=Result+[cisBearerMode];
  if Value and LINECALLINFOSTATE_RATE = LINECALLINFOSTATE_RATE then Result:=Result+[cisRate];
  if Value and LINECALLINFOSTATE_MEDIAMODE = LINECALLINFOSTATE_MEDIAMODE then Result:=Result+[cisMediaMode];
  if Value and LINECALLINFOSTATE_APPSPECIFIC = LINECALLINFOSTATE_APPSPECIFIC then Result:=Result+[cisAppSpecific];
  if Value and LINECALLINFOSTATE_CALLID = LINECALLINFOSTATE_CALLID then Result:=Result+[cisCallID];
  if Value and LINECALLINFOSTATE_RELATEDCALLID = LINECALLINFOSTATE_RELATEDCALLID then Result:=Result+[cisRelatedCallID];
  if Value and LINECALLINFOSTATE_ORIGIN = LINECALLINFOSTATE_ORIGIN then Result:=Result+[cisOrigin];
  if Value and LINECALLINFOSTATE_REASON = LINECALLINFOSTATE_REASON then Result:=Result+[cisReason];
  if Value and LINECALLINFOSTATE_COMPLETIONID = LINECALLINFOSTATE_COMPLETIONID then Result:=Result+[cisCompletionID];
  if Value and LINECALLINFOSTATE_NUMOWNERINCR = LINECALLINFOSTATE_NUMOWNERINCR then Result:=Result+[cisNumOwnerIncr];
  if Value and LINECALLINFOSTATE_NUMOWNERDECR = LINECALLINFOSTATE_NUMOWNERDECR then Result:=Result+[cisNumOwnwerDecr];
  if Value and LINECALLINFOSTATE_NUMMONITORS = LINECALLINFOSTATE_NUMMONITORS then Result:=Result+[cisNumMonitors];
  if Value and LINECALLINFOSTATE_TRUNK = LINECALLINFOSTATE_TRUNK then Result:=Result+[cisTrunk];
  if Value and LINECALLINFOSTATE_CALLERID = LINECALLINFOSTATE_CALLERID then Result:=Result+[cisCallerID];
  if Value and LINECALLINFOSTATE_CALLEDID = LINECALLINFOSTATE_CALLEDID then Result:=Result+[cisCalledID];
  if Value and LINECALLINFOSTATE_CONNECTEDID = LINECALLINFOSTATE_CONNECTEDID then Result:=Result+[cisConnectedID];
  if Value and LINECALLINFOSTATE_REDIRECTIONID = LINECALLINFOSTATE_REDIRECTIONID then Result:=Result+[cisRedirectionID];
  if Value and LINECALLINFOSTATE_REDIRECTINGID = LINECALLINFOSTATE_REDIRECTINGID then Result:=Result+[cisRedirectingID];
  if Value and LINECALLINFOSTATE_DISPLAY = LINECALLINFOSTATE_DISPLAY then Result:=Result+[cisDisplay];
  if Value and LINECALLINFOSTATE_USERUSERINFO = LINECALLINFOSTATE_USERUSERINFO then Result:=Result+[cisUserUserInfo];
  if Value and LINECALLINFOSTATE_HIGHLEVELCOMP = LINECALLINFOSTATE_HIGHLEVELCOMP then Result:=Result+[cisHighLevelComp];
  if Value and LINECALLINFOSTATE_LOWLEVELCOMP = LINECALLINFOSTATE_LOWLEVELCOMP then Result:=Result+[cisLowLevelComp];
  if Value and LINECALLINFOSTATE_CHARGINGINFO = LINECALLINFOSTATE_CHARGINGINFO then Result:=Result+[cisChargingInfo];
  if Value and LINECALLINFOSTATE_TERMINAL = LINECALLINFOSTATE_TERMINAL then Result:=Result+[cisTerminal];
  if Value and LINECALLINFOSTATE_DIALPARAMS = LINECALLINFOSTATE_DIALPARAMS then Result:=Result+[cisDialParams];
  if Value and LINECALLINFOSTATE_MONITORMODES = LINECALLINFOSTATE_MONITORMODES then Result:=Result+[cisMonitorModes];
  {$IFDEF TAPI20}
  if Value and LINECALLINFOSTATE_TREATMENT = LINECALLINFOSTATE_TREATMENT then Result:=Result+[cisTreatment];
  if Value and LINECALLINFOSTATE_QOS = LINECALLINFOSTATE_QOS then Result:=Result+[cisQOS];
  if Value and LINECALLINFOSTATE_CALLDATA = LINECALLINFOSTATE_CALLDATA then Result:=Result+[cisCallData];
 {$ENDIF}
end;

function IntToAddrCapsFlags(Value:LongWord):TLineAddrCapsFlags;
begin
  Result:=[];
  if Value and LINEADDRCAPFLAGS_FWDNUMRINGS = LINEADDRCAPFLAGS_FWDNUMRINGS then Result:=Result+[lacfFWDNUMRINGS];
  if Value and LINEADDRCAPFLAGS_PICKUPGROUPID = LINEADDRCAPFLAGS_PICKUPGROUPID then Result:=Result+[lacfPICKUPGROUPID];
  if Value and LINEADDRCAPFLAGS_SECURE = LINEADDRCAPFLAGS_SECURE then Result:=Result+[lacfSECURE];
  if Value and LINEADDRCAPFLAGS_BLOCKIDDEFAULT = LINEADDRCAPFLAGS_BLOCKIDDEFAULT then Result:=Result+[lacfBLOCKIDDEFAULT];
  if Value and LINEADDRCAPFLAGS_BLOCKIDOVERRIDE = LINEADDRCAPFLAGS_BLOCKIDOVERRIDE  then Result:=Result+[lacfBLOCKIDOVERRIDE];
  if Value and LINEADDRCAPFLAGS_DIALED = LINEADDRCAPFLAGS_DIALED then Result:=Result+[lacfDIALED];
  if Value and LINEADDRCAPFLAGS_ORIGOFFHOOK = LINEADDRCAPFLAGS_ORIGOFFHOOK then Result:=Result+[lacfORIGOFFHOOK];
  if Value and LINEADDRCAPFLAGS_DESTOFFHOOK = LINEADDRCAPFLAGS_DESTOFFHOOK then Result:=Result+[lacfDESTOFFHOOK];
  if Value and LINEADDRCAPFLAGS_FWDCONSULT = LINEADDRCAPFLAGS_FWDCONSULT then Result:=Result+[lacfFWDCONSULT];
  if Value and LINEADDRCAPFLAGS_SETUPCONFNULL = LINEADDRCAPFLAGS_SETUPCONFNULL then Result:=Result+[lacfSETUPCONFNULL];
  if Value and LINEADDRCAPFLAGS_AUTORECONNECT = LINEADDRCAPFLAGS_AUTORECONNECT then Result:=Result+[lacfAUTORECONNECT];
  if Value and LINEADDRCAPFLAGS_COMPLETIONID = LINEADDRCAPFLAGS_COMPLETIONID then Result:=Result+[lacfCOMPLETIONID];
  if Value and LINEADDRCAPFLAGS_TRANSFERHELD = LINEADDRCAPFLAGS_TRANSFERHELD then Result:=Result+[lacfTRANSFERHELD];
  if Value and LINEADDRCAPFLAGS_TRANSFERMAKE = LINEADDRCAPFLAGS_TRANSFERMAKE then Result:=Result+[lacfTRANSFERMAKE];
  if Value and LINEADDRCAPFLAGS_CONFERENCEHELD = LINEADDRCAPFLAGS_CONFERENCEHELD then Result:=Result+[lacfCONFERENCEHELD];
  if Value and LINEADDRCAPFLAGS_CONFERENCEMAKE = LINEADDRCAPFLAGS_CONFERENCEMAKE then Result:=Result+[lacfCONFERENCEMAKE];
  if Value and LINEADDRCAPFLAGS_PARTIALDIAL = LINEADDRCAPFLAGS_PARTIALDIAL then Result:=Result+[lacfPARTIALDIAL];
  if Value and LINEADDRCAPFLAGS_FWDSTATUSVALID = LINEADDRCAPFLAGS_FWDSTATUSVALID then Result:=Result+[lacfFWDSTATUSVALID];
  if Value and LINEADDRCAPFLAGS_FWDINTEXTADDR = LINEADDRCAPFLAGS_FWDINTEXTADDR then Result:=Result+[lacfFWDINTEXTADDR];
  if Value and LINEADDRCAPFLAGS_FWDBUSYNAADDR = LINEADDRCAPFLAGS_FWDBUSYNAADDR then Result:=Result+[lacfFWDBUSYNAADDR];
  if Value and LINEADDRCAPFLAGS_ACCEPTTOALERT = LINEADDRCAPFLAGS_ACCEPTTOALERT then Result:=Result+[lacfACCEPTTOALERT];
  if Value and LINEADDRCAPFLAGS_CONFDROP = LINEADDRCAPFLAGS_CONFDROP then Result:=Result+[lacfCONFDROP];
  if Value and LINEADDRCAPFLAGS_PICKUPCALLWAIT = LINEADDRCAPFLAGS_PICKUPCALLWAIT then Result:=Result+[lacfPICKUPCALLWAIT];
  {$IFDEF TAPI20}
  if Value and LINEADDRCAPFLAGS_PREDICTIVEDIALER = LINEADDRCAPFLAGS_PREDICTIVEDIALER then Result:=Result+[lacfPREDICTIVEDIALER];
  if Value and LINEADDRCAPFLAGS_QUEUE = LINEADDRCAPFLAGS_QUEUE then Result:=Result+[lacfQUEUE];
  if Value and LINEADDRCAPFLAGS_ROUTEPOINT = LINEADDRCAPFLAGS_ROUTEPOINT then Result:=Result+[lacfROUTEPOINT];
  if Value and LINEADDRCAPFLAGS_HOLDMAKESNEW = LINEADDRCAPFLAGS_HOLDMAKESNEW then Result:=Result+[lacfHOLDMAKESNEW];
  if Value and LINEADDRCAPFLAGS_NOINTERNALCALLS = LINEADDRCAPFLAGS_NOINTERNALCALLS then Result:=Result+[lacfNOINTERNALCALLS];
  if Value and LINEADDRCAPFLAGS_NOEXTERNALCALLS = LINEADDRCAPFLAGS_NOEXTERNALCALLS then Result:=Result+[lacfNOEXTERNALCALLS];
  if Value and LINEADDRCAPFLAGS_SETCALLINGID = LINEADDRCAPFLAGS_SETCALLINGID then Result:=Result+[lacfSETCALLINGID];
  {$ENDIF}
  {$IFDEF TAPI22}
  if Value and LINEADDRCAPFLAGS_ACDGROUP = LINEADDRCAPFLAGS_ACDGROUP then Result:=Result+[lacfACDGROUP];
  {$ENDIF}
end;

{ TAddressStatus }

constructor TAddressStatus.Create(ALine: HLine; AAddressID: DWord; Transl:TNotifyEvent);
var FLineAddressStatus:PLineAddressStatus;
    R:LongWord;
begin
  FForwards:=TForwardList.Create;
  FOnDevSpecTrans:= Transl;
  GetMem(FLineAddressStatus,SizeOf(TLineAddressStatus)+1000);
  try
    FLineAddressStatus^.dwTotalSize:=SizeOF(TLineAddressStatus)+1000;
    R:=LineGetAddressStatus(ALine,AAddressID,FLineAddressStatus);
    If R<>0 then RaiseTAPILineError(R);
    SetStatus(FLineAddressStatus);
  finally
    FreeMem(FLineAddressStatus);
  end;
end;

constructor TAddressStatus.Create(ALineAddressStatus: PLineAddressStatus);
begin
  SetStatus(ALineAddressStatus);
end;

destructor TAddressStatus.Destroy;
begin
  FForwards.Free;
  inherited;
end;

procedure TAddressStatus.GetDevSpecific(var AString: String);
begin
  if FDevSpecificSize > 0 then
    AString:=PChar(FDevSpecific);
end;

procedure TAddressStatus.GetDevSpecific(var APointer: Pointer);
begin
  if FDevSpecificSize > 0 then
    APointer:=@FDevSpecific;
end;

function TAddressStatus.GetForwards(Index: Integer): TForwardEntry;
begin
  Result:=FForwards[Index];
end;

function TAddressStatus.GetTerminalModes(Index: Integer): TLineTermModes;
begin
  try
    Result:=FTerminalModes[Index];
  except
    Result:=[tmmNoDef];
  end;
end;

procedure TAddressStatus.SetStatus(ALineAddressStatus: PLineAddressStatus);
var i:Integer;
    DSize,Offset:DWord;
    AForwardEntry:TForwardEntry;
    NumEntries:DWord;
begin
  FNumInUse:=ALineAddressStatus^.dwNumInUse;
  FNumActiveCalls:=ALineAddressStatus^.dwNumActiveCalls;
  FNumOnHoldCalls:=ALineAddressStatus^.dwNumOnHoldCalls;
  FNumOnHoldPendCalls:=ALineAddressStatus^.dwNumOnHoldPendCalls;
  FAddressFeatures:=IntToAddrFeatures(ALineAddressStatus^.dwAddressFeatures);
  FNumRingsNoAnswer:=ALineAddressStatus^.dwNumRingsNoAnswer;
  NumEntries:=ALineAddressStatus^.dwForwardNumEntries;
  if NumEntries > 0 then
  begin
    //SetLength(FForwards,SizeOf(TLineForward)*FForwardNumEntries);
    for i:=0 To NumEntries do
    begin
      AForwardEntry:=TForwardEntry.Create(GetDataFromTAPIStructP(ALineAddressStatus,ALineAddressStatus^.dwForwardOffset,DWord(ALineAddressStatus^.dwForwardSize div NumEntries)));
      FForwards.Add(AForwardEntry);
      //FForwards[i]:=TLineForward(^);
    end;
  end;
  if ALineAddressStatus^.dwTerminalModesSize > 0 then
  begin
    SetLength(FTerminalModes,SizeOf(TLineTermModes)*ALineAddressStatus^.dwTerminalModesSize div 4);
    DSize:=4;
    for i:=0 to (ALineAddressStatus^.dwTerminalModesSize div DSize)-1 do
    begin
      Offset:=ALineAddressStatus^.dwTerminalModesOffset+DWord(i)*DSize;
      FTerminalModes[i]:=IntToTermModes(DWord(GetDataFromTAPIStructP(ALineAddressStatus,Offset,DSize)));
    end;
  end;
  FDevSpecificSize:= ALineAddressStatus^.dwDevSpecificSize;
  {if ALineAddressStatus^.dwDevSpecificSize > 0 then
  begin
    SetLength(FDevSpecific,FDevSpecificSize);
    FDevSpecific:=GetDataFromTAPIStructP(ALineAddressStatus,ALineAddressStatus^.dwDevSpecificOffset,FDevSpecificSize);
  end; }
  if ALineAddressStatus^.dwDevSpecificSize > 0 then
  begin
    if Assigned(FOnDevSpecTrans) then
      FOnDevSpecTrans(Self);
  end;
end;



{TAddressCaps}

constructor TAddressCaps.Create(ALineApp:HLineApp;ADeviceID,AAddressID,AAPIVersion,AExtVersion:DWord);
var R:Longint;
    Size:DWord;
    FLineAddressCaps:PLineAddressCaps;
Label Init;
begin
  inherited Create;
  FCompletionMsgText:=TStringList.Create;
  {$IFDEF TAPI20}
  FDeviceClasses:=TStringList.Create;
  {$ENDIF}
  Size:=SizeOf(TLineAddresscaps)+1000;

  try
  Init:
  GetMem(PLINEADDRESSCAPS(FLineAddressCaps),Size);
  FillChar(FLineAddressCaps^,Size,#0);
  FLineAddressCaps.dwTotalSize:=Size;
  FLineAddressCaps.dwUsedSize:=0;
  R:=LineGetAddressCaps(ALineApp,ADeviceID,AAddressID,AAPIVersion,AExtVersion,FLineAddressCaps);
  if DWord(R)<> 0 then
  begin
    if DWord(R)=LINEERR_STRUCTURETOOSMALL then
    begin
      Size:=FLineAddressCaps^.dwNeededSize;
      FreeAndNil(FLineAddressCaps);
      goto Init;
    end
    else RaiseTAPILineError(R);
  end;
  SetCaps(FLineAddressCaps);
  finally
    FreeMem(FLineAddressCaps);
  end;
end;

constructor TAddressCaps.Create(ALineAddressCaps: PLINEADDRESSCAPS);
begin
  inherited Create;
  FCompletionMsgText:=TStringList.Create;
  {$IFDEF TAPI20}
  FDeviceClasses:=TStringList.Create;
  {$ENDIF}
  SetCaps(ALineAddressCaps);
  if Assigned(AppTAPIMgr)=False then AppTAPIMgr := TTAPIMgr.Create(Application);
  AppTAPIMgr.TAPIObjects.Add(self);
end;

destructor TAddressCaps.Destroy;
begin
  FCompletionMsgText.Free;
  {$IFDEF TAPI20}
  FDeviceClasses.Free;
  {$ENDIF}
  inherited Destroy;
end;

procedure TAddressCaps.SetCaps;
var S:String;
    Offset:DWord;
{$IFDEF TAPI20}
    ACallTreatmentItem:TCallTreatmentEntry;
    i:Integer;
{$ENDIF}
begin
  FAddress:=GetDataFromTAPIStruct(Caps,Caps.dwAddressOffset,Caps.dwAddressSize);
  FAddressSharing:=IntToAddressSharing(Caps.dwAddressSharing);
  FAddressStates:=IntToAddressStates(Caps.dwAddressStates);
  FLineDeviceID:=Caps.dwLineDeviceID;
  FDevSpecificSize:=Caps.dwDevSpecificSize;
  //FDevSpecific:=GetDataFromTAPIStructP(Caps,Caps.dwDevSpecificOffset,FDevSpecificSize);
  if Caps.dwDevSpecificSize > 0 then
  begin
    if Assigned(FOnDevSpecTrans) then
      FOnDevSpecTrans(Self);
  end;
  FCallInfoStates:=IntToCallInfoStates(Caps.dwCallInfoStates);
  FCalledIDFlags:=IntToCallPartyID(Caps.dwCalledIDFlags);
  FCallerIDFlags:=IntToCallPartyID(Caps.dwCallerIDFlags);
  FConnectedIDFlags:=IntToCallPartyID(Caps.dwConnectedIDFlags);
  FRedirectingIDFlags:=IntToCallPartyID(Caps.dwRedirectingIDFlags);
  FRedirectionIDFlags:=IntToCallPartyID(Caps.dwRedirectionIDFlags);
  FCallStates:=IntToCallStates(Caps.dwCallStates);
  FDialToneModes:=IntToDialToneModes(Caps.dwDialToneModes);
  FBusyModes:=IntToBusyModes(Caps.dwBusyModes);
  FSpecialInfo:=IntToSpecialInfo(Caps.dwSpecialInfo);
  FDisconnectModes:=IntToDisconnectModes(Caps.dwDisconnectModes);
  FMaxNumActiveCalls:=Caps.dwMaxNumActiveCalls;
  FMaxNumOnHoldCalls:=Caps.dwMaxNumOnHoldCalls;
  FMaxNumOnHoldPentingCalls:=Caps.dwMaxNumOnHoldPendingCalls;
  FMaxNumConference:=Caps.dwMaxNumConference;
  FMaxNumTransConf:=Caps.dwMaxNumTransConf;
  FAddrCapFlags:=IntToAddrCapsFlags(Caps.dwAddrCapFlags);
  FCallFeatures:=IntToCallFeatures(Caps.dwCallFeatures);
  FRemoveFromConfCaps:=IntToRemoveFromConf(Caps.dwRemoveFromConfCaps);
  FRemoveFromConfState:=IntToCallStates(Caps.dwRemoveFromConfState);
  FTransferModes:=IntToTransferModes(Caps.dwTransferModes);
  FParkModes:=IntToParkModes(Caps.dwParkModes);
  FForwardModes:=IntToForwardModes(Caps.dwForwardModes);
  FMaxForwardEntries:=Caps.dwMaxForwardEntries;
  FMaxSpecificEntries:=Caps.dwMaxSpecificEntries;
  FMinFwdNumRings:=Caps.dwMinFwdNumRings;
  FMaxFwdNumRings:=Caps.dwMaxFwdNumRings;
  FMaxCallCompletions:=Caps.dwMaxCallCompletions;
  FCallCompletionConds:=IntToCallComplConds(Caps.dwCallCompletionConds);
  FCallCompletionModes:=IntToCallComplModes(Caps.dwCallCompletionModes);
  FNumCompletionMessages:=Caps.dwNumCompletionMessages;
  if (Caps.dwNumCompletionMessages >0)and (Caps.dwCompletionMsgTextSize >0) then
  begin
    Offset:=Caps.dwCompletionMsgTextOffset;
    while (Offset- Caps.dwCompletionMsgTextOffset)< Caps.dwCompletionMsgTextSize-1 do
    begin
      S:= GetDataFromTAPIStruct(Caps,Offset,Caps.dwCompletionMsgTextSize) ;
      FCompletionMsgText.Add(S);
      Offset:=Offset+DWord(Caps.dwCompletionMsgTextEntrySize);
    end;
  end;
  FAddressFeatures:=IntToAddrFeatures(Caps.dwAddressFeatures);
  {$IFDEF TAPI20}
  FPredictiveAutoTransferStates:=IntToCallStates(Caps.dwPredictiveAutoTransferStates);
  FNumCallTreatments:=Caps.dwNumCallTreatments;
  if FNumCallTreatments > 0 then
  begin
    for i:=0 to FNumCallTreatments-1 do
    begin
      Offset:=Caps^.dwCallTreatmentListOffset+DWord(SizeOf(TLineCallTreatmentEntry)*i);
      ACallTreatmentItem:=TCallTreatmentEntry.Create(GetDataFromTAPIStructP(Caps,Offset,Caps^.dwCallTreatmentListSize));
      FCallTreatmentList.Add(ACallTreatmentItem);
    end;
  end;
  if (Caps.dwDeviceClassesSize > 0) and (Caps.dwDeviceClassesOffset < Caps.dwUsedSize) then
  begin
    Offset:=Caps.dwDeviceClassesOffset;
    while (Offset- Caps.dwDeviceClassesOffset)< Caps.dwDeviceClassesSize-1 do
    begin
      S:=GetDataFromTAPIStruct(Caps,Offset,Caps.dwDeviceClassesSize);
      FDeviceClasses.Add(S);
      Offset:=Offset+DWord(Length(S))+1;
    end;
  end;
  FMaxCallDataSize:=Caps.dwMaxCallDataSize;
  FCallFeatures2:=IntToCallFeatures2(Caps.dwCallFeatures);
  FMaxNoAnswerTimeout:=Caps.dwMaxNoAnswerTimeout;
  FConnectedModes:=IntToConnectedModes(Caps.dwConnectedModes);
  FOfferingModes:=IntToOfferingModes(Caps.dwOfferingModes);
  FAvailableMediaModes:=IntToMediaModes(Caps.dwAvailableMediaModes);
  {$ENDIF}
end;


{ TTAPIAddress }

constructor TTAPIAddress.Create(AOwner: TComponent);
begin
  inherited;
  FCountryCode:=0;
  FAddressMode:=amDialableAddr;
  FAddressID:=0;
end;

destructor TTAPIAddress.Destroy;
begin
  inherited;
end;

function TTAPIAddress.GetAddressCaps: TAddressCaps;
begin
  Result:=nil;
  if Assigned(FLine.Device) then
  begin
    if Assigned(FAddressCaps)=False then
      FAddressCaps:=TAddressCaps.Create(FLine.Device.Service.Handle,FLine.Device.ID,FAddressID,FLine.Device.APIVersion,FLine.Device.ExtVersion);
    Result:=FAddressCaps;
  end;
end;

function TTAPIAddress.GetAddressStatus: TAddressStatus;
begin
  if Assigned(FAddressStatus) then FreeAndNil(FAddressStatus);
  FAddressStatus:=TAddressStatus.Create(FLine.Handle,FAddressID,FOnDevSpecTrans);
  Result:=FAddressStatus;
end;

function TTAPIAddress.GetDialableAdress: String;
var R:longint;
    LTO:PLineTranslateOutput;
begin
  Result:='';
  GetMem(LTO,SizeOf(TLineTranslateOutput)+1000);
  LTO^.dwTotalSize:=SizeOf(TLineTranslateOutput)+1000;
  try
    R:=LineTranslateAddress(FLine.Device.Service.Handle,FLine.Device.ID,FLine.Device.APIVersion,PChar(FAddress),0,FTranslateOptions,LTO);
    if R<>0 then RaiseTAPILineError(R)
    else
      if LTO^.dwDialableStringSize >0 then
        Result:=GetDataFromTAPIStruct(LTO,LTO^.dwDialableStringOffset,LTO^.dwDialableStringSize);
  finally
    FreeMem(LTO);
  end;
end;

function TTAPIAddress.GetMode: DWord;
begin
  Result:=AddressModeToInt(FAddressMode);
end;

function TTAPIAddress.GetStateMsg: DWord;
begin
  FAddressStateMessages:=[];
  if Assigned(FOnOther) then FAddressStateMessages:=FAddressStateMessages +[asOther];
  if Assigned(FOnDevSpecific) then FAddressStateMessages:=FAddressStateMessages +[asDevSpecific];
  if Assigned(FOnInUseZero) then FAddressStateMessages:=FAddressStateMessages +[asInUseZerro];
  if Assigned(FOnInUseOne) then FAddressStateMessages:=FAddressStateMessages +[asInUseOne];
  if Assigned(FOnInUseMany) then FAddressStateMessages:=FAddressStateMessages +[asInUseMany];
  if Assigned(FOnNumCalls) then FAddressStateMessages:=FAddressStateMessages +[asNumCalls];
  if Assigned(FOnForward) then FAddressStateMessages:=FAddressStateMessages +[asForward];
  if Assigned(FOnTerminals) then FAddressStateMessages:=FAddressStateMessages +[asTerminals];
  if Assigned(FOnCapsChanged) then FAddressStateMessages:=FAddressStateMessages +[asCapSchanged];
  Result:=AddressStatesToInt(FAddressStateMessages);  
end;

function TTAPIAddress.GetTranslateOptions: TLineTranslateOptions;
begin
  Result:=IntToTranslateOptions(FTranslateOptions);
end;

procedure TTAPIAddress.SetAddressID(const Value: DWord);
begin
  if Assigned(FAddressCaps) then FreeAndNil(FAddressCaps);
  FAddressID := Value;
end;

procedure TTAPIAddress.SetTranslateOptions(
  const Value: TLineTranslateOptions);
begin
  FTranslateOptions:=TranslateOptionsToInt(Value);
end;

procedure TTAPIAddress.StateChange(AddressStatus:DWord);
{$IFDEF DEBUG}
var LAS:String;
{$ENDIF}
begin
  if Assigned(FAddressStatus) then FreeAndNil(FAddressStatus);
  {$IFDEF DEBUG}
  case AddressStatus of
    LINEADDRESSSTATE_CAPSCHANGE:LAS:='LINEADDRESSSTATE_CAPSCHANGE';
    LINEADDRESSSTATE_DEVSPECIFIC:LAS:='LINEADDRESSSTATE_DEVSPECIFIC';
    LINEADDRESSSTATE_FORWARD:LAS:='LINEADDRESSSTATE_FORWARD';
    LINEADDRESSSTATE_INUSEMANY:LAS:='LINEADDRESSSTATE_INUSEMANY';
    LINEADDRESSSTATE_INUSEONE:LAS:='LINEADDRESSSTATE_INUSEONE';
    LINEADDRESSSTATE_INUSEZERO:LAS:='LINEADDRESSSTATE_INUSEZERO';
    LINEADDRESSSTATE_NUMCALLS:LAS:='LINEADDRESSSTATE_NUMCALLS';
    LINEADDRESSSTATE_OTHER:LAS:='LINEADDRESSSTATE_OTHER';
    LINEADDRESSSTATE_TERMINALS:LAS:='LINEADDRESSSTATE_TERMINALS';
  end;
  OutputDebugString(PChar(LAS));
  {$ENDIF}
  case AddressStatus of
    LINEADDRESSSTATE_CAPSCHANGE:
    begin
      if Assigned(FAddressCaps) then FreeAndNil(FAddressCaps);
      FAddressCaps:=TAddressCaps.Create(FLine.Device.Service.Handle,FLine.Device.ID,FAddressID,FLine.Device.APIVersion,FLine.Device.ExtVersion);
      if Assigned(FOnCapsChanged) then FOnCapsChanged(self);
    end;
    LINEADDRESSSTATE_DEVSPECIFIC:if Assigned(FOnDevSpecific) then FOnDevSpecific(self);
    LINEADDRESSSTATE_FORWARD:if Assigned(FOnForward) then FOnForward(self);
    LINEADDRESSSTATE_INUSEMANY:if Assigned(FOnInUseMany) then FOnInUseMany(self);
    LINEADDRESSSTATE_INUSEONE:if Assigned( FOnInUseOne) then  FOnInUseOne(self);
    LINEADDRESSSTATE_INUSEZERO:if Assigned(FOnInUseZero) then FOnInUseZero(self);
    LINEADDRESSSTATE_NUMCALLS:if Assigned(FOnNumCalls) then FOnNumCalls(self);
    LINEADDRESSSTATE_OTHER:if Assigned(FOnOther) then FOnOther(self);
    LINEADDRESSSTATE_TERMINALS:if Assigned(FOnTerminals) then FOnTerminals(self);
  end;
end;

procedure TTAPIAddress.MakeCall;
begin
  FOutBoundCall.MakeCall(FLine.Handle,DialableAddress,FCountryCode);
end;


function TTAPIAddress.GetNumRings: DWord;
var R:Longint;
    NumR:DWord;
begin
  Result:=FNumRings;
  if Assigned(FLine) then
  begin
    if FLine.Handle <> 0 then
    begin
      R:=LineGetNumRings(FLine.Handle,FAddressID,NumR);
      if R<>0 then RaiseTAPILineError(R);
      Result:=NumR;
    end;
  end;
end;



procedure TTAPIAddress.SetNumRings(const Value: DWord);
var R:Longint;
begin
  FNumRings:=Value;
  if Assigned(FLine) then
  begin
    if FLine.Handle <> 0 then
    begin
      R:=LineSetNumRings(FLine.Handle,FAddressID,Value);
      if R<>0 then RaiseTAPILineError(R);
    end;
  end;
end;

procedure TTAPIAddress.SetStatusMessages;
var R:Longint;
    DState,AState:DWord;
begin
  If FLine.Active then
  begin
    {$IFDEF DEBUG}
    R:=LineSetStatusMessages(FLine.Handle,$01ffffff,$1FF);
    {$ELSE}
    R:=LineSetStatusMessages(FLine.Handle,FLine.Device.States,GetStateMsg);
    {$ENDIF}
    if R<-1 then
    begin
      RaiseTAPILineError(R);
    end
    else
    begin
      R:=LineGetStatusMessages(FLine.Handle,DState,AState);
      if R<-1 then
      begin
        RaiseTAPILineError(R);
      end
      else
      begin
        R:=LineSetStatusMessages(FLine.Handle,DState,AState);
        if R<-1 then
        begin
          RaiseTAPILineError(R);
        end;
      end;
    end;
  end;
end;

procedure TTAPIAddress.SetLine(const Value: TTAPILine);
begin
  FLine := Value;
end;

procedure TTAPIAddress.AppNewCall(hDevice, dwParam1, dwParam2, dwParam3:LongWord);
begin
  if dwParam3=0 then
  begin
    if cpOwner in FLine.CallPrivileges then dwParam3:=LINECALLPRIVILEGE_OWNER else
      dwParam3:=LINECALLPRIVILEGE_Monitor;
  end;
  if dwParam3=LINECALLPRIVILEGE_OWNER then
  begin
    if FLine.Handle=hDevice then
    begin
      if FAddressID=dwParam1 then
      begin
        if Assigned(FInBoundCall)then
        begin
          FInBoundCall.Handle:=HCall(dwParam2);
          if Assigned(FOnAppNewCall) then FOnAppNewCall(self,FInBoundCall,dwParam1,IntToCallPrivilege(dwParam3));
        end;
      end;
    end;
  end;
  if dwParam3=LINECALLPRIVILEGE_Monitor then
  begin
    if FLine.Handle=hDevice then
    begin
      if FAddressID=dwParam1 then
      begin 
        if Assigned(FMonitorCall)then
        begin
          FMonitorCall.Handle:=HCALL(dwParam2);
          if Assigned(FOnAppNewCall) then FOnAppNewCall(self,FMonitorCall,dwParam1,IntToCallPrivilege(dwParam3));
        end;
      end; 
    end;
  end;
end;



procedure TTAPIAddress.Dial;//(DestAddress: String;CountryCode: DWord);
var R:LongInt;
begin
  //R:=LineDial(FOutBoundCall.Handle,PChar(DestAddress),CountryCode);
  R:=LineDial(FOutBoundCall.Handle,PChar(DialableAddress),FCountryCode);
  if R<-1 then
  begin
    RaiseTAPILineError(R);
  end
  else
  begin
    AppTAPIMgr.AsyncList.Add(afDial,R,self);
  end;
end;

procedure TTAPIAddress.GetID(var ACall: TTAPICall;
  var AddressID: Dword;Select:TLineCallSelect; var VarStr: TVarString);
var R:Longint;
begin
  R:=LineGetID(FLine.Handle,AddressID,ACall.Handle,CallSelectToInt(Select),@varstr,PChar(FLine.Device.DeviceClass));
  if R<-1 then
  begin
    RaiseTAPILineError(R);
  end;
end;

{$IFDEF TAPI20}
{procedure TTAPIAddress.SetAgent(const Value: TTAPILineAgent);
begin
  if Value<>FAgent then
  begin
    FAgent := Value;
    FAgent.AddressID:=FID;
  end;
end; }
{$ENDIF}

{procedure TTAPIAddress.SetActive(const Value: Boolean);
begin
  if Value<> FActive then
  begin
    if Assigned(FLine) then
    begin
      Line.Active:=Value;
      if Line.Active then SetStatusMessages;
    end;
    FActive := Value;
  end;
end;  }

procedure TTAPIAddress.PerformMsg(Msg: TCMTAPI);
{$IFNDEF TAPI20}
var TempCall: TTAPICall;
{$ENDIF}
begin
  inherited;
  with Msg.TAPIRec^ do
  begin
    if Assigned(FLine) then
    begin
      if FLine.Handle=hDevice then
      begin
        case dwMsg of
          LINE_ADDRESSSTATE:if ID=dwParam1 then StateChange(dwParam2);
          {$IFNDEF TAPI20}
          LINE_CALLSTATE:
            begin
              if Assigned(FLine)and Assigned(FInboundCall) then
              begin
                if dwParam3=LINECALLPRIVILEGE_OWNER then
                begin
                  TempCall:=TTAPICall.Create(nil);
                  TempCall.Handle:=hdevice;
                  if (TempCall.Info.AddressID=ID)and (TempCall.Info.LineHandle=FLine.Handle) then
                  begin
                    //New Call ?
                    if not(InboundCall.Handle=hDevice) then
                    begin
                      AppNewCall(TempCall.Info.LineHandle,TempCall.Info.AddressID,hdevice,dwParam3);
                      InboundCall.LineCallState(dwParam1,dwParam2,dwParam3);
                    end;
                  end;
                  TempCall.Free;
                end;
              end;
            end;
          {$ENDIF}
          {$IFDEF TAPI20}
          LINE_APPNEWCALL: {if ID=dwParam1 then }AppNewCall(hDevice,dwParam1,dwParam2,dwParam3);
          {$ENDIF}
        end;
      end;
    end;
  end;
end;

procedure TTAPIAddress.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if Operation=opRemove then
  begin
    if AComponent=FInboundCall then
      FInboundCall:=nil;
    if AComponent=FOutboundCall then
      FOutboundCall:=nil;
    if AComponent=FMonitorCall then
      FMonitorCall:=nil;
    if AComponent=FLine then
      FLine:=nil;
  end;
end;

procedure TTAPIAddress.GetAddressID(var AddrID: PChar);
var R:Longint;
begin
  R:=LineGetAddressID(FLine.Handle,FAddressID,LINEADDRESSMODE_DIALABLEADDR,AddrID,SizeOf(AddrID));
  if R<-1 then
  begin
    RaiseTAPILineError(R);
  end;
end;

{ TForwardEntry }

constructor TForwardEntry.Create(AForwardEntry: PLineForward);
begin
  FForwardMode:=IntToForwardMode(AForwardEntry^.dwForwardMode);
  FCallerAddress:=GetDataFromTAPIStruct(AForwardEntry,
    AForwardEntry^.dwCallerAddressOffset,AForwardEntry^.dwCallerAddressSize);
  FDestCountryCode:=AForwardEntry^.dwDestCountryCode;
  FDestAddress:=GetDataFromTAPIStruct(AForwardEntry,
    AForwardEntry^.dwDestAddressOffset,AForwardEntry^.dwDestAddressSize);;
end;

destructor TForwardEntry.Destroy;
begin
  inherited;
end;

{ TCallTreatmentEntry }
{$IFDEF TAPI20}
constructor TCallTreatmentEntry.Create(
  ALineCallTreatmentEntry: PLineCallTreatmentEntry);
begin
  FID:=ALineCallTreatmentEntry^.dwCallTreatmentID;
  FName:=GetDataFromTAPIStruct(ALineCallTreatmentEntry,
    ALineCallTreatmentEntry^.dwCallTreatmentNameOffset,
    ALineCallTreatmentEntry^.dwCallTreatmentNameSize);
end;

destructor TCallTreatmentEntry.Destroy;
begin
  inherited;
end;
{$ENDIF}
end.
