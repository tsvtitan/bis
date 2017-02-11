unit BisKrieltDataExportsFm;

interface
                                                                                               
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BIsFieldNames, BisDataGridFm, BisDataTreeFm;

type
  TBisKrieltDataExportsForm = class(TBisDataTreeForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataExportsFormIface=class(TBisDataTreeFormIface)
  private
    function GetHeadExists(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetBodyExists(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataExportsForm: TBisKrieltDataExportsForm;

implementation

uses BisKrieltDataExportEditFm;

{$R *.dfm}

{ TBisKrieltDataExportsFormIface }

constructor TBisKrieltDataExportsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataExportsForm;
  FilterClass:=TBisKrieltDataExportEditFormIface;
  InsertClasses.Add(TBisKrieltDataExportInsertFormIface);
  InsertClasses.Add(TBisKrieltDataExportInsertChildFormIface);
  UpdateClass:=TBisKrieltDataExportUpdateFormIface;
  DeleteClass:=TBisKrieltDataExportDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_EXPORTS';
  with FieldNames do begin
    AddKey('EXPORT_ID');
    AddParentKey('PARENT_ID');
    AddInvisible('VIEW_ID');
    AddInvisible('VIEW_NAME');
    AddInvisible('VIEW_NUM');
    AddInvisible('TYPE_ID');
    AddInvisible('TYPE_NAME');
    AddInvisible('TYPE_NUM');
    AddInvisible('OPERATION_ID');
    AddInvisible('OPERATION_NAME');
    AddInvisible('OPERATION_NUM');
    AddInvisible('PARAM_ID');
    AddInvisible('PARAM_NAME');
    AddInvisible('DESCRIPTION');
    AddInvisible('EXPORT');
    AddInvisible('PRIORITY');
    AddInvisible('COND');
    AddInvisible('VALUE');
    AddInvisible('HEAD_RTF');
    AddInvisible('BODY_RTF');
    AddInvisible('SORTING');
    Add('NAME','������������',230);
    Add('PARENT_NAME','��������',175);
    AddCheckBox('DISABLED','��������',30);
    with AddCheckBox('HEAD_EXISTS','���������',30) do begin
      OnCalculate:=GetHeadExists;
      DataType:=ftInteger;
    end;
    with AddCheckBox('BODY_EXISTS','����',30) do begin
      OnCalculate:=GetBodyExists;
      DataType:=ftInteger;
    end;
  end;
  Orders.Add('LEVEL');
  Orders.Add('PRIORITY');
end;

function TBisKrieltDataExportsFormIface.GetBodyExists(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
begin
  Result:=Null;
  if DataSet.Active then begin
    Result:=Integer(Trim(DataSet.FieldByName('BODY_RTF').AsString)<>'');
  end;
end;

function TBisKrieltDataExportsFormIface.GetHeadExists(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
begin
  Result:=Null;
  if DataSet.Active then begin
    Result:=Integer(Trim(DataSet.FieldByName('HEAD_RTF').AsString)<>'');
  end;
end;

end.
