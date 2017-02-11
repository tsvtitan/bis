unit BisTaxiDataDriverOutMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, StdCtrls, ComCtrls, ExtCtrls, DB,
  BisTaxiDataOutMessageEditFm, BisParam, BisValues, BisControls;

type
  TBisTaxiDataDriverOutMessageEditForm = class(TBisTaxiDataOutMessageEditForm)
  private
    { Private declarations }

  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataDriverOutMessageEditFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageViewFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageInsertFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageUpdateFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverOutMessageDeleteFormIface=class(TBisTaxiDataDriverOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisTaxiDataDriverOutMessageEditForm: TBisTaxiDataDriverOutMessageEditForm;

implementation

uses
     BisParamEditDataSelect,
     BisTaxiDataDriversFm;

{$R *.dfm}

{ TBisTaxiDataDriverOutMessageEditFormIface }

constructor TBisTaxiDataDriverOutMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverOutMessageEditForm;
  with Params do begin
    AddInvisible('CAR_CALLSIGN',ptUnknown);
    AddInvisible('CAR_COLOR',ptUnknown);
    AddInvisible('CAR_BRAND',ptUnknown);
    AddInvisible('CAR_STATE_NUM',ptUnknown);
    with TBisParamEditDataSelect(ParamByName('RECIPIENT_ID')) do begin
      DataClass:=TBisTaxiDataDriversFormIface;
      DataName:='RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC';
      Required:=true;
      Alias:='DRIVER_ID';
      DataAlias:='USER_NAME;SURNAME;NAME;PATRONYMIC';
    end;
  end;
end;

{ TBisTaxiDataDriverOutMessageViewFormIface }

constructor TBisTaxiDataDriverOutMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ���������� ���������';
end;

{ TBisTaxiDataDriverOutMessageInsertFormIface }

constructor TBisTaxiDataDriverOutMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='������� ��������� ���������';
  SMessageSuccess:='��������� ������� �������.';
end;

{ TBisTaxiDataDriverOutMessageUpdateFormIface }

constructor TBisTaxiDataDriverOutMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OUT_MESSAGE';
  Caption:='�������� ��������� ���������';
end;

{ TBisTaxiDataDriverOutMessageDeleteFormIface }

constructor TBisTaxiDataDriverOutMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OUT_MESSAGE';
  Caption:='������� ��������� ���������';
end;


{ TBisTaxiDataDriverOutMessageEditForm }

constructor TBisTaxiDataDriverOutMessageEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonRecipient.OnClick:=nil;
end;

procedure TBisTaxiDataDriverOutMessageEditForm.ChangeParam(Param: TBisParam);
var
  ParamRecipient: TBisParamEditDataSelect;
  ParamType: TBisParam;
  V: TBisValue;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC') and
     not Param.Empty then begin
    ParamRecipient:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    if Mode in [emInsert] then begin
      if not ParamRecipient.Empty then begin
        ParamType:=Provider.Params.ParamByName('TYPE_MESSAGE');
        case ParamType.AsInteger of
          0: Provider.Params.ParamByName('CONTACT').Value:=ParamRecipient.Values.GetValue('PHONE');
        end;
      end;
    end;
    V:=ParamRecipient.Values.Find('CAR_CALLSIGN');
    if Assigned(V) then Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(V.Value);
    V:=ParamRecipient.Values.Find('CAR_COLOR');
    if Assigned(V) then Provider.Params.ParamByName('CAR_COLOR').SetNewValue(V.Value);
    V:=ParamRecipient.Values.Find('CAR_BRAND');
    if Assigned(V) then Provider.Params.ParamByName('CAR_BRAND').SetNewValue(V.Value);
    V:=ParamRecipient.Values.Find('CAR_STATE_NUM');
    if Assigned(V) then Provider.Params.ParamByName('CAR_STATE_NUM').SetNewValue(V.Value);
  end;

end;


end.
