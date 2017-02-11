unit BisMapDataMapRouteEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls, DB,
  BisDataEditFm, BisParam, BisControls, Buttons;

type                                                                                                       
  TBisMapDataMapRouteEditForm = class(TBisDataEditForm)
    LabelDuration: TLabel;
    EditDuration: TEdit;
    LabelDistance: TLabel;
    EditDistance: TEdit;
    LabelFromStreet: TLabel;
    EditFromStreet: TEdit;
    ButtonFromStreet: TButton;
    LabelFromHouse: TLabel;
    EditFromHouse: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelToStreet: TLabel;
    LabelToHouse: TLabel;
    EditToStreet: TEdit;
    ButtonToStreet: TButton;
    EditToHouse: TEdit;
    ButtonGet: TBitBtn;
    procedure ButtonGetClick(Sender: TObject);
  private
  public
    procedure BeforeShow; override;
  end;

  TBisMapDataMapRouteEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapRouteFilterFormIface=class(TBisMapDataMapRouteEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapRouteInsertFormIface=class(TBisMapDataMapRouteEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapRouteUpdateFormIface=class(TBisMapDataMapRouteEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMapDataMapRouteDeleteFormIface=class(TBisMapDataMapRouteEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMapDataMapRouteEditForm: TBisMapDataMapRouteEditForm;

implementation

uses BisCore, BisUtils, BisMapConsts, BisParamEditFloat, BisParamEditDataSelect,
     BisProvider,
     BisDesignDataStreetsFm;

{$R *.dfm}

{ TBisMapDataMapRouteEditFormIface }

constructor TBisMapDataMapRouteEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMapDataMapRouteEditForm;
  with Params do begin
    AddInvisible('FROM_LOCALITY_PREFIX');
    AddInvisible('FROM_LOCALITY_NAME');
    AddInvisible('FROM_STREET_PREFIX');
    AddInvisible('FROM_STREET_NAME');

    AddInvisible('TO_LOCALITY_PREFIX');
    AddInvisible('TO_LOCALITY_NAME');
    AddInvisible('TO_STREET_PREFIX');
    AddInvisible('TO_STREET_NAME');

    with AddEditDataSelect('FROM_STREET_ID','EditFromStreet','LabelFromStreet','ButtonFromStreet',
                            TBisDesignDataStreetsFormIface,'FROM_STREET_PREFIX;FROM_STREET_NAME;FROM_LOCALITY_PREFIX;FROM_LOCALITY_NAME',
                            true,true,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME') do begin
      DataAliasFormat:='%s%s, %s%s';
      Older('OLD_FROM_STREET_ID');
    end;
    with AddEdit('FROM_HOUSE','EditFromHouse','LabelFromHouse',true) do begin
      IsKey:=true;
      Older('OLD_FROM_HOUSE');
    end;

    with AddEditDataSelect('TO_STREET_ID','EditToStreet','LabelToStreet','ButtonToStreet',
                            TBisDesignDataStreetsFormIface,'TO_STREET_PREFIX;TO_STREET_NAME;TO_LOCALITY_PREFIX;TO_LOCALITY_NAME',
                            true,true,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME') do begin
      DataAliasFormat:='%s%s, %s%s';
      Older('OLD_TO_STREET_ID');
    end;
    with AddEdit('TO_HOUSE','EditToHouse','LabelToHouse',true) do begin
      IsKey:=true;
      Older('OLD_TO_HOUSE');
    end;

    AddEditInteger('DISTANCE','EditDistance','LabelDistance',false).ExcludeModes([emFilter]);
    AddEditInteger('DURATION','EditDuration','LabelDuration',false).ExcludeModes([emFilter]);
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter]);
  end;
end;

{ TBisMapDataMapRouteFilterFormIface }

constructor TBisMapDataMapRouteFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ��������� �����';
end;

{ TBisMapDataMapRouteInsertFormIface }

constructor TBisMapDataMapRouteInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MAP_ROUTE';
  Caption:='������� ������� �����';
  ParentProviderName:='S_MAP_ROUTES';
  SMessageSuccess:='������� ����� ������� ������.';
end;

{ TBisMapDataMapRouteUpdateFormIface }

constructor TBisMapDataMapRouteUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MAP_ROUTE';
  Caption:='�������� ������� �����';
end;

{ TBisMapDataMapRouteDeleteFormIface }

constructor TBisMapDataMapRouteDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_MAP_ROUTE';
  Caption:='������� ������� �����';
end;

{ TBisMapDataMapRouteEditForm }

procedure TBisMapDataMapRouteEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  ButtonGet.Enabled:=Mode in [emInsert,emUpdate,emDuplicate];
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    with Provider.Params do begin
      Find('DATE_CREATE').SetNewValue(D);
    end;
  end;
end;

procedure TBisMapDataMapRouteEditForm.ButtonGetClick(Sender: TObject);
var
  PFromStreetId,PFromHouse: TBisParam;
  PToStreetId,PToHouse: TBisParam;
  P: TBisProvider;
begin
  PFromStreetId:=Provider.ParamByName('FROM_STREET_ID');
  PFromHouse:=Provider.ParamByName('FROM_HOUSE');
  PToStreetId:=Provider.ParamByName('TO_STREET_ID');
  PToHouse:=Provider.ParamByName('TO_HOUSE');
  if not PFromStreetId.Empty and not PFromHouse.Empty and
     not PToStreetId.Empty and not PToHouse.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='GET_ROUTE_BY_STREETS';
      with P.Params do begin
        AddInvisible('FROM_STREET_ID').Value:=PFromStreetId.Value;
        AddInvisible('FROM_HOUSE').Value:=PFromHouse.Value;
        AddInvisible('TO_STREET_ID').Value:=PToStreetId.Value;
        AddInvisible('TO_HOUSE').Value:=PToHouse.Value;
        AddInvisible('PRIOR_CHECK').Value:=Integer(false);
        AddInvisible('WITH_SAVE').Value:=Integer(false);
        AddInvisible('DISTANCE',ptOutput);
        AddInvisible('DURATION',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        Provider.ParamByName('DISTANCE').Value:=P.ParamByName('DISTANCE').Value;
        Provider.ParamByName('DURATION').Value:=P.ParamByName('DURATION').Value;
      end;
    finally
      P.Free;
    end;
  end;
end;

end.