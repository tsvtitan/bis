unit BisWaitFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GIFImg, ExtCtrls, Buttons,

  BisFm;

type
  TBitBtn=class(Buttons.TBitBtn)
  end;

  TBisWaitForm = class(TBisForm)
    LabelStatus: TLabel;
    ImageProcess: TImage;
    ButtonCancel: TBitBtn;
    Timer: TTimer;
    ButtonTimer: TSpeedButton;
    procedure ButtonCancelClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonTimerClick(Sender: TObject);
  private
    FImageProcess: TGIFImage;
    FOnCancel: TNotifyEvent;
    FTimeout: Integer;
    FCounter: Integer;
    function GetAnimate: Boolean;
    procedure SetAnimate(const Value: Boolean);
    procedure UpdateButtonCaption;
    procedure SetButtonPosition;
  protected
    procedure DoCancel; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;

    property Animate: Boolean read GetAnimate write SetAnimate;
    property Timeout: Integer read FTimeout write FTimeout;

    property OnCancel: TNotifyEvent read FOnCancel write FOnCancel;
  end;

var
  BisWaitForm: TBisWaitForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisWaitForm }

constructor TBisWaitForm.Create(AOwner: TComponent);
var
  Stream: TMemoryStream;
begin
  inherited Create(AOwner);

  FImageProcess:=TGIFImage.Create;

  FTimeout:=0;
  FCounter:=0;

  Stream:=TMemoryStream.Create;
  try
    ImageProcess.Picture.Graphic.SaveToStream(Stream);
    Stream.Position:=0;
    ImageProcess.Picture.Graphic:=FImageProcess;
    ImageProcess.Picture.Graphic.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  LabelStatus.Caption:='';

  Animate:=true;
end;


destructor TBisWaitForm.Destroy;
begin
  FImageProcess.Free;
  inherited Destroy;
end;

procedure TBisWaitForm.BeforeShow;
begin
  inherited BeforeShow;
  FCounter:=0;
  Timer.Enabled:=false;
  ButtonTimer.Visible:=false;
  if ButtonCancel.Visible and
     ButtonCancel.Enabled then begin
    FCounter:=FTimeout;
    Timer.Enabled:=FTimeout>0;
    ButtonTimer.Visible:=Timer.Enabled;
    ButtonTimer.Down:=false;
    UpdateButtonCaption;
    SetButtonPosition;
  end;
end;

type
  THackSpeedButton=class(TSpeedButton)
  end;

procedure TBisWaitForm.SetButtonPosition;
var
  L: Integer;
begin
  L:=THackSpeedButton(ButtonTimer).Canvas.TextWidth(IntToStr(FCounter));
  if FCounter=0 then
    ButtonTimer.Width:=22
  else
    ButtonTimer.Width:=22+L+10;
end;

procedure TBisWaitForm.DoCancel;
begin
  if Assigned(FOnCancel) then
    FOnCancel(Self);
end;

function TBisWaitForm.GetAnimate: Boolean;
begin
  Result:=TGIFImage(ImageProcess.Picture.Graphic).Animate;
end;

procedure TBisWaitForm.SetAnimate(const Value: Boolean);
begin
  TGIFImage(ImageProcess.Picture.Graphic).Animate:=Value;
end;

procedure TBisWaitForm.TimerTimer(Sender: TObject);
begin
  Dec(FCounter);
  UpdateButtonCaption;
  if FCounter<=0 then begin
    Timer.Enabled:=false;
    DoCancel;
    Close;
  end;
end;

procedure TBisWaitForm.UpdateButtonCaption;
begin
  if FCounter=0 then
    ButtonTimer.Caption:=''
  else
    ButtonTimer.Caption:=FormatEx('%d',[FCounter]);
end;

procedure TBisWaitForm.ButtonCancelClick(Sender: TObject);
begin
  DoCancel;
end;

procedure TBisWaitForm.ButtonTimerClick(Sender: TObject);
begin
  Timer.Enabled:=not ButtonTimer.Down;
end;

end.