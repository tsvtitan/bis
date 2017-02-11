unit BisCallcTaskOperatorFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  BisFm, BisCallcTaskFm, BisCallcTaskFrm, BisCallcDealFrm;

type
  TBisCallcTaskOperatorForm = class(TBisCallcTaskForm)
  private
    function GetFrame: TBisCallcDealFrame;
  protected
    function GetFrameClass: TBisCallcTaskFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Frame: TBisCallcDealFrame read GetFrame;
  end;

  TBisCallcTaskOperatorFormIface=class(TBisCallcTaskFormIface)
  private
    FSPermissionDebtorEdit: String;
    function GetLastForm: TBisCallcTaskOperatorForm;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;

    property LastForm: TBisCallcTaskOperatorForm read GetLastForm;
  published
    property SPermissionDebtorEdit: String read FSPermissionDebtorEdit write FSPermissionDebtorEdit;
  end;

var
  BisCallcTaskOperatorForm: TBisCallcTaskOperatorForm;

implementation

{$R *.dfm}

{ TBisCallcTaskOperatorFormIface }

constructor TBisCallcTaskOperatorFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTaskOperatorForm;
  Available:=true;
  Permissions.Enabled:=true;
  FSPermissionDebtorEdit:='Изменение анкеты';
end;

function TBisCallcTaskOperatorFormIface.GetLastForm: TBisCallcTaskOperatorForm;
begin
  Result:=TBisCallcTaskOperatorForm(inherited LastForm);
end;

function TBisCallcTaskOperatorFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) and Assigned(LastForm.Frame) then begin
    LastForm.Frame.DebtorEdited:=Permissions.Exists(FSPermissionDebtorEdit);
  end;
end;

procedure TBisCallcTaskOperatorFormIface.Init;
begin
  inherited Init;
  Permissions.AddDefault(FSPermissionDebtorEdit);
end;

{ TBisCallcTaskOperatorForm }

constructor TBisCallcTaskOperatorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  UseReadiness:=false;
  Purpose:=0;
end;

function TBisCallcTaskOperatorForm.GetFrame: TBisCallcDealFrame;
begin
  Result:=TBisCallcDealFrame(inherited Frame);
end;

function TBisCallcTaskOperatorForm.GetFrameClass: TBisCallcTaskFrameClass;
begin
  Result:=TBisCallcDealFrame;
end;

end.
