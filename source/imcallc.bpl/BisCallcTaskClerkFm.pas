unit BisCallcTaskClerkFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons,
  BisFm, BisCallcTaskFm, BisCallcTaskFrm, BisCallcDealsFrm;

type
  TBisCallcTaskClerkForm = class(TBisCallcTaskForm)
  private
    function GetFrame: TBisCallcDealsFrame;
  protected
    function GetFrameClass: TBisCallcTaskFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Frame: TBisCallcDealsFrame read GetFrame;
  end;

  TBisCallcTaskClerkFormIface=class(TBisCallcTaskFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcTaskClerkForm: TBisCallcTaskClerkForm;

implementation

{$R *.dfm}

{ TBisCallcTaskClerkFormIface }

constructor TBisCallcTaskClerkFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTaskClerkForm;
  Available:=true;
  Permissions.Enabled:=true;
end;

{ TBisCallcTaskClerkForm }

constructor TBisCallcTaskClerkForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UseReadiness:=false;
  Purpose:=1;
  Frame.Purpose:=Purpose;
  Frame.TasksVisible:=false;
end;

function TBisCallcTaskClerkForm.GetFrame: TBisCallcDealsFrame;
begin
  Result:=TBisCallcDealsFrame(inherited Frame);
end;

function TBisCallcTaskClerkForm.GetFrameClass: TBisCallcTaskFrameClass;
begin
  Result:=TBisCallcDealsFrame;
end;

end.
