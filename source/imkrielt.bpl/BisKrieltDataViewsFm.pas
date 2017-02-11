unit BisKrieltDataViewsFm;

interface                                                                                                  

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm, BisDataFrm;

type
  TBisKrieltDataViewsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisKrieltDataViewsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataViewsForm: TBisKrieltDataViewsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataViewEditFm, BisKrieltDataViewsFrm;

{ TBisKrieltDataViewsFormIface }

constructor TBisKrieltDataViewsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataViewsForm;
  InsertClass:=TBisKrieltDataViewInsertFormIface;
  UpdateClass:=TBisKrieltDataViewUpdateFormIface;
  DeleteClass:=TBisKrieltDataViewDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_VIEWS';
  with FieldNames do begin
    AddKey('VIEW_ID');
    AddInvisible('DESCRIPTION');
    Add('NUM','Номер',50);
    Add('NAME','Наименование',300);
  end;
  Orders.Add('NUM');
end;

{ TBisKrieltDataViewsForm }

class function TBisKrieltDataViewsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataViewsFrame;
end;

end.
