unit BisFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  BisLogger, BisConfig;

type
  TBisFrame = class(TFrame)
  private
    FObjectName: String;
    FCaption: String;
    FTranslateClass: TClass;
  protected
    procedure SetName(const NewName: TComponentName); override;
    class function GetObjectName: String; virtual;
    function GetCaption: String; virtual;
    procedure SetCaption(const Value: String); virtual;
    function GetActiveControl: TWinControl; virtual;
    procedure SetActiveControl(Value: TWinControl); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; virtual;
    procedure BeforeShow; virtual;
    procedure EnableControls(AEnabled: Boolean); virtual;
    function GetParentForm: TForm;

    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation; const LoggerName: String=''); virtual;
    function ConfigRead(const Param: String; Default: Variant; Mode: TBisConfigMode=cmDefault; const Section: String=''): Variant; virtual;
    procedure ConfigWrite(const Param: String; Value: Variant; Mode: TBisConfigMode=cmDefault; const Section: String=''); virtual;
    function ProfileRead(const Param: String; Default: Variant; Mode: TBisConfigMode=cmDefault; const Section: String=''): Variant; virtual;
    procedure ProfileWrite(const Param: String; Value: Variant; Mode: TBisConfigMode=cmDefault; const Section: String=''); virtual;
    procedure Progress(const Min, Max, Position: Integer; var Interrupted: Boolean); virtual;

    property ObjectName: String read FObjectName write FObjectName;
    property TranslateClass: TClass read FTranslateClass write FTranslateClass;
    property ActiveControl: TWinControl read GetActiveControl write SetActiveControl; 
  published
    property Caption: String read GetCaption write SetCaption;

  end;

implementation

{$R *.dfm}

uses BisConsts, BisCore, BisUtils, BisCoreUtils;

{ TBisFrame }

constructor TBisFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FObjectName:=GetObjectName;
  FTranslateClass:=TBisFrame;
  Font.Name:=STahoma;
end;

function TBisFrame.GetCaption: String;
begin
  Result:=FCaption;
end;

procedure TBisFrame.SetName(const NewName: TComponentName);
var
  S: String;
begin
  S:=GetComponentName(NewName,GetObjectName,Owner);
  inherited SetName(S);
end;

class function TBisFrame.GetObjectName: String;
begin
  Result:=GetNameByClass(ClassName);
end;

procedure TBisFrame.Init;
begin
  TranslateObject(Self,FTranslateClass);
end;

procedure TBisFrame.EnableControls(AEnabled: Boolean);
begin
  EnableControl(Self,AEnabled);
end;

procedure TBisFrame.LoggerWrite(const Message: String; LogType: TBisLoggerType;  const LoggerName: String);
var
  S: String;
begin
  if Assigned(Core) and
     Assigned(Core.Logger) then begin
    S:=LoggerName;
    if Trim(S)='' then
      S:=Self.ObjectName;
    Core.Logger.Write(Message,LogType,S);
  end;
end;

procedure TBisFrame.BeforeShow;
begin
  //
end;

function TBisFrame.ConfigRead(const Param: String; Default: Variant; Mode: TBisConfigMode=cmDefault; const Section: String=''): Variant;
var
  S: String;
begin
  if Assigned(Core) and
     Assigned(Core.Config) then begin
    S:=Section;
    if Trim(S)='' then
      S:=Self.ObjectName;
    Result:=Core.Config.Read(S,Param,Default,Mode);
  end;
end;

procedure TBisFrame.ConfigWrite(const Param: String; Value: Variant; Mode: TBisConfigMode=cmDefault; const Section: String='');
var
  S: String;
begin
  if Assigned(Core) and
     Assigned(Core.Config) then begin
    S:=Section;
    if Trim(S)='' then
      S:=Self.ObjectName;
    Core.Config.Write(S,Param,Value,Mode);
  end;
end;

function TBisFrame.GetParentForm: TForm;
var
  AParent: TWinControl;
begin
  Result:=nil;
  AParent:=Parent;
  while Assigned(AParent) do begin
    if AParent is TForm then begin
      Result:=TForm(AParent);
      break;
    end else
      AParent:=AParent.Parent;
  end;
end;

function TBisFrame.GetActiveControl: TWinControl;
var
  Form: TForm;
begin
  Result:=nil;
  Form:=GetParentForm;
  if Assigned(Form) then
    Result:=Form.ActiveControl;
end;

procedure TBisFrame.SetActiveControl(Value: TWinControl);
var
  Form: TForm;
begin
  Form:=GetParentForm;
  if Assigned(Form) then
    Form.ActiveControl:=Value;
end;

function TBisFrame.ProfileRead(const Param: String; Default: Variant; Mode: TBisConfigMode=cmDefault; const Section: String=''): Variant;
var
  S: String;
begin
  if Assigned(Core) and
     Assigned(Core.Profile) then begin
    S:=Section;
    if Trim(S)='' then
      S:=Self.ObjectName;
    Result:=Core.Profile.Read(S,Param,Default,Mode);
  end;
end;

procedure TBisFrame.ProfileWrite(const Param: String; Value: Variant; Mode: TBisConfigMode=cmDefault; const Section: String='');
var
  S: String;
begin
  if Assigned(Core) and
     Assigned(Core.Profile) then begin
    S:=Section;
    if Trim(S)='' then
      S:=Self.ObjectName;
    Core.Profile.Write(S,Param,Value,Mode);
  end;
end;

procedure TBisFrame.Progress(const Min, Max, Position: Integer; var Interrupted: Boolean);
begin
  if Assigned(Core) then
    Core.Progress(Min,Max,Position,Interrupted);
end;

procedure TBisFrame.SetCaption(const Value: String);
begin
  FCaption:=Value;
end;

end.
