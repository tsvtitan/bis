unit BisDocproManagementDetailFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  BisDataGridFrm, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids;

type
  TBisDocproManagementDetailFrame = class(TBisDataGridFrame)
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses BisFilterGroups, BisOrders;

{ TBisDocproManagementDetailFrame }

constructor TBisDocproManagementDetailFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with Provider do begin
    ProviderName:='S_MOTIONS';
    with FieldNames do begin
      AddKey('MOTION_ID');
      AddInvisible('DOC_ID');
      AddInvisible('DESCRIPTION');
      Add('DATE_PROCESS','���� ����������',105);
      Add('FIRM_SMALL_NAME','�����',90);
      Add('USER_NAME','��� ��������',90);
    end;
    with FilterGroups.Add do begin
      Filters.Add('DATE_PROCESS',fcIsNotNull,Null);
      Filters.Add('ACCOUNT_ID',fcIsNotNull,Null);
    end;
    Orders.Add('DATE_PROCESS');
    MasterFields:='DOC_ID';
  end;
  
  ActionExport.Visible:=false;
  ActionFilter.Visible:=false;
  ActionViewing.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;
  ActionDelete.Visible:=false;
  LabelCounter.Visible:=true;
end;

end.
