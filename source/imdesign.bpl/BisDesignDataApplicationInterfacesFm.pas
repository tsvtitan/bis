unit BisDesignDataApplicationInterfacesFm;
                                                                                                                   
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm, BisDataGridFrm, BisDataFrm, BisDataEditFm;

type
  TBisDesignDataApplicationInterfacesFrame=class(TBisDataGridFrame)
  private
    FApplicationId: Variant;
    FApplicationName: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property ApplicationId: Variant read FApplicationId write FApplicationId;
    property ApplicationName: String read FApplicationName write FApplicationName;
  end;

  TBisDesignDataApplicationInterfacesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisDesignDataApplicationInterfacesFormIface=class(TBisDataGridFormIface)
  private
    FApplicationId: Variant;
    FApplicationName: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ApplicationId: Variant read FApplicationId write FApplicationId;
    property ApplicationName: String read FApplicationName write FApplicationName;
  end;

var
  BiDesignDataApplicationInterfacesForm: TBisDesignDataApplicationInterfacesForm;

implementation

{$R *.dfm}

uses BisDesignDataApplicationInterfaceEditFm, BisParam;

{ TBisDesignDataApplicationInterfacesFrame }

procedure TBisDesignDataApplicationInterfacesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=AIface.Params.Find('APPLICATION_ID');
    if Assigned(ParamId) and not VarIsNull(FApplicationId) then begin
      ParamId.Value:=FApplicationId;
      AIface.Params.ParamByName('APPLICATION_NAME').Value:=FApplicationName;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisDesignDataApplicationInterfacesFormIface }

constructor TBisDesignDataApplicationInterfacesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FApplicationId:=Null;
  FormClass:=TBisDesignDataApplicationInterfacesForm;
  FilterClass:=TBisDesignDataApplicationInterfaceEditFormIface;
  InsertClass:=TBisDesignDataApplicationInterfaceInsertFormIface;
  UpdateClass:=TBisDesignDataApplicationInterfaceUpdateFormIface;
  DeleteClass:=TBisDesignDataApplicationInterfaceDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_APPLICATION_INTERFACES';
  with FieldNames do begin
    AddKey('APPLICATION_ID');
    AddKey('ACCOUNT_ID');
    AddKey('INTERFACE_ID');
    Add('APPLICATION_NAME','Приложение',100);
    Add('USER_NAME','Роль (учетная запись)',100);
    Add('INTERFACE_NAME','Интерфейс',250);
    Add('PRIORITY','Порядок выполнения',50);
    AddCheckBox('AUTO_RUN','Автозапуск',50);
  end;
  Orders.Add('APPLICATION_NAME');
  Orders.Add('USER_NAME');
  Orders.Add('PRIORITY');
end;

function TBisDesignDataApplicationInterfacesFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisDesignDataApplicationInterfacesForm(Result) do begin
      TBisDesignDataApplicationInterfacesFrame(DataFrame).ApplicationId:=FApplicationId;
      TBisDesignDataApplicationInterfacesFrame(DataFrame).ApplicationName:=FApplicationName;
    end;
  end;
end;

{ TBisDesignDataApplicationInterfacesForm }

class function TBisDesignDataApplicationInterfacesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataApplicationInterfacesFrame;
end;

end.
