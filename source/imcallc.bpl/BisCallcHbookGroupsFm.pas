unit BisCallcHbookGroupsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls,
  BisDataTreeFm, BisDataGridFm;

type
  TBisCallcHbookGroupsForm = class(TBisDataTreeForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookGroupsFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookGroupsForm: TBisCallcHbookGroupsForm;

implementation

uses BisCallcHbookGroupEditFm;

{$R *.dfm}

{ TBisCallcHbookGroupsFormIface }

constructor TBisCallcHbookGroupsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookGroupsForm;
  InsertClass:=TBisCallcHbookGroupInsertFormIface;
  UpdateClass:=TBisCallcHbookGroupUpdateFormIface;
  DeleteClass:=TBisCallcHbookGroupDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_GROUPS';
  with FieldNames do begin
    AddKey('GROUP_ID');
    AddParentKey('PARENT_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('PATTERN_ID');
    AddInvisible('PATTERN_NAME');
    Add('NAME','Наименование',200);
    Add('PARENT_NAME','Родитель',150);
  end;
end;

{ TBisCallcHbookGroupsForm }

constructor TBisCallcHbookGroupsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

end.
