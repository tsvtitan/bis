unit BisDocproHbookPlanViewsIface;

interface

uses Classes,
     BisFm, BisDataGridFm, BisDataFm;

type

  TBisDocproHbookPlanViewsIface=class(TBisDataGridFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses BisFieldNames;

{ TBisDocproHbookPlanViewsIface }

constructor TBisDocproHbookPlanViewsIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Доступные планы';
  ProviderName:='S_PLAN_VIEWS';
  with FieldNames do begin
    AddKey('PLAN_ID').FuncType:=ftDistinct;
    Add('PLAN_NAME','План',150);
    Add('PLAN_DESCRIPTION','Описание',250);
  end;
  Orders.Add('PLAN_NAME');
end;

function TBisDocproHbookPlanViewsIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisDataForm(Result).DataFrame do begin
      ActionExport.Visible:=false;
      ActionFilter.Visible:=false;
      ActionViewing.Visible:=false;
      ActionInsert.Visible:=false;
      ActionDuplicate.Visible:=false;
      ActionUpdate.Visible:=false;
      ActionDelete.Visible:=false;
    end;
  end;
end;

end.
