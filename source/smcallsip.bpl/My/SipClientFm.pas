unit SipClientFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MMSystem, SyncObjs, ButtonGroup, ExtCtrls, DateUtils, ComCtrls,
  IniFiles,

  IdDnsResolver,
  WavePlayers, WaveRecorders, WaveStorage, WaveUtils,

  BisAudioWave, BisSip, BisSdp, BisRtp, BisThreads, BisExceptNotifier,
  BisSipPhone;

type

  TSipClientLine=class(TGrpButtonItem)
  private
    FLine: TBisSipPhoneLine;
    FDateCreate: TDateTime;
    FDateConnect: Variant;
    FAnswerIndex: Integer;
    FInStream: TMemoryStream;
    FTickStarted: Boolean;
    FFirstTick: Int64;
    FFirstFreq: Int64;
    FLastTick: Int64;
    FLastFreq: Int64;
    FMissedCount: Cardinal;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    function Line: TBisSipPhoneLine;
    procedure UpdateItemCatption;

    property InStream: TMemoryStream read FInStream;

    property DateConnect: Variant read FDateConnect write FDateConnect;
    property AnswerIndex: Integer read FAnswerIndex write FAnswerIndex;
    property TickStarted: Boolean read FTickStarted write FTickStarted;

    property FirstTick: Int64 read FFirstTick write FFirstTick;
    property FirstFreq: Int64 read FFirstFreq write FFirstFreq;

    property LastTick: Int64 read FLastTick write FLastTick; 
    property LastFreq: Int64 read FLastFreq write FLastFreq;

    property MissedCount: Cardinal read FMissedCount write FMissedCount; 
  end;

  TButtonGroup=class(ButtonGroup.TButtonGroup)
  private
    FMissedLockCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Find(Line: TBisSipPhoneLine): TSipClientLine;
    function Current: TSipClientLine;
    function GetItem(Index: Integer): TSipClientLine;

    property MissedLockCount: Integer read FMissedLockCount write FMissedLockCount;
  end;

  TSipClientForm = class(TForm)
    GroupBoxRegister: TGroupBox;
    LabelRemoteHost: TLabel;
    LabelRemotePort: TLabel;
    LabelUserName: TLabel;
    LabelPassword: TLabel;
    EditRemoteHost: TEdit;
    EditRemotePort: TEdit;
    EditUserName: TEdit;
    EditPassword: TEdit;
    ButtonConnect: TButton;
    ButtonDisconnect: TButton;
    GroupBoxCall: TGroupBox;
    ButtonDial: TButton;
    GroupBoxLog: TGroupBox;
    MemoLog: TMemo;
    LabelNumber: TLabel;
    ButtonHangup: TButton;
    CheckBoxLog: TCheckBox;
    ButtonAnswer: TButton;
    ButtonGroupLines: TButtonGroup;
    ButtonPlay: TButton;
    ButtonClear: TButton;
    ButtonHold: TButton;
    EditDtmf: TEdit;
    TimerExpires: TTimer;
    TimerCounter: TTimer;
    ComboBoxProviders: TComboBox;
    CheckBoxAccept: TCheckBox;
    ButtonTimers: TButton;
    ComboBoxPhones: TComboBox;
    CheckBoxUseRport: TCheckBox;
    CheckBoxUseReceived: TCheckBox;
    LabelLocalHost: TLabel;
    EditLocalHost: TEdit;
    LabelLocalPort: TLabel;
    EditLocalPort: TEdit;
    TimerHangup: TTimer;
    EditCount: TEdit;
    LabelCount: TLabel;
    UpDownCount: TUpDown;
    LabelLifeTime: TLabel;
    EditLifeTime: TEdit;
    UpDownLifetime: TUpDown;
    LabelOffset: TLabel;
    EditOffset: TEdit;
    UpDownOffset: TUpDown;
    TimerDial: TTimer;
    CheckBoxTimers: TCheckBox;
    CheckBoxDtmf: TCheckBox;
    ComboBoxAnswer: TComboBox;
    EditExpires: TEdit;
    UpDownExpires: TUpDown;
    ButtonTerminate: TButton;
    LabelExpires: TLabel;
    LabelProvider: TLabel;
    TimerUpdateItems: TTimer;
    LabelBuffer: TLabel;
    EditBuffer: TEdit;
    UpDownBuffer: TUpDown;
    LabelBufferCount: TLabel;
    EditBufferCount: TEdit;
    UpDownBufferCount: TUpDown;
    Button1: TButton;
    Button2: TButton;
    ButtonSendDtmf: TButton;
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonDialClick(Sender: TObject);
    procedure ButtonHangupClick(Sender: TObject);
    procedure ButtonAnswerClick(Sender: TObject);
    procedure ButtonGroupLinesButtonClicked(Sender: TObject; Index: Integer);
    procedure ButtonPlayClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonHoldClick(Sender: TObject);
    procedure TimerExpiresTimer(Sender: TObject);
    procedure TimerCounterTimer(Sender: TObject);
    procedure ComboBoxProvidersChange(Sender: TObject);
    procedure ButtonTimersClick(Sender: TObject);
    procedure CheckBoxUseRportClick(Sender: TObject);
    procedure CheckBoxUseReceivedClick(Sender: TObject);
    procedure TimerHangupTimer(Sender: TObject);
    procedure TimerDialTimer(Sender: TObject);
    procedure CheckBoxTimersClick(Sender: TObject);
    procedure ButtonTerminateClick(Sender: TObject);
    procedure TimerUpdateItemsTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonSendDtmfClick(Sender: TObject);
  private
    FPhone: TBisSipPhone;
    FPlayer: TBisAudioLivePlayer;
    FRecorder: TBisAudioLiveRecorder;
    FCounter: Integer;
    FCurrentIndex: Integer;
    FAppPath: String;
    FIniFile: TMemIniFile;
    FPlaying: Boolean;
    FNotifier: TBisExceptNotifier;
    FTestConverter: TWaveConverter;
    FPlayLock: TCriticalSection;
    FPlayerFormat: TWaveFormatEx;

//    Obbb: TObject;

    procedure NotifierException(Notifier: TBisExceptNotifier; const E: Exception; const OSException: Boolean);

    procedure PhoneSend(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
    procedure PhoneReceive(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
    procedure PhoneConnect(Sender: TBisSipPhone);
    procedure PhoneError(Sender: TBisSipPhone; const Error: String);
    procedure PhoneTimeout(Sender: TBisSipPhone);
    procedure PhoneLineCreate(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDestroy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    function PhoneLineCheck(Sender: TBisSipPhone; Line: TBisSipPhoneLine; Message: TBisSipMessage): Boolean;
    procedure PhoneLineRing(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineConnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDisconnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineInData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
    procedure PhoneLineOutData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
    procedure PhoneLineHold(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLinePlayEnd(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDtmf(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Code: Char);
    procedure PhoneLineDetectBusy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);

    function PlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
    function PlayerDataTest(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
    function PlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
    procedure PlayerActivate(Sender: TObject);
    procedure PlayerDeactivate(Sender: TObject);
    procedure PlayerError(Sender: TObject);

    procedure RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
    procedure RecorderDataTest(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
    procedure RecorderActivate(Sender: TObject);
    procedure RecorderDeactivate(Sender: TObject);

    procedure Log(const S1: String; const S2: String=''; const ThreadName: String='');
    procedure OutputStack;


    procedure Button1Start;
    procedure Button1Stop;

    procedure UpdateButtons;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  SipClientForm: TSipClientForm;

implementation

uses
     FileCtrl, TypInfo, Math, StrUtils,
     IdException, IdStack,

     BisUtils, BisNetUtils;

{$R *.dfm}

const
  SPlay='Play';
  SHold='Hold';
  SUnHold='UnHold';
  SStop='Stop';
  SProviders='providers';
  SMain='Main';
  SWidth='Width';
  SHeight='Height';
  SLineNotAssigned='Line is not assigned.';
  SFilePlayWav='play.wav';
  SFileHoldWav='hold.wav';
  SFileInWav='in.wav';
  SFileOutWav='out.wav';
  SFileIni='sip.ini';
  SFilePhones='phones.txt';

function GetLocalIP: String;
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    GetIPList(List);
    if List.Count>0 then
      Result:=List[0];
  finally
    List.Free;
  end;
end;

{ TSipClientLine }

constructor TSipClientLine.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDateCreate:=Now;
  FDateConnect:=Null;
  FInStream:=TMemoryStream.Create;
end;

destructor TSipClientLine.Destroy;
begin
  FInStream.Free;
  inherited Destroy;
end;

function TSipClientLine.Line: TBisSipPhoneLine;
begin
  Result:=FLine;
  if not Assigned(Result) then
    raise Exception.Create(SLineNotAssigned);
end;

procedure TSipClientLine.UpdateItemCatption;
var
  D: Int64;
  T1,T2: TDateTime;
begin
  if Assigned(FLine) then begin
    if TickStarted then begin
      D:=GetTickDifference(FFirstTick,FFirstFreq,FLastTick,FLastFreq,dtMilliSec);
      T1:=Now;
      T2:=IncMilliSecond(T1,D);
      Caption:=FLine.Number+':'+
               ' T='+FormatDateTime('nn:ss.zzz',T2-T1)+
               ' SIn='+FormatFloat('#0.0',D/Line.RemotePackets.Count)+
               ' In='+IntToStr(FLine.RemotePackets.Count)+
               ' Out='+IntToStr(FLine.LocalPackets.Count)+
               ' M='+IntToStr(FMissedCount);
    end else
      Caption:=FLine.Number;
  end;
end;

{ TButtonGroup }

constructor TButtonGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TButtonGroup.Destroy;
begin
  inherited Destroy;
end;

function TButtonGroup.GetItem(Index: Integer): TSipClientLine;
begin
  Result:=TSipClientLine(inherited Items[Index]);
end;

function TButtonGroup.Find(Line: TBisSipPhoneLine): TSipClientLine;
var
  i: Integer;
  Item: TSipClientLine;
begin
  Result:=nil;
  if Assigned(Line) then begin
    for i:=0 to Items.Count-1 do begin
      Item:=GetItem(i);
      if Item.FLine=Line then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function TButtonGroup.Current: TSipClientLine;
begin
  Result:=nil;
  if ItemIndex<>-1 then
    Result:=GetItem(ItemIndex);
end;

{ TSipClientForm }

constructor TSipClientForm.Create(AOwner: TComponent);
var
  Providers: TStringList;
  i: Integer;
begin
  inherited Create(AOwner);

  FNotifier:=TBisExceptNotifier.Create(Self);
  FNotifier.OnException:=NotifierException;
  FNotifier.IngnoreExceptions.Add(EIdSocketError);

  FAppPath:=ExtractFilePath(Application.ExeName);

  EditLocalHost.Text:=GetLocalIP;
  EditLocalHost.Text:='192.168.1.3';
  EditLocalPort.Text:='5060';

  FPhone:=TBisSipPhone.Create(nil);
  FPhone.UserAgent:='SIP Client';
  FPhone.KeepAliveInterval:=0;
  FPhone.MaxActiveLines:=5;
  FPhone.ConfirmCount:=3;
  FPhone.Expires:=60;
  FPhone.RequestRetryCount:=3;
  FPhone.RequestTimeOut:=1000;
  FPhone.SweepInterval:=0;
//  FPhone.DialTimeout:=20000;
//  FPhone.TalkTimeout:=40000;
  FPhone.HoldMode:=lhmEmulate;
  FPhone.CollectRemotePackets:=true;
  FPhone.CollectLocalPackets:=true;
  FPhone.DtmfEnabled:=true;
  FPhone.DtmfThreshold:=900;
  FPhone.DtmfTimeout:=200;
  FPhone.DetectBusyEnabled:=false;
  FPhone.ThreadOptions:=[toLineInData,toError,toLineCheck,toLineConnect]; // be carefull
//  FPhone.ThreadOptions:=[toLineInData,toLineOutData]; 
//  FPhone.ThreadOptions:=AllThreadOptions;

  FPhone.OnSend:=PhoneSend;
  FPhone.OnReceive:=PhoneReceive;
  FPhone.OnConnect:=PhoneConnect;
  FPhone.OnDisconnect:=PhoneConnect;
  FPhone.OnError:=PhoneError;
  FPhone.OnTimeout:=PhoneTimeout;
  FPhone.OnLineCreate:=PhoneLineCreate;
  FPhone.OnLineDestroy:=PhoneLineDestroy;
  FPhone.OnLineCheck:=PhoneLineCheck;
  FPhone.OnLineRing:=PhoneLineRing;
  FPhone.OnLineConnect:=PhoneLineConnect;
  FPhone.OnLineDisconnect:=PhoneLineDisconnect;
  FPhone.OnLineInData:=PhoneLineInData;
  FPhone.OnLineOutData:=PhoneLineOutData;
  FPhone.OnLineHold:=PhoneLineHold;
  FPhone.OnLinePlayEnd:=PhoneLinePlayEnd;
  FPhone.OnLineDtmf:=PhoneLineDtmf;
  FPhone.OnLineDetectBusy:=PhoneLineDetectBusy;

  FPlayLock:=TCriticalSection.Create;

  FPlayer:=TBisAudioLivePlayer.Create(nil);
  FPlayer.BufferInternally:=true;
  FPlayer.PCMFormat:=Mono16bit8000Hz;
  FPlayer.DeviceID:=0;
  FPlayer.Async:=true;
  FPlayer.OnActivate:=PlayerActivate;
  FPlayer.OnDeactivate:=PlayerDeactivate;
  FPlayer.OnError:=PlayerError;
  FPlayer.OnDataPtr:=PlayerDataPtr; // works only for BufferInternally:=false;
  FPlayer.OnData:=PlayerData; // works only for BufferInternally:=true;

  SetPCMAudioFormatS(@FPlayerFormat,FPlayer.PCMFormat);

  FRecorder:=TBisAudioLiveRecorder.Create(nil);
  FRecorder.DeviceID:=0;
  FRecorder.Async:=true;
  FRecorder.PCMFormat:=nonePCM;
  FRecorder.OnFormat:=RecorderFormat;
  FRecorder.OnData:=RecorderData;
  FRecorder.OnActivate:=RecorderActivate;
  FRecorder.OnDeactivate:=RecorderDeactivate;

  FTestConverter:=TWaveConverter.Create;
  FTestConverter.LoadFromFile(FAppPath+SFileHoldWav);
  FTestConverter.ConvertToPCM(FPlayer.PCMFormat);
  FTestConverter.Stream.Position:=FTestConverter.DataOffset;

  FIniFile:=TMemIniFile.Create(FAppPath+SFileIni);
  Width:=FIniFile.ReadInteger(SMain,SWidth,Width);
  Height:=FIniFile.ReadInteger(SMain,SHeight,Height);

  Providers:=TStringList.Create;
  try
    FIniFile.ReadSectionValues(SProviders,Providers);
    ComboBoxProviders.Clear;
    for i:=0 to Providers.Count-1 do begin
      ComboBoxProviders.Items.Add(Providers[i]);
    end;
    if ComboBoxProviders.Items.Count>0 then
      ComboBoxProviders.ItemIndex:=0;

    ComboBoxProvidersChange(nil);
  finally
    Providers.Free;
  end;

  ButtonGroupLines.Items.Clear;

  ComboBoxPhones.Items.LoadFromFile(FAppPath+SFilePhones);
  if ComboBoxPhones.Items.Count>0 then
    ComboBoxPhones.ItemIndex:=0;

  UpdateButtons;

  timeBeginPeriod(1);
end;

destructor TSipClientForm.Destroy;
begin
  FIniFile.Free;
  FTestConverter.Free;
  FRecorder.Free;
  FPlayer.Free;
  FPlayLock.Free;
  FPhone.Free;
  FNotifier.Free;
  inherited Destroy;
end;

type
  TSipClientFormLogSync=class(TObject)
  private
    FS1,FS2,FThreadName: String;
    FForm: TSipClientForm;
    procedure Sync;
  public
    class procedure Log(Form: TSipClientForm; const S1,S2: String);
  end;

{ TSipClientFormLogSync }

procedure TSipClientFormLogSync.Sync;
begin
  try
    FForm.Log(FS1,FS2,FThreadName);
  finally
    Free;
  end;
end;

class procedure TSipClientFormLogSync.Log(Form: TSipClientForm; const S1,S2: String);
begin
  with TSipClientFormLogSync.Create do begin
    FForm:=Form;
    FS1:=S1;
    FS2:=S2;
    FThreadName:=GlobalThreads.NameByID(GetCurrentThreadId);
    TBisThread.StaticQueue(Sync);
  end;
end;

procedure TSipClientForm.Log(const S1: String; const S2: String=''; const ThreadName: String='');
var
  S3: String;
  Str: TStringList;
  i: Integer;
begin
  if IsMainThread then begin
    S3:=ThreadName;
    if S3<>'' then
      S3:=' ('+S3+')';
    if CheckBoxLog.Checked then begin
      MemoLog.Lines.Add(FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz',Now)+' === '+S1+S3);
      MemoLog.Lines.Add(DupeString('-',75)+'begin');
      Str:=TStringList.Create;
      try
        Str.Text:=S2;
        for i:=0 to Str.Count-1 do begin
          if Trim(Str[i])<>'' then
            MemoLog.Lines.Add(Str[i])
          else
            MemoLog.Lines.Add(VisibleControlCharacters(Str[i]));
        end;
      finally
        Str.Free;
      end;
      MemoLog.Lines.Add(DupeString('-',77)+'end');
    end;
  end else
    TSipClientFormLogSync.Log(Self,S1,S2);
end;

procedure TSipClientForm.OutputStack;
var
  Str: TStringList;
  i: Integer;
begin
  Str:=TStringList.Create;
  try
    FNotifier.GetStack(Str);

    for i:=0 to Str.Count-1 do
      OutputThread(Str[i]);

  finally
    Str.Free;
  end;
end;

procedure TSipClientForm.NotifierException(Notifier: TBisExceptNotifier; const E: Exception; const OSException: Boolean);
var
  S: String;
begin
  if OSException then
    S:='System='
  else
    S:='Delphi=';

  if Assigned(E) then
    S:=S+E.ClassName+' ('+E.Message+')';

  OutputThread(S);
  
  OutputStack;
end;

procedure TSipClientForm.CheckBoxTimersClick(Sender: TObject);
begin
  ButtonTimers.Enabled:=CheckBoxTimers.Checked;
end;

procedure TSipClientForm.CheckBoxUseReceivedClick(Sender: TObject);
begin
  FPhone.UseReceived:=CheckBoxUseReceived.Checked;
end;

procedure TSipClientForm.CheckBoxUseRportClick(Sender: TObject);
begin
  FPhone.UseRport:=CheckBoxUseRport.Checked;
end;

procedure TSipClientForm.ComboBoxProvidersChange(Sender: TObject);
var
  Str: TStringList;
  S: String;
begin
  if ComboBoxProviders.ItemIndex<>-1 then begin
    S:=ComboBoxProviders.Items[ComboBoxProviders.ItemIndex];
    if Trim(S)<>'' then begin
      S:=FAppPath+S;
      if FileExists(S) then begin
        Str:=TStringList.Create;
        try
          Str.LoadFromFile(S);
          if Str.Count>0 then
            EditRemoteHost.Text:=Str[0];
          if Str.Count>1 then
            EditRemotePort.Text:=Str[1];
          if Str.Count>2 then
            EditUserName.Text:=Str[2];
          if Str.Count>3 then
            EditPassword.Text:=Str[3];
          if Str.Count>4 then
            CheckBoxUseRport.Checked:=Boolean(StrToIntDef(Str[4],0));
          if Str.Count>5 then
            CheckBoxUseReceived.Checked:=Boolean(StrToIntDef(Str[5],0));
          if Str.Count>6 then
            UpDownExpires.Position:=StrToIntDef(Str[6],UpDownExpires.Position);
        finally
          Str.Free;
        end;
      end;
    end;
  end;
  UpdateButtons;
end;

function TSipClientForm.PlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
var
  Item: TSipClientLine;
  L: Cardinal;
  LSize: Int64;
begin
  Result:=0;
  NumLoops:=0;
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then begin
     if FPlayLock.TryEnter then
      try
        LSize:=Item.InStream.Size-Item.InStream.Position;
        L:=BufferSize;
        if LSize>=L then begin
          LSize:=L;
          Item.InStream.Position:=Item.InStream.Size-LSize;
        end;
        Result:=Item.InStream.Read(Buffer^,LSize);
        if Result=0 then begin
          SilenceWaveAudio(Buffer,BufferSize,@FPlayerFormat);
          Result:=BufferSize;
          Inc(Item.FMissedCount);
        end;
      finally
        FPlayLock.Leave;
      end;
  end;
end;

function TSipClientForm.PlayerDataTest(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
var
  LSize: Int64;
begin
  Result:=1;
  NumLoops:=0;
  LSize:=FTestConverter.Stream.Size-FTestConverter.Stream.Position;
  if LSize>=0 then begin
    Result:=FTestConverter.Stream.Read(Buffer^,BufferSize);
  end;
end;

function TSipClientForm.PlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
var
  Item: TSipClientLine;
  L: Cardinal;
  LSize: Int64;
  BuffPos: Cardinal;
begin
  Result:=0;
  FreeIt:=false;
  NumLoops:=0;

  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then begin
    LSize:=Item.InStream.Size-Item.InStream.Position;
    L:=Round(FPlayer.BufferLength*Item.Line.LocalPayloadLength/Item.Line.LocalPacketTime);
    if LSize>=L then begin
      LSize:=L;
      Item.InStream.Position:=Item.InStream.Size-LSize;
    end;

    if LSize>0 then begin
      Result:=LSize;
//          GetMem(Buffer,Result);   // bad quality with pulsation
//          Item.InStream.Read(Buffer^,Result);
//          FreeIt:=true;
      BuffPos:=Cardinal(Item.InStream.Memory);
      Inc(BuffPos,Item.InStream.Position);
      Buffer:=Pointer(BuffPos); // after 20 seconds exception in msvcrt.memcpy
    end else begin
      Inc(Item.FMissedCount);
      Buffer:=nil;
      Result:=1;   // Result will be considered as silence milliseconds.
    end;
  end;
end;

procedure TSipClientForm.Button1Stop;
begin
  Button1.Caption:='Stop';
  Button1.Enabled:=true;
end;

procedure TSipClientForm.PlayerActivate(Sender: TObject);
begin
  OutputThread('Player Activate');
  TBisThread.StaticQueue(Button1Stop);
end;

procedure TSipClientForm.Button1Start;
begin
  Button1.Caption:='Start';
  Button1.Enabled:=true;
end;

procedure TSipClientForm.PlayerDeactivate(Sender: TObject);
begin
  OutputThread('Player Deactivate');
  TBisThread.StaticQueue(Button1Start);
end;

procedure TSipClientForm.PlayerError(Sender: TObject);
begin
  OutputThread('PlayerError');
  Log('| Player Error',FPlayer.LastErrorText);
end;

procedure TSipClientForm.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
var
  Item: TSipClientLine;
begin
  FreeIt:=true;
  if BufferSize>0 then begin
    Item:=ButtonGroupLines.Current;
    if Assigned(Item) then begin
//      Item.Line.PlayData(Buffer,BufferSize);
      Item.Line.Send(Buffer,BufferSize,false); 
    end;
  end;
end;

procedure TSipClientForm.RecorderDataTest(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
begin
  FreeIt:=true;
  if BufferSize>0 then begin

  end;
end;

procedure TSipClientForm.RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
var
  Item: TSipClientLine;
begin
  FreeIt := false;
  pWaveFormat := @FPlayerFormat;
//  pWaveFormat := nil;
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then
    pWaveFormat:=Item.Line.LocalFormat;
end;

procedure TSipClientForm.RecorderActivate(Sender: TObject);
begin
  OutputThread('Recorder Activate');
  TBisThread.StaticQueue(Button1Stop);
end;

procedure TSipClientForm.RecorderDeactivate(Sender: TObject);
begin
  OutputThread('Recorder Deactivate');
  TBisThread.StaticQueue(Button1Start);
end;

procedure TSipClientForm.TimerCounterTimer(Sender: TObject);
begin
  Inc(FCounter);
  Caption:=IntToStr(FCounter);
end;

procedure TSipClientForm.TimerExpiresTimer(Sender: TObject);
begin
  TimerExpires.Enabled:=false;
end;

procedure TSipClientForm.ButtonGroupLinesButtonClicked(Sender: TObject; Index: Integer);
var
  Item: TSipClientLine;
begin
  FPlayer.Stop(false);
  FRecorder.Stop(false);

  ButtonGroupLines.ItemIndex:=Index;
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then begin

    if Item.Line.Active then begin
      FPlayer.Start(false);
      if Item.AnswerIndex=0 then
        FRecorder.Start(false);
    end;
  end;

  UpdateButtons;
end;

procedure TSipClientForm.PhoneConnect(Sender: TBisSipPhone);
begin
  if FPhone.Connected then begin
    FCounter:=0;
    ButtonGroupLines.MissedLockCount:=0;
    TimerCounter.Enabled:=true;
    TimerExpires.Interval:=FPhone.Expires*1000;
    TimerExpires.Enabled:=true;
  end else begin
    TimerCounter.Enabled:=false;
    FPlayer.Stop;
    FRecorder.Stop;
  end;
  TimerUpdateItems.Enabled:=FPhone.Connected;
  UpdateButtons;
end;

function TSipClientForm.PhoneLineCheck(Sender: TBisSipPhone; Line: TBisSipPhoneLine; Message: TBisSipMessage): Boolean;
begin
  case Line.Direction of
    ldIncoming: begin
      if IsMainThread then
        Result:=CheckBoxAccept.Checked
      else begin
        Sleep(1000); // emulate process
        Result:=true;
      end;  
    end;
    ldOutgoing: Result:=true;
  else
    Result:=false;  
  end;
end;

procedure TSipClientForm.PhoneLineCreate(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
begin
  Item:=TSipClientLine.Create(ButtonGroupLines.Items);
  Item.FLine:=Line;
  Item.Caption:=Line.Number;
  ButtonGroupLines.Items.AddItem(Item,ButtonGroupLines.Items.Count-1);
  ButtonGroupLines.ItemIndex:=Item.Index;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineDestroy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
  Index: Integer;
begin
  Item:=ButtonGroupLines.Find(Line);
  if Assigned(Item) then begin
    Item.Free;
    Index:=ButtonGroupLines.Items.Count-1;
    if Index>=0 then begin
      ButtonGroupLinesButtonClicked(nil,Index);
    end;
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineConnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
  Converter: TWaveConverter;
begin
  Log('| Connect');
  Item:=ButtonGroupLines.Find(Line);
  if Assigned(Item) and Line.Active then begin
    Item.DateConnect:=Now;
    Item.AnswerIndex:=ComboBoxAnswer.ItemIndex;

    FCurrentIndex:=0;

    case ComboBoxAnswer.ItemIndex of
      0: begin
        FPlayer.BufferCount:=UpDownBufferCount.Position;
        FPlayer.BufferLength:=UpDownBuffer.Position*UpDownBufferCount.Position;
        FPlayer.OnData:=PlayerData;
        FPlayer.Start(false);

        FRecorder.BufferCount:=UpDownBufferCount.Position;
//        FRecorder.BufferLength:=UpDownBuffer.Position*UpDownBufferCount.Position;
        FRecorder.BufferLength:=Line.LocalPacketTime;
        FRecorder.OnData:=RecorderData;
        FRecorder.Start(false);

        Line.LocalBufferSize:=Round(FRecorder.BufferLength*Line.LocalPayloadLength/Line.LocalPacketTime); 

       // Line.PlayStart;
      end;
      1: begin
        Converter:=TWaveConverter.Create;
        try
          Converter.LoadFromFile(FAppPath+SFilePlayWav);
          if Converter.ConvertTo(Line.LocalFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            Line.PlayStart(1);
            Line.PlayStream(Converter.Stream);
          end;
        finally
          Converter.Free;
        end;
      end;
      2: begin
        Line.PlayStart(1);
        Line.PlayDtmfString(EditDtmf.Text,FPhone.DtmfTimeout);
      end;
    end;
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineDisconnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
  Stream: TMemoryStream;
  Converter: TWaveFileConverter;
begin
  Log('| Disconnect');
  Item:=ButtonGroupLines.Find(Line);
  if Assigned(Item) then begin

    if Item=ButtonGroupLines.Current then begin
      FPlayer.Stop(false);
      FRecorder.Stop(false);
    end;

    if Assigned(Line.RemoteFormat) then begin
      Stream:=TMemoryStream.Create;
      Converter:=TWaveFileConverter.Create(FAppPath+SFileInWav,fmCreate or fmOpenWrite);
      try
        Line.RemotePackets.SavePayloadToStream(Stream,Line.RemotePayloadType);
        Converter.BeginRewrite(Line.RemoteFormat);
        Converter.Write(Stream.Memory^,Stream.Size);
        Converter.EndRewrite;
      finally
        Converter.Free;
        Stream.Free;
      end;
    end;

    if Assigned(Line.LocalFormat) then begin
      Stream:=TMemoryStream.Create;
      Converter:=TWaveFileConverter.Create(FAppPath+SFileOutWav,fmCreate or fmOpenWrite);
      try
        Line.LocalPackets.SavePayloadToStream(Stream,Line.LocalPayloadType);
        Converter.BeginRewrite(Line.LocalFormat);
        Converter.Write(Stream.Memory^,Stream.Size);
        Converter.EndRewrite;
      finally
        Converter.Free;
        Stream.Free;
      end;
    end;

  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineHold(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Converter: TWaveConverter;
  Item: TSipClientLine;
begin
  Item:=ButtonGroupLines.Find(Line);
  if Assigned(Item) and (lsHolding in Line.States) then begin

    Converter:=TWaveConverter.Create;
    try
      Converter.LoadFromFile(FAppPath+SFileHoldWav);
      if Converter.ConvertTo(Line.LocalFormat) then begin
        Converter.Stream.Position:=Converter.DataOffset;
        Line.PlayStart(MaxInt);
        Line.PlayStream(Converter.Stream);
      end;
    finally
      Converter.Free;
    end;

    FPlayer.Stop(false);
    FRecorder.Stop(false);

  end else begin
    Line.PlayStop;
    FPlayer.Start(false);
    case Item.AnswerIndex of
      0: begin
        FRecorder.Start(false);
        if Line.Active then
          Line.PlayStart;
      end;
    end;
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineInData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
var
  ASize: Integer;
  Item: TSipClientLine;
  Converter: TWaveConverter;
  OldPos: Int64;
  F1: Int64;
begin
  Item:=ButtonGroupLines.Find(Line);
  if Assigned(Item) then begin

      if not Item.TickStarted then begin
        Item.TickStarted:=true;
        Item.FirstTick:=GetTickCount(F1);
        Item.FirstFreq:=F1;
      end;

      if (Item=ButtonGroupLines.Current) then begin

        Converter:=TWaveConverter.Create;
        try
          Converter.BeginRewrite(Line.RemoteFormat);
          Converter.Write(Pointer(Data)^,DataSize);
          Converter.EndRewrite;
          if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            ASize:=Converter.Stream.Size-Converter.Stream.Position;
            if ASize>0 then begin
              FPlayLock.Enter;
              OldPos:=Item.InStream.Position;
              try
                Item.InStream.Position:=Item.InStream.Size;
                Item.InStream.CopyFrom(Converter.Stream,ASize);
              finally
                Item.InStream.Position:=OldPos;
                FPlayLock.Leave;
              end;
            end;
          end;
        finally
          Converter.Free;
        end;

      end;

      if Line.RemotePackets.Count>0 then begin
        if Item.TickStarted then begin
          Item.LastTick:=GetTickCount(F1);
          Item.LastFreq:=F1;
        end;
      end;

   end;
end;

procedure TSipClientForm.PhoneLineOutData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
begin
  //
end;

procedure TSipClientForm.PhoneLinePlayEnd(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  OutputThread('PhoneLinePlayEnd');
  FPlaying:=false;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineRing(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
begin
  Item:=ButtonGroupLines.Find(Line);
  if Assigned(Item) then begin
    Item.Caption:=Line.Number;
//    Line.Hangup;
//    Line.Answer;
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneReceive(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
begin
  OutputThread('PhoneReceive');
  Log(Format('< RECV from %s:%d',[Host,Port]),Data);
end;

procedure TSipClientForm.PhoneSend(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
begin
  OutputThread('PhoneSend');
  Log(Format('> SEND to %s:%d',[Host,Port]),Data);
end;

procedure TSipClientForm.PhoneTimeout(Sender: TBisSipPhone);
begin
  OutputThread('PhoneTimeout');
  Log('| Timeout','');
end;

procedure TSipClientForm.PhoneError(Sender: TBisSipPhone; const Error: String);
begin
  OutputThread('PhoneError = '+Error);
  Log('| Error',Error);
end;

procedure TSipClientForm.PhoneLineDtmf(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Code: Char);
begin
  OutputThread('PhoneLineDtmf = '+Code);
  if CheckBoxDtmf.Checked then begin
    EditDtmf.Text:=EditDtmf.Text+Code;
    EditDtmf.SelStart:=Length(EditDtmf.Text);
  end;
end;

procedure TSipClientForm.PhoneLineDetectBusy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  OutputThread('PhoneLineDetectBusy');
  Log('| Busy detected','');
end;

procedure TSipClientForm.UpdateButtons;
var
  Item: TSipClientLine;
begin
  ButtonConnect.Enabled:=not FPhone.Connected and (FPhone.State=psDefault);
  ButtonDisconnect.Enabled:=FPhone.Connected and (FPhone.State=psDefault);
  ButtonTerminate.Enabled:=FPhone.State<>psDefault;

  ComboBoxProviders.Enabled:=ButtonConnect.Enabled;

  Item:=ButtonGroupLines.Current;

  ButtonDial.Enabled:=FPhone.Connected and (FPhone.State=psDefault);
  ButtonHangup.Enabled:=FPhone.Connected and Assigned(Item);
  ButtonAnswer.Enabled:=FPhone.Connected and Assigned(Item) and
                        not Item.Line.Active and (Item.Line.Direction=ldIncoming)
                        and (lsRinging in Item.Line.States);
  ButtonPlay.Enabled:=FPhone.Connected and Assigned(Item) and
                      Item.Line.Active and not (lsHolding in Item.Line.States);
  if ButtonPlay.Enabled then
    ButtonPlay.Caption:=iff(FPlaying,SStop,SPlay);

  ButtonHold.Enabled:=FPhone.Connected and Assigned(Item) and Item.Line.Active;
  if ButtonHold.Enabled then
    ButtonHold.Caption:=iff(lsHolding in Item.Line.States,SUnHold,SHold);

  ButtonTimers.Enabled:=CheckBoxTimers.Checked;

  LabelBuffer.Enabled:=not Assigned(Item);
  EditBuffer.Enabled:=LabelBuffer.Enabled;
  UpDownBuffer.Enabled:=LabelBuffer.Enabled;

  LabelBufferCount.Enabled:=LabelBuffer.Enabled;
  EditBufferCount.Enabled:=LabelBufferCount.Enabled;
  UpDownBufferCount.Enabled:=LabelBufferCount.Enabled;

  ButtonSendDtmf.Enabled:=Assigned(Item);

end;

procedure TSipClientForm.ButtonConnectClick(Sender: TObject);
begin
  if not FPhone.Connected then begin
    FPhone.UserName:=EditUserName.Text;
    FPhone.Password:=EditPassword.Text;
    FPhone.RemoteHost:=EditRemoteHost.Text;
    FPhone.RemotePort:=StrToIntDef(EditRemotePort.Text,5060);
    FPhone.LocalHost:=EditLocalHost.Text;
    FPhone.LocalPort:=StrToIntDef(EditLocalPort.Text,5060);
    FPhone.RtpLocalPort:=FPhone.LocalPort+2;
    FPhone.Expires:=UpDownExpires.Position;
    FPhone.Connect;
  end;
  UpdateButtons;
end;

procedure TSipClientForm.ButtonDisconnectClick(Sender: TObject);
begin
  if FPhone.Connected then
    FPhone.Disconnect;
  UpdateButtons;  
end;

procedure TSipClientForm.ButtonClearClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

procedure TSipClientForm.ButtonDialClick(Sender: TObject);
begin
  if FPhone.Connected then begin
    FPhone.Dial(ComboBoxPhones.Text);

    if ComboBoxPhones.Items.IndexOf(ComboBoxPhones.Text)=-1 then
      ComboBoxPhones.Items.Add(ComboBoxPhones.Text);
    
    if CheckBoxTimers.Checked then begin
      TimerHangup.Enabled:=true;
      TimerDial.Interval:=UpDownOffset.Position;
      TimerDial.Enabled:=true;
    end;
  end;
end;

procedure TSipClientForm.ButtonHangupClick(Sender: TObject);
var
  Item: TSipClientLine;
begin
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then
    Item.Line.Hangup;
end;

procedure TSipClientForm.ButtonAnswerClick(Sender: TObject);
var
  Item: TSipClientLine;
begin
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then
    Item.Line.Answer;
end;

procedure TSipClientForm.ButtonPlayClick(Sender: TObject);
var
  Item: TSipClientLine;
  Converter: TWaveConverter;
begin
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then begin
    if ButtonPlay.Caption=SPlay then begin

      FRecorder.Stop(true);

      Converter:=TWaveConverter.Create;
      try
        Converter.LoadFromFile(FAppPath+SFilePlayWav);
        if Converter.ConvertTo(Item.Line.LocalFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          Item.Line.PlayStart(1);
          Item.Line.PlayStream(Converter.Stream);
          FPlaying:=true;
          ButtonPlay.Caption:=SStop;
        end;
      finally
        Converter.Free;
      end;
    end else begin
      Item.Line.PlayStop;
      case Item.AnswerIndex of
        0: begin
          FRecorder.Start(true);
          if Item.Line.Active then begin
            Item.Line.PlayStart;
          end;
        end;
      end;
      ButtonPlay.Caption:=SPlay;
    end;
  end;
end;

procedure TSipClientForm.ButtonSendDtmfClick(Sender: TObject);
var
  Item: TSipClientLine;
begin
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then begin
    FRecorder.Stop(true);
    Item.Line.PlayStart(1);
    Item.Line.PlayDtmfString(EditDtmf.Text,FPhone.DtmfTimeout);
  end;
end;

procedure TSipClientForm.ButtonHoldClick(Sender: TObject);
var
  Item: TSipClientLine;
begin
  Item:=ButtonGroupLines.Current;
  if Assigned(Item) then begin
    if ButtonHold.Caption=SHold then
      Item.Line.Hold
    else
      Item.Line.UnHold;
  end;
end;

procedure TSipClientForm.ButtonTerminateClick(Sender: TObject);
begin
  FPhone.Terminate;
  UpdateButtons;
end;

procedure TSipClientForm.ButtonTimersClick(Sender: TObject);
begin
  TimerHangup.Enabled:=false;
  TimerDial.Enabled:=false;
end;

procedure TSipClientForm.TimerHangupTimer(Sender: TObject);
var
  Item: TSipClientLine;
  i: Integer;
begin
  TimerHangup.Enabled:=false;
  try
    // hangup by life time
    for i:=0 to ButtonGroupLines.Items.Count-1 do begin
      Item:=ButtonGroupLines.GetItem(i);
      if Item.Line.Active and
         not VarIsNull(Item.DateConnect) and
         (IncSecond(Item.DateConnect,UpDownLifetime.Position)<=Now) then begin
        Item.Line.Hangup;
      end;
    end;
  finally
    TimerHangup.Enabled:=true;
  end;
end;

procedure TSipClientForm.TimerDialTimer(Sender: TObject);
begin
  TimerDial.Enabled:=false;
  try
    if ButtonGroupLines.Items.Count<UpDownCount.Position then begin
      if FPhone.Connected then
        FPhone.Dial(ComboBoxPhones.Text);
    end;
  finally
    TimerDial.Enabled:=true;
  end;
end;

procedure TSipClientForm.TimerUpdateItemsTimer(Sender: TObject);
var
  i: Integer;
begin
  TimerUpdateItems.Enabled:=false;
  try
    GroupBoxCall.Caption:=IntToStr(ButtonGroupLines.MissedLockCount);
    for i:=0 to ButtonGroupLines.Items.Count-1 do
      ButtonGroupLines.GetItem(i).UpdateItemCatption;
  finally
    TimerUpdateItems.Enabled:=true;
  end;
end;

procedure TSipClientForm.Button1Click(Sender: TObject);
begin

  if Button1.Caption='Stop' then begin
    FPlayer.Stop(false);
    FRecorder.Stop(false);
  end else begin
    FTestConverter.Stream.Position:=FTestConverter.DataOffset;
    FPlayer.OnData:=PlayerDataTest;
    FPlayer.Start(false);

    FRecorder.BufferCount:=UpDownBufferCount.Position;
    FRecorder.BufferLength:=UpDownBuffer.Position*UpDownBufferCount.Position;
    FRecorder.OnData:=RecorderDataTest;
    FRecorder.Start(false);
  end;

  Button1.Enabled:=false;

end;

procedure TSipClientForm.Button2Click(Sender: TObject);
{var
  Obj: TObject;}
begin
//  Sleep(5000);
{  Obj:=TObject.Create;
  try
    Obbb:=Obj;
    FreeAndNilEx(Obbb);
  finally
    Obj.Free;
  end;
       }
end;

end.

