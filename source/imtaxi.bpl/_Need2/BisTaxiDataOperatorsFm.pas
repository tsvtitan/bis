unit BisTaxiDataOperatorsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm, BisDataGridFrm;                                                                                          

type
  TBisTaxiDataOperatorsFrame=class(TBisDataGridFrame)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOperatorsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOperatorsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOperatorsForm: TBisTaxiDataOperatorsForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts, BisFilterGroups,
     BisTaxiDataOperatorEditFm;

{ TBisTaxiDataOperatorsFormIface }

constructor TBisTaxiDataOperatorsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOperatorsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataOperatorsFrame }

constructor TBisTaxiDataOperatorsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataOperatorFilterFormIface;
  InsertClass:=TBisTaxiDataOperatorInsertFormIface;
  UpdateClass:=TBisTaxiDataOperatorUpdateFormIface;
  DeleteClass:=TBisTaxiDataOperatorDeleteFormIface;
  with Provider do begin
    ProviderName:='S_OPERATORS';
    with FieldNames do begin
      AddKey('OPERATOR_ID');
      AddInvisible('RANGES');
      AddInvisible('ENABLED');
      AddInvisible('PRIORITY');
      AddInvisible('CONVERSIONS');
      Add('NAME','������������',100);
      Add('DESCRIPTION','��������',250);
    end;
  end;

  with CreateFilterMenuItem('��������') do begin
    FilterGroups.AddVisible.Filters.Add('ENABLED',fcEqual,1);
    Checked:=true;
  end;

  with CreateFilterMenuItem('���������������') do begin
    FilterGroups.AddVisible.Filters.Add('ENABLED',fcEqual,0);
  end;
  
end;
{ TBisTaxiDataOperatorsForm }

constructor TBisTaxiDataOperatorsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

class function TBisTaxiDataOperatorsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataOperatorsFrame;
end;


end.
