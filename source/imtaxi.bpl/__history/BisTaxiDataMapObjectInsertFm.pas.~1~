unit BisTaxiDataMapObjectInsertFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls,
  
  BisTaxiDataMapObjectEditFm;

type
  TBisTaxiDataMapObjectInsertForm = class(TBisTaxiDataMapObjectEditForm)
  private
    { Private declarations }
  public
    function CanShow: Boolean; override;
  end;

  TBisTaxiDataMapObjectInsertFormIface=class(TBisTaxiDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;
  
var
  BisTaxiDataMapObjectInsertForm: TBisTaxiDataMapObjectInsertForm;

implementation

uses BisParamEditDataSelect;

{$R *.dfm}

{ TBisTaxiDataMapObjectInsertFormIface }

constructor TBisTaxiDataMapObjectInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataMapObjectInsertForm;
  ProviderName:='I_MAP_OBJECT';
  Caption:='Создать объект карты';
  ParentProviderName:='S_MAP_OBJECTS';
  SMessageSuccess:='Объект карты успешно создан.';
end;

{ TBisTaxiDataMapObjectInsertForm }

function TBisTaxiDataMapObjectInsertForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('STREET_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

end.
