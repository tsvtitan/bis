unit BisCallcTaskManagerFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,
  BisFm, BisCallcTaskFm, BisCallcTaskFrm, BisCallcDealsFrm;

type
  TBisCallcTaskManagerForm = class(TBisCallcTaskForm)
  private
    function GetFrame: TBisCallcDealsFrame;
  protected
    function GetFrameClass: TBisCallcTaskFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Frame: TBisCallcDealsFrame read GetFrame;
  end;

  TBisCallcTaskManagerFormIface=class(TBisCallcTaskFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcTaskManagerForm: TBisCallcTaskManagerForm;

implementation

{$R *.dfm}

{ TBisCallcTaskManagerFormIface }

constructor TBisCallcTaskManagerFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTaskManagerForm;
  Available:=true;
  Permissions.Enabled:=true;
end;

{ TBisCallcTaskManagerForm }

constructor TBisCallcTaskManagerForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UseReadiness:=false;
  Purpose:=3;
  Frame.Purpose:=Purpose;
  Frame.TasksVisible:=false;
end;

function TBisCallcTaskManagerForm.GetFrame: TBisCallcDealsFrame;
begin
  Result:=TBisCallcDealsFrame(inherited Frame);
end;

function TBisCallcTaskManagerForm.GetFrameClass: TBisCallcTaskFrameClass;
begin
  Result:=TBisCallcDealsFrame;
end;

end.
