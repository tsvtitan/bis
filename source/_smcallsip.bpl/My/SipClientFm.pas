unit SipClientFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MMSystem, SyncObjs, ButtonGroup, ExtCtrls, DateUtils,
  Acm,
  IdDnsResolver,
  WavePlayers, WaveRecorders, WaveStorage, WaveUtils,
  BisSip, BisDtmf, BisSdp, BisRtp, BisThread,
  BisSipPhone, ComCtrls;

type
  TSipClientBuffer=class(TObject)
  private
    FLock: TCriticalSection;
    Data: Pointer;
    Size: Cardinal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function BeginUpdate(ExtraSize: Cardinal): Pointer;
    procedure EndUpdate;
    function Get(var Buffer: Pointer; var BufferSize: Cardinal): Boolean;
  end;

  TSipClientLine=class(TGrpButtonItem)
  private
    FLine: TBisSipPhoneLine;
    FTimeFlag: Boolean;
    FTime: TDateTime;
    FDateCreate: TDateTime;
    FDateConnect: Variant;
    FAnswerIndex: Integer;
    FOutStream: TMemoryStream;
    FInStream: TMemoryStream;
    FLock: TCriticalSection;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
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
    ButtonRegister: TButton;
    ButtonUnRegister: TButton;
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
    LabelDtmf: TLabel;
    TimerDtfm: TTimer;
    TimerExpires: TTimer;
    TimerCounter: TTimer;
    ComboBoxProviders: TComboBox;
    CheckBoxAccept: TCheckBox;
    ButtonTimers: TButton;
    CheckBoxTransport: TCheckBox;
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
    EditRegister: TEdit;
    UpDownRegister: TUpDown;
    procedure ButtonRegisterClick(Sender: TObject);
    procedure ButtonUnRegisterClick(Sender: TObject);
    procedure ButtonDialClick(Sender: TObject);
    procedure ButtonHangupClick(Sender: TObject);
    procedure ButtonAnswerClick(Sender: TObject);
    procedure ButtonGroupLinesButtonClicked(Sender: TObject; Index: Integer);
    procedure ButtonPlayClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonLinkClick(Sender: TObject);
    procedure ButtonHoldClick(Sender: TObject);
    procedure TimerDtfmTimer(Sender: TObject);
    procedure TimerExpiresTimer(Sender: TObject);
    procedure TimerCounterTimer(Sender: TObject);
    procedure ComboBoxProvidersChange(Sender: TObject);
    procedure ButtonTimersClick(Sender: TObject);
    procedure CheckBoxTransportClick(Sender: TObject);
    procedure CheckBoxUseRportClick(Sender: TObject);
    procedure CheckBoxUseReceivedClick(Sender: TObject);
    procedure TimerHangupTimer(Sender: TObject);
    procedure TimerDialTimer(Sender: TObject);
    procedure CheckBoxTimersClick(Sender: TObject);
  private
    FPhone: TBisSipPhone;
    FPlayer: TLiveAudioPlayer;
    FPlayer2: TStockAudioPlayer;
    FRecorder: TLiveAudioRecorder;
    FPlayerBuffer: TSipClientBuffer;
    FDtmf: TBisDtmf;
    FCounter: Integer;
    FMissedCount: Integer;
    FCurrentIndex: Integer;
    FConverter: TWaveConverter;

    FTime: TDateTime;

    FACMDlg: TACMDlg;

    procedure DtmfCode(Sender: TObject; const Code: Char);

    procedure PhoneSendData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
    procedure PhoneReceiveData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
    procedure PhoneConnect(Sender: TBisSipPhone);
    procedure PhoneLineCreate(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDestroy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    function PhoneLineCheck(Sender: TBisSipPhone; Line: TBisSipPhoneLine): Boolean;
    procedure PhoneLineRing(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineConnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDisconnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineInData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
    procedure PhoneLineInExtraData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket; Rtmap: TBisSdpRtpmapAttr);
    function PhoneLineOutData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal): Boolean;
    procedure PhoneLineHold(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLinePlayEnd(Sender: TBisSipPhone; Line: TBisSipPhoneLine);

    function PlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
    procedure PlayerFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);

    procedure RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);

    function Find(Line: TBisSipPhoneLine): TSipClientLine;
    procedure UpdateButtons;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  SipClientForm: TSipClientForm;

implementation


uses
     FileCtrl, TypInfo, Math,
     Dtmf, 
     BisFileDirs, BisUtils, BisIpUtils;

{$R *.dfm}

{ TSipClientBuffer }

constructor TSipClientBuffer.Create;
begin
  inherited Create;
  FLock:=TCriticalSection.Create;
end;

destructor TSipClientBuffer.Destroy;
begin
  Clear;
  FLock.Free;
  inherited Destroy;
end;

procedure TSipClientBuffer.Clear;
begin
  FLock.Enter;
  try
    ReallocMem(Data, 0);
    Size := 0;
  finally
    FLock.Leave;
  end;
end;

function TSipClientBuffer.BeginUpdate(ExtraSize: Cardinal): Pointer;
begin
  FLock.Enter;
  ReallocMem(Data, Size + ExtraSize);
  Result := Pointer(Cardinal(Data) + Size);
  Inc(Size, ExtraSize);
end;

procedure TSipClientBuffer.EndUpdate;
begin
  FLock.Leave;
end;

function TSipClientBuffer.Get(var Buffer: Pointer; var BufferSize: Cardinal): Boolean;
begin
  FLock.Enter;
  try
    Result := False;
    if Assigned(Data) then
    begin
      Buffer := Data;
      BufferSize := Size;
      Data := nil;
      Size := 0;
      Result := True;
    end;
  finally
    FLock.Leave;
  end;
end;

{ TSipClientLine }

constructor TSipClientLine.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDateCreate:=Now;
  FDateConnect:=Null;
  FOutStream:=TMemoryStream.Create;
  FInStream:=TMemoryStream.Create;
  FLock:=TCriticalSection.Create;
end;

destructor TSipClientLine.Destroy;
begin
  FLock.Free;
  FInStream.Free;
  FOutStream.Free;
  inherited Destroy;
end;

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

{ TSipClientForm }

constructor TSipClientForm.Create(AOwner: TComponent);
var
  NewWaveFormat: TWaveFormatEx;
begin
  inherited Create(AOwner);

  FPlayerBuffer:=TSipClientBuffer.Create;

  EditLocalHost.Text:=GetLocalIP;
  EditLocalPort.Text:='5060';

  FPhone:=TBisSipPhone.Create(nil);
//  FPhone.LocalHost:='192.168.1.3';
//  FPhone.LocalHost:='s1';
//  FPhone.LocalPort:=5060;
  FPhone.UserAgent:='SIP Client';
//  FPhone.UserAgent:='Zoiper rev.6739';
//  FPhone.Expires:=60;
  FPhone.KeepAlive:=0;
  FPhone.MaxLines:=10;
  FPhone.LineConfirmCount:=0;
  FPhone.LineHoldMode:=lhmEmulate;
//  FPhone.LineHoldMode:=lhmStandart;
  FPhone.OnSendData:=PhoneSendData;
  FPhone.OnReceiveData:=PhoneReceiveData;
  FPhone.OnConnect:=PhoneConnect;
  FPhone.OnDisconnect:=PhoneConnect;
  FPhone.OnLineCreate:=PhoneLineCreate;
  FPhone.OnLineDestroy:=PhoneLineDestroy;
  FPhone.OnLineCheck:=PhoneLineCheck;
  FPhone.OnLineRing:=PhoneLineRing;
  FPhone.OnLineConnect:=PhoneLineConnect;
  FPhone.OnLineDisconnect:=PhoneLineDisconnect;
  FPhone.OnLineInData:=PhoneLineInData;
  FPhone.OnLineInExtraData:=PhoneLineInExtraData;
  FPhone.OnLineOutData:=PhoneLineOutData;
  FPhone.OnLineHold:=PhoneLineHold;
  FPhone.OnLinePlayEnd:=PhoneLinePlayEnd;

  FPlayer:=TLiveAudioPlayer.Create(nil);
  FPlayer.BufferCount:=10;
  FPlayer.BufferInternally:=false;
  FPlayer.BufferLength:=1000;
  FPlayer.PCMFormat:=Mono16bit8000Hz;
//  FPlayer.PCMFormat:=nonePCM;
  FPlayer.DeviceID:=0;
  FPlayer.Async:=false;
  FPlayer.OnDataPtr:=PlayerDataPtr;
//  FPlayer.OnData:=PlayerData;
//  FPlayer.OnFormat:=PlayerFormat;

  FPlayer2:=TStockAudioPlayer.Create(nil);
  FPlayer2.DeviceID:=0;
  FPlayer2.Async:=false;

  FDtmf:=TBisDtmf.Create(nil);
  FDtmf.Threshold:=900;
  FDtmf.Quality:=2.5;
  FDtmf.OnCode:=DtmfCode;
  SetPCMAudioFormatS(@NewWaveFormat,FPlayer.PCMFormat);
  FDtmf.SetFormat(NewWaveFormat.nSamplesPerSec,NewWaveFormat.wBitsPerSample,NewWaveFormat.nChannels);

  FRecorder:=TLiveAudioRecorder.Create(nil);
  FRecorder.DeviceID:=0;
  FRecorder.Async:=false;
  FRecorder.PCMFormat:=nonePCM;
  FRecorder.OnFormat:=RecorderFormat;
  FRecorder.OnData:=RecorderData;


  FACMDlg:=TACMDlg.Create(Self);
{  if FACMDlg.Execute then begin

  end;}

  ButtonGroupLines.Items.Clear;

  FConverter:=TWaveConverter.Create;
  FConverter.LoadFromFile(ExtractFilePath(Application.ExeName)+'test2.wav');
{  FConverter.ConvertToPCM(FPlayer.PCMFormat);
  FConverter.Stream.Position:=FConverter.DataOffset;}

  ComboBoxProvidersChange(nil);

  timeBeginPeriod(1);
end;

destructor TSipClientForm.Destroy;
begin
  FConverter.Free;
  FRecorder.Active:=false;
//  FRecorder.WaitForStop;
  FRecorder.Free;
  FPlayer2.Active:=false;
  FPlayer2.Free;
  FPlayer.Active:=false;
//  FPlayer.WaitForStop;
  FDtmf.Free;
  FPlayer.Free;
  FPhone.Free;
  FPlayerBuffer.Free;
  inherited Destroy;
end;

procedure TSipClientForm.CheckBoxTimersClick(Sender: TObject);
begin
  ButtonTimers.Enabled:=CheckBoxTimers.Checked;
end;

procedure TSipClientForm.CheckBoxTransportClick(Sender: TObject);
begin
  FPhone.Transport.Enabled:=CheckBoxTransport.Checked;
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
begin
  case ComboBoxProviders.ItemIndex of
    0: begin
      EditRemoteHost.Text:='195.112.242.242';
      EditRemotePort.Text:='5060';
      EditUserName.Text:='2026672';
      EditPassword.Text:='an7yntwspr';
      CheckBoxUseReceived.Checked:=false;
    end;
    1: begin
      EditRemoteHost.Text:='voip.intertax.net';
      EditRemotePort.Text:='5060';
      EditUserName.Text:='2904021';
      EditPassword.Text:='R07tiu5Vew00In9';
      CheckBoxUseReceived.Checked:=true;
    end;
    2: begin
      EditRemoteHost.Text:='195.112.242.242';
      EditRemotePort.Text:='5060';
      EditUserName.Text:='2231003';
      EditPassword.Text:='M3u9uo9AfU';
      CheckBoxUseReceived.Checked:=false;
    end;
  end;
end;

procedure TSipClientForm.DtmfCode(Sender: TObject; const Code: Char);
begin
  if CheckBoxDtmf.Checked and not TimerDtfm.Enabled then begin
    EditDtmf.Text:=EditDtmf.Text+Code;
    TimerDtfm.Enabled:=true;
  end;
end;

procedure TSipClientForm.PhoneLineInExtraData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket;
                                              Rtmap: TBisSdpRtpmapAttr);
var
  D: TBytes;
  Event: Byte;
  Code: Char;
  S: String;
begin
  if Rtmap.EncodingType=retTelephoneEvent then begin
    D:=Packet.Payload;
    if Length(D)>0 then begin
      Event:=D[0];
      S:=IntToStr(Event);
      if Length(S)>0 then begin
        Code:=S[1];
        case Event of
          10: Code:='*';
          11: Code:='#';
          12: Code:='A';
          13: Code:='B';
          14: Code:='C';
          15: Code:='D';
        end;
        DtmfCode(Self,Code);
      end;
    end;
  end;
end;

procedure TSipClientForm.TimerCounterTimer(Sender: TObject);
begin
  Inc(FCounter);
  Caption:=IntToStr(FCounter);
end;

procedure TSipClientForm.TimerDtfmTimer(Sender: TObject);
var
  Item: TSipClientLine;
  Last: Char;
  L: Integer;
begin
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
    L:=Length(EditDtmf.Text);
    if L>0 then begin
      Last:=EditDtmf.Text[L];
      if Last='1' then
        ButtonPlayClick(nil);
      if Last='2' then
        Item.FLine.Hangup;

      TimerDtfm.Enabled:=false;
    end;
  end;
end;

procedure TSipClientForm.TimerExpiresTimer(Sender: TObject);
begin
  TimerExpires.Enabled:=false;
end;

function TSipClientForm.Find(Line: TBisSipPhoneLine): TSipClientLine;
var
  i: Integer;
  Item: TSipClientLine;
begin
  Result:=nil;
  if Assigned(Line) then begin
    for i:=0 to ButtonGroupLines.Items.Count-1 do begin
      Item:=TSipClientLine(ButtonGroupLines.Items[i]);
      if Item.FLine=Line then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

procedure TSipClientForm.ButtonGroupLinesButtonClicked(Sender: TObject; Index: Integer);
var
  Item: TSipClientLine;
begin
  FPlayer.Active:=false;
  FPlayer.WaitForStop;
  FRecorder.Active:=false;
  if Index<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[Index]);
    ButtonGroupLines.ItemIndex:=Index;
    FPlayer.Active:=Item.FLine.Active;
    FPlayer.WaitForStart;
    FRecorder.Active:=Item.FLine.Active and (Item.FAnswerIndex=0);
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneConnect(Sender: TBisSipPhone);
begin
  if FPhone.Connected then begin
    FCounter:=0;
    TimerCounter.Enabled:=true;
    TimerExpires.Interval:=FPhone.Expires*1000;
    TimerExpires.Enabled:=true;
  end else begin
    TimerCounter.Enabled:=false;
  end;

  UpdateButtons;
end;

function TSipClientForm.PhoneLineCheck(Sender: TBisSipPhone; Line: TBisSipPhoneLine): Boolean;
begin
  Result:=CheckBoxAccept.Checked;
{  case Line.Direction of
    ldIncoming: Result:=AnsiSameText(Line.Number,'9029232332');
    ldOutgoing: Result:=AnsiSameText(Line.Number,'2374863');
  end;}
end;

procedure TSipClientForm.PhoneLineCreate(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
{var
  Item: TSipClientLine;}
begin
{  Item:=TSipClientLine.Create(ButtonGroupLines.Items);
  Item.FLine:=Line;
  Item.Caption:=Line.Number;
  ButtonGroupLines.Items.AddItem(Item,ButtonGroupLines.Items.Count-1);
  ButtonGroupLines.ItemIndex:=Item.Index;}
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineConnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);

  function GetEventByCode(Code: Char): Integer;
  begin
    Result:=-1;
    case Code of
      '0': Result:=0;
      '1': Result:=1;
      '2': Result:=2;
      '3': Result:=3;
      '4': Result:=4;
      '5': Result:=5;
      '6': Result:=6;
      '7': Result:=7;
      '8': Result:=8;
      '9': Result:=9;
      '*': Result:=10;
      '#': Result:=11;
      'A': Result:=12;
      'B': Result:=13;
      'C': Result:=14;
      'D': Result:=15;
    end;
  end;
  
  procedure SetDtmf(Stream: TStream; Code: Char);
  var
    Event: Integer;
    S: String;
    Converter: TWaveConverter;
  begin
    Event:=GetEventByCode(Code);
    if Event>=0 then begin
      S:=GetDTMF(8000,Event,12*160);
      Converter:=TWaveConverter.Create;
      try
        Converter.BeginRewritePCM(Mono16bit8000Hz);
        Converter.Write(Pointer(S)^,Length(S));
        Converter.EndRewrite;
        Converter.InsertSilence(0,5*160);
        if Converter.ConvertTo(Line.OutFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          Stream.CopyFrom(Converter.Stream,Converter.Stream.Size-Converter.Stream.Position);
        end;
      finally
        Converter.Free;
      end;
    end;
  end;

var
  Item: TSipClientLine;
  Converter: TWaveConverter;
  Stream: TMemoryStream;
begin
  Item:=Find(Line);
  if Assigned(Item) then begin
    Item.FDateConnect:=Now;
    Item.FAnswerIndex:=ComboBoxAnswer.ItemIndex;
//    if Item.Index=ButtonGroupLines.ItemIndex then begin
//      Line.Hold;

      FPlayer.Active:=Line.Active;
//      FPlayer2.Active:=Line.Active;
//      FRecorder.Active:=Line.Active;

      FMissedCount:=0;
      FCurrentIndex:=0;

//      if Line.Direction=ldOutgoing then
//      ButtonPlayClick(nil);

     { if CheckBoxTimers.Checked then begin
        Converter:=TWaveConverter.Create;
        try
          Converter.LoadFromFile(ExtractFilePath(Application.ExeName)+'test1.wav');
          if not Line.Playing and Converter.ConvertTo(Line.OutFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            Line.PlayStart(Converter.Stream);
          end;
        finally
          Converter.Free;
        end;
      end; }

      case ComboBoxAnswer.ItemIndex of
        0: begin
          FRecorder.Active:=Line.Active;
        end;
        1: begin
          Converter:=TWaveConverter.Create;
          try
            Converter.LoadFromFile(ExtractFilePath(Application.ExeName)+'test1.wav');
            if not Line.Playing and Converter.ConvertTo(Line.OutFormat) then begin
              Converter.Stream.Position:=Converter.DataOffset;
              Line.PlayStart(Converter.Stream,1);
            end;
          finally
            Converter.Free;
          end;
        end;
        2: begin
          Stream:=TMemoryStream.Create;
          try
            SetDtmf(Stream,'9');
            SetDtmf(Stream,'0');
            SetDtmf(Stream,'*');
            Stream.Position:=0;
            Line.PlayStart(Stream,1);
          finally
            Stream.Free;
          end;
        end;
      end;

  //  end;
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineDisconnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
  Stream: TMemoryStream;
  Converter: TWaveFileConverter;
begin
  Item:=Find(Line);
  if Assigned(Item) then begin
    if Item.Index=ButtonGroupLines.ItemIndex then begin
      FPlayer.Active:=Line.Active;
//      FPlayer2.Active:=Line.Active;
      FRecorder.Active:=Line.Active and (Item.FAnswerIndex=0);

      if Assigned(Line.InFormat) then begin
        Stream:=TMemoryStream.Create;
        Converter:=TWaveFileConverter.Create('c:\in.wav',fmCreate or fmOpenWrite);
        try
          Line.InPackets.SavePayloadToStream(Stream,Line.RemotePayloadType);
          Converter.BeginRewrite(Line.InFormat);
          Converter.Write(Stream.Memory^,Stream.Size);
          Converter.EndRewrite;
        finally
          Converter.Free;
          Stream.Free;
        end;
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
  Item:=Find(Line);
  if Assigned(Item) and Line.Holding then begin
    Converter:=TWaveConverter.Create;
    try
      Converter.LoadFromFile(ExtractFilePath(Application.ExeName)+'test2.wav');
      if Converter.ConvertTo(Line.OutFormat) then begin
        Converter.Stream.Position:=Converter.DataOffset;
        Line.PlayStart(Converter.Stream);
      end;
    finally
      Converter.Free;
    end;
//    FPlayer2.Active:=false;
    FPlayer.Active:=false;
    FRecorder.Active:=false;
  end else begin
    Line.PlayStop;
    FPlayer.Active:=Line.Active;
//    FPlayer2.Active:=Line.Active;
    FRecorder.Active:=Line.Active and (Item.FAnswerIndex=0);
  end;
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineDestroy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
  Index: Integer;
begin
  Item:=Find(Line);
  if Assigned(Item) then begin
    Item.Free;

    Index:=ButtonGroupLines.Items.Count-1;
    if Index>=0 then begin
      ButtonGroupLinesButtonClicked(nil,Index);
    end;
  end;

  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineInData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
var
  AData: Pointer;
  ASize: Integer;
  Item: TSipClientLine;
  Converter: TWaveConverter;
  FullCount, Index: Integer;
  Stream: TMemoryStream;
  OldPos: Int64;
  T1: Cardinal;
begin

  Item:=Find(Line);
  T1:=GetTickCountEx;
  if Assigned(Item) then begin

    if not Item.FTimeFlag then begin
      Item.FTime:=Now;
      Item.FTimeFlag:=true;
    end;

    if (Item.Index=ButtonGroupLines.ItemIndex)  then begin

  {    FDtmf.OnCode:=nil;
      Converter:=TWaveConverter.Create;
      Stream:=TMemoryStream.Create;
      FDtmf.OnCode:=DtmfCode;
      try
        Converter.BeginRewrite(Line.InFormat);
        Converter.Write(Data^,DataSize);
        Converter.EndRewrite;
        if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          FDtmf.LoadFromStream(Converter.Stream);
        end;
      finally
        Stream.Free;
        Converter.Free;
      end;   }

      FDtmf.OnCode:=nil;
      if (Line.InPackets.Count*160)>=160*5 then begin
        Index:=Line.InPackets.Count-1*5;
        Converter:=TWaveConverter.Create;
        Stream:=TMemoryStream.Create;
        FDtmf.OnCode:=DtmfCode;
        try
          Line.InPackets.SavePayloadToStream(Stream,Line.RemotePayloadType,Index);
          Converter.BeginRewrite(Line.InFormat);
          Converter.Write(Pointer(Stream.Memory)^,Stream.Size);
          Converter.EndRewrite;
          if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            FDtmf.LoadFromStream(Converter.Stream);
          end;
        finally
          Stream.Free;
          Converter.Free;
        end;
      end;

    {  FDtmf.OnCode:=nil;
      FullCount:=1000 div 150;
      if (Line.InPackets.Count mod FullCount)=0 then begin
        Index:=((Line.InPackets.Count div FullCount)-1)*FullCount;
        Converter:=TWaveConverter.Create;
        Stream:=TMemoryStream.Create;
        FDtmf.OnCode:=DtmfCode;
        try
          Line.InPackets.SavePayloadToStream(Stream,Line.RemotePayloadType,Index);
          Converter.BeginRewrite(Line.InFormat);
          Converter.Write(Pointer(Stream.Memory)^,Stream.Size);
          Converter.EndRewrite;
          if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            FDtmf.LoadFromStream(Converter.Stream);
          end;
        finally
          Stream.Free;
          Converter.Free;
        end;
      end;}

        Converter:=TWaveConverter.Create;
        try
          Converter.BeginRewrite(Line.InFormat);
          Converter.Write(Pointer(Data)^,DataSize);
          Converter.EndRewrite;
          if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            ASize:=Converter.Stream.Size-Converter.Stream.Position;
            if ASize>0 then begin
            //  Item.FLock.Enter;
              OldPos:=Item.FInStream.Position;
              try
                Item.FInStream.Position:=Item.FInStream.Size;
                Item.FInStream.CopyFrom(Converter.Stream,ASize);
              finally
                Item.FInStream.Position:=OldPos;

                GroupBoxCall.Caption:=IntToStr(Item.FInStream.Position)+' / '+IntToStr(Item.FInStream.Size)+' / '+
                                      IntToStr(Item.FInStream.Size-Item.FInStream.Position);
            //    Item.FLock.Leave;
              end;
            end;
          end;
        finally
          Converter.Free;
        end;

    {  FullCount:=50;
      if (Line.InPackets.Count mod FullCount)=0 then begin
        Index:=((Line.InPackets.Count div FullCount)-1)*FullCount;
        Converter:=TWaveConverter.Create;
        Stream:=TMemoryStream.Create;
        try
          Line.InPackets.SavePayloadToStream(Stream,Line.RemotePayloadType,Index);
          Converter.BeginRewrite(Line.InFormat);
  //        Converter.Write(Pointer(Data)^,DataSize);
          Converter.Write(Pointer(Stream.Memory)^,Stream.Size);
          Converter.EndRewrite;
          if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            ASize:=Converter.Stream.Size-Converter.Stream.Position;
            if ASize>0 then begin
            //  Item.FLock.Enter;
              OldPos:=Item.FInStream.Position;
              try
                Item.FInStream.Position:=Item.FInStream.Size;
                Item.FInStream.CopyFrom(Converter.Stream,ASize);
              finally
                Item.FInStream.Position:=OldPos;

                GroupBoxCall.Caption:=IntToStr(Item.FInStream.Position)+'/'+IntToStr(Item.FInStream.Size);
            //    Item.FLock.Leave;
              end;
            end;
          end;
        finally
          Stream.Free;
          Converter.Free;
        end;
      end;  }
  {
      if ASize>0 then begin
        AData:=FPlayerBuffer.BeginUpdate(DataSize);
        try
          Move(Pointer(Data)^,Pointer(AData)^,DataSize);
        finally
          FPlayerBuffer.EndUpdate;
        end;
      end;}
      
    end;

    if Line.InPackets.Count>0 then begin
      if Item.FTimeFlag then begin
        Item.Caption:=Line.Number+
                      ': In=>'+IntToStr(Line.InPackets.Count)+
                      ' T=>'+FormatDateTime('nn:ss.zzz',Now-Item.FTime)+
                      ' S=>'+FormatFloat('#0.0',MilliSecondsBetween(Now,Item.FTime)/Line.InPackets.Count)+
                      ' C=>'+IntToStr(GetTickCountEx-T1);
      end;
    end;


  end;
end;

function TSipClientForm.PhoneLineOutData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal): Boolean;
var
//  AData: Pointer;
  Item: TSipClientLine;
begin
  Result:=false;
  Item:=Find(Line);
  if Assigned(Item) and (Item.Index=ButtonGroupLines.ItemIndex) then begin
    Result:=Item.FOutStream.Read(Pointer(Data)^,DataSize)>0;
  end;
end;

procedure TSipClientForm.PhoneLinePlayEnd(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
begin
{  if not Line.Holding then
    Line.Hold;}
  
  UpdateButtons;
end;

procedure TSipClientForm.PhoneLineRing(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Item: TSipClientLine;
begin
  Item:=TSipClientLine.Create(ButtonGroupLines.Items);
  Item.FLine:=Line;
  Item.FDateCreate:=Now;
  Item.Caption:=Line.Number;
  ButtonGroupLines.Items.AddItem(Item,ButtonGroupLines.Items.Count-1);
  if not CheckBoxTimers.Checked then
    ButtonGroupLines.ItemIndex:=Item.Index
  else
    ButtonGroupLines.ItemIndex:=0;

{  if Line.Direction=ldIncoming then
    Line.Answer;}

{  Item:=Find(Line);
  if Assigned(Item) then
    Item.Caption:=Line.Number;}

  UpdateButtons;
end;

procedure TSipClientForm.PhoneReceiveData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
begin
  if CheckBoxLog.Checked then begin
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz',Now)+' ========= RECV from '+
                      Host+':'+IntToStr(Port)+' =========');
    MemoLog.Lines.Add('');
    MemoLog.Lines.Add(Data);
    MemoLog.Lines.Add('');
  end;
end;

procedure TSipClientForm.PhoneSendData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
begin
  if CheckBoxLog.Checked then begin
    MemoLog.Lines.Add(FormatDateTime('dd.mm.yyyy hh:nn:ss.zzz',Now)+' ========= SEND to '+
                      Host+':'+IntToStr(Port)+' =========');
    MemoLog.Lines.Add('');
    MemoLog.Lines.Add(Data);
    MemoLog.Lines.Add('');
  end;
end;

function TSipClientForm.PlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
var
  Item: TSipClientLine;
  Converter: TWaveConverter;
  Stream: TMemoryStream;
  ASize: Integer;
  Data: Pointer;
begin
  Item:=nil;
  if ButtonGroupLines.ItemIndex<>-1 then
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);

  if Assigned(Item) and Assigned(Item.FLine) then begin
    Item.FLock.Enter;
    try

      if (Item.FInStream.Size-Item.FInStream.Position)>320 then begin
        Result:=320;
        GetMem(Buffer,Result);
        Item.FInStream.Read(Buffer^,Result);
              GroupBoxCall.Caption:=IntToStr(Item.FInStream.Position)+' / '+IntToStr(Item.FInStream.Size)+' / '+
                                    IntToStr(Item.FInStream.Size-Item.FInStream.Position);
        FreeIt:=true;
      end else begin
        Result:=0;
      end;


    finally
      Item.FLock.Leave;
    end;
  end;

{  if FConverter.Stream.Size>FConverter.Stream.Position then begin
    ASize:=160;
    Converter:=TWaveConverter.Create;
    try
      GetMem(Data,ASize);
      FConverter.Stream.Read(Data^,ASize);
      Converter.BeginRewrite(FConverter.WaveFormat);
      Converter.Write(Data^,ASize);
      Converter.EndRewrite;
      FreeMem(Data,ASize);
      if Converter.ConvertToPCM(FPlayer.PCMFormat) then begin
        Converter.Stream.Position:=Converter.DataOffset;
        ASize:=Converter.Stream.Size-Converter.Stream.Position;
        if ASize>0 then begin
          Result:=ASize;
          GetMem(Buffer,Result);
          Converter.Stream.Read(Buffer^,Result);
          FreeIt:=true;
          GroupBoxCall.Caption:=IntToStr(FConverter.Stream.Position)+'/'+IntToStr(FConverter.Stream.Size);
        end else
          Result:=0;
      end;
    finally
      Converter.Free;
    end;
  end; }

{  if FConverter.Stream.Size>FConverter.Stream.Position then begin
    Result:=320;
    GetMem(Buffer,320);
    FConverter.Stream.Read(Buffer^,320);
    GroupBoxCall.Caption:=IntToStr(FConverter.Stream.Position)+'/'+IntToStr(FConverter.Stream.Size)+'/'+
                          FormatDateTime('nn:ss.zzz',Now-FTime)+'/'+
                          FormatFloat('#0.0',MilliSecondsBetween(Now,FTime)/(FConverter.Stream.Position/320));
    FreeIt:=true;
  end else
    Result:=0;}

  if Result<=0 then begin
    Buffer:=nil; // When Buffer is nil,
    Inc(FMissedCount);
    GroupBoxRegister.Caption:=IntToStr(FMissedCount);
    Result:=1;   // Result will be considered as silence milliseconds.
   end;

 { if FPlayerBuffer.Get(Buffer, Result) then begin
    FreeIt:=false;
  end else begin
    Buffer:=nil; // When Buffer is nil,
    Result:=10;   // Result will be considered as silence milliseconds.
  end}
end;

procedure TSipClientForm.PlayerFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
var
  Item: TSipClientLine;
begin
  FreeIt := false;
  pWaveFormat := nil;
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
    pWaveFormat:=Item.FLine.InFormat;
  end;
end;

procedure TSipClientForm.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
var
  Item: TSipClientLine;
  OldPos: Int64;
begin
  if BufferSize>0 then begin
    FreeIt:=true;
    if ButtonGroupLines.ItemIndex<>-1 then begin
      Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
      OldPos:=Item.FOutStream.Position;
      try
        Item.FOutStream.Write(Pointer(Buffer)^,BufferSize);
      finally
        Item.FOutStream.Position:=OldPos;
      end;
    end;
  end;
end;

procedure TSipClientForm.RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
var
  Item: TSipClientLine;
begin
  FreeIt := false;
  pWaveFormat := nil;
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
    pWaveFormat:=Item.FLine.OutFormat;
  end;
end;

procedure TSipClientForm.UpdateButtons;
var
  Item: TSipClientLine;
begin
  ButtonRegister.Enabled:=not FPhone.Connected;
  ButtonUnRegister.Enabled:=FPhone.Connected;
  
  Item:=nil;
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
  end;

  ButtonDial.Enabled:=FPhone.Connected;
  ButtonHangup.Enabled:=FPhone.Connected and Assigned(Item);
  ButtonAnswer.Enabled:=FPhone.Connected and Assigned(Item) and not Item.FLine.Active and (Item.FLine.Direction=ldIncoming);
  ButtonPlay.Enabled:=FPhone.Connected and Assigned(Item) and Item.FLine.Active and not Item.FLine.Holding;
  if ButtonPlay.Enabled then
    ButtonPlay.Caption:=iff(Item.FLine.Playing,'Stop','Play');

{  ButtonLink.Enabled:=FPhone.Connected and (ButtonGroupLines.Items.Count>1) and
                      TSipClientLine(ButtonGroupLines.Items[0]).FLine.Active and
                      TSipClientLine(ButtonGroupLines.Items[1]).FLine.Active;}
//  ComboBoxAnswer.Enabled:=ButtonAnswer.Enabled;                      
  ButtonHold.Enabled:=FPhone.Connected and Assigned(Item) and Item.FLine.Active;
  if ButtonHold.Enabled then
    ButtonHold.Caption:=iff(Item.FLine.Holding,'UnHold','Hold');

  ButtonTimers.Enabled:=CheckBoxTimers.Checked;  

end;

procedure TSipClientForm.ButtonRegisterClick(Sender: TObject);
begin
  if not FPhone.Connected then begin
    FPhone.UserName:=EditUserName.Text;
    FPhone.Password:=EditPassword.Text;
    FPhone.RemoteHost:=EditRemoteHost.Text;
    FPhone.RemotePort:=StrToIntDef(EditRemotePort.Text,5060);
    FPhone.LocalHost:=EditLocalHost.Text;
    FPhone.LocalPort:=StrToIntDef(EditLocalPort.Text,5060);
    FPhone.LineLocalPort:=FPhone.LocalPort+2;
    FPhone.Expires:=UpDownRegister.Position;
    FPhone.Connect;
  end;
end;

procedure TSipClientForm.ButtonUnRegisterClick(Sender: TObject);
begin
  if FPhone.Connected then
    FPhone.Disconnect;
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
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
    Item.FLine.Hangup;
//    FPhone.Hangup(Item.FLine);
  end;                                     
end;

procedure TSipClientForm.ButtonLinkClick(Sender: TObject);
{var
  Item1, Item2: TSipClientLine;   }
begin
{  if ButtonGroupLines.Items.Count>1 then begin
    Item1:=TSipClientLine(ButtonGroupLines.Items[0]);
    Item2:=TSipClientLine(ButtonGroupLines.Items[1]);
    if ButtonLink.Caption='Link' then begin
      FPlayer.Active:=false;
      FRecorder.Active:=false;
      Item1.FLine.Link(Item2.FLine);
      Item2.FLine.Link(Item1.FLine);
      ButtonLink.Caption:='Unlink';
    end else begin
      Item1.FLine.UnLink(Item2.FLine);
      Item2.FLine.UnLink(Item1.FLine);
      FPlayer.Active:=true;
      FRecorder.Active:=true;
      ButtonLink.Caption:='Link';
    end;
  end; }
end;

procedure TSipClientForm.ButtonAnswerClick(Sender: TObject);
var
  Item: TSipClientLine;
begin
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
    Item.FLine.Answer;
  end;
end;

procedure TSipClientForm.ButtonPlayClick(Sender: TObject);
var
  Item: TSipClientLine;
  Converter: TWaveConverter;
begin
  if (ButtonGroupLines.ItemIndex<>-1) then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);

    if ButtonPlay.Caption='Play' then begin
      Converter:=TWaveConverter.Create;
      try
        Converter.LoadFromFile(ExtractFilePath(Application.ExeName)+'test1.wav');
        if not Item.FLine.Playing and Converter.ConvertTo(Item.FLine.OutFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          Item.FLine.PlayStart(Converter.Stream,1);
        end;
        ButtonPlay.Caption:='Stop';
      finally
        Converter.Free;
      end;
    end else begin
      Item.FLine.PlayStop;
      ButtonPlay.Caption:='Play';
    end;
  end;
end;

procedure TSipClientForm.ButtonHoldClick(Sender: TObject);
var
  Item: TSipClientLine;
begin
  if ButtonGroupLines.ItemIndex<>-1 then begin
    Item:=TSipClientLine(ButtonGroupLines.Items[ButtonGroupLines.ItemIndex]);
    if ButtonHold.Caption='Hold' then begin
      Item.FLine.Hold;
    end else begin
      Item.FLine.UnHold;
    end;
  end;
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
  LifeTime: Integer;
begin
  TimerHangup.Enabled:=false;
  try
    // hangup by life time
    for i:=0 to ButtonGroupLines.Items.Count-1 do begin
      Item:=TSipClientLine(ButtonGroupLines.Items[i]);
      if Assigned(Item.FLine) then begin
        if Item.FLine.Active and
           not VarIsNull(Item.FDateConnect) and
           (IncSecond(Item.FDateConnect,UpDownLifetime.Position)<=Now) then begin
          Item.FLine.Hangup;
        end;
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


end.
