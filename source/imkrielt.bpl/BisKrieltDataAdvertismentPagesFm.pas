unit BisKrieltDataAdvertismentPagesFm;

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

  TBisKrieltDataAdvertismentPagesFormIface=class(TBisDataGridFormIface)
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPlacementsForm: TBisKrieltDataPlacementsForm;

implementation

{$R *.dfm}

uses BisKrieltDataAdvertismentPageEditFm;

{ TBisKrieltDataAdvertismentPagesFormIface }

constructor TBisKrieltDataAdvertismentPagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAdvertismentPagesForm;
  FilterClass:=TBisKrieltDataAdvertismentPageFilterFormIface;
  InsertClass:=TBisKrieltDataAdvertismentPageInsertFormIface;
  UpdateClass:=TBisKrieltDataAdvertismentPageUpdateFormIface;
  DeleteClass:=TBisKrieltDataAdvertismentPageDeleteFormIface;
  Permissions.Enabled:=true;
  FilterOnShow:=true;
//  Available:=true;
  ProviderName:='S_ADVERTISMENT_PAGES';
  with FieldNames do begin
    AddKey('ADVERTISMENT_ID');
    AddKey('PAGE_ID');
    AddKey('ACCOUNT_ID');
    AddInvisible('WHO_PLACED');
    AddInvisible('WHO_PLACED_NAME');
    AddInvisible('DATE_PLACED');
    AddInvisible('PLACE');
    AddInvisible('DATE_BEGIN');
    AddInvisible('DATE_END');
    AddInvisible('PRIORITY');
    AddInvisible('COUNTER');
    Add('ADVERTISMENT_NAME','�������',200);
    Add('PAGE_NAME','��������',150);
    Add('USER_NAME','������� ������ (����)',100);
    Add('PLACE2','�����',50);
  end;
  Orders.Add('ADVERTISMENT_NAME');
end;

end.