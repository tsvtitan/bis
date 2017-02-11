unit BisTaxiDataOperatorEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisTaxiDataOperatorEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxEnabled: TCheckBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    MemoConversions: TMemo;
    MemoRanges: TMemo;
    LabelConversions: TLabel;
    LabelRanges: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataOperatorEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOperatorFilterFormIface=class(TBisTaxiDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOperatorInsertFormIface=class(TBisTaxiDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOperatorUpdateFormIface=class(TBisTaxiDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOperatorDeleteFormIface=class(TBisTaxiDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOperatorEditForm: TBisTaxiDataOperatorEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataOperatorEditFormIface }

constructor TBisTaxiDataOperatorEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOperatorEditForm;
  with Params do begin
    AddKey('OPERATOR_ID').Older('OLD_OPERATOR_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddCheckBox('ENABLED','CheckBoxEnabled');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddMemo('CONVERSIONS','MemoConversions','LabelConversions');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddMemo('RANGES','MemoRanges','LabelRanges',true);
  end;
end;

{ TBisTaxiDataOperatorFilterFormIface }

constructor TBisTaxiDataOperatorFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ���������� �����';
end;

{ TBisTaxiDataOperatorInsertFormIface }

constructor TBisTaxiDataOperatorInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_OPERATOR';
  Caption:='������� ��������� �����';
end;

{ TBisTaxiDataOperatorUpdateFormIface }

constructor TBisTaxiDataOperatorUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OPERATOR';
  Caption:='�������� ��������� �����';
end;

{ TBisTaxiDataOperatorDeleteFormIface }

constructor TBisTaxiDataOperatorDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OPERATOR';
  Caption:='������� ��������� �����';
end;

end.
