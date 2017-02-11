unit BisMessDataOutMessagesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  Menus, ActnPopup, ImgList, ToolWin, Grids, DBGrids,
  VirtualTrees,                                                                          
  BisDataFrm, BisDataEditFm, BisDataGridFrm, BisFieldNames, BisDBTree;

type
  TBisMessDataOutMessagesFrame = class(TBisDataGridFrame)
    ToolBarAdditional: TToolBar;
    ToolButtonImport: TToolButton;
    ActionImport: TAction;
    procedure ActionImportExecute(Sender: TObject);
    procedure ActionImportUpdate(Sender: TObject);
  private
    FGroupHour: String;
    FGroupToday: String;
    FGroupArchive: String;
    FSToday: String;
    FSArchive: String;
    FFilterMenuItemHour: TBisDataFrameFilterMenuItem;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FRecipientId: Variant;
    FRecipientName: Variant;
    FContact: Variant;
    FSHour: String;
    FRecipientUserName: Variant;
    FRecipientSurname: Variant;
    FRecipientPatronymic: Variant;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    function GetNewRecipientName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure OpenRecords; override;
    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;

    function CanImport: Boolean;
    procedure Import;

    property FilterMenuItemHour: TBisDataFrameFilterMenuItem read FFilterMenuItemHour;
    property FilterMenuItemToday: TBisDataFrameFilterMenuItem read FFilterMenuItemToday;
    property FilterMenuItemArchive: TBisDataFrameFilterMenuItem read FFilterMenuItemArchive;

    property RecipientId: Variant read FRecipientId write FRecipientId;
    property RecipientUserName: Variant read FRecipientUserName write FRecipientUserName;
    property RecipientSurname: Variant read FRecipientSurname write FRecipientSurname;
    property RecipientName: Variant read FRecipientName write FRecipientName;
    property RecipientPatronymic: Variant read FRecipientPatronymic write FRecipientPatronymic;

    property Contact: Variant read FContact write FContact;
  published
    property SHour: String read FSHour write FSHour;
    property SToday: String read FSToday write FSToday;
    property SArchive: String read FSArchive write FSArchive;
  end;

implementation

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisFilterGroups, BisValues, BisCore, BisDialogs, BisParam,
     BisMessDataOutMessageEditFm, BisMessDataOutMessageFilterFm, BisMessDataOutMessageInsertExFm,
     BisMessDataOutMessagesImportFm;

{$R *.dfm}

{ TBisMessDataOutMessagesFrame }

constructor TBisMessDataOutMessagesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisMessDataOutMessageFilterFormIface;
  ViewClass:=TBisMessDataOutMessageViewFormIface;
  InsertClasses.Add(TBisMessDataOutMessageInsertFormIface);
  InsertClasses.Add(TBisMessDataOutMessageInsertExFormIface);
  UpdateClass:=TBisMessDataOutMessageUpdateFormIface;
  DeleteClass:=TBisMessDataOutMessageDeleteFormIface;
  with Provider do begin
    ProviderName:='S_OUT_MESSAGES';
    UseCache:=false;
    with FieldNames do begin
      AddKey('OUT_MESSAGE_ID');
      AddInvisible('CREATOR_ID');
      AddInvisible('CREATOR_NAME');
      AddInvisible('RECIPIENT_ID');
      AddInvisible('RECIPIENT_USER_NAME');
      AddInvisible('RECIPIENT_SURNAME');
      AddInvisible('RECIPIENT_NAME');
      AddInvisible('RECIPIENT_PATRONYMIC');
      AddInvisible('RECIPIENT_PHONE');
      AddInvisible('TYPE_MESSAGE');
      AddInvisible('DESCRIPTION');
      AddInvisible('PRIORITY');
      AddInvisible('DATE_CREATE');
      AddInvisible('DATE_END');
      AddInvisible('CHANNEL');
      AddInvisible('DELIVERY');
      AddInvisible('DATE_DELIVERY');
      AddInvisible('FLASH');
      AddInvisible('DEST_PORT');
      AddInvisible('FIRM_ID');
      AddInvisible('FIRM_SMALL_NAME');
      AddInvisible('OPERATOR_ID');
      AddInvisible('OPERATOR_NAME');
      AddInvisible('MESSAGE_ID');
      AddInvisible('SOURCE');
      AddInvisible('ATTEMPTS');
      Add('DATE_BEGIN','���� ������',110);
      Add('TEXT_OUT','����� ���������',210);
      Add('DATE_OUT','���� ��������',110);
      Add('CONTACT','�������',90);
      AddCalculate('NEW_RECIPIENT_NAME','����������',GetNewRecipientName,ftString,350,150);
      Add('LOCKED','����������',50).Visible:=false;
    end;
    Orders.Add('DATE_BEGIN',otDesc);
  end;
  RequestLargeData:=true;

  FGroupHour:=GetUniqueID;
  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;

  FSHour:='�� ���';
  FSToday:='�� �����';
  FSArchive:='�����';

  FFilterMenuItemHour:=CreateFilterMenuItem(FSHour);
  FFilterMenuItemHour.Checked:=true;

  FFilterMenuItemToday:=CreateFilterMenuItem(FSToday);

  FFilterMenuItemArchive:=CreateFilterMenuItem(FSArchive);
  FFilterMenuItemArchive.RequestLargeData:=true;

  Grid.OnPaintText:=GridPaintText;

  FRecipientId:=Null;
  FRecipientName:=Null;
  FContact:=Null;
  FRecipientUserName:=Null;
  FRecipientSurname:=Null;
  FRecipientPatronymic:=Null;

end;

procedure TBisMessDataOutMessagesFrame.Init;
begin
  inherited Init;
  FFilterMenuItemToday.Caption:=FSToday;
  FFilterMenuItemArchive.Caption:=FSArchive;
end;

function TBisMessDataOutMessagesFrame.GetNewRecipientName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=DataSet.FieldByName('RECIPIENT_USER_NAME').AsString;
    S2:=DataSet.FieldByName('RECIPIENT_SURNAME').AsString;
    S3:=DataSet.FieldByName('RECIPIENT_NAME').AsString;
    S4:=DataSet.FieldByName('RECIPIENT_PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

procedure TBisMessDataOutMessagesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamRecipient: TBisParam;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('RECIPIENT_USER_NAME').Value:=FRecipientUserName;
      ParamByName('RECIPIENT_SURNAME').Value:=FRecipientSurname;
      ParamByName('RECIPIENT_NAME').Value:=FRecipientName;
      ParamByName('RECIPIENT_PATRONYMIC').Value:=FRecipientPatronymic;
      P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
      P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      ParamByName('CONTACT').Value:=FContact;
      ParamRecipient:=ParamByName('RECIPIENT_ID');
      ParamRecipient.Value:=FRecipientId;
      if not ParamRecipient.Empty then
        ParamRecipient.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

procedure TBisMessDataOutMessagesFrame.OpenRecords;
var
  Group1, Group2, Group3: TBisFilterGroup;
  D: TDateTime;
begin

  D:=Core.ServerDate;

  with FFilterMenuItemHour do begin
    Group1:=FilterGroups.Find(FGroupHour);
    if Assigned(Group1) then
      FilterGroups.Remove(Group1);
    Group1:=FilterGroups.AddByName(FGroupHour,foAnd,True);
    Group1.Filters.Add('DATE_BEGIN',fcGreater,IncHour(D,-1));
  end;

  with FFilterMenuItemToday do begin
    Group2:=FilterGroups.Find(FGroupToday);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group2.Filters.Add('DATE_BEGIN',fcGreater,IncDay(D,-1));
  end;

  with FFilterMenuItemArchive do begin
    Group3:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group3) then
      FilterGroups.Remove(Group3);
    Group3:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group3.Filters.Add('DATE_BEGIN',fcEqualLess,IncDay(D,-1));
  end;

  inherited OpenRecords;
end;

procedure TBisMessDataOutMessagesFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                                                     Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Locked: Variant;
  Flag: Boolean;
begin
  Flag:=((Node=Grid.FocusedNode) and (Column<>Grid.FocusedColumn)) or (Node<>Grid.FocusedNode);
  if Flag then begin
    Locked:=Grid.GetNodeValue(Node,'LOCKED');
    if not VarIsNull(Locked) then
      TargetCanvas.Font.Color:=clRed;
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
//  Result:=CanInsertRecord;
  Result:=false;
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

function TBisMessDataOutMessagesFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

function TBisMessDataOutMessagesFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;


end.