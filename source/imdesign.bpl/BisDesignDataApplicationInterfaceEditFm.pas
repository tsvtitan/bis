unit BisDesignDataApplicationInterfaceEditFm;

interface
                                                                                                                  
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisDesignDataApplicationInterfaceEditForm = class(TBisDataEditForm)
    LabelApplication: TLabel;
    EditApplication: TEdit;
    ButtonApplication: TButton;
    LabelInterface: TLabel;
    EditInterface: TEdit;
    ButtonInterface: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    CheckBoxAutoRun: TCheckBox;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    CheckBoxRefresh: TCheckBox;
  private
    { Private declarations }
  public
    procedure Execute; override;
    function CanShow: Boolean; override;
  end;

  TBisDesignDataApplicationInterfaceEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataApplicationInterfaceInsertFormIface=class(TBisDesignDataApplicationInterfaceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataApplicationInterfaceUpdateFormIface=class(TBisDesignDataApplicationInterfaceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataApplicationInterfaceDeleteFormIface=class(TBisDesignDataApplicationInterfaceEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataApplicationInterfaceEditForm: TBisDesignDataApplicationInterfaceEditForm;

implementation

uses BisDesignDataInterfacesFm, BisDesignDataRolesAndAccountsFm, BisDesignDataApplicationsFm,
     BisCore, BisParamEditDataSelect, BisParam;

{$R *.dfm}

{ TBisDesignDataApplicationInterfaceEditFormIface }

constructor TBisDesignDataApplicationInterfaceEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataApplicationInterfaceEditForm;
  with Params do begin
    AddEditDataSelect('APPLICATION_ID','EditApplication','LabelApplication','ButtonApplication',
                      TBisDesignDataApplicationsFormIface,'APPLICATION_NAME',true,true,'','NAME').Older('OLD_APPLICATION_ID');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      TBisDesignDataRolesAndAccountsFormIface,'USER_NAME',true,true).Older('OLD_ACCOUNT_ID');
    AddEditDataSelect('INTERFACE_ID','EditInterface','LabelInterface','ButtonInterface',
                      TBisDesignDataInterfacesFormIface,'INTERFACE_NAME',true,true,'','NAME').Older('OLD_INTERFACE_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddCheckBox('AUTO_RUN','CheckBoxAutoRun');                
  end;
end;

{ TBisDesignDataApplicationInterfaceInsertFormIface }

constructor TBisDesignDataApplicationInterfaceInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_APPLICATION_INTERFACE';
end;

{ TBisDesignDataApplicationInterfaceUpdateFormIface }

constructor TBisDesignDataApplicationInterfaceUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_APPLICATION_INTERFACE';
end;

{ TBisDesignDataApplicationInterfaceDeleteFormIface }

constructor TBisDesignDataApplicationInterfaceDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_APPLICATION_INTERFACE';
end;

{ TBisDesignDataApplicationInterfaceEditForm }

function TBisDesignDataApplicationInterfaceEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode in [emInsert]) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('INTERFACE_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

procedure TBisDesignDataApplicationInterfaceEditForm.Execute;
begin
  inherited Execute;
  if CheckBoxRefresh.Checked then begin
    Core.ReloadInterfaces;
    Core.RefreshContents;
  end;
end;

end.
