unit BisTaxiDataParkEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDataParkEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelMaxCount: TLabel;
    EditMaxCount: TEdit;
    LabelStreet: TLabel;
    EditStreet: TEdit;
    ButtonStreet: TButton;
    LabelHouse: TLabel;
    EditHouse: TEdit;
    LabelDescription: TLabel;
    EditDescription: TEdit;
  private
  public
  end;

  TBisTaxiDataParkEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataParkFilterFormIface=class(TBisTaxiDataParkEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataParkInsertFormIface=class(TBisTaxiDataParkEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataParkUpdateFormIface=class(TBisTaxiDataParkEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataParkDeleteFormIface=class(TBisTaxiDataParkEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataParkEditForm: TBisTaxiDataParkEditForm;

implementation

uses BisUtils, BisTaxiConsts;

{$R *.dfm}

{ TBisTaxiDataParkEditFormIface }

constructor TBisTaxiDataParkEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataParkEditForm;
  with Params do begin
    AddKey('PARK_ID').Older('OLD_PARK_ID');
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('STREET_NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('DESCRIPTION','EditDescription','LabelDescription',true);
    with AddEditDataSelect('STREET_ID','EditStreet','LabelStreet','ButtonStreet',
                            SClassDataStreetsFormIface,'STREET_PREFIX;STREET_NAME;LOCALITY_PREFIX;LOCALITY_NAME',
                            true,false,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME') do begin
      DataAliasFormat:='%s%s, %s%s';
    end;
    AddEdit('HOUSE','EditHouse','LabelHouse',true);
    AddEditInteger('MAX_COUNT','EditMaxCount','LabelMaxCount');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataParkFilterFormIface }

constructor TBisTaxiDataParkFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������';
end;

{ TBisTaxiDataParkInsertFormIface }

constructor TBisTaxiDataParkInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PARK';
  Caption:='������� �������';
end;

{ TBisTaxiDataParkUpdateFormIface }

constructor TBisTaxiDataParkUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PARK';
  Caption:='�������� �������';
end;

{ TBisTaxiDataParkDeleteFormIface }

constructor TBisTaxiDataParkDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PARK';
  Caption:='������� �������';
end;

end.
