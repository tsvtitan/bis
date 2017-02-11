unit BisApplication;

interface

uses Classes, Graphics,
     BisCoreObjects, BisObject, BisCmdLine;

type
  TBisApplicationExitMode=(emDefault,emLogOff,emShutdown,emTerminate);
  TBisApplicationExitEvent=procedure(Sender: TObject; const ExitMode: TBisApplicationExitMode) of object;

  TBisApplication=class(TBisCoreObject)
  private
    FID: String;
    FShowMainForm: Boolean;
    FVersion: String;
    FOnExit: TBisApplicationExitEvent;
    procedure SetApplicationTitle;
    procedure SetApplicationDescription;
    procedure SetApplicationVersion;
    procedure SetApplicationIcon;
    procedure SetTitle(const Value: String);
    function GetTitle: String;
    function GetIcon: TIcon;
    procedure SetIcon(const Value: TIcon);
    function GetCmdLine: TBisCmdLine;
  protected
    procedure DoExit(const Mode: TBisApplicationExitMode); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Run; virtual;
    procedure Install; virtual;
    procedure Uninstall; virtual;
    procedure Terminate; virtual;
    procedure FreeTemp; virtual;
    function TempExists: Boolean; virtual;

    property ID: String read FID write FID;
    property Title: String read GetTitle write SetTitle;
    property Version: String read FVersion write FVersion;
    
    property CmdLine: TBisCmdLine read GetCmdLine;
    property Icon: TIcon read GetIcon write SetIcon;
    property ShowMainForm: Boolean read FShowMainForm;

    property OnExit: TBisApplicationExitEvent read FOnExit write FOnExit;
  end;

  TBisApplicationClass=class of TBisApplication;

implementation

uses Windows, Forms, Sysutils,
     BisConsts, BisCore, BisModuleInfo;

{ TBisApplication }

constructor TBisApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowMainForm:=true;
end;

destructor TBisApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TBisApplication.Init;
var
  Buffer: String;
begin
  inherited Init;
  Core.LocalBase.ReadParam(SParamId,FID);
  Buffer:='';
  if Core.LocalBase.ReadParam(SParamName,Buffer) then
    ObjectName:=Buffer;

  SetApplicationTitle;
  SetApplicationDescription;
  FVersion:=Core.ProductVersion;
  SetApplicationVersion;
  SetApplicationIcon;
  if Core.LocalBase.ReadParam(SParamShowMainForm,Buffer) then begin
    FShowMainForm:=Boolean(StrToIntDef(Buffer,1));
  end;
end;

procedure TBisApplication.SetApplicationTitle;
var
  ATitle: String;
begin
  ATitle:='';
  if Core.LocalBase.ReadParam(SParamTitle,ATitle) then begin
    Title:=ATitle;
  end;
end;

procedure TBisApplication.SetApplicationVersion;
var
  AVersion: String;
begin
  AVersion:='';
  if Core.LocalBase.ReadParam(SParamVersion,AVersion) then begin
    FVersion:=AVersion;
  end;
end;

procedure TBisApplication.SetApplicationDescription;
var
  ADescription: String;
begin
  ADescription:='';
  if Core.LocalBase.ReadParam(SParamDescription,ADescription) then begin
    Description:=ADescription;
  end;
end;

procedure TBisApplication.SetApplicationIcon;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    if Core.LocalBase.ReadParam(SParamIcon,Stream) then begin
      Stream.Position:=0;
      if Stream.Size>0 then begin
        Icon.LoadFromStream(Stream);
      end;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TBisApplication.Run;
begin
  Forms.Application.ShowMainForm:=ShowMainForm;
end;

procedure TBisApplication.Install;
begin
end;

procedure TBisApplication.Uninstall;
begin
end;

function TBisApplication.TempExists: Boolean;
begin
  Result:=false;
end;

procedure TBisApplication.Terminate;
begin
end;

procedure TBisApplication.FreeTemp;
begin
end;

function TBisApplication.GetCmdLine: TBisCmdLine;
begin
  Result:=nil;
  if Assigned(Core) then
    Result:=Core.CmdLine;
end;

function TBisApplication.GetIcon: TIcon;
begin
  Result:=Forms.Application.Icon;
end;

procedure TBisApplication.SetIcon(const Value: TIcon);
begin
  if Icon<>Value then begin
    Forms.Application.Icon.Assign(Value);
  end;
end;

function TBisApplication.GetTitle: String;
begin
  Result:=Caption;
end;

procedure TBisApplication.SetTitle(const Value: String);
begin
  if Title<>Value then begin
    Forms.Application.Title:=Value;
    Caption:=Value;
  end;
end;

procedure TBisApplication.DoExit(const Mode: TBisApplicationExitMode);
begin
  if Assigned(FOnExit) then
    FOnExit(Self,Mode);
end;

end.
