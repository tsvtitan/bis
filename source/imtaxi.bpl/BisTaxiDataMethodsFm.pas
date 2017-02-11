unit BisTaxiDataMethodsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;
                                                                                                       
type
  TBisTaxiDataMethodsForm = class(TBisDataGridForm)
  end;

  TBisTaxiDataMethodsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataMethodsForm: TBisTaxiDataMethodsForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataMethodEditFm, BisConsts;

{ TBisTaxiDataMethodsFormIface }

constructor TBisTaxiDataMethodsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataMethodsForm;
  FilterClass:=TBisTaxiDataMethodFilterFormIface;
  InsertClass:=TBisTaxiDataMethodInsertFormIface;
  UpdateClass:=TBisTaxiDataMethodUpdateFormIface;
  DeleteClass:=TBisTaxiDataMethodDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_METHODS';
  with FieldNames do begin
    AddKey('METHOD_ID');
    AddInvisible('PRIORITY');
    AddInvisible('IN_MESSAGE');
    AddInvisible('IN_QUERY');
    AddInvisible('IN_CALL');
    AddInvisible('OUTGOING');
    AddInvisible('DESCRIPTION');
    AddInvisible('DEST_PORT');
    Add('NAME','Наименование',350);
  end;
  Orders.Add('PRIORITY');
end;

end.
