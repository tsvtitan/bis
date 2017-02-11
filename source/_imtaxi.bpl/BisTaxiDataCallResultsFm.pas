unit BisTaxiDataCallResultsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataCallResultsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataCallResultsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCallResultsForm: TBisTaxiDataCallResultsForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisTaxiDataCallResultEditFm;

{ TBisTaxiDataCallResultsFormIface }

constructor TBisTaxiDataCallResultsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCallResultsForm;
  FilterClass:=TBisTaxiDataCallResultFilterFormIface;
  InsertClass:=TBisTaxiDataCallResultInsertFormIface;
  UpdateClass:=TBisTaxiDataCallResultUpdateFormIface;
  DeleteClass:=TBisTaxiDataCallResultDeleteFormIface;  
  Permissions.Enabled:=true;
  ProviderName:='S_CALL_RESULTS';
  with FieldNames do begin
    AddKey('CALL_RESULT_ID');
    AddInvisible('VISIBLE');
    AddInvisible('PRIORITY');
    Add('NAME','Наименование',150);
    Add('DESCRIPTION','Описание',250);
  end;
  Orders.Add('PRIORITY');
end;

end.
