unit BisCallcHbookStatusesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBiCallcHbookStatusesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookStatusesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookStatusesForm: TBiCallcHbookStatusesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookStatusEditFm;

{ TBisCallcHbookStatusesFormIface }

constructor TBisCallcHbookStatusesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookStatusesForm;
  InsertClass:=TBisCallcHbookStatusInsertFormIface;
  UpdateClass:=TBisCallcHbookStatusUpdateFormIface;
  DeleteClass:=TBisCallcHbookStatusDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_STATUSES';
  with FieldNames do begin
    AddKey('STATUS_ID');
    AddInvisible('TABLE_NAME');
    AddInvisible('CONDITION');
    AddInvisible('PRIORITY');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',200);
  end;
  Orders.Add('NAME');
end;

end.