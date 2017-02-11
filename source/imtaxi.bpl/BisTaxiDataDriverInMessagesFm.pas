unit BisTaxiDataDriverInMessagesFm;

interface
                                                         
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, BisDataEditFm, BisFieldNames;

type
  TBisTaxiDataDriverInMessagesFrame=class(TBisDataGridFrame)
  private
    FGroupHour: String;
    FGroupToday: String;
    FGroupArchive: String;                                                                             
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FSenderId: Variant;
    FSenderName: Variant;
    FContact: Variant;
    FSToday: String;
    FSArchive: String;
    FSHour: String;
    FFilterMenuItemHour: TBisDataFrameFilterMenuItem;
    FSenderSurname: Variant;
    FSenderUserName: Variant;
    FSenderPatronymic: Variant;
    function GetNewSenderName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
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

    property SenderId: Variant read FSenderId write FSenderId;
    property SenderUserName: Variant read FSenderUserName write FSenderUserName;
    property SenderSurname: Variant read FSenderSurname write FSenderSurname;
    property SenderName: Variant read FSenderName write FSenderName;
    property SenderPatronymic: Variant read FSenderPatronymic write FSenderPatronymic;
    property Contact: Variant read FContact write FContact;
  published
    property SHour: String read FSHour write FSHour;
    property SToday: String read FSToday write FSToday;
    property SArchive: String read FSArchive write FSArchive;   
  end;

  TBisTaxiDataDriverInMessagesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataDriverInMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverInMessagesForm: TBisTaxiDataDriverInMessagesForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisCore, BisFilterGroups, BisParam,
     BisTaxiDataDriverInMessageEditFm, BisTaxiDataDriverInMessageFilterFm;

{ TBisTaxiDataDriverInMessagesFrame }

constructor TBisTaxiDataDriverInMessagesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataDriverInMessageFilterFormIface;
  ViewClass:=TBisTaxiDataDriverInMessageViewFormIface;
  InsertClass:=TBisTaxiDataDriverInMessageInsertFormIface;
  UpdateClass:=TBisTaxiDataDriverInMessageUpdateFormIface;
  DeleteClass:=TBisTaxiDataDriverInMessageDeleteFormIface;
  with Provider do begin
    ProviderName:='S_DRIVER_IN_MESSAGES';
    UseCache:=false;
    with FieldNames do begin
      AddKey('IN_MESSAGE_ID');
      AddInvisible('SENDER_ID');
      AddInvisible('SENDER_USER_NAME');
      AddInvisible('SENDER_SURNAME');
      AddInvisible('SENDER_NAME');
      AddInvisible('SENDER_PATRONYMIC');
      AddInvisible('CODE_MESSAGE_ID');
      AddInvisible('CODE');
      AddInvisible('TYPE_MESSAGE');
      AddInvisible('CAR_CALLSIGN');
      AddInvisible('ORDER_ID');
      AddInvisible('CHANNEL');
      AddInvisible('DESCRIPTION');
      AddInvisible('FIRM_ID');
      AddInvisible('FIRM_SMALL_NAME');
      AddInvisible('OPERATOR_ID');
      AddInvisible('OPERATOR_NAME');
      Add('DATE_IN','���� ���������',110);
      Add('TEXT_IN','����� ���������',150);
      Add('DATE_SEND','���� ��������',110);
      Add('CONTACT','�������',90);
      AddCalculate('NEW_SENDER_NAME','��������',GetNewSenderName,ftString,150,100);
      Add('CAR_COLOR','���� ����������',80);
      Add('CAR_BRAND','����� ����������',80);
      Add('CAR_STATE_NUM','���. ����� ����������',80);
      
    end;
    Orders.Add('DATE_IN',otDesc);
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

  FSenderId:=Null;
  FSenderName:=Null;
  FContact:=Null;
  FSenderSurname:=Null;
  FSenderUserName:=Null;
  FSenderPatronymic:=Null;
end;

function TBisTaxiDataDriverInMessagesFrame.GetNewSenderName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=DataSet.FieldByName('SENDER_USER_NAME').AsString;
    S2:=DataSet.FieldByName('SENDER_SURNAME').AsString;
    S3:=DataSet.FieldByName('SENDER_NAME').AsString;
    S4:=DataSet.FieldByName('SENDER_PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

procedure TBisTaxiDataDriverInMessagesFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamSender: TBisParam;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      ParamByName('SENDER_USER_NAME').Value:=FSenderUserName;
      ParamByName('SENDER_SURNAME').Value:=FSenderSurname;
      ParamByName('SENDER_NAME').Value:=FSenderName;
      ParamByName('SENDER_PATRONYMIC').Value:=FSenderPatronymic;
      P1:=ParamByName('SENDER_USER_NAME;SENDER_SURNAME;SENDER_NAME;SENDER_PATRONYMIC');
      P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      ParamByName('CONTACT').Value:=FContact;
      ParamSender:=ParamByName('SENDER_ID');
      ParamSender.Value:=FSenderId;
      if not ParamSender.Empty then
        ParamSender.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

procedure TBisTaxiDataDriverInMessagesFrame.OpenRecords;
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
    Group1.Filters.Add('DATE_IN',fcGreater,IncHour(D,-1));
  end;

  with FFilterMenuItemToday do begin
    Group2:=FilterGroups.Find(FGroupToday);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group2.Filters.Add('DATE_IN',fcGreater,IncDay(D,-1));
  end;

  with FFilterMenuItemArchive do begin
    Group3:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group3) then
      FilterGroups.Remove(Group3);
    Group3:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group3.Filters.Add('DATE_IN',fcEqualLess,IncDay(D,-1));
  end;

  inherited OpenRecords;
end;

function TBisTaxiDataDriverInMessagesFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

function TBisTaxiDataDriverInMessagesFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

{ TBisTaxiDataDriverInMessagesFormIface }

constructor TBisTaxiDataDriverInMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverInMessagesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataDriverInMessagesForm }

class function TBisTaxiDataDriverInMessagesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataDriverInMessagesFrame;
end;

end.
