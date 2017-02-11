unit BisKrieltDataParamValueEditFm;

interface                                                                                         

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TBisKrieltDataParamValueEditForm = class(TBisDataEditForm)
    LabelParam: TLabel;
    EditParam: TEdit;
    ButtonParam: TButton;
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelVariants: TLabel;
    MemoVariants: TMemo;
    LabelExport: TLabel;
    EditExport: TEdit;
    procedure MemoVariantsChange(Sender: TObject);
  private
    FDefaultVariants: String;
    procedure DeleteVariants;
    procedure InsertVariants;
  public
    procedure ChangeParam(Param: TBisParam); override;
    procedure Execute; override;
    procedure BeforeShow; override;
    function ChangesExists: Boolean; override;
  end;

  TBisKrieltDataParamValueEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueFilterFormIface=class(TBisKrieltDataParamValueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueInsertFormIface=class(TBisKrieltDataParamValueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueUpdateFormIface=class(TBisKrieltDataParamValueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataParamValueDeleteFormIface=class(TBisKrieltDataParamValueEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataParamValueEditForm: TBisKrieltDataParamValueEditForm;

implementation

{$R *.dfm}

uses BisKrieltDataParamsFm, BisProvider, BisFilterGroups, BisConsts, BisUtils, BisParamEditDataSelect;

{ TBisKrieltDataParamValueEditFormIface }

constructor TBisKrieltDataParamValueEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataParamValueEditForm;
  with Params do begin
    with AddKey('PARAM_VALUE_ID') do begin
      Older('OLD_PARAM_VALUE_ID');
    end;
    AddEditDataSelect('PARAM_ID','EditParam','LabelParam','ButtonParam',
                      TBisKrieltDataParamsFormIface,'PARAM_NAME',true,false,'','NAME');
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('EXPORT','EditExport','LabelExport');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataParamValueFilterFormIface }

constructor TBisKrieltDataParamValueFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataParamValueInsertFormIface }

constructor TBisKrieltDataParamValueInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PARAM_VALUE';
end;

{ TBisKrieltDataParamValueUpdateFormIface }

constructor TBisKrieltDataParamValueUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PARAM_VALUE';
end;

{ TBisKrieltDataParamValueDeleteFormIface }

constructor TBisKrieltDataParamValueDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PARAM_VALUE';
end;

{ TBisKrieltDataParamValueEditForm }

procedure TBisKrieltDataParamValueEditForm.BeforeShow;
begin
  inherited BeforeShow;
  LabelExport.Enabled:=not (Mode in [emFilter,emDelete]);
  MemoVariants.Enabled:=LabelExport.Enabled;
  MemoVariants.ReadOnly:=Mode in [emFilter,emDelete];
  MemoVariants.Color:=iff(MemoVariants.ReadOnly,ColorControlReadOnly,MemoVariants.Color);
  MemoVariants.OnChange:=MemoVariantsChange;
end;

procedure TBisKrieltDataParamValueEditForm.ChangeParam(Param: TBisParam);
var
  P: TBisProvider;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'PARAM_VALUE_ID') and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_PARAM_VALUE_VARIANTS';
      P.FieldNames.AddInvisible('VALUE');
      P.FilterGroups.Add.Filters.Add('PARAM_VALUE_ID',fcEqual,Param.Value);
      P.Open;
      if P.Active and not P.IsEmpty then begin
        MemoVariants.Lines.BeginUpdate;
        try
          MemoVariants.Clear;
          P.First;
          while not P.Eof do begin
            MemoVariants.Lines.Add(P.FieldByName('VALUE').AsString);
            P.Next;
          end;
          FDefaultVariants:=MemoVariants.Lines.Text;
        finally
          MemoVariants.Lines.EndUpdate;
        end;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisKrieltDataParamValueEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or
          (MemoVariants.Lines.Text<>FDefaultVariants);
end;

procedure TBisKrieltDataParamValueEditForm.DeleteVariants;
var
  P: TBisProvider;
  Param: TBisParam;
begin
  Param:=Provider.Params.Find('PARAM_VALUE_ID');
  if Assigned(Param) and not Param.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='D_PARAM_VALUE_VARIANT';
      P.Params.AddInvisible('OLD_PARAM_VALUE_ID').Value:=Param.Value;
      P.Execute;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisKrieltDataParamValueEditForm.InsertVariants;
var
  P: TBisProvider;
  Param: TBisParam;
  i: Integer;
  S: String;
  OldCursor: TCursor;
begin
  Param:=Provider.Params.Find('PARAM_VALUE_ID');
  if Assigned(Param) and not Param.Empty then begin
    OldCursor:=Screen.Cursor;
    P:=TBisProvider.Create(nil);
    try
      Screen.Cursor:=crHourGlass;
      P.WithWaitCursor:=false;
      P.ProviderName:='I_PARAM_VALUE_VARIANT';
      for i:=0 to MemoVariants.Lines.Count-1 do begin
        S:=MemoVariants.Lines.Strings[i];
        if Trim(S)<>'' then begin
          P.Params.Clear;
          with P.Params do begin
            AddInvisible('PARAM_VALUE_ID').Value:=Param.Value;
            AddInvisible('VALUE').Value:=S;
            AddInvisible('PRIORITY').Value:=i+1;
          end;
          P.Execute;
        end;
      end;
    finally
      P.Free;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisKrieltDataParamValueEditForm.MemoVariantsChange(Sender: TObject);
begin
  UpdateButtonState;
end;

procedure TBisKrieltDataParamValueEditForm.Execute;
begin
  if Mode=emDelete then
    DeleteVariants;
  inherited Execute;
  case Mode of
    emInsert,emDuplicate: InsertVariants;
    emUpdate: begin
      DeleteVariants;
      InsertVariants;
    end;
  end;
end;

end.