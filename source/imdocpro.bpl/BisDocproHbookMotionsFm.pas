unit BisDocproHbookMotionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DBCtrls;

type
  TBisDocproHbookMotionsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocproHbookMotionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDocproHbookMotionsForm: TBisDocproHbookMotionsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDocproHbookMotionEditFm;

{ TBisDocproHbookMotionsFormIface }

constructor TBisDocproHbookMotionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDocproHbookMotionsForm;
  InsertClass:=TBisDocproHbookMotionInsertFormIface;
  UpdateClass:=TBisDocproHbookMotionUpdateFormIface;
  DeleteClass:=TBisDocproHbookMotionDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_MOTIONS';
  with FieldNames do begin
    AddKey('MOTION_ID');
    AddInvisible('POSITION_ID');
    AddInvisible('DOC_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('ACCOUNT_ID');
    Add('POSITION_PRIORITY','�������',40);
    Add('DOC_FULL_NAME','��������',200);
    Add('DATE_ISSUE','���� ��������',110);
    Add('USER_NAME','������������',120);
    Add('DATE_PROCESS','���� ����������',110);
  end;
  Orders.Add('DATE_ISSUE');
  Orders.Add('POSITION_PRIORITY');
end;

{ TBiDocproHbookMotionsForm }

constructor TBisDocproHbookMotionsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.
