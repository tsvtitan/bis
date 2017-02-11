unit BisCallcHbookCasesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBiCallcHbookCasesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookCasesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookCasesForm: TBiCallcHbookCasesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookCaseEditFm;

{ TBisCallcHbookCasesFormIface }

constructor TBisCallcHbookCasesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBiCallcHbookCasesForm;
  InsertClass:=TBisCallcHbookCaseInsertFormIface;
  UpdateClass:=TBisCallcHbookCaseUpdateFormIface;
  DeleteClass:=TBisCallcHbookCaseDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_CASES';
  with FieldNames do begin
    AddInvisible('SURNAME_RP');
    AddInvisible('NAME_RP');
    AddInvisible('PATRONYMIC_RP');
    AddInvisible('SURNAME_DP');
    AddInvisible('NAME_DP');
    AddInvisible('PATRONYMIC_DP');
    AddInvisible('SURNAME_VP');
    AddInvisible('NAME_VP');
    AddInvisible('PATRONYMIC_VP');
    AddInvisible('SURNAME_TP');
    AddInvisible('NAME_TP');
    AddInvisible('PATRONYMIC_TP');
    AddInvisible('SURNAME_PP');
    AddInvisible('NAME_PP');
    AddInvisible('PATRONYMIC_PP');
    Add('SURNAME_IP','�������',150).IsKey:=true;
    Add('NAME_IP','���',100).IsKey:=true;
    Add('PATRONYMIC_IP','��������',150).IsKey:=true;
  end;
  Orders.Add('SURNAME_IP');
  Orders.Add('NAME_IP');
  Orders.Add('PATRONYMIC_IP');
end;

end.