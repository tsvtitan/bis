unit BisTaxiDataChargesFrm;
                                                                    
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  BisFieldNames,
  BisDataFrm, BisDataGridFrm, BisDataEditFm;

type
  TBisTaxiDataChargesFrame = class(TBisDataGridFrame)
    PanelBottom: TPanel;
    LabelSum: TLabel;
  private
    FGroupToday: String;
    FGroupArchive: String;
    FGroupFirmId: String;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FAccountId: Variant;
    FUserName: Variant;
    FPatronymic: Variant;
    FName: Variant;
    FSurname: Variant;
    FShowAnotherFirms: Boolean;
    procedure SetCalculateSum;
    procedure AfterChangeData(Sender: TBisDataFrame);
    function GetNewUserName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;
    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;

    property FilterMenuItemToday: TBisDataFrameFilterMenuItem read FFilterMenuItemToday;
    property FilterMenuItemArchive: TBisDataFrameFilterMenuItem read FFilterMenuItemArchive;

    property AccountId: Variant read FAccountId write FAccountId;
    property UserName: Variant read FUserName write FUserName;
    property Surname: Variant read FSurname write FSurname;
    property Name: Variant read FName write FName;
    property Patronymic: Variant read FPatronymic write FPatronymic;

    property ShowAnotherFirms: Boolean read FShowAnotherFirms write FShowAnotherFirms;  
  end;

implementation


uses DateUtils,
     BisUtils, BisConsts, BisOrders, BisCore, BisFilterGroups, BisParam,
     BisTaxiDataChargeEditFm, BisTaxiDataChargeFilterFm;

{$R *.dfm}

{ TBisTaxiDataChargesFrame }

constructor TBisTaxiDataChargesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataChargeFilterFormIface;
  ViewClass:=TBisTaxiDataChargeViewFormIface;
  InsertClass:=TBisTaxiDataChargeInsertFormIface;
  UpdateClass:=TBisTaxiDataChargeUpdateFormIface;
  DeleteClass:=TBisTaxiDataChargeDeleteFormIface;
  with Provider do begin
    ProviderName:='S_CHARGES';
    with FieldNames do begin
      AddKey('CHARGE_ID');
      AddInvisible('CHARGE_TYPE_ID');
      AddInvisible('ACCOUNT_ID');
      AddInvisible('USER_NAME');
      AddInvisible('SURNAME');
      AddInvisible('NAME');
      AddInvisible('PATRONYMIC');
      AddInvisible('WHO_CREATE_ID');
      AddInvisible('WHO_USER_NAME');
      AddInvisible('DATE_CREATE');
      AddInvisible('DESCRIPTION');
      AddInvisible('ORDER_ID');
      AddInvisible('FIRM_ID');
      AddInvisible('FIRM_SMALL_NAME');
      Add('DATE_CHARGE','����',110);
      AddCalculate('NEW_USER_NAME','����',GetNewUserName,ftString,350,150);
      Add('SUM_CHARGE','�����',70).DisplayFormat:='#0.00';
      Add('CHARGE_TYPE_NAME','��� ��������',180);
    end;
    Orders.Add('DATE_CHARGE',otDesc);
  end;
  OnAfterInsertRecord:=AfterChangeData;
  OnAfterDuplicateRecord:=AfterChangeData;
  OnAfterUpdateRecord:=AfterChangeData;
  OnAfterDeleteRecord:=AfterChangeData;
  OnAfterFilterRecords:=AfterChangeData;

  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;
  FGroupFirmId:=GetUniqueID;

  FFilterMenuItemToday:=CreateFilterMenuItem('�� �����');
  FFilterMenuItemToday.Checked:=true;

  FFilterMenuItemArchive:=CreateFilterMenuItem('�����');

  FAccountId:=Null;

  FShowAnotherFirms:=false;
end;

function TBisTaxiDataChargesFrame.GetNewUserName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active and not DataSet.IsEmpty then begin
    S1:=DataSet.FieldByName('USER_NAME').AsString;
    S2:=DataSet.FieldByName('SURNAME').AsString;
    S3:=DataSet.FieldByName('NAME').AsString;
    S4:=DataSet.FieldByName('PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

procedure TBisTaxiDataChargesFrame.AfterChangeData(Sender: TBisDataFrame);
begin
  SetCalculateSum;
end;

procedure TBisTaxiDataChargesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  Param: TBisParam;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('USER_NAME').Value:=FUserName;
      ParamByName('SURNAME').Value:=FSurname;
      ParamByName('NAME').Value:=FName;
      ParamByName('PATRONYMIC').Value:=FPatronymic;
      P1:=ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
      P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      Param:=ParamByName('ACCOUNT_ID');
      Param.Value:=FAccountId;
      if not Param.Empty then
        Param.ExcludeModes(AllParamEditModes);
    end;
    TBisTaxiDataChargeEditFormIface(AIface).ShowAnotherFirms:=ShowAnotherFirms;
  end;
end;

procedure TBisTaxiDataChargesFrame.OpenRecords;
var
  Group1, Group2, Group3: TBisFilterGroup;
  D: TDateTime;
begin

  D:=Core.ServerDate;

  with FFilterMenuItemToday do begin
    Group1:=FilterGroups.Find(FGroupToday);
    if Assigned(Group1) then
      FilterGroups.Remove(Group1);
    Group1:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group1.Filters.Add('DATE_CHARGE',fcGreater,IncDay(D,-1));
  end;

  with FFilterMenuItemArchive do begin
    Group2:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group2.Filters.Add('DATE_CHARGE',fcEqualLess,IncDay(D,-1));
  end;

  Group3:=Provider.FilterGroups.Find(FGroupFirmId);
  if Assigned(Group3) then
    Provider.FilterGroups.Remove(Group3);
  if not VarIsNull(Core.FirmId) then begin
    if not FShowAnotherFirms then begin
      Group3:=Provider.FilterGroups.AddByName(FGroupFirmId);
      Group3.Filters.Add('FIRM_ID',fcEqual,Core.FirmId).CheckCase:=true;
    end;
  end;

  inherited OpenRecords;

  SetCalculateSum;
end;

procedure TBisTaxiDataChargesFrame.SetCalculateSum;

  function GetSum: Extended;
  begin
    Result:=0.0;
    if Provider.Active then begin
      Provider.BeginUpdate(true);
      try
        Provider.First;
        while not Provider.Eof do begin
          Result:=Result+Provider.FieldByName('SUM_CHARGE').AsFloat;
          Provider.Next;
        end;
        Provider.First;
      finally
        Provider.EndUpdate(true);
      end;
    end;
  end;

begin
  LabelSum.Caption:=FormatFloat(Provider.FieldNames.FieldByName('SUM_CHARGE').DisplayFormat,GetSum);
end;

function TBisTaxiDataChargesFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

function TBisTaxiDataChargesFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;


end.
