unit BisCallcTakeBellFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, StdCtrls, ExtCtrls,
  BisFm, BisDataFrm, BisDataGridFm, BisCallcTakeBellFrm, BisCallcTakeBellFilterFm,
  BisCallcDealEditFm;

type
  TBisCallcTakeBellForm = class(TBisDataGridForm)
  protected
    function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisCallcTakeBellFormIface=class(TBisDataGridFormIface)
  private
    FSPermissionApplyPlan: String;
    FSPermissionApplyGroup: String;
    function CanApplyPlan(Sender: TBisDataFrame): Boolean;
    function CanApplyGroup(Sender: TBisDataFrame): Boolean;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
  published
    property SPermissionApplyPlan: String read FSPermissionApplyPlan write FSPermissionApplyPlan;
    property SPermissionApplyGroup: String read FSPermissionApplyGroup write FSPermissionApplyGroup; 
  end;

var
  BisCallcTakeBellForm: TBisCallcTakeBellForm;

implementation

uses BisCallcConsts;

{$R *.dfm}

{ TBisCallcTakeBellFormIface }

constructor TBisCallcTakeBellFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTakeBellForm;
  Available:=true;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
  ChangeFrameProperties:=false;
  FSPermissionApplyPlan:='���������� �����';
  FSPermissionApplyGroup:='���������� ������';
end;

function TBisCallcTakeBellFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    with TBisCallcTakeBellForm(LastForm) do begin
      TBisCallcTakeBellFrame(DataFrame).OnCanApplyPlan:=CanApplyPlan;
      TBisCallcTakeBellFrame(DataFrame).OnCanApplyGroup:=CanApplyGroup;
    end;
  end;
end;

procedure TBisCallcTakeBellFormIface.Init;
begin
  inherited Init; 
  Permissions.AddDefault(FSPermissionApplyPlan);
  Permissions.AddDefault(FSPermissionApplyGroup);
end;

function TBisCallcTakeBellFormIface.CanApplyPlan(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionApplyPlan);
end;

function TBisCallcTakeBellFormIface.CanApplyGroup(Sender: TBisDataFrame): Boolean;
begin
  Result:=Permissions.Exists(FSPermissionApplyGroup); 
end;


{ TBisCallcTakeBellForm }

constructor TBisCallcTakeBellForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ActiveControl:=TBisCallcTakeBellFrame(DataFrame).EditSurname;
end;

destructor TBisCallcTakeBellForm.Destroy;
begin
  inherited Destroy;
end;

function TBisCallcTakeBellForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisCallcTakeBellFrame;
end;


end.
