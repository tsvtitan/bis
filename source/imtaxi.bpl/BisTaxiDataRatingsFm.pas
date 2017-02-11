unit BisTaxiDataRatingsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisTaxiDataRatingsForm = class(TBisDataGridForm)
  end;                                                                                          

  TBisTaxiDataRatingsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataRatingsForm: TBisTaxiDataRatingsForm;

implementation

{$R *.dfm}

uses BisUtils, BisTaxiDataRatingEditFm, BisConsts;

{ TBisTaxiDataRatingsFormIface }

constructor TBisTaxiDataRatingsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataRatingsForm;
  FilterClass:=TBisTaxiDataRatingFilterFormIface;
  InsertClass:=TBisTaxiDataRatingInsertFormIface;
  UpdateClass:=TBisTaxiDataRatingUpdateFormIface;
  DeleteClass:=TBisTaxiDataRatingDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_RATINGS';
  with FieldNames do begin
    AddKey('RATING_ID');
    AddInvisible('PRIORITY');
    AddInvisible('VISIBLE');
    AddInvisible('TYPE_RATING');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',200);
    Add('SCORE','�����',50);
  end;
end;

end.
