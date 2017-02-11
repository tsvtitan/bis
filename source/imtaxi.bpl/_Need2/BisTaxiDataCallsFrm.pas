unit BisTaxiDataCallsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  Menus, ActnPopup, ImgList, ToolWin, Grids, DBGrids,
  VirtualTrees, 
  BisDataFrm, BisDataEditFm, BisDataGridFrm, BisFieldNames, BisDBTree,
  BisTaxiDataCallEditFm;

type
  

  TBisTaxiDataCallsFrame = class(TBisDataGridFrame)
  private                                                                                              
    FGroupHour: String;
    FGroupToday: String;
    FGroupArchive: String;
    FGroupDirection: String;
    FSToday: String;
    FSArchive: String;
    FFilterMenuItemHour: TBisDataFrameFilterMenuItem;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FSHour: String;
    FOrderId: Variant;
    FViewMode: TBisTaxiDataCallViewMode;
    FCallerId: Variant;
    FCallerPatronymic: Variant;
    FCallerName: Variant;
    FCallerSurname: Variant;
    FCallerPhone: Variant;
    FCallerUserName: Variant;
    FAcceptorSurname: Variant;
    FAcceptorPhone: Variant;
    FAcceptorId: Variant;
    FAcceptorUserName: Variant;
    FAcceptorPatronymic: Variant;
    FAcceptorName: Variant;
    procedure GridGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                                Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure SetViewMode(const Value: TBisTaxiDataCallViewMode);

    function GetNewCallerName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetNewAcceptorName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTimeFound(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTimeSpeak(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTimeLine(FieldName: TBisFieldName; DataSet: TDataSet): Variant;

  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure OpenRecords; override;
    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;

    property FilterMenuItemHour: TBisDataFrameFilterMenuItem read FFilterMenuItemHour;
    property FilterMenuItemToday: TBisDataFrameFilterMenuItem read FFilterMenuItemToday;
    property FilterMenuItemArchive: TBisDataFrameFilterMenuItem read FFilterMenuItemArchive;

    property OrderId: Variant read FOrderId write FOrderId;

    property CallerId: Variant read FCallerId write FCallerId;
    property CallerUserName: Variant read FCallerUserName write FCallerUserName;
    property CallerSurname: Variant read FCallerSurname write FCallerSurname;
    property CallerName: Variant read FCallerName write FCallerName;
    property CallerPatronymic: Variant read FCallerPatronymic write FCallerPatronymic;
    property CallerPhone: Variant read FCallerPhone write FCallerPhone;

    property AcceptorId: Variant read FAcceptorId write FAcceptorId;
    property AcceptorUserName: Variant read FAcceptorUserName write FAcceptorUserName;
    property AcceptorSurname: Variant read FAcceptorSurname write FAcceptorSurname;
    property AcceptorName: Variant read FAcceptorName write FAcceptorName;
    property AcceptorPatronymic: Variant read FAcceptorPatronymic write FAcceptorPatronymic;
    property AcceptorPhone: Variant read FAcceptorPhone write FAcceptorPhone;

    property ViewMode: TBisTaxiDataCallViewMode read FViewMode write SetViewMode;

  published
    property SHour: String read FSHour write FSHour;
    property SToday: String read FSToday write FSToday;
    property SArchive: String read FSArchive write FSArchive;
  end;

implementation

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisFilterGroups,
     BisValues, BisCore, BisDialogs, BisParam,
     BisTaxiDataCallFilterFm;

{$R *.dfm}

{ TBisTaxiDataOutMessagesFrame }

constructor TBisTaxiDataCallsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataCallFilterFormIface;
  ViewClass:=TBisTaxiDataCallViewFormIface;
  InsertClass:=TBisTaxiDataCallInsertFormIface;
  UpdateClass:=TBisTaxiDataCallUpdateFormIface;
  DeleteClass:=TBisTaxiDataCallDeleteFormIface;
  with Provider do begin
    ProviderName:='S_CALLS';
    with FieldNames do begin
      AddKey('CALL_ID');
      AddInvisible('CALL_RESULT_ID');
      AddInvisible('LINE_ID');
      AddInvisible('OPERATOR_ID');
      AddInvisible('OPERATOR_NAME');
      AddInvisible('ORDER_ID');
      AddInvisible('FIRM_ID');
      AddInvisible('FIRM_SMALL_NAME');
      AddInvisible('CREATOR_ID');
      AddInvisible('CREATOR_USER_NAME');
      AddInvisible('CALLER_ID');
      AddInvisible('CALLER_USER_NAME');
      AddInvisible('CALLER_SURNAME');
      AddInvisible('CALLER_NAME');
      AddInvisible('CALLER_PATRONYMIC');
      AddInvisible('CALLER_DIVERSION');
      AddInvisible('CALL_RESULT_NAME');
      AddInvisible('ACCEPTOR_ID');
      AddInvisible('ACCEPTOR_USER_NAME');
      AddInvisible('ACCEPTOR_SURNAME');
      AddInvisible('ACCEPTOR_NAME');
      AddInvisible('ACCEPTOR_PATRONYMIC');
      AddInvisible('TYPE_END');
      AddInvisible('IN_CHANNEL');
      AddInvisible('OUT_CHANNEL');
      AddInvisible('DATE_FOUND');
      AddInvisible('DATE_BEGIN');
      AddInvisible('DATE_END');
      Add('DATE_CREATE','���� ��������',130);
      AddCalculate('NEW_CALLER_NAME','����������',GetNewCallerName,ftString,350,150);
      Add('CALLER_PHONE','������� �����������',80);
      AddCalculate('NEW_ACCEPTOR_NAME','�����������',GetNewAcceptorName,ftString,350,150);
      Add('ACCEPTOR_PHONE','������� ������������',80);
      AddCalculate('TIME_FOUND','����� ������',GetTimeFound,ftDateTime,0,40).DisplayFormat:='nn:ss';
      AddCalculate('TIME_SPEAK','����� ��������',GetTimeSpeak,ftDateTime,0,40).DisplayFormat:='nn:ss';
      AddCalculate('TIME_LINE','����� �� �����',GetTimeLine,ftDateTime,0,40).DisplayFormat:='nn:ss';
      Add('DIRECTION','�����������',100).Visible:=false;
    end;
  end;
  RequestLargeData:=true;
  FGroupHour:=GetUniqueID;
  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;
  FGroupDirection:=GetUniqueID;

  FSHour:='�� ���';
  FSToday:='�� �����';
  FSArchive:='�����';

  FFilterMenuItemHour:=CreateFilterMenuItem(FSHour);
  FFilterMenuItemHour.Checked:=true;

  FFilterMenuItemToday:=CreateFilterMenuItem(FSToday);

  FFilterMenuItemArchive:=CreateFilterMenuItem(FSArchive);
  FFilterMenuItemArchive.RequestLargeData:=true;

  Grid.OnGetImageIndex:=GridGetImageIndex;

  FOrderId:=Null;

  FCallerId:=Null;
  FCallerPatronymic:=Null;
  FCallerName:=Null;
  FCallerSurname:=Null;
  FCallerPhone:=Null;
  FCallerUserName:=Null;

  FAcceptorSurname:=Null;
  FAcceptorPhone:=Null;
  FAcceptorId:=Null;
  FAcceptorUserName:=Null;
  FAcceptorPatronymic:=Null;
  FAcceptorName:=Null;

end;

procedure TBisTaxiDataCallsFrame.Init;
begin
  inherited Init;
  FFilterMenuItemToday.Caption:=FSToday;
  FFilterMenuItemArchive.Caption:=FSArchive;
end;

procedure TBisTaxiDataCallsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamCaller: TBisParam;
  ParamAcceptor: TBisParam;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) and (AIface is TBisTaxiDataCallEditFormIface) then begin
    with AIface.Params do begin

      case FViewMode of
        vmFull: begin
          ParamByName('DIRECTION').Value:=Null;
        end;
        vmIncoming: begin
          ParamByName('DIRECTION').Value:=0;
          ParamByName('DIRECTION').ExcludeModes(AllParamEditModes);
        end;
        vmOutgoing: begin
          ParamByName('DIRECTION').Value:=1;
          ParamByName('DIRECTION').ExcludeModes(AllParamEditModes);
          ParamByName('CALL_RESULT_ID').ExcludeModes(AllParamEditModes);
        end;
      end;

      ParamByName('CALLER_USER_NAME').Value:=FCallerUserName;
      ParamByName('CALLER_SURNAME').Value:=FCallerSurname;
      ParamByName('CALLER_NAME').Value:=FCallerName;
      ParamByName('CALLER_PATRONYMIC').Value:=FCallerPatronymic;
      P1:=ParamByName('CALLER_USER_NAME;CALLER_SURNAME;CALLER_NAME;CALLER_PATRONYMIC');
      P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      if AIface.Mode<>emFilter then
        ParamByName('CALLER_PHONE').Value:=FCallerPhone;
      ParamCaller:=ParamByName('CALLER_ID');
      ParamCaller.Value:=FCallerId;
      if not ParamCaller.Empty then
        ParamCaller.ExcludeModes(AllParamEditModes);

      ParamByName('ACCEPTOR_USER_NAME').Value:=FAcceptorUserName;
      ParamByName('ACCEPTOR_SURNAME').Value:=FAcceptorSurname;
      ParamByName('ACCEPTOR_NAME').Value:=FAcceptorName;
      ParamByName('ACCEPTOR_PATRONYMIC').Value:=FAcceptorPatronymic;
      P1:=ParamByName('ACCEPTOR_USER_NAME;ACCEPTOR_SURNAME;ACCEPTOR_NAME;ACCEPTOR_PATRONYMIC');
      P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      if AIface.Mode<>emFilter then
        ParamByName('ACCEPTOR_PHONE').Value:=FAcceptorPhone;
      ParamAcceptor:=ParamByName('ACCEPTOR_ID');
      ParamAcceptor.Value:=FAcceptorId;
      if not ParamAcceptor.Empty then
        ParamAcceptor.ExcludeModes(AllParamEditModes);

      ParamByName('ORDER_ID').Value:=FOrderId;
    end;
  end;
end;

function TBisTaxiDataCallsFrame.GetNewCallerName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=DataSet.FieldByName('CALLER_USER_NAME').AsString;
    S2:=DataSet.FieldByName('CALLER_SURNAME').AsString;
    S3:=DataSet.FieldByName('CALLER_NAME').AsString;
    S4:=DataSet.FieldByName('CALLER_PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

function TBisTaxiDataCallsFrame.GetNewAcceptorName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=DataSet.FieldByName('ACCEPTOR_USER_NAME').AsString;
    S2:=DataSet.FieldByName('ACCEPTOR_SURNAME').AsString;
    S3:=DataSet.FieldByName('ACCEPTOR_NAME').AsString;
    S4:=DataSet.FieldByName('ACCEPTOR_PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

function TBisTaxiDataCallsFrame.GetTimeFound(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDateCreate: TField;
  FieldDateFound: TField;
begin
  Result:=Null;
  FieldDateCreate:=DataSet.FieldByName('DATE_CREATE');
  FieldDateFound:=DataSet.FieldByName('DATE_FOUND');
  if not VarIsNull(FieldDateCreate.Value) and not VarIsNull(FieldDateFound.Value) then begin
    Result:=FieldDateFound.AsDateTime-FieldDateCreate.AsDateTime;
  end;
end;

function TBisTaxiDataCallsFrame.GetTimeLine(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDateCreate: TField;
  FieldDateEnd: TField;
begin
  Result:=Null;
  FieldDateCreate:=DataSet.FieldByName('DATE_CREATE');
  FieldDateEnd:=DataSet.FieldByName('DATE_END');
  if not VarIsNull(FieldDateCreate.Value) and not VarIsNull(FieldDateEnd.Value) then begin
    Result:=FieldDateEnd.AsDateTime-FieldDateCreate.AsDateTime;
  end;
end;

function TBisTaxiDataCallsFrame.GetTimeSpeak(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDateBegin: TField;
  FieldDateEnd: TField;
begin
  Result:=Null;
  FieldDateBegin:=DataSet.FieldByName('DATE_BEGIN');
  FieldDateEnd:=DataSet.FieldByName('DATE_END');
  if not VarIsNull(FieldDateBegin.Value) and not VarIsNull(FieldDateEnd.Value) then begin
    Result:=FieldDateEnd.AsDateTime-FieldDateBegin.AsDateTime;
  end;
end;

procedure TBisTaxiDataCallsFrame.OpenRecords;
var
  Group1, Group2, Group3, Group4: TBisFilterGroup;
  D: TDateTime;
begin

  D:=Core.ServerDate;

  with FFilterMenuItemHour do begin
    Group1:=FilterGroups.Find(FGroupHour);
    if Assigned(Group1) then
      FilterGroups.Remove(Group1);
    Group1:=FilterGroups.AddByName(FGroupHour,foAnd,True);
    Group1.Filters.Add('DATE_CREATE',fcGreater,IncHour(D,-1));
  end;

  with FFilterMenuItemToday do begin
    Group2:=FilterGroups.Find(FGroupToday);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group2.Filters.Add('DATE_CREATE',fcGreater,IncDay(D,-1));
  end;

  with FFilterMenuItemArchive do begin
    Group3:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group3) then
      FilterGroups.Remove(Group3);
    Group3:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group3.Filters.Add('DATE_CREATE',fcEqualLess,IncDay(D,-1));
  end;

  with Provider do begin
    Group4:=FilterGroups.Find(FGroupDirection);
    if Assigned(Group4) then
      FilterGroups.Remove(Group4);

    Group4:=FilterGroups.AddByName(FGroupDirection,foAnd,false);
    case FViewMode of
      vmFull: ;
      vmIncoming: Group4.Filters.Add('DIRECTION',fcEqual,0);
      vmOutgoing: Group4.Filters.Add('DIRECTION',fcEqual,1);
    end;
  end;

  inherited OpenRecords;
end;

function TBisTaxiDataCallsFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

function TBisTaxiDataCallsFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    if Provider.Active and not Provider.Empty then
      if not VarIsNull(Core.FirmId) then
        Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
  end;
end;

procedure TBisTaxiDataCallsFrame.GridGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                                                   Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data: PBisDBTreeNodeData;
  Direction: Integer;
  Index: Integer;
begin
  Data:=Grid.GetNodeData(Node);
  if Assigned(Data) then begin
    if (Column=1) then begin
      Index:=Grid.GetValueIndex('DIRECTION');
      if Index<>-1 then begin
        Direction:=VarToIntDef(Data.Values[Index],0);
        if not Boolean(Direction) then
          ImageIndex:=16
        else
          ImageIndex:=17;
      end;
    end;
  end;
end;

procedure TBisTaxiDataCallsFrame.SetViewMode(const Value: TBisTaxiDataCallViewMode);
begin
  FViewMode:=Value;
  case FViewMode of
    vmFull: begin
      Grid.OnGetImageIndex:=GridGetImageIndex;
      Provider.FieldNames.Find('DATE_CREATE').Width:=130;
    end;
    vmIncoming: begin
      Grid.OnGetImageIndex:=nil;
      Provider.FieldNames.Find('DATE_CREATE').Width:=110;
    end;
    vmOutgoing: begin
      Grid.OnGetImageIndex:=nil;
      Provider.FieldNames.Find('DATE_CREATE').Width:=110;
    end;
  end;
end;


end.