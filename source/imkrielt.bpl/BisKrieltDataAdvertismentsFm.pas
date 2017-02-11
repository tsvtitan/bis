unit BisKrieltDataAdvertismentsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, DB, BisFm, ActnList,
  BisFieldNames;

type
  TBisKrieltDataAdvertismentsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataAdvertismentsFormIface=class(TBisDataGridFormIface)
  private
    function GetAdvertismentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataAdvertismentsForm: TBisKrieltDataAdvertismentsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataAdvertismentEditFm;

{ TBisKrieltDataAdvertismentsFormIface }

constructor TBisKrieltDataAdvertismentsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAdvertismentsForm;
  InsertClass:=TBisKrieltDataAdvertismentInsertFormIface;
  UpdateClass:=TBisKrieltDataAdvertismentUpdateFormIface;
  DeleteClass:=TBisKrieltDataAdvertismentDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_ADVERTISMENTS';
  with FieldNames do begin
    AddKey('ADVERTISMENT_ID');
    AddInvisible('SERVICE_ID');
    AddInvisible('SERVICE_NAME');
    AddInvisible('ADVERTISMENT_TYPE');
    AddInvisible('DESCRIPTION');
    AddInvisible('LOCATION');
    Add('NAME','Наименование',200);
    AddCalculate('ADVERTISMENT_TYPE_NAME','Тип рекламы',GetAdvertismentTypeName,ftString,100,100);
    Add('LINK','Ссылка',200);
  end;
  Orders.Add('NAME');
end;

function TBisKrieltDataAdvertismentsFormIface.GetAdvertismentTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetAdvertismentTypeByIndex(DataSet.FieldByName('ADVERTISMENT_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

end.
