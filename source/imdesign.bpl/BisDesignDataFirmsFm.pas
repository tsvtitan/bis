unit BisDesignDataFirmsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                   
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataTreeFm, BisDataGridFm;

type
  TBisDesignDataFirmsForm = class(TBisDataTreeForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataFirmsFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataFirmsForm: TBisDesignDataFirmsForm;

implementation

uses BisDesignDataFirmEditFm;

{$R *.dfm}

{ TBisDesignDataFirmsFormIface }

constructor TBisDesignDataFirmsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataFirmsForm;
  FilterClass:=TBisDesignDataFirmEditFormIface;
  InsertClasses.Add(TBisDesignDataFirmInsertFormIface);
  InsertClasses.Add(TBisDesignDataFirmInsertChildFormIface);
  UpdateClass:=TBisDesignDataFirmUpdateFormIface;
  DeleteClass:=TBisDesignDataFirmDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_FIRMS';
  with FieldNames do begin
    AddKey('FIRM_ID');
    AddParentKey('PARENT_ID');
    AddInvisible('FIRM_TYPE_ID');
    AddInvisible('FIRM_TYPE_NAME');
    AddInvisible('INN');
    AddInvisible('PAYMENT_ACCOUNT');
    AddInvisible('BANK');
    AddInvisible('BIK');
    AddInvisible('CORR_ACCOUNT');
    AddInvisible('FAX');
    AddInvisible('EMAIL');
    AddInvisible('SITE');
    AddInvisible('OKONH');
    AddInvisible('OKPO');
    AddInvisible('KPP');
    AddInvisible('DIRECTOR');
    AddInvisible('ACCOUNTANT');
    AddInvisible('CONTACT_FACE');
    AddInvisible('FULL_NAME');
    AddInvisible('INDEX_LEGAL');
    AddInvisible('STREET_LEGAL_ID');
    AddInvisible('HOUSE_LEGAL');
    AddInvisible('FLAT_LEGAL');
    AddInvisible('INDEX_POST');
    AddInvisible('STREET_POST_ID');
    AddInvisible('HOUSE_POST');
    AddInvisible('FLAT_POST');
    AddInvisible('FIRM_TYPE_NAME');
    AddInvisible('STREET_LEGAL_NAME');
    AddInvisible('STREET_LEGAL_PREFIX');
    AddInvisible('LOCALITY_LEGAL_ID');
    AddInvisible('LOCALITY_LEGAL_NAME');
    AddInvisible('LOCALITY_LEGAL_PREFIX');
    AddInvisible('STREET_POST_NAME');
    AddInvisible('STREET_POST_PREFIX');
    AddInvisible('LOCALITY_POST_ID');
    AddInvisible('LOCALITY_POST_NAME');
    AddInvisible('LOCALITY_POST_PREFIX');
    Add('SMALL_NAME','������� ������������',250);
    Add('PHONE','��������',100);
    Add('PARENT_SMALL_NAME','��������',200);
  end;
end;

end.
