unit BisKrieltObjectParamEditFm;

interface
                                                                                                     
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam,
  BisKrieltObjectParamFrm,
  BisControls;

type
  TBisKrieltObjectParamEditForm = class(TBisDataEditForm)
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    GroupBoxValue: TGroupBox;
    PanelFrame: TPanel;
    LabelExport: TLabel;
    EditExport: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
  private
    FFrame: TBisKrieltObjectParamFrame;
    FBeforeShowed: Boolean;
    procedure FrameChange(Sender: TObject);
    procedure SetExportDescription(AEnabled: Boolean); 
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltObjectParamEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectParamInsertFormIface=class(TBisKrieltObjectParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectParamUpdateFormIface=class(TBisKrieltObjectParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltObjectParamDeleteFormIface=class(TBisKrieltObjectParamEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltObjectParamEditForm: TBisKrieltObjectParamEditForm;

implementation

uses Dateutils,
     BisCore, BisUtils, BisFilterGroups, BisParamEditDataSelect, 
     BisKrieltDataParamsFm, BisKrieltDataParamEditFm,
     BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltObjectParamEditFormIface }

constructor TBisKrieltObjectParamEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltObjectParamEditForm;
  with Params do begin
    AddKey('OBJECT_PARAM_ID').Older('OLD_OBJECT_PARAM_ID');
    AddInvisible('OBJECT_ID');
    AddInvisible('PARAM_TYPE');
    AddInvisible('PARAM_SORTING');
    AddInvisible('PARAM_MAX_LENGTH');
    AddInvisible('VALUE_STRING');
    AddInvisible('VALUE_NUMBER');
    AddInvisible('VALUE_DATE');
    AddInvisible('VALUE_BLOB');

    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,false,'','NAME');

    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('EXPORT','EditExport','LabelExport');

    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataAccountsFormIface,'USER_NAME',true);
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter]);
  end;
end;

{ TBisKrieltObjectParamInsertFormIface }

constructor TBisKrieltObjectParamInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_OBJECT_PARAM';
  Caption:='������� ��������';
end;

{ TBisKrieltObjectParamUpdateFormIface }

constructor TBisKrieltObjectParamUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OBJECT_PARAM';
  Caption:='�������� ��������';
end;

{ TBisKrieltObjectParamDeleteFormIface }

constructor TBisKrieltObjectParamDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OBJECT_PARAM';
  Caption:='������� ��������';
end;

{ TBisKrieltObjectParamEditForm }

constructor TBisKrieltObjectParamEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFrame:=TBisKrieltObjectParamFrame.Create(nil);
  FFrame.Align:=alClient;
  FFrame.Parent:=PanelFrame;
  FFrame.OnChange:=FrameChange;
end;

destructor TBisKrieltObjectParamEditForm.Destroy;
begin
  FFrame.Free;
  inherited Destroy;
end;

procedure TBisKrieltObjectParamEditForm.Init;
begin
  inherited Init;
  FFrame.Init;
end;

procedure TBisKrieltObjectParamEditForm.SetExportDescription(AEnabled: Boolean);
var
  NEnabled: Boolean;
begin
  NEnabled:=AEnabled and (Mode<>emDelete);
  Provider.ParamByName('EXPORT').Enabled:=NEnabled;
  Provider.ParamByName('DESCRIPTION').Enabled:=NEnabled;
end;

procedure TBisKrieltObjectParamEditForm.ChangeParam(Param: TBisParam);
var
  ParamId: TBisParamEditDataSelect;
begin
  inherited ChangeParam(Param);

  if FBeforeShowed and
     (Mode in [emDuplicate,emDuplicate,emUpdate,emDelete]) and
     AnsiSameText(Param.ParamName,'PARAM_NAME') then begin
    ParamId:=TBisParamEditDataSelect(Provider.ParamByName('PARAM_ID'));
    if ParamId.Empty then begin
      FFrame.ParamId:=Null;
      FFrame.ParamSorting:=dpsNone;
      FFrame.ParamType:=dptList;
      FFrame.ParamMaxLength:=0;
      FFrame.ValueString:=Null;
      FFrame.ValueNumber:=Null;
      FFrame.ValueDate:=Null;
      FFrame.ValueBlob:=Null;
      Provider.ParamByName('VALUE_STRING').Value:=Null;
      Provider.ParamByName('VALUE_NUMBER').Value:=Null;
      Provider.ParamByName('VALUE_DATE').Value:=Null;
      Provider.ParamByName('VALUE_BLOB').Value:=Null;
      Provider.ParamByName('EXPORT').Value:=Null;
      Provider.ParamByName('DESCRIPTION').Value:=Null;
    end else begin
      FFrame.ParamId:=ParamId.Value;
      FFrame.ParamSorting:=TBisKrieltDataParamSorting(VarToIntDef(ParamId.Values.GetValue('SORTING'),0));
      FFrame.ParamType:=TBisKrieltDataParamType(VarToIntDef(ParamId.Values.GetValue('PARAM_TYPE'),0));
      FFrame.ParamMaxLength:=VarToIntDef(ParamId.Values.GetValue('MAX_LENGTH'),0);
      FFrame.ValueString:=Null;
      FFrame.ValueNumber:=Null;
      FFrame.ValueDate:=Null;
      FFrame.ValueBlob:=Null;
      Provider.ParamByName('VALUE_STRING').Value:=Null;
      Provider.ParamByName('VALUE_NUMBER').Value:=Null;
      Provider.ParamByName('VALUE_DATE').Value:=Null;
      Provider.ParamByName('VALUE_BLOB').Value:=Null;
      Provider.ParamByName('EXPORT').Value:=Null;
      Provider.ParamByName('DESCRIPTION').Value:=Null;
    end;
    SetExportDescription(FFrame.ParamType in [dptList,dptImage,dptDocument,dptVideo,dptLink]);
  end;

end;

procedure TBisKrieltObjectParamEditForm.BeforeShow;
begin
  inherited BeforeShow;


  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      with Find('ACCOUNT_ID') do begin
        Enabled:=false;
        SetNewValue(Core.AccountId);
      end;
      Find('WHO_PLACED_NAME').SetNewValue(Core.AccountUserName);
      with Find('DATE_CREATE') do begin
        Enabled:=false;
        SetNewValue(Now);
      end;
    end;

  end;

  FFrame.BeforeShow;
  
  if Mode in [emDuplicate,emDuplicate,emUpdate,emDelete] then begin
    FFrame.ParamId:=Provider.ParamByName('PARAM_ID').Value;
    FFrame.ParamSorting:=TBisKrieltDataParamSorting(Provider.ParamByName('PARAM_SORTING').AsInteger);
    FFrame.ParamType:=TBisKrieltDataParamType(Provider.ParamByName('PARAM_TYPE').AsInteger);
    FFrame.ParamMaxLength:=Provider.ParamByName('PARAM_MAX_LENGTH').AsInteger;

    FFrame.ValueString:=Provider.ParamByName('VALUE_STRING').Value;
    FFrame.ValueNumber:=Provider.ParamByName('VALUE_NUMBER').Value;
    FFrame.ValueDate:=Provider.ParamByName('VALUE_DATE').Value;
    FFrame.ValueBlob:=Provider.ParamByName('VALUE_BLOB').Value;

  end;

  if Mode in [emDelete,emFilter] then begin
    EnableControl(FFrame,false);
  end;

  SetExportDescription(FFrame.ParamType in [dptList,dptImage,dptDocument,dptVideo,dptLink]);

  FBeforeShowed:=true;

  UpdateButtonState;
end;

procedure TBisKrieltObjectParamEditForm.FrameChange(Sender: TObject);
begin
  Provider.ParamByName('VALUE_STRING').Value:=FFrame.ValueString;
  Provider.ParamByName('VALUE_NUMBER').Value:=FFrame.ValueNumber;
  Provider.ParamByName('VALUE_DATE').Value:=FFrame.ValueDate;
  Provider.ParamByName('VALUE_BLOB').Value:=FFrame.ValueBlob;
  Provider.ParamByName('EXPORT').Value:=FFrame.Export;
  Provider.ParamByName('DESCRIPTION').Value:=FFrame.Description;
end;


end.