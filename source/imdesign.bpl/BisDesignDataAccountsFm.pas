unit BisDesignDataAccountsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                         
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataGridFm, BisFm, BisDataGridFrm, BisDataFrm;

type
  TBisDesignDataAccountsFrame=class(TBisDataGridFrame)
  private
    FSLocked: String;
    FSActive: String;
    FActiveMenuItem: TBisDataFrameFilterMenuItem;
    FLockedMenuItem: TBisDataFrameFilterMenuItem;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
  published
    property SActive: String read FSActive write FSActive;
    property SLocked: String read FSLocked write FSLocked;
  end;

  TBisDesignDataAccountsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisDesignDataAccountsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiDesignDataAccountsForm: TBisDesignDataAccountsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataAccountEditFm;

{ TBisDesignDataAccountsFrame }

constructor TBisDesignDataAccountsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FilterClass:=TBisDesignDataAccountEditFormIface;
  InsertClass:=TBisDesignDataAccountInsertFormIface;
  UpdateClass:=TBisDesignDataAccountUpdateFormIface;
  DeleteClass:=TBisDesignDataAccountDeleteFormIface;
  with Provider do begin
    ProviderName:='S_ACCOUNTS';
    with FieldNames do begin
      AddKey('ACCOUNT_ID');
      AddInvisible('FIRM_ID');
      AddInvisible('FIRM_SMALL_NAME');
      AddInvisible('DATE_CREATE');
      AddInvisible('PASSWORD');
      AddInvisible('DESCRIPTION');
      AddInvisible('DB_USER_NAME');
      AddInvisible('DB_PASSWORD');
      AddInvisible('IS_ROLE');
      AddInvisible('LOCKED');
      AddInvisible('AUTO_CREATED');
      AddInvisible('EMAIL');
      AddInvisible('JOB_TITLE');
      AddInvisible('PHONE_INTERNAL');
      AddInvisible('DATE_LOCK');
      AddInvisible('REASON_LOCK');
      Add('USER_NAME','�����',100);
      Add('SURNAME','�������',120);
      Add('NAME','���',100);
      Add('PATRONYMIC','��������',120);
      Add('PHONE','�������',80);
    end;
    FilterGroups.Add.Filters.Add('IS_ROLE',fcEqual,0);
  end;

  FSActive:='��������';
  FSLocked:='����������������';

  FActiveMenuItem:=CreateFilterMenuItem(FSActive);
  with FActiveMenuItem do begin
    FilterGroups.AddVisible.Filters.Add('LOCKED',fcNotEqual,1);
    Checked:=true;
  end;

  FLockedMenuItem:=CreateFilterMenuItem(FSLocked);
  with FLockedMenuItem do begin
    FilterGroups.AddVisible.Filters.Add('LOCKED',fcEqual,1);
  end;

end;

procedure TBisDesignDataAccountsFrame.Init;
begin
  inherited Init;
  FActiveMenuItem.Caption:=FSActive;
  FLockedMenuItem.Caption:=FSLocked;
end;

{ TBisDesignDataAccountsFormIface }

constructor TBisDesignDataAccountsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataAccountsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisDesignDataAccountsForm }

constructor TBisDesignDataAccountsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisDesignDataAccountsForm.Destroy;
begin
  inherited Destroy;
end;

class function TBisDesignDataAccountsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataAccountsFrame;
end;

end.
