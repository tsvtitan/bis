unit ClientFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ZLib,
  IdUDPClient,
  ACS_classes, ACS_smpeg, ACS_WinMedia, ACS_Misc, ACS_Converters, ComCtrls;

type
  TClientForm = class(TForm)
    Label1: TLabel;
    EditIp: TEdit;
    Label2: TLabel;
    EditPort: TEdit;
    ButtonStart: TButton;
    ButtonStop: TButton;
    LabelBytesSent: TLabel;
    LabelInBitsPerSample: TLabel;
    LabelInChannels: TLabel;
    LabelInSampleRate: TLabel;
    EditSize: TEdit;
    CheckBoxCompress: TCheckBox;
    ButtonPause: TButton;
    EditBitsPerSample: TEdit;
    EditChannels: TEdit;
    EditSampleRate: TEdit;
    CheckBoxConvert: TCheckBox;
    ProgressBar: TProgressBar;
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonPauseClick(Sender: TObject);
    procedure CheckBoxConvertClick(Sender: TObject);
  private
    FClient: TIdUDPClient;
    FMP3In: TMP3In;
    FProcessor: TAudioProcessor;
    FNullOut: TNULLOut;
    FClosing: Boolean;
    FSize: Int64;
    FThreadUpdateCounters: TThread;
    FConverter: TACMConverter;
    procedure ProcessorGetData(Sender: TComponent; var Buffer: Pointer; var Bytes: Cardinal);
    procedure NullOutDone(Sender: TComponent);
    procedure UpdateCounters;
    procedure RunThreadUpdateCounters;
    function CompressString(S: String; Level: TCompressionLevel): String;
    procedure ThreadTerminate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  ClientForm: TClientForm;

implementation

{$R *.dfm}

type
  TThreadUpdateCounters=class(TThread)
  public
    FForm: TClientForm;
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

{ TClientForm }

constructor TClientForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClient:=TIdUDPClient.Create(nil);

  FMP3In:=TMP3In.Create(nil);
  FMP3In.FileName:=ExtractFilePath(Application.ExeName)+'test.mp3';
  if FileExists(FMP3In.FileName) and FMP3In.Valid then begin
    EditBitsPerSample.Text:=IntToStr(FMP3In.BitsPerSample);
    EditChannels.Text:=IntToStr(FMP3In.Channels);
    EditSampleRate.Text:=IntToStr(FMP3In.SampleRate);
    LabelInBitsPerSample.Caption:=Format('InBitsPerSample: %d',[FMP3In.BitsPerSample]);
    LabelInBitsPerSample.Update;
    LabelInChannels.Caption:=Format('InChannels: %d',[FMP3In.Channels]);
    LabelInChannels.Update;
    LabelInSampleRate.Caption:=Format('InSampleRate: %d',[FMP3In.SampleRate]);
    LabelInSampleRate.Update;
  end;
  FMP3In.EndSample:=-1;
  FMP3In.HighPrecision:=false;
  FMP3In.Loop:=false;
  FMP3In.OutputChannels:=cnMonoOrStereo;

  FConverter:=TACMConverter.Create(nil);
  FConverter.Input:=nil;

  FProcessor:=TAudioProcessor.Create(nil);
  FProcessor.Input:=FMP3In;
  FProcessor.OnGetData:=ProcessorGetData;

  FNullOut:=TNULLOut.Create(nil);
  FNullOut.Input:=FProcessor;
  FNullOut.OnDone:=NullOutDone;

  FSize:=0;
end;

destructor TClientForm.Destroy;
begin
  FNullOut.Free;
  FProcessor.Free;
  FConverter.Free;
  FMP3In.Free;
  FClient.Active:=false;
  FClient.Free;
  inherited Destroy;
end;

procedure TClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FClosing:=true;
  ButtonStopClick(nil);
  Application.ProcessMessages;
end;

procedure TClientForm.CheckBoxConvertClick(Sender: TObject);
begin
  if CheckBoxConvert.Checked then begin
   FConverter.Input:=FMP3In;
   FConverter.OutBitsPerSample:=StrToIntDef(EditBitsPerSample.Text,0);
   FConverter.OutChannels:=StrToIntDef(EditChannels.Text,0);
   FConverter.OutSampleRate:=StrToIntDef(EditSampleRate.Text,0);
   FProcessor.Input:=FConverter;
  end else begin
   FConverter.Input:=nil;
   FProcessor.Input:=FMP3In;
  end;
end;

function TClientForm.CompressString(S: String; Level: TCompressionLevel): String;
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  TempStream:=TMemoryStream.Create;
  try
    Zip:=TCompressionStream.Create(Level,TempStream);
    try
      Zip.Write(Pointer(S)^,Length(S));
    finally
      Zip.Free;
    end;
    TempStream.Position:=0;
    SetLength(Result,TempStream.Size);
    TempStream.Read(Pointer(Result)^,Length(Result))
  finally
    TempStream.Free;
  end;
end;

procedure TClientForm.ProcessorGetData(Sender: TComponent; var Buffer: Pointer; var Bytes: Cardinal);
var
  S, SOut: String;
  L,M,D,P: Integer;
  i: Integer;
begin
  FProcessor.Input.GetData(Buffer,Bytes);
  if FClient.Active and Assigned(Buffer) and (Bytes>0) then begin
    try
      SetLength(S,Bytes);
      Move(Buffer^,Pointer(S)^,Bytes);
      L:=FClient.BufferSize;
      M:=Length(S) mod L;
      D:=Length(S) div L;
      SOut:='';
      for i:=0 to D do begin
        P:=i*L;
        if i=D then begin
          SOut:=Copy(S,P+1,M);
        end else begin
          SOut:=Copy(S,P+1,L);
        end;
        if CheckBoxCompress.Checked then
          SOut:=CompressString(SOut,clMax);
        FClient.Send(EditIp.Text,StrToIntDef(EditPort.Text,8888),SOut);
        FSize:=FSize+Length(SOut);
        // because in THREAD
        RunThreadUpdateCounters;
        if not FClient.Active  then
          break;
        Sleep(1);
      end;
    except
      On E: Exception do begin
        ShowMessage(E.Message);
      end;
    end;
  end;
end;

procedure TClientForm.ThreadTerminate(Sender: TObject);
begin
  FThreadUpdateCounters:=nil;
end;

procedure TClientForm.RunThreadUpdateCounters;
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

procedure TClientForm.UpdateCounters;
begin
  ProgressBar.Position:=FMP3In.Position;
  ProgressBar.Update;
  LabelBytesSent.Caption:=Format('BytesSent: %d',[FSize]);
  LabelBytesSent.Update;
end;

procedure TClientForm.ButtonStopClick(Sender: TObject);
begin
  FClient.Active:=false;
  FNullOut.Stop(not FClosing);
  FSize:=0;
  UpdateCounters;
end;

procedure TClientForm.NullOutDone(Sender: TComponent);
begin
end;

procedure TClientForm.ButtonPauseClick(Sender: TObject);
begin
  if FNullOut.Status=tosPlaying then
    FNullOut.Pause
  else if FNullOut.Status=tosPaused then
    FNullOut.Resume;
end;

procedure TClientForm.ButtonStartClick(Sender: TObject);
begin
  ButtonStop.Click;
  CheckBoxConvertClick(nil);
  FClient.BufferSize:=StrToIntDef(EditSize.Text,1024);
  FClient.Active:=true;
  ProgressBar.Position:=0;
  ProgressBar.Min:=0;
  ProgressBar.Max:=FMP3In.Size;
  FNullOut.Run;
  UpdateCounters;
end;


end.