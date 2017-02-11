unit BisCallcHbookActionResultsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookActionResultsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookActionResultsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookActionResultsForm: TBisCallcHbookActionResultsForm;

implementation

{$R *.dfm}

uses BisCallcHbookActionResultEditFm;

{ TBisCallcHbookActionResultsFormIface }

constructor TBisCallcHbookActionResultsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookActionResultsForm;
  InsertClass:=TBisCallcHbookActionResultInsertFormIface;
  UpdateClass:=TBisCallcHbookActionResultUpdateFormIface;
  DeleteClass:=TBisCallcHbookActionResultDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACTION_RESULTS';
  with FieldNames do begin
    AddKey('ACTION_ID');
    AddKey('RESULT_ID');
    Add('ACTION_NAME','��������',150);
    Add('RESULT_NAME','���������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('ACTION_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('RESULT_NAME');
end;

end.
