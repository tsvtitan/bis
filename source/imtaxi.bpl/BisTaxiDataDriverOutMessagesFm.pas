unit BisTaxiDataDriverOutMessagesFm;

interface                                              

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  VirtualTrees, 
  BisFm, BisDataFrm, BisDataGridFrm, BisDataGridFm, BisFieldNames, BisDataEditFm,
  BisDBTree;

type
  TBisTaxiDataDriverOutMessagesFrame=class(TBisDataGridFrame)                                          
  private
    FGroupHour: String;
    FGroupToday: String;
    FGroupArchive: String;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FRecipientId: Variant;
    FRecipientName: Variant;
    FContact: Variant;
    FSToday: String;
    FSArchive: String;
    FSHour: String;
    FFilterMenuItemHour: TBisDataFrameFilterMenuItem;
    FRecipientSurname: Variant;
    FRecipientUserName: Variant;
    FRecipientPatronymic: Variant;
    function GetNewRecipientName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
                            Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;
    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;

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

  TBisTaxiDataDriverOutMessagesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataDriverOutMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverOutMessagesForm: TBisTaxiDataDriverOutMessagesForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisFilterGroups, BisValues,
     BisCore, BisParam, BisTaxiDataDriverOutMessageEditFm, BisTaxiDataDriverOutMessageFilterFm;

{ TBisTaxiDataDriverOutMessagesFrame }

constructor TBisTaxiDataDriverOutMessagesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataDriverOutMessageFilterFormIface;
  ViewClass:=TBisTaxiDataDriverOutMessageViewFormIface;
  InsertClass:=TBisTaxiDataDriverOutMessageInsertFormIface;
  UpdateClass:=TBisTaxiDataDriverOutMessageUpdateFormIface;
  DeleteClass:=TBisTaxiDataDriverOutMessageDeleteFormIface;
  with Provider do begin
    ProviderName:='S_DRIVER_OUT_MESSAGES';
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
      AddInvisible('CAR_CALLSIGN');
      AddInvisible('ORDER_ID');
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
      Add('TEXT_OUT','����� ���������',150);
      Add('DATE_OUT','���� ��������',110);
      Add('CONTACT','�������',100);
      AddCalculate('NEW_RECIPIENT_NAME','��������',GetNewRecipientName,ftString,350,150);
      Add('CAR_COLOR','���� ����������',80);
      Add('CAR_BRAND','����� ����������',80);
      Add('CAR_STATE_NUM','���. ����� ����������',80);
      Add('LOCKED','����������',50).Visible:=false;
    end;
    Orders.Add('DATE_CREATE',otDesc);
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
  FRecipientSurname:=Null;
  FRecipientUserName:=Null;
  FRecipientPatronymic:=Null;
end;

function TBisTaxiDataDriverOutMessagesFrame.GetNewRecipientName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
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

procedure TBisTaxiDataDriverOutMessagesFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas;
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

procedure TBisTaxiDataDriverOutMessagesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
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

procedure TBisTaxiDataDriverOutMessagesFrame.OpenRecords;
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

function TBisTaxiDataDriverOutMessagesFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

function TBisTaxiDataDriverOutMessagesFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

{ TBisTaxiDataDriverOutMessagesFormIface }

constructor TBisTaxiDataDriverOutMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverOutMessagesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataDriverOutMessagesForm }

class function TBisTaxiDataDriverOutMessagesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataDriverOutMessagesFrame;
end;



end.
