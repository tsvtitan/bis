unit BisCallDataCallResultEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisControls;

type
  TBisCallDataCallResultEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxVisible: TCheckBox;                                                                       
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallDataCallResultEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallResultFilterFormIface=class(TBisCallDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallResultInsertFormIface=class(TBisCallDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallResultUpdateFormIface=class(TBisCallDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataCallResultDeleteFormIface=class(TBisCallDataCallResultEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallDataCallResultEditForm: TBisCallDataCallResultEditForm;

implementation

{$R *.dfm}

{ TBisCallDataCallResultEditFormIface }

constructor TBisCallDataCallResultEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallDataCallResultEditForm;
  with Params do begin
    AddKey('CALL_RESULT_ID').Older('OLD_CALL_RESULT_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddCheckBox('VISIBLE','CheckBoxVisible');
  end;
end;

{ TBisCallDataCallResultFilterFormIface }

constructor TBisCallDataCallResultFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Фильтр результатов вызова';
end;

{ TBisCallDataCallResultInsertFormIface }

constructor TBisCallDataCallResultInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CALL_RESULT';
  Caption:='Создать результат вызова';
end;

{ TBisCallDataCallResultUpdateFormIface }

constructor TBisCallDataCallResultUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CALL_RESULT';
  Caption:='Изменить результат вызова';
end;

{ TBisCallDataCallResultDeleteFormIface }

constructor TBisCallDataCallResultDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CALL_RESULT';
  Caption:='Удалить результат вызова';
end;

end.
