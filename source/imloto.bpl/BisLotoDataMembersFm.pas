unit BisLotoDataMembersFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataGridFm;

type
  TBisLotoDataMembersForm = class(TBisDataGridForm)
  public
    constructor Create(AOwner: TComponent); override;

  end;

  TBisLotoDataMembersFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoDataMembersForm: TBisLotoDataMembersForm;

implementation

{$R *.dfm}

uses BisUtils, BisLotoDataMemberEditFm, BisConsts, BisFilterGroups;

{ TBisLotoDataMembersFormIface }

constructor TBisLotoDataMembersFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoDataMembersForm;
  FilterClass:=TBisLotoDataMemberFilterFormIface;
  InsertClass:=TBisLotoDataMemberInsertFormIface;
  UpdateClass:=TBisLotoDataMemberUpdateFormIface;
  DeleteClass:=TBisLotoDataMemberDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_MEMBERS';
  with FieldNames do begin
    AddKey('MEMBER_ID');
    AddInvisible('WORK_PLACE');
    Add('SURNAME','Фамилия',120);
    Add('NAME','Имя',100);
    Add('PATRONYMIC','Отчество',120);
    Add('WORK_POSITION','Должность',110);
  end;
  Orders.Add('SURNAME');
  Orders.Add('NAME');
  Orders.Add('PATRONYMIC');
end;

{ TBisLotoDataMembersForm }

constructor TBisLotoDataMembersForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
