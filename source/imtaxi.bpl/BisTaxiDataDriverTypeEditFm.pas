unit BisTaxiDataDriverTypeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataDriverTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;                                                                                  
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    CheckBoxVisible: TCheckBox;
  private
  public
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataDriverTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverTypeFilterFormIface=class(TBisTaxiDataDriverTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverTypeInsertFormIface=class(TBisTaxiDataDriverTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverTypeUpdateFormIface=class(TBisTaxiDataDriverTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverTypeDeleteFormIface=class(TBisTaxiDataDriverTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverTypeEditForm: TBisTaxiDataDriverTypeEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataDriverTypeEditFormIface }

constructor TBisTaxiDataDriverTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverTypeEditForm;
  with Params do begin
    AddKey('DRIVER_TYPE_ID').Older('OLD_DRIVER_TYPE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible',1);
  end;
end;

{ TBisTaxiDataDriverTypeFilterFormIface }

constructor TBisTaxiDataDriverTypeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр типов водителей';
end;

{ TBisTaxiDataDriverTypeInsertFormIface }

constructor TBisTaxiDataDriverTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DRIVER_TYPE';
  Caption:='Создать тип водителя';
end;

{ TBisTaxiDataDriverTypeUpdateFormIface }

constructor TBisTaxiDataDriverTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DRIVER_TYPE';
  Caption:='Изменить тип водителя';
end;

{ TBisTaxiDataDriverTypeDeleteFormIface }

constructor TBisTaxiDataDriverTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DRIVER_TYPE';
  Caption:='Удалить тип водителя';
end;

{ TBisTaxiDataDRIVEREditForm }

procedure TBisTaxiDataDriverTypeEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

end.
