unit BisMessDataOutMessagesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  Menus, ActnPopup, ImgList, ToolWin, Grids, DBGrids,
  VirtualTrees, VirtualDBTreeEx,
  BisDataFrm, BisDataGridFrm, BisFieldNames, BisDBTree;

type
  TBisMessDataOutMessagesFrame = class(TBisDataGridFrame)
    ToolBarAdditional: TToolBar;
    ToolButtonImport: TToolButton;
    ActionImport: TAction;
    procedure ActionImportExecute(Sender: TObject);
    procedure ActionImportUpdate(Sender: TObject);
  private
    FGroupToday: String;
    FGroupArchive: String;
    FSToday: String;
    FSArchive: String;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure OpenRecords; override;

    function CanImport: Boolean;
    procedure Import;

    property FilterMenuItemToday: TBisDataFrameFilterMenuItem read FFilterMenuItemToday;
    property FilterMenuItemArchive: TBisDataFrameFilterMenuItem read FFilterMenuItemArchive;

  published
    property SToday: String read FSToday write FSToday;
    property SArchive: String read FSArchive write FSArchive;
  end;

implementation

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisFilterGroups, BisValues, BisCore, BisDialogs,
     BisMessDataOutMessageEditFm, BisMessDataOutMessageFilterFm, BisMessDataOutMessageInsertExFm,
     BisMessDataOutMessagesImportFm;

{$R *.dfm}

{ TBisMessDataOutMessagesFrame }

constructor TBisMessDataOutMessagesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FilterClass:=TBisMessDataOutMessageFilterFormIface;
  InsertClasses.Add(TBisMessDataOutMessageInsertFormIface);
  InsertClasses.Add(TBisMessDataOutMessageInsertExFormIface);
  UpdateClass:=TBisMessDataOutMessageUpdateFormIface;
  DeleteClass:=TBisMessDataOutMessageDeleteFormIface;
  with Provider do begin
    ProviderName:='S_OUT_MESSAGES';
    with FieldNames do begin
      AddKey('OUT_MESSAGE_ID');
      AddInvisible('CREATOR_ID');
      AddInvisible('CREATOR_NAME');
      AddInvisible('RECIPIENT_ID');
      AddInvisible('RECIPIENT_NAME');
      AddInvisible('RECIPIENT_PHONE');
      AddInvisible('TYPE_MESSAGE');
      AddInvisible('DESCRIPTION');
      AddInvisible('PRIORITY');
      AddInvisible('DATE_CREATE');
      AddInvisible('DATE_END');
      Add('DATE_BEGIN','���� ������',110);
      Add('TEXT_OUT','����� ���������',210);
      Add('DATE_OUT','���� ��������',110);
      Add('CONTACT','�������',100);
      Add('LOCKED','����������',50).Visible:=false;
    end;
    Orders.Add('DATE_BEGIN',otDesc);
  end;

  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;

  FSToday:='�� �����';
  FSArchive:='�����';

  FFilterMenuItemToday:=CreateFilterMenuItem(FSToday);
  FFilterMenuItemToday.Checked:=true;

  FFilterMenuItemArchive:=CreateFilterMenuItem(FSArchive);

  Grid.OnPaintText:=GridPaintText;

end;

procedure TBisMessDataOutMessagesFrame.Init;
begin
  inherited Init;
  FFilterMenuItemToday.Caption:=FSToday;
  FFilterMenuItemArchive.Caption:=FSArchive;
end;

procedure TBisMessDataOutMessagesFrame.OpenRecords;
var
  Group1, Group2: TBisFilterGroup;
  D: TDateTime;
begin

  D:=Core.ServerDate;

  with FFilterMenuItemToday do begin
    Group1:=FilterGroups.Find(FGroupToday);
    if Assigned(Group1) then
      FilterGroups.Remove(Group1);
    Group1:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group1.Filters.Add('DATE_BEGIN',fcGreater,IncDay(D,-1));
    Group1.Filters.Add('DATE_BEGIN',fcEqualLess,D);
  end;

  with FFilterMenuItemArchive do begin
    Group2:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group2.Filters.Add('DATE_BEGIN',fcEqualLess,IncDay(D,-1));
  end;

  inherited OpenRecords;
end;

procedure TBisMessDataOutMessagesFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                 Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PBisDBTreeNode;
  DataKey: PDBVTData;
  DateKeyFocused: PDBVTData;
  Item: TBisValue;
  Flag: Boolean;
begin
  Data:=Grid.GetDBNodeData(Node);
  DataKey:=Grid.GetNodeData(Node);
  DateKeyFocused:=Grid.GetNodeData(Grid.FocusedNode);
  if Assigned(Data) and Assigned(DataKey) and Assigned(DateKeyFocused) then begin
    Flag:=((DataKey.Hash=DateKeyFocused.Hash) and (Column<>Grid.FocusedColumn)) or (DataKey.Hash<>DateKeyFocused.Hash);
    if Assigned(Data.Values) and Flag then begin
      Item:=Data.Values.Find('LOCKED');
      if Assigned(Item) and not VarIsNull(Item.Value) then begin
        TargetCanvas.Font.Color:=clRed;
      end;
    end;
  end;
end;

procedure TBisMessDataOutMessagesFrame.ActionImportExecute(Sender: TObject);
begin
  Import;
end;

procedure TBisMessDataOutMessagesFrame.ActionImportUpdate(Sender: TObject);
begin
  ActionImport.Enabled:=CanImport;
end;

function TBisMessDataOutMessagesFrame.CanImport: Boolean;
begin
  Result:=CanInsertRecord;
end;

procedure TBisMessDataOutMessagesFrame.Import;
var
  AIface: TBisMessDataOutMessagesImportFormIface;
begin
  if CanImport then begin
    AIface:=TBisMessDataOutMessagesImportFormIface.Create(nil);
    try
      AIface.Init;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
      RefreshRecords;
    finally
      AIface.Free;
    end;
  end;
end;


end.
