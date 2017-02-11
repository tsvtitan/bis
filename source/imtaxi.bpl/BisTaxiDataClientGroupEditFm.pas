unit BisTaxiDataClientGroupEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs, CheckLst, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataClientGroupEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;                                                                
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisTaxiDataClientGroupEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientGroupViewFormIface=class(TBisTaxiDataClientGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;
  
  TBisTaxiDataClientGroupInsertFormIface=class(TBisTaxiDataClientGroupEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientGroupInsertChildFormIface=class(TBisTaxiDataClientGroupEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientGroupUpdateFormIface=class(TBisTaxiDataClientGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientGroupDeleteFormIface=class(TBisTaxiDataClientGroupEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientGroupEditForm: TBisTaxiDataClientGroupEditForm;

implementation

uses BisTaxiDataClientGroupsFm, BisProvider,
     BisFilterGroups, BisUtils, BisCore;

{$R *.dfm}

{ TBisTaxiDataClientGroupEditFormIface }

constructor TBisTaxiDataClientGroupEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientGroupEditForm;
  with Params do begin
    AddKey('CLIENT_GROUP_ID').Older('OLD_CLIENT_GROUP_ID');
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisTaxiDataClientGroupsFormIface,'PARENT_NAME',false,false,'CLIENT_GROUP_ID','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisTaxiDataClientGroupViewFormIface }

constructor TBisTaxiDataClientGroupViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Просмотр группы';
end;

{ TBisTaxiDataClientGroupInsertFormIface }

constructor TBisTaxiDataClientGroupInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CLIENT_GROUP';
  Caption:='Создать группу';
end;

function TBisTaxiDataClientGroupInsertFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with TBisTaxiDataClientGroupEditForm(Result).Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('PARENT_NAME').Value);
      end;
    end;
  end;
end;

{ TBisTaxiDataClientGroupInsertChildFormIface }

constructor TBisTaxiDataClientGroupInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CLIENT_GROUP';
  Caption:='Создать дочернюю группу';
end;


function TBisTaxiDataClientGroupInsertChildFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with TBisTaxiDataClientGroupEditForm(Result).Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('CLIENT_GROUP_ID').Value);
        Params.ParamByName('PARENT_NAME').SetNewValue(ParentDataSet.FieldByName('NAME').Value);
      end;
    end;
  end;
end;

{ TBisTaxiDataClientGroupUpdateFormIface }

constructor TBisTaxiDataClientGroupUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CLIENT_GROUP';
  Caption:='Изменить группу';
end;

{ TBisTaxiDataClientGroupDeleteFormIface }

constructor TBisTaxiDataClientGroupDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CLIENT_GROUP';
  Caption:='Удалить группу';
end;

{ TBisTaxiDataClientGroupEditForm }

constructor TBisTaxiDataClientGroupEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisTaxiDataClientGroupEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;


end.
