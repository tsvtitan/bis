unit BisKrieltDataBannersFm;

interface

uses                                                                                       
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, DB, BisFm, ActnList,
  BisFieldNames;

type
  TBisKrieltDataBannersForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataBannersFormIface=class(TBisDataGridFormIface)
  private
    function GetBannerTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataBannersForm: TBisKrieltDataBannersForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataBannerEditFm;

{ TBisKrieltDataBannersFormIface }

constructor TBisKrieltDataBannersFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataBannersForm;
  InsertClass:=TBisKrieltDataBannerInsertFormIface;
  UpdateClass:=TBisKrieltDataBannerUpdateFormIface;
  DeleteClass:=TBisKrieltDataBannerDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_BANNERS';
  with FieldNames do begin
    AddKey('BANNER_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('USER_NAME');
    AddInvisible('BANNER_TYPE');
    AddInvisible('DESCRIPTION');
    AddInvisible('COUNTER');
    Add('NAME','������������',200);
    AddCalculate('BANNER_TYPE_NAME','��� �������',GetBannerTypeName,ftString,100,100);
    Add('LINK','������',200);
  end;
  Orders.Add('NAME');
end;

function TBisKrieltDataBannersFormIface.GetBannerTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetBannerTypeByIndex(DataSet.FieldByName('BANNER_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

end.