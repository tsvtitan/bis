unit BisTaxiDataSourceEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;                                                                         

type
  TBisTaxiDataSourceEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    CheckBoxVisible: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataSourceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSourceFilterFormIface=class(TBisTaxiDataSourceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSourceInsertFormIface=class(TBisTaxiDataSourceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSourceUpdateFormIface=class(TBisTaxiDataSourceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataSourceDeleteFormIface=class(TBisTaxiDataSourceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataSourceEditForm: TBisTaxiDataSourceEditForm;

implementation

{$R *.dfm}

{ TBisTaxiDataSourceEditFormIface }

constructor TBisTaxiDataSourceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataSourceEditForm;
  with Params do begin
    AddKey('SOURCE_ID').Older('OLD_SOURCE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible').Value:=1;
  end;
end;

{ TBisTaxiDataSourceFilterFormIface }

constructor TBisTaxiDataSourceFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр источников';
end;

{ TBisTaxiDataSourceInsertFormIface }

constructor TBisTaxiDataSourceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SOURCE';
  Caption:='Создать источник';
end;

{ TBisTaxiDataSourceUpdateFormIface }

constructor TBisTaxiDataSourceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SOURCE';
  Caption:='Изменить источник';
end;

{ TBisTaxiDataSourceDeleteFormIface }

constructor TBisTaxiDataSourceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SOURCE';
  Caption:='Удалить источник';
end;

end.
