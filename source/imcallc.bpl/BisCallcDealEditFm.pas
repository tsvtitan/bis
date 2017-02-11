unit BisCallcDealEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisFm, BisDataEditFm, BisCallcDealFrm, BisControls, ImgList;

type
  TBisCallcDealEditForm = class(TBisDataEditForm)
  private
    FFrame: TBisCallcDealFrame;

    procedure FrameDebtorParamsChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
    function ChangesArePresent: Boolean; override;
    function SaveChanges: Boolean; override;
    function CheckParams: Boolean; override;

    property Frame: TBisCallcDealFrame read FFrame;
  end;

  TBisCallcDealEditFormIface=class(TBisDataEditFormIface)
  private
    FActionId: Variant;
    FTaskId: Variant;
    FDealNum: String;
    FDealId: Variant;
    function GetLastForm: TBisCallcDealEditForm;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property DealId: Variant read FDealId write FDealId;
    property DealNum: String read FDealNum write FDealNum;
    property TaskId: Variant read FTaskId write FTaskId;
    property ActionId: Variant read FActionId write FActionId;

    property LastForm: TBisCallcDealEditForm read GetLastForm;
  end;

var
  BisCallcDealEditForm: TBisCallcDealEditForm;

implementation

uses BisParam;

{$R *.dfm}

{ TBisCallcDealEditFormIface }

constructor TBisCallcDealEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcDealEditForm;
  SCaptionUpdate:='�������� ��������� ����';
  SCaptionViewing:='�������� ���������� ����';
end;

function TBisCallcDealEditFormIface.GetLastForm: TBisCallcDealEditForm;
begin
  Result:=TBisCallcDealEditForm(inherited LastForm);
end;

function TBisCallcDealEditFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    with LastForm do begin
      Frame.DealId:=FDealId;
      Frame.DealNum:=FDealNum;
      Frame.TaskId:=FTaskId;
      Frame.ActionId:=FActionId;
    end;
  end;
end;

{ TBisCallcDealEditForm }

constructor TBisCallcDealEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFrame:=TBisCallcDealFrame.Create(nil);
  FFrame.Align:=alClient;
  FFrame.Parent:=PanelControls;
  FFrame.OnDebtorParamsChange:=FrameDebtorParamsChange;
  ClientWidth:=FFrame.Width;
  ClientHeight:=FFrame.Height;
end;

destructor TBisCallcDealEditForm.Destroy;
begin
  FFrame.Free;
  inherited Destroy;
end;

procedure TBisCallcDealEditForm.Init;
begin
  inherited Init;
  FFrame.Init;
end;
                                
procedure TBisCallcDealEditForm.BeforeShow;
begin                                                   
  inherited BeforeShow;
  BorderStyle:=bsSizeable;
  BorderIcons:=BorderIcons-[biMinimize];
  FFrame.BeforeShow;
  FFrame.DebtorEdited:=Mode=emUpdate;
  FFrame.RefreshControls;
end;

function TBisCallcDealEditForm.ChangesArePresent: Boolean;
begin
  Result:=FFrame.ChangesArePresent;
end;

function TBisCallcDealEditForm.CheckParams: Boolean;
begin
  Result:=FFrame.CheckControls;
end;

function TBisCallcDealEditForm.SaveChanges: Boolean;
begin
  FFrame.SaveChanges;
  Result:=true;
end;

procedure TBisCallcDealEditForm.FrameDebtorParamsChange(Sender: TObject);
begin
  UpdateButtonState;
end;


end.