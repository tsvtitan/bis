unit BisDesignDataPermissionsFm;

interface

uses                                                                                                           
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataFrm, BisDataGridFrm, BisDataGridFm, BisDataEditFm;

type
  TBisDesignDataPermissionsFrame=class(TBisDataGridFrame)
  private
    FInterfaceId: Variant;
    FInterfaceName: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property InterfaceId: Variant read FInterfaceId write FInterfaceId;
    property InterfaceName: String read FInterfaceName write FInterfaceName;
  end;

  TBisDesignDataPermissionsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisDesignDataPermissionsFormIface=class(TBisDataGridFormIface)
  private
    FInterfaceId: Variant;
    FInterfaceName: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property InterfaceId: Variant read FInterfaceId write FInterfaceId;
    property InterfaceName: String read FInterfaceName write FInterfaceName;
  end;

var
  BiDesignDataPermissionsForm: TBisDesignDataPermissionsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisParam, BisDesignDataPermissionEditFm;

{ TBisDesignDataPermissionsFrame }

procedure TBisDesignDataPermissionsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=AIface.Params.Find('INTERFACE_ID');
    if Assigned(ParamId) and not VarIsNull(FInterfaceId) then begin
      ParamId.Value:=FInterfaceId;
      AIface.Params.ParamByName('INTERFACE_NAME').Value:=FInterfaceName;
      ParamId.ExcludeModes(AllParamEditModes);
      if (AIface is TBisDesignDataPermissionEditFormIface) then
        TBisDesignDataPermissionEditFormIface(AIface).ChangeInterfaceId:=true;
    end;
  end;
end;

{ TBisDesignDataPermissionsFormIface }

constructor TBisDesignDataPermissionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterfaceId:=Null;
  FormClass:=TBisDesignDataPermissionsForm;
  FilterClass:=TBisDesignDataPermissionEditFormIface;
  InsertClass:=TBisDesignDataPermissionInsertFormIface;
  UpdateClass:=TBisDesignDataPermissionUpdateFormIface;
  DeleteClass:=TBisDesignDataPermissionDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_PERMISSIONS';
  with FieldNames do begin
    AddKey('PERMISSION_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('INTERFACE_ID');
    Add('USER_NAME','���� (������� ������)',100);
    Add('INTERFACE_NAME','���������',200);
    Add('RIGHT_ACCESS','�����',100);
    Add('VALUE','��������',100);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('INTERFACE_NAME');
  Orders.Add('RIGHT_ACCESS');
end;

function TBisDesignDataPermissionsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisDesignDataPermissionsForm(Result) do begin
      TBisDesignDataPermissionsFrame(DataFrame).InterfaceId:=FInterfaceId;
      TBisDesignDataPermissionsFrame(DataFrame).InterfaceName:=FInterfaceName;
    end;
  end;
end;

{ TBisDesignDataPermissionsForm }

class function TBisDesignDataPermissionsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataPermissionsFrame;
end;

end.
