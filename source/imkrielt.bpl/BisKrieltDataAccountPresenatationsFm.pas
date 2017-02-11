unit BisKrieltDataAccountPresenatationsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;
                                                                                                              
type
  TBisKrieltDataAccountPresentationsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataAccountPresentationsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAccountPresentationsForm: TBisKrieltDataAccountPresentationsForm;

implementation

{$R *.dfm}

uses BisKrieltDataAccountPresentationEditFm;

{ TBisKrieltDataAccountPresentationsFormIface }

constructor TBisKrieltDataAccountPresentationsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAccountPresentationsForm;
  FilterClass:=TBisKrieltDataAccountPresentationFilterFormIface;
  InsertClass:=TBisKrieltDataAccountPresentationInsertFormIface;
  UpdateClass:=TBisKrieltDataAccountPresentationUpdateFormIface;
  DeleteClass:=TBisKrieltDataAccountPresentationDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ACCOUNT_PRESENTATIONS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddKey('VIEW_ID');
    AddKey('TYPE_ID');
    AddKey('OPERATION_ID');
    AddKey('PUBLISHING_ID');
    AddInvisible('PRESENTATION_ID');
    AddInvisible('WEEKDAY');
    Add('USER_NAME','Учетная запись (роль)',80);
    Add('PUBLISHING_NAME','Издание',75);
    Add('VIEW_NAME','Вид объектов',100);
    Add('TYPE_NAME','Тип объектов',100);
    Add('OPERATION_NAME','Операция',70);
    Add('PRESENTATION_NAME','Представление',175);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('PUBLISHING_NAME');
  Orders.Add('VIEW_NAME');
  Orders.Add('TYPE_NAME');
  Orders.Add('OPERATION_NAME');
  Orders.Add('PRESENTATION_NAME');
end;

end.
