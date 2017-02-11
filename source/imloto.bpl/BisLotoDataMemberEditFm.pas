unit BisLotoDataMemberEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisLotoDataMemberEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelWorkPlace: TLabel;
    EditWorkPlace: TEdit;
    EditSurname: TEdit;
    LabelSurname: TLabel;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelWorkPosition: TLabel;
    EditWorkPosition: TEdit;
  private
  public
  end;

  TBisLotoDataMemberEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataMemberFilterFormIface=class(TBisLotoDataMemberEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataMemberInsertFormIface=class(TBisLotoDataMemberEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataMemberUpdateFormIface=class(TBisLotoDataMemberEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisLotoDataMemberDeleteFormIface=class(TBisLotoDataMemberEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisLotoDataMemberEditForm: TBisLotoDataMemberEditForm;

implementation

uses
     BisUtils, BisLotoConsts, 
     BisValues;

{$R *.dfm}

{ TBisLotoDataMemberEditFormIface }

constructor TBisLotoDataMemberEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisLotoDataMemberEditForm;
  with Params do begin
    AddKey('MEMBER_ID').Older('OLD_MEMBER_ID');
    AddEdit('SURNAME','EditSurName','LabelSurName',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic',true);
    AddEdit('WORK_PLACE','EditWorkPlace','LabelWorkPlace');
    AddEdit('WORK_POSITION','EditWorkPosition','LabelWorkPosition');
  end;
end;

{ TBisLotoDataMemberFilterFormIface }

constructor TBisLotoDataMemberFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр членов комиссии';
end;

{ TBisLotoDataMemberInsertFormIface }

constructor TBisLotoDataMemberInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MEMBER';
  Caption:='Создать члена комиссии';
end;

{ TBisLotoDataMemberUpdateFormIface }

constructor TBisLotoDataMemberUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MEMBER';
  Caption:='Изменить члена комиссии';
end;

{ TBisLotoDataMemberDeleteFormIface }

constructor TBisLotoDataMemberDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_MEMBER';
  Caption:='Удалить члена комиссии';
end;


end.
