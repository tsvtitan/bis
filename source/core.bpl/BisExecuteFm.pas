unit BisExecuteFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ImgList, ActnList,

  BisFm, BisSizeGrip, BisThreads, BisOptionsFm, BisOptionsFrm;

type
  TBisExecuteFormThread=class(TBisThread)
  end;

  TBisExecuteForm = class(TBisForm)
    PanelButtons: TPanel;
    ButtonCancel: TButton;
    BitBtnStart: TBitBtn;
    BitBtnStop: TBitBtn;
    Timer: TTimer;
    ImageList: TImageList;
    ActionList: TActionList;
    ActionStart: TAction;
    ActionStop: TAction;
    ButtonOptions: TButton;
    ActionOptions: TAction;
    PanelControls: TPanel;
    procedure ButtonCancelClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ActionStartExecute(Sender: TObject);
    procedure ActionStartUpdate(Sender: TObject);
    procedure ActionStopExecute(Sender: TObject);
    procedure ActionStopUpdate(Sender: TObject);
    procedure ActionOptionsExecute(Sender: TObject);
    procedure ActionOptionsUpdate(Sender: TObject);
  private
    FSuccess: Boolean;
    FStartCaption: String;
    FTimerTime: Integer;
    FAutoExit: Boolean;
    FAutoStartTime: Integer;
    FThread: TBisExecuteFormThread;
    FSizeGrip: TBisSizeGrip;
    FWorking: Boolean;
    FOnEnd: TNotifyEvent;

    procedure ThreadWork(Thread: TBisThread);
    procedure ThreadEnd(Thread: TBisThread);
    procedure UpdateStartCaption(WithWait: Boolean);
  protected
    function GetWorking: Boolean; override;
    function Execute(Thread: TBisExecuteFormThread): Boolean; virtual;
    procedure DoEnd; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function CanOptions: Boolean; override;
    function CanStart: Boolean; virtual;
    procedure Start; virtual;
    function CanStop: Boolean; virtual;
    procedure Stop; virtual;


    property SizeGrip: TBisSizeGrip read FSizeGrip;
    property Working: Boolean read FWorking;

    property OnEnd: TNotifyEvent read FOnEnd write FOnEnd;
  end;

  TBisExecuteFormIface=class(TBisFormIface)
  private
    FAutoStart: Boolean;
    FAutoStartTime: Integer;
    FAutoExit: Boolean;
  protected
    procedure BeforeOptions(AFrame: TBisOptionsFrame); override;
    procedure AfterOptions(AFrame: TBisOptionsFrame); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadOptions; override;
    procedure SaveOptions; override;
    procedure BeforeFormShow; override;

  end;

var
  BisExecuteForm: TBisExecuteForm;

implementation

{$R *.dfm}

uses
     BisUtils, BisExecuteOptionsFrm;

{ TBisExecuteFormIface }

constructor TBisExecuteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisExecuteForm;
  OptionsFrameClass:=TBisExecuteOptionsFrame;
  ShowType:=stMdiChild;
end;

destructor TBisExecuteFormIface.Destroy;
begin
  inherited Destroy;
end;

procedure TBisExecuteFormIface.Init;
begin
  inherited Init;
end;

procedure TBisExecuteFormIface.LoadOptions;
begin
  inherited LoadOptions;
  FAutoStart:=ProfileRead('AutoStart',FAutoStart);
  FAutoStartTime:=ProfileRead('AutoStartTime',FAutoStartTime);
  FAutoExit:=ProfileRead('AutoExit',FAutoExit);
end;

procedure TBisExecuteFormIface.SaveOptions;
begin
  ProfileWrite('AutoStart',FAutoStart);
  ProfileWrite('AutoStartTime',FAutoStartTime);
  ProfileWrite('AutoExit',FAutoExit);
  inherited SaveOptions;
end;

procedure TBisExecuteFormIface.BeforeOptions(AFrame: TBisOptionsFrame);
begin
  inherited BeforeOptions(AFrame);
  if Assigned(AFrame) then begin
    with TBisExecuteOptionsFrame(AFrame) do begin
      CheckBoxAutoStart.Checked:=FAutoStart;
      UpDownAutoStart.Position:=FAutoStartTime;
      CheckBoxAutoExit.Checked:=FAutoExit;
    end;
  end;
end;

procedure TBisExecuteFormIface.AfterOptions(AFrame: TBisOptionsFrame);
var
  Form: TBisExecuteForm;
begin
  if Assigned(AFrame) then begin
    with TBisExecuteOptionsFrame(AFrame) do begin
      FAutoStart:=CheckBoxAutoStart.Checked;
      FAutoStartTime:=UpDownAutoStart.Position;
      FAutoExit:=CheckBoxAutoExit.Checked;
    end;
    if Assigned(ActiveForm) then begin
      Form:=TBisExecuteForm(ActiveForm);
      Form.Timer.Enabled:=FAutoStart;
      Form.FAutoStartTime:=FAutoStartTime;
      Form.FAutoExit:=FAutoExit;
      Form.UpdateStartCaption(FAutoStart);
    end;
  end;
  inherited AfterOptions(AFrame);
end;

procedure TBisExecuteFormIface.BeforeFormShow;
var
  Form: TBisExecuteForm;
begin
  inherited BeforeFormShow;
  Form:=TBisExecuteForm(LastForm);
  if Assigned(Form) then begin
    Form.Timer.Enabled:=FAutoStart;
    Form.FAutoStartTime:=FAutoStartTime;
    Form.FAutoExit:=FAutoExit;
    Form.UpdateStartCaption(FAutoStart);
  end;
end;

{ TBisExecuteForm }

constructor TBisExecuteForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;

  FSizeGrip:=TBisSizeGrip.Create(Self);
  FSizeGrip.Parent:=PanelButtons;
  FSizeGrip.Visible:=true;

  FThread:=TBisExecuteFormThread.Create;
  FThread.OnWork:=ThreadWork;
  FThread.OnEnd:=ThreadEnd;

  FTimerTime:=0;
end;

destructor TBisExecuteForm.Destroy;
begin
  Stop;
  FThread.Free;
  FSizeGrip.Free;
  inherited Destroy;
end;

procedure TBisExecuteForm.Init;
begin
  inherited Init;
  FStartCaption:=BitBtnStart.Caption;
end;

procedure TBisExecuteForm.UpdateStartCaption(WithWait: Boolean);
begin
  if WithWait then
    BitBtnStart.Caption:=FormatEx('%s (%d)',[FStartCaption,FAutoStartTime-FTimerTime])
  else BitBtnStart.Caption:=FStartCaption;
  BitBtnStart.Update;
end;

procedure TBisExecuteForm.TimerTimer(Sender: TObject);
var
  Flag: Boolean;
begin
  Flag:=true;
  Timer.Enabled:=false;
  try
    Flag:=FTimerTime>=FAutoStartTime;
    if Flag then
      Start
    else begin
      Inc(FTimerTime);
      UpdateStartCaption(true);
    end;
  finally
    Timer.Enabled:=not Flag;
  end;
end;

procedure TBisExecuteForm.ActionOptionsExecute(Sender: TObject);
begin
  Options;
end;

procedure TBisExecuteForm.ActionOptionsUpdate(Sender: TObject);
begin
  ActionOptions.Enabled:=CanOptions;
end;

procedure TBisExecuteForm.ActionStartExecute(Sender: TObject);
begin
  Start;
end;

procedure TBisExecuteForm.ActionStartUpdate(Sender: TObject);
begin
  ActionStart.Enabled:=CanStart;
end;

procedure TBisExecuteForm.ActionStopExecute(Sender: TObject);
begin
  Stop;
end;

procedure TBisExecuteForm.ActionStopUpdate(Sender: TObject);
begin
  ActionStop.Enabled:=CanStop;
end;

procedure TBisExecuteForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

function TBisExecuteForm.GetWorking: Boolean;
begin
  Result:=Assigned(FThread);
end;

function TBisExecuteForm.Execute(Thread: TBisExecuteFormThread): Boolean;
begin
  Result:=false;
end;

procedure TBisExecuteForm.ThreadEnd(Thread: TBisThread);
begin
  Thread.Synchronize(DoEnd);
end;

procedure TBisExecuteForm.ThreadWork(Thread: TBisThread);
begin
  FSuccess:=Execute(TBisExecuteFormThread(Thread));
end;

procedure TBisExecuteForm.DoEnd;
begin
  if Assigned(FOnEnd) then
    FOnEnd(Self);

  UpdateStartCaption(false);
  if FSuccess and FAutoExit then
    Close;
end;

function TBisExecuteForm.CanStart: Boolean;
begin
  Result:=FThread.Suspended or not FThread.Working;
end;

procedure TBisExecuteForm.Start;
begin
  Stop;
  if CanStart then begin
    FSuccess:=false;
    Timer.Enabled:=false;
    FThread.Start;
  end;
end;

function TBisExecuteForm.CanStop: Boolean;
begin
  Result:=not FThread.Suspended and FThread.Working;
end;

procedure TBisExecuteForm.Stop;
begin
  if CanStop then
    FThread.Stop;
end;

function TBisExecuteForm.CanOptions: Boolean;
begin
  Result:=inherited CanOptions and not FThread.Working;
end;

end.