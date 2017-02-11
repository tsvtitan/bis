unit BisDocproHbookViewsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDocproHbookViewsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDocproHbookViewsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookViewsForm: TBisDocproHbookViewsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDocproHbookViewEditFm;

{ TBisDocproHbookViewsFormIface }

constructor TBisDocproHbookViewsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookViewsForm;
  InsertClass:=TBisDocproHbookViewInsertFormIface;
  UpdateClass:=TBisDocproHbookViewUpdateFormIface;
  DeleteClass:=TBisDocproHbookViewDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_VIEWS';
  with FieldNames do begin
    AddKey('VIEW_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',310);
  end;
  Orders.Add('NAME');
end;

end.
