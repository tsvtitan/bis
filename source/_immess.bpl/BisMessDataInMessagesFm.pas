unit BisMessDataInMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList, DB,
  BisDataFrm, BisDataGridFrm, BisDataGridFm, BisFieldNames;

type
  TBisMessDataInMessagesFrame=class(TBisDataGridFrame)
  private
    FGroupToday: String;
    FGroupArchive: String;
    FSToday: String;
    FSArchive: String;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure OpenRecords; override;

    property FilterMenuItemToday: TBisDataFrameFilterMenuItem read FFilterMenuItemToday;
    property FilterMenuItemArchive: TBisDataFrameFilterMenuItem read FFilterMenuItemArchive;

  published
    property SToday: String read FSToday write FSToday;
    property SArchive: String read FSArchive write FSArchive;   
  end;

  TBisMessDataInMessagesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisMessDataInMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataInMessagesForm: TBisMessDataInMessagesForm;

implementation

{$R *.dfm}

uses DateUtils,
     BisUtils, BisConsts, BisVariants, BisOrders, BisCore, BisFilterGroups,
     BisMessDataInMessageEditFm, BisMessDataInMessageFilterFm{, BisLeak};

{ TBisMessDataInMessagesFrame }

constructor TBisMessDataInMessagesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FilterClass:=TBisMessDataInMessageFilterFormIface;
  InsertClass:=TBisMessDataInMessageInsertFormIface;
  UpdateClass:=TBisMessDataInMessageUpdateFormIface;
  DeleteClass:=TBisMessDataInMessageDeleteFormIface;
  with Provider do begin
    ProviderName:='S_IN_MESSAGES';
    with FieldNames do begin
      AddKey('IN_MESSAGE_ID');
      AddInvisible('SENDER_ID');
      AddInvisible('SENDER_NAME');
      AddInvisible('CODE_MESSAGE_ID');
      AddInvisible('CODE');
      AddInvisible('TYPE_MESSAGE');
      Add('DATE_IN','���� ���������',110);
      Add('TEXT_IN','����� ���������',210);
      Add('DATE_SEND','���� ��������',110);
      Add('CONTACT','�������',100);
    end;
    Orders.Add('DATE_IN',otDesc);
  end;

  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;

  FSToday:='�� �����';
  FSArchive:='�����';

  FFilterMenuItemToday:=CreateFilterMenuItem(FSToday);
  FFilterMenuItemToday.Checked:=true;

  FFilterMenuItemArchive:=CreateFilterMenuItem(FSArchive);

end;

procedure TBisMessDataInMessagesFrame.Init;
begin
  inherited Init;
  FFilterMenuItemToday.Caption:=FSToday;
  FFilterMenuItemArchive.Caption:=FSArchive;
end;

procedure TBisMessDataInMessagesFrame.OpenRecords;
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
    Group1.Filters.Add('DATE_IN',fcGreater,IncDay(D,-1));
    Group1.Filters.Add('DATE_IN',fcEqualLess,D);
  end;

  with FFilterMenuItemArchive do begin
    Group2:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group2.Filters.Add('DATE_IN',fcEqualLess,IncDay(D,-1));
  end;

  inherited OpenRecords;
end;

{ TBisMessDataInMessagesFormIface }

constructor TBisMessDataInMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataInMessagesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisMessDataInMessagesForm }

constructor TBisMessDataInMessagesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisMessDataInMessagesForm.Destroy;
begin
  inherited Destroy;
end;

class function TBisMessDataInMessagesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisMessDataInMessagesFrame;
end;

end.
