unit BisTaxiDataCarTypeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisTaxiDataCarTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    ColorBoxFontColor: TColorBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelFontColor: TLabel;
    LabelRatio: TLabel;
    EditRatio: TEdit;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelBrushColor: TLabel;
    ColorBoxBrushColor: TColorBox;
    LabelCostIdle: TLabel;
    EditCostIdle: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataCarTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarTypeFilterFormIface=class(TBisTaxiDataCarTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarTypeInsertFormIface=class(TBisTaxiDataCarTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarTypeUpdateFormIface=class(TBisTaxiDataCarTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarTypeDeleteFormIface=class(TBisTaxiDataCarTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCarTypeEditForm: TBisTaxiDataCarTypeEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataCarTypeEditFormIface }

constructor TBisTaxiDataCarTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCarTypeEditForm;
  with Params do begin
    AddKey('CAR_TYPE_ID').Older('OLD_CAR_TYPE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddColorBox('FONT_COLOR','ColorBoxFontColor','LabelFontColor');
    AddColorBox('BRUSH_COLOR','ColorBoxBrushColor','LabelBrushColor');
    AddEditFloat('RATIO','EditRatio','LabelRatio',true).Value:=1.0;
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddEditFloat('COST_IDLE','EditCostIdle','LabelCostIdle',true).Value:=0.0;
  end;
end;

{ TBisTaxiDataCarTypeFilterFormIface }

constructor TBisTaxiDataCarTypeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ����� �����������';
end;

{ TBisTaxiDataCarTypeInsertFormIface }

constructor TBisTaxiDataCarTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CAR_TYPE';
  Caption:='������� ��� ����������';
end;

{ TBisTaxiDataCarTypeUpdateFormIface }

constructor TBisTaxiDataCarTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CAR_TYPE';
  Caption:='�������� ��� ����������';
end;

{ TBisTaxiDataCarTypeDeleteFormIface }

constructor TBisTaxiDataCarTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CAR_TYPE';
  Caption:='������� ��� ����������';
end;

end.
