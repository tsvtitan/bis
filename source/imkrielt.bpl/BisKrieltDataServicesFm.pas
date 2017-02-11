unit BisKrieltDataServicesFm;

interface
                                                                                                         
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataServicesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataServicesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataServicesForm: TBisKrieltDataServicesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataServiceEditFm;

{ TBisKrieltDataServicesFormIface }

constructor TBisKrieltDataServicesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataServicesForm;
  InsertClass:=TBisKrieltDataServiceInsertFormIface;
  UpdateClass:=TBisKrieltDataServiceUpdateFormIface;
  DeleteClass:=TBisKrieltDataServiceDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_SERVICES';
  with FieldNames do begin
    AddKey('SERVICE_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','Наименование',250);
    Add('PRIORITY','Порядок',50);
  end;
  Orders.Add('PRIORITY');
end;

end.
