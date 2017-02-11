unit BisKrieltDataParamValueDependEditFm;

interface                                                                                           

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB,
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TBisKrieltDataParamValueDependEditForm = class(TBisDataEditForm)
    LabelWhatValue: TLabel;
    EditWhatValue: TEdit;
    ButtonWhatValue: TButton;
    LabelWhatParam: TLabel;
    EditWhatParam: TEdit;
    ButtonWhatParam: TButton;
    LabelFromParam: TLabel;
    EditFromParam: TEdit;
    ButtonFromParam: TButton;
    LabelFromValue: TLabel;
    EditFromValue: TEdit;
    ButtonFromValue: TButton;
  private
    procedure SetParamValues(ParamValueId, ParamId, ParamName: TBisParam);
  public
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisKrieltDataParamValueDependEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueDependFilterFormIface=class(TBisKrieltDataParamValueDependEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueDependInsertFormIface=class(TBisKrieltDataParamValueDependEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueDependUpdateFormIface=class(TBisKrieltDataParamValueDependEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueDependDeleteFormIface=class(TBisKrieltDataParamValueDependEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataParamValueDependEditForm: TBisKrieltDataParamValueDependEditForm;

implementation

uses BisKrieltDataParamsFm, BisKrieltDataParamValuesFm, BisUtils, BisProvider, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataParamValueDependEditFormIface }

constructor TBisKrieltDataParamValueDependEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataParamValueDependEditForm;
  with Params do begin
    AddEditDataSelect('WHAT_PARAM_VALUE_ID','EditWhatValue','LabelWhatValue','ButtonWhatValue',
                      TBisKrieltDataParamValuesFormIface,'WHAT_PARAM_VALUE_NAME',true,true,'PARAM_VALUE_ID','NAME').Older('OLD_WHAT_PARAM_VALUE_ID');
    AddEditDataSelect('WHAT_PARAM_ID','EditWhatParam','LabelWhatParam','ButtonWhatParam',
                      TBisKrieltDataParamsFormIface,'WHAT_PARAM_NAME',true,false,'PARAM_ID','NAME').ParamType:=ptUnknown;
    AddEditDataSelect('FROM_PARAM_VALUE_ID','EditFromValue','LabelFromValue','ButtonFromValue',
                      TBisKrieltDataParamValuesFormIface,'FROM_PARAM_VALUE_NAME',true,true,'PARAM_VALUE_ID','NAME').Older('OLD_FROM_PARAM_VALUE_ID');
    AddEditDataSelect('FROM_PARAM_ID','EditFromParam','LabelFromParam','ButtonFromParam',
                      TBisKrieltDataParamsFormIface,'FROM_PARAM_NAME',true,false,'PARAM_ID','NAME').ParamType:=ptUnknown;
  end;
end;

{ TBisKrieltDataParamValueDependFilterFormIface }

constructor TBisKrieltDataParamValueDependFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataParamValueDependInsertFormIface }

constructor TBisKrieltDataParamValueDependInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PARAM_VALUE_DEPEND';
end;

{ TBisKrieltDataParamValueDependUpdateFormIface }

constructor TBisKrieltDataParamValueDependUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PARAM_VALUE_DEPEND';
end;

{ TBisKrieltDataParamValueDependDeleteFormIface }

constructor TBisKrieltDataParamValueDependDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PARAM_VALUE_DEPEND';
end;


{ TBisKrieltDataParamValueDependEditForm }

procedure TBisKrieltDataParamValueDependEditForm.BeforeShow;
begin
  inherited BeforeShow;
  ButtonWhatParam.Visible:=Mode in [emFilter];
  ButtonFromParam.Visible:=ButtonWhatParam.Visible;
  if ButtonWhatParam.Visible then begin
    EditWhatValue.ReadOnly:=false;
    EditWhatValue.Color:=clWindow;
    EditWhatParam.ReadOnly:=false;
    EditWhatParam.Color:=clWindow;
    EditFromValue.ReadOnly:=false;
    EditFromValue.Color:=clWindow;
    EditFromParam.ReadOnly:=false;
    EditFromParam.Color:=clWindow;
  end;
end;

procedure TBisKrieltDataParamValueDependEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'WHAT_PARAM_VALUE_ID') and not Param.Empty then begin
    SetParamValues(Param,Param.Find('WHAT_PARAM_ID'),Param.Find('WHAT_PARAM_NAME'));
  end;
  if AnsiSameText(Param.ParamName,'FROM_PARAM_VALUE_ID') and not Param.Empty then begin
    SetParamValues(Param,Param.Find('FROM_PARAM_ID'),Param.Find('FROM_PARAM_NAME'));
  end;
end;

procedure TBisKrieltDataParamValueDependEditForm.SetParamValues(ParamValueId, ParamId, ParamName: TBisParam);
var
  P: TBisProvider;
  OldParamIdChange: TBisParamChangeEvent;
  OldParamNameChange: TBisParamChangeEvent;
begin
  if Assigned(ParamId) and Assigned(ParamName) then begin
    OldParamIdChange:=ParamId.OnChange;
    OldParamNameChange:=ParamName.OnChange;
    P:=TBisProvider.Create(nil);
    try
      ParamId.OnChange:=nil;
      ParamName.OnChange:=nil;
      P.ProviderName:='S_PARAM_VALUES';
      P.FieldNames.AddInvisible('PARAM_ID');
      P.FieldNames.AddInvisible('PARAM_NAME');
      P.FilterGroups.Add.Filters.Add('PARAM_VALUE_ID',fcEqual,ParamValueId.Value);
      P.Open;
      if P.Active and not P.IsEmpty then begin
        ParamId.SetNewValue(P.FieldByName('PARAM_ID').Value);
        ParamName.SetNewValue(P.FieldByName('PARAM_NAME').Value);
      end;
    finally
      P.Free;
      ParamId.OnChange:=OldParamIdChange;
      ParamName.OnChange:=OldParamNameChange;
    end;
  end;
end;

end.
