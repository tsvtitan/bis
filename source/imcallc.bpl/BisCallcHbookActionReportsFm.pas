unit BisCallcHbookActionReportsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookActionReportsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookActionReportsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookActionReportsForm: TBisCallcHbookActionReportsForm;

implementation

{$R *.dfm}

uses BisCallcHbookActionReportEditFm;

{ TBisCallcHbookActionReportsFormIface }

constructor TBisCallcHbookActionReportsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookActionReportsForm;
  InsertClass:=TBisCallcHbookActionReportInsertFormIface;
  UpdateClass:=TBisCallcHbookActionReportUpdateFormIface;
  DeleteClass:=TBisCallcHbookActionReportDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACTION_REPORTS';
  with FieldNames do begin
    AddKey('ACTION_ID');
    AddKey('REPORT_ID');
    Add('ACTION_NAME','��������',150);
    Add('REPORT_NAME','�����',200);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('ACTION_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('REPORT_NAME');
end;

end.
