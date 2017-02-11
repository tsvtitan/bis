unit BisTaxiDataCarEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, CheckLst, DB,
  BisDataEditFm, BisParam, BisFilterGroups, BisControls;

type
  TBisTaxiDataCarEditForm = class(TBisDataEditForm)
    LabelStateNum: TLabel;
    EditStateNum: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelYearCreated: TLabel;
    EditYearCreated: TEdit;
    LabelCallsign: TLabel;
    EditCallsign: TEdit;
    LabelBrand: TLabel;
    EditBrand: TEdit;
    LabelColor: TLabel;
    EditColor: TEdit;
    LabelPts: TLabel;
    MemoPts: TMemo;
    LabelPayload: TLabel;
    EditPayload: TEdit;
    LabelAmount: TLabel;
    EditAmount: TEdit;
    LabelCarTypes: TLabel;
    CheckListBoxCarTypes: TCheckListBox;
    procedure CheckListBoxCarTypesClickCheck(Sender: TObject);
  private
    FCarTypesChanged: Boolean;
    procedure RefreshCarTypes;
    procedure RefreshCarInTypes;
    procedure SetDeleteCarInTypes(Before: Boolean);
    procedure SetInsertCarInTypes;
    function CheckedCount: Integer;
    function GetCarTypeFlag(Param: TBisParam): Variant;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure Execute; override;
    function ChangesExists: Boolean; override;
    function CheckParam(Param: TBisParam): Boolean; override;

    procedure GetCarTypesFilterGroup(AFilterGroup: TBisFilterGroup);
  end;

  TBisTaxiDataCarEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarViewFormIface=class(TBisTaxiDataCarEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarFilterFormIface=class(TBisTaxiDataCarEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarInsertFormIface=class(TBisTaxiDataCarEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarUpdateFormIface=class(TBisTaxiDataCarEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCarDeleteFormIface=class(TBisTaxiDataCarEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCarEditForm: TBisTaxiDataCarEditForm;

implementation

uses BisUtils, BisProvider, BisParamCalculate, BisParams,
     BisTaxiDataCarTypesFm, BisParamComboBoxDataSelect;

{$R *.dfm}

type
  TBisCarTypeInfo=class(TObject)
  private
    var CarTypeId: Variant;
  end;

{ TBisTaxiDataCarEditFormIface }

constructor TBisTaxiDataCarEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCarEditForm;
  with Params do begin
    AddKey('CAR_ID').Older('OLD_CAR_ID');
    AddEdit('STATE_NUM','EditStateNum','LabelStateNum',true);
    with AddCalculate('CAR_TYPE_FLAG',nil) do begin
      Required:=true;
      ParamType:=ptUnknown;
      CaptionName:='LabelCarTypes';
      ControlName:='CheckListBoxCarTypes';
    end;
    AddEdit('CALLSIGN','EditCallsign','LabelCallsign');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEdit('BRAND','EditBrand','LabelBrand',true);
    AddEdit('COLOR','EditColor','LabelColor',true);
    AddEditInteger('YEAR_CREATED','EditYearCreated','LabelYearCreated');
    AddEditInteger('PAYLOAD','EditPayload','LabelPayload');
    AddEditInteger('AMOUNT','EditAmount','LabelAmount');
    AddMemo('PTS','MemoPts','LabelPts');
  end;
end;

{ TBisTaxiDataCarViewFormIface }

constructor TBisTaxiDataCarViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ����������';
end;

{ TBisTaxiDataCarFilterFormIface }

constructor TBisTaxiDataCarFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �����������';
  
end;

{ TBisTaxiDataCarInsertFormIface }

constructor TBisTaxiDataCarInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_CAR';
  ParentProviderName:='S_CARS';
  Caption:='������� ����������';
  SMessageSuccess:='���������� %STATE_NUM ������� ������.';
end;

{ TBisTaxiDataCarUpdateFormIface }

constructor TBisTaxiDataCarUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CAR';
  Caption:='�������� ����������';
end;

{ TBisTaxiDataCarDeleteFormIface }

constructor TBisTaxiDataCarDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CAR';
  Caption:='������� ����������';
end;

{ TBisTaxiDataCarEditForm }

constructor TBisTaxiDataCarEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RefreshCarTypes;
end;

procedure TBisTaxiDataCarEditForm.BeforeShow;
begin
  inherited BeforeShow;
  TBisParamCalculate(Provider.ParamByName('CAR_TYPE_FLAG')).OnGetValue:=GetCarTypeFlag;
  if not (Mode in [emInsert,emDuplicate,emFilter])then
    RefreshCarInTypes;
  UpdateButtonState;
end;

function TBisTaxiDataCarEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists or FCarTypesChanged;
end;

function TBisTaxiDataCarEditForm.CheckedCount: Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to CheckListBoxCarTypes.Count-1 do begin
    if CheckListBoxCarTypes.Checked[i] then
      Inc(Result);
  end;
end;

procedure TBisTaxiDataCarEditForm.CheckListBoxCarTypesClickCheck(Sender: TObject);
begin
  FCarTypesChanged:=true;
  UpdateButtonState;
end;

function TBisTaxiDataCarEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  Result:=inherited CheckParam(Param);
  if AnsiSameText(Param.ParamName,'CAR_TYPE_FLAG') then begin
  end;
end;

procedure TBisTaxiDataCarEditForm.RefreshCarInTypes;
var
  P: TBisProvider;
  Param: TBisParam;
  CarTypeId: Variant;
  i: Integer;
  Obj: TBisCarTypeInfo;
begin
  Param:=Provider.Params.Find('CAR_ID');
  if Assigned(Param) and not Param.Empty then begin
    CheckListBoxCarTypes.Items.BeginUpdate;
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_CAR_IN_TYPES';
      P.FieldNames.AddInvisible('CAR_TYPE_ID');
      P.FilterGroups.Add.Filters.Add('CAR_ID',fcEqual,Param.Value);
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          CarTypeId:=P.FieldByName('CAR_TYPE_ID').Value;
          for i:=0 to CheckListBoxCarTypes.Items.Count-1 do begin
            Obj:=TBisCarTypeInfo(CheckListBoxCarTypes.Items.Objects[i]);
            if VarSameValue(CarTypeId,Obj.CarTypeId) then begin
              CheckListBoxCarTypes.Checked[i]:=true;
            end;
          end;
          P.Next;
        end;
        Provider.ParamByName('CAR_TYPE_FLAG').DefaultValue:=GetCarTypeFlag(nil);
      end;
    finally
      P.Free;
      CheckListBoxCarTypes.Items.EndUpdate;
    end;
  end;
end;

procedure TBisTaxiDataCarEditForm.RefreshCarTypes;
var
  P: TBisProvider;
  Obj: TBisCarTypeInfo;
begin
  ClearStrings(CheckListBoxCarTypes.Items);
  CheckListBoxCarTypes.Items.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_CAR_TYPES';
    with P.FieldNames do begin
      AddInvisible('CAR_TYPE_ID');
      AddInvisible('NAME');
    end;
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active then begin
      P.First;
      while not P.Eof do begin
        Obj:=TBisCarTypeInfo.Create;
        Obj.CarTypeId:=P.FieldByName('CAR_TYPE_ID').Value;
        CheckListBoxCarTypes.Items.AddObject(P.FieldByName('NAME').AsString,Obj);
        P.Next;
      end;
    end;
  finally
    P.Free;
    CheckListBoxCarTypes.Items.EndUpdate;
  end;
end;

procedure TBisTaxiDataCarEditForm.SetDeleteCarInTypes(Before: Boolean);
var
  Obj: TBisCarTypeInfo;
  Param: TBisParam;
  i: Integer;
  Package: TBisPackageParams;
begin
  Param:=Provider.Params.Find('CAR_ID');
  if Assigned(Param) and not Param.Empty then begin
    Package:=Provider.PackageAfter;
    if Before then
      Package:=Provider.PackageBefore;
    Package.DeleteByProvider('D_CAR_IN_TYPE');
    for i:=0 to CheckListBoxCarTypes.Items.Count-1 do begin
      Obj:=TBisCarTypeInfo(CheckListBoxCarTypes.Items.Objects[i]);
      with Package.Add do begin
        ProviderName:='D_CAR_IN_TYPE';
        with AddInvisible('CAR_ID') do begin
          Older('OLD_CAR_ID');
          Value:=Param.Value;
        end;
        with AddInvisible('CAR_TYPE_ID') do begin
          Older('OLD_CAR_TYPE_ID');
          Value:=Obj.CarTypeId;
        end;
      end;
    end;
  end;
end;

procedure TBisTaxiDataCarEditForm.SetInsertCarInTypes;
var
  Obj: TBisCarTypeInfo;
  Param: TBisParam;
  i: Integer;
begin
  Param:=Provider.Params.Find('CAR_ID');
  if Assigned(Param) and not Param.Empty then begin
    Provider.PackageAfter.DeleteByProvider('I_CAR_IN_TYPE');
    for i:=0 to CheckListBoxCarTypes.Items.Count-1 do begin
      if CheckListBoxCarTypes.Checked[i] then begin
        Obj:=TBisCarTypeInfo(CheckListBoxCarTypes.Items.Objects[i]);
        with Provider.PackageAfter.Add do begin
          ProviderName:='I_CAR_IN_TYPE';
          AddInvisible('CAR_ID').Value:=Param.Value;
          AddInvisible('CAR_TYPE_ID').Value:=Obj.CarTypeId;
        end;
      end;
    end;
  end;
end;

function TBisTaxiDataCarEditForm.GetCarTypeFlag(Param: TBisParam): Variant;
begin
  Result:=Null;
  if CheckedCount>0 then
    Result:=true;
end;

procedure TBisTaxiDataCarEditForm.GetCarTypesFilterGroup(AFilterGroup: TBisFilterGroup);
var
  i: Integer;
  Obj: TBisCarTypeInfo;
  Group: TBisFilterGroup;
begin
  for i:=0 to CheckListBoxCarTypes.Count-1 do begin
    if CheckListBoxCarTypes.Checked[i] then begin
      Obj:=TBisCarTypeInfo(CheckListBoxCarTypes.Items.Objects[i]);
      Group:=AFilterGroup.Filters.AddInside('CAR_ID','','S_CAR_IN_TYPES').InsideFilterGroups.Add;
      Group.Filters.Add('CAR_TYPE_ID',fcEqual,Obj.CarTypeId).CheckCase:=true;
    end;
  end;
end;

procedure TBisTaxiDataCarEditForm.Execute;
begin
  if Mode in [emDelete,emUpdate] then
    SetDeleteCarInTypes(Mode in [emDelete]);
  if Mode in [emInsert,emUpdate,emDuplicate] then
    SetInsertCarInTypes;
  inherited Execute;
end;


end.
