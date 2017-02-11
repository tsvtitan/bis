unit BisMessDataOperatorsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm, BisDataGridFrm;                                                                                          

type
  TBisMessDataOperatorsFrame=class(TBisDataGridFrame)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOperatorsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOperatorsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataOperatorsForm: TBisMessDataOperatorsForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts, BisFilterGroups,
     BisMessDataOperatorEditFm;

{ TBisMessDataOperatorsFormIface }

constructor TBisMessDataOperatorsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataOperatorsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisMessDataOperatorsFrame }

constructor TBisMessDataOperatorsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisMessDataOperatorFilterFormIface;
  InsertClass:=TBisMessDataOperatorInsertFormIface;
  UpdateClass:=TBisMessDataOperatorUpdateFormIface;
  DeleteClass:=TBisMessDataOperatorDeleteFormIface;
  with Provider do begin
    ProviderName:='S_OPERATORS';
    with FieldNames do begin
      AddKey('OPERATOR_ID');
      AddInvisible('RANGES');
      AddInvisible('ENABLED');
      AddInvisible('PRIORITY');
      AddInvisible('CONVERSIONS');
      Add('NAME','Наименование',100);
      Add('DESCRIPTION','Описание',250);
    end;
  end;

  with CreateFilterMenuItem('Активные') do begin
    FilterGroups.AddVisible.Filters.Add('ENABLED',fcEqual,1);
    Checked:=true;
  end;

  with CreateFilterMenuItem('Заблокированные') do begin
    FilterGroups.AddVisible.Filters.Add('ENABLED',fcEqual,0);
  end;
  
end;
{ TBisMessDataOperatorsForm }

constructor TBisMessDataOperatorsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

class function TBisMessDataOperatorsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisMessDataOperatorsFrame;
end;


end.
