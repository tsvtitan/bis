unit BisMapDataMapObjectEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type                                                                                                       
  TBisMapDataMapObjectEditForm = class(TBisDataEditForm)
    LabelLon: TLabel;
    EditLon: TEdit;
    LabelLat: TLabel;
    EditLat: TEdit;
    LabelStreet: TLabel;
    EditStreet: TEdit;
    ButtonStreet: TButton;
    LabelHouse: TLabel;
    EditHouse: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
  private
  public
    procedure BeforeShow; override;
    function CanShow: Boolean; override;
  end;

  TBisMapDataMapObjectEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapObjectFilterFormIface=class(TBisMapDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapObjectInsertFormIface=class(TBisMapDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapObjectUpdateFormIface=class(TBisMapDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapObjectDeleteFormIface=class(TBisMapDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMapDataMapObjectEditForm: TBisMapDataMapObjectEditForm;

implementation

uses BisCore, BisUtils, BisMapConsts, BisParamEditFloat, BisParamEditDataSelect,
     BisDesignDataStreetsFm;

{$R *.dfm}

{ TBisMapDataMapObjectEditFormIface }

constructor TBisMapDataMapObjectEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMapDataMapObjectEditForm;
  with Params do begin
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('STREET_NAME');
    with AddEditDataSelect('STREET_ID','EditStreet','LabelStreet','ButtonStreet',
                            TBisDesignDataStreetsFormIface,'STREET_PREFIX;STREET_NAME;LOCALITY_PREFIX;LOCALITY_NAME',
                            true,true,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME') do begin
      DataAliasFormat:='%s%s, %s%s';
      Older('OLD_STREET_ID');
    end;
    with AddEdit('HOUSE','EditHouse','LabelHouse',true) do begin
      IsKey:=true;
      Older('OLD_HOUSE');
    end;
    with AddEditFloat('LAT','EditLat','LabelLat',true) do begin
      ParamFormat:='#0.000000000';
      ExcludeModes([emFilter]);
    end;
    with AddEditFloat('LON','EditLon','LabelLon',true) do begin
      ParamFormat:='#0.000000000';
      ExcludeModes([emFilter]);
    end;
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisMapDataMapObjectFilterFormIface }

constructor TBisMapDataMapObjectFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������� �����';
end;

{ TBisMapDataMapObjectInsertFormIface }

constructor TBisMapDataMapObjectInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MAP_OBJECT';
  Caption:='������� ������ �����';
  ParentProviderName:='S_MAP_OBJECTS';
  SMessageSuccess:='������ ����� ������� ������.';
end;

{ TBisMapDataMapObjectUpdateFormIface }

constructor TBisMapDataMapObjectUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MAP_OBJECT';
  Caption:='�������� ������ �����';
end;

{ TBisMapDataMapObjectDeleteFormIface }

constructor TBisMapDataMapObjectDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_MAP_OBJECT';
  Caption:='������� ������ �����';
end;

{ TBisMapDataMapObjectEditForm }

procedure TBisMapDataMapObjectEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    with Provider.Params do begin
      Find('DATE_CREATE').SetNewValue(D);
    end;
  end;
end;

function TBisMapDataMapObjectEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode=emInsert) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('STREET_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

end.