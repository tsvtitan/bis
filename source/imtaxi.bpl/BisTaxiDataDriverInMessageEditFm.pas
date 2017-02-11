unit BisTaxiDataDriverInMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, StdCtrls, ComCtrls, ExtCtrls, DB,
  BisParam, BisValues, 
  BisTaxiDataInMessageEditFm, BisControls;

type
  TBisTaxiDataDriverInMessageEditForm = class(TBisTaxiDataInMessageEditForm)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
  end;                                                                                         

  TBisTaxiDataDriverInMessageEditFormIface=class(TBisTaxiDataInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageViewFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageInsertFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageUpdateFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageDeleteFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverInMessageEditForm: TBisTaxiDataDriverInMessageEditForm;

implementation

uses
     BisParamEditDataSelect,
     BisTaxiDataDriversFm;

{$R *.dfm}

{ TBisTaxiDataDriverInMessageEditFormIface }

constructor TBisTaxiDataDriverInMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverInMessageEditForm;
  with Params do begin
    AddInvisible('CAR_CALLSIGN',ptUnknown);
    AddInvisible('CAR_COLOR',ptUnknown);
    AddInvisible('CAR_BRAND',ptUnknown);
    AddInvisible('CAR_STATE_NUM',ptUnknown);
    with TBisParamEditDataSelect(ParamByName('SENDER_ID')) do begin
      DataClass:=TBisTaxiDataDriversFormIface;
      DataName:='SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC';
      Required:=true;
      Alias:='DRIVER_ID';
      DataAlias:='USER_NAME;SURNAME;NAME;PATRONYMIC';
    end;
  end;
end;

{ TBisTaxiDataDriverInMessageViewFormIface }

constructor TBisTaxiDataDriverInMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisTaxiDataInMessageViewFormIface.CreateInited(nil) do begin
    try
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataDriverInMessageInsertFormIface }

constructor TBisTaxiDataDriverInMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisTaxiDataInMessageInsertFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataDriverInMessageUpdateFormIface }

constructor TBisTaxiDataDriverInMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisTaxiDataInMessageUpdateFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataDriverInMessageDeleteFormIface }

constructor TBisTaxiDataDriverInMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisTaxiDataInMessageDeleteFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataDriverInMessageEditForm }

constructor TBisTaxiDataDriverInMessageEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ButtonSender.OnClick:=nil;
end;

procedure TBisTaxiDataDriverInMessageEditForm.ChangeParam(Param: TBisParam);
var
  ParamSender: TBisParamEditDataSelect;
  ParamType: TBisParam;
  V: TBisValue;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'SENDER_NAME') and not Param.Empty then begin
    ParamSender:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
    if Mode in [emInsert] then begin
      if not ParamSender.Empty then begin
        ParamType:=Provider.Params.ParamByName('TYPE_MESSAGE');
        case ParamType.AsInteger of
          0: Provider.Params.ParamByName('CONTACT').Value:=ParamSender.Values.GetValue('PHONE');
        end;
      end;
    end;
    V:=ParamSender.Values.Find('CAR_CALLSIGN');
    if Assigned(V) then Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(V.Value);
    V:=ParamSender.Values.Find('CAR_COLOR');
    if Assigned(V) then Provider.Params.ParamByName('CAR_COLOR').SetNewValue(V.Value);
    V:=ParamSender.Values.Find('CAR_BRAND');
    if Assigned(V) then Provider.Params.ParamByName('CAR_BRAND').SetNewValue(V.Value);
    V:=ParamSender.Values.Find('CAR_STATE_NUM');
    if Assigned(V) then Provider.Params.ParamByName('CAR_STATE_NUM').SetNewValue(V.Value);
  end;

end;

end.
