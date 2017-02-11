unit BisTaxiDataZoneEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisTaxiDataZoneEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelCostIn: TLabel;
    EditCostIn: TEdit;
    LabelCostOut: TLabel;
    EditCostOut: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataZoneEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataZoneFilterFormIface=class(TBisTaxiDataZoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataZoneInsertFormIface=class(TBisTaxiDataZoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataZoneUpdateFormIface=class(TBisTaxiDataZoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataZoneDeleteFormIface=class(TBisTaxiDataZoneEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataZoneEditForm: TBisTaxiDataZoneEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataZoneEditFormIface }

constructor TBisTaxiDataZoneEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataZoneEditForm;
  with Params do begin
    AddKey('ZONE_ID').Older('OLD_ZONE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditFloat('COST_IN','EditCostIn','LabelCostIn');
    AddEditFloat('COST_OUT','EditCostOut','LabelCostOut');
  end;
end;

{ TBisTaxiDataZoneFilterFormIface }

constructor TBisTaxiDataZoneFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ���';
end;

{ TBisTaxiDataZoneInsertFormIface }

constructor TBisTaxiDataZoneInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_ZONE';
  Caption:='������� ����';
end;

{ TBisTaxiDataZoneUpdateFormIface }

constructor TBisTaxiDataZoneUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_ZONE';
  Caption:='�������� ����';
end;

{ TBisTaxiDataZoneDeleteFormIface }

constructor TBisTaxiDataZoneDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_ZONE';
  Caption:='������� ����';
end;

end.
