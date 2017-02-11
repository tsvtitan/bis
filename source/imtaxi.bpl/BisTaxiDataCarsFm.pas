unit BisTaxiDataCarsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm, BisDataGridFrm, BisDataFrm, BisFilterGroups, BisDataEditFm;

type
  TBisTaxiDataCarsFrame=class(TBisDataGridFrame)
  private
    FCarTypesFilterGroup: TBisFilterGroup;
  protected
    procedure FilterRecordsAfterExecute(AForm: TBisDataEditForm); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenRecords; override;
                                                                                               
  end;

  TBisTaxiDataCarsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;     
  end;

  TBisTaxiDataCarsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCarsForm: TBisTaxiDataCarsForm;

implementation

{$R *.dfm}

uses BisUtils,
     BisTaxiDataCarEditFm, BisValues;

{ TBisTaxiDataCarsFrame }

constructor TBisTaxiDataCarsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCarTypesFilterGroup:=TBisFilterGroup.Create;
  FCarTypesFilterGroup.GroupName:=GetUniqueID;
  FCarTypesFilterGroup.Visible:=false;
end;

destructor TBisTaxiDataCarsFrame.Destroy;
begin
  FCarTypesFilterGroup.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataCarsFrame.FilterRecordsAfterExecute(AForm: TBisDataEditForm);
begin
 if Assigned(AForm) and (AForm is TBisTaxiDataCarEditForm) then begin
    TBisTaxiDataCarEditForm(AForm).Provider.ParamByName('CAR_TYPE_FLAG').Visible:=false;
    FCarTypesFilterGroup.Filters.Clear;
    TBisTaxiDataCarEditForm(AForm).GetCarTypesFilterGroup(FCarTypesFilterGroup);
 end;
 try
   inherited FilterRecordsAfterExecute(AForm);
 finally
   if Assigned(AForm) and (AForm is TBisTaxiDataCarEditForm) then 
     TBisTaxiDataCarEditForm(AForm).Provider.ParamByName('CAR_TYPE_FLAG').Visible:=true;
 end;
end;

procedure TBisTaxiDataCarsFrame.OpenRecords;
var
  Group: TBisFilterGroup;
begin
  Group:=Provider.FilterGroups.Find(FCarTypesFilterGroup.GroupName);
  if Assigned(Group) then
    Provider.FilterGroups.Remove(Group);
  Group:=Provider.FilterGroups.Add;
  Group.CopyFrom(FCarTypesFilterGroup,true);
  inherited OpenRecords;
end;

{ TBisTaxiDataCarsFormIface }

constructor TBisTaxiDataCarsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCarsForm;
  ViewClass:=TBisTaxiDataCarViewFormIface;
  FilterClass:=TBisTaxiDataCarFilterFormIface;
  InsertClass:=TBisTaxiDataCarInsertFormIface;
  UpdateClass:=TBisTaxiDataCarUpdateFormIface;
  DeleteClass:=TBisTaxiDataCarDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_CARS';
  with FieldNames do begin
    AddKey('CAR_ID');
    AddInvisible('CALLSIGN');
    AddInvisible('DESCRIPTION');
    AddInvisible('PTS');
    AddInvisible('PAYLOAD');
    AddInvisible('AMOUNT');
    Add('STATE_NUM','���.�����',80);
    Add('BRAND','��������',160);
    Add('COLOR','����',120);
    Add('YEAR_CREATED','���',40);
  end;
end;

{ TBisTaxiDataCarsForm }

class function TBisTaxiDataCarsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataCarsFrame;
end;

end.
