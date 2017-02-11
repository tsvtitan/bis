unit BisMessDataRolesAndAccountsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  VirtualTrees, VirtualDBTreeEx,
  BisFm, BisDataFrm, BisDataTreeFm, BisDataTreeFrm, BisDataGridFm;

type
  TBisMessDataRolesAndAccountsFrame=class(TBisDataTreeFrame)
  private
    FSWithOutRole: String;
    procedure TreeClick(Sender: TObject);
    procedure FillProvider;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;
    procedure Init; override;

  published  
    property SWithOutRole: String read FSWithOutRole write FSWithOutRole;
  end;

  TBisMessDataRolesAndAccountsForm = class(TBisDataTreeForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataRolesAndAccountsFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataRolesAndAccountsForm: TBisMessDataRolesAndAccountsForm;

implementation

uses BisFilterGroups, BisOrders, BisProvider, BisUtils, BisDialogs;

{$R *.dfm}

{ TBisMessDataRolesAndAccountsFrame }

constructor TBisMessDataRolesAndAccountsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with Provider.FieldDefs do begin
    Add('ID',ftString,32);
    Add('PARENT_ID',ftString,32);
    Add('ACCOUNT_ID',ftString,32);
    Add('USER_NAME',ftString,100);
  end;

  with Provider.FieldNames do begin
    AddKey('ID');
    AddParentKey('PARENT_ID');
    AddInvisible('ACCOUNT_ID');
    Add('USER_NAME','������������',300);
  end;
  Provider.CreateTable;

  ActionView.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;
  ActionDelete.Visible:=false;

  FSWithOutRole:='���� �� ����������';

  Tree.OnClick:=TreeClick;
end;

procedure TBisMessDataRolesAndAccountsFrame.FillProvider;
var
  P1: TBisProvider;
  P2: TBisProvider;
  P3: TBisProvider;
  RoleId: Variant;
  ParentId: Variant;
begin
  P1:=TBisProvider.Create(nil);
  P2:=TBisProvider.Create(nil);
  P3:=TBisProvider.Create(nil);
  try
    P1.ProviderName:='S_ACCOUNTS';
    with P1.FieldNames do begin
      AddInvisible('ACCOUNT_ID');
      AddInvisible('USER_NAME');
    end;
    P1.FilterGroups.Add.Filters.Add('IS_ROLE',fcEqual,1);
    P1.Orders.Add('USER_NAME');

    P2.ProviderName:='S_ACCOUNTS';
    with P2.FieldNames do begin
      AddInvisible('ACCOUNT_ID');
      AddInvisible('USER_NAME');
    end;
    with P2.FilterGroups do begin
      Add.Filters.Add('IS_ROLE',fcEqual,0);
      Add.Filters.Add('LOCKED',fcNotEqual,1);
    end;
    P2.Orders.Add('USER_NAME');

    P3.ProviderName:='S_ACCOUNT_ROLES';
    with P3.FieldNames do begin
      AddInvisible('ROLE_ID');
      AddInvisible('ACCOUNT_ID');
      AddInvisible('USER_NAME');
    end;

    P1.Open;
    P2.Open;
    P3.Open;
    if P1.Active and P2.Active and P3.Active then begin
      Provider.BeginUpdate;
      try
        Provider.EmptyTable;
        P1.First;
        while not P1.Eof do begin

          RoleId:=P1.FieldByName('ACCOUNT_ID').Value;
          ParentId:=GetUniqueID;

          Provider.Append;
          Provider.FieldByName('ID').Value:=ParentId;
          Provider.FieldByName('ACCOUNT_ID').Value:=RoleId;
          Provider.FieldByName('PARENT_ID').Value:=Null;
          Provider.FieldByName('USER_NAME').Value:=P1.FieldByName('USER_NAME').Value;
          Provider.Post;

          P3.Filter:=FormatEx('ROLE_ID=%s',[QuotedStr(VarToStrDef(RoleId,''))]);
          P3.Filtered:=true;
          P3.First;
          while not P3.Eof do begin

            if P2.Locate('ACCOUNT_ID',P3.FieldByName('ACCOUNT_ID').Value,[loCaseInsensitive]) then begin
              Provider.Append;
              Provider.FieldByName('ID').Value:=GetUniqueID;
              Provider.FieldByName('ACCOUNT_ID').Value:=P3.FieldByName('ACCOUNT_ID').Value;
              Provider.FieldByName('PARENT_ID').Value:=ParentId;
              Provider.FieldByName('USER_NAME').Value:=P3.FieldByName('USER_NAME').Value;
              Provider.Post;
            end;

            P3.Next;
          end;

          P1.Next;
        end;

        ParentId:=GetUniqueID;

        Provider.Append;
        Provider.FieldByName('ID').Value:=ParentId;
        Provider.FieldByName('ACCOUNT_ID').Value:=Null;
        Provider.FieldByName('PARENT_ID').Value:=Null;
        Provider.FieldByName('USER_NAME').Value:=FSWithOutRole;
        Provider.Post;

        P3.Filter:='';
        P3.Filtered:=false;

        P2.First;
        while not P2.Eof do begin

          if not P3.Locate('ACCOUNT_ID',P2.FieldByName('ACCOUNT_ID').Value,[loCaseInsensitive]) then begin

            Provider.Append;
            Provider.FieldByName('ID').Value:=GetUniqueID;
            Provider.FieldByName('ACCOUNT_ID').Value:=P2.FieldByName('ACCOUNT_ID').Value;
            Provider.FieldByName('PARENT_ID').Value:=ParentId;
            Provider.FieldByName('USER_NAME').Value:=P2.FieldByName('USER_NAME').Value;
            Provider.Post;
            
          end;

          P2.Next;
        end;

        Provider.First;
      finally
        Provider.EndUpdate;
      end;
    end;
  finally
    P3.Free;
    P2.Free;
    P1.Free;
  end;
end;

procedure TBisMessDataRolesAndAccountsFrame.Init;
begin
  inherited Init;
end;

procedure TBisMessDataRolesAndAccountsFrame.OpenRecords;
begin
  inherited OpenRecords;
  FillProvider;
  DoUpdateCounters;
end;

procedure TBisMessDataRolesAndAccountsFrame.TreeClick(Sender: TObject);
begin
end;

{ TBisMessDataAccountsFormIface }

constructor TBisMessDataRolesAndAccountsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataRolesAndAccountsForm;
  Permissions.Enabled:=true;
//  Available:=true;
  ChangeFrameProperties:=false;
end;

{ TBisMessDataRolesAndAccountsForm }

constructor TBisMessDataRolesAndAccountsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

class function TBisMessDataRolesAndAccountsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisMessDataRolesAndAccountsFrame;
end;

end.