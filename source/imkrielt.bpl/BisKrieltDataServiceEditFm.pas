unit BisKrieltDataServiceEditFm;

interface                                                                                                  

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisKrieltDataServiceEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataServiceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataServiceInsertFormIface=class(TBisKrieltDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataServiceUpdateFormIface=class(TBisKrieltDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataServiceDeleteFormIface=class(TBisKrieltDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataServiceEditForm: TBisKrieltDataServiceEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataServiceEditFormIface }

constructor TBisKrieltDataServiceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataServiceEditForm;
  with Params do begin
    AddKey('SERVICE_ID').Older('OLD_SERVICE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataServiceInsertFormIface }

constructor TBisKrieltDataServiceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SERVICE';
end;

{ TBisKrieltDataServiceUpdateFormIface }

constructor TBisKrieltDataServiceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SERVICE';
end;

{ TBisKrieltDataServiceDeleteFormIface }

constructor TBisKrieltDataServiceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SERVICE';
end;

end.
