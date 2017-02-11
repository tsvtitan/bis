unit BisTaxiDataServiceEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisTaxiDataServiceEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelCost: TLabel;
    EditCost: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataServiceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataServiceFilterFormIface=class(TBisTaxiDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataServiceInsertFormIface=class(TBisTaxiDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataServiceUpdateFormIface=class(TBisTaxiDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataServiceDeleteFormIface=class(TBisTaxiDataServiceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataServiceEditForm: TBisTaxiDataServiceEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataServiceEditFormIface }

constructor TBisTaxiDataServiceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataServiceEditForm;
  with Params do begin
    AddKey('SERVICE_ID').Older('OLD_SERVICE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditFloat('COST','EditCost','LabelCost',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataServiceFilterFormIface }

constructor TBisTaxiDataServiceFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр услуг';
end;

{ TBisTaxiDataServiceInsertFormIface }

constructor TBisTaxiDataServiceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SERVICE';
  Caption:='Создать услугу';
end;

{ TBisTaxiDataServiceUpdateFormIface }

constructor TBisTaxiDataServiceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SERVICE';
  Caption:='Изменить услугу';
end;

{ TBisTaxiDataServiceDeleteFormIface }

constructor TBisTaxiDataServiceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SERVICE';
  Caption:='Удалить услугу';
end;

end.
