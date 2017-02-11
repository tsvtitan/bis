unit BisSplashFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  BisObject, BisFm, BisPicture;

type
  TBisSplashForm = class(TBisForm)
    Image: TImage;
  private
    FSplashExists: Boolean;
    FMaxInterval: Integer;
  protected
    property SplashExists: Boolean read FSplashExists;
  public
    procedure Init; override;
    function CanShow: Boolean; override;
    procedure Show; override;

    property MaxInterval: Integer read FMaxInterval write FMaxInterval;  
  end;

  TBisSplashFormIface=class(TBisFormIface)
  private
    FEnabled: Boolean;
    FTimer: TTimer;
    procedure TimerOnTimer(Sender: TObject);
  protected
    function CreateForm: TBisForm; override;  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Show; override;
    procedure Init; override;
    function CanShow: Boolean; override;
    procedure Hide; override;
    procedure BringToFront;
  end;

var
  BisSplashForm: TBisSplashForm;

implementation

{$R *.dfm}

uses TypInfo,
     BisConsts, BisLocalBase, BisCore, BisConfig;

{ TBisSplashFormIface }

constructor TBisSplashFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ObjectName:='SplashIface';
  OnlyOneForm:=true;
  FTimer:=TTimer.Create(nil);
  FTimer.Enabled:=false;
  FTimer.OnTimer:=TimerOnTimer;
end;

destructor TBisSplashFormIface.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

procedure TBisSplashFormIface.Init;

  procedure LoadParams(Config: TBisConfig);
  begin
    if Assigned(Config) then begin
      FEnabled:=Config.Read(ObjectName,SEnabled,FEnabled);
      FTimer.Interval:=Config.Read(ObjectName,SSleepTime,SplashSleepTime);
    end;
  end;

var
  Config: TBisConfig;
begin
  inherited Init;
  FormClass:=TBisSplashForm;
  Config:=TBisConfig.Create(Self);
  try
    if Core.LocalBase.ReadToConfig(ObjectName,Config) then
      LoadParams(Config);
//    LoadParams(Core.Config);
  finally
    Config.Free;
  end;
end;

procedure TBisSplashFormIface.Show;
begin
  Caption:=Core.Application.Caption;
  inherited Show;
end;

function TBisSplashFormIface.CanShow: Boolean;
begin
  Result:=inherited CanShow and FEnabled;
  if Result then begin
    Result:=Core.Localbase.ParamExists(SParamSplash);
  end;
end;

procedure TBisSplashFormIface.Hide;
begin
  FTimer.Enabled:=FEnabled;
end;

procedure TBisSplashFormIface.TimerOnTimer(Sender: TObject);
begin
  FTimer.Enabled:=false;
  inherited Hide;
end;

procedure TBisSplashFormIface.BringToFront;
begin
  if Assigned(LastForm) then begin
    LastForm.BringToFront;
    LastForm.FormStyle:=fsStayOnTop;
    LastForm.Update;
  end;
end;

function TBisSplashFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    TBisSplashForm(Result).MaxInterval:=FTimer.Interval;
  end;
end;

{ TBisSplashForm }

procedure TBisSplashForm.Init;
var
  Picture: TBisPicture;
  Stream: TMemoryStream;
begin
  inherited Init;
  Stream:=TMemoryStream.Create;
  Picture:=TBisPicture.Create;
  try
    FSplashExists:=true;
    if Core.LocalBase.ReadParam(SParamSplash,Stream) then begin
      Stream.Position:=0;
      try
        Picture.LoadFromStream(Stream);
        if not Picture.Empty then begin
          ClientWidth:=Picture.Width;
          ClientHeight:=Picture.Height;
          Image.Picture.Graphic:=Picture.Graphic;
          Stream.Position:=0;
          Image.Picture.Graphic.LoadFromStream(Stream);
          Left:=Screen.Width div 2 - Width div 2;
          Top:=Screen.Height div 2 - Height div 2;
        end else
          FSplashExists:=false;
      except
        FSplashExists:=false;
      end;
    end else
      FSplashExists:=false;
  finally
    Picture.Free;
    Stream.Free;
  end;
end;

function TBisSplashForm.CanShow: Boolean;
begin
  Result:=FSplashExists;
end;

procedure TBisSplashForm.Show;
var
  I: Integer;
  Increment: Integer;
  Max: Integer;
begin
  inherited Show;
  Update;
  I:=0;
  Max:=FMaxInterval;
  Increment:=Max div 100;
  if Increment>0 then
    while (I<=Max) do begin
      Application.ProcessMessages;
      Sleep(Increment);
      Inc(I,Increment);
    end;
end;


end.

