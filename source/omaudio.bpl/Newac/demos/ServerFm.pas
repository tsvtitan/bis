unit ServerFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZLib,
  IdUdpServer, IdSocketHandle, IdGlobal,
  ACS_Classes, ACS_Misc, NewACDSAudio, ACS_Converters, ComCtrls;

type
  TServerForm = class(TForm)
    Label1: TLabel;
    EditIp: TEdit;
    Label2: TLabel;
    EditPort: TEdit;
    ButtonStart: TButton;
    ButtonStop: TButton;
    LabelBytesRead: TLabel;
    LabelBytesPlay: TLabel;
    CheckBoxDecompress: TCheckBox;
    ButtonPause: TButton;
    LabelInBitsPerSample: TLabel;
    LabelInChannels: TLabel;
    LabelInSampleRate: TLabel;
    EditBitsPerSample: TEdit;
    EditChannels: TEdit;
    EditSampleRate: TEdit;
    TrackBar: TTrackBar;
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonPauseClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    FLock: TRTLCriticalSection;
    FServer: TIdUDPServer;
    FStream: TMemoryStream;
    FPosition: Int64;
    FMemoryIn: TMemoryIn;
    FAudioOut: TDSAudioOut;
    FClosing: Boolean;
    FCache: TAudioCache;
    FBufSize: Integer;
    FThreadUpdateCounters: TThread;
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure MemoryInBufferDone(Sender : TComponent; var DataBuffer : Pointer; var DataSize : LongWord; var RepeatCount : Integer);
    procedure AudioOutDone(Sender : TComponent);
    procedure StartPlay;
    procedure StopPlay;
    procedure UpdateCounters;
    function DecompressString(S: String): String;
    procedure RunThreadUpdateCounters;
    procedure ThreadTerminate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  ServerForm: TServerForm;

implementation

{$R *.dfm}

type
  TThreadUpdateCounters=class(TThread)
  public
    FForm: TServerForm;
    procedure FormUpdate;
  public
    procedure Execute; override;
  end;

{ TThreadUpdateCounters }

procedure TThreadUpdateCounters.FormUpdate;
begin
  if Assigned(FForm) then
    FForm.UpdateCounters;
end;

procedure TThreadUpdateCounters.Execute;
begin
  Sleep(100);
  Synchronize(FormUpdate);
end;

{ TServerForm }

constructor TServerForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeCriticalSection(FLock);

  FServer:=TIdUDPServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.ThreadedEvent:=false;

  FStream:=TMemoryStream.Create;
  FPosition:=0;

  FMemoryIn:=TMemoryIn.Create(nil);
  FMemoryIn.OnBufferDone:=MemoryInBufferDone;
  FMemoryIn.RepeatCount:=1;

  FCache:=TAudioCache.Create(nil);
//  FCache.Input:=FMemoryIn;

  FAudioOut:=TDSAudioOut.Create(nil);
  FAudioOut.Input:=FMemoryIn;
  FAudioOut.Calibrate:=false;
  FAudioOut.DeviceNumber:=0;
  FAudioOut.Latency:=100;
  FAudioOut.SpeedFactor:=1;
  FAudioOut.OnDone:=AudioOutDone;
end;

destructor TServerForm.Destroy;
begin
  FAudioOut.Free;
  FCache.Free;
  FMemoryIn.Free;
  FStream.Free;
  FServer.Free;
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TServerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FClosing:=true;
  ButtonStopClick(nil);
end;

function TServerForm.DecompressString(S: String): String;
var
  Zip: TDecompressionStream;
  Count: Integer;
  Buffer: array[0..1023] of Char;
  Stream: TStringStream;
  TempStream: TMemoryStream;
begin
  Result:='';
  TempStream:=TMemoryStream.Create;
  Stream:=TStringStream.Create(S);
  try
    Stream.Position:=0;
    try
      Zip:=TDecompressionStream.Create(Stream);
      try
        repeat
          Count:=Zip.Read(Buffer,SizeOf(Buffer));
          TempStream.Write(Buffer,Count);
        until Count=0;
      finally
        Zip.Free;
      end;
    except
    end;
    TempStream.Position:=0;
    SetLength(Result,TempStream.Size);
    TempStream.ReadBuffer(Pointer(Result)^,TempStream.Size);
  finally
    Stream.Free;
    TempStream.Free;
  end;
end;

procedure TServerForm.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  S: String;
  L: Integer;
  D: Integer;
begin
  EnterCriticalSection(FLock);
  try
    S:=BytesToString(AData);
    L:=Length(S);
    if L>0 then begin
      if CheckBoxDecompress.Checked then begin
        S:=DecompressString(S);
        L:=Length(S);
      end;
    end;
    if L>0 then begin
      FStream.Write(Pointer(S)^,L);
      D:=FStream.Size-FPosition;
      if D>=FBufSize then begin
        if FAudioOut.Status=tosIdle then
          StartPlay;
      end;{ else
        if FAudioOut.Status<>tosIdle then
          StopPLay;}
      RunThreadUpdateCounters;
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure TServerForm.UpdateCounters;
begin
  LabelBytesRead.Caption:=Format('BytesRead: %d',[FStream.Size]);
  LabelBytesRead.Update;
  LabelBytesPlay.Caption:=Format('BytesPlayed: %d',[FPosition]);
  LabelBytesPlay.Update;
end;

procedure TServerForm.MemoryInBufferDone(Sender: TComponent; var DataBuffer: Pointer; var DataSize: LongWord; var RepeatCount: Integer);
var
  D: Integer;
begin
//  EnterCriticalSection(FLock);
  try
    D:=FStream.Size-FPosition;
    if D>=FBufSize then begin
      FStream.Position:=FPosition;
      FStream.ReadBuffer(DataBuffer^,FBufSize);
      FPosition:=FStream.Position;
      FStream.Position:=FStream.Size;
      // because in THREAD
      RunThreadUpdateCounters;
    end else
      DataSize:=0;
  finally
 //   LeaveCriticalSection(FLock);
  end;
end;

procedure TServerForm.ThreadTerminate(Sender: TObject);
begin
  FThreadUpdateCounters:=nil;
end;

procedure TServerForm.TrackBarChange(Sender: TObject);
begin
  FAudioOut.Volume:=TrackBar.Position;
end;

procedure TServerForm.RunThreadUpdateCounters;
var
  Thread: TThreadUpdateCounters;
begin
  if not Assigned(FThreadUpdateCounters) then begin
    Thread:=TThreadUpdateCounters.Create(true);
    Thread.FForm:=Self;
    Thread.FreeOnTerminate:=true;
    Thread.OnTerminate:=ThreadTerminate;
    FThreadUpdateCounters:=Thread;
    Thread.Resume;
  end;
end;

procedure TServerForm.ButtonStopClick(Sender: TObject);
begin
  FServer.Active:=false;
  FServer.Bindings.Clear;
  FStream.Clear;
  FPosition:=0;
  StopPlay;
  UpdateCounters;
end;

procedure TServerForm.AudioOutDone(Sender: TComponent);
begin
//  StopPlay;
//  UpdateCounters;
end;

procedure TServerForm.ButtonPauseClick(Sender: TObject);
begin
  if FAudioOut.Status=tosPlaying then
    FAudioOut.Pause
  else if FAudioOut.Status=tosPaused then
    FAudioOut.Resume;
end;

procedure TServerForm.ButtonStartClick(Sender: TObject);
begin
  ButtonStop.Click;
  with FServer.Bindings.Add do begin
    IP:=EditIp.Text;
    Port:=StrToIntDef(EditPort.Text,8888);
  end;
  FServer.Active:=true;
  FMemoryIn.InBitsPerSample:=StrToIntDef(EditBitsPerSample.Text,16);
  FMemoryIn.InChannels:=StrToIntDef(EditChannels.Text,2);
  FMemoryIn.InSampleRate:=StrToIntDef(EditSampleRate.Text,44100);
  FBufSize:=(FMemoryIn.InSampleRate*FMemoryIn.InChannels*(FMemoryIn.InBitsPerSample shr 3));
end;

procedure TServerForm.StartPlay;
var
  Memory: Pointer;
begin
  StopPlay;
  GetMem(Memory,FBufSize);
  FillChar(Memory^,FBufSize,0);
  FMemoryIn.DataBuffer:=Memory;
  FMemoryIn.DataSize:=FBufSize;
  FAudioOut.Run;
  TrackBar.Position:=FAudioOut.Volume;
  TrackBar.Min:=-10000;
  TrackBar.Max:=0;
end;

procedure TServerForm.StopPlay;
begin
  FAudioOut.Stop(not FClosing);
  if Assigned(FMemoryIn.DataBuffer) then begin
    FreeMem(FMemoryIn.DataBuffer,FBufSize);
    FMemoryIn.DataBuffer:=nil;
    FMemoryIn.DataSize:=0;
  end;
end;



end.
