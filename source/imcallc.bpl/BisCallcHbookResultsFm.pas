unit BisCallcHbookResultsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataTreeFm, StdCtrls, ExtCtrls, ComCtrls, BisDataGridFm, ActnList;

type
  TBisCallcHbookResultsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookResultsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookResultsForm: TBisCallcHbookResultsForm;

implementation

uses BisCallcHbookResultEditFm;

{$R *.dfm}

{ TBisCallcHbookResultsFormIface }

constructor TBisCallcHbookResultsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookResultsForm;
  InsertClass:=TBisCallcHbookResultInsertFormIface;
  UpdateClass:=TBisCallcHbookResultUpdateFormIface;
  DeleteClass:=TBisCallcHbookResultDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_RESULTS';
  with FieldNames do begin
    AddKey('RESULT_ID');
    AddInvisible('ACTION_ID');
    AddInvisible('PERIOD');
    AddInvisible('RESULT_TYPE');
    AddInvisible('CHOICE_DATE');
    AddInvisible('CHOICE_PERFORMER');
    Add('NAME','������������',150);
    Add('ACTION_NAME','��������',150);
    Add('DESCRIPTION','��������',200);
  end;
end;

end.
