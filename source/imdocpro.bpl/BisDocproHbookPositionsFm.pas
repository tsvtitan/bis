unit BisDocproHbookPositionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls;

type
  TBisDocproHbookPositionsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookPositionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookPositionsForm: TBisDocproHbookPositionsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDocproHbookPositionEditFm;

{ TBisDocproHbookPositionsFormIface }

constructor TBisDocproHbookPositionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookPositionsForm;
  InsertClass:=TBisDocproHbookPositionInsertFormIface;
  UpdateClass:=TBisDocproHbookPositionUpdateFormIface;
  DeleteClass:=TBisDocproHbookPositionDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_POSITIONS';
  with FieldNames do begin
    AddKey('POSITION_ID');
    AddInvisible('PLAN_ID');
    AddInvisible('VIEW_ID');
    AddInvisible('FIRM_ID');
    Add('PLAN_NAME','����',100);
    Add('VIEW_NAME','��� ���������',200);
    Add('FIRM_SMALL_NAME','�����',160);
    Add('PRIORITY','�������',40);
  end;
  Orders.Add('PLAN_NAME');
  Orders.Add('VIEW_NAME');
  Orders.Add('PRIORITY');
end;

{ TBiDocproHbookPositionsForm }

constructor TBisDocproHbookPositionsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.