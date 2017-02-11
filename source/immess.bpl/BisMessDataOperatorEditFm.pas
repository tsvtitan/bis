unit BisMessDataOperatorEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;
                                                                                                       
type
  TBisMessDataOperatorEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxEnabled: TCheckBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    MemoConversions: TMemo;
    MemoRanges: TMemo;
    LabelConversions: TLabel;
    LabelRanges: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisMessDataOperatorEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOperatorFilterFormIface=class(TBisMessDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOperatorInsertFormIface=class(TBisMessDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOperatorUpdateFormIface=class(TBisMessDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOperatorDeleteFormIface=class(TBisMessDataOperatorEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataOperatorEditForm: TBisMessDataOperatorEditForm;

implementation

{$R *.dfm}

{ TBisMessDataOperatorEditFormIface }

constructor TBisMessDataOperatorEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataOperatorEditForm;
  with Params do begin
    AddKey('OPERATOR_ID').Older('OLD_OPERATOR_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddCheckBox('ENABLED','CheckBoxEnabled');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddMemo('CONVERSIONS','MemoConversions','LabelConversions');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddMemo('RANGES','MemoRanges','LabelRanges',true);
  end;
end;

{ TBisMessDataOperatorFilterFormIface }

constructor TBisMessDataOperatorFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр операторов связи';
end;

{ TBisMessDataOperatorInsertFormIface }

constructor TBisMessDataOperatorInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_OPERATOR';
  Caption:='Создать оператора связи';
end;

{ TBisMessDataOperatorUpdateFormIface }

constructor TBisMessDataOperatorUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OPERATOR';
  Caption:='Изменить оператора связи';
end;

{ TBisMessDataOperatorDeleteFormIface }

constructor TBisMessDataOperatorDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OPERATOR';
  Caption:='Удалить оператора связи';
end;

end.
