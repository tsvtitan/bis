unit SipClientFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MMSystem,
  Acm,
  WavePlayers, WaveUtils,
  BisSipClient;

type
  TAudioBuffer = class
  private
    CS: RTL_CRITICAL_SECTION;
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

  TSipClientForm = class(TForm)
    GroupBoxRegister: TGroupBox;
    LabelHost: TLabel;
    LabelPort: TLabel;
    LabelUserName: TLabel;
    LabelPassword: TLabel;
    EditHost: TEdit;
    EditPort: TEdit;
    EditUserName: TEdit;
    EditPassword: TEdit;
    ButtonRegister: TButton;
    ButtonUnRegister: TButton;
    GroupBoxCall: TGroupBox;
    ButtonInvite: TButton;
    GroupBoxLog: TGroupBox;
    MemoLog: TMemo;
    LabelInviteUserName: TLabel;
    EditInviteUserName: TEdit;
    ButtonCancel: TButton;
    CheckBoxLog: TCheckBox;
    Button1: TButton;
    Edit1: TEdit;
    ButtonBye: TButton;
    Button2: TButton;
    procedure ButtonRegisterClick(Sender: TObject);
    procedure ButtonUnRegisterClick(Sender: TObject);
    procedure ButtonInviteClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonByeClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FClient: TBisSipClient;
    FPlayer: TLiveAudioPlayer;
    FBuffer: TAudioBuffer;
    FACMDlg: TACMDlg;

    procedure ClientSend(Sender: TBisSipClient; Message: String);
    procedure ClientReceive(Sender: TBisSipClient; Message: String);
    procedure ClientRegister(Sender: TBisSipClient);
    procedure ClientData(Sender: TBisSipClient; Data: TBytes);


    function PlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
    procedure PlayerFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);


    procedure UpdateButtons;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  SipClientForm: TSipClientForm;

implementation


uses
     FileCtrl, TypInfo,
     BisFileDirs, BisRtp, BisUtils;

{$R *.dfm}

{ TAudioBuffer }

constructor TAudioBuffer.Create;
begin
  InitializeCriticalSection(CS);
end;

destructor TAudioBuffer.Destroy;
begin
  Clear;
  DeleteCriticalSection(CS);
  inherited Destroy;
end;

procedure TAudioBuffer.Clear;
begin
  EnterCriticalSection(CS);
  try
    ReallocMem(Data, 0);
    Size := 0;
  finally
    LeaveCriticalSection(CS);
  end;
end;

function TAudioBuffer.BeginUpdate(ExtraSize: Cardinal): Pointer;
begin
  EnterCriticalSection(CS);
  ReallocMem(Data, Size + ExtraSize);
  Result := Pointer(Cardinal(Data) + Size);
  Inc(Size, ExtraSize);
end;

procedure TAudioBuffer.EndUpdate;
begin
  LeaveCriticalSection(CS);
end;

function TAudioBuffer.Get(var Buffer: Pointer; var BufferSize: Cardinal): Boolean;
begin
  EnterCriticalSection(CS);
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
    LeaveCriticalSection(CS);
  end;
end;

{ TSipClientForm }

constructor TSipClientForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FBuffer:=TAudioBuffer.Create;

  FClient:=TBisSipClient.Create(nil);
  FClient.LocalHost:='192.168.1.3';
  FClient.LocalPort:=5060;
  FClient.OnSend:=ClientSend;
  FClient.OnReceive:=ClientReceive;
  FClient.OnRegister:=ClientRegister;
  FClient.OnData:=ClientData;

  FPlayer:=TLiveAudioPlayer.Create(nil);
  FPlayer.OnDataPtr:=PlayerDataPtr;
//  FPlayer.OnData:=PlayerData;
  FPlayer.OnFormat:=PlayerFormat;
  FPlayer.BufferCount:=10;
  FPlayer.BufferInternally:=false;
  FPlayer.BufferLength:=1000;
  FPlayer.PCMFormat:=nonePCM;
  FPlayer.DeviceID:=0;
  FPlayer.Async:=false;



  FACMDlg:=TACMDlg.Create(Self);
  if FACMDlg.Execute then begin

  end;
end;

destructor TSipClientForm.Destroy;
begin
  FPlayer.Active:=false;
  FPlayer.Free;
  FClient.Free;
  FBuffer.Free;
  inherited Destroy;
end;

function TSipClientForm.PlayerDataPtr(Sender: TObject; var Buffer: Pointer; var NumLoops: Cardinal; var FreeIt: Boolean): Cardinal;
begin
  if FBuffer.Get(Buffer, Result) then begin
    FreeIt := True;
  end else begin
//    Buffer := nil; // When Buffer is nil,
    GetMem(Buffer,1000);
    FillChar(Buffer^,1000,0);
    Result := 1000;   // Result will be considered as silence milliseconds.
    FreeIt := True;
  end
end;

procedure TSipClientForm.PlayerFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
begin
  FreeIt := false;
  pWaveFormat := FACMDlg.WaveFormatEx;
  FPlayer.BufferLength:=pWaveFormat.nChannels*pWaveFormat.nSamplesPerSec;
end;

procedure TSipClientForm.ClientReceive(Sender: TBisSipClient; Message: String);
begin
  if CheckBoxLog.Checked then begin
    MemoLog.Lines.Add(DateTimeToStr(Now)+' ========= RECV from '+
                      Sender.RemoteHost+':'+IntToStr(Sender.RemotePort)+' =========');
    MemoLog.Lines.Add(Message);
    MemoLog.Lines.Add('');
  end;
end;

procedure TSipClientForm.ClientSend(Sender: TBisSipClient; Message: String);
begin
  if CheckBoxLog.Checked then begin
    MemoLog.Lines.Add(DateTimeToStr(Now)+' ========= SEND to '+
                      Sender.RemoteHost+':'+IntToStr(Sender.RemotePort)+' =========');
    MemoLog.Lines.Add(Message);
    MemoLog.Lines.Add('');
  end;
end;

procedure TSipClientForm.ClientData(Sender: TBisSipClient; Data: TBytes);
var
  AData: Pointer;
  ADataSize: Integer;
begin
  ADataSize:=Length(Data);
  if ADataSize>0 then begin
    AData:=FBuffer.BeginUpdate(ADataSize);
    try
      Move(Pointer(Data)^,AData^,ADataSize);
    finally
      FBuffer.EndUpdate;
    end;
    FPlayer.Paused:=false;
  end else
    FPlayer.Paused:=true;
end;

procedure TSipClientForm.ClientRegister(Sender: TBisSipClient);
begin
  UpdateButtons;
end;

procedure TSipClientForm.UpdateButtons;
begin
  ButtonRegister.Enabled:=not FClient.Registered;
  ButtonUnRegister.Enabled:=FClient.Registered;
  ButtonInvite.Enabled:=FClient.Registered;
  ButtonCancel.Enabled:=FClient.Registered;
  ButtonBye.Enabled:=FClient.Registered;
end;

procedure TSipClientForm.ButtonRegisterClick(Sender: TObject);
begin
  if not FClient.Registered then begin
    FClient.UserName:=EditUserName.Text;
    FClient.Password:=EditPassword.Text;
    FClient.RemoteHost:=EditHost.Text;
  //  FClient.RemoteHost:='sion.vezdefon.ru';
    FClient.RemotePort:=StrToIntDef(EditPort.Text,5060);
    FClient.Register;
  end;
end;

procedure TSipClientForm.ButtonUnRegisterClick(Sender: TObject);
begin
  if FClient.Registered then
    FClient.UnRegister;
end;

procedure TSipClientForm.ButtonInviteClick(Sender: TObject);
begin
  FBuffer.Clear;
  if FClient.Registered then begin
    FClient.Invite(EditInviteUserName.Text);
    FPlayer.Active:=true;
  end;
end;

procedure TSipClientForm.Button1Click(Sender: TObject);
begin
  FClient.TestRtpServer(Edit1.text);
end;

procedure TSipClientForm.ButtonByeClick(Sender: TObject);
begin
//  if FClient.Active then
     FClient.Bye(EditInviteUserName.Text);
     FPlayer.Active:=false;
     FBuffer.Clear;
end;

procedure TSipClientForm.ButtonCancelClick(Sender: TObject);
begin
//  if FClient.Active then
     FClient.Cancel(EditInviteUserName.Text);
     FPlayer.Active:=false;
     FBuffer.Clear;
end;


procedure TSipClientForm.Button2Click(Sender: TObject);
var
  Files: TBisFileDirs;
  Dir: String;
  i: Integer;
  Item: TBisFileDir;
  Ext: String;
  Stream: TMemoryStream;
  Client: TMemoryStream;
  Server: TMemoryStream;
  Strings: TStringList;
  Packet: TBisRtpPacket;
  Data: String;
  Short: String;
  IsClient: Boolean;
begin
  if SelectDirectory('','',Dir,[],Self) then begin
    Files:=TBisFileDirs.Create;
    Strings:=TStringList.Create;
    Client:=TMemoryStream.Create;
    Server:=TMemoryStream.Create;
    try
      DeleteFile(Dir+'\info.txt');
      DeleteFile(Dir+'\client.payload');
      DeleteFile(Dir+'\server.payload');
      Files.Refresh(Dir,false);
      for i:=0 to Files.Count-1 do begin
        Item:=Files.Items[i];
        if not Item.IsDir then begin
          Ext:=ExtractFileExt(Item.Name);

          if Ext='.mem' then begin
            Stream:=TMemoryStream.Create;
            Packet:=TBisRtpPacket.Create;
            try
              Stream.LoadFromFile(Item.Name);
              Stream.Position:=42;
              SetLength(Data,Stream.Size-Stream.Position);
              Stream.Read(Pointer(Data)^,Length(Data));
              Packet.Parse(Data);
              Strings.Add(Format('=========================== %s',[ExtractFileName(Item.Name)]));
              Strings.Add(Format('Version=%s',[GetEnumName(TypeInfo(TBisRtpPacketVersion),Integer(Packet.Version))]));
              Strings.Add(Format('Padding=%s',[GetEnumName(TypeInfo(Boolean),Integer(Packet.Padding))]));
              Strings.Add(Format('Extension=%s',[GetEnumName(TypeInfo(Boolean),Integer(Packet.Extension))]));
              Strings.Add(Format('Marker=%s',[GetEnumName(TypeInfo(Boolean),Integer(Packet.Marker))]));
              Strings.Add(Format('PayloadType=%s',[GetEnumName(TypeInfo(TBisRtpPacketPayloadType),Integer(Packet.PayloadType))]));
              Strings.Add(Format('Sequence=%d',[Packet.Sequence]));
              Strings.Add(Format('TimeStamp=%d',[Packet.TimeStamp]));
              Strings.Add(Format('SSRCIdentifier=%d',[Packet.SSRCIdentifier]));
              Strings.Add(Format('CSRCList.Count=%d',[Packet.CSRCList.Count]));
              Strings.Add(Format('ExternalHeader Length=%d',[Length(Packet.ExternalHeader)]));
              Strings.Add(Format('Payload Length=%d',[Length(Packet.Payload)]));

              Short:=ExtractFileName(Item.Name);
              Short:=Copy(Short,5,Length(Short));
              IsClient:=iff(Short='c.mem',true,false);
              if IsClient then
                Client.Write(Pointer(Packet.Payload)^,Length(Packet.Payload))
              else
                Server.Write(Pointer(Packet.Payload)^,Length(Packet.Payload))
              
            finally
              Packet.Free;
              Stream.Free;
            end;
          end;
        end;
      end;
      Strings.SaveToFile(Dir+'\info.txt');
      Client.SaveToFile(Dir+'\client.payload');
      Server.SaveToFile(Dir+'\server.payload');
    finally
      Server.Free;
      Client.Free;
      Strings.Free;
      Files.Free;
    end;
  end;
end;


end.
