unit BisAudioWaveFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, mmSystem, Menus, ActnPopup,
  WaveUtils,
  BisFrm,
  BisAudioWave;

type
  TBisAudioWaveFrame=class;

  TBisAudioWaveFrameEvent=procedure (Frame: TBisAudioWaveFrame) of object;

  TBisAudioWaveFrameFormats=set of TPCMFormat;

  TBisAudioWaveFrame = class(TBisFrame)
    TrackBarPosition: TTrackBar;
    BitBtnPlay: TBitBtn;
    BitBtnPause: TBitBtn;
    BitBtnStop: TBitBtn;
    BitBtnLoad: TBitBtn;
    BitBtnSave: TBitBtn;
    BitBtnClear: TBitBtn;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    Timer: TTimer;
    TrackBarVolume: TTrackBar;
    LabelTime: TStaticText;
    BitBtnRecord: TBitBtn;
    LabelFormat: TLabel;
    BitBtnFormat: TBitBtn;
    PopupFormat: TPopupActionBar;
    MenuItemMono8Bit8000Hz: TMenuItem;
    MenuItemMono16bit8000Hz: TMenuItem;
    MenuItemMono8bit11025Hz: TMenuItem;
    MenuItemMono8bit22050Hz: TMenuItem;
    MenuItemMono16bit11025Hz: TMenuItem;
    MenuItemMono16bit22050Hz: TMenuItem;
    procedure BitBtnPlayClick(Sender: TObject);
    procedure BitBtnPauseClick(Sender: TObject);
    procedure BitBtnStopClick(Sender: TObject);
    procedure BitBtnLoadClick(Sender: TObject);
    procedure BitBtnSaveClick(Sender: TObject);
    procedure BitBtnClearClick(Sender: TObject);
    procedure TrackBarPositionChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TrackBarVolumeChange(Sender: TObject);
    procedure BitBtnRecordClick(Sender: TObject);
    procedure BitBtnFormatClick(Sender: TObject);
    procedure MenuItemMono16bit22050HzClick(Sender: TObject);
  private
    FPlayer: TBisAudioStockPlayer;
    FRecorder: TBisAudioLiveRecorder;
    FWaveOriginal: TBisAudioWave;
    FWaveTransform: TBisAudioWave;
    FOnClear: TBisAudioWaveFrameEvent;
    FOnLoad: TBisAudioWaveFrameEvent;
    FEditable: Boolean;
    FOnBeforePlay: TBisAudioWaveFrameEvent;
    FEventHappend: Boolean;
    FEventTime: Cardinal;
    FOnEvent: TBisAudioWaveFrameEvent;
    FCurrentVolume: Integer;
    FConverted: Boolean;
    FOnAfterRecord: TBisAudioWaveFrameEvent;
    FOnAfterPlay: TBisAudioWaveFrameEvent;

    procedure PlayerStop(Sender: TObject);
    procedure PlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: DWord);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
    procedure UpdateTime(Position: Cardinal);
    procedure SetEditable(const Value: Boolean);
    function GetEmpty: Boolean;
    function Transform: Boolean;
    procedure PlayerFirst(FromBegin: Boolean);
    procedure RecorderFirst;
    procedure SetPCMFormat(const Value: TPCMFormat);
    procedure SetAvailableFormats;
    procedure SetBestFormat;
    procedure SetDefaultFormat;
    function GetMenuByFormat(F: TPCMFormat): TMenuItem;
    function GetFormatByMenu: TPCMFormat;
    function GetPCMFormat: TPCMFormat;
    function GetAvailableFormats: TBisAudioWaveFrameFormats;
    function GetSpeedFactor: Single;
    procedure SetSpeedFactor(const Value: Single);
  protected
    procedure DoClear;
    procedure DoLoad;
    procedure DoBeforePlay;
    procedure DoAfterPlay;
    procedure DoAfterRecord;
    procedure DoEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    function CanPlay: Boolean;
    procedure Play;
    function CanRecord: Boolean;
    procedure &Record;
    function CanPause: Boolean;
    procedure Pause;
    function CanStop: Boolean;
    procedure Stop;
    function CanLoad: Boolean;
    procedure Load;
    function CanSave: Boolean;
    procedure Save;
    function CanClear: Boolean;
    procedure Clear;
    procedure UpdateStates;

    property Editable: Boolean read FEditable write SetEditable;
    property EventTime: Cardinal read FEventTime write FEventTime;
    property PCMFormat: TPCMFormat read GetPCMFormat write SetPCMFormat;
    property SpeedFactor: Single read GetSpeedFactor write SetSpeedFactor;
    property Empty: Boolean read GetEmpty;
    property AvailableFormats: TBisAudioWaveFrameFormats read GetAvailableFormats;

    property OnClear: TBisAudioWaveFrameEvent read FOnClear write FOnClear;
    property OnLoad: TBisAudioWaveFrameEvent read FOnLoad write FOnLoad;
    property OnBeforePlay: TBisAudioWaveFrameEvent read FOnBeforePlay write FOnBeforePlay;
    property OnAfterPlay: TBisAudioWaveFrameEvent read FOnAfterPlay write FOnAfterPlay; 
    property OnAfterRecord: TBisAudioWaveFrameEvent read FOnAfterRecord write FOnAfterRecord; 
    property OnEvent: TBisAudioWaveFrameEvent read FOnEvent write FOnEvent;
  end;

implementation

uses DateUtils,
     BisUtils;

{$R *.dfm}

{ TBisAudioWaveFrame }

constructor TBisAudioWaveFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  SetDefaultFormat;
  
  SetBestFormat;

  FWaveOriginal:=TBisAudioWave.Create;

  FWaveTransform:=TBisAudioWave.Create;

  FPlayer:=TBisAudioStockPlayer.Create(nil);
  FPlayer.DeviceID:=0;
  FPlayer.Async:=false;
  FPlayer.BufferLength:=100;
  FPlayer.BufferCount:=5;
  FPlayer.OnStop:=PlayerStop;
  FPlayer.OnData:=PlayerData;

  FRecorder:=TBisAudioLiveRecorder.Create(nil);
  FRecorder.DeviceID:=0;
  FRecorder.Async:=false;
  FRecorder.OnData:=RecorderData;

  FEditable:=true;
  FEventTime:=0;
  FEventHappend:=false;

  Clear;
end;

destructor TBisAudioWaveFrame.Destroy;
begin
  Stop;
  FRecorder.Free;
  FPlayer.Free;
  FWaveTransform.Free;
  FWaveOriginal.Free;
  inherited Destroy;
end;

procedure TBisAudioWaveFrame.DoAfterPlay;
begin
  if Assigned(FOnAfterPlay) then
    FOnAfterPlay(Self);
end;

procedure TBisAudioWaveFrame.DoAfterRecord;
begin
  if Assigned(FOnAfterRecord) then
    FOnAfterRecord(Self);
end;

procedure TBisAudioWaveFrame.DoBeforePlay;
begin
  if Assigned(FOnBeforePlay) then
    FOnBeforePlay(Self);
end;

procedure TBisAudioWaveFrame.DoClear;
begin
  if Assigned(FOnClear) then
    FOnClear(Self);
end;

procedure TBisAudioWaveFrame.DoEvent;
begin
  if Assigned(FOnEvent) then
    FOnEvent(Self);
end;

procedure TBisAudioWaveFrame.DoLoad;
begin
  if Assigned(FOnLoad) then
    FOnLoad(Self);
end;

procedure TBisAudioWaveFrame.PlayerFirst(FromBegin: Boolean);
begin
  FEventHappend:=false;
  FCurrentVolume:=-(TrackBarVolume.Position);
  FPlayer.Paused:=false;
  FPlayer.Stop;
  FPlayer.WaitForStop;
  if FromBegin then
    TrackBarPosition.Position:=0;
end;

procedure TBisAudioWaveFrame.RecorderFirst;
begin
  FRecorder.Paused:=false;
  FRecorder.Active:=false;
  FRecorder.WaitForStop;
end;

function TBisAudioWaveFrame.GetAvailableFormats: TBisAudioWaveFrameFormats;
begin
  Result:=[];
  if MenuItemMono8Bit8000Hz.Enabled then
    Include(Result,Mono8Bit8000Hz);
  if MenuItemMono16bit8000Hz.Enabled then
    Include(Result,Mono16bit8000Hz);
  if MenuItemMono8bit11025Hz.Enabled then
    Include(Result,Mono8bit11025Hz);
  if MenuItemMono8bit22050Hz.Enabled then
    Include(Result,Mono8bit22050Hz);
  if MenuItemMono16bit11025Hz.Enabled then
    Include(Result,Mono16bit11025Hz);
  if MenuItemMono16bit22050Hz.Enabled then
    Include(Result,Mono16bit22050Hz);
end;

function TBisAudioWaveFrame.GetEmpty: Boolean;
begin
  Result:=FWaveOriginal.Empty;
end;

function TBisAudioWaveFrame.GetFormatByMenu: TPCMFormat;
begin
  Result:=nonePCM;
  if MenuItemMono8Bit8000Hz.Checked then
    Result:=Mono8Bit8000Hz;
  if MenuItemMono16bit8000Hz.Checked then
    Result:=Mono16bit8000Hz;
  if MenuItemMono8bit11025Hz.Checked then
    Result:=Mono8bit11025Hz;
  if MenuItemMono8bit22050Hz.Checked then
    Result:=Mono8bit22050Hz;
  if MenuItemMono16bit11025Hz.Checked then
    Result:=Mono16bit11025Hz;
  if MenuItemMono16bit22050Hz.Checked then
    Result:=Mono16bit22050Hz;
end;

function TBisAudioWaveFrame.GetMenuByFormat(F: TPCMFormat): TMenuItem;
begin
  Result:=nil;
  case F of
    Mono8Bit8000Hz: Result:=MenuItemMono8Bit8000Hz;
    Mono16bit8000Hz: Result:=MenuItemMono16bit8000Hz;
    Mono8bit11025Hz: Result:=MenuItemMono8bit11025Hz;
    Mono16bit11025Hz: Result:=MenuItemMono16bit11025Hz;
    Mono8bit22050Hz: Result:=MenuItemMono8bit22050Hz;
    Mono16bit22050Hz: Result:=MenuItemMono16bit22050Hz;
  end;
end;

procedure TBisAudioWaveFrame.BeforeShow;
begin
  inherited BeforeShow;
  UpdateStates;
end;

procedure TBisAudioWaveFrame.SetPCMFormat(const Value: TPCMFormat);
var
  MenuItem: TMenuItem;
begin
  MenuItem:=GetMenuByFormat(Value);
  if Assigned(MenuItem) then begin
    FRecorder.PCMFormat:=Value;
    MenuItem.Checked:=true;
  end;
end;

procedure TBisAudioWaveFrame.SetSpeedFactor(const Value: Single);
begin
  FPlayer.SpeedFactor:=Value;
end;

function TBisAudioWaveFrame.GetPCMFormat: TPCMFormat;
begin
  Result:=GetFormatByMenu;
end;

function TBisAudioWaveFrame.GetSpeedFactor: Single;
begin
  Result:=FPlayer.SpeedFactor;
end;

procedure TBisAudioWaveFrame.BitBtnClearClick(Sender: TObject);
begin
  Clear;
end;

procedure TBisAudioWaveFrame.BitBtnFormatClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=ClientToScreen(Point(BitBtnFormat.Left,BitBtnFormat.Top+BitBtnFormat.Height));
  PopupFormat.Popup(Pt.X,Pt.Y);
end;

procedure TBisAudioWaveFrame.BitBtnLoadClick(Sender: TObject);
begin
  Load;
end;

procedure TBisAudioWaveFrame.BitBtnPauseClick(Sender: TObject);
begin
  Pause;
end;

procedure TBisAudioWaveFrame.BitBtnPlayClick(Sender: TObject);
begin
  Play;
end;

procedure TBisAudioWaveFrame.BitBtnRecordClick(Sender: TObject);
begin
  &Record;
end;

procedure TBisAudioWaveFrame.BitBtnSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TBisAudioWaveFrame.BitBtnStopClick(Sender: TObject);
begin
  Stop;
end;

procedure TBisAudioWaveFrame.PlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: DWord);
begin
  ChangeWaveAudioVolume(Buffer,BufferSize,FWaveTransform.WaveFormat,FCurrentVolume);
end;

procedure TBisAudioWaveFrame.PlayerStop(Sender: TObject);
begin
  Stop;
  DoAfterPlay;
end;

procedure TBisAudioWaveFrame.UpdateStates;
begin
  TrackBarPosition.Enabled:=not FWaveOriginal.Empty;
  TrackBarVolume.Enabled:=not FWaveOriginal.Empty and FConverted;
  BitBtnPlay.Enabled:=CanPlay;
  BitBtnRecord.Enabled:=CanRecord;
  BitBtnPause.Enabled:=CanPause;
  BitBtnStop.Enabled:=CanStop;
  BitBtnLoad.Enabled:=CanLoad;
  BitBtnSave.Enabled:=CanSave;
  BitBtnClear.Enabled:=CanClear;
  BitBtnFormat.Enabled:=not FPlayer.Active and not FRecorder.Active;
  Timer.Enabled:=FPlayer.Active or FRecorder.Active;
end;

procedure TBisAudioWaveFrame.UpdateTime(Position: Cardinal);
var
   D: TDateTime;
begin
  D:=Position/MSecsPerSec/SecsPerDay;
  LabelTime.Caption:=FormatEx('%s',[FormatDateTime('hh:nn:ss.zzz',D)]);
  LabelTime.Update;
end;

procedure TBisAudioWaveFrame.TimerTimer(Sender: TObject);
begin

  if FPlayer.Active and not FPlayer.Paused then begin
    Timer.Enabled:=false;
    TrackBarPosition.OnChange:=nil;
    try
      TrackBarPosition.Position:=FPlayer.Position;
      UpdateTime(FPlayer.Position);
      if not FEventHappend then begin
        if (FPlayer.Position>=FEventTime) and (FPlayer.Position<=(FEventTime+Timer.Interval*3)) then begin
          FEventHappend:=true;
          DoEvent;
        end;
      end;
    finally
      TrackBarPosition.OnChange:=TrackBarPositionChange;
      Timer.Enabled:=true;
    end;
  end;

  if FRecorder.Active and not FRecorder.Paused then begin
    Timer.Enabled:=false;
    try
      UpdateTime(FRecorder.Position);
    finally
      Timer.Enabled:=true;
    end;
  end;

end;

procedure TBisAudioWaveFrame.TrackBarPositionChange(Sender: TObject);
begin
  FPlayer.Position:=TrackBarPosition.Position;
  UpdateTime(FPlayer.Position);
end;

procedure TBisAudioWaveFrame.TrackBarVolumeChange(Sender: TObject);
begin
  FCurrentVolume:=-(TrackBarVolume.Position);
end;

procedure TBisAudioWaveFrame.SetEditable(const Value: Boolean);
begin
  FEditable := Value;
  UpdateStates;
end;

function TBisAudioWaveFrame.CanPlay: Boolean;
begin
  Result:=(not FPlayer.Active or FPlayer.Paused) and
           not FWaveOriginal.Empty and (FWaveOriginal.DataSize>0);
end;

procedure TBisAudioWaveFrame.Play;
begin
  if CanPlay then begin
    if not FPlayer.Paused then begin
      PlayerFirst(false);
      DoBeforePlay;
      Transform;
      FPlayer.Position:=TrackBarPosition.Position;
      FPlayer.PlayStream(FWaveTransform.Stream,0);
    end else
      FPlayer.Paused:=false;
  end;
  UpdateStates;
end;

function TBisAudioWaveFrame.CanRecord: Boolean;
begin
  Result:=(not FRecorder.Active or FRecorder.Paused) and
          FWaveOriginal.Empty;
end;

procedure TBisAudioWaveFrame.&Record;
begin
  if CanRecord then begin
    if not FRecorder.Paused then begin
      RecorderFirst;
      FWaveTransform.BeginRewritePCM(GetFormatByMenu);
      FRecorder.PCMFormat:=GetFormatByMenu;
      FRecorder.Active:=true;
    end else
      FRecorder.Paused:=false;
  end;
  UpdateStates;
end;

procedure TBisAudioWaveFrame.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
begin
  FreeIt:=true;
  if (BufferSize>0) then begin
    FWaveTransform.Write(Buffer^,BufferSize);
  end;
end;

function TBisAudioWaveFrame.CanPause: Boolean;
begin
  Result:=(FPlayer.Active and not FPlayer.Paused) or
          (FRecorder.Active and not FRecorder.Paused);
end;

procedure TBisAudioWaveFrame.Pause;
begin
  if CanPause then begin
    if FPlayer.Active then
      FPlayer.Paused:=true;
    if FRecorder.Active then
      FRecorder.Paused:=true;
  end;
  UpdateStates;
end;

function TBisAudioWaveFrame.CanStop: Boolean;
begin
  Result:=FPlayer.Active or FRecorder.Active;
end;

procedure TBisAudioWaveFrame.Stop;
begin
  if CanStop then begin
    if FPlayer.Active then begin
      PlayerFirst(true);
    end;
    if FRecorder.Active then begin
      RecorderFirst;
      FWaveTransform.EndRewrite;
      FWaveOriginal.Assign(FWaveTransform);
      TrackBarPosition.Max:=FWaveOriginal.Length;
      UpdateTime(TrackBarPosition.Max);
      LabelFormat.Caption:=FWaveOriginal.AudioFormat;
      DoAfterRecord;
    end;
  end else if not FPlayer.Active then
    PlayerFirst(true)
  else
    RecorderFirst;
  UpdateStates;
end;

function TBisAudioWaveFrame.CanLoad: Boolean;
begin
  Result:=not FPlayer.Active and not FRecorder.Active and
          FEditable;
end;

procedure TBisAudioWaveFrame.Load;
begin
  if CanLoad then begin
    if OpenDialog.Execute then begin
      PlayerFirst(true);
      FWaveOriginal.LoadFromFile(OpenDialog.FileName);
      TrackBarPosition.Max:=FWaveOriginal.Length;
      UpdateTime(TrackBarPosition.Max);
      LabelFormat.Caption:=FWaveOriginal.AudioFormat;
      SetAvailableFormats;
      FConverted:=Transform;
      DoLoad;
    end;
  end;
  UpdateStates;
end;

function TBisAudioWaveFrame.CanSave: Boolean;
begin
  Result:=not FWaveOriginal.Empty;
end;

procedure TBisAudioWaveFrame.Save;
begin
  if CanSave then begin
    if SaveDialog.Execute then
      FWaveOriginal.SaveToFile(SaveDialog.FileName);
  end;
  UpdateStates;
end;

function TBisAudioWaveFrame.CanClear: Boolean;
begin
  Result:=not FPlayer.Active and not FWaveOriginal.Empty and FEditable;
end;

procedure TBisAudioWaveFrame.Clear;
begin
  if CanClear then begin
    PlayerFirst(true);
    RecorderFirst;
    FWaveOriginal.Clear;
    FWaveTransform.Clear;
    UpdateTime(0);
    LabelFormat.Caption:='';
    SetDefaultFormat;
    DoClear;
  end;
  UpdateStates;
end;

procedure TBisAudioWaveFrame.SetAvailableFormats;
const
  Formats: array[0..5] of TPCMFormat = (Mono8Bit8000Hz,Mono16bit8000Hz,Mono8bit11025Hz,
                                        Mono16bit11025Hz,Mono8bit22050Hz,Mono16bit22050Hz);
var
  i: Integer;
  FMT: TPCMFormat;
  Wave: TBisAudioWave;
  ItemCheck: TMenuItem;
begin
  if not FWaveOriginal.Empty then begin
    Wave:=TBisAudioWave.Create;
    try

      ItemCheck:=nil;
      for i:=0 to PopupFormat.Items.Count-1 do begin
        PopupFormat.Items[i].Enabled:=false;
        if PopupFormat.Items[i].Checked then begin
          PopupFormat.Items[i].Checked:=false;
          ItemCheck:=PopupFormat.Items[i];
        end;
      end;

      for i:=High(Formats) downto Low(Formats) do begin
        FMT:=Formats[i];
        Wave.Assign(FWaveOriginal);
        if Wave.ConvertToPCM(FMT) then begin
          if FMT=Mono8Bit8000Hz then
            MenuItemMono8Bit8000Hz.Enabled:=true;

          if FMT=Mono16bit8000Hz then
            MenuItemMono16bit8000Hz.Enabled:=true;

          if FMT=Mono8bit11025Hz then
            MenuItemMono8bit11025Hz.Enabled:=true;

          if FMT=Mono16bit11025Hz then
            MenuItemMono16bit11025Hz.Enabled:=true;

          if FMT=Mono8bit22050Hz then
            MenuItemMono8bit22050Hz.Enabled:=true;

          if FMT=Mono16bit22050Hz then
            MenuItemMono16bit22050Hz.Enabled:=true;
        end;
      end;

      if Assigned(ItemCheck) and ItemCheck.Enabled then
        ItemCheck.Checked:=true
      else
        SetBestFormat;  
      

    finally
      Wave.Free;
    end;
  end;
end;

procedure TBisAudioWaveFrame.SetBestFormat;
var
  i: Integer;
  Item: TMenuItem;
begin
  for i:=PopupFormat.Items.Count-1 downto 0 do begin
    Item:=PopupFormat.Items[i];
    if Item.Enabled then begin
      Item.Checked:=true;
      exit;
    end;
  end;
end;

procedure TBisAudioWaveFrame.SetDefaultFormat;
var
  i: Integer;
begin
  for i:=0 to PopupFormat.Items.Count-1 do begin
    PopupFormat.Items[i].Enabled:=true;
  end;
end;

function TBisAudioWaveFrame.Transform: Boolean;
var
  FMT: TPCMFormat;
begin
  Result:=false;
  if not FWaveOriginal.Empty then begin
    FWaveTransform.Assign(FWaveOriginal);
    FMT:=GetFormatByMenu;
    if FMT<>nonePCM then
      Result:=FWaveTransform.ConvertToPCM(FMT);
  end;
end;

procedure TBisAudioWaveFrame.LoadFromStream(Stream: TStream);
var
  OldPos: Integer;
begin
  if CanLoad then begin
    OldPos:=Stream.Position;
    Stream.Position:=0;
    try
      PlayerFirst(true);
      FWaveOriginal.LoadFromStream(Stream);
      TrackBarPosition.Max:=FWaveOriginal.Length;
      UpdateTime(TrackBarPosition.Max);
      LabelFormat.Caption:=FWaveOriginal.AudioFormat;
      SetAvailableFormats;
      FConverted:=Transform;
    finally
      Stream.Position:=OldPos;
    end;
  end;
  UpdateStates;
end;

procedure TBisAudioWaveFrame.MenuItemMono16bit22050HzClick(Sender: TObject);
var
  Item: TMenuItem;
begin
  if Assigned(Sender) and (Sender is TMenuItem) then begin
    Item:=TMenuItem(Sender);
    Item.Checked:=true;
  end;
end;

procedure TBisAudioWaveFrame.SaveToStream(Stream: TStream);
begin
  FWaveOriginal.SaveToStream(Stream);
end;

end.
