unit BisCallcTaskLeaderFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,
  BisCallcTaskFm, BisCallcTaskFrm, BisCallcDealsFrm;

type
  TBisCallcTaskLeaderForm = class(TBisCallcTaskForm)
  private
    function GetFrame: TBisCallcDealsFrame;
  protected
    function GetFrameClass: TBisCallcTaskFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Frame: TBisCallcDealsFrame read GetFrame;
  end;

  TBisCallcTaskLeaderFormIface=class(TBisCallcTaskFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcTaskLeaderForm: TBisCallcTaskLeaderForm;

implementation

{$R *.dfm}

{ TBisCallcTaskLeaderFormIface }

constructor TBisCallcTaskLeaderFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTaskLeaderForm;
  Available:=true;
  Permissions.Enabled:=true;
end;

{ TBisCallcTaskLeaderForm }

constructor TBisCallcTaskLeaderForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UseReadiness:=false;
  Purpose:=2;
  Frame.Purpose:=Purpose;
  Frame.TasksVisible:=true;
end;

function TBisCallcTaskLeaderForm.GetFrame: TBisCallcDealsFrame;
begin
  Result:=TBisCallcDealsFrame(inherited Frame);
end;

function TBisCallcTaskLeaderForm.GetFrameClass: TBisCallcTaskFrameClass;
begin
  Result:=TBisCallcDealsFrame;
end;

end.
