unit BisTaxiDataClientDriverEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ComCtrls,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataClientDriverKind=(dkWhite,dkBlack);

  TBisTaxiDataClientDriverEditForm = class(TBisDataEditForm)
    LabelClient: TLabel;
    EditClient: TEdit;
    ButtonClient: TButton;                                                                         
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelDriver: TLabel;
    EditDriver: TEdit;
    ButtonDriver: TButton;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    LabelKind: TLabel;
    ComboBoxKind: TComboBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
  public
    constructor Create(AOwner: TComponent); override;
    function CanShow: Boolean; override;
    procedure BeforeShow; override;
  end;

  TBisTaxiDataClientDriverEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientDriverFilterFormIface=class(TBisTaxiDataClientDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientDriverInsertFormIface=class(TBisTaxiDataClientDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientDriverUpdateFormIface=class(TBisTaxiDataClientDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataClientDriverDeleteFormIface=class(TBisTaxiDataClientDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientDriverEditForm: TBisTaxiDataClientDriverEditForm;

function GetKindNameByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups,
     BisParamEditDataSelect, 
     BisTaxiDataClientsFm, BisTaxiDataDriversFm;

{$R *.dfm}

function GetKindNameByIndex(Index: Integer): String;
begin
  Result:='';
  case TBisTaxiDataClientDriverKind(Index) of
    dkWhite: Result:='�����';
    dkBlack: Result:='������';
  end;
end;

{ TBisTaxiDataClientDriverEditFormIface }

constructor TBisTaxiDataClientDriverEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientDriverEditForm;
  with Params do begin
    AddEditDataSelect('CLIENT_ID','EditClient','LabelClient','ButtonClient',
                      TBisTaxiDataClientsFormIface,'CLIENT_USER_NAME',true,true,'ID').Older('OLD_CLIENT_ID');
    AddEditDataSelect('DRIVER_ID','EditDriver','LabelDriver','ButtonDriver',
                      TBisTaxiDataDriversFormIface,'DRIVER_USER_NAME',true,true,'DRIVER_ID','USER_NAME').Older('OLD_DRIVER_ID');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter]);
    AddComboBox('KIND','ComboBoxKind','LabelKind',true);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
  end;
end;

{ TBisTaxiDataClientDriverFilterFormIface }

constructor TBisTaxiDataClientDriverFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ��������� �������';
end;

{ TBisTaxiDataClientDriverInsertFormIface }

constructor TBisTaxiDataClientDriverInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CLIENT_DRIVER';
  Caption:='������� �������� �������';
end;

{ TBisTaxiDataClientDriverUpdateFormIface }

constructor TBisTaxiDataClientDriverUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CLIENT_DRIVER';
  Caption:='�������� �������� �������';
end;

{ TBisTaxiDataClientDriverDeleteFormIface }

constructor TBisTaxiDataClientDriverDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CLIENT_DRIVER';
  Caption:='������� �������� �������';
end;

{ TBisTaxiDataClientDriverEditForm }


constructor TBisTaxiDataClientDriverEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxKind.Clear;
  for i:=0 to 1 do
    ComboBoxKind.Items.Add(GetKindNameByIndex(i));

end;

procedure TBisTaxiDataClientDriverEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert] then
    Provider.ParamByName('DATE_CREATE').SetNewValue(Core.ServerDate);
end;

function TBisTaxiDataClientDriverEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode in [emInsert]) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('DRIVER_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

end.
