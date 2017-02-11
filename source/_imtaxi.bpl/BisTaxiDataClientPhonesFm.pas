unit BisTaxiDataClientPhonesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, BisDataEditFm;

type
  TBisTaxiDataClientPhonesFrame=class(TBisDataGridFrame)
  private
    FClientId: Variant;
    FUserName: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;

    property ClientId: Variant read FClientId write FClientId;
    property UserName: String read FUserName write FUserName; 
  end;

  TBisTaxiDataClientPhonesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataClientPhonesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientPhonesForm: TBisTaxiDataClientPhonesForm;

implementation

uses BisUtils, BisTaxiDataClientPhoneEditFm, BisConsts, BisParam;

{$R *.dfm}

{ TBisTaxiDataClientPhonesFrame }

constructor TBisTaxiDataClientPhonesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataClientPhoneFilterFormIface;
  InsertClass:=TBisTaxiDataClientPhoneInsertFormIface;
  UpdateClass:=TBisTaxiDataClientPhoneUpdateFormIface;
  DeleteClass:=TBisTaxiDataClientPhoneDeleteFormIface;
  with Provider do begin
    ProviderName:='S_CLIENT_PHONES';
    with FieldNames do begin
      AddInvisible('CLIENT_ID').IsKey:=true;
      AddInvisible('METHOD_ID');
      AddInvisible('METHOD_NAME');
      Add('USER_NAME','Клиент',110);
      Add('PHONE','Номер',140).IsKey:=true;
      Add('DESCRIPTION','Описание',250);
    end;
    Orders.Add('USER_NAME');
    Orders.Add('PHONE');
  end;

  FClientId:=Null;
end;

procedure TBisTaxiDataClientPhonesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('USER_NAME').Value:=FUserName;
      Param:=ParamByName('CLIENT_ID');
      Param.Value:=FClientId;
      if not Param.Empty then
        Param.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisTaxiDataClientPhonesFormIface }

constructor TBisTaxiDataClientPhonesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientPhonesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
  ProviderName:='S_CLIENT_PHONES';
end;

{ TBisTaxiDataClientPhonesForm }

class function TBisTaxiDataClientPhonesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataClientPhonesFrame;
end;

end.
