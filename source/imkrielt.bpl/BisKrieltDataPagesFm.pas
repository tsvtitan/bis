unit BisKrieltDataPagesFm;
                                                                                                       
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataPagesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataPagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPagesForm: TBisKrieltDataPagesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataPageEditFm;

{ TBisKrieltDataPagesFormIface }

constructor TBisKrieltDataPagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPagesForm;
  InsertClass:=TBisKrieltDataPageInsertFormIface;
  UpdateClass:=TBisKrieltDataPageUpdateFormIface;
  DeleteClass:=TBisKrieltDataPageDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_PAGES';
  with FieldNames do begin
    AddKey('PAGE_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',250);
    Add('ADDRESS','Адрес',250);
  end;
  Orders.Add('NAME');
end;

end.
