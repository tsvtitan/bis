unit BisCallDataCallResultsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisCallDataCallResultsForm = class(TBisDataGridForm)
  end;

  TBisCallDataCallResultsFormIface=class(TBisDataGridFormIface)                                 
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallDataCallResultsForm: TBisCallDataCallResultsForm;

implementation

{$R *.dfm}

uses BisUtils, BisConsts,
     BisCallDataCallResultEditFm;

{ TBisCallDataCallResultsFormIface }

constructor TBisCallDataCallResultsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallDataCallResultsForm;
  FilterClass:=TBisCallDataCallResultFilterFormIface;
  InsertClass:=TBisCallDataCallResultInsertFormIface;
  UpdateClass:=TBisCallDataCallResultUpdateFormIface;
  DeleteClass:=TBisCallDataCallResultDeleteFormIface;  
  Permissions.Enabled:=true;
  ProviderName:='S_CALL_RESULTS';
  with FieldNames do begin
    AddKey('CALL_RESULT_ID');
    AddInvisible('VISIBLE');
    AddInvisible('PRIORITY');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',350);
  end;
end;

end.
