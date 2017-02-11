unit BisTaxiDataSourcesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;
                                                                                                          
type
  TBisTaxiDataSourcesForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataSourcesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataSourcesForm: TBisTaxiDataSourcesForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataSourceEditFm, BisConsts;

{ TBisTaxiDataSourcesFormIface }

constructor TBisTaxiDataSourcesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataSourcesForm;
  FilterClass:=TBisTaxiDataSourceFilterFormIface;
  InsertClass:=TBisTaxiDataSourceInsertFormIface;
  UpdateClass:=TBisTaxiDataSourceUpdateFormIface;
  DeleteClass:=TBisTaxiDataSourceDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_SOURCES';
  with FieldNames do begin
    AddKey('SOURCE_ID');
    AddInvisible('PRIORITY');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',320);
    AddCheckBox('VISIBLE','Видимость',30)
  end;
///  Orders.Add('PRIORITY');
end;

end.
