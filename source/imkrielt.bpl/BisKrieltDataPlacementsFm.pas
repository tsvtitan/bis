unit BisKrieltDataPlacementsFm;

interface
                                                                                              
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisFieldNames;

type
  TBisKrieltDataPlacementsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataPlacementsFormIface=class(TBisDataGridFormIface)
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPlacementsForm: TBisKrieltDataPlacementsForm;

implementation

{$R *.dfm}

uses BisOrders,
     BisKrieltDataPlacementEditFm;

{ TBisKrieltDataPlacementsFormIface }

constructor TBisKrieltDataPlacementsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPlacementsForm;
  FilterClass:=TBisKrieltDataPlacementFilterFormIface;
  InsertClass:=TBisKrieltDataPlacementInsertFormIface;
  UpdateClass:=TBisKrieltDataPlacementUpdateFormIface;
  DeleteClass:=TBisKrieltDataPlacementDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_PLACEMENTS';
  with FieldNames do begin
    AddKey('PLACEMENT_ID');
    AddInvisible('BANNER_ID');
    AddInvisible('PAGE_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('WHO_PLACED');
    AddInvisible('WHO_PLACED_NAME');
    AddInvisible('DATE_PLACED');
    AddInvisible('PLACE');
    AddInvisible('DATE_BEGIN');
    AddInvisible('DATE_END');
    AddInvisible('PRIORITY');
    AddInvisible('COUNTER');
    AddInvisible('RESTRICTED');
    Add('BANNER_NAME','Баннер',200);
    Add('PAGE_NAME','Страница',150);
    Add('USER_NAME','Учетная запись (роль)',100);
    Add('PLACE','Место',50);
  end;
  Orders.Add('DATE_BEGIN',otDesc);
end;

end.
