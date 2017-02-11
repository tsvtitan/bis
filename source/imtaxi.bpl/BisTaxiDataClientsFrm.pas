unit BisTaxiDataClientsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids,
  VirtualTrees,
  BisDataSet, BisFieldNames, BisFilterGroups,
  BisDBTree, BisFm, BisDataFrm, BisDataTreeFrm, BisDataEditFm;

type
  TBisTaxiDataClientsFrame = class(TBisDataTreeFrame)
    ActionMessages: TAction;
    N1: TMenuItem;
    MenuItemMessages: TMenuItem;
    procedure ActionMessagesExecute(Sender: TObject);
    procedure ActionMessagesUpdate(Sender: TObject);
  private
//    function GetNewName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    procedure TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                var Ghosted: Boolean; var ImageIndex: Integer);
    function CanMessages: Boolean;
    procedure Messages;
  protected
    procedure PrepareFilterGroups(FilterGroups: TBisFilterGroups); override;
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
    function GetCurrentDuplicateClass: TBisDataEditFormIfaceClass; override;
    function GetCurrentUpdateClass: TBisDataEditFormIfaceClass; override;
    function GetCurrentDeleteClass: TBisDataEditFormIfaceClass; override;
    function GetCurrentViewClass: TBisDataEditFormIfaceClass; override;
  public
    function CanSelect: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;
  end;

implementation

uses BisUtils, BisProvider, BisParam,
     BisMessDataOutMessageInsertExFm,
     BisTaxiDataClientEditFm, BisTaxiDataClientGroupEditFm,
     BisTaxiDataOutMessageEditFm;

{$R *.dfm}

type
  TBisTaxiDataClientsOutMessagesFormIface=class(TBisTaxiDataOutMessageInsertExFormIface)
  private
    FFrame: TBisTaxiDataClientsFrame;
  protected
    function CreateForm: TBisForm; override;
  public

    property Frame: TBisTaxiDataClientsFrame read FFrame write FFrame;
  end;


{ TBisTaxiDataClientsOutMessagesFormIface }

function TBisTaxiDataClientsOutMessagesFormIface.CreateForm: TBisForm;
var
  Form: TBisMessDataOutMessageInsertExForm;
  ParentId: Variant;
  Phone: String;
  OldCursor: TCursor;
begin
  Result:=inherited CreateForm;
  if Assigned(FFrame) and Assigned(Result) and (Result is TBisMessDataOutMessageInsertExForm) then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    FFrame.Provider.BeginUpdate(true);
    try
      Form:=TBisMessDataOutMessageInsertExForm(Result);
      Form.WithLocked:=false;
      FFrame.Provider.First;
      while not FFrame.Provider.Eof do begin
        ParentId:=FFrame.Provider.FieldByName('PARENT_ID').Value;
        if not VarIsNull(ParentId) then begin
          Phone:=FFrame.Provider.FieldByName('PHONE').AsString;
          if Trim(Phone)<>'' then begin
            Form.AddRecipient(FFrame.Provider.FieldByName('NEW_NAME').AsString,
                              FFrame.Provider.FieldByName('SURNAME').AsString,
                              FFrame.Provider.FieldByName('NAME').AsString,
                              FFrame.Provider.FieldByName('PATRONYMIC').AsString,
                              Phone,
                              FFrame.Provider.FieldByName('ID').Value,
                              False);
          end;
        end;
        FFrame.Provider.Next;
      end;
    finally
      FFrame.Provider.EndUpdate;
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

{ TBisTaxiDataClientsFrame }

constructor TBisTaxiDataClientsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisTaxiDataClientFilterFormIface;
  ViewClass:=TBisTaxiDataClientViewFormIface;
  InsertClasses.Add(TBisTaxiDataClientInsertFormIface);
  InsertClasses.Add(TBisTaxiDataClientGroupInsertFormIface);
  UpdateClass:=TBisTaxiDataClientUpdateFormIface;
  DeleteClass:=TBisTaxiDataClientDeleteFormIface;

  with Provider do begin
    ProviderName:='S_GROUPS_CLIENTS';
    with FieldNames do begin
      AddKey('ID');

      AddInvisible('PARENT_NAME');
      AddInvisible('DESCRIPTION');
      AddInvisible('PRIORITY');
      AddInvisible('LOCKED');

      AddInvisible('PASSWORD');
      AddInvisible('LOCALITY_ID');
      AddInvisible('LOCALITY_PREFIX');
      AddInvisible('LOCALITY_NAME');
      AddInvisible('STREET_PREFIX');
      AddInvisible('STREET_NAME');
      AddInvisible('FIRM_ID');
      AddInvisible('FIRM_SMALL_NAME');
      AddInvisible('JOB_TITLE');
      AddInvisible('METHOD_ID');
      AddInvisible('METHOD_NAME');
      AddInvisible('STREET_ID');
      AddInvisible('HOUSE');
      AddInvisible('FLAT');
      AddInvisible('PORCH');
      AddInvisible('INDEX');
      AddInvisible('ADDRESS_DESC');
      AddInvisible('SOURCE_ID');
      AddInvisible('SOURCE_NAME');
      AddInvisible('DATE_BIRTH');
      AddInvisible('PLACE_BIRTH');
      AddInvisible('PASSPORT');
      AddInvisible('SEX');
      AddInvisible('CALC_ID');
      AddInvisible('CALC_NAME');
      AddInvisible('MIN_BALANCE');
      AddInvisible('DATE_CREATE');
      AddInvisible('DATE_LOCK');
      AddInvisible('REASON_LOCK');

     // AddCalculate('NEW_NAME','������ / �����',GetNewName,ftString,100,170);

      Add('NEW_NAME','������ / �����',170);

      Add('PHONE','�������',80);
      Add('SURNAME','�������',100);
      Add('NAME','���',100);
      Add('PATRONYMIC','��������',100);

      Add('IS_GROUP','���',0).Visible:=false;
      with AddParentKey('PARENT_ID') do begin
        Caption:='�� ��������';
        Visible:=false;
      end;
    end;
  end;

  with CreateFilterMenuItem('��������') do begin
    with FilterGroups.AddVisible.Filters do begin
      Add('LOCKED',fcEqual,0);
    end;
    Checked:=true;
  end;

  with CreateFilterMenuItem('���������������') do begin
    with FilterGroups.AddVisible.Filters do begin
      Add('LOCKED',fcEqual,1);
    end;
  end;

  Tree.OnGetImageIndex:=TreeGetImageIndex;
end;

function TBisTaxiDataClientsFrame.GetCurrentDuplicateClass: TBisDataEditFormIfaceClass;
var
  IsGroup: Boolean;
begin
  Result:=inherited GetCurrentDuplicateClass;
  if Provider.Active and not Provider.Empty then begin
    IsGroup:=Boolean(Provider.FieldByName('IS_GROUP').AsInteger);
    if not IsGroup then
      Result:=TBisTaxiDataClientInsertFormIface
    else
      Result:=TBisTaxiDataClientGroupInsertFormIface;
  end;
end;

function TBisTaxiDataClientsFrame.GetCurrentUpdateClass: TBisDataEditFormIfaceClass;
var
  IsGroup: Boolean;
begin
  Result:=inherited GetCurrentUpdateClass;
  if Provider.Active and not Provider.Empty then begin
    IsGroup:=Boolean(Provider.FieldByName('IS_GROUP').AsInteger);
    if not IsGroup then
      Result:=TBisTaxiDataClientUpdateFormIface
    else
      Result:=TBisTaxiDataClientGroupUpdateFormIface;
  end;
end;

function TBisTaxiDataClientsFrame.GetCurrentDeleteClass: TBisDataEditFormIfaceClass;
var
  IsGroup: Boolean;
begin
  Result:=inherited GetCurrentDeleteClass;
  if Provider.Active and not Provider.Empty then begin
    IsGroup:=Boolean(Provider.FieldByName('IS_GROUP').AsInteger);
    if not IsGroup then
      Result:=TBisTaxiDataClientDeleteFormIface
    else
      Result:=TBisTaxiDataClientGroupDeleteFormIface;
  end;
end;

function TBisTaxiDataClientsFrame.GetCurrentViewClass: TBisDataEditFormIfaceClass;
var
  IsGroup: Boolean;
begin
  Result:=inherited GetCurrentViewClass;
  if Provider.Active and not Provider.Empty then begin
    IsGroup:=Boolean(Provider.FieldByName('IS_GROUP').AsInteger);
    if not IsGroup then
      Result:=TBisTaxiDataClientViewFormIface
    else
      Result:=TBisTaxiDataClientGroupViewFormIface;
  end;
end;

{function TBisTaxiDataClientsFrame.GetNewName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  IsGroup: Boolean;
begin
  Result:=Null;
  if DataSet.Active then begin
    IsGroup:=Boolean(DataSet.FieldByName('IS_GROUP').AsInteger);
    if not IsGroup then
      Result:=DataSet.FieldByName('USER_NAME').Value
    else
      Result:=DataSet.FieldByName('NAME').Value;
  end;
end;
}

procedure TBisTaxiDataClientsFrame.PrepareFilterGroups(FilterGroups: TBisFilterGroups);
var
  i,j: Integer;
  Group: TBisFilterGroup;
  Filter: TBisFilter;
begin
  if Assigned(FilterGroups) then begin
    for i:=0 to FilterGroups.Count-1 do begin
      Group:=FilterGroups.Items[i];
      for j:=Group.Filters.Count-1 downto 0 do begin
        Filter:=Group.Filters.Items[j];
        if AnsiSameText(Filter.FieldName,'LOCKED') and
           (Filter.Condition=fcIsNull) and
            VarIsNull(Filter.Value) then
          Group.Filters.Remove(Filter);
      end;
      Group.Filters.Add('LOCKED',fcIsNull,Null).&Operator:=foOr;
    end;
  end;
end;

procedure TBisTaxiDataClientsFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

function TBisTaxiDataClientsFrame.CanSelect: Boolean;
begin
  Result:=inherited CanSelect;
  if Result then begin
    Result:=Provider.Active and not Provider.Empty;
    if Result then
      Result:=not Boolean(Provider.FieldByName('IS_GROUP').AsInteger);
  end;
end;

procedure TBisTaxiDataClientsFrame.ActionMessagesExecute(Sender: TObject);
begin
  Messages;
end;

procedure TBisTaxiDataClientsFrame.ActionMessagesUpdate(Sender: TObject);
begin
  ActionMessages.Enabled:=CanMessages;
end;

procedure TBisTaxiDataClientsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  IsGroup: Boolean;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    if AIface is TBisTaxiDataClientEditFormIface then begin
      with AIface.Params do begin
        ParamByName('CLIENT_ID').Duplicates.Clear;
        ParamByName('CLIENT_ID').Duplicates.Add('ID');
        ParamByName('USER_NAME').Duplicates.Clear;
        ParamByName('USER_NAME').Duplicates.Add('NEW_NAME');
        ParamByName('CLIENT_GROUP_ID').Duplicates.Clear;
        ParamByName('CLIENT_GROUP_ID').Duplicates.Add('PARENT_ID');
        ParamByName('CLIENT_GROUP_NAME').Duplicates.Clear;
        ParamByName('CLIENT_GROUP_NAME').Duplicates.Add('PARENT_NAME');
        if AIface.Mode=emInsert then begin
          IsGroup:=Boolean(Provider.FieldByName('IS_GROUP').AsInteger);
          if IsGroup then begin
            ParamByName('CLIENT_GROUP_ID').SetNewValue(Provider.FieldByName('ID').Value);
            ParamByName('CLIENT_GROUP_NAME').SetNewValue(Provider.FieldByName('NEW_NAME').Value);
          end;
        end;
        AddInvisible('IS_GROUP',ptUnknown).Value:=0;
      end;
    end;
    if AIface is TBisTaxiDataClientGroupEditFormIface then begin
      with AIface.Params do begin
        ParamByName('CLIENT_GROUP_ID').Duplicates.Clear;
        ParamByName('CLIENT_GROUP_ID').Duplicates.Add('ID');
        ParamByName('NAME').Duplicates.Clear;
        ParamByName('NAME').Duplicates.Add('NEW_NAME');
        AddInvisible('IS_GROUP',ptUnknown).Value:=1;
      end;
    end;
  end;
end;

procedure TBisTaxiDataClientsFrame.TreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                                                     Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  IsGroup: Boolean;
begin
  if (Column=1) then begin
    IsGroup:=Boolean(VarToIntDef(Tree.GetNodeValue(Node,'IS_GROUP'),1));
    if IsGroup then begin
      ImageIndex:=16;
      if vsExpanded in Node.States then
        ImageIndex:=17;
    end else
      ImageIndex:=18;
  end;
end;

function TBisTaxiDataClientsFrame.CanMessages: Boolean;
var
  AIface: TBisTaxiDataOutMessageInsertExFormIface;
begin
  Result:=Provider.Active and not Provider.Empty; 
  if Result then begin
    AIface:=TBisTaxiDataOutMessageInsertExFormIface.Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataClientsFrame.Messages;
var
  AIface: TBisTaxiDataClientsOutMessagesFormIface;
begin
  if CanMessages then begin
    AIface:=TBisTaxiDataClientsOutMessagesFormIface.Create(nil);
    try
      AIface.Init;
      AIface.Permissions.Enabled:=false;
      AIface.ShowType:=ShowType;
      AIface.Frame:=Self;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;


end.
