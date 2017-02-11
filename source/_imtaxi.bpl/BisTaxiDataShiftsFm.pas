unit BisTaxiDataShiftsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataFrm, BisDataGridFrm, BisDataGridFm;

type
  TBisTaxiDataShiftsFrame=class(TBisDataGridFrame)
  end;

  TBisTaxiDataShiftsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataShiftsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataShiftsForm: TBisTaxiDataShiftsForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisCore, BisFilterGroups,
     BisUtils, BisTaxiDataShiftEditFm, BisConsts, BisVariants;

{ TBisTaxiDataShiftsFormIface }

constructor TBisTaxiDataShiftsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataShiftsForm;
  FilterClass:=TBisTaxiDataShiftFilterFormIface;
  InsertClass:=TBisTaxiDataShiftInsertFormIface;
  UpdateClass:=TBisTaxiDataShiftUpdateFormIface;
  DeleteClass:=TBisTaxiDataShiftDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_SHIFTS';
  with FieldNames do begin
    AddKey('SHIFT_ID');
    AddInvisible('ACCOUNT_ID');
    Add('USER_NAME','������� ������',150);
    Add('DATE_BEGIN','���� ������',125);
    Add('DATE_END','���� ���������',125);
  end;
  Orders.Add('DATE_BEGIN');
end;

{ TBisTaxiDataShiftsForm }

constructor TBisTaxiDataShiftsForm.Create(AOwner: TComponent);
var
  D: TDateTime;
begin
  inherited Create(AOwner);

  if Assigned(DataFrame) then begin

    D:=Core.ServerDate;

    with DataFrame.CreateFilterMenuItem('�������') do begin
      with FilterGroups.AddVisible do begin
        Filters.Add('DATE_BEGIN',fcEqualGreater,DateOf(D));
        Filters.Add('DATE_BEGIN',fcLess,IncDay(DateOf(D)));
      end;
      Checked:=true;
    end;

    with DataFrame.CreateFilterMenuItem('�����') do begin
      FilterGroups.AddVisible.Filters.Add('DATE_BEGIN',fcLess,DateOf(D));
    end;

  end;
  
end;

class function TBisTaxiDataShiftsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataShiftsFrame;
end;

end.
