unit BisDocproManagementMasterFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids,
  BisDataGridFrm, BisDocproManagementMasterEditFm;

type
  TBisDocproManagementMasterFrame = class(TBisDataGridFrame)
  private
    function GetFirmId: Variant;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;
  end;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCore, BisProvider;

{ TBisDocproManagementMasterFrame }

constructor TBisDocproManagementMasterFrame.Create(AOwner: TComponent);
var
  FirmId: Variant;
begin
  inherited Create(AOwner);
  UpdateClass:=TBisDocproManagementMasterUpdateFormIface;
  AsModal:=true;

  with Provider do begin
    ProviderName:='S_MANAGEMENTS';
    with FieldNames do begin
      AddKey('MOTION_ID');
      AddInvisible('DOC_ID');
      AddInvisible('DESCRIPTION');
      Add('DATE_ISSUE','���� ��������',105);
      Add('WHO_FIRM','�����',100);
      Add('WHO_ACCOUNT','��� �������',100);
      Add('DOC_NUM','����� ���������',50);
      Add('DATE_DOC','���� ���������',70);
      Add('DOC_NAME','������������ ���������',150);
    end;
    FirmId:=GetFirmId;
    with FilterGroups.Add do begin
      Filters.Add('POSITION_FIRM_ID',fcEqual,FirmId)
    end;
    Orders.Add('DATE_ISSUE');
  end;

  ActionExport.Visible:=false;
  ActionFilter.Visible:=false;
  ActionViewing.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionDelete.Visible:=false;
  LabelCounter.Visible:=true;
end;

function TBisDocproManagementMasterFrame.GetFirmId: Variant;
var
  P: TBisProvider;
begin
  Result:=Null;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNTS';
    P.FieldNames.AddInvisible('FIRM_ID');
    P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Core.AccountId);
    P.Open;
    if P.Active and not P.IsEmpty then
      Result:=P.FieldByName('FIRM_ID').Value;
  finally
    P.Free;
  end;
end;

procedure TBisDocproManagementMasterFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

end.