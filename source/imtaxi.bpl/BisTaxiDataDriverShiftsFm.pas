unit BisTaxiDataDriverShiftsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, BisFieldNames, BisDataEditFm;

type
  TBisTaxiDataDriverShiftsFrame=class(TBisDataGridFrame)                                                  
  private
    FGroupToday: String;
    FGroupArchive: String;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FDriverName: Variant;
    FDriverId: Variant;
    FDriverUserName: Variant;
    FDriverPatronymic: Variant;
    FDriverSurname: Variant;
    function GetTimeWork(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;

    property FilterMenuItemToday: TBisDataFrameFilterMenuItem read FFilterMenuItemToday;
    property FilterMenuItemArchive: TBisDataFrameFilterMenuItem read FFilterMenuItemArchive;

    property DriverId: Variant read FDriverId write FDriverId;
    property DriverUserName: Variant read FDriverUserName write FDriverUserName;
    property DriverSurname: Variant read FDriverSurname write FDriverSurname;
    property DriverName: Variant read FDriverName write FDriverName;
    property DriverPatronymic: Variant read FDriverPatronymic write FDriverPatronymic;
  end;

  TBisTaxiDataDriverShiftsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataDriverShiftsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverShiftsForm: TBisTaxiDataDriverShiftsForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisCore, BisFilterGroups, BisParam,
     BisUtils, BisTaxiDataDriverShiftEditFm, BisConsts, BisVariants;

{ TBisTaxiDataDriverShiftsFrame }

constructor TBisTaxiDataDriverShiftsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataDriverShiftFilterFormIface;
  InsertClass:=TBisTaxiDataDriverShiftInsertFormIface;
  UpdateClass:=TBisTaxiDataDriverShiftUpdateFormIface;
  DeleteClass:=TBisTaxiDataDriverShiftDeleteFormIface;
  with Provider do begin
    ProviderName:='S_DRIVER_SHIFTS';
    with FieldNames do begin
      AddKey('SHIFT_ID');
      AddInvisible('DRIVER_ID');
      AddInvisible('CAR_ID');
      AddInvisible('CAR_COLOR');
      AddInvisible('CAR_BRAND');
      AddInvisible('CAR_STATE_NUM');
      AddInvisible('CAR_CALLSIGN');
      Add('DRIVER_USER_NAME','��������',150);
      Add('DATE_BEGIN','���� ������',125);
      Add('DATE_END','���� ���������',125);
      AddCalculate('TIME_WORK','����� ������',GetTimeWork,ftDateTime,0,60).DisplayFormat:='hh:nn:ss';
    end;
    Orders.Add('DATE_BEGIN');
  end;

  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;

  FFilterMenuItemToday:=CreateFilterMenuItem('�� �����');
  FFilterMenuItemToday.Checked:=true;

  FFilterMenuItemArchive:=CreateFilterMenuItem('�����');

  FDriverId:=Null;
end;

function TBisTaxiDataDriverShiftsFrame.GetTimeWork(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDateBegin: TField;
  FieldDateEnd: TField;
begin
  Result:=Null;
  FieldDateBegin:=DataSet.FieldByName('DATE_BEGIN');
  FieldDateEnd:=DataSet.FieldByName('DATE_END');
  if not VarIsNull(FieldDateBegin.Value) then begin
    if not VarIsNull(FieldDateEnd.Value) then
      Result:=FieldDateEnd.AsDateTime-FieldDateBegin.AsDateTime
  end;
end;

procedure TBisTaxiDataDriverShiftsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('DRIVER_USER_NAME').Value:=FDriverUserName;
      Param:=ParamByName('DRIVER_ID');
      Param.Value:=FDriverId;
      if not Param.Empty then
        Param.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

procedure TBisTaxiDataDriverShiftsFrame.OpenRecords;
var
  Group1, Group2: TBisFilterGroup;
  D: TDateTime;
begin

  D:=Core.ServerDate;

  with FFilterMenuItemToday do begin
    Group1:=FilterGroups.Find(FGroupToday);
    if Assigned(Group1) then
      FilterGroups.Remove(Group1);
    Group1:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group1.Filters.Add('DATE_BEGIN',fcGreater,IncDay(D,-1));
    Group1.Filters.Add('DATE_BEGIN',fcEqualLess,D);
  end;

  with FFilterMenuItemArchive do begin
    Group2:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group2.Filters.Add('DATE_BEGIN',fcEqualLess,IncDay(D,-1));
  end;

  inherited OpenRecords;
end;


{ TBisTaxiDataDriverShiftsFormIface }

constructor TBisTaxiDataDriverShiftsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverShiftsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataDriverShiftsForm }

class function TBisTaxiDataDriverShiftsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataDriverShiftsFrame;
end;

end.
